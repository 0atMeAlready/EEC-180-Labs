module FA(

	input A, B, Cin,
	output S, Cout
	
	);
	
	assign S = A ^ B ^ Cin;
	assign Cout = (A & B) | (A & Cin) | (B & Cin);
	
endmodule

module multiplier(

	input [3:0] A, B,
	output [7:0] P
	
	);
	
	wire [4:0] carry1;
	wire [4:0] carry2;
	wire [4:0] carry3;
	wire [11:0] in1;
	wire [11:0] in2;
	wire [11:0] S;
	
	//all the b[0] stuff
	
	assign P[0] = A[0] & B[0];
	assign in1[0] = A[1] & B[0];
	assign in1[1] = A[2] & B[0];
	assign in1[2] = A[3] & B[0];
	
	//all the b[1] stuff
	
	assign carry1[0] = 0;
	assign in2[0] = A[0] & B[1];
	assign in2[1] = A[1] & B[1];
	assign in2[2] = A[2] & B[1];
	assign in2[3] = A[3] & B[1];
	
	FA FA0 (.A(in1[0]), .B(in2[0]), .Cin(carry1[0]), .S(P[1]), .Cout(carry1[1]));
	FA FA1 (.A(in1[1]), .B(in2[1]), .Cin(carry1[1]), .S(in1[4]), .Cout(carry1[2]));
	FA FA2 (.A(in1[2]), .B(in2[2]), .Cin(carry1[2]), .S(in1[5]), .Cout(carry1[3]));
	FA FA3 (.A(0), .B(in2[3]), .Cin(carry1[3]), .S(in1[6]), .Cout(carry1[4]));
	
	//all the b[2] stuff
	
	assign carry2[0] = 0;
	assign in1[7] = carry1[4];
	assign in2[4] = S[1] & B[2];
	assign in2[5] = S[2] & B[2];
	assign in2[6] = S[3] & B[2];
	assign in2[7] = A[3] & B[2];

	FA FA4 (.A(in1[4]), .B(in2[4]), .Cin(carry2[0]), .S(P[2]), .Cout(carry2[1]));
	FA FA5 (.A(in1[5]), .B(in2[5]), .Cin(carry2[1]), .S(in1[8]), .Cout(carry2[2]));
	FA FA6 (.A(in1[6]), .B(in2[6]), .Cin(carry2[2]), .S(in1[9]), .Cout(carry2[3]));
	FA FA7 (.A(in1[7]), .B(in2[7]), .Cin(carry2[3]), .S(in1[10]), .Cout(carry2[4]));
	
	//all the b[3] stuff
	
	assign carry3[0] = 0;
	assign in1[11] = carry2[4];
	assign in2[8] = S[4] & B[3];
	assign in2[9] = S[5] & B[3];
	assign in2[10] = S[6] & B[3];
	assign in2[11] = A[3] & B[3];

	FA FA8 (.A(in1[8]), .B(in2[8]), .Cin(carry3[0]), .S(P[3]), .Cout(carry3[1]));
	FA FA9 (.A(in1[9]), .B(in2[9]), .Cin(carry3[1]), .S(P[4]), .Cout(carry3[2]));
	FA FA10 (.A(in1[10]), .B(in2[10]), .Cin(carry3[2]), .S(P[5]), .Cout(carry3[3]));
	FA FA11 (.A(in1[11]), .B(in2[11]), .Cin(carry3[3]), .S(P[6]), .Cout(carry3[4]));
	
	assign P[7] = carry3[4];
	
endmodule