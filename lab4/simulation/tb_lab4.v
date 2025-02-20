module fsm_mealy_101(
    input clk, reset, X,
    output reg Z
);

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

    // State update logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic and output logic (Mealy output)
    always @(state, X) begin
        case(state)
            S0: begin
                if (X)
                    next_state = S1;
                else
                    next_state = S4;
            end
            
            S1: begin
                if (X)
                    next_state = S7;
                else
                    next_state = S2;
            end

            S2: begin
                if (X)
                    next_state = S3;
                else
                    next_state = S5;
            end

            S3: begin
               
                if (X)
                    next_state = S7;
                else
                    next_state = S2;
            end

            S4: begin
                if (X)
                    next_state = S1;
                else
                    next_state = S5;
            end

            S5: begin
                if (X != 0)
                    next_state = S1;
                else
                    next_state = S6;
            end

            S6: begin
                if (X)
                    next_state = S6;
                else
                    next_state = S6;  
            end

            S7: begin
                if (X)
                    next_state = S8;
                else
                    next_state = S2;
            end

            S8: begin
          
                next_state = S8;  // Lock Z to 1
            end

            default: begin
                next_state = S0;
            end
        endcase
    end
	 
	     always @(*) begin
        case (state)
            S3: Z = 1;  // Output 1 when 101 detected
            S6: Z = 0;  // Lock output at 0 if 000 detected
            S8: Z = 1;  // Lock output at 1 if 111 detected
            default: Z = 0;
        endcase
    end

endmodule

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
    always #10 clk = ~clk; // 10ns period

    // Stimulus
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        X = 0;
        #10;
        
        reset = 0;

        // Feed the sequence of bits (01010100101000101111)
        
        $display("Test case 1");
        
        X = 0; #10;  // Time 10ns, X = 0
        #10 X = 1; #10;  // Time 20ns, X = 1
        #10 X = 0; #10;  // Time 30ns, X = 0
        #10 X = 1; #10;  // Time 40ns, X = 1
        #10 X = 0; #10;  // Time 50ns, X = 0
        #10 X = 1; #10;  // Time 60ns, X = 1
        #10 X = 0; #10;  // Time 70ns, X = 0
        #10 X = 0; #10;  // Time 80ns, X = 0
        #10 X = 1; #10;  // Time 90ns, X = 1
        #10 X = 0; #10;  // Time 100ns, X = 0
        #10 X = 1; #10;  // Time 110ns, X = 1
        #10 X = 0; #10;  // Time 120ns, X = 0
        #10 X = 0; #10;  // Time 130ns, X = 0
        #10 X = 0; #10;  // Time 130ns, X = 0
        #10 X = 1; #10;  // Time 140ns, X = 1
        #10 X = 0; #10;  // Time 150ns, X = 0
        #10 X = 1; #10;  // Time 160ns, X = 1
        #10 X = 1; #10;  // Time 170ns, X = 1
        #10 X = 1; #10;  // Time 180ns, X = 1
		  
		  $display("reset occurs, test case 2");
		  
		  reset = 1;
		  #10;
		  reset = 0;
		  
		  X = 0; #10;  // Time 10ns, X = 0
        #10 X = 1; #10;  // Time 20ns, X = 1
        #10 X = 0; #10;  // Time 30ns, X = 0
        #10 X = 1; #10;  // Time 40ns, X = 1
        #10 X = 0; #10;  // Time 50ns, X = 0
        #10 X = 1; #10;  // Time 60ns, X = 1
        #10 X = 0; #10;  // Time 70ns, X = 0
        #10 X = 1; #10;  // Time 80ns, X = 1
        #10 X = 0; #10;  // Time 90ns, X = 0
        #10 X = 1; #10;  // Time 100ns, X = 1
        #10 X = 1; #10;  // Time 110ns, X = 1
        #10 X = 1; #10;  // Time 120ns, X = 1
        #10 X = 0; #10;  // Time 130ns, X = 0
        #10 X = 1; #10;  // Time 140ns, X = 1
        #10 X = 0; #10;  // Time 150ns, X = 0
        #10 X = 1; #10;  // Time 160ns, X = 1
        #10 X = 0; #10;  // Time 170ns, X = 0
        #10 X = 0; #10;  // Time 180ns, X = 0
		  #10 X = 0; #10;  // Time 180ns, X = 0
		  

        // End of stimulus
        #20;
        $stop; // Finish simulation
    end

    // Monitor signals
    initial begin
        $monitor("Time = %0t | X = %b | State = %b | Z = %b", $time, X, uut.state, Z);
    end

endmodule