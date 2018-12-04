module coin_total
					#(parameter X_Start = 13'd320;
					  parameter Y_Start = 13'd240)
					  
					( input       Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [12:0]  DrawX, DrawY,       // Current pixel coordinates
					input [23:0]  coin1_dout, coin2_dout, coin3_dout, coin4_dout,
					input [12:0]  process,
               output logic  is_coin,            // Whether current pixel belongs to Goomba or background
					input logic   collision,
					output logic [12:0] coin_X_Pos, coin_Y_Pos,
					output logic [23:0] coin_dout,
					output logic [3:0]  state_number
              );
    
	 coin_image coin_image_ins(.*);
	 coin_movement #(X_Start, Y_Start) coin_movement_instance(.*);
	 always_comb begin
        if ( coin_X_Pos <= process + DrawX && DrawX + process < coin_X_Pos +13'd32 && DrawY >= coin_Y_Pos && DrawY < coin_Y_Pos + 13'd32) 
            is_coin = 1'b1;
        else
            is_coin = 1'b0;

    end

endmodule
