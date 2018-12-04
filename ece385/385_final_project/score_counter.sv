module score_counter
						  (input Clk, Reset, win_game,
						   input [12:0] done,
							input [4:0] rip,
							input [12:0] Mario_X_Pos,
							output logic [15:0] score_display);

	// Display time on hex display
	logic [15:0] score_display_in;
	
	always_ff @(posedge Clk) begin
		if (Reset) begin
			score_display <= 16'h0000;
		end
		else begin
			score_display <= score_display_in;
		end
	end
	
	always_comb begin
		score_display_in = 16'd0;
		for (integer i = 0; i < 13; i++) begin
			score_display_in = score_display_in + 16 * done[i];
			if (score_display_in[7:0] > 16'h90)
				score_display_in = score_display_in + 16'h0060;
		end
		for (integer i = 0; i < 5; i++) begin
			score_display_in = score_display_in + rip[i] * 16'h0050;
			if (score_display_in[7:0] > 16'h90)
				score_display_in = score_display_in + 16'h0060;
		end
		if (win_game)
		// if (Mario_X_Pos >= 13'd6322)
			score_display_in = score_display_in + 16'h0200;
	end



endmodule
