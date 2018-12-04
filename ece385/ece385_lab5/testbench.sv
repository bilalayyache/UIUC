module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic           	Clk;        // 50MHz clock is only used to get timing estimate data
logic           	Reset;      // From push-button 0.  Remember the button is active low (0 when pressed)
logic           	CALB;		   // From push-button 1
logic           	Run;        // From push-button 3.
logic[7:0]  		S;     		// input data

// all outputs are registered
logic[6:0]  		AhexL,
						AhexU,
						BhexL,
						BhexU;
logic[7:0]			Aval,
						Bval;
logic					X, D_X, M, Shift_enable, LA;

// To store expected results
logic [7:0] ans_1a, ans_1b, ans_2a, ans_2b, ans_3a, ans_3b, ans_4a, ans_4b;
				
// A counter to count the instances where simulation results
// do no match with expected results
integer ErrorCnt = 0;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
multiplier_toplevel multiplier(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS


////////////////////////////////////
// test case 1: + * +
////////////////////////////////////
Reset = 0;		// Toggle Rest
CALB = 1;
Run = 1;
S = 8'b00000111;	// Specify switch input B = 7


#2 Reset = 1;

#2 CALB = 0;	// Toggle CALB
#2 CALB = 1;

#2	S = 8'b00111011;	// Change S = 59

#2 Run = 0;	// Toggle Execute
   
#50 Run = 1;
    ans_1a = 8'b00000001; // Expected result of test1
	 ans_1b = 8'b10011101;
    if (Aval != ans_1a)
	 ErrorCnt++;
    if (Bval != ans_1b)
	 ErrorCnt++;
	 
////////////////////////////////////
// test case 2: - * - (-7)*(-59)
////////////////////////////////////
#20
Reset = 0;		// Toggle Rest
CALB = 1;
Run = 1;
S = 8'b11111001;	// Specify switch input B = -7	 
#2 Reset = 1;

#2 CALB = 0;	// Toggle CALB
#2 CALB = 1;

#2	S = 8'b11000101;	// Change S = -59

#2 Run = 0;	// Toggle Execute
   
#50 Run = 1;
    ans_2a = 8'b00000001; // Expected result of test2
	 ans_2b = 8'b10011101;
    if (Aval != ans_2a)
	 ErrorCnt++;
    if (Bval != ans_2b)
	 ErrorCnt++;

	 
	 
////////////////////////////////////
// test case 3: + * -	(7)*(-59)
////////////////////////////////////
#20
Reset = 0;		// Toggle Rest
CALB = 1;
Run = 1;
S = 8'b00000111;	// Specify switch input B = 7	 
#2 Reset = 1;

#2 CALB = 0;	// Toggle CALB
#2 CALB = 1;

#2	S = 8'b11000101;	// Change S = -59

#2 Run = 0;	// Toggle Execute
   
#50 Run = 1;
    ans_3a = 8'b11111110; // Expected result of test3
	 ans_3b = 8'b01100011;
    if (Aval != ans_3a)
	 ErrorCnt++;
    if (Bval != ans_3b)
	 ErrorCnt++;

	 
	 
////////////////////////////////////
// test case 4: - * +	(-59)*(7)
////////////////////////////////////
#20
Reset = 0;		// Toggle Rest
CALB = 1;
Run = 1;
S = 8'b11000101;	// Specify switch input B = -59	 
#2 Reset = 1;

#2 CALB = 0;	// Toggle CALB
#2 CALB = 1;

#2	S = 8'b00000111;	// Change S = 7

#2 Run = 0;	// Toggle Execute
   
#50 Run = 1;
    ans_4a = 8'b11111110; // Expected result of test4
	 ans_4b = 8'b01100011;
    if (Aval != ans_4a)
	 ErrorCnt++;
    if (Bval != ans_4b)
	 ErrorCnt++;

	 

if (ErrorCnt == 0)
	$display("Success!");  // Command line output in ModelSim
else
	$display("%d error(s) detected. Try again!", ErrorCnt);
end
endmodule
