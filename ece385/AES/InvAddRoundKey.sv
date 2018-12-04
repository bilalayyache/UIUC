module InvAddRoundKey (
	input	 logic clk,
	input  logic [127:0] message,
	input  logic [1407:0] KeySchedule,
	input  logic [3:0] counter_cycle,
	output logic [127:0] Inv_Add
);

always_comb begin
	case(counter_cycle)
		4'b0000: Inv_Add = message ^ KeySchedule[127 : 0];
		4'b0001: Inv_Add = message ^ KeySchedule[255 : 128];
		4'b0010: Inv_Add = message ^ KeySchedule[383 : 256];
		4'b0011: Inv_Add = message ^ KeySchedule[511 : 384];
		4'b0100: Inv_Add = message ^ KeySchedule[639 : 512];
		4'b0101: Inv_Add = message ^ KeySchedule[767 : 640];
		4'b0110: Inv_Add = message ^ KeySchedule[895 : 768];
		4'b0111: Inv_Add = message ^ KeySchedule[1023 : 896];
		4'b1000: Inv_Add = message ^ KeySchedule[1151 : 1024];
		4'b1001: Inv_Add = message ^ KeySchedule[1279 : 1152];
		4'b1010: Inv_Add = message ^ KeySchedule[1407 : 1280];
		default: Inv_Add = 128'b0;
	endcase
end


endmodule
