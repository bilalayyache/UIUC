module SRAM_READ   ( 	input logic Clk, Reset,
								input logic [19:0]  ADDR,
								input logic CE, UB, LB, OE, WE,
								input logic [15:0]  Data_from_SRAM,
								output logic [15:0] Data_to_CPU);

   
	// Load data from switches when address is xFFFF, and from SRAM otherwise.
	always_comb
		begin 
			Data_to_CPU = 16'd0;
			if (WE && ~OE)  
				Data_to_CPU = Data_from_SRAM;
   end

endmodule
