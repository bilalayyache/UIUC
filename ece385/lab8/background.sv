module BACKGROUND (// input Clk,
						 input [12:0]   DrawX, DrawY,       // Current pixel coordinates
						 input [12:0]	 process,
						 input [23:0]   cloud_dout, L_mountain_dout,S_mountain_dout, tube_1_dout, tube_2_dout, tube_3_dout, castle_dout,
						 output [23:0]  background_dout,
						 output [12:0]  Cloud_X_Pos, Cloud_Y_Pos,castle_X_Pos, castle_Y_Pos,
						 output [12:0]  L_mountain_X_Pos, L_mountain_Y_Pos, S_mountain_X_Pos, S_mountain_Y_Pos,
						 output [12:0]  tube_1_X_Pos, tube_1_Y_Pos, tube_2_X_Pos, tube_2_Y_Pos, tube_3_X_Pos, tube_3_Y_Pos
						);

	  logic   is_Cloud, is_L_mountain, is_S_mountain, is_tube_1, is_tube_2, is_tube_3, is_castle; 	  // Whether current pixel belongs to Mario or background
	  
	  Cloud cloud1(.*);
	  L_mountain L_mountain_instance(.*);
	  S_mountain S_mountain_instance(.*);
	  Tube_1 tube_1_ins(.*);
	  Tube_2 tube_2_ins(.*);
	  Tube_3 tube_3_ins(.*);
	  Castle castle_ins(.*);
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
			else if (is_castle)
				background_dout = castle_dout;
			else
			begin
            // Background color
            background_dout[23:16] = 8'h6b; 
            background_dout[15: 8] = 8'h8c;
            background_dout[ 7: 0] = 8'hff;
        end
	  end



endmodule



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
		  else if ( DrawX+process >= 13'd4608 && DrawX+process < 13'd4736 && DrawY >= 13'd346 && DrawY < 13'd416 )
		  
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
