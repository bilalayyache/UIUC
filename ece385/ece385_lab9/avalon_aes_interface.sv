/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/
/*
module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

	logic [31:0] register_file [16];
	logic aes_done;
	always_ff @ (posedge CLK) begin
		register_file[15][0] <= aes_done;
		if (RESET) begin
			for (integer i = 0; i < 16; i++)
			begin
				register_file[i] <= 32'b0;
			end
		end
		else if (AVL_WRITE && AVL_CS) begin
			case (AVL_BYTE_EN)
				4'b0001:
					register_file[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];
				4'b0010:
					register_file[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];
				4'b0100:
					register_file[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
				4'b1000:
					register_file[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
				4'b0011:
					register_file[AVL_ADDR][15:0] <= AVL_WRITEDATA[15:0];
				4'b1100:
					register_file[AVL_ADDR][31:16] <= AVL_WRITEDATA[31:16];
				4'b1111:
					register_file[AVL_ADDR][31:0] <= AVL_WRITEDATA[31:0];
				default: ;
			endcase
		end
	end

	logic [127:0] KEY, ENC, DEC;
	always_comb begin
		KEY = {register_file[0], register_file[1], register_file[2], register_file[3]};
		ENC = {register_file[4], register_file[5], register_file[6], register_file[7]};
	end
	
	AES my_aes(.CLK,
			  .RESET(RESET||~register_file[14][0]),
			  .AES_START(register_file[14][0]),
			  .AES_DONE(aes_done),
			  .AES_KEY(KEY),
			  .AES_MSG_ENC(ENC),
	        .AES_MSG_DEC(DEC));

	always_comb begin
		register_file[8] = DEC[127:96];
		register_file[9] = DEC[95:64];
		register_file[10] = DEC[63:32];
		register_file[11] = DEC[31:0];
	end
	
	assign AVL_READDATA = (AVL_CS && AVL_READ) ? register_file[AVL_ADDR] : 32'b0;
	// assign register_file[15] = aes_done ? 32'b1 : 32'b0;
	assign EXPORT_DATA = {register_file[4][31:16], register_file[7][15:0]};
endmodule
*/


/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data

	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

	logic [31:0] register_file [16];
	logic aes_done;
	logic [127:0] KEY;
	logic [127:0] ENC;
	logic [127:0] DEC;
	
	always_ff @ (posedge CLK) begin
		if (RESET) begin
			for (integer i = 0; i < 16; i++)
			begin
				register_file[i] <= 32'b0;
			end
		end
		else if (AVL_WRITE && AVL_CS) begin
			case (AVL_BYTE_EN)
				4'b0001:
					register_file[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];
				4'b0010:
					register_file[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];
				4'b0100:
					register_file[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
				4'b1000:
					register_file[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
				4'b0011:
					register_file[AVL_ADDR][15:0] <= AVL_WRITEDATA[15:0];
				4'b1100:
					register_file[AVL_ADDR][31:16] <= AVL_WRITEDATA[31:16];
				4'b1111:
					register_file[AVL_ADDR][31:0] <= AVL_WRITEDATA[31:0];
				default: ;
			endcase
		end
		if (aes_done) begin
			register_file[11] = DEC[31:0];
			register_file[10] = DEC[63:32];
			register_file[9] = DEC[95:64];
			register_file[8] = DEC[127:96];
			register_file[15][0] = aes_done;
		end
	end
	assign KEY = {register_file[0], register_file[1], register_file[2], register_file[3]};
	assign ENC = {register_file[4], register_file[5], register_file[6], register_file[7]};

	AES my_aes(.CLK,
			  .RESET,
			  .AES_START(register_file[14][0]),
			  .AES_DONE(aes_done),
			  .AES_KEY(KEY),
			  .AES_MSG_ENC(ENC),
	        .AES_MSG_DEC(DEC));
	
	assign AVL_READDATA = (AVL_CS && AVL_READ) ? register_file[AVL_ADDR] : 32'b0;
	// assign register_file[15] = aes_done ? 32'b1 : 32'b0;
	// assign EXPORT_DATA = {register_file[8][31:16], register_file[9][15:0]};
	assign EXPORT_DATA = DEC[31:0];
endmodule

