////testbench
//
////testbench
//
//module testbench();
//
//timeunit 10ns;
//timeprecision 1ns;
//
//logic Clk;
//logic Reset;
//
//logic frame_clk;
//logic [9:0]   DrawX, DrawY;      // Current pixel coordinates
//logic [7:0]   keycode;
//logic  [0:15*20-1][4:0]  memory_map_in;
//logic [0:15*20-1][4:0] memory_map;
//
//always begin : CLOCK_GENERATION
//#1 Clk = ~Clk;
//end
//
//initial begin: CLOCK_INITIALIZATION
//    Clk = 0;
//end 
//
//Boy_Girl_Bomb aesmodule(.*);
//
//initial begin: TEST_VECTORS
//Reset =0;
//keycode = 8'h00;
//memory_map_in = {
// 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,   5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,
// 5'h1,	 5'hD,    5'h0,	 5'h2,    5'h0,    5'h0,    5'h2,	 5'h2,	 5'h0,	 5'h2,   5'h0,	 5'h2,	 5'h2,	 5'h0,	 5'h0,	 5'h2,	 5'h2,	 5'h0,	 5'h2,	 5'h1,
// 5'h1,	 5'h0,	 5'h1,	 5'h2,	 5'h1,	 5'h0,	 5'h1,	 5'h2,	 5'h1,	 5'h2,   5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,
// 5'h1,	 5'h2,	 5'h2,	 5'h0,	 5'h0,	 5'h0,	 5'h2,	 5'h2,	 5'h0,	 5'h2,   5'h2,	 5'h2,	 5'h0,	 5'h0,	 5'h2,	 5'h2,	 5'h2,	 5'h0,	 5'h2,	 5'h1,
// 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,   5'h2,	 5'h1,	 5'h0,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h0,	 5'h1,
// 5'h1,	 5'h0,	 5'h2,	 5'h0,	 5'h0,	 5'h2,	 5'h2,	 5'h2,	 5'h0,	 5'h0,   5'h2,	 5'h2,	 5'h0,	 5'h0,	 5'h2,	 5'h2,	 5'h0,	 5'h0,	 5'h2,	 5'h1,
// 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,   5'h0,	 5'h1,	 5'h2,	 5'h1,	 5'h0,	 5'h1,	 5'h0,	 5'h1,	 5'h2,	 5'h1,
// 5'h1,	 5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h2,	 5'h0,	 5'h2,	 5'h0,	 5'h0,   5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h2,	 5'h0,	 5'h0,	 5'h1,
// 5'h1,	 5'h0,	 5'h1,	 5'h0,	 5'h1,	 5'h0,	 5'h1,	 5'h2,	 5'h1,	 5'h2,   5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h0,	 5'h1,
// 5'h1,	 5'h0,	 5'h0,    5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h0,   5'h2,	 5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h2,	 5'h1,
// 5'h1,	 5'h2,	 5'h1,	 5'h0,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,   5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,	 5'h2,	 5'h1,
// 5'h1,	 5'h2,	 5'h2,	 5'h2,	 5'h0,	 5'h2,	 5'h2,	 5'h2,	 5'h0,	 5'h2,   5'h2,	 5'h2,	 5'h0,	 5'h0,	 5'h0,	 5'h2,	 5'h0,	 5'h0,	 5'h2,	 5'h1,
// 5'h1,	 5'h0,	 5'h1,	 5'h0,	 5'h1,	 5'h0,	 5'h1,	 5'h2,	 5'h1,	 5'h2,   5'h0,	 5'h1,	 5'h0,	 5'h1,	 5'h0,	 5'h1,	 5'h0,	 5'h1,	 5'h0,    5'h1,
// 5'h1,	 5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h0,	 5'h2,	 5'h0,	 5'h0,   5'h2,	 5'h0,	 5'h2,	 5'h0,	 5'h2,	 5'h0,	 5'h2,	 5'h0,	 5'h15,   5'h1,
// 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,   5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1,	 5'h1
//};
//
//
//
//#30 Reset = 1;
//#2  Reset = 0;
//	 keycode = 8'h00;
//	 
//#4 keycode = 8'h16;
//
//#20 keycode = 8'h00;
//
//end
//endmodule 