module tb_partII;

    reg [7:0] i8;      
    wire [3:0] z8;     

    lzd8b lzd8b0 (
        .i8(i8),
        .z8(z8)
    );

    integer j;

    initial begin
        
        i8 = 8'b00000000;

        for (j = 0; j < 10; j = j + 1) begin
            i8 = $random;
            
            #10;   
           
            $display("Input: %b, Leading Zeros: %d", i8, z8);
       
       end

    end

endmodule


