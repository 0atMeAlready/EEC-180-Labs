module partII(
    // LED Output
    output [9:0] LEDR,
    
    // Switch Inputs
    input [9:0] SW
);

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire [3:0] z8;
wire [7:0] SW_in;

//=======================================================
//  Structural coding
//=======================================================
assign SW_in = SW[7:0];  // Using lower 8 bits for LED display
lzd8b lzd_inst (
    .z8(z8), 
    .i8(SW_in)
);

assign LEDR = {6'b0000000, z8};  // Assign the 4-bit result to the LEDR output

endmodule

//------------------------------------------------------------------------//
module LED_DISPLAY(
    input [7:0] WIRE_IN, 
    output reg [3:0] LEDR
); 


always @(WIRE_IN) begin
    case(WIRE_IN)
        8'b00000000: LEDR = 4'b1111; 
        8'b00000001: LEDR = 4'b1111; 
        8'b0000001x: LEDR = 4'b1111; 
        8'b000001xx: LEDR = 4'b1111; 
        8'b00001xxx: LEDR = 4'b1111; 
        8'b0001xxxx: LEDR = 4'b1111; 
        8'b001xxxxx: LEDR = 4'b1111; 
        8'b01xxxxxx: LEDR = 4'b1111; 
        8'b1xxxxxxx: LEDR = 4'b1111; 
        default: LEDR = 4'b1111;
    endcase
end

endmodule
//------------------------------------------------------------------------//

module lzd (
    output reg [2:0] z, 
    input [3:0] i
);

always @(*) begin
    z[2] = (~i[3] & ~i[2] & ~i[1] & ~i[0]);
    z[1] = (~i[3] & ~i[2] & i[0]) | (~i[3] & ~i[2] & i[1]);
    z[0] = (~i[3] & i[2]) | (~i[3] & ~i[1] & i[0]);
end

endmodule

module lzd8b (
    output reg [3:0] z8,  
    input [7:0] i8    
);

wire [2:0] z_upper, z_lower;

lzd lzd_upper (
    .z(z_upper),
    .i(i8[7:4])
);

lzd lzd_lower (
    .z(z_lower),
    .i(i8[3:0])
);

// Combine outputs
always @(*) begin
    if (z_upper == 3'd4) begin        
        z8 = z_upper + z_lower;
    end 
    else begin   
        z8 = {1'b0, z_upper};  // Add leading 0 to match the 4-bit width
    end

    // Check for edge case
    if (i8 == 8'b00000000) begin
        z8 = 4'b1000;
		  
    end
end

endmodule



