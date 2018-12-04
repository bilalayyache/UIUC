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
module  color_mapper ( input        is_Mario, is_Goomba1, is_Goomba2, is_Goomba3, is_Goomba4,is_Goomba5,is_flag,
												//is_coin1, is_coin2,
							  input [12:0] DrawX, DrawY,       // Current pixel coordinates
							  input [6:0]  image_show,
							  input [15:0]  SRAM_DQ,
							  input [23:0]  ground_dout, mario_dout, background_dout, goomba1_dout, goomba2_dout, goomba3_dout, goomba4_dout, goomba5_dout, flag_dout,
												 //coin_1_dout, coin_2_dout,
							  input [12:0]	 process,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    logic [15:0]Byte_Swap;
	 
    assign Byte_Swap = {SRAM_DQ[7:0],SRAM_DQ[15:8]};
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	 
    // Assign color based on is_Mario signal
    always_comb
    begin
		  if (image_show[2]) begin
			  if (is_Goomba1 == 1'b1 && (goomba1_dout != 24'h6b8cff))
			  begin
					Red = goomba1_dout[23:16];
					Green = goomba1_dout[15:8];
					Blue = goomba1_dout[7:0];
			  end
			  else if (is_Goomba2 == 1'b1 && (goomba2_dout != 24'h6b8cff))
			  begin
					Red = goomba2_dout[23:16];
					Green = goomba2_dout[15:8];
					Blue = goomba2_dout[7:0];
			  end
			  else if (is_Goomba3 == 1'b1 && (goomba3_dout != 24'h6b8cff))
			  begin
					Red = goomba3_dout[23:16];
					Green = goomba3_dout[15:8];
					Blue = goomba3_dout[7:0];
			  end
			  else if (is_Goomba4 == 1'b1 && (goomba4_dout != 24'h6b8cff))
			  begin
					Red = goomba4_dout[23:16];
					Green = goomba4_dout[15:8];
					Blue = goomba4_dout[7:0];
			  end
			  else if (is_Goomba5 == 1'b1 && (goomba5_dout != 24'h6b8cff))
			  begin
					Red = goomba5_dout[23:16];
					Green = goomba5_dout[15:8];
					Blue = goomba5_dout[7:0];
			  end
			  else if (is_flag && (flag_dout != 24'h6b8cff))
			  begin
					Red = flag_dout[23:16];
					Green = flag_dout[15:8];
					Blue = flag_dout[7:0];
			  end
			  else if (is_Mario == 1'b1 && (mario_dout != 24'h6b8cff))
			  begin
					// White Mario
					Red = mario_dout[23:16];
					Green = mario_dout[15:8];
					Blue = mario_dout[7:0];
			  end
//			  else if (is_coin1 && (coin_1_dout != 24'h6b8cff))
//			  begin
//					Red = coin_1_dout[23:16];
//					Green = coin_1_dout[15:8];
//					Blue = coin_1_dout[7:0];
//			  end
//			  else if (is_coin2 && (coin_2_dout != 24'h6b8cff))
//			  begin
//					Red = coin_2_dout[23:16];
//					Green = coin_2_dout[15:8];
//					Blue = coin_2_dout[7:0];
//			  end
			  else if (DrawY >= 13'd416)
			  begin
					Red = ground_dout[23:16];
					Green = ground_dout[15:8];
					Blue = ground_dout[7:0];
			  end
			  else 
			  begin
					// Background color
					Red = background_dout[23:16];
					Green = background_dout[15: 8];
					Blue = background_dout[7:0];
	//				Red   = 8'h6b;
	//				Green = 8'h8c;
	//				Blue  = 8'hff;
			  end
		  end
		  else if(image_show[6]) begin
				Red = {Byte_Swap[15:11], 3'b0};
			   Green = {Byte_Swap[10:5], 2'b0};
				Blue = {Byte_Swap[4:0], 3'b0};
		  end
		  else if(image_show[5]||image_show[4]||image_show[3])begin
				if (DrawY > 13'd200 && DrawY <= 13'd240)begin
					Red = {Byte_Swap[15:11], 3'b0};
					Green = {Byte_Swap[10:5], 2'b0};
					Blue = {Byte_Swap[4:0], 3'b0};
				end
				else
					begin
						Red = 8'd0;
						Green = 8'd0;
						Blue = 8'd0;
					end
			end
			else 
				begin 
					if (DrawY > 13'd200 && DrawY <= 13'd230)begin
						Red = {Byte_Swap[15:11], 3'b0};
						Green = {Byte_Swap[10:5], 2'b0};
						Blue = {Byte_Swap[4:0], 3'b0};
						end
					else
						begin
							Red = 8'd0;
							Green = 8'd0;
							Blue = 8'd0;
						end
			end
    end 
    
endmodule
