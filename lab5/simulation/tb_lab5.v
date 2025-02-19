module RAM (
    input wire [3:0] Addr,
    input wire [7:0] MDI,
    input wire Write_Enable, CLK,
    output reg [7:0] MDO
);

    reg [7:0] memory [15:0] /*synthesis ramstyle = "M9K" */;

    always @(posedge CLK) begin
        if (Write_Enable)  
            memory[Addr] <= MDI;  // Write memory
        MDO <= memory[Addr];      // Read memory
    end
endmodule

module SquareRoot (
    input wire CLK, ResetN, St, 
    input wire [7:0] N,
    output reg Done,
    output reg [3:0] Sqrt
);

    reg [7:0] R;       // Remainder (N)
    reg [3:0] count;   // Square root result
    reg [7:0] odd;     // Odd numbers: 1, 3, 5, 7, ...

    always @(posedge CLK or negedge ResetN) begin
        if (!ResetN) begin
            Sqrt <= 4'b0;
            Done <= 0;
        end 
        else if (St) begin
            R <= N;      // Initialize remainder
            odd <= 8'd1; // Start subtracting with 1
            count <= 4'b0;
            Done <= 0;
        end 
        else if (R >= odd) begin
            R <= R - odd;  // Subtract the odd number
            odd <= odd + 8'd2; // Next odd number
            count <= count + 1;
        end 
        else begin
            Sqrt <= count;
            Done <= 1;   // Done computing
        end
    end
endmodule

module Controller (
    input wire CLK, ResetN, St,
    output wire Done,
    output wire [3:0] Sqrt,
    output wire [7:0] N
);

    reg [3:0] Addr;    // Address pointer
    wire [7:0] MDO;    // RAM output

    // Instantiate RAM
    RAM ram_inst (
        .Addr(Addr),
        .MDI(8'b0),         // No writing in this phase
        .Write_Enable(1'b0),
        .CLK(CLK),
        .MDO(MDO)
    );

    // Instantiate Square Root Calculator
    SquareRoot sqrt_inst (
        .CLK(CLK),
        .ResetN(ResetN),
        .St(St),
        .N(MDO),
        .Done(Done),
        .Sqrt(Sqrt)
    );

    assign N = MDO;

    always @(posedge CLK or negedge ResetN) begin
        if (!ResetN)
            Addr <= 4'b0;
        else if (Done) begin
            if (Addr == 4'b1111)
                Addr <= 4'b0; // Wrap back to 0
            else
                Addr <= Addr + 1'b1;
        end
    end
endmodule

module tb_sqrt;
parameter num_vectors = 16; // 16 words
reg CLK, ResetN, St, Write_Enable;
wire Done;
wire [3:0] Sqrt;
reg [7:0] vectors [0:num_vectors-1];
integer i;
reg [3:0] Addr;
reg [7:0] MDI;
wire [7:0] MDO_wire; // Temporary wire to connect RAM output

// Instantiate RAM
RAM ram_inst (
    .Addr(Addr),
    .MDI(MDI),
    .Write_Enable(Write_Enable),
    .CLK(CLK),
    .MDO(MDO_wire)  // Connect RAM output to wire, not N
);

// Instantiate Controller
Controller UUT (
    .CLK(CLK), 
    .ResetN(ResetN), 
    .St(St), 
    .Done(Done), 
    .Sqrt(Sqrt), 
    .N(MDO_wire)  // Pass wire instead of reg
);

initial // Clock generator
begin
    CLK = 1'b0;
    forever #20 CLK = ~CLK; // Clock period = 40 ns
end

initial // Test stimulus
begin
    ResetN = 1'b0; // Reset state machine
    St = 1'b0;
    Write_Enable = 1'b1; // Enable writing to RAM
    #80 ResetN = 1'b1; // Deassert reset after 80 ns

    // Load test vectors into RAM
    $readmemb("/Users/jhsu2022/Documents/school/2024-2025/Winter Quarter/EEC 180/EEC-180-Labs/lab5/simulation/testvecs.txt", vectors); // Ensure correct file path

    for (i = 0; i < num_vectors; i = i + 1) begin
        Addr = i;  // Set address in RAM
        MDI = vectors[i];  // Load test vector into RAM
        #20;  // Wait for write to complete
    end

    Write_Enable = 1'b0; // Disable writing after loading data

    #100; // Wait before starting computation to let RAM settle

    // Now start the square root computation
    for (i = 0; i < num_vectors; i = i + 1) begin
        #20 St = 1'b1; // Start computation
        wait (Done == 1);
        $display("Input=0x%h, SqRt=0x%h", MDO_wire, Sqrt);
        #20 St = 1'b0; // Reset Start
        wait (Done == 0);
    end

    $finish;
end

endmodule
