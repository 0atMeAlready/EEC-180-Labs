`ifndef RAM_8BIT_V
`define RAM_8BIT_V

module RAM (
    input wire [3:0] Addr,
    input wire [7:0] MDI,
    input wire Write_Enable, CLK,
    output reg [7:0] MDO
);
    reg [7:0] memory [15:0] /*synthesis ramstyle = "M9K" */;
    always @(posedge CLK) begin
        if (Write_Enable)
            memory[Addr] <= MDI;
        MDO <= memory[Addr];
    end
endmodule

`endif