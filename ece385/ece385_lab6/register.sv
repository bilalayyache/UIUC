// 16-bit registers 
module register	#(parameter width = 16)
						(	input  logic 					Clk,
																Reset,
																Load,
							input  logic[width-1:0]  	Din,
							output logic[width-1:0]  	Data_Out);
						

	always_ff @ (posedge Clk)
		begin
			if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
				Data_Out <= {width{1'b0}};
			else if (Load)
				Data_Out <= Din;
		end
						
endmodule
