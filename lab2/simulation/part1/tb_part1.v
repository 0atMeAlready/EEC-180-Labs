module fullAdder(

	input [8:0] A, 
	input [8:0] B, 
	input [1:0] Cin,
	output [8:0] S, 
	output [1:0] Cout

);

	assign S = A ^ B ^ Cin;
	assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule

module tb;
wire [8:0] S;
wire Cout;
reg [8:0] test;
// design under test;
fullAdder FA (S, Cout, test[1], test[0]);
// stimulus and verification that the output is correct
initial begin
for (test = 0; test < 65536; test = test + 1)
begin
#10;
if ({Cout, S} != (test[1] + test[0]) )
$display("ERROR: a=%b b=%b sum=%b cout=%b", test[1], test[0], S, Cout);
end
#10 $finish;
end
endmodule
