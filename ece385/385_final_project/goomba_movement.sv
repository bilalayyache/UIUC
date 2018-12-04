module Goomba_movement
							#(parameter X_Min = 13'd0;
							  parameter X_Max = 13'd895;
							  parameter X_Start = 13'd512)
							(input       Clk,                // 50 MHz clock
											 Reset,              // Active-high reset signal
											 frame_clk,          // The clock indicating a new frame (~60Hz)
											 is_goomba_die,
											 rip,
							 output logic [12:0] Goomba_X_Pos, Goomba_Y_Pos
);

							 
							 
							 
    parameter [12:0] Goomba_X_Min = X_Min;       // Leftmost point on the X axis
    parameter [12:0] Goomba_X_Max = X_Max;     // Rightmost point on the X axis
    parameter [12:0] Goomba_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [12:0] Goomba_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [12:0] Goomba_X_Step = 10'd1;      // Step size on the X axis
    parameter [12:0] Goomba_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [12:0] Goomba_Size = 10'd32;        // Goomba size
    
    logic [12:0] Goomba_X_Motion, Goomba_Y_Motion;
    logic [12:0] Goomba_X_Pos_in, Goomba_X_Motion_in, Goomba_Y_Pos_in, Goomba_Y_Motion_in;
    
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
            // Goomba_X_Pos <= 13'd704;
				Goomba_X_Pos <= X_Start;
            Goomba_Y_Pos <= 13'd384;
            Goomba_X_Motion <= 13'd1;
            Goomba_Y_Motion <= 13'd0;
        end
		  else if (rip)
		  begin
				Goomba_X_Pos <= 13'd0;
            Goomba_Y_Pos <= 13'd0;
            Goomba_X_Motion <= 13'd0;
            Goomba_Y_Motion <= 13'd0;
		  end
        else
        begin
            Goomba_X_Pos <= Goomba_X_Pos_in;
            Goomba_Y_Pos <= Goomba_Y_Pos_in;
            Goomba_X_Motion <= Goomba_X_Motion_in;
            Goomba_Y_Motion <= Goomba_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Goomba_X_Pos_in = Goomba_X_Pos;
        Goomba_Y_Pos_in = Goomba_Y_Pos;
        Goomba_X_Motion_in = Goomba_X_Motion;
        Goomba_Y_Motion_in = Goomba_Y_Motion;
		  
		  // Update position and motion only at rising edge of frame clock
		  if (frame_clk_rising_edge)
        begin
				if (is_goomba_die)
				begin
					Goomba_X_Motion_in = 13'd0;
					Goomba_Y_Motion_in = 13'd0;
				end
				else if ( Goomba_X_Pos <= Goomba_X_Min )
					Goomba_X_Motion_in = Goomba_X_Step;
				else if (Goomba_X_Pos + Goomba_Size >= Goomba_X_Max)
					Goomba_X_Motion_in = (~(Goomba_X_Step) + 1'b1);
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
				Goomba_X_Pos_in = Goomba_X_Pos + Goomba_X_Motion;
				Goomba_Y_Pos_in = Goomba_Y_Pos + Goomba_Y_Motion;
		  end
        
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
