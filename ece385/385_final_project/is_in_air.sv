module IS_IN_AIR(	input logic [12:0] Mario_X_Pos, Mario_Y_Pos,
												 Mario_Y_Motion,
						output logic [12:0]	 level,
						output logic is_in_air);
						
		always_comb begin
			if (Mario_Y_Pos + Mario_Y_Motion >= 13'd384)
				begin
					is_in_air = 1'b0;
					level = 13'd384;
				end
			else if (Mario_X_Pos > 13'd624 && Mario_X_Pos < 13'd784 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd256 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd320)
				begin
					is_in_air = 1'b0;
					level = 13'd256;
				end
			else if (Mario_X_Pos > 13'd496 && Mario_X_Pos < 13'd528 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd256 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd320)
				begin
					is_in_air = 1'b0;
					level = 13'd256;
				end
			else if (Mario_X_Pos > 13'd688 && Mario_X_Pos < 13'd720 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd128 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd192)
				begin
					is_in_air = 1'b0;
					level = 13'd128;
				end
			else if (Mario_X_Pos > 13'd2452 && Mario_X_Pos < 13'd2544 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd256 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd320)
				begin
					is_in_air = 1'b0;
					level = 13'd256;
				end
			// tube small 
			else if (Mario_X_Pos > 13'd869 && Mario_X_Pos < 13'd955 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd320 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd384)
				begin
					is_in_air = 1'b0;
					level = 13'd320;
				end
			else if (Mario_X_Pos > 13'd5189 && Mario_X_Pos < 13'd5275 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd320 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd384)
				begin
					is_in_air = 1'b0;
					level = 13'd320;
				end
			else if (Mario_X_Pos > 13'd5702 && Mario_X_Pos < 13'd5787 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd320 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd384)
				begin
					is_in_air = 1'b0;
					level = 13'd320;
				end
			// medium tube
			else if (Mario_X_Pos > 13'd1189 && Mario_X_Pos < 13'd1275 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd288 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd384)
				begin
					is_in_air = 1'b0;
					level = 13'd288;
				end
			// large tube
			else if (Mario_X_Pos > 13'd1445 && Mario_X_Pos < 13'd1533 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd256 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd384)
				begin
					is_in_air = 1'b0;
					level = 13'd256;
				end
			else if (Mario_X_Pos > 13'd1797 && Mario_X_Pos < 13'd1883 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd256 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd384)
				begin
					is_in_air = 1'b0;
					level = 13'd256;
				end
			// first level
			else if (Mario_X_Pos > 13'd2992 && Mario_X_Pos < 13'd3024 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd256 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd320)
				begin
					is_in_air = 1'b0;
					level = 13'd256;
				end
			else if (Mario_X_Pos > 13'd3184 && Mario_X_Pos < 13'd3216 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd256 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd320)
				begin
					is_in_air = 1'b0;
					level = 13'd256;
				end
			else if (Mario_X_Pos > 13'd3376 && Mario_X_Pos < 13'd3408 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd256 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd320)
				begin
					is_in_air = 1'b0;
					level = 13'd256;
				end
			else if (Mario_X_Pos > 13'd3472 && Mario_X_Pos < 13'd3504 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd256 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd320)
				begin
					is_in_air = 1'b0;
					level = 13'd256;
				end
			else if (Mario_X_Pos > 13'd3568 && Mario_X_Pos < 13'd3600 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd256 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd320)
				begin
					is_in_air = 1'b0;
					level = 13'd256;
				end
			else if (Mario_X_Pos > 13'd3760 && Mario_X_Pos < 13'd3792 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd256 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd320)
				begin
					is_in_air = 1'b0;
					level = 13'd256;
				end
			else if (Mario_X_Pos > 13'd4112 && Mario_X_Pos < 13'd4176 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd256 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd320)
				begin
					is_in_air = 1'b0;
					level = 13'd256;
				end
			else if (Mario_X_Pos > 13'd5360 && Mario_X_Pos < 13'd5488 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd256 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd320)
				begin
					is_in_air = 1'b0;
					level = 13'd256;
				end
			/////////////////////////////////second level////////////////////////////////////////////
			else if (Mario_X_Pos > 13'd2544 && Mario_X_Pos < 13'd2800 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd128 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd192)
				begin
					is_in_air = 1'b0;
					level = 13'd128;
				end
			else if (Mario_X_Pos > 13'd2896 && Mario_X_Pos < 13'd3024 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd128 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd192)
				begin
					is_in_air = 1'b0;
					level = 13'd128;
				end
			else if (Mario_X_Pos > 13'd3472 && Mario_X_Pos < 13'd3504 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd128 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd192)
				begin
					is_in_air = 1'b0;
					level = 13'd128;
				end
			else if (Mario_X_Pos > 13'd3856 && Mario_X_Pos < 13'd3952 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd128 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd192)
				begin
					is_in_air = 1'b0;
					level = 13'd128;
				end
			else if (Mario_X_Pos > 13'd4080 && Mario_X_Pos < 13'd4208 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd128 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd192)
				begin
					is_in_air = 1'b0;
					level = 13'd128;
				end
			///////////////////////////////////flag di zuo/////////////////////
			else if (Mario_X_Pos > 13'd6320 && Mario_X_Pos < 13'd6352 && (Mario_Y_Pos + Mario_Y_Motion) >= 13'd352 && (Mario_Y_Motion + Mario_Y_Pos) < 13'd384)
				begin
					is_in_air = 1'b0;
					level = 13'd352;
				end
			else
				begin
					is_in_air = 1'b1;
					level = 13'd384;
				end
		end
						
endmodule
