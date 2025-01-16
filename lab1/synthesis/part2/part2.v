
//=======================================================
//  This code is ge~erated by Terasic System Builder
//=======================================================

module part2(

	//////////// SEG7 //////////
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW

);



//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================

assign HEX0[0] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX0[1] = (~SW[3] & SW[2] & ~SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX0[2] = (SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & SW[1] & ~SW[0]);
assign HEX0[3] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX0[4] = (SW[0]) | (SW[3] & SW[2] & SW[1]) | (~SW[3] & SW[2] & ~SW[1]);
assign HEX0[5] = (SW[3] & SW[2] & ~SW[1]) | (~SW[3] & ~SW[2] & SW[0]) | (~SW[3] & SW[1] & SW[0]) | (~SW[3] & ~SW[2] & SW[1]) | (~SW[2] & SW[1] & SW[0]);
assign HEX0[6] = (~SW[3] & ~SW[2] & ~SW[1]) | (SW[3] & ~SW[2] & SW[1]) | (~SW[3] & SW[2] & SW[1] & SW[0]);

assign HEX1[0] = (SW[3] & SW[2]) | (SW[3] & SW[1]);
assign HEX1[1] = 0;
assign HEX1[2] = 0;
assign HEX1[3] = (SW[3] & SW[2]) | (SW[3] & SW[1]);
assign HEX1[4] = (SW[3] & SW[2]) | (SW[3] & SW[1]);
assign HEX1[5] = (SW[3] & SW[2]) | (SW[3] & SW[1]);
assign HEX1[6] = 1;

endmodule
