//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
				 output logic [17:0]	LEDR,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,      //SDRAM Clock
				 output logic 			SRAM_CE_N, SRAM_UB_N, SRAM_LB_N, SRAM_OE_N, SRAM_WE_N,
             output logic [19:0] SRAM_ADDR,
             inout wire [15:0] 	SRAM_DQ,
				 
				 // audio part
				 input  AUD_BCLK,
				 input  AUD_ADCDAT,
				 output AUD_DACDAT,
				 input  AUD_DACLRCK, 
				 input  AUD_ADCLRCK,
				 output I2C_SDAT,
				 output I2C_SCLK,
				 output AUD_XCK
                    );
    
    logic Reset_h, Clk, reset_game;
    logic [15:0] keycode;
    logic [6:0] image_show;
	 
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
   // Use PLL to generate the 25MHZ VGA_CLK.
   // You will have to generate it on your own in simulation.
   vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
   
	// audio control
	// logic dig, mark, ON_MINE, CHEAT;
	logic Init, Init_Finish, data_over;
	logic [15:0] Ldata, Rdata;
	// logic a ;
	// assign a = ~KEY[3]; 
	audio_controller audio_controller_module( 
														.Clk(CLOCK_50),
														.Reset(reset_game), 
														.data_over(data_over),
														.LDATA(Ldata), 
														.RDATA(Rdata),
														.Init(Init),
														.Init_Finish(Init_Finish)
														);  
	audio_interface audio( 
								.LDATA(Ldata), 
								.RDATA(Rdata),          //IN std_logic_vector(15 downto 0); -- parallel external data inputs
								.clk(CLOCK_50), 
								.Reset(reset_game), 
								.INIT(Init),        //IN std_logic; 
								.INIT_FINISH(Init_Finish),      //OUT std_logic;
								.adc_full(),       //OUT std_logic;
								.data_over(data_over),            //OUT std_logic; -- sample sync pulse
								.AUD_MCLK(AUD_XCK),               //OUT std_logic; -- Codec master clock OUTPUT
								.AUD_BCLK(AUD_BCLK),               //IN std_logic; -- Digital Audio bit clock
								.AUD_ADCDAT(AUD_ADCDAT),      //IN std_logic;
								.AUD_DACDAT(AUD_DACDAT),             //OUT std_logic; -- DAC data line
								.AUD_DACLRCK(AUD_DACLRCK), 
								.AUD_ADCLRCK(AUD_ADCLRCK),           //IN std_logic; -- DAC data left/right select
								.I2C_SDAT(I2C_SDAT),    //OUT std_logic; -- serial interface data line
								.I2C_SCLK(I2C_SCLK),    //OUT std_logic;  -- serial interface clock
								.ADCDATA(   )     //OUT std_logic_vector(31 downto 0)
								);  
	
	
	
	// game controller
	game_controller game_controller_instance(.Clk, .Reset(Reset_h),
														  .enter_on, .is_Mario_die, .is_win, .win_game,
														  .image_show, .reset_game);
   //////////////////////////////////////////SRAM
	
	// SRAM memory
	assign SRAM_CE_N=1'b0;
	assign SRAM_UB_N=1'b0;
	assign SRAM_LB_N=1'b0;
	assign SRAM_OE_N=1'b0;
	assign SRAM_WE_N=1'b1;
	logic is_castle;
	logic [15:0]Byte_Swap;
   assign Byte_Swap = {SRAM_DQ[7:0],SRAM_DQ[15:8]};
	always_comb begin
		if (is_castle) begin
				SRAM_ADDR = 424961+(X-castle_X_Pos+process) + 160*(Y-castle_Y_Pos);
			end
		else begin
			case (image_show)
				// start
				7'b1000000:
					SRAM_ADDR = X + 640*Y;
				// remain_3
				7'b0100000:
					SRAM_ADDR = 307201+X + 640*(Y-13'd200);
				// remain_2
				7'b0010000:
					SRAM_ADDR = 332801+X + 640*(Y-13'd200);
				// remain_1
				7'b0001000:
					SRAM_ADDR = 358401+X + 640*(Y-13'd200);
				// game
				7'b0000100:
					SRAM_ADDR = 0;
				// game_over
				7'b0000010:
					SRAM_ADDR = 384001+X + 640*(Y-13'd200);
				// win
				7'b0000001:
					SRAM_ADDR = 404481+X + 640*(Y-13'd200);
				default:
					SRAM_ADDR = X + Y*640;
					
			endcase
		end
	end

	 // logic for keycode
	 // logic space_on, a_on, s_on, d_on;
	 // keycode_reader keycode_reader_instance(.*);
	 
	 // coordinate for drawing
	 //////////////////////////////////////////////////////////////////////////////////////
	 logic[12:0] coin1_X_Pos, coin1_Y_Pos, coin2_X_Pos, coin2_Y_Pos, coin3_X_Pos, coin3_Y_Pos, coin4_X_Pos, coin4_Y_Pos, coin5_X_Pos, coin5_Y_Pos,
					 coin6_X_Pos, coin6_Y_Pos, coin7_X_Pos, coin7_Y_Pos, coin8_X_Pos, coin8_Y_Pos, coin9_X_Pos, coin9_Y_Pos, coin10_X_Pos, coin10_Y_Pos,
					 coin11_X_Pos, coin11_Y_Pos, coin12_X_Pos, coin12_Y_Pos, coin13_X_Pos, coin13_Y_Pos;

	 //////////////////////////////////////////////////////////////////////////////////////
	 logic[12:0] X, Y;
	 logic		isMario, is_Mario1_die, is_Mario2_die , is_Mario3_die,is_Mario4_die , is_Mario5_die,
					isGoomba1, is_goomba1_die, isGoomba2, is_goomba2_die, isGoomba3, is_goomba3_die, isGoomba4, is_goomba4_die, isGoomba5, is_goomba5_die, 
					is_flag, is_coin1, is_coin2, is_coin3, is_coin4, is_coin5, is_coin6, is_coin7, is_coin8, is_coin9, is_coin10, is_coin11, is_coin12, is_coin13;
	 logic[12:0] is_collision;
	 logic[23:0] ground_dout, stand_dout, run_1_dout, run_2_dout, run_3_dout, run_4_dout, mario_dout, die_dout, win_game_dout,
					 stand_l_dout, run_1_l_dout, run_2_l_dout, run_3_l_dout, run_4_l_dout, jump_dout, jump_l_dout,
					 cloud_dout, background_dout, L_mountain_dout, S_mountain_dout,
					 tube_1_dout, tube_2_dout, tube_3_dout, castle_dout, brick_dout,rec_dout,flag_gan_dout,
					 q_mark1_dout, q_mark2_dout, q_mark3_dout, flag_dout,
					 qmark1_dout, qmark2_dout, qmark3_dout, qmark4_dout, qmark5_dout, qmark6_dout,
					 qmark7_dout, qmark8_dout, qmark9_dout, qmark10_dout, qmark11_dout, qmark12_dout, qmark13_dout,
					 goomba1_1_dout, goomba1_2_dout, goomba1_die_dout, 
					 goomba2_1_dout, goomba2_2_dout, goomba2_die_dout,
					 goomba3_1_dout, goomba3_2_dout, goomba3_die_dout,
					 goomba4_1_dout, goomba4_2_dout, goomba4_die_dout,
					 goomba5_1_dout, goomba5_2_dout, goomba5_die_dout,
					 goomba1_dout, goomba2_dout, goomba3_dout, goomba4_dout, goomba5_dout,
					 coin1_1_dout, coin1_2_dout, coin1_3_dout, coin1_4_dout,
					 coin2_1_dout, coin2_2_dout, coin2_3_dout, coin2_4_dout,
					 coin3_1_dout, coin3_2_dout, coin3_3_dout, coin3_4_dout,
					 coin4_1_dout, coin4_2_dout, coin4_3_dout, coin4_4_dout,
					 coin5_1_dout, coin5_2_dout, coin5_3_dout, coin5_4_dout,
					 coin6_1_dout, coin6_2_dout, coin6_3_dout, coin6_4_dout,
					 coin7_1_dout, coin7_2_dout, coin7_3_dout, coin7_4_dout,
					 coin8_1_dout, coin8_2_dout, coin8_3_dout, coin8_4_dout,
					 coin9_1_dout, coin9_2_dout, coin9_3_dout, coin9_4_dout,
					 coin10_1_dout, coin10_2_dout, coin10_3_dout, coin10_4_dout,
					 coin11_1_dout, coin11_2_dout, coin11_3_dout, coin11_4_dout,
					 coin12_1_dout, coin12_2_dout, coin12_3_dout, coin12_4_dout,
					 coin13_1_dout, coin13_2_dout, coin13_3_dout, coin13_4_dout,
					 coin_1_dout, coin_2_dout, coin_3_dout, coin_4_dout, coin_5_dout,
					 coin_6_dout, coin_7_dout, coin_8_dout, coin_9_dout, coin_10_dout,
					 coin_11_dout, coin_12_dout, coin_13_dout;//, q_mark2_dout, q_mark3_dout;
	 
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.Clk,
														 .Reset(Reset_h),      
														 .VGA_HS,
														 .VGA_VS,
														 .VGA_CLK,
														 .VGA_BLANK_N,
														 .VGA_SYNC_N,
														 .DrawX(X),
														 .DrawY(Y)       
														);
    
	 // read keycode from keyboard
	 logic space_on, a_on, s_on, d_on, enter_on;
	 keycode_reader keycode_reader_instance(.*);
	 //assign LEDR[15:0] = keycode;
	 logic is_in_air, is_win;
//	 assign LEDR[0] = is_in_air;
//	 assign LEDR[2] = is_Mario1_die;
//	 assign LEDR[3] = is_goomba1_die;
	 // assign LEDR[4] = game_over;
	 
	 logic [12:0] Mario_X_Pos, Mario_Y_Pos, process, Cloud_X_Pos, Cloud_Y_Pos, L_mountain_X_Pos, L_mountain_Y_Pos, S_mountain_X_Pos, S_mountain_Y_Pos;
	 logic [12:0] Mario_Y_Motion;
	 logic [12:0] Goomba1_X_Pos, Goomba1_Y_Pos, Goomba2_X_Pos, Goomba2_Y_Pos, Goomba3_X_Pos, Goomba3_Y_Pos, Goomba4_X_Pos, Goomba4_Y_Pos, Goomba5_X_Pos, Goomba5_Y_Pos;
	 logic [12:0] tube_1_X_Pos, tube_1_Y_Pos, tube_2_X_Pos, tube_2_Y_Pos,tube_3_X_Pos, tube_3_Y_Pos, castle_X_Pos, castle_Y_Pos, brick_X_Pos, brick_Y_Pos;
	 logic [12:0] q_mark_X_Pos, q_mark_Y_Pos,flag_gan_X_Pos,flag_gan_Y_Pos, rec_X_Pos, rec_Y_Pos;// q_mark2_X_Pos, q_mark2_Y_Pos, q_mark3_X_Pos, q_mark3_Y_Pos;
    logic [12:0] flag_X_Pos, flag_Y_Pos;
	 // Which signal should be frame_clk?
	 logic is_Mario_die;
	 assign is_Mario_die = (is_Mario1_die||is_Mario2_die||is_Mario3_die||is_Mario4_die||is_Mario5_die||run_out);
    mario mario_instance(.Clk,
	                    //.Reset(Reset_h),
							  .Reset(reset_game),
	                    .frame_clk(VGA_VS),
	                    .DrawX(X), .DrawY(Y),
	                    .is_Mario(isMario),
							  .is_Mario_die(is_Mario_die),
							  .space_on, .a_on, .s_on, .d_on,
							  .Mario_X_Pos,
							  .Mario_Y_Pos,
							  .Mario_Y_Motion,
							  .process,
							  .stand_dout, .run_1_dout, .run_2_dout, .run_3_dout,
							  .stand_l_dout, .run_1_l_dout, .run_2_l_dout, .run_3_l_dout, .jump_dout, .jump_l_dout,.die_dout, .win_game_dout, .is_in_air,
							  .mario_dout
							 );
    
    color_mapper color_instance(.is_Mario(isMario), .is_Goomba1(isGoomba1), .is_Goomba2(isGoomba2),.is_Goomba3(isGoomba3), .is_Goomba4(isGoomba4), .is_Goomba5(isGoomba5), 
										  .is_flag,
										  .image_show,
	                             .DrawX(X), .DrawY(Y),
	                             .VGA_R, .VGA_G, .VGA_B,
										  .ground_dout, .mario_dout, .background_dout, .flag_dout,
										  .goomba1_dout, .goomba2_dout,.goomba3_dout, .goomba4_dout,.goomba5_dout,
										  .SRAM_DQ,
										  .process
										 );
  
	 logic [4:0] rip;
	 Goomba  #(13'd2, 13'd895, 13'd512)
			goomba_instance_1(.Clk,
									.Reset(reset_game && ~win_game),
									.frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_Goomba(isGoomba1), .is_goomba_die(is_goomba1_die),
									.Goomba_X_Pos(Goomba1_X_Pos),
									.Goomba_Y_Pos(Goomba1_Y_Pos),
									.process,
									.goomba_1_dout(goomba1_1_dout), .goomba_2_dout(goomba1_2_dout), .goomba_die_dout(goomba1_die_dout), .background_dout,
									.goomba_dout(goomba1_dout),
									.rip(rip[0]));
									
	 Goomba #(13'd960, 13'd1216, 13'd1000)
			goomba_instance_2(.Clk,
									.Reset(reset_game && ~win_game),
									.frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_Goomba(isGoomba2), .is_goomba_die(is_goomba2_die),
									.Goomba_X_Pos(Goomba2_X_Pos),
									.Goomba_Y_Pos(Goomba2_Y_Pos),
									.process,
									.goomba_1_dout(goomba2_1_dout), .goomba_2_dout(goomba2_2_dout), .goomba_die_dout(goomba2_die_dout), .background_dout,
									.goomba_dout(goomba2_dout),
									.rip(rip[1]));

	  Goomba #(13'd3008, 13'd3392, 13'd3100)
			goomba_instance_3(.Clk,
									.Reset(reset_game && ~win_game),
									.frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_Goomba(isGoomba3), .is_goomba_die(is_goomba3_die),
									.Goomba_X_Pos(Goomba3_X_Pos),
									.Goomba_Y_Pos(Goomba3_Y_Pos),
									.process,
									.goomba_1_dout(goomba3_1_dout), .goomba_2_dout(goomba3_2_dout), .goomba_die_dout(goomba3_die_dout), .background_dout,
									.goomba_dout(goomba3_dout),
									.rip(rip[2]));
									
		Goomba #(13'd4288, 13'd4896, 13'd4400)
			goomba_instance_4(.Clk,
									.Reset(reset_game && ~win_game),
									.frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_Goomba(isGoomba4), .is_goomba_die(is_goomba4_die),
									.Goomba_X_Pos(Goomba4_X_Pos),
									.Goomba_Y_Pos(Goomba4_Y_Pos),
									.process,
									.goomba_1_dout(goomba4_1_dout), .goomba_2_dout(goomba4_2_dout), .goomba_die_dout(goomba4_die_dout), .background_dout,
									.goomba_dout(goomba4_dout),
									.rip(rip[3]));
									
		Goomba #(13'd5280, 13'd5728, 13'd5500)
			goomba_instance_5(.Clk,
									.Reset(reset_game && ~win_game),
									.frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_Goomba(isGoomba5), .is_goomba_die(is_goomba5_die),
									.Goomba_X_Pos(Goomba5_X_Pos),
									.Goomba_Y_Pos(Goomba5_Y_Pos),
									.process,
									.goomba_1_dout(goomba5_1_dout), .goomba_2_dout(goomba5_2_dout), .goomba_die_dout(goomba5_die_dout), .background_dout,
									.goomba_dout(goomba5_dout),
									.rip(rip[4]));
									
		parameter [12:0] Y_1 = 13'd288;
		parameter [12:0] Y_2 = 13'd160;
		parameter [12:0] X_1 = 13'd512;
		parameter [12:0] X_2 = 13'd672;
		parameter [12:0] X_3 = 13'd704;
		parameter [12:0] X_4 = 13'd736;
		parameter [12:0] X_5 = 13'd2496;
		parameter [12:0] X_6 = 13'd3008;
		parameter [12:0] X_7 = 13'd3392;
		parameter [12:0] X_8 = 13'd3488;
		parameter [12:0] X_9 = 13'd3584;
		parameter [12:0] X_10 = 13'd4128;
		parameter [12:0] X_11 = 13'd4160;
		parameter [12:0] X_12 = 13'd5440;
		coin_total #(X_1, Y_1)
			coin_instance_1(.Clk, .Reset(reset_game), .frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_coin(is_coin1), .collision(is_collision[0]),
									.coin_X_Pos(coin1_X_Pos), .coin_Y_Pos(coin1_Y_Pos),
									.process,
									.coin1_dout(coin1_1_dout), .coin2_dout(coin1_2_dout), .coin3_dout(coin1_3_dout), .coin4_dout(coin1_4_dout),
									.coin_dout(coin_1_dout));
									
		coin_total #(X_2, Y_1)
			coin_instance_2(.Clk, .Reset(reset_game), .frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_coin(is_coin2), .collision(is_collision[1]),
									.coin_X_Pos(coin2_X_Pos), .coin_Y_Pos(coin2_Y_Pos),
									.process,
									.coin1_dout(coin2_1_dout), .coin2_dout(coin2_2_dout), .coin3_dout(coin2_3_dout), .coin4_dout(coin2_4_dout),
									.coin_dout(coin_2_dout));
		
		coin_total #(X_3, Y_2)
			coin_instance_3(.Clk, .Reset(reset_game), .frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_coin(is_coin3), .collision(is_collision[2]),
									.coin_X_Pos(coin3_X_Pos), .coin_Y_Pos(coin3_Y_Pos),
									.process,
									.coin1_dout(coin3_1_dout), .coin2_dout(coin3_2_dout), .coin3_dout(coin3_3_dout), .coin4_dout(coin3_4_dout),
									.coin_dout(coin_3_dout));
		
		coin_total #(X_4, Y_1)
			coin_instance_4(.Clk, .Reset(reset_game), .frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_coin(is_coin4), .collision(is_collision[3]),
									.coin_X_Pos(coin4_X_Pos), .coin_Y_Pos(coin4_Y_Pos),
									.process,
									.coin1_dout(coin4_1_dout), .coin2_dout(coin4_2_dout), .coin3_dout(coin4_3_dout), .coin4_dout(coin4_4_dout),
									.coin_dout(coin_4_dout));
									
		coin_total #(X_5, Y_1)
			coin_instance_5(.Clk, .Reset(reset_game), .frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_coin(is_coin5), .collision(is_collision[4]),
									.coin_X_Pos(coin5_X_Pos), .coin_Y_Pos(coin5_Y_Pos),
									.process,
									.coin1_dout(coin5_1_dout), .coin2_dout(coin5_2_dout), .coin3_dout(coin5_3_dout), .coin4_dout(coin5_4_dout),
									.coin_dout(coin_5_dout));
									
		coin_total #(X_6, Y_2)
			coin_instance_6(.Clk, .Reset(reset_game), .frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_coin(is_coin6), .collision(is_collision[5]),
									.coin_X_Pos(coin6_X_Pos), .coin_Y_Pos(coin6_Y_Pos),
									.process,
									.coin1_dout(coin6_1_dout), .coin2_dout(coin6_2_dout), .coin3_dout(coin6_3_dout), .coin4_dout(coin6_4_dout),
									.coin_dout(coin_6_dout));
									
		coin_total #(X_7, Y_1)
			coin_instance_7(.Clk, .Reset(reset_game), .frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_coin(is_coin7), .collision(is_collision[6]),
									.coin_X_Pos(coin7_X_Pos), .coin_Y_Pos(coin7_Y_Pos),
									.process,
									.coin1_dout(coin7_1_dout), .coin2_dout(coin7_2_dout), .coin3_dout(coin7_3_dout), .coin4_dout(coin7_4_dout),
									.coin_dout(coin_7_dout));
			
		coin_total #(X_8, Y_1)
			coin_instance_8(.Clk, .Reset(reset_game), .frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_coin(is_coin8), .collision(is_collision[7]),
									.coin_X_Pos(coin8_X_Pos), .coin_Y_Pos(coin8_Y_Pos),
									.process,
									.coin1_dout(coin8_1_dout), .coin2_dout(coin8_2_dout), .coin3_dout(coin8_3_dout), .coin4_dout(coin8_4_dout),
									.coin_dout(coin_8_dout));
		
		coin_total #(X_8, Y_2)
			coin_instance_9(.Clk, .Reset(reset_game), .frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_coin(is_coin9), .collision(is_collision[8]),
									.coin_X_Pos(coin9_X_Pos), .coin_Y_Pos(coin9_Y_Pos),
									.process,
									.coin1_dout(coin9_1_dout), .coin2_dout(coin9_2_dout), .coin3_dout(coin9_3_dout), .coin4_dout(coin9_4_dout),
									.coin_dout(coin_9_dout));
				
		coin_total #(X_9, Y_1)
			coin_instance_10(.Clk, .Reset(reset_game), .frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_coin(is_coin10), .collision(is_collision[9]),
									.coin_X_Pos(coin10_X_Pos), .coin_Y_Pos(coin10_Y_Pos),
									.process,
									.coin1_dout(coin10_1_dout), .coin2_dout(coin10_2_dout), .coin3_dout(coin10_3_dout), .coin4_dout(coin10_4_dout),
									.coin_dout(coin_10_dout));
							
		coin_total #(X_10, Y_2)
			coin_instance_11(.Clk, .Reset(reset_game), .frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_coin(is_coin11), .collision(is_collision[10]),
									.coin_X_Pos(coin11_X_Pos), .coin_Y_Pos(coin11_Y_Pos),
									.process,
									.coin1_dout(coin11_1_dout), .coin2_dout(coin11_2_dout), .coin3_dout(coin11_3_dout), .coin4_dout(coin11_4_dout),
									.coin_dout(coin_11_dout));
									
		coin_total #(X_11, Y_2)
			coin_instance_12(.Clk, .Reset(reset_game), .frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_coin(is_coin12), .collision(is_collision[11]),
									.coin_X_Pos(coin12_X_Pos), .coin_Y_Pos(coin12_Y_Pos),
									.process,
									.coin1_dout(coin12_1_dout), .coin2_dout(coin12_2_dout), .coin3_dout(coin12_3_dout), .coin4_dout(coin12_4_dout),
									.coin_dout(coin_12_dout));
									
		coin_total #(X_12, Y_1)
			coin_instance_13(.Clk, .Reset(reset_game), .frame_clk(VGA_VS),
									.DrawX(X), .DrawY(Y),
									.is_coin(is_coin13), .collision(is_collision[12]),
									.coin_X_Pos(coin13_X_Pos), .coin_Y_Pos(coin13_Y_Pos),
									.process,
									.coin1_dout(coin13_1_dout), .coin2_dout(coin13_2_dout), .coin3_dout(coin13_3_dout), .coin4_dout(coin13_4_dout),
									.coin_dout(coin_13_dout));
									
	  flag flag_movement_instance(.Clk, .Reset(reset_game), .Mario_X_Pos, .flag_X_Pos, .flag_Y_Pos,
											.DrawX(X), .DrawY(Y), .process, .frame_clk(VGA_VS), .is_flag, .is_win);

	  // we put our background here
	  GROUND ground_instance(.Clk, .read_address((X+process)%32 + 32*(Y%64)), .data_Out(ground_dout));
	  
	  BRICK brick_instance(.Clk, .read_address((X+process)%32 + 32*(Y%32)), .data_Out(brick_dout));
	  
	  CLOUD cloud_instance(.Clk, .read_address((X-Cloud_X_Pos+process)%64 + 64*((Y-Cloud_Y_Pos)%48)), .data_Out(cloud_dout));
	  
	  LARGE_MOUNTAIN large_mountain_instance(.Clk, .read_address((X-L_mountain_X_Pos+process)%160 + 160*((Y-L_mountain_Y_Pos)%72)), .data_Out(L_mountain_dout));
	
	  MOUNTAIN mountain_instance(.Clk, .read_address((X-S_mountain_X_Pos+process)%64 + 64*((Y-S_mountain_Y_Pos)%32)), .data_Out(S_mountain_dout));
	  
	  TUBE_1 tube_1_instance(.Clk, .read_address((X-tube_1_X_Pos+process)%64 + 64*((Y-tube_1_Y_Pos)%64)), .data_Out(tube_1_dout));
	  TUBE_2 tube_2_instance(.Clk, .read_address((X-tube_2_X_Pos+process)%64 + 64*((Y-tube_2_Y_Pos)%96)), .data_Out(tube_2_dout));
	  TUBE_3 tube_3_instance(.Clk, .read_address((X-tube_3_X_Pos+process)%64 + 64*((Y-tube_3_Y_Pos)%128)), .data_Out(tube_3_dout));
	  
	  Q_MARK1 q_mark1_instance(.Clk, .read_address((X-q_mark1_X_Pos+process)%32 + 32*((Y-q_mark1_Y_Pos)%32)), .data_Out(q_mark1_dout));
	  Q_MARK2 q_mark2_instance(.Clk, .read_address((X-q_mark2_X_Pos+process)%32 + 32*((Y-q_mark2_Y_Pos)%32)), .data_Out(q_mark2_dout));
	  Q_MARK3 q_mark3_instance(.Clk, .read_address((X-q_mark3_X_Pos+process)%32 + 32*((Y-q_mark3_Y_Pos)%32)), .data_Out(q_mark3_dout));
	  
	  COIN1	 coin1_1_instance(.Clk, .read_address((X-coin1_X_Pos+process)%32 + 32*((Y-coin1_Y_Pos)%32)), .data_Out(coin1_1_dout));
	  COIN2	 coin1_2_instance(.Clk, .read_address((X-coin1_X_Pos+process)%32 + 32*((Y-coin1_Y_Pos)%32)), .data_Out(coin1_2_dout));
	  COIN3	 coin1_3_instance(.Clk, .read_address((X-coin1_X_Pos+process)%32 + 32*((Y-coin1_Y_Pos)%32)), .data_Out(coin1_3_dout));
	  COIN4	 coin1_4_instance(.Clk, .read_address((X-coin1_X_Pos+process)%32 + 32*((Y-coin1_Y_Pos)%32)), .data_Out(coin1_4_dout));
	  
	  COIN1	 coin2_1_instance(.Clk, .read_address((X-coin2_X_Pos+process)%32 + 32*((Y-coin2_Y_Pos)%32)), .data_Out(coin2_1_dout));
	  COIN2	 coin2_2_instance(.Clk, .read_address((X-coin2_X_Pos+process)%32 + 32*((Y-coin2_Y_Pos)%32)), .data_Out(coin2_2_dout));
	  COIN3	 coin2_3_instance(.Clk, .read_address((X-coin2_X_Pos+process)%32 + 32*((Y-coin2_Y_Pos)%32)), .data_Out(coin2_3_dout));
	  COIN4	 coin2_4_instance(.Clk, .read_address((X-coin2_X_Pos+process)%32 + 32*((Y-coin2_Y_Pos)%32)), .data_Out(coin2_4_dout));
	  
	  COIN1	 coin3_1_instance(.Clk, .read_address((X-coin3_X_Pos+process)%32 + 32*((Y-coin3_Y_Pos)%32)), .data_Out(coin3_1_dout));
	  COIN2	 coin3_2_instance(.Clk, .read_address((X-coin3_X_Pos+process)%32 + 32*((Y-coin3_Y_Pos)%32)), .data_Out(coin3_2_dout));
	  COIN3	 coin3_3_instance(.Clk, .read_address((X-coin3_X_Pos+process)%32 + 32*((Y-coin3_Y_Pos)%32)), .data_Out(coin3_3_dout));
	  COIN4	 coin3_4_instance(.Clk, .read_address((X-coin3_X_Pos+process)%32 + 32*((Y-coin3_Y_Pos)%32)), .data_Out(coin3_4_dout));
	  
	  COIN1	 coin4_1_instance(.Clk, .read_address((X-coin4_X_Pos+process)%32 + 32*((Y-coin4_Y_Pos)%32)), .data_Out(coin4_1_dout));
	  COIN2	 coin4_2_instance(.Clk, .read_address((X-coin4_X_Pos+process)%32 + 32*((Y-coin4_Y_Pos)%32)), .data_Out(coin4_2_dout));
	  COIN3	 coin4_3_instance(.Clk, .read_address((X-coin4_X_Pos+process)%32 + 32*((Y-coin4_Y_Pos)%32)), .data_Out(coin4_3_dout));
	  COIN4	 coin4_4_instance(.Clk, .read_address((X-coin4_X_Pos+process)%32 + 32*((Y-coin4_Y_Pos)%32)), .data_Out(coin4_4_dout));
	  
	  COIN1	 coin5_1_instance(.Clk, .read_address((X-coin5_X_Pos+process)%32 + 32*((Y-coin5_Y_Pos)%32)), .data_Out(coin5_1_dout));
	  COIN2	 coin5_2_instance(.Clk, .read_address((X-coin5_X_Pos+process)%32 + 32*((Y-coin5_Y_Pos)%32)), .data_Out(coin5_2_dout));
	  COIN3	 coin5_3_instance(.Clk, .read_address((X-coin5_X_Pos+process)%32 + 32*((Y-coin5_Y_Pos)%32)), .data_Out(coin5_3_dout));
	  COIN4	 coin5_4_instance(.Clk, .read_address((X-coin5_X_Pos+process)%32 + 32*((Y-coin5_Y_Pos)%32)), .data_Out(coin5_4_dout));
	  
	  COIN1	 coin6_1_instance(.Clk, .read_address((X-coin6_X_Pos+process)%32 + 32*((Y-coin6_Y_Pos)%32)), .data_Out(coin6_1_dout));
	  COIN2	 coin6_2_instance(.Clk, .read_address((X-coin6_X_Pos+process)%32 + 32*((Y-coin6_Y_Pos)%32)), .data_Out(coin6_2_dout));
	  COIN3	 coin6_3_instance(.Clk, .read_address((X-coin6_X_Pos+process)%32 + 32*((Y-coin6_Y_Pos)%32)), .data_Out(coin6_3_dout));
	  COIN4	 coin6_4_instance(.Clk, .read_address((X-coin6_X_Pos+process)%32 + 32*((Y-coin6_Y_Pos)%32)), .data_Out(coin6_4_dout));
	  
	  COIN1	 coin7_1_instance(.Clk, .read_address((X-coin7_X_Pos+process)%32 + 32*((Y-coin7_Y_Pos)%32)), .data_Out(coin7_1_dout));
	  COIN2	 coin7_2_instance(.Clk, .read_address((X-coin7_X_Pos+process)%32 + 32*((Y-coin7_Y_Pos)%32)), .data_Out(coin7_2_dout));
	  COIN3	 coin7_3_instance(.Clk, .read_address((X-coin7_X_Pos+process)%32 + 32*((Y-coin7_Y_Pos)%32)), .data_Out(coin7_3_dout));
	  COIN4	 coin7_4_instance(.Clk, .read_address((X-coin7_X_Pos+process)%32 + 32*((Y-coin7_Y_Pos)%32)), .data_Out(coin7_4_dout));
	  
	  COIN1	 coin8_1_instance(.Clk, .read_address((X-coin8_X_Pos+process)%32 + 32*((Y-coin8_Y_Pos)%32)), .data_Out(coin8_1_dout));
	  COIN2	 coin8_2_instance(.Clk, .read_address((X-coin8_X_Pos+process)%32 + 32*((Y-coin8_Y_Pos)%32)), .data_Out(coin8_2_dout));
	  COIN3	 coin8_3_instance(.Clk, .read_address((X-coin8_X_Pos+process)%32 + 32*((Y-coin8_Y_Pos)%32)), .data_Out(coin8_3_dout));
	  COIN4	 coin8_4_instance(.Clk, .read_address((X-coin8_X_Pos+process)%32 + 32*((Y-coin8_Y_Pos)%32)), .data_Out(coin8_4_dout));
	  
	  COIN1	 coin9_1_instance(.Clk, .read_address((X-coin9_X_Pos+process)%32 + 32*((Y-coin9_Y_Pos)%32)), .data_Out(coin9_1_dout));
	  COIN2	 coin9_2_instance(.Clk, .read_address((X-coin9_X_Pos+process)%32 + 32*((Y-coin9_Y_Pos)%32)), .data_Out(coin9_2_dout));
	  COIN3	 coin9_3_instance(.Clk, .read_address((X-coin9_X_Pos+process)%32 + 32*((Y-coin9_Y_Pos)%32)), .data_Out(coin9_3_dout));
	  COIN4	 coin9_4_instance(.Clk, .read_address((X-coin9_X_Pos+process)%32 + 32*((Y-coin9_Y_Pos)%32)), .data_Out(coin9_4_dout));
	  
	  COIN1	 coin10_1_instance(.Clk, .read_address((X-coin10_X_Pos+process)%32 + 32*((Y-coin10_Y_Pos)%32)), .data_Out(coin10_1_dout));
	  COIN2	 coin10_2_instance(.Clk, .read_address((X-coin10_X_Pos+process)%32 + 32*((Y-coin10_Y_Pos)%32)), .data_Out(coin10_2_dout));
	  COIN3	 coin10_3_instance(.Clk, .read_address((X-coin10_X_Pos+process)%32 + 32*((Y-coin10_Y_Pos)%32)), .data_Out(coin10_3_dout));
	  COIN4	 coin10_4_instance(.Clk, .read_address((X-coin10_X_Pos+process)%32 + 32*((Y-coin10_Y_Pos)%32)), .data_Out(coin10_4_dout));
	  
	  COIN1	 coin11_1_instance(.Clk, .read_address((X-coin11_X_Pos+process)%32 + 32*((Y-coin11_Y_Pos)%32)), .data_Out(coin11_1_dout));
	  COIN2	 coin11_2_instance(.Clk, .read_address((X-coin11_X_Pos+process)%32 + 32*((Y-coin11_Y_Pos)%32)), .data_Out(coin11_2_dout));
	  COIN3	 coin11_3_instance(.Clk, .read_address((X-coin11_X_Pos+process)%32 + 32*((Y-coin11_Y_Pos)%32)), .data_Out(coin11_3_dout));
	  COIN4	 coin11_4_instance(.Clk, .read_address((X-coin11_X_Pos+process)%32 + 32*((Y-coin11_Y_Pos)%32)), .data_Out(coin11_4_dout));
	  
	  COIN1	 coin12_1_instance(.Clk, .read_address((X-coin12_X_Pos+process)%32 + 32*((Y-coin12_Y_Pos)%32)), .data_Out(coin12_1_dout));
	  COIN2	 coin12_2_instance(.Clk, .read_address((X-coin12_X_Pos+process)%32 + 32*((Y-coin12_Y_Pos)%32)), .data_Out(coin12_2_dout));
	  COIN3	 coin12_3_instance(.Clk, .read_address((X-coin12_X_Pos+process)%32 + 32*((Y-coin12_Y_Pos)%32)), .data_Out(coin12_3_dout));
	  COIN4	 coin12_4_instance(.Clk, .read_address((X-coin12_X_Pos+process)%32 + 32*((Y-coin12_Y_Pos)%32)), .data_Out(coin12_4_dout));
	  
	  COIN1	 coin13_1_instance(.Clk, .read_address((X-coin13_X_Pos+process)%32 + 32*((Y-coin13_Y_Pos)%32)), .data_Out(coin13_1_dout));
	  COIN2	 coin13_2_instance(.Clk, .read_address((X-coin13_X_Pos+process)%32 + 32*((Y-coin13_Y_Pos)%32)), .data_Out(coin13_2_dout));
	  COIN3	 coin13_3_instance(.Clk, .read_address((X-coin13_X_Pos+process)%32 + 32*((Y-coin13_Y_Pos)%32)), .data_Out(coin13_3_dout));
	  COIN4	 coin13_4_instance(.Clk, .read_address((X-coin13_X_Pos+process)%32 + 32*((Y-coin13_Y_Pos)%32)), .data_Out(coin13_4_dout));

	  // coin_image coin_image_ins(.Clk, .Reset(reset_game), .coin1_dout, .coin2_dout, .coin3_dout, .coin4_dout, .coin_dout);
	  
	  
	  //CASTLE castle_instance(.Clk, .read_address((X-castle_X_Pos+process)%160 + 160*((Y-castle_Y_Pos)%160)), .data_Out(castle_dout));
	  
	  STAND stand_instance(.Clk, .read_address((X-Mario_X_Pos+process)%32 + 32*((Y-Mario_Y_Pos)%32)), .data_Out(stand_dout));
	  RUN_1 run1_instance(.Clk, .read_address((X-Mario_X_Pos+process)%32 + 32*((Y-Mario_Y_Pos)%32)), .data_Out(run_1_dout));
	  RUN_2 run2_instance(.Clk, .read_address((X-Mario_X_Pos+process)%32 + 32*((Y-Mario_Y_Pos)%32)), .data_Out(run_2_dout));
	  RUN_3 run3_instance(.Clk, .read_address((X-Mario_X_Pos+process)%32 + 32*((Y-Mario_Y_Pos)%32)), .data_Out(run_3_dout));
	  JUMP  jump_instance(.Clk, .read_address((X-Mario_X_Pos+process)%32 + 32*((Y-Mario_Y_Pos)%32)), .data_Out(jump_dout));
	  WIN_GAME win_game_instance(.Clk, .read_address((X-Mario_X_Pos+process)%32 + 32*((Y-Mario_Y_Pos)%32)), .data_Out(win_game_dout));
		
	  STAND stand_l_instance(.Clk, .read_address((13'd31-X+Mario_X_Pos-process)%32 + 32*((Y-Mario_Y_Pos)%32)), .data_Out(stand_l_dout));
	  RUN_1 run1_l_instance(.Clk, .read_address((13'd31-X+Mario_X_Pos-process)%32 + 32*((Y-Mario_Y_Pos)%32)), .data_Out(run_1_l_dout));
	  RUN_2 run2_l_instance(.Clk, .read_address((13'd31-X+Mario_X_Pos-process)%32 + 32*((Y-Mario_Y_Pos)%32)), .data_Out(run_2_l_dout));
	  RUN_3 run3_l_instance(.Clk, .read_address((13'd31-X+Mario_X_Pos-process)%32 + 32*((Y-Mario_Y_Pos)%32)), .data_Out(run_3_l_dout));
	  JUMP  jump_l_instance(.Clk, .read_address((13'd31-X+Mario_X_Pos-process)%32 + 32*((Y-Mario_Y_Pos)%32)), .data_Out(jump_l_dout));
	  
	  
	  
	  DIE		die_instance(.Clk, .read_address((X-Mario_X_Pos+process)%32 + 32*((Y-Mario_Y_Pos)%32)), .data_Out(die_dout));
	  
	  REC rec_instance(.Clk, .read_address((X-rec_X_Pos+process)%32 + 32*((Y-rec_Y_Pos)%32)), .data_Out(rec_dout));
	  FLAG_GAN flag_gan_instance(.Clk,.read_address((X-flag_gan_X_Pos+process)%16 + 16*((Y-flag_gan_Y_Pos)%288)), .data_Out(flag_gan_dout));
	  FLAG flag_instance(.Clk, .read_address((X-flag_X_Pos+process)%32 + 32*((Y-flag_Y_Pos)%32)), .data_Out(flag_dout));
	  
     BACKGROUND background_instance(.DrawX(X), .DrawY(Y), .process,
											.is_coin1, .is_coin2, .is_coin3, .is_coin4, .is_coin5, .is_coin6, .is_coin7, .is_coin8, .is_coin9,
											.is_coin10, .is_coin11, .is_coin12, .is_coin13,
											.coin_1_dout, .coin_2_dout, .coin_3_dout, .coin_4_dout, .coin_5_dout, .coin_6_dout, .coin_7_dout,
											.coin_8_dout, .coin_9_dout, .coin_10_dout, .coin_11_dout, .coin_12_dout, .coin_13_dout,
											.cloud_dout, .L_mountain_dout,.S_mountain_dout,.tube_1_dout, .tube_2_dout, .tube_3_dout, .brick_dout,
											.background_dout, .qmark1_dout, .qmark2_dout, .qmark3_dout, .qmark4_dout, .qmark5_dout, .qmark6_dout,
											.qmark7_dout, .qmark8_dout, .qmark9_dout, .qmark10_dout, .qmark11_dout, .qmark12_dout, .qmark13_dout, 
											.castle_dout(Byte_Swap), .rec_dout, .flag_gan_dout,
											.Cloud_X_Pos, .Cloud_Y_Pos, .L_mountain_X_Pos, .L_mountain_Y_Pos, .S_mountain_X_Pos, .S_mountain_Y_Pos,
											.tube_1_X_Pos, .tube_1_Y_Pos, .tube_2_X_Pos, .tube_2_Y_Pos, .tube_3_X_Pos, .tube_3_Y_Pos, .castle_X_Pos, .castle_Y_Pos,
											.q_mark_X_Pos, .q_mark_Y_Pos, .rec_X_Pos, .rec_Y_Pos, .flag_gan_X_Pos, .flag_gan_Y_Pos,
											.brick_X_Pos, .brick_Y_Pos,
											.coin1_Y_Pos, .coin2_Y_Pos, .coin3_Y_Pos, .coin4_Y_Pos, .coin5_Y_Pos, .coin6_Y_Pos, .coin7_Y_Pos,
											.coin8_Y_Pos, .coin9_Y_Pos, .coin10_Y_Pos, .coin11_Y_Pos, .coin12_Y_Pos, .coin13_Y_Pos,.is_castle);
	  
	  check_brick_collision(.*);
	  logic [12:0] done;
	  qmark qmark1_ins (.Clk, .Reset(reset_game && ~win_game), .collision(is_collision[0 ]), .q_mark1_dout, .q_mark2_dout, .q_mark3_dout, .qmark_dout(qmark1_dout ), .done(done[0 ]));
	  qmark qmark2_ins (.Clk, .Reset(reset_game && ~win_game), .collision(is_collision[1 ]), .q_mark1_dout, .q_mark2_dout, .q_mark3_dout, .qmark_dout(qmark2_dout ), .done(done[1 ]));
	  qmark qmark3_ins (.Clk, .Reset(reset_game && ~win_game), .collision(is_collision[2 ]), .q_mark1_dout, .q_mark2_dout, .q_mark3_dout, .qmark_dout(qmark3_dout ), .done(done[2 ]));
	  qmark qmark4_ins (.Clk, .Reset(reset_game && ~win_game), .collision(is_collision[3 ]), .q_mark1_dout, .q_mark2_dout, .q_mark3_dout, .qmark_dout(qmark4_dout ), .done(done[3 ]));
	  qmark qmark5_ins (.Clk, .Reset(reset_game && ~win_game), .collision(is_collision[4 ]), .q_mark1_dout, .q_mark2_dout, .q_mark3_dout, .qmark_dout(qmark5_dout ), .done(done[4 ]));
	  qmark qmark6_ins (.Clk, .Reset(reset_game && ~win_game), .collision(is_collision[5 ]), .q_mark1_dout, .q_mark2_dout, .q_mark3_dout, .qmark_dout(qmark6_dout ), .done(done[5 ]));
	  qmark qmark7_ins (.Clk, .Reset(reset_game && ~win_game), .collision(is_collision[6 ]), .q_mark1_dout, .q_mark2_dout, .q_mark3_dout, .qmark_dout(qmark7_dout ), .done(done[6 ]));
	  qmark qmark8_ins (.Clk, .Reset(reset_game && ~win_game), .collision(is_collision[7 ]), .q_mark1_dout, .q_mark2_dout, .q_mark3_dout, .qmark_dout(qmark8_dout ), .done(done[7 ]));
	  qmark qmark9_ins (.Clk, .Reset(reset_game && ~win_game), .collision(is_collision[8 ]), .q_mark1_dout, .q_mark2_dout, .q_mark3_dout, .qmark_dout(qmark9_dout ), .done(done[8 ]));
	  qmark qmark10_ins(.Clk, .Reset(reset_game && ~win_game), .collision(is_collision[9 ]), .q_mark1_dout, .q_mark2_dout, .q_mark3_dout, .qmark_dout(qmark10_dout), .done(done[9 ]));
	  qmark qmark11_ins(.Clk, .Reset(reset_game && ~win_game), .collision(is_collision[10]), .q_mark1_dout, .q_mark2_dout, .q_mark3_dout, .qmark_dout(qmark11_dout), .done(done[10]));
	  qmark qmark12_ins(.Clk, .Reset(reset_game && ~win_game), .collision(is_collision[11]), .q_mark1_dout, .q_mark2_dout, .q_mark3_dout, .qmark_dout(qmark12_dout), .done(done[11]));
	  qmark qmark13_ins(.Clk, .Reset(reset_game && ~win_game), .collision(is_collision[12]), .q_mark1_dout, .q_mark2_dout, .q_mark3_dout, .qmark_dout(qmark13_dout), .done(done[12]));
	 
	  GOOMBA_1 goomba1_1_instance(.Clk, .read_address((X-Goomba1_X_Pos+process)%32 + 32*((Y-Goomba2_Y_Pos)%32)), .data_Out(goomba1_1_dout));
	  GOOMBA_2 goomba1_2_instance(.Clk, .read_address((X-Goomba1_X_Pos+process)%32 + 32*((Y-Goomba2_Y_Pos)%32)), .data_Out(goomba1_2_dout));
	  GOOMBA_DIE goomba1_die_instance(.Clk, .read_address((X-Goomba1_X_Pos+process)%32 + 32*((Y-Goomba2_Y_Pos)%32)), .data_Out(goomba1_die_dout));
	 
	  GOOMBA_1 goomba2_1_instance(.Clk, .read_address((X-Goomba2_X_Pos+process)%32 + 32*((Y-Goomba2_Y_Pos)%32)), .data_Out(goomba2_1_dout));
	  GOOMBA_2 goomba2_2_instance(.Clk, .read_address((X-Goomba2_X_Pos+process)%32 + 32*((Y-Goomba2_Y_Pos)%32)), .data_Out(goomba2_2_dout));
	  GOOMBA_DIE goomba2_die_instance(.Clk, .read_address((X-Goomba2_X_Pos+process)%32 + 32*((Y-Goomba2_Y_Pos)%32)), .data_Out(goomba2_die_dout));
	  
	  GOOMBA_1 goomba3_1_instance(.Clk, .read_address((X-Goomba3_X_Pos+process)%32 + 32*((Y-Goomba3_Y_Pos)%32)), .data_Out(goomba3_1_dout));
	  GOOMBA_2 goomba3_2_instance(.Clk, .read_address((X-Goomba3_X_Pos+process)%32 + 32*((Y-Goomba3_Y_Pos)%32)), .data_Out(goomba3_2_dout));
	  GOOMBA_DIE goomba3_die_instance(.Clk, .read_address((X-Goomba3_X_Pos+process)%32 + 32*((Y-Goomba3_Y_Pos)%32)), .data_Out(goomba3_die_dout));
	  
	  GOOMBA_1 goomba4_1_instance(.Clk, .read_address((X-Goomba4_X_Pos+process)%32 + 32*((Y-Goomba4_Y_Pos)%32)), .data_Out(goomba4_1_dout));
	  GOOMBA_2 goomba4_2_instance(.Clk, .read_address((X-Goomba4_X_Pos+process)%32 + 32*((Y-Goomba4_Y_Pos)%32)), .data_Out(goomba4_2_dout));
	  GOOMBA_DIE goomba4_die_instance(.Clk, .read_address((X-Goomba4_X_Pos+process)%32 + 32*((Y-Goomba4_Y_Pos)%32)), .data_Out(goomba4_die_dout));
	  
	  GOOMBA_1 goomba5_1_instance(.Clk, .read_address((X-Goomba5_X_Pos+process)%32 + 32*((Y-Goomba5_Y_Pos)%32)), .data_Out(goomba5_1_dout));
	  GOOMBA_2 goomba5_2_instance(.Clk, .read_address((X-Goomba5_X_Pos+process)%32 + 32*((Y-Goomba5_Y_Pos)%32)), .data_Out(goomba5_2_dout));
	  GOOMBA_DIE goomba5_die_instance(.Clk, .read_address((X-Goomba5_X_Pos+process)%32 + 32*((Y-Goomba5_Y_Pos)%32)), .data_Out(goomba5_die_dout));
	 
	  who_die who_die1(.Clk, .Reset(reset_game),
							.Mario_X_Pos, .Mario_Y_Pos, .Goomba_X_Pos(Goomba1_X_Pos), .Goomba_Y_Pos(Goomba1_Y_Pos),
							.Mario_Y_Motion,
						   .is_Mario_die(is_Mario1_die), .is_goomba_die(is_goomba1_die));
	  who_die who_die2(.Clk, .Reset(reset_game),
							.Mario_X_Pos, .Mario_Y_Pos, .Goomba_X_Pos(Goomba2_X_Pos), .Goomba_Y_Pos(Goomba2_Y_Pos),
							.Mario_Y_Motion,
						   .is_Mario_die(is_Mario2_die), .is_goomba_die(is_goomba2_die));
	  who_die who_die3(.Clk, .Reset(reset_game),
							.Mario_X_Pos, .Mario_Y_Pos, .Goomba_X_Pos(Goomba3_X_Pos), .Goomba_Y_Pos(Goomba3_Y_Pos),
							.Mario_Y_Motion,
						   .is_Mario_die(is_Mario3_die), .is_goomba_die(is_goomba3_die));
	  who_die who_die4(.Clk, .Reset(reset_game),
							.Mario_X_Pos, .Mario_Y_Pos, .Goomba_X_Pos(Goomba4_X_Pos), .Goomba_Y_Pos(Goomba4_Y_Pos),
							.Mario_Y_Motion,
						   .is_Mario_die(is_Mario4_die), .is_goomba_die(is_goomba4_die));
	  who_die who_die5(.Clk, .Reset(reset_game),
							.Mario_X_Pos, .Mario_Y_Pos, .Goomba_X_Pos(Goomba5_X_Pos), .Goomba_Y_Pos(Goomba5_Y_Pos),
							.Mario_Y_Motion,
						   .is_Mario_die(is_Mario5_die), .is_goomba_die(is_goomba5_die));

    // Display time on hex display
	 logic [15:0] time_display, score_display;
	 logic run_out, win_game;
	 time_display time_display_instance(.Clk, .Reset(reset_game), .time_display, .run_out);
    HexDriver hex_inst_0 (time_display[3:0], HEX0);
    HexDriver hex_inst_1 (time_display[7:4], HEX1);
	 HexDriver hex_inst_2 (time_display[11:8], HEX2);
	 HexDriver hex_inst_3 (time_display[15:12], HEX3);
	 score_counter score_counter_instance(.Clk, .Reset(reset_game && ~win_game), .score_display, .done, .rip, .win_game);
	 HexDriver hex_inst_4 (score_display[3:0], HEX4);
    HexDriver hex_inst_5 (score_display[7:4], HEX5);
	 HexDriver hex_inst_6 (score_display[11:8], HEX6);
    HexDriver hex_inst_7 (score_display[15:12], HEX7);
    // HexDriver hex_inst_2 (keycode[11:8], HEX2);
    // HexDriver hex_inst_3 (keycode[15:12], HEX3);
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
