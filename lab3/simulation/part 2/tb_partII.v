module lzd (
    
    output reg [3:0] z,
    input [3:0] i

    );

    always @ (i)
        begin
            
            z[3] = 1'b0;
            z[2] = (~i[3] * ~i[2] * ~i[1] * ~i[0]);
            z[1] = (~i[3] * ~i[2] * i[0] | ~i[3] * ~i[2] * i[1]);
            z[0] = (~i[3] * i[2] | ~i[3] * ~i[1] * i[0]);

        end

endmodule

module tb_partII;

    reg [7:0] i8;      
    wire [3:0] z8;     

    lzd8b lzd8b0 (
        .i8(i8),
        .z8(z8)
    );

    integer j;

    initial begin
        
        for (j = 0; j < 10; j = j + 1) begin
            i8 = $random;
            
            #10;   
           
            $display("Input: %b, Leading Zeros: %0d", i8, z8);
       
       end

    end

endmodule


