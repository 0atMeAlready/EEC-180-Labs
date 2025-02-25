`ifndef SQRT_V
`define SQRT_V

module SquareRoot (
    input wire CLK, RST, St,
    input wire [7:0] MDI,  // Read from RAM instead of internal memory
    output reg Done,
    output reg [3:0] Sqrt,
    output reg [3:0] Addr // Keep Addr as reg
);
    reg [7:0] R;
    reg [4:0] count;
    reg [7:0] odd;
    reg calculating;
    reg [1:0] state, next_state;

    localparam IDLE = 2'b00, START = 2'b01, WAIT = 2'b10, WRITE = 2'b11;
    
    always @(posedge CLK or negedge RST) begin
        if (!RST)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = St ? START : IDLE;
            START: next_state = WAIT;
            WAIT: next_state = Done ? WRITE : WAIT;
            WRITE: next_state = (Addr == 4'b1111) ? IDLE : START;
            default: next_state = IDLE;
        endcase
    end
    
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            Done <= 0;
            Sqrt <= 4'b0;
            R <= 0;
            odd <= 1;
            count <= 0;
            calculating <= 0;
            Addr <= 0;  // Ensure Addr is reset here
        end else begin
            case (state)
                IDLE: begin
                    Done <= 0;
                    if (St) begin
                        // Do not increment Addr here
                    end
                end
                
                START: begin
                    R <= MDI;  // Fetch data from RAM
                    odd <= 8'd1;
                    count <= 4'b0;
                    calculating <= 1;
                    Done <= 0;
                end
                
                WAIT: begin
                    if (calculating) begin
                        // Perform subtraction and increment count
                        if (R >= odd) begin
                            R <= R - odd;
                            odd <= odd + 8'd2;
                            count <= count + 1;
                        end else begin
                            Sqrt <= count;  // Set square root value here
                            Done <= 1;
                            calculating <= 0;
                        end
                    end
                end
                
                WRITE: begin
                    if (Done) begin
                        Addr <= Addr + 1; // Increment Addr after calculation is done
                    end
                    if (Addr == 4'b1111) begin
                        Addr <= 0;
                    end
                end
            endcase
        end
    end
endmodule



`endif