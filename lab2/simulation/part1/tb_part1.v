module fullAdder(

input [8:0] A, B,  
input Cin,
output [8:0] S, 
output Cout
);

assign S = A ^ B ^ Cin;
assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule

module tb;

reg [8:0] A, B;
reg Cin;
wire [8:0] S;
wire Cout;

//design under test

rippleAdder RA(S[8:0], Cout, A[8:0], B[8:0], Cin);

inital begin

        // Iterate through all possible values of A, B, and Cin
        for (i = 0; i < 65536; i = i + 1) begin
            {A, B, Cin} = i;
            #10; //

            // Display the results
            $monitor("A = %b, B = %b, Cin = %b | Sum = %b, Cout = %b", A, B, Cin, S, Cout);
        end

$finish

endmodule


