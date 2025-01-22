`ifndef DEC_7SEG_DECODER_V
`define DEC_7SEG_DECODER_V

module dec_7seg_decoder
(
    input [7:0] SW,
    output [7:0] HEX0,
    output [7:0] HEX1,
	output [7:0] HEX2,
	output [7:0] HEX3,
	output [7:0] HEX4,
	output [7:0] HEX5,
	output [7:0] HEX6,
	output [7:0] HEX7,
);

// HEX displays 0-9
assign HEX0[0] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX0[1] = (~SW[3] & SW[2] & ~SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX0[2] = (SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & SW[1] & ~SW[0]);
assign HEX0[3] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX0[4] = (SW[0]) | (SW[3] & SW[2] & SW[1]) | (~SW[3] & SW[2] & ~SW[1]);
assign HEX0[5] = (SW[3] & SW[2] & ~SW[1]) | (~SW[3] & ~SW[2] & SW[0]) | (~SW[3] & SW[1] & SW[0]) | (~SW[3] & ~SW[2] & SW[1]) | (~SW[2] & SW[1] & SW[0]);
assign HEX0[6] = (~SW[3] & ~SW[2] & ~SW[1]) | (SW[3] & ~SW[2] & SW[1]) | (~SW[3] & SW[2] & SW[1] & SW[0]);

assign HEX1[0] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX1[1] = (~SW[3] & SW[2] & ~SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX1[2] = (SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & SW[1] & ~SW[0]);
assign HEX1[3] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX1[4] = (SW[0]) | (SW[3] & SW[2] & SW[1]) | (~SW[3] & SW[2] & ~SW[1]);
assign HEX1[5] = (SW[3] & SW[2] & ~SW[1]) | (~SW[3] & ~SW[2] & SW[0]) | (~SW[3] & SW[1] & SW[0]) | (~SW[3] & ~SW[2] & SW[1]) | (~SW[2] & SW[1] & SW[0]);
assign HEX1[6] = (~SW[3] & ~SW[2] & ~SW[1]) | (SW[3] & ~SW[2] & SW[1]) | (~SW[3] & SW[2] & SW[1] & SW[0]);

assign HEX2[0] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX2[1] = (~SW[3] & SW[2] & ~SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX2[2] = (SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & SW[1] & ~SW[0]);
assign HEX2[3] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX2[4] = (SW[0]) | (SW[3] & SW[2] & SW[1]) | (~SW[3] & SW[2] & ~SW[1]);
assign HEX2[5] = (SW[3] & SW[2] & ~SW[1]) | (~SW[3] & ~SW[2] & SW[0]) | (~SW[3] & SW[1] & SW[0]) | (~SW[3] & ~SW[2] & SW[1]) | (~SW[2] & SW[1] & SW[0]);
assign HEX2[6] = (~SW[3] & ~SW[2] & ~SW[1]) | (SW[3] & ~SW[2] & SW[1]) | (~SW[3] & SW[2] & SW[1] & SW[0]);

assign HEX3[0] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX3[1] = (~SW[3] & SW[2] & ~SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX3[2] = (SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & SW[1] & ~SW[0]);
assign HEX3[3] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX3[4] = (SW[0]) | (SW[3] & SW[2] & SW[1]) | (~SW[3] & SW[2] & ~SW[1]);
assign HEX3[5] = (SW[3] & SW[2] & ~SW[1]) | (~SW[3] & ~SW[2] & SW[0]) | (~SW[3] & SW[1] & SW[0]) | (~SW[3] & ~SW[2] & SW[1]) | (~SW[2] & SW[1] & SW[0]);
assign HEX3[6] = (~SW[3] & ~SW[2] & ~SW[1]) | (SW[3] & ~SW[2] & SW[1]) | (~SW[3] & SW[2] & SW[1] & SW[0]);

assign HEX4[0] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX4[1] = (~SW[3] & SW[2] & ~SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX4[2] = (SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & SW[1] & ~SW[0]);
assign HEX4[3] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX4[4] = (SW[0]) | (SW[3] & SW[2] & SW[1]) | (~SW[3] & SW[2] & ~SW[1]);
assign HEX4[5] = (SW[3] & SW[2] & ~SW[1]) | (~SW[3] & ~SW[2] & SW[0]) | (~SW[3] & SW[1] & SW[0]) | (~SW[3] & ~SW[2] & SW[1]) | (~SW[2] & SW[1] & SW[0]);
assign HEX4[6] = (~SW[3] & ~SW[2] & ~SW[1]) | (SW[3] & ~SW[2] & SW[1]) | (~SW[3] & SW[2] & SW[1] & SW[0]);

assign HEX5[0] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX5[1] = (~SW[3] & SW[2] & ~SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX5[2] = (SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & SW[1] & ~SW[0]);
assign HEX5[3] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX5[4] = (SW[0]) | (SW[3] & SW[2] & SW[1]) | (~SW[3] & SW[2] & ~SW[1]);
assign HEX5[5] = (SW[3] & SW[2] & ~SW[1]) | (~SW[3] & ~SW[2] & SW[0]) | (~SW[3] & SW[1] & SW[0]) | (~SW[3] & ~SW[2] & SW[1]) | (~SW[2] & SW[1] & SW[0]);
assign HEX5[6] = (~SW[3] & ~SW[2] & ~SW[1]) | (SW[3] & ~SW[2] & SW[1]) | (~SW[3] & SW[2] & SW[1] & SW[0]);

assign HEX6[0] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX6[1] = (~SW[3] & SW[2] & ~SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX6[2] = (SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & SW[1] & ~SW[0]);
assign HEX6[3] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX6[4] = (SW[0]) | (SW[3] & SW[2] & SW[1]) | (~SW[3] & SW[2] & ~SW[1]);
assign HEX6[5] = (SW[3] & SW[2] & ~SW[1]) | (~SW[3] & ~SW[2] & SW[0]) | (~SW[3] & SW[1] & SW[0]) | (~SW[3] & ~SW[2] & SW[1]) | (~SW[2] & SW[1] & SW[0]);
assign HEX6[6] = (~SW[3] & ~SW[2] & ~SW[1]) | (SW[3] & ~SW[2] & SW[1]) | (~SW[3] & SW[2] & SW[1] & SW[0]);

assign HEX7[0] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX7[1] = (~SW[3] & SW[2] & ~SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX7[2] = (SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & SW[1] & ~SW[0]);
assign HEX7[3] = (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (~SW[3] & SW[2] & SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]) | (SW[3] & SW[2] & SW[1] & ~SW[0]);
assign HEX7[4] = (SW[0]) | (SW[3] & SW[2] & SW[1]) | (~SW[3] & SW[2] & ~SW[1]);
assign HEX7[5] = (SW[3] & SW[2] & ~SW[1]) | (~SW[3] & ~SW[2] & SW[0]) | (~SW[3] & SW[1] & SW[0]) | (~SW[3] & ~SW[2] & SW[1]) | (~SW[2] & SW[1] & SW[0]);
assign HEX7[6] = (~SW[3] & ~SW[2] & ~SW[1]) | (SW[3] & ~SW[2] & SW[1]) | (~SW[3] & SW[2] & SW[1] & SW[0]);
endmodule

`endif
