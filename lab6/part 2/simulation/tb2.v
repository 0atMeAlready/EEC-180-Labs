module mux2x1 (
    input [18:0] a, b,
    input sel,
    output [18:0] muxout
);

assign muxout = sel ? b : a;

endmodule

module MAC (
    input [7:0] inA, inB,
    input macc_clear, clk,
    output reg [18:0] out
);

    wire [18:0] mult_out;
    wire [18:0] add_out;
    wire [18:0] mux_out;

assign mult_out = inA * inB;
assign add_out = mult_out + out;

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
    reg [511:0] data_inA;
    reg [511:0] data_inB;
    reg [(19*64)-1:0] data_out;
    reg macc_clear, clk, rst;
    reg [7:0] matA [7:0][7:0];
    reg [7:0] matB [7:0][7:0];
    wire [18:0] mac_out;
    reg [18:0] result_matrix [7:0][7:0];
    integer i, j, k;

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

    MAC uut (
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

        // Initialize matrices
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                matA[i][j] = i + 1;
                matB[i][j] = j + 2;
            end
        end

        #10;
        rst = 0;
        macc_clear = 0;

        // Perform matrix multiplication
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                result_matrix[i][j] = 0; // Reset the result matrix

                // Perform matrix multiplication for row i of matA and column j of matB
                for (k = 0; k < 8; k = k + 1) begin
                    // Set the current values for multiplication
                    data_inA = matA[i][k]; // Element from row i, column k of matA
                    data_inB = matB[k][j]; // Element from row k, column j of matB

                    // Clear MAC before starting multiplication
                    macc_clear = 1;
                    #10; // Wait for one clock cycle to clear the MAC
                    macc_clear = 0;  // Disable clearing of MAC

                    #10; // Wait for MAC to process the multiplication
                    // Accumulate the result once the multiplication is done

                    result_matrix[i][j] = result_matrix[i][j] + mac_out;

                end

                $display("result_matrix[%0d][%0d] = %0d", i, j, result_matrix[i][j]);

            end
        end

        #10;
        macc_clear = 1;
        #10;

        $finish;
    end

endmodule
