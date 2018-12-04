//image file

module  BRICK
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] brick[0:1023];

initial
begin
	 $readmemh("sprite_bytes/brick.txt", brick);
end


always_ff @ (posedge Clk) begin

	data_Out<= brick[read_address];
end
endmodule
/////////////////////////////////////////////////
module  CASTLE
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] castle[0:25599];

initial
begin
	 $readmemh("sprite_bytes/castle.txt", castle);
end


always_ff @ (posedge Clk) begin

	data_Out<= castle[read_address];
end
endmodule
/////////////////////////////////////////////////
module  COIN1
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] coin1[0:1023];

initial
begin
	 $readmemh("sprite_bytes/coin1.txt", coin1);
end


always_ff @ (posedge Clk) begin

	data_Out<= coin1[read_address];
end
endmodule
/////////////////////////////////////////////////
module  COIN2
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] coin2[0:1023];

initial
begin
	 $readmemh("sprite_bytes/coin2.txt", coin2);
end


always_ff @ (posedge Clk) begin

	data_Out<= coin2[read_address];
end
endmodule
/////////////////////////////////////////////////
module  COIN3
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] coin3[0:1023];

initial
begin
	 $readmemh("sprite_bytes/coin3.txt", coin3);
end


always_ff @ (posedge Clk) begin

	data_Out<= coin3[read_address];
end
endmodule
/////////////////////////////////////////////////
module  COIN4
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] coin4[0:1023];

initial
begin
	 $readmemh("sprite_bytes/coin4.txt", coin4);
end


always_ff @ (posedge Clk) begin

	data_Out<= coin4[read_address];
end
endmodule
/////////////////////////////////////////////////
module  DIE
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] die[0:1023];

initial
begin
	 $readmemh("sprite_bytes/die.txt", die);
end


always_ff @ (posedge Clk) begin

	data_Out<= die[read_address];
end

endmodule
/////////////////////////////////////////////////

/////////////////////////////////////////////////
module  DOUBLE_MOUNTAIN
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] double_mountain [0:3071];

initial
begin
	 $readmemh("sprite_bytes/double_mountain.txt", double_mountain);
end


always_ff @ (posedge Clk) begin

	data_Out<= double_mountain[read_address];
end

endmodule

///////////////////////////////////////////////////////////////BOY_FRONT_STA
module  FLAG
(
 
		input [18:0]read_address,
 
		input Clk,

		output logic [23:0] data_Out
);

logic [23:0] flag [0:1023];

initial
begin
	 $readmemh("sprite_bytes/flag.txt", flag);
end


always_ff @ (posedge Clk) begin

	data_Out<= flag[read_address];
end

endmodule

/////////////////////////////////////////////////BOY_BACK
module  FLAG_GAN
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] flag_gan [0:4607];

initial
begin
	 $readmemh("sprite_bytes/flag_gan.txt", flag_gan);
end


always_ff @ (posedge Clk) begin

	data_Out<= flag_gan[read_address];
end

endmodule




/////////////////////////////////////////////////module for goomba
module  GOOMBA_1
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] goomba_1 [0:1023];

initial
begin
	 $readmemh("sprite_bytes/goomba_1.txt", goomba_1);
end


always_ff @ (posedge Clk) begin

	data_Out<= goomba_1[read_address];
end

endmodule

module  GOOMBA_2
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] goomba_2 [0:1023];

initial
begin
	 $readmemh("sprite_bytes/goomba_2.txt", goomba_2);
end


always_ff @ (posedge Clk) begin

	data_Out<= goomba_2[read_address];
end

endmodule


module  GOOMBA_DIE
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);


logic [23:0] goomba_die [0:1023];

initial
begin
	 $readmemh("sprite_bytes/goomba_die.txt", goomba_die);
end


always_ff @ (posedge Clk) begin

	data_Out<= goomba_die[read_address];
end

endmodule
/////////////////////////////////////////////////ground
module  GROUND
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] ground [0:2047];

initial
begin
	 $readmemh("sprite_bytes/ground.txt", ground);
end


always_ff @ (posedge Clk) begin

	data_Out<= ground[read_address];
end

endmodule

/////////////////////////////////////////////////JUMP_BIG
module  JUMP_BIG
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] jump_big [0:2047];

initial
begin
	 $readmemh("sprite_bytes/jump_big.txt", jump_big);
end


always_ff @ (posedge Clk) begin

	data_Out<= jump_big[read_address];
end

endmodule

module  JUMP
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] jump [0:1023];

initial
begin
	 $readmemh("sprite_bytes/jump.txt", jump);
end


always_ff @ (posedge Clk) begin

	data_Out<= jump[read_address];
end

endmodule

/////////////////////////////////////////////////LARGE_MOUNTAIN
module  LARGE_MOUNTAIN
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] large_mountain [0:11519];

initial
begin
	 $readmemh("sprite_bytes/large_mountain.txt", large_mountain);
end


always_ff @ (posedge Clk) begin

	data_Out<= large_mountain[read_address];
end

endmodule

/////////////////////////////////////////////////MOUNTAIN
module  MOUNTAIN
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mountain [0:2047];

