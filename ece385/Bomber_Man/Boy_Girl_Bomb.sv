module Boy_Girl_Bomb( input      Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signa
									  MOUSE,RESTART,
									  
					input [15:0]   keycode,
					output logic [7:0] Dummy1, Dummy2,Dummy3,Dummy4,
					input  [0:15*20-1][4:0]  memory_map_in,
              	output  logic [0:15*20-1][4:0] memory_map,
					output logic 	START,GAMESTART,GAMEEND,GGG,BGG
					,Char_Pos_G,Char_Pos_B		
				  );
				  
enum logic [3:0] {Start0, Bfront_1, Bfront_2, Bfront_wait,Bback_1, Bback_2, Bback_wait,Bleft_1, Bleft_2, Bleft_wait,Bright_1, Bright_2, Bright_wait}State0, NextState0;
enum logic [3:0] {Start1, Gfront_1, Gfront_2, Gfront_wait,Gback_1, Gback_2, Gback_wait,Gleft_1, Gleft_2, Gleft_wait,Gright_1, Gright_2, Gright_wait}State1, NextState1;
enum logic[4:0] {Start2,  BB_Placed,  BB_Count,BB_Clear,BB_Move,BB_Q,Explode,BGG_State}State2, NextState2;
enum logic[4:0] {Start3, GB_Placed,   GB_Count,GB_Clear,GB_Move,BB_Q_G,Explode_G,GGG_State}State3, NextState3;

enum logic[2:0] {GameStart, Start, GameEnd} GameState, NextGameState;		
		
		logic [8:0] G_Bomb_Pos, G_Bomb_Pos_in,Boy_Pos, Boy_Motion, Boy_Pos_in, Boy_Motion_in, Bomb_Pos, Bomb_Pos_in;
		logic [8:0] Girl_Pos, Girl_Motion, Girl_Pos_in, Girl_Motion_in;
		
		logic [27:0] Boy_Bomb_Count0,Boy_Bomb_Count1,Boy_Bomb_Count0_in,Boy_Bomb_Count1_in;
		logic [27:0] Girl_Bomb_Count0,Girl_Bomb_Count1,Girl_Bomb_Count0_in,Girl_Bomb_Count1_in;
		
		logic Girl_Die,Girl_Die_in,GGG_in,G_Move, G_Move_in,Move, Move_in,Boy_Die,Boy_Die_in,BGG_in;
		logic [1:0] Boy_Life,Boy_Life_in;
		logic [1:0] Girl_Life,Girl_Life_in;
		
		logic [3:0] w,s,a,d,u,dn,l,r,bb,gb;		
		assign w = (keycode[15:8] == 8'h1A ||keycode[7:0] == 8'h1A);
		assign s = (keycode[15:8] == 8'h16 ||keycode[7:0] == 8'h16);
		assign a = (keycode[15:8] == 8'h04 ||keycode[7:0] == 8'h04);
		assign d = (keycode[15:8] == 8'h07 ||keycode[7:0] == 8'h07);
		assign u = (keycode[15:8] == 8'h52 ||keycode[7:0] == 8'h52);
		assign dn = (keycode[15:8] == 8'h51 ||keycode[7:0] == 8'h51);
		assign l = (keycode[15:8] == 8'h50 ||keycode[7:0] == 8'h50);
		assign r = (keycode[15:8] == 8'h4F ||keycode[7:0] == 8'h4F);

		assign bb = (keycode[15:8] == 8'h2C ||keycode[7:0] == 8'h2C);
		assign gb = (keycode[15:8] == 8'h28 ||keycode[7:0] == 8'h28);
		
              
		
		parameter [8:0]twenty = 20;
		parameter [8:0]one = 1;
		
		always_comb
		begin
		if((Boy_Pos%40)<20)
		Char_Pos_B = 1;
		else
		Char_Pos_B = 0;
		end
		
		always_comb
		begin
		if((Girl_Pos%40)<20)
		Char_Pos_G = 1;
		else
		Char_Pos_G = 0;
		end
			
