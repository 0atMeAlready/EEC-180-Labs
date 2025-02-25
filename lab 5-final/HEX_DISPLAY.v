`ifndef HEX_DISPLAY_V
`define HEX_DISPLAY_V

module HEX_DISPLAY(
    input [3:0] WIRE_IN, 
    output reg [6:0] HEX
); 


always @(WIRE_IN) begin
    case(WIRE_IN)
        4'h0: HEX = 7'b1000000;  // 0 
        4'h1: HEX = 7'b1111001;  // 1 
        4'h2: HEX = 7'b0100100;  // 2 
        4'h3: HEX = 7'b0110000;  // 3 
        4'h4: HEX = 7'b0011001;  // 4 
        4'h5: HEX = 7'b0010010;  // 5 
        4'h6: HEX = 7'b0000010;  // 6 
        4'h7: HEX = 7'b1111000;  // 7 
        4'h8: HEX = 7'b0000000;  // 8 
        4'h9: HEX = 7'b0010000;  // 9 
        4'hA: HEX = 7'b0001000;  // A 
        4'hB: HEX = 7'b0000011;  // b 
        4'hC: HEX = 7'b1000110;  // C 
        4'hD: HEX = 7'b0100001;  // d 
        4'hE: HEX = 7'b0000110;  // E 
        4'hF: HEX = 7'b0001110;  // F 
        default: HEX = 7'b1111111; // Default (off) 
    endcase
	end

endmodule

`endif
