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
    input macc_clear, clk,
    output reg signed [18:0] out   // Output as signed 19-bit value
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
        end else begin
            out <= mux_out;
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
    reg macc_clear, clk, rst;
    wire signed [18:0] mac_out;         // Signed 19-bit output from MAC
    reg signed [18:0] result_matrix [0:7][0:7]; // 8x8 result matrix, each element is signed 19 bits
    reg signed [18:0] matrixC [0:7][0:7]; // Store expected results (fix this to use matrixC)
    integer i, j, k;
    integer clock_count;

    // Instantiate the MAC module and RAM modules (No changes here)
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

    MAC MAC0 (
        .inA(data_inA[7:0]),
        .inB(data_inB[7:0]),
        .macc_clear(macc_clear),
        .clk(clk),
        .out(mac_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        macc_clear = 1;
        rst = 1;
        clock_count = 0;

        // Read matrices from files in column-major order
        $readmemb("ram_a_init.txt", matA); // Assuming the matrix is stored column-major in the file
        $readmemb("ram_b_init.txt", matB); // Assuming the matrix is stored column-major in the file

        #10;
        rst = 0;
        macc_clear = 0;

        // Compute expected result in matrixC
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                matrixC[i][j] = 0;  // Initialize the expected result matrix
                for (k = 0; k < 8; k = k + 1) begin
                    matrixC[i][j] = matrixC[i][j] + matA[k][i] * matB[j][k]; // Column-major order multiplication
                end
            end
        end

        // Perform matrix multiplication (modified for column-major access)
        for (j = 0; j < 8; j = j + 1) begin // Iterate over columns for column-major order
            for (i = 0; i < 8; i = i + 1) begin
                result_matrix[i][j] = 0; // Reset the result matrix

                // Perform matrix multiplication for row i of matA and column j of matB
                for (k = 0; k < 8; k = k + 1) begin
                    // Set the current values for multiplication from column-major order
                    data_inA = matA[k][i]; // Element from column k, row i of matA (swapped index for column-major)
                    data_inB = matB[j][k]; // Element from row k, column j of matB

                    // Clear MAC before starting multiplication
                    macc_clear = 1;
                    #10; // Wait for one clock cycle to clear the MAC
                    macc_clear = 0;  // Disable clearing of MAC

                    #10; // Wait for MAC to process the multiplication
                    // Accumulate the result once the multiplication is done
                    result_matrix[i][j] = result_matrix[i][j] + mac_out;

                    // Increment clock count
                    clock_count = clock_count + 1;
                end
            end
        end

        // Print Expected and Actual Results in the Lab Manual Format
        // Expected matrix printed from matrixC
        $display("\nExpected Result:");
        for (i = 0; i < 8; i = i + 1) begin
            $display(matrixC[i][0], matrixC[i][1], matrixC[i][2], matrixC[i][3],
                     matrixC[i][4], matrixC[i][5], matrixC[i][6], matrixC[i][7]);
        end
        
        // Print the Generated Result from RAM
        $display("\nGenerated Result:");
        for (i = 0; i < 8; i = i + 1) begin
            $display(result_matrix[i][0], result_matrix[i][1], result_matrix[i][2], result_matrix[i][3],
                     result_matrix[i][4], result_matrix[i][5], result_matrix[i][6], result_matrix[i][7]);
        end

        // Display the number of clock cycles
        $display("\nTotal Clock Cycles: %d", clock_count);

        #10;
        macc_clear = 1;
        #10;

        $finish;
    end

endmodule
