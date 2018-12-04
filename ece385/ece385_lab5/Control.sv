//Two-always example for state machine

module control (input  logic Clk, Reset, CALB, Run, M,
                output logic Add, Shift_En, LoadA, LoadB, ResetA);

    // Declare signals curr_state, next_state of type enum
    // with enum values of A, B, ..., F as the state values
	 // Note that the length implies a max of 8 states, so you will need to bump this up for 8-bits
    enum logic [4:0] {start, 	CA_LB, 	CLA,
							A, 	A_P, 	B, 	B_P, 	C, 	C_P,
							D, 	D_P, 	E, 	E_P, 	F, 	F_P,
							G, 	G_P, 	H, 	H_M, 	halt}   curr_state, next_state; // we need 20 states in this lab. One for hold, four for shift and one for halt.

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)
    begin
        if (!Reset)
            curr_state <= start;				// any time if the reset button is pressed, it should go to start state.
		  else if (!CALB)
				curr_state <= CA_LB;				// any time if the CALB button is pressed. it should go to CA_LB state.
		  else
            curr_state <= next_state;		// if no button is pressed, it would go to the next state.
    end
	 
   // Assign outputs based on state
	always_comb
		begin
        
		  next_state  = curr_state;	//required because I haven't enumerated all possibilities below	  
	  
        unique case (curr_state) 
				
            start :	if (!Run)							//go to the CLA state only if the Run button is pressed.
								next_state = CLA;
							else
								next_state = start;
            CLA :			next_state = A_P;				//always go to the next state
				A_P :		next_state = A;
				A :	 	next_state = B_P;

				B_P :		next_state = B;
				B :		next_state = C_P;

				C_P :		next_state = C;
            C :    	next_state = D_P;

				D_P :		next_state = D;
            D :		next_state = E_P;

				E_P :		next_state = E;
            E :    	next_state = F_P;

				F_P :		next_state = F;
				F :    	next_state = G_P;
				
				G_P :		next_state = G;
				G :    	next_state = H_M;
				
				H_M :		next_state = H;
				H :		next_state = halt;

            halt :   if (Run)								// go to the start state only when the Run button is no longer being pressed
								next_state = start;
							else
								next_state = halt;
				CA_LB : 		next_state = start;			// go to start state after CA_LB
							  
        endcase
   
		  // Assign outputs based on ‘state’
        unique case (curr_state)
	   	   start:											// hold the value, do nothing								
	         begin
					 ResetA = 1'b1;							// when ResetA = 0, we reset register A
                LoadA = 1'b0;
					 LoadB = 1'b0;
					 Shift_En = 1'b0;
					 Add = 1'b0;
		      end
				
				A, B, C, D, E, F, G, H:						// shift state: allow the data in register A and B to shift
				begin
					ResetA = 1'b1;
					Add = 1'b0;
					LoadA = 1'b0;
					LoadB = 1'b0;
					Shift_En = 1'b1;
				end
				
	   	   halt:												// hold all value, do nothing
		      begin
                LoadA = 1'b0;
                LoadB = 1'b0;
                Shift_En = 1'b0;
					 Add = 1'b0;
					 ResetA = 1'b1;
		      end
				
				CLA:												// only reset A(clear A). no shifting, no loading.
				begin
					 ResetA = 1'b0;
					 LoadA = 1'b0;
                LoadB = 1'b0;
                Shift_En = 1'b0;
					 Add = 1'b0;
				end

				CA_LB:											// reset A, allow B to load data from switches. no shifting
				begin											
					 ResetA = 1'b0;
					 LoadA = 1'b0;
                LoadB = 1'b1;
                Shift_En = 1'b0;
					 Add = 1'b0;
				end
				
				H_M:												// enable adders to do substraction, load the value from the adders to A. do not shift 
				begin
					ResetA = 1'b1;
					LoadA = 1'b1;
					LoadB = 1'b0;
					Shift_En  =1'b0;
					Add = 1'b0;									// do substraction
				end

	   	   default:  										//default adding case allow A to load value from adder. enable adder to do addition
		      begin
               ResetA = 1'b1;
					LoadA = 1'b1;
					LoadB = 1'b0;
					Shift_En  =1'b0;
					Add = 1'b1;									// do addtion 
		      end
        endcase
    end

endmodule
