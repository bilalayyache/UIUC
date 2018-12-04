module Goomba_image(	input       Clk,                // 50 MHz clock
											Reset,              // Active-high reset signal
							input logic [23:0] goomba_1_dout, goomba_2_dout, goomba_die_dout, background_dout,
							input logic is_goomba_die,
							output logic [23:0] goomba_dout,
							output logic rip);

	 enum logic [2:0] {left, right, die, none} state, next_state;
	 logic [24:0] Goomba_counter, Goomba_counter_in;
	 logic rip_in;

	 // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
				// FSM control
				state <= left;
				Goomba_counter <= 24'd0;
				rip <= 1'b0;
        end
        else
        begin
				// FSM
				state <= next_state;
				Goomba_counter <= Goomba_counter_in;
				rip <= rip_in;
        end
    end

	 // FSM control (next state logic
	 always_comb begin
		  // FSM control
		  next_state = state;
		  Goomba_counter_in = Goomba_counter;
		  rip_in = rip;
		  unique case (state)
		     left:
				  if (is_goomba_die) begin
						next_state = die;
					   Goomba_counter_in = 25'd0;
				  end
				  else if (Goomba_counter[24]) begin
						next_state = right;
						Goomba_counter_in = 25'd0;
				  end
				  else begin
						next_state = left;
						Goomba_counter_in = Goomba_counter + 1'b1;
				  end
				  
			  right:
				  if (is_goomba_die) begin
						next_state = die;
					   Goomba_counter_in = 25'd0;
				  end
				  else if (Goomba_counter[24]) begin
						next_state = left;
						Goomba_counter_in = 25'd0;
				  end
				  else begin
						next_state = right;
						Goomba_counter_in = Goomba_counter + 1'b1;
				  end
				 
				die:
				  if (Goomba_counter[24]) begin
						next_state = none;
						Goomba_counter_in = 25'd0;
						rip_in = 1'b1;
				  end
				  else begin
						next_state = die;
						Goomba_counter_in = Goomba_counter + 1'b1;
				  end 

				none:
				  begin
						next_state = none;
						Goomba_counter_in = 25'd0;
						rip_in = 1'b1;
				  end 
			  default: ;
		  
		  endcase
		  
		  // assign output for each state
		  case(state)
				left:
					goomba_dout = goomba_1_dout;
				right:
					goomba_dout = goomba_2_dout;
				die:
					goomba_dout = goomba_die_dout;
				none:
					goomba_dout = background_dout;
				default:
					goomba_dout = goomba_1_dout;
		  
		  endcase
	 
	 end
	 
endmodule
