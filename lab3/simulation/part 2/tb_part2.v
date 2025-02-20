module lzd (
    output reg [2:0] z, 
    input [3:0] i     
);

    always @(*) begin
        z[2] = (~i[3] & ~i[2] & ~i[1] & ~i[0]);
        z[1] = (~i[3] & ~i[2] & i[0]) | (~i[3] & ~i[2] & i[1]);
        z[0] = (~i[3] & i[2]) | (~i[3] & ~i[1] & i[0]);
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
            
            z8 = z_upper + z_lower;

        end 
        
        else begin
            
            z8 = z_upper;
        end

        //check for edge case
        if (i8 == 8'b00000000) begin
            z8 = 4'b1000;
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
        
        for (j = 0; j < 256; j = j + 1) begin
            i8 = j;
            
            #10;   
           
            $display("Input: %b, Leading Zeros: %0d", i8, z8);
       
       end

    end

endmodule
