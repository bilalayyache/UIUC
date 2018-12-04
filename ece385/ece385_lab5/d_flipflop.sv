module D_FF(	input  logic 	Clk,
										Reset,
										D,
					output logic 	Q);
					

		always_ff @ (posedge Clk)
				begin
					if (!Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
						Q <= 1'b0;
					else
						Q <= D;
					
				end

endmodule
