module bus
				(	input		logic[15:0]		MDR,
													PC,
													ALU,
													MARMUX,
					input		logic				GateMDR,
													GatePC,
													GateALU,
													GateMARMUX,
					output	logic[15:0]		OUTPUT
				);

				always_comb begin
					if (GateMDR)
						OUTPUT = MDR;
					else if (GatePC)
						OUTPUT = PC;
					else if (GateALU)
						OUTPUT = ALU;
					else if (GateMARMUX)
						OUTPUT = MARMUX;
					else
						OUTPUT = {16{1'bx}};
				end

endmodule
