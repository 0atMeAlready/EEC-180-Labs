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