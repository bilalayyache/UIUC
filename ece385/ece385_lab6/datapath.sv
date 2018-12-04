module datapath
		(	  
			input logic 		Clk,
									Reset,
			
			input logic    	LD_MAR,
									LD_MDR,
									LD_IR,
									LD_BEN,
									LD_CC,
									LD_REG,
									LD_PC,
									LD_LED, // for PAUSE instruction

			input logic      	GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,
									MIO_EN,
									
			input logic[15:0] MDR_In,

			input logic[1:0] 	PCMUX,
			input logic       DRMUX,
									SR1MUX,
									SR2MUX,
									ADDR1MUX,
			
			input logic [1:0] ADDR2MUX,
									ALUK,
									
			output logic[15:0] MAR, MDR, IR, PC, ALU, MARMUX,
			output logic[11:0] LED,
			output logic BEN
			
			
			
		);
		
		// temp variable to hold the value of output of bus
		logic[15:0] temp;
		
		bus BUS(.MDR,
				  .PC,
				  .ALU,
				  .MARMUX,
				  .GateMDR,
				  .GatePC,
				  .GateALU,
				  .GateMARMUX,
				  .OUTPUT(temp));
		
		// just for week 1 (pc_din2 = 0)
		pc_module pc(.pc_din1(temp), .pc_din2(MARMUX), .LD_PC, .Clk, .Reset, .PCMUX, .PC);
		register mar(.Clk, .Reset, .Load(LD_MAR), .Din(temp), .Data_Out(MAR));
		
		// maybe have bugs on MIO_EN
		mdr_module mdr(.Clk, .Reset, .LD_MDR, .mdr_din0(temp), .mdr_din1(MDR_In), .MIO_EN(MIO_EN), .MDR);
		
		// IR
		register ir(.Clk, .Reset, .Load(LD_IR), .Din(temp), .Data_Out(IR));
		
		
		logic[15:0]		sr1_out, sr2_out, sr2mux_out;
		// register file
		register_module reg_file(.BUS_val(temp), .IR,
                               .Clk, .Reset,
                               .DRMUX, .SR1MUX, .LD_REG,
                               .SR1_OUT(sr1_out), .SR2_OUT(sr2_out));
										 
		// ALU
		alu_unit alu(.regA(sr1_out), .regB(sr2mux_out), .ALUK, .ALU);
		
		// SR2MUX
		mux4 sr2mux(.d0(sr2_out), .d1({{11{IR[4]}}, IR[4:0]}), .d2(16'b0), .d3(16'b0), .s0(IR[5]), .s1(1'b0), .y(sr2mux_out));

		logic[15:0]	addr2mux_out;
		// ADDR2MUX
		mux4 addr2mux(.d0(16'b0),
						  .d1({{10{IR[5]}}, IR[5:0]}),
						  .d2({{7{IR[5]}}, IR[8:0]}),
						  .d3({{5{IR[5]}}, IR[10:0]}),
						  .s0(ADDR2MUX[0]),
						  .s1(ADDR2MUX[1]),
						  .y(addr2mux_out));
		
		logic[15:0] addr1mux_out;
		// ADDR1MUX
		mux4 addr1mux(.d0(PC), .d1(sr1_out), .d2(16'b0), .d3(16'b0), .s0(ADDR1MUX), .s1(1'b0), .y(addr1mux_out));
		
		assign MARMUX = addr1mux_out + addr2mux_out;
		
		// BEN
		nzp ben(.Clk, .Reset, .IR, .BUS_val(temp), .LD_BEN, .LD_CC, .BEN);
		
		// LED for pause state
		register #(.width(12)) led(.Clk, .Reset, .Load(LD_LED), .Din(IR[11:0]), .Data_Out(LED));

endmodule
