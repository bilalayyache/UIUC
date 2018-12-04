module flag ( input          Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [12:0]  DrawX, DrawY,       // Current pixel coordinates
					input [12:0]  process,
					input [12:0]  Mario_X_Pos,
					output [12:0] flag_X_Pos, flag_Y_Pos,
               output logic  is_flag, is_win           // Whether current pixel belongs to Goomba or background
              );

    parameter [12:0] flag_X_start = 13'd6320;
	 parameter [12:0] flag_Y_Max = 13'd352;
	 logic [12:0] flag_X_Pos_in, flag_Y_Pos_in, flag_X_Motion, flag_Y_Motion, flag_X_Motion_in, flag_Y_Motion_in;
	 
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
				// flag_X_Pos <= 13'd6320;
				flag_X_Pos <= flag_X_start;
            flag_Y_Pos <= 13'd106;
            flag_X_Motion <= 13'd0;
            flag_Y_Motion <= 13'd0;
        end
        else
        begin
            flag_X_Pos <= flag_X_Pos_in;
            flag_Y_Pos <= flag_Y_Pos_in;
            flag_X_Motion <= flag_X_Motion_in;
            flag_Y_Motion <= flag_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
	 
	 always_comb
    begin
        // By default, keep motion and position unchanged
        flag_X_Pos_in = flag_X_Pos;
        flag_Y_Pos_in = flag_Y_Pos;
        flag_X_Motion_in = flag_X_Motion;
        flag_Y_Motion_in = flag_Y_Motion;
		  
		  // Update position and motion only at rising edge of frame clock
		  if (frame_clk_rising_edge)
        begin
				if (Mario_X_Pos >=  flag_X_start + 13'd5)
					flag_Y_Motion_in = 13'd2;
				if (flag_Y_Pos + flag_Y_Motion >= flag_Y_Max)
					flag_Y_Motion_in = 13'b0;
				// Be careful when using comparators with "logic" datatype because compiler treats 
				//   both sides of the operator as UNSIGNED numbers.
				// e.g. Goomba_Y_Pos - Goomba_Size <= Goomba_Y_Min 
				// If Goomba_Y_Pos is 0, then Goomba_Y_Pos - Goomba_Size will not be -4, but rather a large positive number.
				//if( Goomba_Y_Pos + Goomba_Size >= Goomba_Y_Max )  // Goomba is at the bottom edge, BOUNCE!
				//		Goomba_Y_Motion_in = (~(Goomba_Y_Step) + 1'b1);  // 2's complement.  
				//else if ( Goomba_Y_Pos <= Goomba_Y_Min + Goomba_Size )  // Goomba is at the top edge, BOUNCE!
				//		Goomba_Y_Motion_in = Goomba_Y_Step;
				// TODO: Add other boundary detections and handle keypress here.
				
				
				// Update the Goomba's position with its motion
				flag_X_Pos_in = flag_X_Pos + flag_X_Motion;
				flag_Y_Pos_in = flag_Y_Pos + flag_Y_Motion;
		  end
    end
	 
	 always_comb begin
        if ( flag_X_Pos <= process + DrawX && DrawX + process < flag_X_Pos +13'd32 && DrawY >= flag_Y_Pos && DrawY < flag_Y_Pos + 13'd32) 
            is_flag = 1'b1;
        else
            is_flag = 1'b0;
        /* The Goomba's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end
    
	 assign is_win = flag_Y_Pos >= flag_Y_Max ? 1'b1 : 1'b0;
endmodule
