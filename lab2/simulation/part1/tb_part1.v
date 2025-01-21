module testbench;
    reg [7:0] A, B;
    reg Cin;
    wire [7:0] S;
    wire [7:0] Cout;
    wire [8:0] add;

    // Instantiate the design under test (DUT)
    rippleAdder RA (
	
	A,
	B,
	Cin,
	S,
	Cout

    );

    assign add = {Cout[7], S};

    integer i, j;

    initial begin
        // Monitor for debugging
        $monitor("Time=%0t | A=%b B=%b Cin=%b S=%b Cout=%b", $time, A, B, Cin, S, Cout);

        // Test cases
            for (j = 0; j < 65536; j = j + 1) begin
                A = j[7:0];
                B = j[7:0];
                Cin = 1'b0;

                #10; // Wait 10 time units for results to stabilize

                // Check result
                if ({S} !== (A + B + Cin)) begin
                    $display("ERROR: A=%b B=%b Cin=%b S=%b Cout=%b (Expected %b)", 
                              A, B, Cin, S, Cout, A + B + Cin);
                end
        end

        $finish; // End simulation
    end
endmodule


