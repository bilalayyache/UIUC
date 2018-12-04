module coin_movement
							#(parameter X_Start = 13'd320;
							  parameter Y_Start = 13'd240)
							
							(input       Clk,                // 50 MHz clock
											 Reset,              // Active-high reset signal
											 frame_clk,          // The clock indicating a new frame (~60Hz)
											 collision,
							 output logic [12:0] coin_X_Pos, coin_Y_Pos,
							 output logic [3:0] state_number
);

    
    logic [12:0] coin_X_Motion, coin_Y_Motion;
    logic [12:0] coin_X_Pos_in, coin_X_Motion_in, coin_Y_Pos_in, coin_Y_Motion_in;
	 logic [3:0] state_number_in;
    
	 enum logic [3:0] {start, jump, in_air, disappear} state, next_state;
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
				coin_X_Pos <= X_Start;
				coin_Y_Pos <= Y_Start;
            coin_X_Motion <= 13'd0;
            coin_Y_Motion <= 13'd0;
				state_number <= 4'd0;
				state <= start;
        end
		  else 
        begin
            coin_X_Pos <= coin_X_Pos_in;
            coin_Y_Pos <= coin_Y_Pos_in;
            coin_X_Motion <= coin_X_Motion_in;
            coin_Y_Motion <= coin_Y_Motion_in;
				state <= next_state;
				state_number <= state_number_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
	always_comb
	begin
		coin_X_Pos_in = coin_X_Pos;
		coin_Y_Pos_in = coin_Y_Pos;
		coin_X_Motion_in = coin_X_Motion;
		coin_Y_Motion_in = coin_Y_Motion;
		next_state = state;
		state_number_in = state_number;
		
		if (frame_clk_rising_edge)
		begin
			unique case (state)
				start:
				begin
				state_number_in = 4'b1000;
					if (collision) begin
						next_state = jump;
						state_number_in = 4'b0100;
					end
					else
						next_state = start;
				end
				
				jump:
				begin
					next_state = in_air;
					coin_Y_Motion_in = ~(13'd14) + 1'd1;
					state_number_in = 4'b0010;
				end
				
				in_air:
				begin
					if (coin_Y_Pos >= Y_Start + 13'd32) begin
						next_state = disappear;
						coin_Y_Motion_in = 13'd0;
						state_number_in = 4'b0001;
					end
					else begin
						next_state = in_air;
						coin_Y_Motion_in = coin_Y_Motion + 13'd1;;
						state_number_in = 4'b0010;
					end
				end
				
				disappear:
				begin
					next_state = disappear;
					coin_Y_Motion_in = 13'd0;
					coin_X_Pos_in = 13'd320;
					coin_Y_Pos_in = 13'd240;
					state_number_in = 4'b0001;
				end
			
				default:;
			endcase
			coin_X_Pos_in = coin_X_Pos + coin_X_Motion;
			coin_Y_Pos_in = coin_Y_Pos + coin_Y_Motion;
		end
//        // By default, keep motion and position unchanged
//        coin_X_Pos_in = coin_X_Pos;
//        coin_Y_Pos_in = coin_Y_Pos;
//        coin_X_Motion_in = coin_X_Motion;
//        coin_Y_Motion_in = coin_Y_Motion;
//		  next_state = state;
//		  
//		  // Update position and motion only at rising edge of frame clock
//		  if (frame_clk_rising_edge)
//        begin
//				unique case (state)
//					start:
//					begin
//						if (collision) begin
//							next_state = jump;
//						end
//						else begin
//							next_state = start;
//							coin_X_Pos_in = X_Start;
//							coin_Y_Pos_in = Y_Start;
//							coin_X_Motion_in = 13'b0;
//							coin_Y_Motion_in = 13'd0;
//						end
//					end
//					
//					jump:
//					begin
//						next_state = in_air;
//						coin_Y_Motion_in = ~(13'd15) + 1'd1;
//					end
//					
//					in_air:
//					begin
//						coin_Y_Motion_in = coin_Y_Motion + 1'd1;
//						//if (coin_Y_Pos < Y_Start)
//						if (coin_Y_Pos < 13'd288)
//							next_state = in_air;
//						else
//							next_state = disappear;
//					end
//					
//					disappear:
//					begin
//						coin_Y_Pos_in = 13'd0;
//						coin_X_Pos_in = 13'd0;
//						coin_X_Motion_in = 13'd1;
//						coin_Y_Motion_in = 13'd0;
//						next_state = disappear;
//					end
//
//					default:;
//				endcase
//				
//				
//				
//				coin_X_Pos_in = coin_X_Pos + coin_X_Motion;
//				coin_Y_Pos_in = coin_Y_Pos + coin_Y_Motion;
//		  end
        
        /**************************************************************************************
            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
            Hidden Question #2/2:
               Notice that Goomba_Y_Pos is updated using Goomba_Y_Motion. 
              Will the new value of Goomba_Y_Motion be used when Goomba_Y_Pos is updated, or the old? 
              What is the difference between writing
                "Goomba_Y_Pos_in = Goomba_Y_Pos + Goomba_Y_Motion;" and 
                "Goomba_Y_Pos_in = Goomba_Y_Pos + Goomba_Y_Motion_in;"?
              How will this impact behavior of the Goomba during a bounce, and how might that interact with a response to a keypress?
              Give an answer in your Post-Lab.
        **************************************************************************************/
    end					 
endmodule
