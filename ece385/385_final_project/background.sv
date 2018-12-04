module BACKGROUND (// input Clk,
						 input [12:0]   DrawX, DrawY,       // Current pixel coordinates
						 input [12:0]	 process,
						 input			 is_coin1, is_coin2, is_coin3, is_coin4, is_coin5, is_coin6, is_coin7, is_coin8, is_coin9,
											 is_coin10, is_coin11, is_coin12, is_coin13,
						 input [23:0]   cloud_dout, L_mountain_dout,S_mountain_dout, tube_1_dout, tube_2_dout, tube_3_dout, castle_dout, brick_dout,
											 qmark1_dout, qmark2_dout, qmark3_dout, qmark4_dout, qmark5_dout, qmark6_dout, qmark7_dout, 
											 qmark8_dout, qmark9_dout, qmark10_dout, qmark11_dout, qmark12_dout, qmark13_dout,
											 coin_1_dout, coin_2_dout, coin_3_dout, coin_4_dout, coin_5_dout, coin_6_dout, coin_7_dout,
											 coin_8_dout, coin_9_dout, coin_10_dout, coin_11_dout, coin_12_dout, coin_13_dout,
						 input [23:0]	 flag_gan_dout, rec_dout,
						 input [12:0]   coin1_Y_Pos, coin2_Y_Pos, coin3_Y_Pos,coin4_Y_Pos,coin5_Y_Pos,coin6_Y_Pos,
											coin7_Y_Pos,coin8_Y_Pos,coin9_Y_Pos,coin10_Y_Pos,coin11_Y_Pos,coin12_Y_Pos,coin13_Y_Pos,
						 output [23:0]  background_dout,
						 output [12:0]  Cloud_X_Pos, Cloud_Y_Pos,castle_X_Pos, castle_Y_Pos,brick_X_Pos, brick_Y_Pos,
						 output [12:0]  L_mountain_X_Pos, L_mountain_Y_Pos, S_mountain_X_Pos, S_mountain_Y_Pos, rec_X_Pos, rec_Y_Pos, 
											 flag_gan_X_Pos, flag_gan_Y_Pos,
						 output [12:0]  tube_1_X_Pos, tube_1_Y_Pos, tube_2_X_Pos, tube_2_Y_Pos, tube_3_X_Pos, tube_3_Y_Pos, q_mark_X_Pos, q_mark_Y_Pos,
						 output is_castle
						);

	  parameter [12:0] Y_1 = 13'd300;
	  parameter [12:0] Y_2 = 13'd172;
	  logic   is_Cloud, is_L_mountain, is_S_mountain, is_tube_1, is_tube_2, is_tube_3, is_brick,//is_castle,
				 is_qmark1, is_qmark2, is_qmark3, is_qmark4, is_qmark5, is_qmark6, is_qmark7, is_qmark8, is_qmark9, is_qmark10, is_qmark11, is_qmark12, is_qmark13,
				 is_flag_gan, is_rec; 	  // Whether current pixel belongs to Mario or background
	  
	  Cloud cloud1(.*);
	  L_mountain L_mountain_instance(.*);
	  S_mountain S_mountain_instance(.*);
	  Tube_1 tube_1_ins(.*);
	  Tube_2 tube_2_ins(.*);
	  Tube_3 tube_3_ins(.*);
	  Castle castle_ins(.*);
	  Brick  brick_ins(.*);
	  Qmark  Qmark_ins(.*);
	  Rec		rec_ins(.*);
	  Flag_gan	flag_gan_ins(.*);
	  always_comb begin
			if (is_Cloud)
				background_dout = cloud_dout;
			else if (is_L_mountain)
				background_dout = L_mountain_dout;
			else if (is_S_mountain)
				background_dout = S_mountain_dout;
			else if (is_tube_1)
				background_dout = tube_1_dout;
			else if (is_tube_2)
				background_dout = tube_2_dout;
			else if (is_tube_3)
				background_dout = tube_3_dout;
			else if (is_castle) begin
				background_dout = {castle_dout[15:11], 3'b0, castle_dout[10:5], 2'b0, castle_dout[4:0], 3'b0};
			end
			else if (is_brick)
				background_dout = brick_dout;
			else if (is_qmark1)
				background_dout = qmark1_dout;
			else if (is_qmark2)
				background_dout = qmark2_dout;
			else if (is_qmark3)
				background_dout = qmark3_dout;
			else if (is_qmark4)
				background_dout = qmark4_dout;
			else if (is_qmark5)
				background_dout = qmark5_dout;
			else if (is_qmark6)
				background_dout = qmark6_dout;
			else if (is_qmark7)
				background_dout = qmark7_dout;
			else if (is_qmark8)
				background_dout = qmark8_dout;
			else if (is_qmark9)
				background_dout = qmark9_dout;
			else if (is_qmark10)
				background_dout = qmark10_dout;
			else if (is_qmark11)
				background_dout = qmark11_dout;
			else if (is_qmark12)
				background_dout = qmark12_dout;
			else if (is_qmark13)
				background_dout = qmark13_dout;
			else if (is_coin1 && coin1_Y_Pos < Y_1)
				background_dout = coin_1_dout;
			else if (is_coin2 && coin2_Y_Pos < Y_1)
				background_dout = coin_2_dout;
			else if (is_coin3 && coin3_Y_Pos < Y_2)
				background_dout = coin_3_dout;
			else if (is_coin4 && coin4_Y_Pos < Y_1)
				background_dout = coin_4_dout;
			else if (is_coin5 && coin5_Y_Pos < Y_1)
				background_dout = coin_5_dout;
			else if (is_coin6 && coin6_Y_Pos < Y_2)
				background_dout = coin_6_dout;
			else if (is_coin7 && coin7_Y_Pos < Y_1)
				background_dout = coin_7_dout;
			else if (is_coin8 && coin8_Y_Pos < Y_1)
				background_dout = coin_8_dout;
			else if (is_coin9 && coin9_Y_Pos < Y_2)
				background_dout = coin_9_dout;
			else if (is_coin10 && coin10_Y_Pos < Y_1)
				background_dout = coin_10_dout;
			else if (is_coin11 && coin11_Y_Pos < Y_2)
				background_dout = coin_11_dout;
			else if (is_coin12 && coin12_Y_Pos < Y_2)
				background_dout = coin_12_dout;
			else if (is_coin13 && coin13_Y_Pos < Y_1)
				background_dout = coin_13_dout;
			else if (is_flag_gan)
				background_dout = flag_gan_dout;
			else if (is_rec)
				background_dout = rec_dout;
//			else if (is_coin)
//				background_dout = coin_dout;
			else
			begin
            // Background color
            background_dout[23:16] = 8'h6b; 
            background_dout[15: 8] = 8'h8c;
            background_dout[ 7: 0] = 8'hff;
        end
	  end



endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//module Coin (input [12:0]   DrawX, DrawY,       // Current pixel coordinates
//				  input [12:0]	  process,
//				  output logic   is_coin           // Whether current pixel belongs to Mario or background
//				  //output logic [12:0] castle_X_Pos, castle_Y_Pos
//				  );
//	 
//	 always_comb begin
//        
//		  if ( DrawX+process >= 13'd0 && DrawX+process < 13'd32 && DrawY >= 13'd0 && DrawY < 13'd32 )
//		  begin
//            is_coin = 1'b1;
//				//castle_X_Pos = 13'd6464;
//				//castle_Y_Pos = 13'd256;
//		  end
//        
//		  else
//		  begin
//				is_coin = 1'b0;
//				//castle_X_Pos = 13'd0;
//				//castle_Y_Pos = 13'd0;
//		  end
//    end
//
//
//
//endmodule


module Cloud (input [12:0]   DrawX, DrawY,       // Current pixel coordinates
				  input [12:0]	  process,
				  output logic   is_Cloud,           // Whether current pixel belongs to Mario or background
				  output logic [12:0] Cloud_X_Pos, Cloud_Y_Pos
				  );
	 
	 always_comb begin
        if ( DrawX+process >= 13'd272 && DrawX+process < 13'd336 && DrawY >= 13'd66 && DrawY < 13'd114 )
		  begin
            is_Cloud = 1'b1;
				Cloud_X_Pos = 13'd272;
				Cloud_Y_Pos = 13'd66;
		  end
        
		  else if ( DrawX+process >= 13'd624 && DrawX+process < 13'd688 && DrawY >= 13'd34 && DrawY < 13'd82 )
		  begin
            is_Cloud = 1'b1;
				Cloud_X_Pos = 13'd624;
				Cloud_Y_Pos = 13'd34;
		  end
		  else if ( DrawX+process >= 13'd1808 && DrawX+process < 13'd1872 && DrawY >= 13'd66 && DrawY < 13'd114 )
		  begin
            is_Cloud = 1'b1;
				Cloud_X_Pos = 13'd1808;
				Cloud_Y_Pos = 13'd66;
		  end
		  else if ( DrawX+process >= 13'd2160 && DrawX+process < 13'd2224 && DrawY >= 13'd34 && DrawY < 13'd82 )
		 
		  begin
            is_Cloud = 1'b1;
				Cloud_X_Pos = 13'd2160;
				Cloud_Y_Pos = 13'd34;
		  end
		  else if ( DrawX+process >= 13'd3344 && DrawX+process < 13'd3408 && DrawY >= 13'd66 && DrawY < 13'd114 )
		  
		  begin
            is_Cloud = 1'b1;
				Cloud_X_Pos = 13'd3344;
				Cloud_Y_Pos = 13'd66;
		  end
		  else if ( DrawX+process >= 13'd6416 && DrawX+process < 13'd6480 && DrawY >= 13'd34 && DrawY < 13'd82 )
		  
		  begin
            is_Cloud = 1'b1;
				Cloud_X_Pos = 13'd6416;
				Cloud_Y_Pos = 13'd34;
		  end
		  else
		  begin
				is_Cloud = 1'b0;
				Cloud_X_Pos = 13'd0;
				Cloud_Y_Pos = 13'd0;
		  end
    end



endmodule

module L_mountain (input [12:0]   DrawX, DrawY,       // Current pixel coordinates
				  input [12:0]	  process,
				  output logic   is_L_mountain,           // Whether current pixel belongs to Mario or background
				  output logic [12:0] L_mountain_X_Pos, L_mountain_Y_Pos
				  );
	 
	 always_comb begin
        
		  if ( DrawX+process >= 13'd0 && DrawX+process < 13'd160 && DrawY >= 13'd346 && DrawY < 13'd416 )
		  begin
            is_L_mountain = 1'b1;
				L_mountain_X_Pos = 13'd0;
				L_mountain_Y_Pos = 13'd346;
		  end
        else if ( DrawX+process >= 13'd1536 && DrawX+process < 13'd1696 && DrawY >= 13'd346 && DrawY < 13'd416 )
		  begin
            is_L_mountain = 1'b1;
				L_mountain_X_Pos = 13'd1536;
				L_mountain_Y_Pos = 13'd346;
		  end
		  
		  else if ( DrawX+process >= 13'd3072 && DrawX+process < 13'd3232 && DrawY >= 13'd346 && DrawY < 13'd416 )
		  begin
            is_L_mountain = 1'b1;
				L_mountain_X_Pos = 13'd3072;
				L_mountain_Y_Pos = 13'd346;
		  end
		  else if ( DrawX+process >= 13'd4608 && DrawX+process < 13'd4768 && DrawY >= 13'd346 && DrawY < 13'd416 )
		  
		  begin
            is_L_mountain = 1'b1;
				L_mountain_X_Pos = 13'd4608;
				L_mountain_Y_Pos = 13'd346;
		  end
		  else if ( DrawX+process >= 13'd6144 && DrawX+process < 13'd6304 && DrawY >= 13'd346 && DrawY < 13'd416 )
		  begin
            is_L_mountain = 1'b1;
				L_mountain_X_Pos = 13'd6144;
				L_mountain_Y_Pos = 13'd346;
		  end
		  else
		  begin
				is_L_mountain = 1'b0;
				L_mountain_X_Pos = 13'd0;
				L_mountain_Y_Pos = 13'd0;
		  end
    end



endmodule

module S_mountain (input [12:0]   DrawX, DrawY,       // Current pixel coordinates
				  input [12:0]	  process,
				  output logic   is_S_mountain,           // Whether current pixel belongs to Mario or background
				  output logic [12:0] S_mountain_X_Pos, S_mountain_Y_Pos
				  );
	 
	 always_comb begin
        
		  if ( DrawX+process >= 13'd754 && DrawX+process < 13'd818 && DrawY >= 13'd384 && DrawY < 13'd416 )
		  begin
            is_S_mountain = 1'b1;
				S_mountain_X_Pos = 13'd754;
				S_mountain_Y_Pos = 13'd384;
		  end
        else if ( DrawX+process >= 13'd2290 && DrawX+process < 13'd2354 && DrawY >= 13'd384 && DrawY < 13'd416 )
		  begin
            is_S_mountain = 1'b1;
				S_mountain_X_Pos = 13'd2290;
				S_mountain_Y_Pos = 13'd384;
		  end
		  
		  else if ( DrawX+process >= 13'd3826 && DrawX+process < 13'd3890 && DrawY >= 13'd384 && DrawY < 13'd416 )
		  begin
            is_S_mountain = 1'b1;
				S_mountain_X_Pos = 13'd3826;
				S_mountain_Y_Pos = 13'd384;
		  end
		  else if ( DrawX+process >= 13'd5362 && DrawX+process < 13'd5426 && DrawY >= 13'd384 && DrawY < 13'd416 )
		  
		  begin
            is_S_mountain = 1'b1;
				S_mountain_X_Pos = 13'd5362;
				S_mountain_Y_Pos = 13'd384;
		  end
		 
		  else
		  begin
				is_S_mountain = 1'b0;
				S_mountain_X_Pos = 13'd0;
				S_mountain_Y_Pos = 13'd0;
		  end
    end



endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Tube_1 (input [12:0]   DrawX, DrawY,       // Current pixel coordinates
				  input [12:0]	  process,
				  output logic   is_tube_1,           // Whether current pixel belongs to Mario or background
				  output logic [12:0] tube_1_X_Pos, tube_1_Y_Pos
				  );
	 
	 always_comb begin
        
		  if ( DrawX+process >= 13'd896 && DrawX+process < 13'd960 && DrawY >= 13'd352 && DrawY < 13'd416 )
		  begin
            is_tube_1 = 1'b1;
				tube_1_X_Pos = 13'd896;
				tube_1_Y_Pos = 13'd352;
		  end
        else if ( DrawX+process >= 13'd5216 && DrawX+process < 13'd5280 && DrawY >= 13'd352 && DrawY < 13'd416 )
		  begin
            is_tube_1 = 1'b1;
				tube_1_X_Pos = 13'd5216;
				tube_1_Y_Pos = 13'd352;
		  end
		  
		  else if ( DrawX+process >= 13'd5728 && DrawX+process < 13'd5792 && DrawY >= 13'd352 && DrawY < 13'd416 )
		  begin
            is_tube_1 = 1'b1;
				tube_1_X_Pos = 13'd5728;
				tube_1_Y_Pos = 13'd352;
		  end
		 
		  else
		  begin
				is_tube_1 = 1'b0;
				tube_1_X_Pos = 13'd0;
				tube_1_Y_Pos = 13'd0;
		  end
    end



endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Tube_2 (input [12:0]   DrawX, DrawY,       // Current pixel coordinates
				  input [12:0]	  process,
				  output logic   is_tube_2,           // Whether current pixel belongs to Mario or background
				  output logic [12:0] tube_2_X_Pos, tube_2_Y_Pos
				  );
	 
	 always_comb begin
        
		  if ( DrawX+process >= 13'd1216 && DrawX+process < 13'd1280 && DrawY >= 13'd320 && DrawY < 13'd416 )
		  begin
            is_tube_2 = 1'b1;
				tube_2_X_Pos = 13'd1216;
				tube_2_Y_Pos = 13'd320;
		  end
        
		  else
		  begin
				is_tube_2 = 1'b0;
				tube_2_X_Pos = 13'd0;
				tube_2_Y_Pos = 13'd0;
		  end
    end



endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Tube_3 (input [12:0]   DrawX, DrawY,       // Current pixel coordinates
				  input [12:0]	  process,
				  output logic   is_tube_3,           // Whether current pixel belongs to Mario or background
				  output logic [12:0] tube_3_X_Pos, tube_3_Y_Pos
				  );
	 
	 always_comb begin
        
		  if ( DrawX+process >= 13'd1472 && DrawX+process < 13'd1536 && DrawY >= 13'd288 && DrawY < 13'd416 )
		  begin
            is_tube_3 = 1'b1;
				tube_3_X_Pos = 13'd1472;
				tube_3_Y_Pos = 13'd288;
		  end
        else if ( DrawX+process >= 13'd1824 && DrawX+process < 13'd1888 && DrawY >= 13'd288 && DrawY < 13'd416 )
		  begin
            is_tube_3 = 1'b1;
				tube_3_X_Pos = 13'd1824;
				tube_3_Y_Pos = 13'd288;
		  end
		 
		  else
		  begin
				is_tube_3 = 1'b0;
				tube_3_X_Pos = 13'd0;
				tube_3_Y_Pos = 13'd0;
		  end
    end



endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Castle (input [12:0]   DrawX, DrawY,       // Current pixel coordinates
				  input [12:0]	  process,
				  output logic   is_castle,           // Whether current pixel belongs to Mario or background
				  output logic [12:0] castle_X_Pos, castle_Y_Pos
				  );
	 
	 always_comb begin
        
		  if ( DrawX+process >= 13'd6464 && DrawX+process < 13'd6624 && DrawY >= 13'd256 && DrawY < 13'd416 )
		  begin
            is_castle = 1'b1;
				castle_X_Pos = 13'd6464;
				castle_Y_Pos = 13'd256;
		  end
        
		  else
		  begin
				is_castle = 1'b0;
				castle_X_Pos = 13'd0;
				castle_Y_Pos = 13'd0;
		  end
    end



endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Rec (input [12:0]   DrawX, DrawY,       // Current pixel coordinates
				  input [12:0]	  process,
				  output logic   is_rec,           // Whether current pixel belongs to Mario or background
				  output logic [12:0] rec_X_Pos, rec_Y_Pos
				  );
	 
	 always_comb begin
        
		  if ( DrawX+process >= 13'd6336 && DrawX+process < 13'd6368 && DrawY >= 13'd384 && DrawY < 13'd416 )
		  begin
            is_rec = 1'b1;
				rec_X_Pos = 13'd6336;
				rec_Y_Pos = 13'd384;
		  end
        
		  else
		  begin
				is_rec = 1'b0;
				rec_X_Pos = 13'd0;
				rec_Y_Pos = 13'd0;
		  end
    end



endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Flag_gan (input [12:0]   DrawX, DrawY,       // Current pixel coordinates
				  input [12:0]	  process,
				  output logic   is_flag_gan,           // Whether current pixel belongs to Mario or background
				  output logic [12:0] flag_gan_X_Pos, flag_gan_Y_Pos
				  );
	 
	 always_comb begin
        
		  if ( DrawX+process >= 13'd6344 && DrawX+process < 13'd6360 && DrawY >= 13'd96 && DrawY < 13'd384 )
		  begin
            is_flag_gan = 1'b1;
				flag_gan_X_Pos = 13'd6344;
				flag_gan_Y_Pos = 13'd96;
		  end
        
		  else
		  begin
				is_flag_gan = 1'b0;
				flag_gan_X_Pos = 13'd0;
				flag_gan_Y_Pos = 13'd0;
		  end
    end



endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Brick (input [12:0]   DrawX, DrawY,       // Current pixel coordinates
				  input [12:0]	  process,
				  output logic   is_brick,           // Whether current pixel belongs to Mario or background
				  output logic [12:0] brick_X_Pos, brick_Y_Pos
				  );
	 logic [27:0] pos;
	 always_comb begin
        pos[27:12]=(DrawX+process)>>4;
		  pos[12:0]=(DrawY[11:0])>>5;

		  unique case (pos)
			   28'h0028009:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd640;
					brick_Y_Pos = 13'd288;
				end
				28'h0030009:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd768;
					brick_Y_Pos = 13'd288;
				end
				28'h002C009:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd704;
					brick_Y_Pos = 13'd288;
				end
				28'h009A009:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd2464;
					brick_Y_Pos = 13'd288;
				end
				28'h009E009:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd2528;
					brick_Y_Pos = 13'd288;
				end
				28'h00BC009:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd3008;
					brick_Y_Pos = 13'd288;
				end
				28'h00C8009:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd3200;
					brick_Y_Pos = 13'd288;
				end
				28'h00EC009:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd3776;
					brick_Y_Pos = 13'd288;
				end
				28'h0102009:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd4128;
					brick_Y_Pos = 13'd288;
				end
				28'h0104009:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd4160;
					brick_Y_Pos = 13'd288;
				end
				28'h0150009:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd5376;
					brick_Y_Pos = 13'd288;
				end
				28'h0152009:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd5408;
					brick_Y_Pos = 13'd288;
				end
				28'h0156009:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd5472;
					brick_Y_Pos = 13'd288;
				end
				//////////////////second level brick//////////////////
				28'h00A0005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd2560;
					brick_Y_Pos = 13'd160;
				end
				28'h00A2005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd2592;
					brick_Y_Pos = 13'd160;
				end
				28'h00A4005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd2624;
					brick_Y_Pos = 13'd160;
				end
				28'h00A6005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd2656;
					brick_Y_Pos = 13'd160;
				end
				28'h00A8005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd2688;
					brick_Y_Pos = 13'd160;
				end
				28'h00AA005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd2720;
					brick_Y_Pos = 13'd160;
				end
				28'h00AC005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd2752;
					brick_Y_Pos = 13'd160;
				end
				28'h00AE005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd2784;
					brick_Y_Pos = 13'd160;
				end
				///////
				28'h00B6005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd2912;
					brick_Y_Pos = 13'd160;
				end
				28'h00B8005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd2944;
					brick_Y_Pos = 13'd160;
				end
				28'h00BA005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd2976;
					brick_Y_Pos = 13'd160;
				end
				///

				28'h00F2005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd3872;
					brick_Y_Pos = 13'd160;
				end
				28'h00F4005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd3904;
					brick_Y_Pos = 13'd160;
				end
				28'h00F6005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd3936;
					brick_Y_Pos = 13'd160;
				end
				///
				28'h0100005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd4096;
					brick_Y_Pos = 13'd160;
				end
				//
				28'h0106005:
				begin
					is_brick = 1'b1;
					brick_X_Pos = 13'd4192;
					brick_Y_Pos = 13'd160;
				end
				//
				default:
					begin
						is_brick = 1'b0;
						brick_X_Pos = 13'd0;
						brick_Y_Pos = 13'd0;
					end
				endcase

    end



endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Qmark (input [12:0]   DrawX, DrawY,       // Current pixel coordinates
				  input [12:0]	  process,
				  output logic   is_qmark1, is_qmark2, is_qmark3, is_qmark4, is_qmark5, is_qmark6,
									  is_qmark7, is_qmark8, is_qmark9, is_qmark10, is_qmark11, is_qmark12, is_qmark13,
				  output logic [12:0] q_mark_X_Pos, q_mark_Y_Pos
				  );
	 logic [27:0] pos;
	 always_comb begin
        pos[23:12]=(DrawX+process)>>4;
		  pos[12:0]=(DrawY[11:0])>>5;
		  is_qmark1 = 1'b0;
		  is_qmark2 = 1'b0;
		  is_qmark3 = 1'b0;
		  is_qmark4 = 1'b0;
		  is_qmark5 = 1'b0;
		  is_qmark6 = 1'b0;
		  is_qmark7 = 1'b0;
		  is_qmark8 = 1'b0;
		  is_qmark9 = 1'b0;
		  is_qmark10 = 1'b0;
		  is_qmark11 = 1'b0;
		  is_qmark12 = 1'b0;
		  is_qmark13 = 1'b0;
		  
		  unique case (pos)
			   28'h0020009:
				begin
					is_qmark1 = 1'b1;
					q_mark_X_Pos = 13'd512;
					q_mark_Y_Pos = 13'd288;
				end
				28'h002A009:
				begin
					is_qmark2 = 1'b1;
					q_mark_X_Pos = 13'd672;
					q_mark_Y_Pos = 13'd288;
				end
				28'h002E009:
				begin
					is_qmark4 = 1'b1;
					q_mark_X_Pos = 13'd736;
					q_mark_Y_Pos = 13'd288;
				end
				28'h002C005:
				begin
					is_qmark3 = 1'b1;
					q_mark_X_Pos = 13'd704;
					q_mark_Y_Pos = 13'd160;
				end
				28'h009C009:
				begin
					is_qmark5 = 1'b1;
					q_mark_X_Pos = 13'd2496;
					q_mark_Y_Pos = 13'd288;
				end
				28'h00BC005:
				begin
					is_qmark6 = 1'b1;
					q_mark_X_Pos = 13'd3008;
					q_mark_Y_Pos = 13'd160;
				end
				28'h0102005:
				begin
					is_qmark11 = 1'b1;
					q_mark_X_Pos = 13'd4128;
					q_mark_Y_Pos = 13'd160;
				end
				28'h0104005:
				begin
					is_qmark12 = 1'b1;
					q_mark_X_Pos = 13'd4160;
					q_mark_Y_Pos = 13'd160;
				end
				28'h00DA005:
				begin
					is_qmark9 = 1'b1;
					q_mark_X_Pos = 13'd3488;
					q_mark_Y_Pos = 13'd160;
				end
				///////////////first level second half////////////
				28'h00D4009:
				begin
					is_qmark7 = 1'b1;
					q_mark_X_Pos = 13'd3392;
					q_mark_Y_Pos = 13'd288;
				end
				28'h00DA009:
				begin
					is_qmark8 = 1'b1;
					q_mark_X_Pos = 13'd3488;
					q_mark_Y_Pos = 13'd288;
				end
				28'h00E0009:
				begin
					is_qmark10 = 1'b1;
					q_mark_X_Pos = 13'd3584;
					q_mark_Y_Pos = 13'd288;
				end
				28'h0154009:
				begin
					is_qmark13 = 1'b1;
					q_mark_X_Pos = 13'd5440;
					q_mark_Y_Pos = 13'd288;
				end
				default:
				begin
					is_qmark1 = 1'b0;
					q_mark_X_Pos = 13'd0;
					q_mark_Y_Pos = 13'd0;
				end
			endcase

    end



endmodule
