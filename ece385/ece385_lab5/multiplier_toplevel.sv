// 8-bit multiplier top level
// ece385 lab5
// Yichi Zhang, Yizhen Ding

module multiplier_toplevel
(
	input		logic           	Clk,        // 50MHz clock is only used to get timing estimate data
	input		logic           	Reset,      // From push-button 0.  Remember the button is active low (0 when pressed)
	input		logic           	CALB,		   // From push-button 1
	input		logic           	Run,        // From push-button 3.
	input  	logic[7:0]  		S,     		// input data

	// all outputs are registered
	output 	logic[6:0]  		AhexL,
										AhexU,
										BhexL,
										BhexU,
	output	logic[7:0]			Aval,
										Bval,
	output	logic					X, D_X,
	output	logic					M,
	output	logic					Shift_enable,
	output	logic					LA);

	
	//logic								LA;				// load A
	//logic								Shift_enable;	// shift enable bit for register A and B
	//logic								M;					// least significant bit of register B
	//logic								D_X;				// input to d flipflop of X
	logic									LB;				// load B
	logic[7:0]							Din_A;			// parallel load for register A
	logic									SO;				// shift out bit of register A
	logic									Add_En;			// add enable bit
	logic									Reset_A;			// reset of register A
	

	// two 8-bit shift registers
	register 	RegA(		.Clk, 	
								.Reset(Reset_A & Reset),
								.Shift_In(X ), 
								.Load(LA), 
								.Shift_En(Shift_enable), 
								.Din(Din_A), 
								.Shift_Out(SO), 
								.Data_Out(Aval));
								
	register 	RegB(		.Clk, 
								.Reset, 
								.Shift_In(SO), 
								.Load(LB), 		
								.Shift_En(Shift_enable), 
								.Din(S), 
								.Shift_Out(M ), 
								.Data_Out(Bval));
	
	
	// 9-bit adder: can do addtion substraction and holding, depending on signal M and Add
	adder_9bit	adder(	.A(Aval),
								.S(S), 
								.Add(Add_En), 
								.Sum(Din_A), 
								.X(D_X), .M);
	
	// d flipflop for X
	D_FF  		d_ff(		.Clk, 
								.Reset, 
								.D(D_X), 
								.Q(X));
	
	// control logic
	control control_logic(.Clk,
								 .Reset,
								 .Run,
								 .CALB,
								 .M(M),
								 .Add(Add_En),
								 .Shift_En(Shift_enable),
								 .LoadA(LA),
								 .LoadB(LB),
								 .ResetA(Reset_A));

	HexDriver        HexAL (
                        .In0(Aval[3:0]),
                        .Out0(AhexL) );
	HexDriver        HexBL (
                        .In0(Bval[3:0]),
                        .Out0(BhexL) );
								
	HexDriver        HexAU (
                        .In0(Aval[7:4]),
                        .Out0(AhexU) );	
	HexDriver        HexBU (
                        .In0(Bval[7:4]),
                        .Out0(BhexU) );

/*
	 //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	 //These are array module instantiations
	 //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	 //Note: We can invert the levels inside the port assignments
	 sync button_sync[3:0] (Clk, {~Reset, ~LoadA, ~LoadB, ~Execute}, {Reset_SH, LoadA_SH, LoadB_SH, Execute_SH});
	 sync Din_sync[7:0] (Clk, Din, Din_S);
	 sync F_sync[2:0] (Clk, F, F_S);
    sync R_sync[1:0] (Clk, R, R_S);
*/
endmodule
