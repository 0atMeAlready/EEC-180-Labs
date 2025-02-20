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
    input wire [7:0] N,
    output reg Done,
    output reg [3:0] Sqrt
);
    reg [7:0] R;
    reg [3:0] count;
    reg [7:0] odd;
    reg calculating;
    
    always @(posedge CLK or negedge ResetN) begin
        if (!ResetN) begin
            Sqrt <= 4'b0;
            Done <= 0;
            calculating <= 0;
        end 
        else if (St && !calculating) begin
            R <= N;
            odd <= 8'd1;
            count <= 4'b0;
            Done <= 0;
            calculating <= 1;
        end 
        else if (calculating) begin
            if (R >= odd) begin
                R <= R - odd;
                odd <= odd + 8'd2;
                count <= count + 1;
            end else begin
                Sqrt <= count;
                Done <= 1;
                calculating <= 0;
            end
        end
    end
endmodule

module Controller (
    input wire CLK, ResetN, St,
    output wire Done,
    output wire [3:0] Sqrt,
    output wire [7:0] N
);
    reg [3:0] Addr;
    reg Write_Enable;
    wire [7:0] MDO;
    wire [3:0] Sqrt_Result;
    reg Output_Write_Enable;
    reg [3:0] Out_Addr;
    
    RAM ram_inst (
        .Addr(Addr),
        .MDI(8'b0),
        .Write_Enable(Write_Enable),
        .CLK(CLK),
        .MDO(MDO)
    );
    
    SquareRoot sqrt_inst (
        .CLK(CLK),
        .ResetN(ResetN),
        .St(St),
        .N(MDO),
        .Done(Done),
        .Sqrt(Sqrt_Result)
    );
    
    RAM output_ram (
        .Addr(Out_Addr),
        .MDI({4'b0, Sqrt_Result}),
        .Write_Enable(Output_Write_Enable),
        .CLK(CLK),
        .MDO()
    );
    
    assign N = MDO;
    assign Sqrt = Sqrt_Result;
    
    always @(posedge CLK or negedge ResetN) begin
        if (!ResetN) begin
            Addr <= 0;
            Write_Enable <= 1;
            Out_Addr <= 0;
            Output_Write_Enable <= 0;
        end 
        else if (St) begin
            if (Addr == 4'b1111) begin
                Addr <= 0;
                Write_Enable <= 0;
            end else begin
                Addr <= Addr + 1;
            end
            if (Done) begin
                Output_Write_Enable <= 1;
                Out_Addr <= Addr;
            end else begin
                Output_Write_Enable <= 0;
            end
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
    reg [3:0] Addr;
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
        .N(MDO_wire),
        .Done(Done),
        .Sqrt(Sqrt)
    );
    
    Controller UUT (
        .CLK(CLK),
        .ResetN(ResetN),
        .St(St),
        .Done(Done),
        .Sqrt(Sqrt),
        .N(MDO_wire)
    );
    
    initial begin
        CLK = 0;
        forever #20 CLK = ~CLK;
    end
    
    initial begin
        ResetN = 0;
        St = 0;
        #80 ResetN = 1;
        $readmemb("testvecs", vectors);
        for (i = 0; i < num_vectors; i = i + 1) begin
            MDI = vectors[i];
            #20 St = 1;
            wait (Done == 1);
            $display("Input=0x%h, SqRt=0x%h", MDI, Sqrt);
            #20 St = 0;
            wait (Done == 0);
        end
        $finish;
    end
endmodule
