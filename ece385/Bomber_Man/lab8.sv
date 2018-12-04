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
             output logic [6:0]  HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,              // VGA Interface 
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
                                 DRAM_CLK,    //SDRAM Clock
				output logic SRAM_CE_N, SRAM_UB_N, SRAM_LB_N, SRAM_OE_N, SRAM_WE_N,
                      output logic [19:0] SRAM_ADDR,
                      inout wire [15:0] SRAM_DQ,
							 
				// MOUSE 
				inout	PS2_CLK, PS2_DAT
							 
				);													
//				// flash													
//				inout wire [7:0] FL_DQ,
//				output logic [22:0] FL_ADDR,
//				output FL_WE_N, FL_RST_N, FL_WP_N, FL_CE_N, FL_OE_N,
//				input  FL_RY
				
					
											
				// audio
	//			    inout  AUD_ADCLRCK,
   // input  AUD_ADCDAT,
   // inout  AUD_DACLRCK,
   // output AUD_DACDAT,
   // output AUD_XCK,
   // inout  AUD_BCLK,
   // output AUD_I2C_SCLK,
   // inout  AUD_I2C_SDAT,
   // output AUD_MUTE,
//
   // //input  [3:0] KEY,
   // input  [3:0] SW,
   // output [3:0] LED
						  
	// sockit_top(.*);

    
    logic Reset_h, Clk;
    logic [15:0] keycode;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs;
    
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
                             .sdram_out_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w)
    );
  

    
	  always_ff @ (posedge Clk) begin
        if(Reset_h)
            VGA_CLK <= 1'b0;
        else
            VGA_CLK <= ~VGA_CLK;
    end

	 //////////////////////////////////////////SRAM
	 
	 	assign SRAM_CE_N=1'b0;
		assign SRAM_UB_N=1'b0;
		assign SRAM_LB_N=1'b0;
		assign SRAM_OE_N=1'b0;
		assign SRAM_WE_N=1'b1;
		 
		
		always_comb
			begin		
			if(START)
				SRAM_ADDR = DrawX + 640*DrawY;
			else if(GAMEEND) 
				SRAM_ADDR = 307201+DrawX + 640*DrawY;
			else
				SRAM_ADDR = 0;
			end
                      
	 always_ff @ (posedge Clk) begin
 
			RESTART <= ~(KEY[3]); 
    end
	 
//	 
	 
	 ////////////////////////////////////////////////flash
	 
//	 inout wire [7:0] FL_DQ,
//				output logic [22:0] FL_ADDR,
//				output FL_WE_N, FL_RST_N, FL_WP_N, FL_CE_N, FL_OE_N,
//				input  FL_RY
//				
	 
	 // MOUSE 
	 logic rightButton, middleButton, leftButton;
	 logic [9:0] cursorX, cursorY;
	 
	 Mouse little_mouse( 
								.CLOCK_50(Clk),
								.KEY(KEY),
								.PS2_CLK(PS2_CLK),
								.PS2_DAT(PS2_DAT),
								.leftButton(leftButton),
								.middleButton(middleButton),
								.rightButton(rightButton),
								.cursorX(cursorX),
								.cursorY(cursorY)
							);
	always_comb
	begin
	MOUSE = 1'b0;
	if((leftButton) &&
		(cursorX >= 245 && cursorX <= 383 && cursorY >= 417 && cursorY <= 450))
	 MOUSE = 1'b1;
	end
	
	logic is_ball;
	ball ball_instance(.*, .Reset(Reset_h), .frame_clk(VGA_VS));
	////////////////////////////////////////////////
	 
	 
	 logic [9:0] DrawX, DrawY;
	 logic [23:0] background_dout,brick_dout,wall_dout,boy_front_sta_dout,boy_front_dout,boy_back_sta_dout,boy_back_dout,boy_left_sta_dout,boy_left_dout,boy_right_sta_dout,boy_right_dout
	 ,girl_front_sta_dout,girl_front_dout,heart_dout,fire_round1_dout,girl_back_sta_dout,girl_back_dout,girl_left_sta_dout,girl_left_dout,girl_right_sta_dout,girl_right_dout,bomb_dout,fire_center_dout,fire_round_dout;
	 logic [0:299][4:0] map_in;
	 logic [0:299][4:0] map_out, map_updated ;
	 logic [7:0] Dummy1, Dummy2,Dummy3,Dummy4;
	 logic START,GAMEEND,GAMESTART,MOUSE,RESTART,GGG,BGG;
	 
    VGA_controller vga_controller_instance(.*  ,.Reset(Reset_h)  // 25 MHz VGA clock input
         
	 );
    
      
		
	//color map  
	color_mapper color_instance(   .*,.map_out(map_updated),.SRAM_DQ,.START);
	
	 
	//character FSM 
	Boy_Girl_Bomb instance0(.*,.Reset(Reset_h),.keycode(keycode[15:0]),  
								.memory_map_in(map_out), .memory_map(map_updated));
	
	
	//initial map
	map_array map_array_instance(.Clk, .Reset(Reset_h), .map_in(map_updated), .map_out );
		
    
	//sprites import	 
	 background0 background_instance(.*,.read_address(DrawX%32 + 32*(DrawY%32)), .data_Out(background_dout));	 
	 brick0 brick_instance(.*,.read_address(DrawX%32 + 32*(DrawY%32)), .data_Out(brick_dout));
	 wall0 wall_instance(.*,.read_address(DrawX%32 + 32*(DrawY%32)), .data_Out(wall_dout));
	 
	bomb0 bomb_instance(.*,.read_address(DrawX%32 + 32*(DrawY%32)), .data_Out(bomb_dout));
	fire_center0 fire_center_instance(.*,.read_address(DrawX%32 + 32*(DrawY%32)), .data_Out(fire_center_dout));
	fire_round0 fire_round_instance(.*,.read_address(DrawX%32 + 32*(DrawY%32)), .data_Out(fire_round_dout));
	fire_round1 fire_round1_instance(.*,.read_address(DrawX%32 + 32*(DrawY%32)), .data_Out(fire_round1_dout));
	heart heart0(.*,.read_address(DrawX%32 + 32*(DrawY%32)), .data_Out(heart_dout));
