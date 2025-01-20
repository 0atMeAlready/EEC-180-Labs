module fullAdder(

	input A, 
	input B, 
	input Cin,
	output S, 
	output Cout

);

	assign S = A ^ B ^ Cin;
	assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule

module rippleAdder
    #(parameter N = 8)
(
    input [N-1:0] A, B,    // N-bit inputs
    input Cin,             // Single-bit global carry-in
    output [N-1:0] S,      // N-bit sum output
    output [N-1:0] Cout            // Single-bit carry-out
);

    genvar i;

    fullAdder fA(A[0], B[0], Cin, S[0], Cout[0]);

    generate
        for (i = 0; i < N; i = i + 1) begin : rippleAdder_generation
            // Instantiate full adders for each bit
            fullAdder fA (
                A[i],
                B[i],
                Cout[i-1],   // Carry-in from the previous stage
                S[i],     // Sum for this bit
                Cout[i] // Carry-out for this stage
            );
        end
    endgenerate

endmodule


module testbench;
    reg [7:0] A, B;
    reg Cin;
    wire [7:0] S;
    wire [7:0] Cout;

    // Instantiate the design under test (DUT)
    rippleAdder #(.N(8)) RA (
	
	A,
	B,
	Cin,
	S,
	Cout

    );

    integer i, j;

    initial begin
        // Monitor for debugging
        $monitor("Time=%0t | A=%b B=%b Cin=%b S=%b Cout=%b", $time, A, B, Cin, S, Cout);

	A = 8'b00000000;
	B = 8'b00000000;
	Cin = 1'b0;

        // Test cases
        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 256; j = j + 1) begin
                A = i[7:0];
                B = j[7:0];
                Cin = 1'b0;

                #10; // Wait 10 time units for results to stabilize

                // Check result
                if ({Cout, S} !== (A + B + Cin)) begin
                    $display("ERROR: A=%b B=%b Cin=%b S=%b Cout=%b (Expected %b)", 
                              A, B, Cin, S, Cout, A + B + Cin);
                end
            end
        end

        $finish; // End simulation
    end
endmodule

