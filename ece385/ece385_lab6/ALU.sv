module ALU(	input  logic[1:0]		ALUK,
				input  logic[15:0]  	A,B,
				output logic[15:0]  	ALU
				);
						

	always_comb begin
					if (ALUK==2b'00)					//passA
						ALU_OUT = A;
					else if (ALUK==2b'01)			//NOT
						ALU_OUT = ~A;
					else if (ALUK==2b'10)			//AND
						ALU_OUT = A&B;
					else									//ADD
						ALU_OUT = A;
				end
						
endmodule
