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
        X = 0; #10;  // Time 10ns, X = 0
        #10 X = 1; #10;  // Time 20ns, X = 1
        #10 X = 0; #10;  // Time 30ns, X = 0
        #10 X = 1; #10;  // Time 40ns, X = 1
        #10 X = 0; #10;  // Time 50ns, X = 0
        #10 X = 1; #10;  // Time 60ns, X = 1
        #10 X = 0; #10;  // Time 70ns, X = 0
        #10 X = 0; #10;  // Time 80ns, X = 0
        #10 X = 0; #10;  // Time 80ns, X = 0
        #10 X = 1; #10;  // Time 90ns, X = 1
        #10 X = 0; #10;  // Time 100ns, X = 0
        #10 X = 1; #10;  // Time 110ns, X = 1
        #10 X = 0; #10;  // Time 120ns, X = 0
        #10 X = 0; #10;  // Time 130ns, X = 0
        #10 X = 1; #10;  // Time 140ns, X = 1
        #10 X = 0; #10;  // Time 150ns, X = 0
        #10 X = 1; #10;  // Time 160ns, X = 1
        #10 X = 1; #10;  // Time 170ns, X = 1
        #10 X = 1; #10;  // Time 180ns, X = 1
		  #10 X = 1; #10;  // Time 190ns, X = 1
		  
		  
		  $display("reset occurs");
		  
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
		  #10 X = 0; #10;  // Time 190ns, X = 0
		  

        // End of stimulus
        #20;
        $stop; // Finish simulation
    end

    // Monitor signals
    initial begin
        $monitor("Time = %0t | X = %b | State = %b | Z = %b", $time, X, uut.state, Z);
    end

endmodule

