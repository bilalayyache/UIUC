

module  audio_controller ( output [15:0]  LDATA, RDATA,
									output			Init, 
									input				Init_Finish, Reset, Clk, data_over,
									input 			frame_clk
								  );   
    parameter [9:0] d1 = 8'd44;//8'd65;
	 parameter [9:0] d2 = 8'd50;//8'd73;
	 parameter [9:0] d3_= 8'd52;//8'd78;
	 parameter [9:0] d3 = 8'd55;//8'd82;
	 parameter [9:0] d4 = 8'd59;//8'd87;
	 parameter [9:0] d5 = 8'd66;//8'd98;
	 parameter [9:0] d6 = 8'd73;//8'd110;
	 parameter [9:0] d7 = 8'd83;//8'd123;
	 parameter [9:0] h1 = 8'd88;//8'd131;
	 parameter [9:0] l1 = 8'd33;
	 parameter [9:0] l2 = 8'd101;
	 parameter [9:0] l3 = 8'd28;//8'd37;//
	 parameter [9:0] l4 = 8'd35;//8'd41;//
	 parameter [9:0] l5 = 8'd33;//8'd44;//
	 parameter [9:0] l6 = 8'd36;//8'd49;//
	 parameter [9:0] l7 = 8'd39;//8'd55;//
	 parameter [9:0] l71 = 8'd41;//;
	 parameter [9:0] dx = 8'd00;
	 
int duration, counter;
enum logic [1:0] {Normal} state,next_state;

