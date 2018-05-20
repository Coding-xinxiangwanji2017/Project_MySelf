////////////////////////////////////////////////////////////////////////////////
// Copyright (c)2015 CNCS Incorporated
// All Rights Reserved
// THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of CNCS Inc.
// The copyright notice above does not evidence any actual or intended
// publication of such source code.
// No part of this code may be reproduced, stored in a retrieval system,
// or transmitted, in any form or by any means, electronic, mechanical,
// photocopying, recording, or otherwise, without the prior written
// permission of CNCS
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Name of module : NP811_U1_C01_TOP
// Project        : NicSys8000
// Func           : Project TOP
// Author         : Liu zhikai
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FG484
// version 1.0    : made in Date: 2015.12.01
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/04/12   Initial version(Tan Xingye)
//
//
//
////////////////////////////////////////////////////////////////////////////////
module cmds_scan(

	input	wire				clk,
	input	wire				rst,

	input	wire				i_start_scan,			
	input	wire [11:0]	im_base_addr,
	output reg				o_done_scan,
	
	output reg 				o_cdcb_wren,
	output reg [11:0] om_cdcb_addr,
	input wire [7:0]  im_cdcb_dout,

	output reg 				o_cucb_wren,
	output reg [11:0] om_cucb_addr,
	output wire [7:0] om_cucb_din,
	
	output reg 				o_start_con,
	output reg [11:0] om_base_addr,
	input wire				i_done_con,
	input wire        i_error_con

);

	//=========================================================
	// Local parameters
	//=========================================================

	parameter do_cmd = 8'h01;	
	parameter s0 = 8'b0000_0001;
	parameter s1 = 8'b0000_0010;
	parameter s6 = 8'b0000_0100;
	parameter s2 = 8'b0000_1000;
	parameter s3 = 8'b0001_0000;
	parameter s4 = 8'b0010_0000;
	parameter s5 = 8'b0100_0000;
	parameter s7 = 8'b1000_0000;
	
	parameter top_con_time = 16'd1000;


	//=========================================================
	// internal signals
	//=========================================================

	reg [7:0] state;
	reg shift1_en;
	reg [15:0] cnt;

	reg shift1_en_d1;
	reg shift1_en_d2;
	reg [63:0] r_cmds;
	
	reg [11:0] r_im_base_addr;
	reg [1:0] type_addr;


	//=========================================================
	// fsm_1s
	//=========================================================

	always @ (posedge clk)
	begin
		if(rst)
			begin
				state <= s0;
				o_cdcb_wren <= 0;
				om_cdcb_addr <= 0;
				o_cucb_wren <= 0;
				om_cucb_addr <= 0;
				cnt <= 1;
				o_start_con <= 0;
				om_base_addr <= 0;
				o_done_scan <= 0;
				shift1_en <= 0;
			end
		else begin
			case(state)
				s0	:	begin
								if(i_start_scan)
									begin
										state <= s1;
										shift1_en <= 1;
										om_cdcb_addr <= im_base_addr;
										cnt <= 1;
									end
							end
				s1	:	begin
								if(cnt <= 7)
									begin
										state <= s1;
										om_cdcb_addr <= om_cdcb_addr + 1;
										cnt <= cnt + 1;
									end
								else begin
									state <= s6;
									shift1_en <= 0;
									cnt <= 1;
								end
							end
				s6	:	begin
								if(cnt >= 2)
									state <= s2;
								else begin
									state <= s6;
									cnt <= cnt + 1;
								end
							end
				s2	:	begin
								if(type_addr == 2'b10)		//需要维护执行模块做动作的区域
									begin
										state <= s3;
									end
								else begin
									state <= s4;
									o_cucb_wren <= 1;
									om_cucb_addr <= r_im_base_addr;
									cnt <= 1;
								end
							end
				s3	:	begin
								if(r_cmds[63:56] == do_cmd)
									begin
										state <= s7;
										o_start_con <= 1;
										om_base_addr <= r_im_base_addr;
									end
								else begin
									state <= s4;
									om_cucb_addr <= r_im_base_addr;
									o_cucb_wren <= 1;
									cnt <= 1;
								end
							end							
				s7	:	begin
								o_start_con <= 0;
								if(cnt <= top_con_time)
									begin
										if(i_done_con)
											begin
												state <= s4;
												om_cucb_addr <= r_im_base_addr;
												o_cucb_wren <= 1;
												cnt <= 1;
											end
										else if(i_error_con)
											begin
												state <= s5;
												o_done_scan <= 1;
											end
										else begin
											state <= s7;
											cnt <= cnt + 1;
										end
									end
								else begin
									state <= s5;
									o_done_scan <= 1;
								end
							end
				s4	:	begin
								if(cnt <= 7)
									begin
										state <= s4;
										om_cucb_addr <= om_cucb_addr + 1;
										cnt <= cnt + 1;
									end
								else begin
									state <= s5;
									o_done_scan <= 1;
									o_cucb_wren <= 0;
								end
							end
				s5	:	begin
								state <= s0;
								o_done_scan <= 0;
							end
				
				default	:	state <= s0;
			endcase
		end
	end

	//=========================================================
	// cap dout from cdcb read and generate write data of cucb
	//=========================================================

	always @ (posedge clk)
	begin
		if(rst)
			begin
				shift1_en_d1 <= 0;
				shift1_en_d2 <= 0;
			end
		else begin
			shift1_en_d1 <= shift1_en;
			shift1_en_d2 <= shift1_en_d1;
		end
	end
	
	always @ (posedge clk)
	begin
		if(rst)
			r_cmds <= 0;
		else if(shift1_en_d2 || o_cucb_wren)
			r_cmds <= {r_cmds[55:0],im_cdcb_dout};
	end

	assign om_cucb_din = (o_cucb_wren)? r_cmds[63:56] : 8'b0;
	
	
	//=========================================================
	// cap input & gennerate type_addr
	//=========================================================	
	
	always @ (posedge clk)
	begin
		if(rst)
			r_im_base_addr <= 0;
		else if(i_start_scan)
			r_im_base_addr <= im_base_addr;
	end

	always @ (posedge clk)
	begin
		if(rst)
			type_addr <= 2'b00;
		else if(i_start_scan)
			begin
				if(im_base_addr >= 12'd56)
					type_addr <= 2'b10;
				else
					type_addr <= 2'b01;
			end
	end

endmodule