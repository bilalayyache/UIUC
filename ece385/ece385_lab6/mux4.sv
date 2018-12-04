module mux4
		#(parameter width = 16)
		(	input		logic[width-1 : 0] d0, d1, d2, d3,
			input		logic s0, s1,
			output	logic[width-1 : 0] y
		);
		
		logic	[1:0]	s;
		assign s = {s1, s0};

		always_comb begin
			unique case (s)
				2'b00:	y = d0;
				2'b01:	y = d1;
				2'b10:	y = d2;
				2'b11:	y = d3;
				default : ;
			endcase
		end
		
endmodule
