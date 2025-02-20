// RAM module
module RAM (
    input wire [3:0] Addr,
    input wire [7:0] MDI,
    input wire Write_Enable, CLK,
    output reg [7:0] MDO
);
    reg [7:0] memory [15:0];
    always @(posedge CLK) begin
        if (Write_Enable)
            memory[Addr] <= MDI;
        MDO <= memory[Addr];
    end
endmodule


module SquareRoot (
    input wire CLK, ResetN, St,
    input wire [7:0] MDO,  // Read from RAM instead of internal memory
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
    
    always @(posedge CLK or negedge ResetN) begin
        if (!ResetN)
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
    
    always @(posedge CLK or negedge ResetN) begin
        if (!ResetN) begin
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
                    R <= MDO;  // Fetch data from RAM
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





module tb_sqrt;
    parameter num_vectors = 16;
    reg CLK, ResetN, St;
    wire Done;
    reg [7:0] MDI;
    wire [3:0] Sqrt;
    reg [7:0] vectors [0:num_vectors-1];
    integer i;
    wire [7:0] MDO_wire;
    wire [3:0] Addr; // Addr is now a wire, driven by SquareRoot
    reg Write_Enable;
    
    RAM ram_inst (
        .Addr(Addr),
        .MDI(MDI),
        .Write_Enable(Write_Enable),
        .CLK(CLK),
        .MDO(MDO_wire)
    );
    
    SquareRoot sqrt_inst (
        .CLK(CLK),
        .ResetN(ResetN),
        .St(St),
        .MDO(MDI),  // Connect RAM output to SquareRoot input
        .Done(Done),
        .Sqrt(Sqrt),
        .Addr(Addr)  // Connect SquareRoot address output to RAM address input
    );

    initial begin
        CLK = 0;
        forever #20 CLK = ~CLK;
    end
    
    initial begin
        ResetN = 0;
        St = 0;
        #80 ResetN = 1;  // Initial reset release
        
        // Initializing the vectors
        vectors[0]  = 8'b00000001; // 1
        vectors[1]  = 8'b00000100; // 4
        vectors[2]  = 8'b00001001; // 9
        vectors[3]  = 8'b00010000; // 16
        vectors[4]  = 8'b00011001; // 25
        vectors[5]  = 8'b00100100; // 36
        vectors[6]  = 8'b00110001; // 49
        vectors[7]  = 8'b01000000; // 64
        vectors[8]  = 8'b00000000; // 0
        vectors[9]  = 8'b00000110; // 6
        vectors[10] = 8'b00001101; // 13
        vectors[11] = 8'b00010101; // 21
        vectors[12] = 8'b00011011; // 27
        vectors[13] = 8'b00101100; // 44
        vectors[14] = 8'b11100001; // 225
        vectors[15] = 8'b11111111; // 255
        
        // Test each vector
        for (i = 0; i < num_vectors; i = i + 1) begin
            MDI = vectors[i];
            $display("Starting computation for RAM %d = %d, value loaded into subtractor  = %d", i, vectors[i], MDI);
            #20 St = 1;        // Assert the St signal
            wait (Done == 1);  // Wait for the calculation to complete
            $display("Input=%d, SqRt=%d", MDI, Sqrt);
            #20 St = 0;        // Deassert the St signal
            wait (Done == 0);  // Wait until Done is cleared
        end
        $finish;
    end
endmodule