assign Dummy1 = GameState;//memory_map[156];
assign Dummy2 = START;//memory_map[158];
assign Dummy3 = GAMESTART;
assign Dummy4 = GAMEEND;

always_ff @ (posedge Clk)
    begin
        if (Reset)
				begin
				Boy_Pos<=21;
				Girl_Pos<=278;
				Bomb_Pos<=0;
				G_Bomb_Pos<=0;
				State0 <= Start0;
				State1 <= Start1;
				State2 <= Start2;
				State3 <= Start3;
				GameState <=Start;
				Boy_Life<=0;
				Girl_Life<=0;

				end   
		  
        else 
		  begin
				GameState <=NextGameState;
				Boy_Pos <= Boy_Pos_in;
				Bomb_Pos<=Bomb_Pos_in;
				G_Bomb_Pos<=G_Bomb_Pos_in;
				Move<=Move_in;
				G_Move<=G_Move_in;
				BGG <=BGG_in;
				GGG <=GGG_in;
				Girl_Pos <= Girl_Pos_in;
				State0 <= NextState0;
				State1 <= NextState1;
				State2 <= NextState2;
				State3 <= NextState3;
				Boy_Life<=Boy_Life_in;
				Girl_Life<=Girl_Life_in;
				Boy_Die<=Boy_Die_in;
				Girl_Die<=Girl_Die_in;
				Boy_Bomb_Count0<=Boy_Bomb_Count0_in;
				Boy_Bomb_Count1<=Boy_Bomb_Count1_in;
				Girl_Bomb_Count0<=Girl_Bomb_Count0_in;
				Girl_Bomb_Count1<=Girl_Bomb_Count1_in;

        end
		  end
		  
always_comb
		 begin
				NextState0 = State0;
				NextState1 = State1;
				NextState2 = State2;
				NextState3 = State3;
				NextGameState = GameState;
				
				
				
				unique case(GameState)
				
				Start:
				begin
				if(MOUSE)
				NextGameState = GameStart;
				else
				NextGameState = Start;
				end
				
				
				GameStart:
				begin
				if(Girl_Life == 3||Boy_Life == 3)
				NextGameState = GameEnd;
				else
				NextGameState = GameStart;
				end
				
				
				GameEnd:
				begin
				if(RESTART)
				NextGameState = Start;
				else
				NextGameState = GameEnd;
				end
				
				endcase
				
				
		  