initial
begin
	 $readmemh("sprite_bytes/mountain.txt", mountain);
end


always_ff @ (posedge Clk) begin

	data_Out<= mountain[read_address];
end

endmodule

/////////////////////////////////////////////////MUSHROOM
module  MUSHROOM
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mushroom [0:1023];

initial
begin
	 $readmemh("sprite_bytes/mushroom.txt", mushroom);
end


always_ff @ (posedge Clk) begin

	data_Out<= mushroom[read_address];
end

endmodule


/////////////////////////////////////////////////MARIO
module  STAND
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] stand [0:1023];

initial
begin
	 $readmemh("sprite_bytes/stand.txt", stand);
end


always_ff @ (posedge Clk) begin

	data_Out<= stand[read_address];
end

endmodule


module  CLOUD
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] cloud [0:3071];

initial
begin
	 $readmemh("sprite_bytes/cloud.txt", cloud);
end


always_ff @ (posedge Clk) begin

	data_Out<= cloud[read_address];
end

endmodule



module  RUN_1
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] run_1 [0:1023];

initial
begin
	 $readmemh("sprite_bytes/run_1.txt", run_1);
end


always_ff @ (posedge Clk) begin

	data_Out<= run_1[read_address];
end

endmodule


module  RUN_2
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] run_2 [0:1023];

initial
begin
	 $readmemh("sprite_bytes/run_2.txt", run_2);
end


always_ff @ (posedge Clk) begin

	data_Out<= run_2[read_address];
end

endmodule

module  RUN_3
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] run_3 [0:1023];

initial
begin
	 $readmemh("sprite_bytes/run_3.txt", run_3);
end


always_ff @ (posedge Clk) begin

	data_Out<= run_3[read_address];
end

endmodule

/////////////////////////////////////////////////TUBE_1
module  TUBE_1
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] tube_1 [0:4095];

initial
begin
	 $readmemh("sprite_bytes/tube_1.txt", tube_1);
end


always_ff @ (posedge Clk) begin

	data_Out<= tube_1[read_address];
end

endmodule
/////////////////////////////////////////////////TUBE_2
module  TUBE_2
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] tube_2 [0:6143];

initial
begin
	 $readmemh("sprite_bytes/tube_2.txt", tube_2);
end


always_ff @ (posedge Clk) begin

	data_Out<= tube_2[read_address];
end

endmodule

/////////////////////////////////////////////////TUBE_3
module  TUBE_3
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] tube_3 [0:8191];

initial
begin
	 $readmemh("sprite_bytes/tube_3.txt", tube_3);
end


always_ff @ (posedge Clk) begin

	data_Out<= tube_3[read_address];
end

endmodule

/////////////////////////////////////////////////q_mark1
module  Q_MARK1
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] q_mark1 [0:1023];

initial
begin
	 $readmemh("sprite_bytes/q_mark1.txt", q_mark1);
end


always_ff @ (posedge Clk) begin

	data_Out<= q_mark1[read_address];
end

endmodule

/////////////////////////////////////////////////q_mark2
module  Q_MARK2
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] q_mark2 [0:1023];

initial
begin
	 $readmemh("sprite_bytes/q_mark2.txt", q_mark2);
end


always_ff @ (posedge Clk) begin

	data_Out<= q_mark2[read_address];
end

endmodule
/////////////////////////////////////////////////q_mark3
module  Q_MARK3
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] q_mark3 [0:1023];

initial
begin
	 $readmemh("sprite_bytes/q_mark3.txt", q_mark3);
end


always_ff @ (posedge Clk) begin

	data_Out<= q_mark3 [read_address];
end

endmodule
/////////////////////////////////////////////////////////////////////
module  REC
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] rec [0:1023];

initial
begin
	 $readmemh("sprite_bytes/rec_brick.txt", rec);
end


always_ff @ (posedge Clk) begin

	data_Out<= rec [read_address];
end

endmodule
/////////////////////////////////////////////////////////////////////

module  WIN_GAME
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] win_game [0:1023];

initial
begin
	 $readmemh("sprite_bytes/win.txt", win_game);
end


always_ff @ (posedge Clk) begin

	data_Out<= win_game [read_address];
end

endmodule

/////////////////////////////////////////////////////////////////////
//module  FLAG_GAN
//(
//
//		input [18:0]  read_address,
//		input  Clk,
//
//		output logic [23:0] data_Out
//);
//
//// mem has width of 3 bits and a total of 400 addresses
//logic [23:0] flag_gan [0:4607];
//
//initial
//begin
//	 $readmemh("sprite_bytes/flag_gan.txt", flag_gan);
//end
//
//
//always_ff @ (posedge Clk) begin
//
//	data_Out<= flag_gan [read_address];
//end

//endmodule
/*
///////////////////////////////////////////////////////////BACKGROUND
module  background0
(
		//input [23:0] data_In,
		//input [18:0] write_address, 
		input [9:0]read_address,
		input  Clk,

		output logic [23:0] data_Out
);

logic [23:0] background [0:1023];

initial
begin
	 $readmemh("sprite_bytes/background.txt", background);
end


always_ff @ (posedge Clk) begin

	data_Out<= background[read_address];
end

endmodule
*/