logic [126:0][7:0] BGM; 
always_comb begin

		BGM[0][7:0] = d3;//d3;
		BGM[1][7:0] = dx;//d3;
		BGM[2][7:0] = d3;//d4;
		BGM[3][7:0] = dx;//d5;
		BGM[4][7:0] = d3;//d5;
		BGM[5][7:0] = dx;//d4;
		BGM[6][7:0] = d1;//d3;
		BGM[7][7:0] = d3;
		BGM[9][7:0] = dx;
		BGM[10][6:0] = d5;
		BGM[11][6:0] = dx;
		BGM[12][6:0] = l5;
		BGM[13][6:0] = l5;
		BGM[14][6:0] = dx;
		BGM[15][6:0] = d1;
		BGM[16][6:0] = dx;
		BGM[17][6:0] = l5;
		BGM[18][6:0] = dx;
		BGM[19][6:0] = l3;
		BGM[20][6:0] = dx;
		BGM[21][6:0] = l6;
		BGM[22][6:0] = dx;
		BGM[23][6:0] = l71;
		BGM[24][6:0] = dx;
		BGM[25][6:0] = l7;
		BGM[26][6:0] = l6;
		BGM[27][6:0] = dx;
		BGM[28][6:0] = l5;
		BGM[29][6:0] = d3;
		BGM[30][6:0] = dx;
		BGM[31][6:0] = d5;
		BGM[32][6:0] = dx;
		BGM[33][6:0] = d6;
		BGM[34][6:0] = d4;
		BGM[35][6:0] = dx;
		BGM[36][6:0] = d5;
		BGM[37][6:0] = d3;
		BGM[38][6:0] = dx;
		BGM[39][6:0] = d1;
		BGM[40][6:0] = dx;
		BGM[41][6:0] = d2;
		BGM[42][6:0] = l71;
		BGM[43][6:0] = l71;
		
		BGM[44][6:0] = dx;
		BGM[45][6:0] = d1;
		BGM[46][6:0] = dx;
		BGM[47][6:0] = l5;
		BGM[48][6:0] = dx;
		BGM[49][6:0] = l3;
		BGM[50][6:0] = dx;
		BGM[51][6:0] = l6;
		BGM[52][6:0] = dx;
		BGM[53][6:0] = l71;
		BGM[54][6:0] = dx;
		BGM[55][6:0] = l7;
		BGM[56][6:0] = l6;
		BGM[57][6:0] = dx;
		BGM[58][6:0] = l5;
		BGM[59][6:0] = d3;
		BGM[60][6:0] = dx;
		BGM[61][6:0] = d5;
		BGM[62][6:0] = dx;
		BGM[63][6:0] = d6;
		BGM[64][6:0] = d4;
		BGM[65][6:0] = dx;
		BGM[66][6:0] = d5;
		BGM[67][6:0] = d3;
		BGM[68][6:0] = dx;
		BGM[69][6:0] = d1;
		BGM[70][6:0] = dx;
		BGM[71][6:0] = d2;
		BGM[72][6:0] = l71;
		BGM[73][6:0] = l71;
		
		BGM[74][6:0] = dx;
		BGM[75][6:0] = d5;
		BGM[76][6:0] = d4;
		BGM[77][6:0] = dx;
		BGM[78][6:0] = d2;
		BGM[79][6:0] = d3;
		BGM[80][6:0] = dx;
		BGM[81][6:0] = l5;
		BGM[82][6:0] = dx;
		BGM[83][6:0] = l6;
		BGM[84][6:0] = d1;
		BGM[85][6:0] = dx;
		BGM[86][6:0] = l6;
		BGM[87][6:0] = d1;
		BGM[88][6:0] = dx;
		BGM[89][6:0] = d2;
		BGM[90][6:0] = dx;
		BGM[91][6:0] = d5;
		BGM[92][6:0] = d4;
		BGM[93][6:0] = d2;
		BGM[94][6:0] = d3;
		BGM[95][6:0] = dx;
		BGM[96][6:0] = d3;
		BGM[97][6:0] = h1;
		BGM[98][6:0] = dx;
		BGM[99][6:0] = h1;
		BGM[100][6:0] = h1;
		BGM[101][6:0] = dx;
		
		BGM[102][6:0] = d5;
		BGM[103][6:0] = d4;
		BGM[104][6:0] = d2;
		BGM[105][6:0] = d3;
		BGM[106][6:0] = dx;
		BGM[107][6:0] = l5;
		BGM[108][6:0] = dx;
		BGM[109][6:0] = l6;
		BGM[110][6:0] = d1;
		BGM[111][6:0] = dx;
		BGM[112][6:0] = l6;
		BGM[113][6:0] = d1;
		BGM[114][6:0] = dx;
		BGM[115][6:0] = d2;
		BGM[116][6:0] = dx;
		BGM[117][6:0] = d3_;
		BGM[118][6:0] = d3_;
		BGM[119][6:0] = dx;
		BGM[120][6:0] = d2;
		BGM[121][6:0] = dx;
		BGM[122][6:0] = d1;
		BGM[123][6:0] = d1;
		BGM[124][6:0] = dx;
		BGM[125][6:0] = dx;
		BGM[126][6:0] = dx;
	
end
always_comb
	begin	
	unique case(state)
		Normal:
		begin
		next_state<=Normal;
		end
	endcase
end	
	

always_ff @ (posedge Clk or posedge Reset)
	begin
		if ( Reset ) 
			begin 
				LDATA <= 16'hFFFF;
				RDATA <= 16'hFFFF;
				Init  <= 1'b1;
				counter <= 1;
				duration <= 0;
				state<= Normal;
			end
		else
			begin
	
		state <= next_state;

			if(Init_Finish)
				begin
					duration <= duration + 1;
					if(data_over)
					begin
						RDATA <= RDATA + BGM[counter][6:0];
					end
					else//DO
					begin
						Init <= 1'b0;
						LDATA <= LDATA;
						if(counter < 130)
						begin
							counter <= counter + duration/50000;
							duration <= duration%50000;
						end
						else
						begin
							counter <= 0;
						end
					end
				end
				else//IF
				begin
					Init <= Init;
					LDATA <= LDATA;
					RDATA <= RDATA;
				end
			end
		
	end

endmodule
