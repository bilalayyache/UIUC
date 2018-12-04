module  qmark ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                            // frame_clk,          // The clock indicating a new frame (~60Hz)
               //input [12:0]   DrawX, DrawY,       // Current pixel coordinates
					input [23:0] q_mark1_dout, q_mark2_dout, q_mark3_dout,
               //output logic  is_qmark,            // Whether current pixel belongs to qmark or background
					input collision,
					output logic [23:0] qmark_dout,
					output logic done
              );
				  
	enum logic [2:0] {q1,q2,q3} state, next_state;
	logic [1:0] counter, next_counter;
	logic [24:0] qmark_counter, qmark_counter_in;
	logic done_in;
	always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin				
				// FSM control
				state <= q1;
				counter <= 1'b0;
				qmark_counter <= 24'd0;
				done <= 1'd0;

        end
        else
        begin
				// FSM
				state <= next_state;
				counter <= next_counter;
				qmark_counter <= qmark_counter_in;
				done <= done_in;
        end
    end
	always_comb begin
		  // FSM control
		  next_state = state;
		  next_counter = counter;
		  qmark_counter_in = qmark_counter;
		  done_in = done;
		  unique case (state)
		     q1:
				  if (collision) begin
						next_state = q3;
						done_in = 1'b1;
				  end
			     else if (qmark_counter[24]) begin
						next_state = q2;
						next_counter = 1'b0;
						qmark_counter_in = 24'd0;
				  end
				  else begin
						next_state = q1;
						next_counter = 1'b0;
						qmark_counter_in = qmark_counter + 1'b1;
				  end
				q2:
				  if (collision) begin
						next_state = q3;
						done_in = 1'b1;
				  end
			     else if (qmark_counter[24]) begin
						next_state = q1;
						next_counter = 1'b0;
						qmark_counter_in = 24'd0;
				  end
				  else begin
						next_state = q2;
						next_counter = 1'b0;
						qmark_counter_in = qmark_counter + 1'b1;
				  end
				 q3:
				  next_state = q3;
//			     if (qmark_counter[24]) begin
//						next_state = q1;
//						next_counter = 1'b0;
//						qmark_counter_in = 24'd0;
//				  end
//				  else begin
//						next_state = q3;
//						next_counter = 1'b0;
//						qmark_counter_in = qmark_counter + 1'b1;
//				  end
			  default: ;
		  
		  endcase
		  
		  // assign output for each state
		  case(state)
				q1:
					qmark_dout = q_mark1_dout;
				q2:
					qmark_dout = q_mark2_dout;
				q3:
					qmark_dout = q_mark3_dout;
				default:
					qmark_dout = q_mark1_dout;
		  
		  endcase
	 
	 end
endmodule
