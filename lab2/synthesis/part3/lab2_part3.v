
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module lab2_part3(
);



//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================



endmodule

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
	
	input [N-1:0] A, B,	// N-bit inputs
	input Cin,         	// Single-bit global carry-in
	output [N-1:0] S,  	// N-bit sum output
	output Cout        	// Single-bit carry-out
	
);

	genvar i;
	
	wire [N:0] carry; // Create a carry chain with N+1 bits

	assign carry[0] = Cin; // Assign global carry-in to the first carry bit

	generate
    	
		for (i = 0; i < N; i = i + 1) begin : rippleAdder_generation
       
		 // Instantiate full adders for each bit
        	
			fullAdder fA (
            	.A(A[i]),
            	.B(B[i]),
            	.Cin(carry[i]),   // Carry-in from the previous stage
            	.S(S[i]),     	// Sum for this bit
            	.Cout(carry[i+1]) // Carry-out for this stage
        	
			);
    	
		end
	
	endgenerate

	assign Cout = carry[N]; // Assign the final carry-out

endmodule
