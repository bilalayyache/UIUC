module  Goomba #(parameter X_Min = 13'd0;
					  parameter X_Max = 13'd895;
					  parameter X_Start = 13'd512)
					  
					( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [12:0]   DrawX, DrawY,       // Current pixel coordinates
					input [23:0] goomba_1_dout, goomba_2_dout, goomba_die_dout, background_dout,
					input [12:0] process,
               output logic  is_Goomba,            // Whether current pixel belongs to Goomba or background
					input logic is_goomba_die,
					output logic [12:0] Goomba_X_Pos, Goomba_Y_Pos,
					output logic [23:0] goomba_dout,
					output logic rip
              );
    
	 //logic is_in_air;
	 Goomba_image Goomba_image_instance(.*);
	 Goomba_movement #(X_Min, X_Max, X_Start) Goomba_movement_instance(.*);
	 always_comb begin
        if ( Goomba_X_Pos <= process + DrawX && DrawX + process < Goomba_X_Pos +13'd32 && DrawY >= Goomba_Y_Pos && DrawY < Goomba_Y_Pos + 13'd32) 
            is_Goomba = 1'b1;
        else
            is_Goomba = 1'b0;

    end
    
endmodule