unique case(State0)
			Start0:
					begin
					if(s)
					begin
					if(memory_map_in[Boy_Pos+20] == 5'h1||memory_map_in[Boy_Pos+20] == 5'h7 || memory_map_in[Boy_Pos+20] == 5'h2 
						|| memory_map_in[Boy_Pos+20] == 5'h3 )
						NextState0 = Start0;
						else
						NextState0 = Bfront_1;
					end
					else if(w)
					begin
					if(memory_map_in[Boy_Pos-20] == 5'h1||memory_map_in[Boy_Pos-20] == 5'h7 || memory_map_in[Boy_Pos-20] == 5'h2 
						|| memory_map_in[Boy_Pos-20] == 5'h3 )
						NextState0 = Start0;
						else
						NextState0 = Bback_1;
					end
					else if(a)
					begin
					if(memory_map_in[Boy_Pos-1] == 5'h1 ||memory_map_in[Boy_Pos-1] == 5'h7|| memory_map_in[Boy_Pos-1] == 5'h2 
						|| memory_map_in[Boy_Pos-1] == 5'h3 )
						NextState0 = Start0;
						else
						NextState0 = Bleft_1;
					end
					else if(d)
					begin
					if(memory_map_in[Boy_Pos+1] == 5'h1 ||memory_map_in[Boy_Pos+1] == 5'h7|| memory_map_in[Boy_Pos+1] == 5'h2 
						|| memory_map_in[Boy_Pos+1] == 5'h3 )
						NextState0 = Start0;
						else
						NextState0 = Bright_1;
					end
					else
						NextState0 = Start0;					
					end
				
				Bfront_1:				
						NextState0 = Bfront_wait;						
				Bfront_wait:
						begin
						if(keycode[15:8] == 8'h16 ||keycode[7:0] == 8'h16)
						NextState0 = Bfront_wait;
						else
						NextState0 = Bfront_2;
						end
				Bfront_2:				
					NextState0 = Start0;
					
				Bback_1:					
						NextState0 = Bback_wait;						
				Bback_wait:
						begin
						if(keycode[15:8] == 8'h1A||keycode[7:0] == 8'h1A)
						NextState0  = Bback_wait;
						else
						NextState0  = Bback_2;
						end
						
				Bback_2:				
					NextState0  = Start0;
					
				Bleft_1:
					NextState0  = Bleft_wait;						
				Bleft_wait:
						begin
						if(keycode[15:8] == 8'h04 ||keycode[7:0] == 8'h04)
						NextState0  = Bleft_wait;
						else
						NextState0 = Bleft_2;
						end
				Bleft_2:				
					NextState0  = Start0;
					
				Bright_1:				
						NextState0 = Bright_wait;					
				Bright_wait:
						begin
						if(keycode[15:8] == 8'h07 ||keycode[7:0] == 8'h07)
						NextState0 = Bright_wait; 	
						else 
						NextState0 = Bright_2;
						end
						
				Bright_2:				
					NextState0 = Start0;	
				endcase	
//		
		
		
unique case(State1)
			Start1:
					begin
					if(l)
					begin
					if(memory_map_in[Girl_Pos-1] == 5'h1 || memory_map_in[Girl_Pos-1] == 5'h2 
						|| memory_map_in[Girl_Pos-1] == 5'h3||memory_map_in[Girl_Pos-1] == 5'h7 )
						NextState1 = Start1;
						else
						NextState1 = Gleft_1;
					end
					else if(dn)
					begin
					if(memory_map_in[Girl_Pos+20] == 5'h1 || memory_map_in[Girl_Pos+20] == 5'h2 
						|| memory_map_in[Girl_Pos+20] == 5'h3 ||memory_map_in[Girl_Pos+20] == 5'h7 )
						NextState1 = Start1;
						else
						NextState1= Gfront_1;
					end
					else if(u)
					begin
					if(memory_map_in[Girl_Pos-20] == 5'h1 || memory_map_in[Girl_Pos-20] == 5'h2 
						|| memory_map_in[Girl_Pos-20] == 5'h3||memory_map_in[Girl_Pos-20] == 5'h7 )
						NextState1 = Start1;
						else
						NextState1 = Gback_1;	
					end
					
					else if(r)
					begin
					if(memory_map_in[Girl_Pos+1] == 5'h1 || memory_map_in[Girl_Pos+1] == 5'h2 
						|| memory_map_in[Girl_Pos+1] == 5'h3 ||memory_map_in[Girl_Pos+1] == 5'h7)
						NextState1 = Start1;
						else
						NextState1 = Gright_1;
					end
					else 
					NextState1 = Start1;
					end
					
				Gfront_1:				
						NextState1 = Gfront_wait;						
				Gfront_wait:
						begin
						if(keycode[15:8] == 8'h51 ||keycode[7:0] == 8'h51)
						NextState1 =Gfront_wait;
						else
						NextState1 = Gfront_2;
						end					
				Gfront_2:				
					NextState1 = Start1;
					
				Gback_1:					
						NextState1 = Gback_wait;						
				Gback_wait:
						begin
						if(keycode[15:8] == 8'h52 ||keycode[7:0] == 8'h52)
						NextState1 =Gback_wait;
						else
						NextState1 = Gback_2;
						end										
				Gback_2:				
					NextState1 = Start1;
					
				Gleft_1:
					NextState1 = Gleft_wait;						
				Gleft_wait:
						begin
						if(keycode[15:8] == 8'h50 ||keycode[7:0] == 8'h50)
						NextState1 =Gleft_wait;
						else
						NextState1 = Gleft_2;
						end						
				Gleft_2:				
					NextState1 = Start1;
					
				Gright_1:				
						NextState1 = Gright_wait;					
				Gright_wait:
						begin
						if(keycode[15:8] == 8'h4F ||keycode[7:0] == 8'h4F)
						NextState1 =Gright_wait;
						else
						NextState1 = Gright_2;
						end				
				Gright_2:				
					NextState1 = Start1;
					
				endcase
		
			memory_map = memory_map_in;
			Boy_Motion_in = 0;
			Girl_Motion_in = 0;

			Boy_Bomb_Count0_in = Boy_Bomb_Count0;
			Boy_Bomb_Count1_in = Boy_Bomb_Count1;
			Bomb_Pos_in = Bomb_Pos;
			Boy_Life_in = Boy_Life;
			Boy_Die_in = Boy_Die;

			Move_in = Move;
			BGG_in = 0;
			
			Girl_Bomb_Count0_in = Girl_Bomb_Count0;
			Girl_Bomb_Count1_in = Girl_Bomb_Count1;
			G_Bomb_Pos_in = G_Bomb_Pos;
			Girl_Life_in = Girl_Life;
			Girl_Die_in = Girl_Die;

			G_Move_in = G_Move;
			GGG_in = 0;

			unique case(GameState)
				
				Start:
				begin
				START = 1;
				GAMESTART=0;
				GAMEEND=0;
				end
				
				
				GameStart:
				begin
				START = 0;
				GAMESTART=1;
				GAMEEND=0;
				
				end
				
				
				GameEnd:
				begin
				START =0;
				GAMESTART=0;
				GAMEEND=1;
				end
				
				endcase
			case(State0)
			//*******************************START****************	
				Start0:
				
               Boy_Motion_in = 0;
						
		//*******************************FRONT****************
				Bfront_1:
					begin
					Boy_Motion_in = 20;	
					memory_map[Boy_Pos] = 5'h0;		//21
					memory_map[Boy_Pos+20] = 5'hC;  //41
					end
				Bfront_wait:
					begin					
					Boy_Motion_in = 0;
					end				
				Bfront_2: //pos=41
					begin					
				   Boy_Motion_in = 0; //always clear first!	
					memory_map[Boy_Pos-20] = 5'h0; 	//21
					memory_map[Boy_Pos] = 5'hD;		//41			
					end
		//*******************************BACK****************
				Bback_1:
					begin
					Boy_Motion_in = ~twenty + 1;	
					memory_map[Boy_Pos] = 5'h0;	  //41
					memory_map[Boy_Pos-20] = 5'hA;  //21
					end
				Bback_wait:
					begin					
					Boy_Motion_in = 0;
					end				
				Bback_2: 
					begin					
				   Boy_Motion_in = 0; //always clear first!	
					memory_map[Boy_Pos+20] = 5'h0;	//41
					memory_map[Boy_Pos] = 5'hB;		//21	
					end
		//*******************************LEFT****************			
				Bleft_1:
					begin
					Boy_Motion_in = ~one +1;	
					memory_map[Boy_Pos] = 5'h0;  //22
					memory_map[Boy_Pos-1] = 5'hE;  //21
					end
				Bleft_wait:
					begin					
					Boy_Motion_in = 0;
					end				
				Bleft_2: //pos=41
					begin					
				   Boy_Motion_in = 0; //always clear first!	
					memory_map[Boy_Pos+1] = 5'h0; //22
					memory_map[Boy_Pos] = 5'hF;	//21		
					end
		//*******************************RIGHT****************			
				Bright_1:
					begin
					Boy_Motion_in = 1;	
					memory_map[Boy_Pos] = 5'h0;    //21
					memory_map[Boy_Pos+1] = 5'h10;  //22
					end
				Bright_wait:
					begin					
					Boy_Motion_in = 0;
					end				
				Bright_2: //pos=41
					begin					
				   Boy_Motion_in = 0; //always clear first!	
					memory_map[Boy_Pos-1] = 5'h0; //21
					memory_map[Boy_Pos] = 5'h11;  //22			
					end
					endcase
					
			case(State1)
			//*******************************START****************	
				Start1:
					
              Girl_Motion_in = 0;
				
				//*******************************FRONT****************
				Gfront_1:
					begin
					Girl_Motion_in = 20;	
					memory_map[Girl_Pos] = 5'h0;		//21
					memory_map[Girl_Pos+20] = 5'h16;  //41
					end
				Gfront_wait:
					begin					
					Girl_Motion_in = 0;
					end				
				Gfront_2: //pos=41
					begin					
				   Girl_Motion_in = 0; //always clear first!	
					memory_map[Girl_Pos-20] = 5'h0; 	//21
					memory_map[Girl_Pos] = 5'h17;		//41			
					end
		//*******************************BACK****************
				Gback_1:
					begin
					Girl_Motion_in = ~twenty + 1;	
					memory_map[Girl_Pos] = 5'h0;	  //41
					memory_map[Girl_Pos-20] = 5'h14;  //21
					end
				Gback_wait:
					begin					
					Girl_Motion_in = 0;
					end				
				Gback_2: 
					begin					
				   Girl_Motion_in = 0; //always clear first!	
					memory_map[Girl_Pos+20] = 5'h0;	//41
					memory_map[Girl_Pos] = 5'h15;		//21	
					end
		//*******************************LEFT****************			
				Gleft_1:
					begin
					Girl_Motion_in = ~one +1;	
					memory_map[Girl_Pos] = 5'h0;  //22
					memory_map[Girl_Pos-1] = 5'h18;  //21
					end
				Gleft_wait:
					begin					
					Girl_Motion_in = 0;
					end				
				Gleft_2: //pos=41
					begin					
				   Girl_Motion_in = 0; //always clear first!	
					memory_map[Girl_Pos+1] = 5'h0; //22
					memory_map[Girl_Pos] = 5'h19;	//21		
					end
		//*******************************RIGHT****************			
				Gright_1:
					begin
					Girl_Motion_in = 1;	
					memory_map[Girl_Pos] = 5'h0;    //21
					memory_map[Girl_Pos+1] = 5'h1A;  //22
					end
				Gright_wait:
					begin					
					Girl_Motion_in = 0;
					end		
					
				Gright_2: //pos=41
					begin					
				   Girl_Motion_in = 0; //always clear first!	
					memory_map[Girl_Pos-1] = 5'h0; //21
					memory_map[Girl_Pos] = 5'h1B;  //22			
					end
			endcase
			
			Girl_Pos_in = Girl_Pos + Girl_Motion_in;
			Boy_Pos_in = Boy_Pos + Boy_Motion_in;
			
						////////////////////////////////////////////////////////////BOMB

			unique case (State2)
				Start2:
					begin
					if(bb) // space
					NextState2 = BB_Placed;
					else if (State3==Explode_G && (Boy_Pos_in == G_Bomb_Pos-20||Boy_Pos_in == G_Bomb_Pos+1||Boy_Pos_in == G_Bomb_Pos-1||Boy_Pos_in == G_Bomb_Pos+20||Boy_Pos_in == G_Bomb_Pos))
					NextState2 = BGG_State;
					else
					NextState2 = Start2;
					end	
					
				BB_Placed:
					NextState2 = BB_Move;
					
				BB_Move:
			
					NextState2 = BB_Q;
					
			
				BB_Q:
					begin
					if(Move)
					NextState2 = BB_Count;
					else
					NextState2 = BB_Move;
					end
					

				BB_Count: 
					begin
					if(Boy_Bomb_Count0==28'd100000000)
					NextState2 = Explode;
					else if (State3==Explode_G && (Boy_Pos_in == G_Bomb_Pos-20||Boy_Pos_in == G_Bomb_Pos+1||Boy_Pos_in == G_Bomb_Pos-1||Boy_Pos_in == G_Bomb_Pos+20||Boy_Pos_in == G_Bomb_Pos))
					NextState2 = BGG_State;
					else
					NextState2 = BB_Count;
					end
				
				Explode:
					begin
					if(Boy_Bomb_Count1==28'd30000000)
					NextState2 = BB_Clear;
					else if (State3==Explode_G && (Boy_Pos_in == G_Bomb_Pos-20||Boy_Pos_in == G_Bomb_Pos+1||Boy_Pos_in == G_Bomb_Pos-1||Boy_Pos_in == G_Bomb_Pos+20||Boy_Pos_in == G_Bomb_Pos))
					NextState2 = BGG_State;
					else
					NextState2 = Explode;
					end
					
//				Explode_Dui:
//					NextState2 = Explode_Dui_Clear;
					
					
	
				BB_Clear:
					begin
					if(Boy_Die==1)
					NextState2 = BGG_State;
					else 
					NextState2 = Start2;
					end
					
//				Explode_Dui_Clear:
//					begin
//					if(Boy_Die==1)
//					NextState2 = BGG_State;
//					else 
//					NextState2 = Start2;
//					end
					
			//		
				BGG_State:
					NextState2 = Start2;
				

			endcase 
//			
			
			unique case (State3)
				Start3:
					begin
					if(gb) // space
					NextState3 = GB_Placed;
					else if(State2==Explode && (Girl_Pos_in == Bomb_Pos-20||Girl_Pos_in == Bomb_Pos+1||Girl_Pos_in == Bomb_Pos-1||Girl_Pos_in == Bomb_Pos+20||Girl_Pos_in == Bomb_Pos))
					NextState3 = GGG_State;
					else
					NextState3 = Start3;
					end	
					
				GB_Placed:
					NextState3 = GB_Move;
					
				GB_Move:
			
					NextState3 = BB_Q_G;
					
			
				BB_Q_G:
					begin
					if(G_Move)
					NextState3 = GB_Count;
					else
					NextState3 = GB_Move;
					end
					

				GB_Count: 
					begin
					if(Girl_Bomb_Count0==28'd100000000)
					NextState3 = Explode_G;
					else if(State2==Explode && (Girl_Pos_in == Bomb_Pos-20||Girl_Pos_in == Bomb_Pos+1||Girl_Pos_in == Bomb_Pos-1||Girl_Pos_in == Bomb_Pos+20||Girl_Pos_in == Bomb_Pos))
					NextState3 = GGG_State;
					else
					NextState3 = GB_Count;
					end
				
				Explode_G:
					begin
					if(Girl_Bomb_Count1==28'd30000000)
					NextState3 = GB_Clear;
					else if(State2==Explode && (Girl_Pos_in == Bomb_Pos-20||Girl_Pos_in == Bomb_Pos+1||Girl_Pos_in == Bomb_Pos-1||Girl_Pos_in == Bomb_Pos+20||Girl_Pos_in == Bomb_Pos))
					NextState3 = GGG_State;
					else
					NextState3 = Explode_G;
					end
	
				GB_Clear:
					begin
					if(Girl_Die==1)
					NextState3 = GGG_State;
					else 
					NextState3 = Start3;
					end
			//		
				GGG_State:
					NextState3 = Start3;
				

			endcase 
			
			case(State2)
			//*******************************START****************	
			
			Start2:
				begin
				Boy_Bomb_Count0_in = 28'd0;
				Boy_Bomb_Count1_in = 28'd0;
				Boy_Die_in=0;
				Move_in=0;
				end
				
			BB_Placed:
				begin
				Bomb_Pos_in = Boy_Pos;
				end
			
			BB_Move:
				begin
				if(Bomb_Pos == Boy_Pos)
				Move_in = 0;
				else
				Move_in = 1;
				end
				
			BB_Q: ;

			
				
			BB_Count: 
				
				begin
				Boy_Bomb_Count0_in+=1;	
				memory_map[Bomb_Pos_in] = 5'h3;
				
				end
				
			Explode:
				begin
				Boy_Bomb_Count0_in=28'd0;
				Boy_Bomb_Count1_in+=1;
				if(Boy_Pos_in == Bomb_Pos-20||Boy_Pos_in == Bomb_Pos+1||Boy_Pos_in == Bomb_Pos-1||Boy_Pos_in == Bomb_Pos+20||Boy_Pos_in == Bomb_Pos)
				Boy_Die_in = 1;
				else 
				Boy_Die_in = 0;
				
				memory_map[Bomb_Pos] = 5'h4;	
				
				if(memory_map_in[Bomb_Pos+1] == 5'h1)
				memory_map[Bomb_Pos+1] = 5'h1;
				else
				memory_map[Bomb_Pos+1] = 5'h5;
				
				if(memory_map_in[Bomb_Pos-1] == 5'h1)
				memory_map[Bomb_Pos-1] = 5'h1;
				else
				memory_map[Bomb_Pos-1] = 5'h5;
				
				if(memory_map_in[Bomb_Pos+20] == 5'h1)
				memory_map[Bomb_Pos+20] = 5'h1;
				else if(memory_map_in[Bomb_Pos+20] == 5'h7)
				memory_map[Bomb_Pos+20] = 5'h7;
				else
				memory_map[Bomb_Pos+20] = 5'h6;
				
				if(memory_map_in[Bomb_Pos-20] == 5'h1)
				memory_map[Bomb_Pos-20] = 5'h1;
				else if(memory_map_in[Bomb_Pos-20] == 5'h7)
				memory_map[Bomb_Pos-20] = 5'h7;
				else
				memory_map[Bomb_Pos-20] = 5'h6;
				end
				
//			Explode_Dui:
//			begin
//				if(Boy_Pos_in == G_Bomb_Pos-20||Boy_Pos_in == G_Bomb_Pos+1||Boy_Pos_in == G_Bomb_Pos-1||Boy_Pos_in == G_Bomb_Pos+20||Boy_Pos_in == G_Bomb_Pos)
//				Boy_Die_in = 1;
//				else 
//				Boy_Die_in = 0;
//			end
			
			BB_Clear:
						
				begin
				Boy_Bomb_Count1_in = 28'd0;
				memory_map[Bomb_Pos] = 5'h0;
				
				if(memory_map_in[Bomb_Pos+1] == 5'h5)
				memory_map[Bomb_Pos+1] = 5'h0;
				if(memory_map_in[Bomb_Pos-1] == 5'h5)
				memory_map[Bomb_Pos-1] = 5'h0;
				if(memory_map_in[Bomb_Pos+20] == 5'h6)
				memory_map[Bomb_Pos+20] = 5'h0;
				if(memory_map_in[Bomb_Pos-20] == 5'h6)
				memory_map[Bomb_Pos-20] = 5'h0;			
				end
			//Explode_Dui_Clear:  ;	
				
			BGG_State:
				begin
				Boy_Life_in+=1;
				if(Boy_Life_in==1)
				memory_map[2] = 5'h1;
				else if(Boy_Life_in==2)
				memory_map[1] = 5'h1;
				else if(Boy_Life_in==3)
				begin
				memory_map[0] = 5'h1;
				BGG_in = 1;
				end
				
				Boy_Motion_in = 0;
				Boy_Pos_in =21;
				memory_map[21]=5'hD;
				end
				
				endcase		
				
				
			case(State3)
			//*******************************START****************	
			
			Start3:
				begin
				Girl_Bomb_Count0_in = 28'd0;
				Girl_Bomb_Count1_in = 28'd0;
				Girl_Die_in=0;
				G_Move_in=0;
				end
				
			GB_Placed:
				begin
				G_Bomb_Pos_in = Girl_Pos;
				end
			
			GB_Move:
				begin
				if(G_Bomb_Pos == Girl_Pos)
				G_Move_in = 0;
				else
				G_Move_in = 1;
				end
				
			BB_Q_G: ;

			
				
			GB_Count: 
				
				begin
				Girl_Bomb_Count0_in+=1;	
				memory_map[G_Bomb_Pos_in] = 5'h3;
				
				end
				
			Explode_G:
				begin
				Girl_Bomb_Count0_in=28'd0;
				Girl_Bomb_Count1_in+=1;
				if(Girl_Pos_in == G_Bomb_Pos-20||Girl_Pos_in == G_Bomb_Pos+1||Girl_Pos_in == G_Bomb_Pos-1||Girl_Pos_in == G_Bomb_Pos+20||Girl_Pos_in == G_Bomb_Pos)
				Girl_Die_in = 1;
				else 
				Girl_Die_in = 0;
				
				memory_map[G_Bomb_Pos] = 5'h4;	
				
				if(memory_map_in[G_Bomb_Pos+1] == 5'h1)
				memory_map[G_Bomb_Pos+1] = 5'h1;
				else
				memory_map[G_Bomb_Pos+1] = 5'h5;
				
				if(memory_map_in[G_Bomb_Pos-1] == 5'h1)
				memory_map[G_Bomb_Pos-1] = 5'h1;
				else
				memory_map[G_Bomb_Pos-1] = 5'h5;
				
				if(memory_map_in[G_Bomb_Pos+20] == 5'h1)
				memory_map[G_Bomb_Pos+20] = 5'h1;
				else if(memory_map_in[G_Bomb_Pos+20] == 5'h7)
				memory_map[G_Bomb_Pos+20] = 5'h7;
				else
				memory_map[G_Bomb_Pos+20] = 5'h6;
				
				if(memory_map_in[G_Bomb_Pos-20] == 5'h1)
				memory_map[G_Bomb_Pos-20] = 5'h1;
				else if(memory_map_in[G_Bomb_Pos-20] == 5'h7)
				memory_map[G_Bomb_Pos-20] = 5'h7;
				else
				memory_map[G_Bomb_Pos-20] = 5'h6;
				end
			
			GB_Clear:
						
				begin
				Girl_Bomb_Count1_in = 28'd0;
				memory_map[G_Bomb_Pos] = 5'h0;
				
				if(memory_map_in[G_Bomb_Pos+1] == 5'h5)
				memory_map[G_Bomb_Pos+1] = 5'h0;
				if(memory_map_in[G_Bomb_Pos-1] == 5'h5)
				memory_map[G_Bomb_Pos-1] = 5'h0;
				if(memory_map_in[G_Bomb_Pos+20] == 5'h6)
				memory_map[G_Bomb_Pos+20] = 5'h0;
				if(memory_map_in[G_Bomb_Pos-20] == 5'h6)
				memory_map[G_Bomb_Pos-20] = 5'h0;			
				end
				
				
			GGG_State:
				begin
				Girl_Life_in+=1;
				if(Girl_Life_in==1)
				memory_map[297] = 5'h1;
				else if(Girl_Life_in==2)
				memory_map[298] = 5'h1;
				else if(Girl_Life_in==3)
				begin
				memory_map[299] = 5'h1;
				GGG_in = 1;
				end
				
				Girl_Motion_in = 0;
				Girl_Pos_in =278;
				memory_map[278]=5'h15;
				end
				
				endcase		
				
			end

endmodule	


				