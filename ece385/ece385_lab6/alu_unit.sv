module alu_unit
			(	input	logic[15:0] regA,
				input logic[15:0]	regB,
				input	logic[1:0]	ALUK,
				output logic[15:0] ALU		
			);
			
			// ALUK is the function selects bit
			// if ALUK = 00, do ADD
			// if ALUK = 01, do AND
			// if ALUK = 10, do NOT regA
			// if ALUK = 11, do PASS regA
			always_comb begin
				unique case (ALUK)
					2'b00 :
						ALU = regA + regB;
					2'b01 :
						ALU = regA & regB;
					2'b10 :
						ALU = ~regA;
					2'b11 :
						ALU = regA;
					default :;
				endcase
			end
			
			
			
			
endmodule
