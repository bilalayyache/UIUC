//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [9:0] cursorX, cursorY,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					//input [7:0]   keycode,
               output logic  is_ball             // Whether current pixel belongs to ball or background
              );
				  
				  
	 int Ball_X_Pos, Ball_Y_Pos;	
    int DistX, DistY, Size;	 
	 assign DistX = DrawX -   Ball_X_Pos;
    assign DistY = DrawY -  Ball_Y_Pos;
	 
	 int X, Y;
	assign Y = DrawY < Ball_Y_Pos? (Ball_Y_Pos - DrawY): (DrawY- Ball_Y_Pos);
	assign  X = DrawX < Ball_X_Pos? (Ball_X_Pos - DrawX): (DrawX- Ball_X_Pos);	 
	
	  
    assign Size = Ball_Size;

	    parameter [9:0] Ball_Size=4;        // Ball size
		 // parameter [9:0] X=320;
		 //  parameter [9:0] Y=240;
		
	    // Update ball position and motion
    always_comb
    begin
        if (Reset)
        begin
            Ball_X_Pos = 320;
            Ball_Y_Pos = 240;
        end
		 else //if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Ball_X_Pos = cursorX;
				Ball_Y_Pos = cursorY;
        end
	end

	 always_comb
	 begin
	   // if ( ((Y-3*X/4)*(Y-3*X/4)+(3/4*X)* (3/4*X))< 16)
		 if (Y*Y + X*X <16 )
		// if ((X*X + Y*Y -1)*(X*X + Y*Y -1)*(X*X + Y*Y -1) - X*X*Y*Y*Y < 0) 
            is_ball = 1'b1;
       else
            is_ball = 1'b0;
	end
//
endmodule
