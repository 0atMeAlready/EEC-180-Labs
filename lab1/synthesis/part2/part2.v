`include "C:/Users/Justin/Documents/School/2024-2025/Winter Quarter/EEC 180/EEC-180-Labs/lab1/hdl/7 segment decoder.v"

module part2(

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
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

	// Declare wires for connecting to the decoder module
	wire [6:0] hex_decoder_out0; // Output from HEX0 of decoder
	wire [6:0] hex_decoder_out1; // Output from HEX1 of decoder

	//=======================================================
	//  Structural coding
	//=======================================================


	dec_7seg_decoder u_decoder (
		.SW(SW[3:0]),          
		.HEX0(hex_decoder_out0),
		.HEX1(hex_decoder_out1)
	);

	assign HEX0 = hex_decoder_out0;
	assign HEX1 = hex_decoder_out1;

	assign HEX2 = 8'b11111111;
	assign HEX3 = 8'b11111111;
	assign HEX4 = 8'b11111111;
	assign HEX5 = 8'b11111111;


endmodule
