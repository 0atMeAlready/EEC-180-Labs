module mux2x1 (
    input signed [18:0] a, b,
    input sel,
    output signed [18:0] muxout
);

assign muxout = sel ? b : a;

endmodule

module MAC (
    input signed [7:0] inA, inB,    // Signed inputs
    input macc_clear, clk, start,
    output reg signed [18:0] out,
    output reg done
);

    wire signed [18:0] mult_out;
    wire signed [18:0] add_out;
    wire signed [18:0] mux_out;

    // Signed multiplication for two's complement support
    assign mult_out = inA * inB;
    assign add_out = mult_out + out;

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
    input signed [(WIDTH*64)-1:0] data_in,  // Signed data input
    output reg signed [(WIDTH*64)-1:0] data_out
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
    reg signed [7:0] matA [0:63];
    reg signed [7:0] matB [0:63];
    reg signed [511:0] data_inA;
    reg signed [511:0] data_inB;
    reg signed [(19*64)-1:0] data_out;
    reg macc_clear, clk, rst, start;
    wire done0, done1;  // Done signals for MAC units
    wire signed [18:0] mac_out0, mac_out1;
    reg signed [18:0] result_matrix [0:63];
    reg signed [18:0] matrixC [0:63];
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

    // Instantiate two parallel MAC units
    MAC MAC0 (
        .inA(data_inA[7:0]),
        .inB(data_inB[7:0]),
        .macc_clear(macc_clear),
        .clk(clk),
        .start(start),
        .out(mac_out0),
        .done(done0)
    );

    MAC MAC1 (
        .inA(data_inA[15:8]),
        .inB(data_inB[15:8]),
        .macc_clear(macc_clear),
        .clk(clk),
        .start(start),
        .out(mac_out1),
        .done(done1)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        macc_clear = 1;
        rst = 1;
        start = 0;
        clock_count = 0;

        // Load matrices (signed values for two's complement)
        $readmemb("ram_a_init.txt", matA);
        $readmemb("ram_b_init.txt", matB);

        #10;
        rst = 0;
        macc_clear = 0;

        // Compute expected result in matrixC
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                matrixC[i * 8 + j] = 0;
                for (k = 0; k < 8; k = k + 1) begin
                    matrixC[i * 8 + j] = matrixC[i * 8 + j] + matA[k * 8 + i] * matB[j * 8 + k];
                end
            end
        end

        // Start signal assertion
        #10;
        start = 1;

        // Perform matrix multiplication using parallel MACs
        for (j = 0; j < 8; j = j + 1) begin
            for (i = 0; i < 8; i = i + 2) begin
                result_matrix[i * 8 + j] = 0;
                result_matrix[(i + 1) * 8 + j] = 0;

                for (k = 0; k < 8; k = k + 1) begin
                    // Load data for MAC0 and MAC1
                    data_inA[7:0] = matA[k * 8 + i];
                    data_inB[7:0] = matB[j * 8 + k];

                    data_inA[15:8] = matA[k * 8 + (i + 1)];
                    data_inB[15:8] = matB[j * 8 + k];

                    // Clear MACs before starting multiplication
                    macc_clear = 1;
                    #10;
                    macc_clear = 0;

                    // Wait for MAC units to finish
                    #10;
                    result_matrix[i * 8 + j] = result_matrix[i * 8 + j] + mac_out0;
                    result_matrix[(i + 1) * 8 + j] = result_matrix[(i + 1) * 8 + j] + mac_out1;

                    // Increment clock count
                    clock_count = clock_count + 1;
                end
            end
        end

        // Check if MACs are done
        if (done0 && done1) begin
            $display("Status of MACs: MAC0 = %d, MAC1 = %d, [1 = done with calculations]", done0, done1);
        end

        // Display results
        $display("\nExpected Result:");
        for (i = 0; i < 8; i = i + 1) begin
            $display(matrixC[i * 8], matrixC[i * 8 + 1], matrixC[i * 8 + 2], matrixC[i * 8 + 3],
                     matrixC[i * 8 + 4], matrixC[i * 8 + 5], matrixC[i * 8 + 6], matrixC[i * 8 + 7]);
        end

        $display("\nGenerated Result:");
        for (i = 0; i < 8; i = i + 1) begin
            $display(result_matrix[i * 8], result_matrix[i * 8 + 1], result_matrix[i * 8 + 2], result_matrix[i * 8 + 3],
                     result_matrix[i * 8 + 4], result_matrix[i * 8 + 5], result_matrix[i * 8 + 6], result_matrix[i * 8 + 7]);
        end

        $display("\nTotal Clock Cycles: %d", clock_count);

        #10;
        macc_clear = 1;
        #10;

        $finish;
    end

endmodule
