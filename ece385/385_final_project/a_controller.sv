

module  a_controller     ( output [15:0]  LDATA, RDATA,
									output			Init, 
									input				Init_Finish, Reset, Clk, data_over,
									input	 [15:0]	FL_DQ,
									input 			frame_clk,
									input  [ 6:0]  image_show,
									output [21:0]  FL_ADDR
								  );   
    parameter [9:0] d1 = 7'd45;
	 parameter [9:0] d2 = 7'd50;
	 parameter [9:0] d3 = 7'd55;
	 parameter [9:0] d4 = 7'd59;
	 parameter [9:0] d5 = 7'd66;
	 parameter [9:0] d6 = 7'd73;
	 parameter [9:0] d7 = 7'd83;
	 parameter [9:0] dx = 7'd00;
	 
int duration, duration_in, counter, counter_in, Init_in, FL_ADDR_in;
enum logic [2:0] {init, read, stop} state, next_state;
logic LDATA_in, RDATA_in;

//logic [31:0][6:0] BGM; 
//assign BGM[0][6:0] = d3;//d3;
//assign BGM[1][6:0] = d3;//d3;
//assign BGM[2][6:0] = d4;//d4;
//assign BGM[3][6:0] = d5;//d5;
//assign BGM[4][6:0] = d5;//d5;
//assign BGM[5][6:0] = d4;//d4;
//assign BGM[6][6:0] = d3;//d3;
//assign BGM[7][6:0] = d2;
//assign BGM[8][6:0] = d1;
//assign BGM[9][6:0] = d1;
//assign BGM[10][6:0] = d2;
//assign BGM[11][6:0] = d3;
//assign BGM[12][6:0] = d3;
//assign BGM[13][6:0] = d2;
//assign BGM[14][6:0] = d2;
//assign BGM[15][6:0] = d3;
//assign BGM[16][6:0] = d3;
//assign BGM[17][6:0] = d4;
//assign BGM[18][6:0] = d5;
//assign BGM[19][6:0] = d5;
//assign BGM[20][6:0] = d4;
//assign BGM[21][6:0] = d3;
//assign BGM[22][6:0] = d2;
//assign BGM[23][6:0] = d1;
//assign BGM[24][6:0] = d1;
//assign BGM[25][6:0] = d2;
//assign BGM[26][6:0] = d3;
//assign BGM[27][6:0] = d2;
//assign BGM[28][6:0] = d1;
//assign BGM[29][6:0] = d1;
//assign BGM[30][6:0] = dx;
//assign BGM[31][6:0] = dx;
	

	always_ff @ (posedge Clk) begin
		if (Reset) begin 
			LDATA <= 16'hFFFF;
			RDATA <= 16'hFFFF;
			Init  <= 1'b0;
			counter <= 1;
			duration <= 0;
			state<= init;
			FL_ADDR <= 22'd0;
			end
		else begin
			LDATA <= LDATA_in;
			RDATA <= RDATA_in;
			Init  <= Init_in;
			counter <= counter_in;
			duration <= duration_in;
			state <= next_state;
			FL_ADDR <= FL_ADDR_in;
		end
	end

	always_comb begin
		next_state = state;
		RDATA_in = RDATA;
		Init_in = Init;
		FL_ADDR_in = FL_ADDR;
		unique case(state)
			init:
				begin
					//if (image_show[2])
					if (Reset)
						Init_in = 1'b1;
					if (Init_Finish)
						next_state = read;
					else
						next_state = init;
				end
			// in read state, we need to send address and in stop state, we need to do D/A for signal
			read:
				begin
					next_state = stop;
				end
			stop:
				begin
					if (data_over) begin
						next_state = read;
						RDATA_in = RDATA + FL_DQ;
						FL_ADDR_in = FL_ADDR + 22'd1;
					end
					else
						next_state = stop;
				end
			default:;
		endcase
	end	
endmodule
