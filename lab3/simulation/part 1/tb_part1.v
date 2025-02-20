module testbench;
    
    reg [3:0] i;
    wire [3:0] z;         

    lzd lzd0 (
        
        .i(i),
        .z(z)

    );

    integer j;

    initial begin

        for (j = 0; j < 16; j = j + 1) begin
                
		i [3:0] = j;

            #10;

        $display("input = %b, number of leading zeroes = %b | %d", i, z, z);

        end

    end
endmodule


