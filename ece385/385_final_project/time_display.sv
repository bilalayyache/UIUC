module time_display (input Clk, Reset,
							output logic [15:0] time_display,
							output logic run_out);

	// Display time on hex display
	enum logic [1:0] {TIME} time_state, next_time_state;
	logic [15:0] time_display_in;
	logic [31:0] time_counter, time_counter_in;
	logic run_out_in;

	always_ff @(posedge Clk) begin
		if (Reset) begin
			time_state <= TIME;
			time_display <= 16'h0060;
			time_counter <= 32'd0;
			run_out <= 1'b0;
		end
		else begin
			time_state <= next_time_state;
			time_display <= time_display_in;
			time_counter <= time_counter_in;
			run_out <= run_out_in;
		end
	end
	
	always_comb begin
		next_time_state = time_state;
		time_display_in = time_display;
		time_counter_in = time_counter;
		run_out_in = run_out;
		if (time_counter == 32'h3938700) begin
			time_counter_in = 30'b0;
			if (time_display == 16'b0) begin
				run_out_in = 1'b1;
				time_display_in = 16'h0000;
			end
			else if (time_display[7:0] == 8'h00) begin
				time_display_in = time_display - 16'd103;
			end
			else if (time_display[3:0] == 4'b0000) begin
				time_display_in = time_display - 16'd7;
			end
			else begin
				time_display_in = time_display - 16'd1;
			end
		end
		else begin
			time_counter_in = time_counter + 32'b1;
		end
	end
			
							
endmodule
