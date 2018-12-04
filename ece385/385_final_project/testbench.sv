module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic         Clk;           
logic         Reset;          	
logic         frame_clk;     // Instantiating the DUT
logic [12:0]   DrawX, DrawY;  // Make sure the module and signal names match with those in your design
logic [23:0] stand_dout, run_1_dout, run_2_dout, run_3_dout, run_4_dout;
logic space_on, a_on, s_on, d_on;
logic  is_Mario;
logic [12:0] Mario_X_Pos, Mario_Y_Pos, process;
logic [23:0] mario_dout;

mario Mario(.*);


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

////////////////////////////////////////////////////////////////
// modify below
////////////////////////////////////////////////////////////////


Reset = 1'b1;		// Toggle Rest

#2
Reset = 1'b0;
#2
d_on = 1'b1;

end
endmodule
