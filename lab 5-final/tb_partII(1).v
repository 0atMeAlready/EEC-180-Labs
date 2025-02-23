`include "C:/Users/dzyzhang/EEC180/lab 5/synthesis/supplement files/RAM_8BIT.v"
`include "C:/Users/dzyzhang/EEC180/lab 5/synthesis/supplement files/HEX_DISPLAY.v"
`include "C:/Users/dzyzhang/EEC180/lab 5/synthesis/supplement files/SQRT.v"
`include "C:/Users/dzyzhang/EEC180/lab 5/synthesis/supplement files/CTRL.v"

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
        .RST(ResetN),
        .St(St),
        .MDI(MDI),  // Change N to MDI
        .Done(Done),
        .Sqrt(Sqrt)
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
        for (i = 0; i < num_vectors-1; i = i + 1) begin
            MDI = vectors[i];
            $display("Starting computation for RAM[%0d] = 0x%h", i, vectors[i]);
            #20 St = 1;        // Assert the St signal
            wait (Done == 1);  // Wait for the calculation to complete
            $display("Input=0x%h, SqRt=0x%h", MDI, Sqrt);
            #20 St = 0;        // Deassert the St signal
            wait (Done == 0);  // Wait until Done is cleared
        end
    end
endmodule