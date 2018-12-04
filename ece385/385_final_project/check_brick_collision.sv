module check_brick_collision
										(input [12:0] Mario_X_Pos, Mario_Y_Pos,
										 output logic [12:0] is_collision);

	// total 13 bricks need to check
	// total two levels of Y
   parameter [12:0] Y_1 = 13'd354;
	parameter [12:0] Y_2 = 13'd226;
	parameter [12:0] X_1 = 13'd512;
	parameter [12:0] X_2 = 13'd672;
	parameter [12:0] X_3 = 13'd704;
	parameter [12:0] X_4 = 13'd736;
	parameter [12:0] X_5 = 13'd2496;
	parameter [12:0] X_6 = 13'd3008;
	parameter [12:0] X_7 = 13'd3392;
	parameter [12:0] X_8 = 13'd3488;
	parameter [12:0] X_9 = 13'd3584;
	parameter [12:0] X_10 = 13'd4128;
	parameter [12:0] X_11 = 13'd4160;
	parameter [12:0] X_12 = 13'd5440;
	

	always_comb begin
		is_collision = 13'b0;
		if (Mario_X_Pos + 13'd16 > X_1 && Mario_X_Pos < X_1 + 13'd16 && Mario_Y_Pos < Y_1 && Mario_Y_Pos > Y_1 - 13'd32)
			is_collision[0] = 1'b1;
		if (Mario_X_Pos + 13'd16 > X_2 && Mario_X_Pos < X_2 + 13'd16 && Mario_Y_Pos < Y_1 && Mario_Y_Pos > Y_1 - 13'd32)
			is_collision[1] = 1'b1;
		if (Mario_X_Pos + 13'd16 > X_3 && Mario_X_Pos < X_3 + 13'd16 && Mario_Y_Pos < Y_2 && Mario_Y_Pos > Y_2 - 13'd32)
			is_collision[2] = 1'b1;
		if (Mario_X_Pos + 13'd16 > X_4 && Mario_X_Pos < X_4 + 13'd16 && Mario_Y_Pos < Y_1 && Mario_Y_Pos > Y_1 - 13'd32)
			is_collision[3] = 1'b1;
		if (Mario_X_Pos + 13'd16 > X_5 && Mario_X_Pos < X_5 + 13'd16 && Mario_Y_Pos < Y_1 && Mario_Y_Pos > Y_1 - 13'd32)
			is_collision[4] = 1'b1;
		if (Mario_X_Pos + 13'd16 > X_6 && Mario_X_Pos < X_6 + 13'd16 && Mario_Y_Pos < Y_2 && Mario_Y_Pos > Y_2 - 13'd32)
			is_collision[5] = 1'b1;
		if (Mario_X_Pos + 13'd16 > X_7 && Mario_X_Pos < X_7 + 13'd16 && Mario_Y_Pos < Y_1 && Mario_Y_Pos > Y_1 - 13'd32)
			is_collision[6] = 1'b1;
		if (Mario_X_Pos + 13'd16 > X_8 && Mario_X_Pos < X_8 + 13'd16 && Mario_Y_Pos < Y_1 && Mario_Y_Pos > Y_1 - 13'd32)
			is_collision[7] = 1'b1;
		if (Mario_X_Pos + 13'd16 > X_8 && Mario_X_Pos < X_8 + 13'd16 && Mario_Y_Pos < Y_2 && Mario_Y_Pos > Y_2 - 13'd32)
			is_collision[8] = 1'b1;
		if (Mario_X_Pos + 13'd16 > X_9 && Mario_X_Pos < X_9 + 13'd16 && Mario_Y_Pos < Y_1 && Mario_Y_Pos > Y_1 - 13'd32)
			is_collision[9] = 1'b1;
		if (Mario_X_Pos + 13'd16 > X_10 && Mario_X_Pos < X_10 + 13'd16 && Mario_Y_Pos < Y_2 && Mario_Y_Pos > Y_2 - 13'd32)
			is_collision[10] = 1'b1;
		if (Mario_X_Pos + 13'd16 > X_11 && Mario_X_Pos < X_11 + 13'd16 && Mario_Y_Pos < Y_2 && Mario_Y_Pos > Y_2 - 13'd32)
			is_collision[11] = 1'b1;
		if (Mario_X_Pos + 13'd16 > X_12 && Mario_X_Pos < X_12 + 13'd16 && Mario_Y_Pos < Y_1 && Mario_Y_Pos > Y_1 - 13'd32)
			is_collision[12] = 1'b1;
	end
	
endmodule
