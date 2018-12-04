//-------------------------------------------------------------------------
//    Mario.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  mario ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [12:0]   DrawX, DrawY,       // Current pixel coordinates
					// input [7:0] keycode,
					input [23:0] stand_dout, run_1_dout, run_2_dout, run_3_dout, jump_dout, jump_l_dout,
									 stand_l_dout, run_1_l_dout, run_2_l_dout, run_3_l_dout, die_dout, win_game_dout,
					input space_on, a_on, s_on, d_on,is_Mario_die,  // keycode from keyboard
               output logic  is_Mario,            // Whether current pixel belongs to Mario or background
					output logic [12:0] Mario_X_Pos, Mario_Y_Pos, process, Mario_Y_Motion,
					output logic [23:0] mario_dout,
					output logic is_in_air
              );
    
	 //logic is_in_air;
	 mario_image mario_image_instance(.*);
	 mario_movement mario_movement_instance(.*);
	 always_comb begin
        if ( Mario_X_Pos <= process + DrawX && DrawX + process < Mario_X_Pos +13'd32 && DrawY >= Mario_Y_Pos && DrawY < Mario_Y_Pos + 13'd32) 
            is_Mario = 1'b1;
        else
            is_Mario = 1'b0;
        /* The Mario's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end
    
endmodule
//	 
//    // parameter [9:0] Mario_X_Center = 10'd320;  // Center position on the X axis
//    // parameter [9:0] Mario_Y_Center = 10'd240;  // Center position on the Y axis
//    parameter [12:0] Mario_X_Min = 13'd0;       // Leftmost point on the X axis
//    parameter [12:0] Mario_X_Max = 13'd6783;     // Rightmost point on the X axis (total 212 blocks on the ground)
//    parameter [12:0] Mario_Y_Min = 13'd0;       // Topmost point on the Y axis
//    parameter [12:0] Mario_Y_Max = 13'd479;     // Bottommost point on the Y axis
//    parameter [12:0] Mario_X_Step = 13'd2;      // Step size on the X axis
//	 // mario has jump initial velocity 3 and it will decrease 1 for each cycle until mario back to ground
//	 parameter [12:0] Mario_Y_V = 13'd3;
//    parameter [12:0] Mario_Y_Step = 13'd1;      // Step size on the Y axis
//
//    parameter [12:0] Mario_Size = 13'd32;        // Mario size
//    
//    logic [12:0] Mario_X_Motion, Mario_Y_Motion;
//    logic [12:0] Mario_X_Pos_in, Mario_X_Motion_in, Mario_Y_Pos_in, Mario_Y_Motion_in;
//	 logic [12:0] process_in;
//	 // Mario_counter is used to slow down the motion of Mario and counter is used to determine the next state
//    logic [23:0] Mario_counter, Mario_counter_in;
//	 // FSM:
//	 enum logic [3:0] {stand_r, run_1_r, run_2_r, run_3_r,
//							 stand_l, run_1_l, run_2_l, run_3_l} state, next_state;
//	 logic counter, next_counter;
//	 // leycode input
//	 logic [3:0] keycode;
//	 assign keycode = {space_on, a_on, s_on, d_on};
//	 
//	 
//    //////// Do not modify the always_ff blocks. ////////
//    // Detect rising edge of frame_clk
//    logic frame_clk_delayed, frame_clk_rising_edge;
//    always_ff @ (posedge Clk) begin
//        frame_clk_delayed <= frame_clk;
//        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
//    end
//	 
//    // Update registers
//    always_ff @ (posedge Clk)
//    begin
//        if (Reset)
//        begin
//            Mario_X_Pos <= 13'd80;
//            Mario_Y_Pos <= 13'd384;//Mario_Y_Center;
//            Mario_X_Motion <= 13'd0;
//            Mario_Y_Motion <= 13'd0;
//				process <= 13'd0;
//				
//				// FSM control
//				state <= stand_r;
//				counter <= 1'b0;
//				Mario_counter <= 24'd0;
//		
//
//        end
//        else
//        begin
//            Mario_X_Pos <= Mario_X_Pos_in;
//            Mario_Y_Pos <= Mario_Y_Pos_in;
//            Mario_X_Motion <= Mario_X_Motion_in;
//            Mario_Y_Motion <= Mario_Y_Motion_in;
//				process <= process_in;
//				// FSM
//				state <= next_state;
//				counter <= next_counter;
//				Mario_counter <= Mario_counter_in;
//				
//        end
//    end
//    //////// Do not modify the always_ff blocks. ////////
//    
//	 // check whether mario is in air ornot
//	 logic is_in_air;
//	 IS_IN_AIR is_in_air_instance(.*);
//	 
//    // You need to modify always_comb block.
//    always_comb
//    begin
//        // By default, keep motion and position unchanged
//        Mario_X_Pos_in = Mario_X_Pos;
//        Mario_Y_Pos_in = Mario_Y_Pos;
//        Mario_X_Motion_in = Mario_X_Motion;
//        Mario_Y_Motion_in = Mario_Y_Motion;
//		  process_in = process;
//
//		  // Update position and motion only at rising edge of frame clock
//		  if (frame_clk_rising_edge)
//        begin
//		      unique case (keycode)
//			   // if (space_on)
//			   4'b1000:
//					// space is pressed
//				begin
//					// first, we need to check whether mario is at grounud or not
//					// if mario is at ground, whenwe press space, mario should have an initial y velocity 3 and decrease by 1 in each cycle
//					// remember in VGA, y is counting down. Therefore the initial v is negative
//					// when mario is not at ground, we need to ignore the key press for space
//					// to check whether mario is at ground, 
//					Mario_X_Motion_in = 13'd0;
//					Mario_Y_Motion_in = 13'd0;
//						/*
//							if (Mario_Y_Pos + Mario_Size >= 10'd416)
//								Mario_Y_Motion_in = (~Mario_Y_Step)+10'd1;
//							else if (Mario_Y_Pos + Mario_Size + Mario_Y_Motion_in >= 10'd384)
//								Mario_Y_Pos_in = 10'd380;
//							else
//								Mario_Y_Motion_in = Mario_Y_Motion+10'd1;
//							/*
//							Mario_X_Motion_in = 10'd0;
//							Mario_Y_Motion_in = (~(Mario_Y_Step) + 1'b1);
//							if ( Mario_Y_Pos <= Mario_Y_Min + Mario_Size )
//								Mario_Y_Motion_in = Mario_Y_Step;
//							*/
//				end
//					
//				// if (s_on)
//				4'b0010:
//					// S is pressed
//				begin
//					Mario_X_Motion_in = 13'd0;
//					Mario_Y_Motion_in = 13'd0;
//							/*
//							Mario_Y_Motion_in = Mario_Y_Step;
//							if (Mario_Y_Pos + Mario_Size >= 10'd384)
//								Mario_Y_Motion_in = 10'd0;//(~(Mario_Y_Step) + 1'b1);
//								*/
//				end
//
//				// if (a_on)
//				4'b0100:
//					// A is pressed
//				begin
//					Mario_Y_Motion_in = 13'd0;
//					Mario_X_Motion_in = (~(Mario_X_Step) + 1'b1);
//					if ( Mario_X_Pos <= process + 13'd1 )
//						Mario_X_Motion_in = 13'd0;
//				end
//		 
//				// if (d_on)
//				4'b0001:
//					// D
//				begin
//					Mario_Y_Motion_in = 13'd0;
//					Mario_X_Motion_in = Mario_X_Step;
//					if (Mario_X_Pos + Mario_Size >= Mario_X_Max)
//						Mario_X_Motion_in = 13'd0;
//							//else if (Mario_X_Pos>=13'd400 + process)
//							//	Mario_X_Motion_in = 13'd0;
//				end
//						
//				default:
//					/*
//						if (Mario_Y_Pos <= Mario_Y_Min + Mario_Size)
//						begin
//							if (Mario_X_Motion != 10'd0)
//								Mario_Y_Motion_in = 10'd0;
//							else
//								Mario_Y_Motion_in = Mario_Y_Step;
//						end
//						
//						else if (Mario_Y_Pos + Mario_Size >= Mario_Y_Max)
//						begin
//							if (Mario_X_Motion != 10'd0)
//								Mario_Y_Motion_in = 10'd0;
//							else
//								Mario_Y_Motion_in = (~(Mario_Y_Step) + 1'b1);
//						end
//						
//						else if ( Mario_X_Pos <= Mario_X_Min + Mario_Size )
//						begin
//							if (Mario_Y_Motion != 10'd0)
//								Mario_X_Motion_in = 10'd0;
//							else
//								Mario_X_Motion_in = Mario_X_Step;
//						end
//
//						else if (Mario_X_Pos + Mario_Size >= Mario_X_Max)
//						begin
//							if (Mario_Y_Motion != 10'd0)
//								Mario_X_Motion_in = 10'd0;
//							else
//								Mario_X_Motion_in = (~(Mario_X_Step) + 1'b1);
//						end
//						*/
//					begin
//						Mario_Y_Motion_in = 13'd0;
//						Mario_X_Motion_in = 13'd0;
//					end
//				endcase
//        
//
//				// Be careful when using comparators with "logic" datatype because compiler treats 
//				//   both sides of the operator as UNSIGNED numbers.
//				// e.g. Mario_Y_Pos - Mario_Size <= Mario_Y_Min 
//				// If Mario_Y_Pos is 0, then Mario_Y_Pos - Mario_Size will not be -4, but rather a large positive number.
//				//if( Mario_Y_Pos + Mario_Size >= Mario_Y_Max )  // Mario is at the bottom edge, BOUNCE!
//				//		Mario_Y_Motion_in = (~(Mario_Y_Step) + 1'b1);  // 2's complement.  
//				//else if ( Mario_Y_Pos <= Mario_Y_Min + Mario_Size )  // Mario is at the top edge, BOUNCE!
//				//		Mario_Y_Motion_in = Mario_Y_Step;
//				// TODO: Add other boundary detections and handle keypress here.
//				
//				
//				// Update the Mario's position with its motion
//				Mario_X_Pos_in = Mario_X_Pos + Mario_X_Motion;
//				Mario_Y_Pos_in = Mario_Y_Pos + Mario_Y_Motion;
//				
//				
//				// scroll the screen
//				if (Mario_X_Pos >= process + 13'd320)
//				begin
//					if (Mario_X_Motion[12] == 1'b0)
//					begin
//						process_in = process + Mario_X_Motion;
//					end
//				end
//				
//				// check the end position, stop screen scroll
//				if (process + 13'd640 >= Mario_X_Max)
//				begin
//					process_in = process;
//				end
//				
//		  end
//        
//        /**************************************************************************************
//            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
//            Hidden Question #2/2:
//               Notice that Mario_Y_Pos is updated using Mario_Y_Motion. 
//              Will the new value of Mario_Y_Motion be used when Mario_Y_Pos is updated, or the old? 
//              What is the difference between writing
//                "Mario_Y_Pos_in = Mario_Y_Pos + Mario_Y_Motion;" and 
//                "Mario_Y_Pos_in = Mario_Y_Pos + Mario_Y_Motion_in;"?
//              How will this impact behavior of the Mario during a bounce, and how might that interact with a response to a keypress?
//              Give an answer in your Post-Lab.
//        **************************************************************************************/
//    end
//    
//
//	 // FSM control (next state logic
//	 always_comb begin
//		  // FSM control
//		  next_state = state;
//		  next_counter = counter;
//		  Mario_counter_in = Mario_counter;
//		  
//		  unique case (state)
//		     stand_r:
//			     if (d_on) begin
//						next_state = run_1_r;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else if (a_on) begin
//						next_state = run_1_l;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else begin
//						next_state = stand_r;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  
//			  stand_l:
//			     if (d_on) begin
//						next_state = run_1_r;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else if (a_on) begin
//						next_state = run_1_l;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else begin
//						next_state = stand_l;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//			  
//			  run_1_r:
//			     if (d_on && Mario_counter[22]) begin
//						next_state = run_2_r;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else if (d_on) begin
//						next_state = run_1_r;
//						next_counter = 1'b0;
//						Mario_counter_in = Mario_counter + 1'b1;
//				  end
//				  // turn around case
//				  else if (a_on) begin
//						next_state = run_1_l;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else begin
//						next_state = stand_r;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  
//			  run_1_l:
//			     if (a_on && Mario_counter[22]) begin
//						next_state = run_2_l;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else if (a_on) begin
//						next_state = run_1_l;
//						next_counter = 1'b0;
//						Mario_counter_in = Mario_counter + 1'b1;
//				  end
//				  // turn around case
//				  else if (d_on) begin
//						next_state = run_1_r;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else begin
//						next_state = stand_l;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  
//			  run_2_r:
//				  if (d_on && Mario_counter[22] && ~counter) begin
//						next_state = run_3_r;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else if (d_on && Mario_counter[22] && counter) begin
//						next_state = run_1_r;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else if (d_on && ~Mario_counter[22]) begin
//						next_state = run_2_r;
//						next_counter = counter;
//						Mario_counter_in = Mario_counter + 24'd1;;
//				  end
//				  else if (a_on) begin
//						next_state = run_1_l;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else begin
//						next_state = stand_r;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  
//			  run_2_l:
//				  if (a_on && Mario_counter[22] && ~counter) begin
//						next_state = run_3_l;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else if (a_on && Mario_counter[22] && counter) begin
//						next_state = run_1_l;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else if (a_on && ~Mario_counter[22]) begin
//						next_state = run_2_l;
//						next_counter = counter;
//						Mario_counter_in = Mario_counter + 24'd1;;
//				  end
//				  else if (d_on) begin
//						next_state = run_1_r;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  else begin
//						next_state = stand_l;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//				  end
//				  
//			  run_3_r:
//					if (d_on && ~Mario_counter[22]) begin
//						next_state = run_3_r;
//						next_counter = 1'b0;
//						Mario_counter_in = Mario_counter + 24'd1;
//				   end
//					else if (d_on) begin
//						next_state = run_2_r;
//						next_counter = 1'b1;
//						Mario_counter_in = 24'd0;
//					end
//					else if (a_on) begin
//						next_state = run_1_l;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//					end
//					else begin
//						next_state = stand_r;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//					end
//					
//			  run_3_l:
//					if (a_on && ~Mario_counter[22]) begin
//						next_state = run_3_l;
//						next_counter = 1'b0;
//						Mario_counter_in = Mario_counter + 24'd1;
//				   end
//					else if (a_on) begin
//						next_state = run_2_l;
//						next_counter = 1'b1;
//						Mario_counter_in = 24'd0;
//					end
//					else if (d_on) begin
//						next_state = run_1_r;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//					end
//					else begin
//						next_state = stand_l;
//						next_counter = 1'b0;
//						Mario_counter_in = 24'd0;
//					end
//			  default: ;
//		  
//		  endcase
//		  
//		  // assign output for each state
//		  case(state)
//				stand_r:
//					mario_dout = stand_dout;
//				run_1_r:
//					mario_dout = run_1_dout;
//				run_2_r:
//					mario_dout = run_2_dout;
//				run_3_r:
//					mario_dout = run_3_dout;
//				stand_l:
//					mario_dout = stand_l_dout;
//				run_1_l:
//					mario_dout = run_1_l_dout;
//				run_2_l:
//					mario_dout = run_2_l_dout;
//				run_3_l:
//					mario_dout = run_3_l_dout;
//				default:
//					mario_dout = stand_dout;
//		  
//		  endcase
//	 
//	 end
    // Compute whether the pixel corresponds to Mario or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    // int DistX, DistY, Size;
    // assign DistX = DrawX - Mario_X_Pos;
    // assign DistY = DrawY - Mario_Y_Pos;
    // assign Size = Mario_Size;
//    always_comb begin
//        if ( Mario_X_Pos <= process + DrawX && DrawX + process < Mario_X_Pos +13'd32 && DrawY >= Mario_Y_Pos && DrawY < Mario_Y_Pos + 13'd32) 
//            is_Mario = 1'b1;
//        else
//            is_Mario = 1'b0;
//        /* The Mario's (pixelated) circle is generated using the standard circle formula.  Note that while 
//           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
//           of the 12 available multipliers on the chip! */
//    end
//    
//endmodule
