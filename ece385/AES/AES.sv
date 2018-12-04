/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);

logic Inv_MC_s1, Inv_MC_s0, msg_mux_s1, msg_mux_s0;


// first, generate the keySchedule
logic [1407:0] KeySchedule;
KeyExpansion keyexpansion(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule);

// create a message register
logic [127:0] message;
// result of inverse_addroundkey, shiftrows, subbyte and mixcolumn
logic [127:0] Inv_Add, Inv_SR, Inv_SB, Inv_MC;

// create four functions with message

// InvAddRoundKey
logic [3:0] counter_cycle;
InvAddRoundKey invaddroundkey(.clk(CLK), .message, .KeySchedule, .counter_cycle, .Inv_Add);

/*
// InvSubByte
for(integer i = 0; i < 16; i = i + 1)
begin
	InvSubByte invsubbyte(.clk(CLK), .in(message[7+8*i : 8*i]), .out(Inv_SB[7+8*i : 8*i]));
end
*/
InvSubByte128 invsubbyte128(.clk(CLK), .in128(message), .out128(Inv_SB));

// InvShiftRows
InvShiftRows invshiftrows(.clk(CLK), .in(message), .out(Inv_SR));

logic [31:0] in_Inv_MC, out_Inv_MC;
// InvMixColumn
mux4 #(.width(32)) InvMixColumnMux(.d0(message[31:0]),
											  .d1(message[63:32]),
											  .d2(message[95:64]),
											  .d3(message[127:96]),
											  .s1(Inv_MC_s1), .s0(Inv_MC_s0), .y(in_Inv_MC));
InvMixColumn invmixcolumn(.in(in_Inv_MC), .out(out_Inv_MC));
always_comb begin
	if (Inv_MC_s1 && Inv_MC_s0)
		Inv_MC[127:96] = out_Inv_MC;
	else if (Inv_MC_s1 && ~Inv_MC_s0)
		Inv_MC[95:64] = out_Inv_MC;
	else if (~Inv_MC_s1 && Inv_MC_s0)
		Inv_MC[63:32] = out_Inv_MC;
	else
		Inv_MC[31:0] = out_Inv_MC;
end

logic [127:0] msg_mux_out;

mux4 msg_mux(.d0(Inv_Add), .d1(Inv_SR), .d2(Inv_MC), .d3(Inv_SB), .s1(msg_mux_s1), .s0(msg_mux_s0), .y(msg_mux_out));

always_ff @ (posedge CLK) begin
	if (RESET)
		message <= AES_MSG_ENC;
	else
		message <= msg_mux_out;
end

control FSM(.CLK,
				.RESET,
				.AES_START,
				.AES_DONE,
				.Inv_MC_s1,
				.Inv_MC_s0,
				.msg_mux_s1,
				.msg_mux_s0,
				.counter_cycle);

// assign the final result
always_comb begin
	if (AES_DONE)
		AES_MSG_DEC = message;
	else
		AES_MSG_DEC = 128'b0;
end


endmodule
