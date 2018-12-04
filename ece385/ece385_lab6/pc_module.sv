module pc_module

		(	input	logic	[15:0]	pc_din1,
										pc_din2,
			input	logic				LD_PC,
			input logic 			Clk,
										Reset,
			input	logic	[1:0]		PCMUX,
			output logic [15:0]	PC
		);
		
		
		logic [15:0] PCMUX_OUT;

		register pc(.Clk, .Reset, .Load(LD_PC), .Din(PCMUX_OUT), .Data_Out(PC));
		mux4 pcmux(.d0(PC+16'h1), .d1(pc_din1), .d2(pc_din2), .d3(16'h0000), .s0(PCMUX[0]), .s1(PCMUX[1]), .y(PCMUX_OUT));

		
endmodule