//	
	 
			logic [9:0] DrawY_G,DrawY_B;
			logic Char_Pos_G,Char_Pos_B;
	
			//position calculation
			always_comb
			begin
			
			if(Char_Pos_B)
				DrawY_B = DrawY+32;
			else 
				DrawY_B = DrawY;
			end
//			
			always_comb
			begin
			
			if(Char_Pos_G)
				DrawY_G = DrawY+32;
			else 
				DrawY_G = DrawY;
			end
	
	 //character images
	 boy_front0 boy_front_instance(.*,.read_address(DrawX%32 + 32*(DrawY_B%64)), .data_Out(boy_front_dout));
	 boy_front_sta0 boy_front_sta_instance(.*,.read_address(DrawX%32 + 32*(DrawY_B%64)), .data_Out(boy_front_sta_dout));
	 boy_back0 boy_back_instance(.*,.read_address(DrawX%32 + 32*(DrawY_B%64)), .data_Out(boy_back_dout));
	 boy_back_sta0 boy_back_sta_instance(.*,.read_address(DrawX%32 + 32*(DrawY_B%64)), .data_Out(boy_back_sta_dout));
	 boy_left0 boy_left_instance(.*,.read_address(DrawX%32 + 32*(DrawY_B%64)), .data_Out(boy_left_dout));
	 boy_left_sta0 boy_left_sta_instance(.*,.read_address(DrawX%32 + 32*(DrawY_B%64)), .data_Out(boy_left_sta_dout));
	 boy_right0 boy_right_instance(.*,.read_address(DrawX%32 + 32*(DrawY_B%64)), .data_Out(boy_right_dout));
	 boy_right_sta0 boy_right_sta_instance(.*,.read_address(DrawX%32 + 32*(DrawY_B%64)), .data_Out(boy_right_sta_dout));
	 
	 girl_front0 girl_front_instance(.*,.read_address(DrawX%32 + 32*(DrawY_G%64)), .data_Out(girl_front_dout));
	 girl_front_sta0 girl_front_sta_instance(.*,.read_address(DrawX%32 + 32*(DrawY_G%64)), .data_Out(girl_front_sta_dout));
	 girl_back0 girl_back_instance(.*,.read_address(DrawX%32 + 32*(DrawY_G%64)), .data_Out(girl_back_dout));
	 girl_back_sta0 girl_back_sta_instance(.*,.read_address(DrawX%32 + 32*(DrawY_G%64)), .data_Out(girl_back_sta_dout));
	 girl_left0 girl_left_instance(.*,.read_address(DrawX%32 + 32*(DrawY_G%64)), .data_Out(girl_left_dout));
	 girl_left_sta0 girl_left_sta_instance(.*,.read_address(DrawX%32 + 32*(DrawY_G%64)), .data_Out(girl_left_sta_dout));
	 girl_right0 girl_right_instance(.*,.read_address(DrawX%32 + 32*(DrawY_G%64)), .data_Out(girl_right_dout));
	 girl_right_sta0 girl_right_sta_instance(.*,.read_address(DrawX%32 + 32*(DrawY_G%64)), .data_Out(girl_right_sta_dout));
//	 
	 
	 
	 // Display keycode on hex display
    HexDriver hex_inst_0 (Dummy1[3:0], HEX0);
    HexDriver hex_inst_1 (Dummy1[7:4], HEX1);
	 HexDriver hex_inst_2 (Dummy2[3:0], HEX2);
    HexDriver hex_inst_3 (Dummy2[7:4], HEX3);
    HexDriver hex_inst_4 (Dummy3[3:0], HEX4);
	 HexDriver hex_inst_5 (Dummy3[7:4], HEX5);
	 HexDriver hex_inst_6 (Dummy4[3:0], HEX6);
	 HexDriver hex_inst_7 (Dummy4[7:4], HEX7);

	 
	 
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
