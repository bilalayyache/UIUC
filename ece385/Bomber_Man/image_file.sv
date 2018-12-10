//image file
/////////////////////////////////////////////////Fire_round
module  heart
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] heart[0:1023];

initial
begin
	 $readmemh("sprite_bytes/heart.txt", heart);
end


always_ff @ (posedge Clk) begin

	data_Out<= heart[read_address];
end
endmodule
/////////////////////////////////////////////////Fire_round
module  fire_round1
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] fire_round1[0:1023];

initial
begin
	 $readmemh("sprite_bytes/fire_round1.txt", fire_round1);
end


always_ff @ (posedge Clk) begin

	data_Out<= fire_round1[read_address];
end
endmodule
/////////////////////////////////////////////////Fire_round
module  fire_round0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] fire_round[0:1023];

initial
begin
	 $readmemh("sprite_bytes/fire_round.txt", fire_round);
end


always_ff @ (posedge Clk) begin

	data_Out<= fire_round[read_address];
end
endmodule
/////////////////////////////////////////////////Fire_center
module  fire_center0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] fire_center[0:1023];

initial
begin
	 $readmemh("sprite_bytes/fire_center.txt", fire_center);
end


always_ff @ (posedge Clk) begin

	data_Out<= fire_center[read_address];
end

endmodule
/////////////////////////////////////////////////BOMB
module  bomb0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] bomb [0:1023];

initial
begin
	 $readmemh("sprite_bytes/bomb.txt", bomb);
end


always_ff @ (posedge Clk) begin

	data_Out<= bomb[read_address];
end

endmodule
/////////////////////////////////////////////////BOY_FRONT
module  boy_front0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] boy_front [0:2047];

initial
begin
	 $readmemh("sprite_bytes/boy_front.txt", boy_front);
end


always_ff @ (posedge Clk) begin

	data_Out<= boy_front[read_address];
end

endmodule

///////////////////////////////////////////////////////////////BOY_FRONT_STA
module  boy_front_sta0
(
 
		input [18:0]read_address,
 
		input Clk,

		output logic [23:0] data_Out
);

logic [23:0] boy_front_sta [0:2047];

initial
begin
	 $readmemh("sprite_bytes/boy_front_sta.txt", boy_front_sta);
end


always_ff @ (posedge Clk) begin

	data_Out<= boy_front_sta[read_address];
end

endmodule

/////////////////////////////////////////////////BOY_BACK
module  boy_back0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] boy_back [0:2047];

initial
begin
	 $readmemh("sprite_bytes/boy_back.txt", boy_back);
end


always_ff @ (posedge Clk) begin

	data_Out<= boy_back[read_address];
end

endmodule

/////////////////////////////////////////////////BOY_BACK_STA
module  boy_back_sta0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] boy_back_sta [0:2047];

initial
begin
	 $readmemh("sprite_bytes/boy_back_sta.txt", boy_back_sta);
end


always_ff @ (posedge Clk) begin

	data_Out<= boy_back_sta[read_address];
end

endmodule

/////////////////////////////////////////////////BOY_LEFT
module  boy_left0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] boy_left [0:2047];

initial
begin
	 $readmemh("sprite_bytes/boy_left.txt", boy_left);
end


always_ff @ (posedge Clk) begin

	data_Out<= boy_left[read_address];
end

endmodule

/////////////////////////////////////////////////BOY_LEFT_STA
module  boy_left_sta0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] boy_left_sta [0:2047];

initial
begin
	 $readmemh("sprite_bytes/boy_left_sta.txt", boy_left_sta);
end


always_ff @ (posedge Clk) begin

	data_Out<= boy_left_sta[read_address];
end

endmodule

/////////////////////////////////////////////////BOY_RIGHT
module  boy_right0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] boy_right [0:2047];

initial
begin
	 $readmemh("sprite_bytes/boy_right.txt", boy_right);
end


always_ff @ (posedge Clk) begin

	data_Out<= boy_right[read_address];
