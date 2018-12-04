module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic CLK;
logic RESET;
logic AES_START;
logic AES_DONE;
logic [127:0] AES_KEY;
logic [127:0] AES_MSG_ENC;
logic [127:0] AES_MSG_DEC;
	
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
AES lab9(.*);





//logic CLK,
//
//
//logic RESET,
//
//logic AVL_READ,					// Avalon-MM Read
//logic AVL_WRITE,					// Avalon-MM Write
//logic AVL_CS,						// Avalon-MM Chip Select
//logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
//logic [3:0] AVL_ADDR,			// Avalon-MM Address
//logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
//logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
//	// Exported Conduit
//logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
//
//avalon_aes_interface avl_aes(.*)


// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin: CLOCK_INITIALIZATION
    CLK = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS

////////////////////////////////////////////////////////////////
// modify below
////////////////////////////////////////////////////////////////


RESET = 1'b1;		// Toggle Rest
AES_KEY = 128'h000102030405060708090a0b0c0d0e0f;
AES_MSG_ENC = 128'hdaec3055df058e1c39e814ea76f6747e;

//AVL_BYTE_EN = 4'b1111;
//AVL_WRITE = 1'b1;
//AVL_CS = 1'b1;
//AVL_ADDR = 4'b1110;
//AVL_WRITEDATA = 32'h00000001
#2
RESET = 1'b0;
#20
AES_START = 1'b1;


end
endmodule
