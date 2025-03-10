`include "C:/Users/dzyzhang/EEC180/lab 5/synthesis/supplement files/RAM_8BIT.v"
`include "C:/Users/dzyzhang/EEC180/lab 5/synthesis/supplement files/SQRT.v"
`include "C:/Users/dzyzhang/EEC180/lab 5/synthesis/supplement files/HEX_DISPLAY.v"
//`include "C:/Users/dzyzhang/EEC180/lab 5/synthesis/supplement files/CTRL.v"


//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module partII(

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

//initial in
wire St, CLK, RST;
wire Done;
wire[7:0] Addr;
wire [7:0] N;
wire [7:0] MDO;
reg Enable;

wire[3:0] sqrt;

//basics 
assign St = SW[0];
//assign CLK = SW[1];
assign CLK = KEY[1];
assign RST = KEY[0];
assign N = SW[8:1];

//=======================================================
//  Structural coding
//=======================================================

RAM Number(.Addr(Addr), .MDI(N), .Write_Enable(St), .CLK(CLK), .MDO(MDO));
SquareRoot Calc(.CLK(CLK), .RST(RST), .St(St), .MDI(N), .Done(Done), .Sqrt(sqrt));


HEX_DISPLAY H0(sqrt[3:0],HEX0);
HEX_DISPLAY H1(N[3:0], HEX1);
HEX_DISPLAY H2(N[7:4], HEX2);
assign LEDR0 = Done;
assign HEX3 = 8'b11111111;
assign HEX4 = 8'b11111111;
assign HEX5 = 8'b11111111;


endmodule
