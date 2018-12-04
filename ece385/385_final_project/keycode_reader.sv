module keycode_reader(
								input [15:0] keycode,
								output logic space_on, a_on, s_on, d_on, enter_on
							);

always_comb begin
	space_on = (keycode[15:8] == 8'h2C | keycode[7:0] == 8'h2C);
	a_on = (keycode[15:8] == 8'h04 | keycode[7:0] == 8'h04);
	s_on = (keycode[15:8] == 8'h16 | keycode[7:0] == 8'h16);
	d_on = (keycode[15:8] == 8'h07 | keycode[7:0] == 8'h07);
	enter_on = (keycode[15:8] == 8'h28 | keycode[7:0] == 8'h28);
end
endmodule


//	space_on = (keycode[7:0] == 8'h2C)? 1'b1 : 1'b0;
//	a_on = (keycode[7:0] == 8'h04) ? 1'b1 : 1'b0;
//	s_on = (keycode[7:0] == 8'h16) ? 1'b1 : 1'b0;
//	d_on = (keycode[7:0] == 8'h07) ? 1'b1 : 1'b0;