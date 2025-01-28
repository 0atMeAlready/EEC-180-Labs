module lzd (
    output reg [2:0] z, // 3-bit output to represent leading zero count
    input [3:0] i      // 4-bit input
);

    always @(*) begin
        if (i == 4'b0000) begin
            z = 3'd4; // All zeros -> 4 leading zeros
        end else if (i[3] == 0) begin
            if (i[2] == 0) begin
                if (i[1] == 0) begin
                    z = 3'd3; // 000x -> 3 leading zeros
                end else begin
                    z = 3'd2; // 00x1 -> 2 leading zeros
                end
            end else begin
                z = 3'd1; // 0x11 -> 1 leading zero
            end
        end else begin
            z = 3'd0; // 1xxx -> no leading zeros
        end
    end

endmodule

module lzd8b (
    output reg [3:0] z8,  // 4-bit result: number of leading zeros in the 8-bit input
    input [7:0] i8        // 8-bit input
);

    // Wires to hold outputs from the 4-bit LZD modules
    wire [2:0] z_upper, z_lower;

    // Instantiate the two 4-bit LZD modules
    lzd lzd_upper (
        .z(z_upper),
        .i(i8[7:4]) // Process the upper 4 bits
    );

    lzd lzd_lower (
        .z(z_lower),
        .i(i8[3:0]) // Process the lower 4 bits
    );

    // Combine outputs
    always @(*) begin
        if (z_upper == 3'd4) begin
            // If the upper 4 bits are all zero, add zeros from both halves
            z8 = z_upper + z_lower;
        end else begin
            // Otherwise, only consider the upper half
            z8 = z_upper;
        end

        // Special case for all zeros
        if (i8 == 8'b00000000) begin
            z8 = 4'd8; // Set 8 leading zeros for all-zero input
        end
    end

endmodule

module testbench;

    reg [7:0] i8;      // 8-bit input for testing
    wire [3:0] z8;     // 4-bit output for the number of leading zeros

    // Instantiate the DUT (Design Under Test)
    lzd8b dut (
        .i8(i8),
        .z8(z8)
    );

    integer j;

    initial begin
        // Test 50 random 8-bit inputs
        for (j = 0; j < 50; j = j + 1) begin
            i8 = $random; // Generate a random 8-bit value
            #10;          // Wait for output to stabilize
            $display("Input: %b, Leading Zeros: %0d", i8, z8); // Display the input and the result
        end
    end

endmodule
