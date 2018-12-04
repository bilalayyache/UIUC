module game_controller
								(input Clk, Reset, enter_on,
								       is_Mario_die, is_win,
								 output logic [6:0] image_show,
								 output logic reset_game,
								 output logic win_game);
	
	
	logic [3:0] game_counter, game_counter_in;
	logic [29:0] timer, timer_in;
	enum logic [3:0] {start, game, remain_3, remain_2, remain_1, win, game_over} state, next_state;
	
	
	always_ff @(posedge Clk) begin
		if (Reset) begin
			state <= start;
			game_counter <= 4'b0;
			timer <= 30'd0;
		end
		else begin
			state <= next_state;
			game_counter <= game_counter_in;
			timer <= timer_in;
		end
	
	end
	
	always_comb begin
		game_counter_in = game_counter;
		next_state = state;
		reset_game = 1'b0;
		win_game = 1'b0;
		timer_in = timer;
		unique case (state)
			start:
				begin
					if (enter_on) begin
						next_state = remain_3;
						game_counter_in = 4'b0;
					end
				end
			
			remain_3:
				begin
					if ( timer[26] ) begin
						next_state = game;
						game_counter_in = 4'b0;
						timer_in = 30'd0;
					end
					else
						begin
							next_state = remain_3;
							timer_in = timer + 30'd1;
						end
				end
				
			remain_2:
				begin
					if ( timer[26] ) begin
						next_state = game;
						game_counter_in = 4'd1;
						timer_in = 30'd0;
					end
					else
						begin
							next_state = remain_2;
							timer_in = timer + 30'd1;
						end
				end
			
			remain_1:
				begin
					if (timer[26] ) begin
						next_state = game;
						game_counter_in = 4'd2;
						timer_in = 30'd0;
					end
					else
						begin
							next_state = remain_1;
							timer_in = timer + 30'd1;
						end
				end
				
			game:
				begin
					if (is_Mario_die && timer[26] ) begin
						case (game_counter)
							4'b0000:
								begin
									next_state = remain_2;
									timer_in = 30'd0;
								end
							4'b0001:
								begin
									next_state = remain_1;
									timer_in = 30'd0;
								end
							4'b0010:
								begin
									next_state = game_over;
									timer_in = 30'd0;
								end
							default:;
						endcase
					end
					else if (is_Mario_die) 
						begin
							next_state = game;
							timer_in = timer + 30'd1;
						end
				
					else if (is_win) begin
						next_state = win;
					end
				end
				
			win:
				begin
					next_state = win;
					
				end
			default:;
		endcase
		
		case (state)
			start:
			begin
				image_show = 7'b1000000;
				reset_game = 1'b1;
			end
			remain_3:
			begin
				reset_game = 1'b1;
				image_show = 7'b0100000;
			end
			remain_2:
			begin
				reset_game = 1'b1;
				image_show = 7'b0010000;
			end
			remain_1:
			begin
				reset_game = 1'b1;
				image_show = 7'b0001000;
			end
			game:
				image_show = 7'b0000100;
			game_over:
			begin
				image_show = 7'b0000010;
				reset_game = 1'b1;
			end
			win:
			begin
				image_show = 7'b0000001;
				reset_game = 1'b1;
				win_game = 1'b1;
			end
			default:
				image_show = 7'b1000000;
		endcase
	
	end
								
								
endmodule
