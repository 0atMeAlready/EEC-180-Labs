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

module testbench;
    
    reg [3:0] i;
    wire [3:0] z;         

    // Instantiate the design under test (DUT)
    lzd lzd0 (
        
        .i(i),
        .z(z)

    );

    integer j;

    initial begin

        // Iterate through all possible combinations of A and B
        for (j = 0; j < 16; j = j + 1) begin
                
		i [3:0] = j; // Assign values to A

            #10; // Wait 10 time units for results to stabilize

        $display("input = %b, number of leading zeroes = %b | %d", i, z, z);

        end

    end
endmodule


