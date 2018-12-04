//-------------------------------------------------------------------------
//      lab6_toplevel.sv                                                 --
//                                                                       --
//      Created 10-19-2017 by Po-Han Huang                               --
//                        Spring 2018 Distribution                       --
//                                                                       --
//      For use with ECE 385 Experment 6                                 --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------
module lab6_toplevel( input logic [15:0] S,
                      input logic Clk, Reset, Run, Continue,
                      output logic [11:0] LED,
                      output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
                      output logic CE, UB, LB, OE, WE,
                      output logic [19:0] ADDR,
                      inout wire [15:0] Data
							 );

logic Reset_ah, Continue_ah, Run_ah;
logic[15:0] S_S;
//logic CE_OUT, UB_OUT, LB_OUT, OE_OUT, WE_OUT;
slc3 my_slc(.*, .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah), .S(S_S));
// Even though test memory is instantiated here, it will be synthesized into 
// a blank module, and will not interfere with the actual SRAM.
// Test memory is to play the role of physical SRAM in simulation.
test_memory my_test_memory(.Reset(~Reset), .I_O(Data), .A(ADDR), .*);


//Input synchronizers required for asynchronous inputs (in this case, from the switches)
//These are array module instantiations
//Note: S stands for SYNCHRONIZED, H stands for active HIGH
//Note: We can invert the levels inside the port assignments
sync button_sync[2:0] (Clk, {~Reset, ~Run, ~Continue}, {Reset_ah, Run_ah, Continue_ah});
sync S_sync[15:0] (Clk, S, S_S);
// sync input_sync[4:0] (Clk, {CE_OUT, UB_OUT, LB_OUT, OE_OUT, WE_OUT}, {CE, UB, LB, OE, WE});
endmodule
