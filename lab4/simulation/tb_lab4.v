module fsm_mealy_101 (
    input clk, reset, X,
    output reg Z
);
    // Define states using localparam instead of enum
    localparam S0 = 4'b0000,  // Initial state
               S1 = 4'b0001,  // Saw 1
               S2 = 4'b0010,  // Saw 10
               S3 = 4'b0011,  // Saw 101 (Z = 1)
               S4 = 4'b0100,  // Saw 0
               S5 = 4'b0101,  // Saw 00
               S6 = 4'b0110,  // Saw 000 (Lock Z = 0)
               S7 = 4'b0111,  // Saw 11
               S8 = 4'b1000;  // Saw 111 (Lock Z = 1)

    reg [3:0] state, next_state;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = X ? S1 : S4;
            S1: next_state = X ? S7 : S2;
            S2: next_state = X ? S3 : S4;
            S3: next_state = X ? S1 : S2;
            S4: next_state = X ? S1 : S5;
            S5: next_state = X ? S1 : S6;
            S6: next_state = S6; // Lock Z = 0
            S7: next_state = X ? S8 : S2;
            S8: next_state = S8; // Lock Z = 1
            default: next_state = S0;
        endcase
    end

    // Output logic (Mealy)
    always @(*) begin
        case (state)
            S3: Z = 1; // Output 1 when 101 detected
            S6: Z = 0; // Lock output at 0 if 000 detected
            S8: Z = 1; // Lock output at 1 if 111 detected
            default: Z = 0;
        endcase
    end
endmodule

`timescale 1ns / 1ps

module fsm_mealy_101_tb;
    reg clk, reset, X;
    wire Z;

    // Instantiate FSM
    fsm_mealy_101 uut (
        .clk(clk),
        .reset(reset),
        .X(X),
        .Z(Z)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns period

    // Stimulus
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        X = 0;
        #10;
        
        reset = 0;

        // Randomly generate 0s and 1s
        repeat (100) begin
            X = $random % 2; 
            #10;
        end

        // Finish simulation
        $stop;
    end

    // Monitor signals
    initial begin
        $monitor("X = %b | State = %b | Z = %b", X, uut.state, Z);
    end

endmodule
