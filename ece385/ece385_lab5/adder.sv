// 9-bit adder: can do addtion substraction and holding, depending on signal M and Add

module adder_9bit
(
    input   logic[7:0]     A,
    input   logic[7:0]     S,
	 input	logic				Add,
	 input	logic				M,
    output  logic[7:0]     Sum,
    output  logic          X
);

    logic 		C[1:0];
	 logic[7:0] temp;
	 logic		add_sub;
	 
	 OP_inverter 	xor1(.Din(S), .Control(!Add), .M, .Dout(temp));
	 always_comb begin
			if(Add)							// if add is 1: do addition, therefore, no carryin is needed
				add_sub = 1'b0;
			else if(M)
				add_sub = 1'b1;			// if add is 0, M=1: do substraction, therefore Cin=1 is needed after all bits in S are fliped
			else
				add_sub = 1'b0;			// if add is 0, M=0: no need to do substraction
	 end
	 
	 
	 four_bit_ra FA0(.x(A[3:0]  ), .y(temp[3:0]  ), .cin(add_sub), .s(Sum[3:0]  ), .cout(C[0]));
	 four_bit_ra FA1(.x(A[7:4]  ), .y(temp[7:4]  ), .cin(C[0]), 	.s(Sum[7:4]  ), .cout(C[1]));
	 one_bit_ra  FA3(.x(A[7]), 	 .y(temp[7]),	   .cin(C[1]), 	.s(X));
	 
endmodule



// optional inter the value in S or make the value equal to 8'b0 according to signal Add and M.
module OP_inverter
(
	input		logic[7:0]		Din,
	input		logic				Control,
	input		logic				M,
	output	logic[7:0]		Dout
);

	always_comb begin									// if M=0, temp value will be 8'b0, if M=1, add=1, we flip all the bits in S
		Dout[0] = (Din[0]^Control)&M;
		Dout[1] = (Din[1]^Control)&M;
		Dout[2] = (Din[2]^Control)&M;
		Dout[3] = (Din[3]^Control)&M;
		Dout[4] = (Din[4]^Control)&M;
		Dout[5] = (Din[5]^Control)&M;
		Dout[6] = (Din[6]^Control)&M;
		Dout[7] = (Din[7]^Control)&M;
	end

endmodule




// Four-bit full adder
// Three input : [3:0] x, [3:0] y, cin.
// Packed input x, y indicate the numbers need to be added. cin is the carry-in bit
// Two output : [3:0] s and cout
// This module is built upon four single bit full adder and ripple their carry-out bit together

module four_bit_ra(input [3:0] x,
                  input [3:0] y,
                  input cin,
                  output logic [3:0] s,
                  output logic cout
                  );
    logic c[2:0];
    one_bit_ra fa0(.x(x[0]), .y(y[0]), .cin(cin ), .s(s[0]), .cout(c[0]));
    one_bit_ra fa1(.x(x[1]), .y(y[1]), .cin(c[0]), .s(s[1]), .cout(c[1]));
    one_bit_ra fa2(.x(x[2]), .y(y[2]), .cin(c[1]), .s(s[2]), .cout(c[2]));
    one_bit_ra fa3(.x(x[3]), .y(y[3]), .cin(c[2]), .s(s[3]), .cout(cout));

endmodule




// One bit adder.
// Three input : x, y, cin. cin is the carry-in bit to the one bit full adder
// Two output : s, cout. cout is the one bit carry-out bit
module one_bit_ra(input x,
                  input y,
                  input cin,
                  output logic s,
                  output logic cout
                  );
    assign s    = x^y^cin;
    assign cout = (x&y)|(y&cin)|(cin&x);

endmodule
