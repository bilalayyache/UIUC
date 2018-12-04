module nzp
		(	input logic				Clk, Reset,
			input logic[15:0]		IR, BUS_val,
			input logic				LD_CC, LD_BEN,
			output logic			BEN
		);
		
		logic DN, DZ, DP;
		logic N, Z, P;
		logic n, z, p;
		logic DBEN;
		
		always_comb
		begin
		DN = 0;
		DZ = 0;
		DP = 0;
		n = IR[11];
		z = IR[10];
		p = IR[9];
		DBEN = (N&n)|(Z&z)|(P&p);

		if (BUS_val == 16'b0)
			DZ = 1;
		else if (BUS_val[15] == 1'b0)
			DP = 1;
		else if (BUS_val[15] == 1'b1)
			DN = 1;
		end

		always_ff @ (posedge Clk)
		begin
			if (Reset) begin
				N <= 1'b0;
				Z <= 1'b0;
				P <= 1'b0;
				BEN <= 1'b0;
			end
			else if (LD_CC) begin
				N <= DN;
				Z <= DZ;
				P <= DP;
			end
			else if (LD_BEN)
				BEN <= DBEN;
		end
		
endmodule
