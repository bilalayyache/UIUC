
module control (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	input  logic[31:0] out_Inv_MC,
	input  logic[127:0] message,
	output logic[127:0] Inv_MC,
	output logic AES_DONE,
	output logic Inv_MC_s1, Inv_MC_s0, msg_mux_s1, msg_mux_s0, load_en,
	output logic [3:0] counter_cycle
);



enum logic [4:0] {WAIT, InvAR, InvSR, InvSB, InvMC0, InvMC1, InvMC2, InvMC3, DONE}   State, Next_state;   // Internal state logic

logic [3:0] next_counter; // Counter for the loop

always_ff @ (posedge CLK) begin
	begin
		if (RESET) begin
			State <= WAIT;
			counter_cycle <= 4'b0000;
		end

		else
			State <= Next_state;
			counter_cycle <= next_counter;
	end
end

always_comb
	begin
		// Default next state is staying at current state
		Next_state = State;
		next_counter = counter_cycle;
		// Default output
		AES_DONE = 1'b0;
		Inv_MC_s1 = 1'b0;
		Inv_MC_s0 = 1'b0;
		msg_mux_s1 = 1'b0;
		msg_mux_s0 = 1'b0;
		load_en = 1'b1;
		Inv_MC = message;
		
		// Assign next state
		unique case (State)
			WAIT:
				if (AES_START) begin
					Next_state = InvAR;
					next_counter = 4'b0;
				end
				else
					Next_state = WAIT;
			
			InvAR:
				case(counter_cycle)
					// round 0
					4'b0000:
						Next_state = InvSR;
					// last round
					4'b1010:
						Next_state = DONE;
					default:
						Next_state = InvMC0;
				endcase

			InvSR:
				begin
					Next_state = InvSB;
					next_counter = counter_cycle + 1'b1;
				end
			InvSB:
				Next_state = InvAR;
				
			InvMC0:
				Next_state = InvMC1;
				
			InvMC1:
				Next_state = InvMC2;
			
			InvMC2:
				Next_state = InvMC3;
			
			InvMC3:
				Next_state = InvSR;

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
					//counter_cycle = 4'b0000;
					load_en = 1'b0;
					msg_mux_s1 = 1'b0;
					msg_mux_s0 = 1'b0;
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
				end
//			InvSB0:
//				begin
//					load_en = 1'b0;
//					msg_mux_s1 = 1'b1;
//					msg_mux_s0 = 1'b1;
//				end
//				
			InvSB:
				begin
					msg_mux_s1 = 1'b1;
					msg_mux_s0 = 1'b1;
				end
				
			InvMC0:
				begin
					Inv_MC_s1 = 1'b0;
					Inv_MC_s0 = 1'b0;
					msg_mux_s1 = 1'b1;
					msg_mux_s0 = 1'b0;
					Inv_MC[31:0] = out_Inv_MC;
				end
		
			InvMC1:
				begin
					Inv_MC_s1 = 1'b0;
					Inv_MC_s0 = 1'b1;
					msg_mux_s1 = 1'b1;
					msg_mux_s0 = 1'b0;
					Inv_MC[63:32] = out_Inv_MC;
				end
				
			InvMC2:
				begin
					Inv_MC_s1 = 1'b1;
					Inv_MC_s0 = 1'b0;
					msg_mux_s1 = 1'b1;
					msg_mux_s0 = 1'b0;
					Inv_MC[95:64] = out_Inv_MC;
				end
				
			InvMC3:
				begin
					Inv_MC_s1 = 1'b1;
					Inv_MC_s0 = 1'b1;
					msg_mux_s1 = 1'b1;
					msg_mux_s0 = 1'b0;
					Inv_MC[127:96] = out_Inv_MC;
				end
				
			DONE:
				begin
					AES_DONE = 1'b1;
					load_en = 1'b0;
				end

			default:;
				//AES_DONE = 1'b1;

		endcase
	end

endmodule
		