end

endmodule

/////////////////////////////////////////////////BOY_RIGHT_STA
module  boy_right_sta0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] boy_right_sta [0:2047];

initial
begin
	 $readmemh("sprite_bytes/boy_right_sta.txt", boy_right_sta);
end


always_ff @ (posedge Clk) begin

	data_Out<= boy_right_sta[read_address];
end

endmodule

/////////////////////////////////////////////////GIRL_FRONT
module  girl_front0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] girl_front [0:2047];

initial
begin
	 $readmemh("sprite_bytes/girl_front.txt", girl_front);
end


always_ff @ (posedge Clk) begin

	data_Out<= girl_front[read_address];
end

endmodule

///////////////////////////////////////////////////////////////girl_FRONT_STA
module  girl_front_sta0
(
 
		input [18:0]read_address,
 
		input Clk,

		output logic [23:0] data_Out
);

logic [23:0] girl_front_sta [0:2047];

initial
begin
	 $readmemh("sprite_bytes/girl_front_sta.txt", girl_front_sta);
end


always_ff @ (posedge Clk) begin

	data_Out<= girl_front_sta[read_address];
end

endmodule

/////////////////////////////////////////////////girl_BACK
module  girl_back0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] girl_back [0:2047];

initial
begin
	 $readmemh("sprite_bytes/girl_back.txt", girl_back);
end


always_ff @ (posedge Clk) begin

	data_Out<= girl_back[read_address];
end

endmodule

/////////////////////////////////////////////////girl_BACK_STA
module  girl_back_sta0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] girl_back_sta [0:2047];

initial
begin
	 $readmemh("sprite_bytes/girl_back_sta.txt", girl_back_sta);
end


always_ff @ (posedge Clk) begin

	data_Out<= girl_back_sta[read_address];
end

endmodule

/////////////////////////////////////////////////girl_LEFT
module  girl_left0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] girl_left [0:2047];

initial
begin
	 $readmemh("sprite_bytes/girl_left.txt", girl_left);
end


always_ff @ (posedge Clk) begin

	data_Out<= girl_left[read_address];
end

endmodule

/////////////////////////////////////////////////girl_LEFT_STA
module  girl_left_sta0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] girl_left_sta [0:2047];

initial
begin
	 $readmemh("sprite_bytes/girl_left_sta.txt", girl_left_sta);
end


always_ff @ (posedge Clk) begin

	data_Out<= girl_left_sta[read_address];
end

endmodule


/////////////////////////////////////////////////girl_RIGHT
module  girl_right0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] girl_right [0:2047];

initial
begin
	 $readmemh("sprite_bytes/girl_right.txt", girl_right);
end


always_ff @ (posedge Clk) begin

	data_Out<= girl_right[read_address];
end

endmodule

/////////////////////////////////////////////////girl_RIGHT_STA
module  girl_right_sta0
(

		input [18:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] girl_right_sta [0:2047];

initial
begin
	 $readmemh("sprite_bytes/girl_right_sta.txt", girl_right_sta);
end


always_ff @ (posedge Clk) begin

	data_Out<= girl_right_sta[read_address];
end

endmodule

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
///////////////////////////////////////////////////////////BRICK
module  brick0
(
		
		input [18:0]read_address,
		input  Clk,

		output logic [23:0] data_Out
);


logic [23:0] brick [0:1023];

initial
begin
	 $readmemh("sprite_bytes/brick.txt", brick);
end


always_ff @ (posedge Clk) begin
	
	data_Out<= brick[read_address];
end

endmodule

////////////////////////////////////////////////////////////WALL
module  wall0
(

		input [18:0]read_address,
		input  Clk,

		output logic [23:0] data_Out
);


logic [23:0] wall [0:1023];

initial
begin
	 $readmemh("sprite_bytes/wall.txt", wall);
end


always_ff @ (posedge Clk) begin

		data_Out<= wall[read_address];
end

endmodule 