
module control (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	output logic Inv_MC_s1, Inv_MC_s0, msg_mux_s1, msg_mux_s0,
	output logic [3:0] counter_cycle
);



enum logic [2:0] {WAIT, InvAR, InvSR, InvSB, InvMC, DONE}   State, Next_state;   // Internal state logic

logic [3:0] counter1; // Counter for the loop
logic [1:0] counter2; // Counter for inverse MixColumn

always_ff @ (posedge CLK)
	begin
		if (RESET) begin
			State <= WAIT;
			counter1 <= 4'b0000;
			counter2 <= 2'b00;
		end
			
		else
			State <= Next_state;
	end

always_comb
	begin
		// Default next state is staying at current state
		Next_state = State;
		// Default output
		AES_DONE = 1'b0;
		Inv_MC_s1 = 1'b0;
		Inv_MC_s0 = 1'b0;
		msg_mux_s1 = 1'b0;
		msg_mux_s0 = 1'b0;
		
		// Assign next state
		unique case (State)
			WAIT:
				if (AES_START)
					Next_state = InvAR;
				else
					Next_state = WAIT;
			
			InvAR:
				case(counter1)
					// round 0
					4'b0000:
						Next_state = InvSR;
					// last round
					4'b1010:
						Next_state = DONE;
					default:
						Next_state = InvMC;
				endcase

			InvSR:
				Next_state = InvSB;
			
			InvSB:
				Next_state = InvAR;
				
			InvMC:
				case(counter2)
					// we need four cycles here to finish 128 bits mixcolumn
					2'b00:
						Next_state = InvSR;
					default:
						Next_state = InvMC;
				endcase
			
			DONE:
				if (AES_START)
					Next_state = DONE;
				else
					Next_state = WAIT;
			
			default : ;

		endcase

		// Assign control signals based on current state
		case(State)
			WAIT:
				begin
					counter1 = 4'b0000;
					counter2 = 2'b00;
				end
			InvAR:
				begin
					msg_mux_s1 = 1'b0;
					msg_mux_s0 = 1'b0;
				end
			
			InvSR:
				begin
					msg_mux_s1 = 1'b0;
					msg_mux_s0 = 1'b1;
					counter1 = counter1+1;
				end

			InvSB:
				begin
					msg_mux_s1 = 1'b1;
					msg_mux_s0 = 1'b1;
				end
				
			InvMC:
				begin
					msg_mux_s1 = 1'b1;
					msg_mux_s0 = 1'b0;
					counter2 = counter2+1;
				end
		
			DONE:
				begin
					AES_DONE = 1'b1;
				end
			default:;

		endcase
	end
	
assign counter_cycle = counter1;

endmodule
		