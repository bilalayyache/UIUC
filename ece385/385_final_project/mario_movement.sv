module mario_movement(input       Clk,                // 50 MHz clock
											 Reset,              // Active-high reset signal
											 frame_clk,          // The clock indicating a new frame (~60Hz)
							 input logic space_on, a_on, s_on, d_on,
							 input logic is_Mario_die,
							 output logic [12:0] Mario_X_Pos, Mario_Y_Pos, process, Mario_Y_Motion,
							 output logic is_in_air);

	
	 parameter [12:0] Mario_X_Min = 13'd0;       // Leftmost point on the X axis
    parameter [12:0] Mario_X_Max = 13'd6783;     // Rightmost point on the X axis (total 212 blocks on the ground)
    parameter [12:0] Mario_Y_Min = 13'd0;       // Topmost point on the Y axis
    parameter [12:0] Mario_Y_Max = 13'd479;     // Bottommost point on the Y axis
    parameter [12:0] Mario_X_Step = 13'd2;      // Step size on the X axis
	 // mario has jump initial velocity 3 and it will decrease 1 for each cycle until mario back to ground
	 parameter [12:0] Mario_Y_V = 13'd3;
    parameter [12:0] Mario_Y_Step = 13'd1;      // Step size on the Y axis

    parameter [12:0] Mario_Size = 13'd32;        // Mario size
    
    logic [12:0] Mario_X_Motion, level;
    logic [12:0] Mario_X_Pos_in, Mario_X_Motion_in, Mario_Y_Pos_in, Mario_Y_Motion_in;
	 logic [12:0] process_in;
	
	 logic [23:0] Mario_counter, Mario_counter_in;
	 // set a flag to perform jump once action
	 logic flag, flag_in;
	 //logic is_in_air;
	 // is_in_air check
	 IS_IN_AIR is_in_air_instance(.*);
    
	 enum logic [3:0] {STAND, RUN, RUN_1_R, RUN_2_R, RUN_3_R,
							 RUN_1_L, RUN_2_L, RUN_3_L, JUMP_1, IN_AIR, DIE} STATE, NEXT_STATE;

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
            Mario_X_Pos <= 13'd80;
            Mario_Y_Pos <= 13'd384;//Mario_Y_Center;
            Mario_X_Motion <= 13'd0;
            Mario_Y_Motion <= 13'd0;
				process <= 13'd0;
				// FSM control
				STATE <= STAND;
				Mario_counter <= 24'b0;
				flag <= 1'b0;
        end
        else
        begin
            Mario_X_Pos <= Mario_X_Pos_in;
            Mario_Y_Pos <= Mario_Y_Pos_in;
            Mario_X_Motion <= Mario_X_Motion_in;
            Mario_Y_Motion <= Mario_Y_Motion_in;
				process <= process_in;
				// FSM
				STATE <= NEXT_STATE;
				Mario_counter <= Mario_counter_in;
				flag <= flag_in;
        end
    end
	
	 always_comb
    begin
        // By default, keep motion and position unchanged
        Mario_X_Pos_in = Mario_X_Pos;
        Mario_Y_Pos_in = Mario_Y_Pos;
        Mario_X_Motion_in = Mario_X_Motion;
        Mario_Y_Motion_in = Mario_Y_Motion;
		  process_in = process;
		 
		  // FSM
		  NEXT_STATE = STATE;
		  flag_in = flag;
		  Mario_counter_in = Mario_counter;
		  
		  if (frame_clk_rising_edge)
        begin
				unique case (STATE)
					STAND:
						begin
						   // Mario_Y_Pos_in = 13'd384;
							Mario_X_Motion_in = 13'd0;
							Mario_Y_Motion_in = 13'd0;
							
							Mario_counter_in = 24'b0;
							if (is_Mario_die) begin
								NEXT_STATE = DIE;
								Mario_X_Motion_in = 13'd0;
								Mario_Y_Motion_in = ~(13'd15) + 1'd1;
							end
							else if (space_on && ~flag) begin
								NEXT_STATE = JUMP_1;
								flag_in = 1'b1;
							end
							else if (d_on) begin
								flag_in = 1'b0;
								NEXT_STATE = RUN_1_R;
							end
							else if (a_on) begin
								flag_in = 1'b0;
								NEXT_STATE = RUN_1_L;
							end
							else if (~space_on) begin
								NEXT_STATE = STAND;
								flag_in = 1'b0;
							end
							else begin
								flag_in = flag;
								NEXT_STATE = STAND;
							end
						end
					
					RUN_1_R:
						begin
							Mario_X_Motion_in = 13'd1;
							Mario_Y_Motion_in = 13'd0;
							flag_in = flag;
							Mario_counter_in = 24'b0;
							if (Mario_X_Pos_in + Mario_Size >= Mario_X_Max)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos_in + Mario_Size >= 13'd896 && Mario_X_Pos  <= 13'd928 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd5216  && Mario_X_Pos  < 13'd5248 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd5728  && Mario_X_Pos  < 13'd5760 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd1216  && Mario_X_Pos  < 13'd1248 && Mario_Y_Pos +Mario_Size > 13'd320)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd1472  && Mario_X_Pos  < 13'd1504 && Mario_Y_Pos +Mario_Size > 13'd288)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd1824  && Mario_X_Pos  < 13'd1856 && Mario_Y_Pos +Mario_Size > 13'd288)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd6336 && Mario_X_Pos  <= 13'd6352 && Mario_Y_Pos +Mario_Size > 13'd374)
								Mario_X_Motion_in = 13'd0;
							if (~space_on)
								flag_in = 1'b0;
							if (is_Mario_die) begin
								NEXT_STATE = DIE;
								Mario_X_Motion_in = 13'd0;
								Mario_Y_Motion_in = ~(13'd15) + 1'd1;
							end
							else if (is_in_air)
								NEXT_STATE = IN_AIR;
							else if (space_on && ~flag) begin
								NEXT_STATE = JUMP_1;
								flag_in = 1'b1;
							end
							else if (d_on && Mario_counter[3])begin
								NEXT_STATE = RUN_2_R;
							end
							else if (d_on && ~Mario_counter[3]) begin
								NEXT_STATE = RUN_1_R;
								Mario_counter_in = Mario_counter + 1'd1;
							end
							else begin
								NEXT_STATE = STAND;
							end
						end
						
					RUN_2_R:
						begin
							Mario_X_Motion_in = 13'd2;
							Mario_Y_Motion_in = 13'd0;
							Mario_counter_in = 24'd0;
							flag_in = flag;
							if (Mario_X_Pos + Mario_Size >= Mario_X_Max)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd896 && Mario_X_Pos  <= 13'd928 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd5216  && Mario_X_Pos  < 13'd5248 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd5728  && Mario_X_Pos  < 13'd5760 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd1216  && Mario_X_Pos  < 13'd1248 && Mario_Y_Pos +Mario_Size > 13'd320)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd1472  && Mario_X_Pos  < 13'd1504 && Mario_Y_Pos +Mario_Size > 13'd288)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd1824  && Mario_X_Pos  < 13'd1856 && Mario_Y_Pos +Mario_Size > 13'd288)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd6336 && Mario_X_Pos  <= 13'd6352 && Mario_Y_Pos +Mario_Size > 13'd374)
								Mario_X_Motion_in = 13'd0;
							if (~space_on) begin
								flag_in = 1'b0;
							end
							if (is_Mario_die) begin
								NEXT_STATE = DIE;
								Mario_X_Motion_in = 13'd0;
								Mario_Y_Motion_in = ~(13'd15) + 1'd1;
							end
							else if (is_in_air)
								NEXT_STATE = IN_AIR;
							else if (space_on && ~flag) begin
								NEXT_STATE = JUMP_1;
								flag_in = 1'b1;
							end
							else if (d_on && Mario_counter[3])begin
								NEXT_STATE = RUN_3_R;
							end
							else if (d_on && ~Mario_counter[3]) begin
								NEXT_STATE = RUN_2_R;
								Mario_counter_in = Mario_counter + 1'd1;
							end
							else begin
								NEXT_STATE = STAND;
							end
						end
					
					RUN_3_R:
						begin
							Mario_X_Motion_in = 13'd4;
							Mario_Y_Motion_in = 13'd0;
							Mario_counter_in = 24'd0;
							flag_in = flag;
							if (Mario_X_Pos + Mario_Size >= Mario_X_Max)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd896 && Mario_X_Pos  <= 13'd928 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd5216  && Mario_X_Pos  < 13'd5248 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd5728  && Mario_X_Pos  < 13'd5760 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd1216  && Mario_X_Pos  < 13'd1248 && Mario_Y_Pos +Mario_Size > 13'd320)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd1472  && Mario_X_Pos  < 13'd1504 && Mario_Y_Pos +Mario_Size > 13'd288)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd1824  && Mario_X_Pos  < 13'd1856 && Mario_Y_Pos +Mario_Size > 13'd288)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd6336 && Mario_X_Pos  <= 13'd6352 && Mario_Y_Pos +Mario_Size > 13'd374)
								Mario_X_Motion_in = 13'd0;
							if (~space_on)
								flag_in = 1'b0;
							if (is_Mario_die) begin
								NEXT_STATE = DIE;
								Mario_X_Motion_in = 13'd0;
								Mario_Y_Motion_in = ~(13'd15) + 1'd1;
							end
							else if (is_in_air)
								NEXT_STATE = IN_AIR;
							else if (space_on && ~flag) begin
								NEXT_STATE = JUMP_1;
								flag_in = 1'b1;
							end
							else if (d_on) begin
								NEXT_STATE = RUN_3_R;
							end
							else begin
								NEXT_STATE = RUN_1_R;
							end
						end

					RUN_1_L:
						begin
							Mario_X_Motion_in = (~(13'd1) + 1'b1);
							Mario_Y_Motion_in = 13'd0;
							flag_in = flag;
							Mario_counter_in = 24'd0;
							if (Mario_X_Pos + Mario_X_Motion <= 13'd1)
								Mario_X_Motion_in = 13'd0;
							if ( Mario_X_Pos <= process + 13'd1 )
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd928 && Mario_X_Pos  <= 13'd960 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd5248  && Mario_X_Pos  < 13'd5280 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd5760  && Mario_X_Pos  < 13'd5792 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd1248  && Mario_X_Pos  < 13'd1280 && Mario_Y_Pos +Mario_Size > 13'd320)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd1504  && Mario_X_Pos  < 13'd1536 && Mario_Y_Pos +Mario_Size > 13'd288)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd1856  && Mario_X_Pos  < 13'd1888 && Mario_Y_Pos +Mario_Size > 13'd288)
								Mario_X_Motion_in = 13'd0;
							if (~space_on) begin
								flag_in = 1'b0;
							end
							if (is_Mario_die) begin
								NEXT_STATE = DIE;
								Mario_X_Motion_in = 13'd0;
								Mario_Y_Motion_in = ~(13'd15) + 1'd1;
							end
							else if (is_in_air)
								NEXT_STATE = IN_AIR;
							else if (space_on && ~flag) begin
								NEXT_STATE = JUMP_1;
								flag_in = 1'b1;
							end
							else if (a_on && Mario_counter[4])begin
								NEXT_STATE = RUN_2_L;
								end
							else if (a_on && ~Mario_counter[4]) begin
								NEXT_STATE = RUN_1_L;
								Mario_counter_in = Mario_counter + 1'd1;
							end
							else begin
								NEXT_STATE = STAND;
							end
						end
						
					RUN_2_L:
						begin
							Mario_X_Motion_in = (~(13'd2) + 1'b1);
							Mario_Y_Motion_in = 13'd0;
							Mario_counter_in = 24'd0;
							flag_in = flag;
							if (Mario_X_Pos + Mario_X_Motion <= 13'd1)
								Mario_X_Motion_in = 13'd0;
							if ( Mario_X_Pos <= process + 13'd1 )
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd928 && Mario_X_Pos  <= 13'd960 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd5248  && Mario_X_Pos  < 13'd5280 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd5760  && Mario_X_Pos  < 13'd5792 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd1248  && Mario_X_Pos  < 13'd1280 && Mario_Y_Pos +Mario_Size > 13'd320)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd1504  && Mario_X_Pos  < 13'd1536 && Mario_Y_Pos +Mario_Size > 13'd288)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd1856  && Mario_X_Pos  < 13'd1888 && Mario_Y_Pos +Mario_Size > 13'd288)
								Mario_X_Motion_in = 13'd0;
							if (~space_on) begin
								flag_in = 1'b0;
							end
							if (is_Mario_die) begin
								NEXT_STATE = DIE;
								Mario_X_Motion_in = 13'd0;
								Mario_Y_Motion_in = ~(13'd15) + 1'd1;
							end
							else if (is_in_air)
								NEXT_STATE = IN_AIR;
							else if (space_on && ~flag) begin
								NEXT_STATE = JUMP_1;
								flag_in = 1'b1;
							end
							else if (a_on && Mario_counter[3])begin
								NEXT_STATE = RUN_3_L;
							end
							else if (a_on && ~Mario_counter[3]) begin
								NEXT_STATE = RUN_2_L;
								Mario_counter_in = Mario_counter + 1'd1;
							end
							else begin
								NEXT_STATE = STAND;
							end
						end
					
					RUN_3_L:
						begin
							Mario_X_Motion_in = (~(13'd3) + 1'b1);
							Mario_Y_Motion_in = 13'd0;
							flag_in = flag;
							if (Mario_X_Pos + Mario_X_Motion <= 13'd1)
								Mario_X_Motion_in = 13'd0;
							if ( Mario_X_Pos <= process + 13'd3 )
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size >= 13'd928 && Mario_X_Pos  <= 13'd960 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd5248  && Mario_X_Pos  < 13'd5280 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd5760  && Mario_X_Pos  < 13'd5792 && Mario_Y_Pos +Mario_Size > 13'd352)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd1248  && Mario_X_Pos  < 13'd1280 && Mario_Y_Pos +Mario_Size > 13'd320)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd1504  && Mario_X_Pos  < 13'd1536 && Mario_Y_Pos +Mario_Size > 13'd288)
								Mario_X_Motion_in = 13'd0;
							if (Mario_X_Pos + Mario_Size > 13'd1856  && Mario_X_Pos  < 13'd1888 && Mario_Y_Pos +Mario_Size > 13'd288)
								Mario_X_Motion_in = 13'd0;
							if (~space_on) begin
								flag_in = 1'b0;
							end
							if (is_Mario_die) begin
								NEXT_STATE = DIE;
								Mario_X_Motion_in = 13'd0;
								Mario_Y_Motion_in = ~(13'd15) + 1'd1;
							end
							else if (is_in_air)
								NEXT_STATE = IN_AIR;
							else if (space_on && ~flag) begin
								NEXT_STATE = JUMP_1;
								flag_in = 1'b1;
							end
							else if (a_on)
								NEXT_STATE = RUN_3_L;
							else
								NEXT_STATE = RUN_1_L;
						end

					JUMP_1:
						begin
							Mario_X_Motion_in = Mario_X_Motion;
							if (Mario_Y_Pos < 13'd160)
								Mario_Y_Motion_in = ~(13'd15) + 1'd1;
							else
								Mario_Y_Motion_in = ~(13'd17) + 1'd1;
							flag_in = 1'b1;
							NEXT_STATE = IN_AIR;
						end
						
					IN_AIR:
						begin
							if (a_on && ~d_on && Mario_X_Motion == 13'd0) begin
								Mario_X_Motion_in = ~(13'd2) +1'd1;
								if (Mario_X_Pos + Mario_X_Motion <= 13'd1)
									Mario_X_Motion_in = 13'd0;
							end
							else if (d_on && ~a_on && Mario_X_Motion == 13'd0) begin
								Mario_X_Motion_in = 13'd2;
								if (Mario_X_Pos + Mario_X_Motion <= 13'd1)
									Mario_X_Motion_in = 13'd0;
							end
							else
								Mario_X_Motion_in = Mario_X_Motion;
							
							flag_in = 1'b1;
							// if ((Mario_Y_Pos + Mario_Y_Motion) < 13'd384) begin
							if (is_Mario_die) begin
								NEXT_STATE = DIE;
								Mario_X_Motion_in = 13'd0;
								Mario_Y_Motion_in = ~(13'd15) + 1'd1;
							end
							else if (is_in_air) begin
								NEXT_STATE = IN_AIR;
								Mario_Y_Motion_in = Mario_Y_Motion + 1'd1;
								if (Mario_X_Pos + Mario_X_Motion <= 13'd1)
									Mario_X_Motion_in = 13'd0;
								if (Mario_X_Pos <= process + 13'd1)
									Mario_X_Motion_in = 13'd0;
								if (Mario_X_Pos + Mario_Size >= Mario_X_Max)
									Mario_X_Motion_in = 13'd0;
								
								if (Mario_X_Pos + Mario_X_Motion >= 13'd6326) begin
									Mario_X_Motion_in = 13'd0;
									Mario_Y_Motion_in = 13'd2;
								end
								
								if (Mario_X_Pos + Mario_Size > 13'd896 && Mario_X_Pos  < 13'd960 && Mario_Y_Pos +Mario_Size > 13'd352)
									Mario_X_Motion_in = 13'd0;
								if (Mario_X_Pos + Mario_Size > 13'd5216  && Mario_X_Pos  < 13'd5280 && Mario_Y_Pos +Mario_Size > 13'd352)
									Mario_X_Motion_in = 13'd0;
								if (Mario_X_Pos + Mario_Size > 13'd5728  && Mario_X_Pos  < 13'd5792 && Mario_Y_Pos +Mario_Size > 13'd352)
									Mario_X_Motion_in = 13'd0;
								if (Mario_X_Pos + Mario_Size > 13'd1216  && Mario_X_Pos  < 13'd1280 && Mario_Y_Pos +Mario_Size > 13'd320)
									Mario_X_Motion_in = 13'd0;
								if (Mario_X_Pos + Mario_Size > 13'd1472  && Mario_X_Pos  < 13'd1536 && Mario_Y_Pos +Mario_Size > 13'd288)
									Mario_X_Motion_in = 13'd0;
								if (Mario_X_Pos + Mario_Size > 13'd1824  && Mario_X_Pos  < 13'd1888 && Mario_Y_Pos +Mario_Size > 13'd288)
									Mario_X_Motion_in = 13'd0;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd320 && Mario_Y_Pos > 13'd288 && Mario_X_Pos > 13'd480 && Mario_X_Pos < 13'd544)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd320 && Mario_Y_Pos > 13'd288 && Mario_X_Pos > 13'd608 && Mario_X_Pos < 13'd800)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd192 && Mario_Y_Pos > 13'd176 && Mario_X_Pos > 13'd678 && Mario_X_Pos < 13'd736)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd320 && Mario_Y_Pos > 13'd304 && Mario_X_Pos > 13'd2432 && Mario_X_Pos < 13'd2560)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd192 && Mario_Y_Pos > 13'd176 && Mario_X_Pos > 13'd2528 && Mario_X_Pos < 13'd2816)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd192 && Mario_Y_Pos > 13'd176 && Mario_X_Pos > 13'd2880 && Mario_X_Pos < 13'd3040)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd320 && Mario_Y_Pos > 13'd304 && Mario_X_Pos > 13'd2976 && Mario_X_Pos < 13'd3040)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd320 && Mario_Y_Pos > 13'd304 && Mario_X_Pos > 13'd3168 && Mario_X_Pos < 13'd3232)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd320 && Mario_Y_Pos > 13'd304 && Mario_X_Pos > 13'd3360 && Mario_X_Pos < 13'd3424)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd320 && Mario_Y_Pos > 13'd304 && Mario_X_Pos > 13'd3456 && Mario_X_Pos < 13'd3520)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd320 && Mario_Y_Pos > 13'd304 && Mario_X_Pos > 13'd3552 && Mario_X_Pos < 13'd3616)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd192 && Mario_Y_Pos > 13'd176 && Mario_X_Pos > 13'd3456 && Mario_X_Pos < 13'd3520)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd320 && Mario_Y_Pos > 13'd304 && Mario_X_Pos > 13'd3744 && Mario_X_Pos < 13'd3808)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd192 && Mario_Y_Pos > 13'd176 && Mario_X_Pos > 13'd3840 && Mario_X_Pos < 13'd3968)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd192 && Mario_Y_Pos > 13'd176 && Mario_X_Pos > 13'd4064 && Mario_X_Pos < 13'd4224)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd320 && Mario_Y_Pos > 13'd304 && Mario_X_Pos > 13'd4096 && Mario_X_Pos < 13'd4192)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
								if (Mario_Y_Pos + Mario_Y_Motion < 13'd5 + 13'd320 && Mario_Y_Pos > 13'd304 && Mario_X_Pos > 13'd5344 && Mario_X_Pos < 13'd5504)
									Mario_Y_Motion_in = ~(Mario_Y_Motion) + 13'd1;
							end								
							else
								begin
									NEXT_STATE = RUN;
									// Mario_Y_Pos_in = 13'd384;
									Mario_Y_Motion_in = 13'd0;
									// Mario_Y_Pos_in = level;
									if (space_on)
										flag_in = 1'b1;
									else
										flag_in = 1'b0;
								end
						end
						
					RUN:
						begin
							Mario_Y_Motion_in = 13'b0;
							Mario_X_Motion_in = Mario_X_Motion;
							if (Mario_X_Pos + Mario_Size >= Mario_X_Max)
								Mario_X_Motion_in = 13'd0;
							if ( Mario_X_Pos <= process + 13'd1 )
								Mario_X_Motion_in = 13'd0;
							if (is_Mario_die) begin
								NEXT_STATE = DIE;
								Mario_X_Motion_in = 13'd0;
								Mario_Y_Motion_in = ~(13'd15) + 1'd1;
							end
							else begin
								case (Mario_X_Motion)
									13'd0:
									begin
										NEXT_STATE = STAND;
									end
									
									13'd1:
									begin
										NEXT_STATE = RUN_1_R;
									end
									
									13'd2:
									begin
										NEXT_STATE = RUN_2_R;
									end
									
									13'd4:
									begin
										NEXT_STATE = RUN_3_R;
									end
									
									~(13'd1) + 1'd1:
									begin
										NEXT_STATE = RUN_1_L;
									end
									
									~(13'd2) + 1'd1:
									begin
										NEXT_STATE = RUN_2_L;
									end
									
									~(13'd3) + 1'd1:
									begin
										NEXT_STATE = RUN_3_L;
									end
									
									default:
										NEXT_STATE = STAND;
								
								endcase
							end
						end
					DIE:
						begin
							NEXT_STATE = DIE;
							Mario_Y_Motion_in = Mario_Y_Motion + 1'd1;
						
						end
					default:;
				endcase
        

				// Be careful when using comparators with "logic" datatype because compiler treats 
				//   both sides of the operator as UNSIGNED numbers.
				// e.g. Mario_Y_Pos - Mario_Size <= Mario_Y_Min 
				// If Mario_Y_Pos is 0, then Mario_Y_Pos - Mario_Size will not be -4, but rather a large positive number.
				//if( Mario_Y_Pos + Mario_Size >= Mario_Y_Max )  // Mario is at the bottom edge, BOUNCE!
				//		Mario_Y_Motion_in = (~(Mario_Y_Step) + 1'b1);  // 2's complement.  
				//else if ( Mario_Y_Pos <= Mario_Y_Min + Mario_Size )  // Mario is at the top edge, BOUNCE!
				//		Mario_Y_Motion_in = Mario_Y_Step;
				// TODO: Add other boundary detections and handle keypress here.
				// Update the Mario's position with its motion
				Mario_X_Pos_in = Mario_X_Pos + Mario_X_Motion;
				if (is_in_air || (STATE == DIE))begin
					Mario_Y_Pos_in = Mario_Y_Pos + Mario_Y_Motion;
					if ((STATE==DIE) && (Mario_Y_Pos + Mario_Y_Motion >= 13'd480))
						Mario_Y_Pos_in = 13'd480;
				end		
				else
					Mario_Y_Pos_in = level;
				

				
				
				// scroll the screen
				if (Mario_X_Pos >= process + 13'd320)
				begin
					if (Mario_X_Motion[12] == 1'b0)
					begin
						process_in = process + Mario_X_Motion;
					end
				end
				
				// check the end position, stop screen scroll
				if (process + 13'd640 >= Mario_X_Max)
				begin
					process_in = process;
				end
				
		  end
        
        /**************************************************************************************
            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
            Hidden Question #2/2:
               Notice that Mario_Y_Pos is updated using Mario_Y_Motion. 
              Will the new value of Mario_Y_Motion be used when Mario_Y_Pos is updated, or the old? 
              What is the difference between writing
                "Mario_Y_Pos_in = Mario_Y_Pos + Mario_Y_Motion;" and 
                "Mario_Y_Pos_in = Mario_Y_Pos + Mario_Y_Motion_in;"?
              How will this impact behavior of the Mario during a bounce, and how might that interact with a response to a keypress?
              Give an answer in your Post-Lab.
        **************************************************************************************/
    end


endmodule

//					// if (space_on)
//					4'b1000:
//						// space is pressed
//					begin
//						// first, we need to check whether mario is at grounud or not
//						// if mario is at ground, whenwe press space, mario should have an initial y velocity 3 and decrease by 1 in each cycle
//						// remember in VGA, y is counting down. Therefore the initial v is negative
//						// when mario is not at ground, we need to ignore the key press for space
//						// to check whether mario is at ground, 
//						Mario_X_Motion_in = Mario_X_Motion;
//						Mario_Y_Motion_in = 13'd0;
//							/*
//								if (Mario_Y_Pos + Mario_Size >= 10'd416)
//									Mario_Y_Motion_in = (~Mario_Y_Step)+10'd1;
//								else if (Mario_Y_Pos + Mario_Size + Mario_Y_Motion_in >= 10'd384)
//									Mario_Y_Pos_in = 10'd380;
//								else
//									Mario_Y_Motion_in = Mario_Y_Motion+10'd1;
//								/*
//								Mario_X_Motion_in = 10'd0;
//								Mario_Y_Motion_in = (~(Mario_Y_Step) + 1'b1);
//								if ( Mario_Y_Pos <= Mario_Y_Min + Mario_Size )
//									Mario_Y_Motion_in = Mario_Y_Step;
//								*/
//					end
//						
//					// if (s_on)
//					4'b0010:
//						// S is pressed
//					begin
//						Mario_X_Motion_in = 13'd0;
//						Mario_Y_Motion_in = 13'd0;
//								/*
//								Mario_Y_Motion_in = Mario_Y_Step;
//								if (Mario_Y_Pos + Mario_Size >= 10'd384)
//									Mario_Y_Motion_in = 10'd0;//(~(Mario_Y_Step) + 1'b1);
//									*/
//					end
//	
//					// if (a_on)
//					4'b0100:
//						// A is pressed
//					begin
//						Mario_Y_Motion_in = 13'd0;
//						Mario_X_Motion_in = (~(Mario_X_Step) + 1'b1);
//						if ( Mario_X_Pos <= process + 13'd1 )
//							Mario_X_Motion_in = 13'd0;
//					end
//			
//					// if (d_on)
//					4'b0001:
//						// D
//					begin
//						Mario_Y_Motion_in = 13'd0;
//						Mario_X_Motion_in = Mario_X_Step;
//						if (Mario_X_Pos + Mario_Size >= Mario_X_Max)
//							Mario_X_Motion_in = 13'd0;
//								//else if (Mario_X_Pos>=13'd400 + process)
//								//	Mario_X_Motion_in = 13'd0;
//					end
//							
//					default:
//						/*
//							if (Mario_Y_Pos <= Mario_Y_Min + Mario_Size)
//							begin
//								if (Mario_X_Motion != 10'd0)
//									Mario_Y_Motion_in = 10'd0;
//								else
//									Mario_Y_Motion_in = Mario_Y_Step;
//							end
//							
//							else if (Mario_Y_Pos + Mario_Size >= Mario_Y_Max)
//							begin
//								if (Mario_X_Motion != 10'd0)
//									Mario_Y_Motion_in = 10'd0;
//								else
//									Mario_Y_Motion_in = (~(Mario_Y_Step) + 1'b1);
//							end
//							
//							else if ( Mario_X_Pos <= Mario_X_Min + Mario_Size )
//							begin
//								if (Mario_Y_Motion != 10'd0)
//									Mario_X_Motion_in = 10'd0;
//								else
//									Mario_X_Motion_in = Mario_X_Step;
//							end
//	
//							else if (Mario_X_Pos + Mario_Size >= Mario_X_Max)
//							begin
//								if (Mario_Y_Motion != 10'd0)
//									Mario_X_Motion_in = 10'd0;
//								else
//									Mario_X_Motion_in = (~(Mario_X_Step) + 1'b1);
//							end
//							*/
//						begin
//							Mario_Y_Motion_in = 13'd0;
//							Mario_X_Motion_in = 13'd0;
//						end
//				endcase