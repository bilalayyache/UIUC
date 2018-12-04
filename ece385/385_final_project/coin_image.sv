module  coin_image ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                            // frame_clk,          // The clock indicating a new frame (~60Hz)
               //input [12:0]   DrawX, DrawY,       // Current pixel coordinates
					input [23:0] coin1_dout, coin2_dout, coin3_dout, coin4_dout,
               //output logic  is_coin,            // Whether current pixel belongs to coin or background

					output logic [23:0] coin_dout
              );
				  
	enum logic [2:0] {c1,c2,c3,c4} state, next_state;
	logic [1:0] counter, next_counter;
	logic [24:0] coin_counter, coin_counter_in;
	always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin				
				// FSM control
				state <= c1;
				counter <= 1'b0;
				coin_counter <= 24'd0;
		

        end
        else
        begin
				// FSM
				state <= next_state;
				counter <= next_counter;
				coin_counter <= coin_counter_in;
				
        end
    end
	always_comb begin
		  // FSM control
		  next_state = state;
		  next_counter = counter;
		  coin_counter_in = coin_counter;
		  
		  unique case (state)
		     c1:
			     if (coin_counter[21]) begin
						next_state = c2;
						next_counter = 1'b0;
						coin_counter_in = 24'd0;
				  end
				  else begin
						next_state = c1;
						next_counter = 1'b0;
						coin_counter_in = coin_counter + 1'b1;
				  end
				c2:
			     if (coin_counter[21]) begin
						next_state = c3;
						next_counter = 1'b0;
						coin_counter_in = 24'd0;
				  end
				  else begin
						next_state = c2;
						next_counter = 1'b0;
						coin_counter_in = coin_counter + 1'b1;
				  end
				 c3:
			     if (coin_counter[21]) begin
						next_state = c4;
						next_counter = 1'b0;
						coin_counter_in = 24'd0;
				  end
				  else begin
						next_state = c3;
						next_counter = 1'b0;
						coin_counter_in = coin_counter + 1'b1;
				  end
				  c4:
			     if (coin_counter[21]) begin
						next_state = c1;
						next_counter = 1'b0;
						coin_counter_in = 24'd0;
				  end
				  else begin
						next_state = c4;
						next_counter = 1'b0;
						coin_counter_in = coin_counter + 1'b1;
				  end
			  default: ;
		  
		  endcase
		  
		  // assign output for each state
		  case(state)
				c1:
					coin_dout = coin1_dout;
				c2:
					coin_dout = coin2_dout;
				c3:
					coin_dout = coin3_dout;
				c4:
					coin_dout = coin4_dout;
				default:
					coin_dout = coin1_dout;
		  
		  endcase
	 
	 end
endmodule
