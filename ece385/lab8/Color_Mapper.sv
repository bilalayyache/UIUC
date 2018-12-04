//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
//module  color_mapper ( input              is_Mario,            // Whether current pixel belongs to ball 
//                                                              //   or background (computed in ball.sv)
//                       input        [12:0] DrawX, DrawY,       // Current pixel coordinates
//							  input			[23:0] stand_dout, ground_dout,
//							  input			[12:0] process,
//                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
//                     );
//    
//    logic [7:0] Red, Green, Blue;
//    
//    // Output colors to VGA
//    assign VGA_R = Red;
//    assign VGA_G = Green;
//    assign VGA_B = Blue;
//    
//    // Assign color based on is_ball signal
//    always_comb
//    begin
//        if (is_Mario == 1'b1)
//        begin
//            // White Mario
//            Red = stand_dout[23:16];
//            Green = stand_dout[15:8];
//            Blue = stand_dout[7:0];
//        end
//        else if (DrawY >= 13'd416)
//		  begin
//				Red = ground_dout[23:16];
//				Green = ground_dout[15:8];
//				Blue = ground_dout[7:0];
//		  end
//        begin
//            // Background with nice color gradient
//            Red = 8'h3f; 
//            Green = 8'h00;
//            Blue = 8'h7f - {1'b0, DrawX[9:3]};
//        end
//    end 
//    
//endmodule

module  color_mapper ( input              is_Mario,            // Whether current pixel belongs to Mario 
                                                              //   or background (computed in Mario.sv)
                       input        [12:0] DrawX, DrawY,       // Current pixel coordinates
							  input [23:0]  ground_dout, stand_dout,
							  input [12:0]	 process,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	 
    // Assign color based on is_Mario signal
    always_comb
    begin
        if (is_Mario == 1'b1 && (stand_dout != 23'h6b8cff))
        begin
            // White Mario
            Red = stand_dout[23:16];
            Green = stand_dout[15:8];
            Blue = stand_dout[7:0];
        end
		  else if (DrawY >= 13'd416)
		  begin
				Red = ground_dout[23:16];
				Green = ground_dout[15:8];
				Blue = ground_dout[7:0];
		  end
        else 
        begin
            // Background color
//            Red = background_dout[23:16];
//            Green = background_dout[15:8];
//            Blue = background_dout[7:0];
				Red = 8'h6b;
				Green = 8'h8c;
				Blue = 8'hff;
        end
    end 
    
endmodule
