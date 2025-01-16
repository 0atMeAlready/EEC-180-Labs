module fullAdder(

	reg [8:0] A, 
	reg [8:0] B, 
	reg [1:0] Cin,
	wire [8:0] S, 
	wire [1:0] Cout

);

	assign S = A ^ B ^ Cin;
	assign Cout = (A & B) | (A & Cin) | (B & Cin);

reg [8:0] A, B;
// design under test;
fullAdder UUT (.S(S), .Cout(Cout), .A(A), .B(B), .Cin(Cin));
// stimulus and verification that the output is correct
initial begin
	for (A = 0; A < 65536; A = A + 1)
		for (B = 0; B < 65536; B = B + 1)
			begin
				#10;
					if ({Cout, S} != (A[0] + B[0]) )
						$display("ERROR: a=%b b=%b sum=%b cout=%b", A[1], B[0], S, Cout);
					end
					#10 $finish;
	end
end

endmodule
