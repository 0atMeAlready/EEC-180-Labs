module full_adder (
    input A, B, Cin,       // Inputs: two bits and carry-in
    output Sum, Cout       // Outputs: sum and carry-out
);
    assign Sum = A ^ B ^ Cin;            // Sum is XOR of inputs
    assign Cout = (A & B) | (B & Cin) | (A & Cin); // Carry-out logic
endmodule

module multiplier (
    input [3:0] A, B,       // 4-bit inputs
    output [7:0] P          // 8-bit product
);
    wire [15:0] pp;                 // Partial products
    wire [7:0] sum1, sum2, sum3;    // Intermediate sums
    wire [7:0] carry1, carry2, carry3; // Carry signals

    // Generate partial products
    assign pp[0]  = A[0] & B[0];
    assign pp[1]  = A[1] & B[0];
    assign pp[2]  = A[2] & B[0];
    assign pp[3]  = A[3] & B[0];
    assign pp[4]  = A[0] & B[1];
    assign pp[5]  = A[1] & B[1];
    assign pp[6]  = A[2] & B[1];
    assign pp[7]  = A[3] & B[1];
    assign pp[8]  = A[0] & B[2];
    assign pp[9]  = A[1] & B[2];
    assign pp[10] = A[2] & B[2];
    assign pp[11] = A[3] & B[2];
    assign pp[12] = A[0] & B[3];
    assign pp[13] = A[1] & B[3];
    assign pp[14] = A[2] & B[3];
    assign pp[15] = A[3] & B[3];

    // Row 1: Add pp[4:7] and shifted pp[0:3]
    full_adder fa1_0 (pp[4], pp[1], 1'b0, sum1[1], carry1[1]);
    full_adder fa1_1 (pp[5], pp[2], carry1[1], sum1[2], carry1[2]);
    full_adder fa1_2 (pp[6], pp[3], carry1[2], sum1[3], carry1[3]);
    full_adder fa1_3 (pp[7], 1'b0, carry1[3], sum1[4], carry1[4]);
    assign sum1[0] = pp[0];
    assign sum1[5] = carry1[4];
    assign sum1[7:6] = 2'b00;

    // Row 2: Add sum1[2:7] and shifted pp[8:11]
    full_adder fa2_0 (sum1[2], pp[8], 1'b0, sum2[2], carry2[2]);
    full_adder fa2_1 (sum1[3], pp[9], carry2[2], sum2[3], carry2[3]);
    full_adder fa2_2 (sum1[4], pp[10], carry2[3], sum2[4], carry2[4]);
    full_adder fa2_3 (sum1[5], pp[11], carry2[4], sum2[5], carry2[5]);
    assign sum2[0] = sum1[0];
    assign sum2[1] = sum1[1];
    assign sum2[6] = carry2[5];
    assign sum2[7] = 1'b0;

    // Row 3: Add sum2[3:7] and shifted pp[12:15]
    full_adder fa3_0 (sum2[3], pp[12], 1'b0, sum3[3], carry3[3]);
    full_adder fa3_1 (sum2[4], pp[13], carry3[3], sum3[4], carry3[4]);
    full_adder fa3_2 (sum2[5], pp[14], carry3[4], sum3[5], carry3[5]);
    full_adder fa3_3 (sum2[6], pp[15], carry3[5], sum3[6], carry3[6]);
    assign sum3[0] = sum2[0];
    assign sum3[1] = sum2[1];
    assign sum3[2] = sum2[2];
    assign sum3[7] = carry3[6];

    // Final product
    assign P = sum3;

endmodule


module testbench;
    reg [3:0] A, B;       // Inputs to the multiplier
    wire [7:0] P;         // Output from the multiplier

    // Instantiate the design under test (DUT)
    multiplier MA (
        .A(A),
        .B(B),
        .P(P)
    );

    integer i, j; // Loop variables

    initial begin
        // Monitor for debugging
        $monitor("A=%b B=%b P=%b", A, B, P);

        // Iterate through all possible combinations of A and B
        for (i = 0; i < 16; i = i + 1) begin
                
		A [3:0] = i; // Assign values to A
                B [3:0] = i; // Assign values to B

                #10; // Wait 10 time units for results to stabilize

                // Check result
                if (P !== (A * B)) begin
                    $display("ERROR: A=%b B=%b P=%b (Expected %b)", 
                              A, B, P, A * B);
                
            end
        end

        $finish; // End simulation
    end
endmodule


