module mario_image(	input       Clk,                // 50 MHz clock
											Reset,              // Active-high reset signal
							input logic space_on, a_on, s_on, d_on, is_in_air, is_Mario_die,
							input logic [23:0] stand_dout, run_1_dout, run_2_dout, run_3_dout, jump_dout,
									 stand_l_dout, run_1_l_dout, run_2_l_dout, run_3_l_dout, jump_l_dout,die_dout, win_game_dout,
							input logic [12:0] Mario_X_Pos,
							output logic [23:0] mario_dout);

	 enum logic [4:0] {stand_r, run_1_r, run_2_r, run_3_r,
							 stand_l, run_1_l, run_2_l, run_3_l,jump_r,jump_l, die} state, next_state;
	 logic counter, next_counter;
	 logic [23:0] Mario_counter, Mario_counter_in;

	 // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
				// FSM control
				state <= stand_r;
				counter <= 1'b0;
				Mario_counter <= 24'd0;
        end
        else
        begin
				// FSM
				state <= next_state;
				counter <= next_counter;
				Mario_counter <= Mario_counter_in;				
        end
    end

	 // FSM control (next state logic
	 always_comb begin
		  // FSM control
		  next_state = state;
		  next_counter = counter;
		  Mario_counter_in = Mario_counter;
		  
		  unique case (state)
		     stand_r:
				  if (is_Mario_die) begin
						next_state = die;
				  end
			     else if (d_on) begin
						next_state = run_1_r;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else if (is_in_air)
						next_state = jump_r;
				  else if (a_on) begin
						next_state = run_1_l;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else begin
						next_state = stand_r;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  
			  stand_l:
				  if (is_Mario_die) begin
						next_state = die;
				  end
			     else if (d_on) begin
						next_state = run_1_r;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else if (is_in_air)
						next_state = jump_l;
				  else if (a_on) begin
						next_state = run_1_l;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else begin
						next_state = stand_l;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
			  
			  run_1_r:
			     if (is_Mario_die) begin
						next_state = die;
				  end
				  
				  else if (is_in_air)
						next_state = jump_r;
			     else if (d_on && Mario_counter[22]) begin
						next_state = run_2_r;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else if (d_on) begin
						next_state = run_1_r;
						next_counter = 1'b0;
						Mario_counter_in = Mario_counter + 1'b1;
				  end
				  // turn around case
				  else if (a_on) begin
						next_state = run_1_l;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else begin
						next_state = stand_r;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  
			  run_1_l:
			     if (is_Mario_die) begin
						next_state = die;
				  end
			     else if (is_in_air)
						next_state = jump_l;
			     else if (a_on && Mario_counter[22]) begin
						next_state = run_2_l;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else if (a_on) begin
						next_state = run_1_l;
						next_counter = 1'b0;
						Mario_counter_in = Mario_counter + 1'b1;
				  end
				  // turn around case
				  else if (d_on) begin
						next_state = run_1_r;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else begin
						next_state = stand_l;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  
			  run_2_r:
			     if (is_Mario_die) begin
						next_state = die;
				  end
			     else if (is_in_air)
						next_state = jump_r;
				  else if (d_on && Mario_counter[22] && ~counter) begin
						next_state = run_3_r;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else if (d_on && Mario_counter[22] && counter) begin
						next_state = run_1_r;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else if (d_on && ~Mario_counter[22]) begin
						next_state = run_2_r;
						next_counter = counter;
						Mario_counter_in = Mario_counter + 24'd1;;
				  end
				  else if (a_on) begin
						next_state = run_1_l;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else begin
						next_state = stand_r;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  
			  run_2_l:
			     if (is_Mario_die) begin
						next_state = die;
				  end
				  else if (is_in_air)
						next_state = jump_l;
				  else if (a_on && Mario_counter[22] && ~counter) begin
						next_state = run_3_l;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else if (a_on && Mario_counter[22] && counter) begin
						next_state = run_1_l;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else if (a_on && ~Mario_counter[22]) begin
						next_state = run_2_l;
						next_counter = counter;
						Mario_counter_in = Mario_counter + 24'd1;;
				  end
				  else if (d_on) begin
						next_state = run_1_r;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  else begin
						next_state = stand_l;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
				  end
				  
			  run_3_r:
					if (is_Mario_die) begin
						next_state = die;
				   end
			      else if (is_in_air)
						next_state = jump_r;
					else if (d_on && ~Mario_counter[22]) begin
						next_state = run_3_r;
						next_counter = 1'b0;
						Mario_counter_in = Mario_counter + 24'd1;
				   end
					else if (d_on) begin
						next_state = run_2_r;
						next_counter = 1'b1;
						Mario_counter_in = 24'd0;
					end
					else if (a_on) begin
						next_state = run_1_l;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
					end
					else begin
						next_state = stand_r;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
					end
					
			  run_3_l:
				   if (is_Mario_die) begin
						next_state = die;
				   end
			      else if (is_in_air)
						next_state = jump_l;
					else if (a_on && ~Mario_counter[22]) begin
						next_state = run_3_l;
						next_counter = 1'b0;
						Mario_counter_in = Mario_counter + 24'd1;
				   end
					else if (a_on) begin
						next_state = run_2_l;
						next_counter = 1'b1;
						Mario_counter_in = 24'd0;
					end
					else if (d_on) begin
						next_state = run_1_r;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
					end
					else begin
						next_state = stand_l;
						next_counter = 1'b0;
						Mario_counter_in = 24'd0;
					end
				jump_r:
					if (is_Mario_die) begin
						next_state = die;
				   end
					else if (is_in_air)
						next_state = jump_r;
					else
						next_state = stand_r;
				jump_l:
				   if (is_Mario_die) begin
						next_state = die;
				   end
					else if (is_in_air)
						next_state = jump_l;
					else
						next_state = stand_l;
				die:
					next_state = die;
			  default: ;
		  
		  endcase
		  
		  // assign output for each state
		  case(state)
				stand_r:
					begin
						mario_dout = stand_dout;
						if (Mario_X_Pos >= 13'd6326)
							mario_dout = win_game_dout;
						//game_over = 1'b0;
					end
				run_1_r:
					begin
						mario_dout = run_1_dout;
						if (Mario_X_Pos >= 13'd6326)
							mario_dout = win_game_dout;
						//game_over = 1'b0;
					end
				run_2_r:
					begin
						mario_dout = run_2_dout;
						if (Mario_X_Pos >= 13'd6326)
							mario_dout = win_game_dout;
						//game_over = 1'b0;
					end
				run_3_r:
					begin
						mario_dout = run_3_dout;
						if (Mario_X_Pos >= 13'd6326)
							mario_dout = win_game_dout;
						//game_over = 1'd0;
					end
				stand_l:
					begin
						mario_dout = stand_l_dout;
						//game_over = 1'b0;
					end
				run_1_l:
					begin
						mario_dout = run_1_l_dout;
						//game_over = 1'b0;
					end
				run_2_l:
					begin
						mario_dout = run_2_l_dout;
						//game_over = 1'b0;
					end
				run_3_l:
					begin
						mario_dout = run_3_l_dout;
						//game_over = 1'b0;
					end
				jump_r:
					begin
						mario_dout = jump_dout;
						if (Mario_X_Pos >= 13'd6326)
							mario_dout = win_game_dout;
						//game_over = 1'b0;
					end
				jump_l:
					begin
						mario_dout = jump_l_dout;
						//game_over = 1'b0;
					end
				die:
					begin
						mario_dout = die_dout;
						//game_over = 1'b1;
					end
				default:
					begin
						mario_dout = stand_dout;
						//game_over = 1'b0;
					end
		  
		  endcase
	 
	 end
	 
endmodule
