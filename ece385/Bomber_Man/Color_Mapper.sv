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
module  color_mapper ( input              [0:15*20-1][4:0]map_out,            // Whether current pixel belongs to ball 
                       input START,GAMEEND,GAMESTART,GGG, BGG,                                   //   or background (computed in ball.sv)
							  input is_ball,
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							  input [15:0] SRAM_DQ,
							  input [23:0]  background_dout,brick_dout,wall_dout,boy_front_sta_dout,boy_front_dout,boy_back_sta_dout,boy_back_dout,boy_left_sta_dout,boy_left_dout,boy_right_sta_dout,boy_right_dout
	 ,fire_round1_dout,heart_dout,bomb_dout,fire_center_dout,fire_round_dout,girl_front_dout,girl_back_sta_dout,girl_back_dout,girl_left_sta_dout,girl_left_dout,girl_right_sta_dout,girl_right_dout,girl_front_sta_dout,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
	 logic [15:0]Byte_Swap;
	 
  assign Byte_Swap = {SRAM_DQ[7:0],SRAM_DQ[15:8]};

    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    

    always_comb
    begin
			if(START)
				begin
				if(is_ball == 1'b1)
				begin
					Red = 8'hfa;
					Green = 8'h18;
					Blue = 8'h18;
				end	
			
				else 
				begin
					Red = {Byte_Swap[15:11],3'b0};
					Green = {Byte_Swap[10:5],2'b0};
					Blue = {Byte_Swap[4:0],3'b0};
				end
				end
					
			
			else if(GAMESTART)
			begin
			if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'hD || map_out[(DrawY/32)*20+DrawX/32] == 5'hD) 	//boy_front_sta
			begin
				if((boy_front_sta_dout[23:16] == 8'h00) && (boy_front_sta_dout[15:8] == 8'hff) && (boy_front_sta_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end

					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = boy_front_sta_dout[23:16];
						Green = boy_front_sta_dout[15:8];
						Blue = boy_front_sta_dout[7:0];
					end
				end
				
			
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'hC || map_out[(DrawY/32)*20+DrawX/32] == 5'hC) 	//boy_front
			begin
				if((boy_front_dout[23:16] == 8'h00) && (boy_front_dout[15:8] == 8'hff) && (boy_front_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end

					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = boy_front_dout[23:16];
						Green = boy_front_dout[15:8];
						Blue = boy_front_dout[7:0];
					end
				end
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'hA || map_out[(DrawY/32)*20+DrawX/32] == 5'hA) 	//boy_back
			begin
				if((boy_back_dout[23:16] == 8'h00) && (boy_back_dout[15:8] == 8'hff) && (boy_back_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end

					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = boy_back_dout[23:16];
						Green = boy_back_dout[15:8];
						Blue = boy_back_dout[7:0];
					end
				end
			
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'hB || map_out[(DrawY/32)*20+DrawX/32] == 5'hB) 	//boy_back_sta
		begin
				if((boy_back_sta_dout[23:16] == 8'h00) && (boy_back_sta_dout[15:8] == 8'hff) && (boy_back_sta_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end

					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = boy_back_sta_dout[23:16];
						Green = boy_back_sta_dout[15:8];
						Blue = boy_back_sta_dout[7:0];
					end
				end
					
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'hE || map_out[(DrawY/32)*20+DrawX/32] == 5'hE) 	//boy_left
					begin
				if((boy_left_dout[23:16] == 8'h00) && (boy_left_dout[15:8] == 8'hff) && (boy_left_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end

					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = boy_left_dout[23:16];
						Green = boy_left_dout[15:8];
						Blue = boy_left_dout[7:0];
					end
				end
					
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'hF || map_out[(DrawY/32)*20+DrawX/32] == 5'hF) 	//boy_left_sta
					begin
				if((boy_left_sta_dout[23:16] == 8'h00) && (boy_left_sta_dout[15:8] == 8'hff) && (boy_left_sta_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end

					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = boy_left_sta_dout[23:16];
						Green =boy_left_sta_dout[15:8];
						Blue = boy_left_sta_dout[7:0];
					end
				end

//					
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'h10 || map_out[(DrawY/32)*20+DrawX/32] == 5'h10) 	//boy_right
						begin
				if((boy_right_dout[23:16] == 8'h00) && (boy_right_dout[15:8] == 8'hff) && (boy_right_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end

					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = boy_right_dout[23:16];
						Green =boy_right_dout[15:8];
						Blue = boy_right_dout[7:0];
					end
				end
					
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'h11 || map_out[(DrawY/32)*20+DrawX/32] == 5'h11) 	//boy_right_sta
							begin
				if((boy_right_sta_dout[23:16] == 8'h00) && (boy_right_sta_dout[15:8] == 8'hff) && (boy_right_sta_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end

					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = boy_right_sta_dout[23:16];
						Green =boy_right_sta_dout[15:8];
						Blue = boy_right_sta_dout[7:0];
					end
				end
     			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'h14 || map_out[(DrawY/32)*20+DrawX/32] == 5'h14) 	//girl_back
				begin
				if((girl_back_dout[23:16] == 8'h00) && (girl_back_dout[15:8] == 8'hff) && (girl_back_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end

					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = girl_back_dout[23:16];
						Green = girl_back_dout[15:8];
						Blue = girl_back_dout[7:0];
					end
				end
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'h15 || map_out[(DrawY/32)*20+DrawX/32] == 5'h15) 		//girl_back_sta
			begin
				if((girl_back_sta_dout[23:16] == 8'h00) && (girl_back_sta_dout[15:8] == 8'hff) && (girl_back_sta_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end

					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = girl_back_sta_dout[23:16];
						Green = girl_back_sta_dout[15:8];
						Blue = girl_back_sta_dout[7:0];
					end
				end
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'h16 || map_out[(DrawY/32)*20+DrawX/32] == 5'h16) 		//girl_front
			begin
				if((girl_front_dout[23:16] == 8'h00) && (girl_front_dout[15:8] == 8'hff) && (girl_front_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end

					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = girl_front_dout[23:16];
						Green = girl_front_dout[15:8];
						Blue = girl_front_dout[7:0];
					end
				end
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'h17 || map_out[(DrawY/32)*20+DrawX/32] == 5'h17) 		//girl_front_sta
			begin
				if((girl_front_sta_dout[23:16] == 8'h00) && (girl_front_sta_dout[15:8] == 8'hff) && (girl_front_sta_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end

					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = girl_front_sta_dout[23:16];
						Green = girl_front_sta_dout[15:8];
						Blue = girl_front_sta_dout[7:0];
					end
				end
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'h18 || map_out[(DrawY/32)*20+DrawX/32] == 5'h18) 		//girl_left
			begin
				if((girl_left_dout[23:16] == 8'h00) && (girl_left_dout[15:8] == 8'hff) && (girl_left_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = girl_left_dout[23:16];
						Green = girl_left_dout[15:8];
						Blue = girl_left_dout[7:0];
					end
				end
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'h19 || map_out[(DrawY/32)*20+DrawX/32] == 5'h19) 		//girl_left_sta
			begin
				if((girl_left_sta_dout[23:16] == 8'h00) && (girl_left_sta_dout[15:8] == 8'hff) && (girl_left_sta_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end
else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = girl_left_sta_dout[23:16];
						Green = girl_left_sta_dout[15:8];
						Blue = girl_left_sta_dout[7:0];
					end
				end
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'h1A || map_out[(DrawY/32)*20+DrawX/32] == 5'h1A) 		//girl_right
			begin
				if((girl_right_dout[23:16] == 8'h00) && (girl_right_dout[15:8] == 8'hff) && (girl_right_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end
else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = girl_right_dout[23:16];
						Green = girl_right_dout[15:8];
						Blue = girl_right_dout[7:0];
					end
				end
			else if(map_out[((DrawY/32)+1)*20+DrawX/32] == 5'h1B || map_out[(DrawY/32)*20+DrawX/32] == 5'h1B) 		//girl_right_sta
			begin
				if((girl_right_sta_dout[23:16] == 8'h00) && (girl_right_sta_dout[15:8] == 8'hff) && (girl_right_sta_dout[7:0] == 8'h00))
				begin
					if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h1)
					begin
						if(wall_dout[23:0]==24'hffffff)
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
					end
else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h3)
					begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h2)
					begin
						Red = brick_dout[23:16];
						Green = brick_dout[15:8];
						Blue = brick_dout[7:0];
					end
					else if (map_out[(DrawY/32)*20 + DrawX/32] == 5'h7)
					begin
						Red = heart_dout[23:16];
						Green = heart_dout[15:8];
						Blue = heart_dout[7:0];
					end
					else
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
					end
					else 
					begin
						Red = girl_right_sta_dout[23:16];
						Green = girl_right_sta_dout[15:8];
						Blue = girl_right_sta_dout[7:0];
					end
				end

			else if(map_out[(DrawY/32)*20+DrawX/32] == 5'h0)			//background
		   begin
			Red = background_dout[23:16];
			Green = background_dout[15:8];
			Blue = background_dout[7:0];
			end
			
			else if(map_out[(DrawY/32)*20+DrawX/32] == 5'h2)		//brick
		   begin
			Red = brick_dout[23:16];
			Green = brick_dout[15:8];
			Blue = brick_dout[7:0];
			end
			
			else if(map_out[(DrawY/32)*20+DrawX/32] == 5'h3)		//bomb
		   begin
			if((bomb_dout[23:16] == 8'h00) && (bomb_dout[15:8] == 8'hff) && (bomb_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
			begin
			Red = bomb_dout[23:16];
			Green = bomb_dout[15:8];
			Blue = bomb_dout[7:0];
			end
			end
			else if(map_out[(DrawY/32)*20+DrawX/32] == 5'h4)		//fire_center
		   begin
			if((fire_center_dout[23:16] == 8'h00) && (fire_center_dout[15:8] == 8'hff) && (fire_center_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
						begin
						Red = fire_center_dout[23:16];
						Green = fire_center_dout[15:8];
						Blue = fire_center_dout[7:0];
						end
			end
			
			else if(map_out[(DrawY/32)*20+DrawX/32] == 5'h5)		//fire_round_dout
		    begin
			if((fire_round_dout[23:16] == 8'h00) && (fire_round_dout[15:8] == 8'hff) && (fire_round_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
						begin
						Red = fire_round_dout[23:16];
						Green = fire_round_dout[15:8];
						Blue = fire_round_dout[7:0];
						end
			end
			else if(map_out[(DrawY/32)*20+DrawX/32] == 5'h6)		//fire_round
			begin
			if((fire_round1_dout[23:16] == 8'h00) && (fire_round1_dout[15:8] == 8'hff) && (fire_round1_dout[7:0] == 8'h00))
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
			else
						begin
						Red = fire_round1_dout[23:16];
						Green = fire_round1_dout[15:8];
						Blue = fire_round1_dout[7:0];
						end
			end
			else if(map_out[(DrawY/32)*20+DrawX/32] == 5'h7)		//heart
		   begin
			Red = heart_dout[23:16];
			Green = heart_dout[15:8];
			Blue = heart_dout[7:0];
			end
			
//			
			else if(map_out[(DrawY/32)*20+DrawX/32] == 5'h1)		//wall
		   begin
						if(wall_dout[23:0]==24'hffffff)
					
						begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];
						end
						else 
						begin
						Red = wall_dout[23:16];
						Green = wall_dout[15:8];
						Blue = wall_dout[7:0];
						end
						end
			else 
			begin
						Red = background_dout[23:16];
						Green = background_dout[15:8];
						Blue = background_dout[7:0];	
			end
			end
//			
		   else if(GAMEEND)
			begin
						Red = {Byte_Swap[15:11],3'b0};
						Green = {Byte_Swap[10:5],2'b0};
						Blue = {Byte_Swap[4:0],3'b0};
						end
					
			else
			begin
						Red = {Byte_Swap[15:11],3'b0};
						Green = {Byte_Swap[10:5],2'b0};
						Blue = {Byte_Swap[4:0],3'b0};
			end
			end
    
    
endmodule
					
