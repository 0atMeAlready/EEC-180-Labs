`timescale 1ns/10ps

module mux2x1 (
    input signed [18:0] a, b,
    input sel,
    output signed [18:0] muxout
);

assign muxout = sel ? b : a;

endmodule

module MAC (
    input signed [7:0] inA, inB,   // Input as signed 8-bit values
    input macc_clear, clk, start,
    output reg signed [18:0] out,  // Output as signed 19-bit value
    output reg done
);

    wire signed [18:0] mult_out;
    wire signed [18:0] add_out;
    wire signed [18:0] mux_out;

    assign mult_out = inA * inB;    // Signed multiplication
    assign add_out = mult_out + out; // Accumulate previous result

    mux2x1 mux0 (.a(add_out), .b(mult_out), .sel(macc_clear), .muxout(mux_out));

    always @(posedge clk) begin
        if (macc_clear) begin
            out <= 0;
            done <= 0;
        end else if (start) begin
            out <= mux_out;
            done <= 1;  // Signal done when computation is completed
        end else begin
            done <= 0;
        end
    end

endmodule

module matrix_RAM #(parameter WIDTH = 19) (
    input clk,
    input rst,
    input [(WIDTH*64)-1:0] data_in,  // Flattened 8x8 matrix
    output reg [(WIDTH*64)-1:0] data_out
);

always @(posedge clk) begin
    if (rst) begin
        data_out <= 0;
    end else begin
        data_out <= data_in;
    end
end

endmodule

module matrix_tb;

    // Testbench signals
    reg signed [7:0] matA [0:7][0:7];  // 8x8 matrix, each element is signed 8-bit
    reg signed [7:0] matB [0:7][0:7];  // 8x8 matrix, each element is signed 8-bit
    reg [511:0] data_inA;
    reg [511:0] data_inB;
    reg [(19*64)-1:0] data_out;
    reg macc_clear, clk, rst, start;
    wire signed [18:0] mac_out;         // Signed 19-bit output from MAC
    wire done;                          // MAC done signal
    reg signed [18:0] result_matrix [0:7][0:7]; // 8x8 result matrix
    reg signed [18:0] matrixC [0:7][0:7]; // Expected results
    integer i, j, k;
    integer clock_count;

    // Instantiate RAM modules
    matrix_RAM #(.WIDTH(8)) RAM0 (
        .clk(clk),
        .rst(rst),
        .data_in(data_inA),
        .data_out()
    );

    matrix_RAM #(.WIDTH(8)) RAM1 (
        .clk(clk),
        .rst(rst),
        .data_in(data_inB),
        .data_out()
    );

    matrix_RAM #(.WIDTH(19)) RAM2 (
        .clk(clk),
        .rst(rst),
        .data_in(data_out),
        .data_out()
    );

    // Instantiate MAC module
    MAC MAC0 (
        .inA(data_inA[7:0]),
        .inB(data_inB[7:0]),
        .macc_clear(macc_clear),
        .clk(clk),
        .start(start),
        .out(mac_out),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        macc_clear = 1;
        rst = 1;
        start = 0;
        clock_count = 0;

        // Read matrices from files in column-major order
        $readmemb("ram_a_init.txt", matA); 
        $readmemb("ram_b_init.txt", matB); 

        #10;
        rst = 0;
        macc_clear = 0;

        // Compute expected result in matrixC
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                matrixC[i][j] = 0;  // Initialize expected result
                for (k = 0; k < 8; k = k + 1) begin
                    matrixC[i][j] = matrixC[i][j] + matA[k][i] * matB[j][k];
                end
            end
        end

        // Perform matrix multiplication
        for (j = 0; j < 8; j = j + 1) begin 
            for (i = 0; i < 8; i = i + 1) begin
                result_matrix[i][j] = 0;

                for (k = 0; k < 8; k = k + 1) begin
                    // Load values from matrices
                    data_inA = matA[k][i]; 
                    data_inB = matB[j][k]; 

                    // Clear MAC before starting
                    macc_clear = 1;
                    #10; 
                    macc_clear = 0;

                    // Start MAC computation
                    start = 1;
                    #10;
                    start = 0;

                    // Wait for MAC to signal done
                    wait (done);

                    // Accumulate result
                    result_matrix[i][j] = result_matrix[i][j] + mac_out;

                    // Increment clock count
                    clock_count = clock_count + 1;
                end
            end
        end

        // Print Expected and Actual Results
        $display("\nExpected Result:");
        for (i = 0; i < 8; i = i + 1) begin
            $display(matrixC[i][0], matrixC[i][1], matrixC[i][2], matrixC[i][3],
                     matrixC[i][4], matrixC[i][5], matrixC[i][6], matrixC[i][7]);
        end
        
        $display("\nGenerated Result:");
        for (i = 0; i < 8; i = i + 1) begin
            $display(result_matrix[i][0], result_matrix[i][1], result_matrix[i][2], result_matrix[i][3],
                     result_matrix[i][4], result_matrix[i][5], result_matrix[i][6], result_matrix[i][7]);
        end

        $display("\nTotal Clock Cycles: %d", clock_count);

        // Check if MACs are done
        if (done == 1) begin
            $display("Status of MACs: MAC0 = %d, [1 = done with calculations]", done);
        end

        #10;
        macc_clear = 1;
        #10;

        $finish;
    end

endmodule