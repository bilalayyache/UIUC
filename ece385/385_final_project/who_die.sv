module who_die
					(input       Clk,                // 50 MHz clock
								    Reset,              // Active-high reset signal
					 input [12:0] Mario_X_Pos, Mario_Y_Pos, Goomba_X_Pos, Goomba_Y_Pos,
					 input [12:0] Mario_Y_Motion,
					 // input logic game_over,
					 output is_Mario_die, is_goomba_die);
					 
	logic is_Mario_die_in, is_goomba_die_in;			 
			
	always_ff @(posedge Clk) begin
		if (Reset) begin
			is_Mario_die <= 1'b0;
			is_goomba_die <= 1'b0;
		end
		else begin
			is_Mario_die <= is_Mario_die_in;
			is_goomba_die <= is_goomba_die_in;
		end
	
	end
	
	always_comb begin
		is_Mario_die_in = is_Mario_die;
		is_goomba_die_in = is_goomba_die;
		if (Mario_Y_Pos < Goomba_Y_Pos +13'd32 &&   Goomba_Y_Pos < Mario_Y_Pos +13'd32 && Mario_X_Pos < Goomba_X_Pos +13'd32 &&   Goomba_X_Pos < Mario_X_Pos +13'd32)
		begin
			if (Mario_Y_Motion > 13'd0 && (~ Mario_Y_Motion[12]) && (~is_Mario_die))
				is_goomba_die_in = 1'd1;
			else if (~is_goomba_die)
				is_Mario_die_in = 1'd1;
		end
	end

endmodule
