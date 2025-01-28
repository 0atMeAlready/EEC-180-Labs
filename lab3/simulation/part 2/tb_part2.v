module lzd (
    output reg [2:0] z, // 3-bit output to represent leading zero count
    input [3:0] i      // 4-bit input
);

    always @(*) begin
        z[2] = (~i[3] & ~i[2] & ~i[1] & ~i[0]); // All bits are 0
        z[1] = (~i[3] & ~i[2] & i[0]) | (~i[3] & ~i[2] & i[1]); // Position 2 or 1
        z[0] = (~i[3] & i[2]) | (~i[3] & ~i[1] & i[0]); // Position 3 or 2
    end

endmodule

module lzd8b (

    output reg [3:0] z8,  
    input [7:0] i8        

);

    wire [2:0] z_upper, z_lower;

    lzd lzd_upper (
        .z(z_upper),
        .i(i8[7:4])
    );

    lzd lzd_lower (
        .z(z_lower),
        .i(i8[3:0])
    );

    // Combine outputs
    always @(*) begin
        if (z_upper == 3'd4) begin
            
            // If the upper 4 bits are all zero, add zeros from both halves
            z8 = z_upper + z_lower;

        end 
        
        else begin
            
            z8 = z_upper;
        end

        // Special case for all zeros
        if (i8 == 8'b00000000) begin
            z8 = 4'b0000; // Set 8 leading zeros for all-zero input
        end
    end

endmodule

module testbench;

    reg [7:0] i8;      
    wire [3:0] z8;     

    lzd8b lzd8b0 (
        .i8(i8),
        .z8(z8)
    );

    integer j;

    initial begin
        
        for (j = 0; j < 10; j = j + 1) begin
            i8 = $random; // Generate a random 8-bit value
            
            #10;          // Wait for output to stabilize
           
            $display("Input: %b, Leading Zeros: %0d", i8, z8);
       
       end

    end

endmodule
