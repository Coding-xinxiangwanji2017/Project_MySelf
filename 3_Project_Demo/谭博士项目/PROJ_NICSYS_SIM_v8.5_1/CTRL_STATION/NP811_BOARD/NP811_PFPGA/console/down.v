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
module down(

	input  wire         clk,
	input  wire         rst,
	                
	input  wire         i_down_en,
	input  wire         i_flag_wr_ddb,
	        
	output reg  [10:0]  om_ddb_addr,
	input  wire [7:0]   im_ddb_dout,
	                    
	output reg          o_dub_wren,
	output reg  [10:0]  om_dub_addr,
	output reg  [7:0]   om_dub_din,
	input  wire [7:0]   im_dub_dout,
	
	output reg  				o_fram_rden,
	output reg 				  o_fram_wren,
	output reg  [15:0]	om_fram_addr,
	output reg  [15:0]  om_fram_wr_len,
	output reg 				  o_fram_wr_dv,
	output reg  [7:0] 	o_fram_wdata,
	input  wire				  i_fram_rd_dv,
	input	 wire [7:0]   im_fram_rdata,
	input	 wire				  i_fram_rdy,
	
  output reg          flash_rden,
  output reg          flash_wren,
  output reg          flash_era,
  output reg  [24:00] flash_addr,
  output reg  [24:00] flash_length,
  input  wire         flash_ready,
  output reg  [07:00] flash_wr_data,
  output reg          flash_wr_valid,
  output reg          flash_wr_last,
  input  wire [07:00] flash_rd_data,
  input  wire         flash_rd_valid,
  input  wire         flash_rd_last,
  input  wire         status_reg_en,
  input  wire [07:00] status_reg

);

//=========================================================
// local parameter
//=========================================================

parameter top_flash_ot = 16'd2117;

parameter s0  = 21'b0_0000_0000_0000_0000_0001;
parameter s1  = 21'b0_0000_0000_0000_0000_0010;
parameter s2  = 21'b0_0000_0000_0000_0000_0100;
parameter s3  = 21'b0_0000_0000_0000_0000_1000;
parameter s4  = 21'b0_0000_0000_0000_0001_0000;
parameter s5  = 21'b0_0000_0000_0000_0010_0000;
parameter s6  = 21'b0_0000_0000_0000_0100_0000;
parameter s7  = 21'b0_0000_0000_0000_1000_0000;
parameter s8  = 21'b0_0000_0000_0001_0000_0000;
parameter s9  = 21'b0_0000_0000_0010_0000_0000;
parameter s10 = 21'b0_0000_0000_0100_0000_0000;
parameter s11 = 21'b0_0000_0000_1000_0000_0000;
parameter s12 = 21'b0_0000_0001_0000_0000_0000;
parameter s13 = 21'b0_0000_0010_0000_0000_0000;
parameter s14 = 21'b0_0000_0100_0000_0000_0000;
parameter s15 = 21'b0_0000_1000_0000_0000_0000;
parameter s16 = 21'b0_0001_0000_0000_0000_0000;
parameter s17 = 21'b0_0010_0000_0000_0000_0000;
parameter s18 = 21'b0_0100_0000_0000_0000_0000;
parameter s19 = 21'b0_1000_0000_0000_0000_0000;
parameter s20 = 21'b1_0000_0000_0000_0000_0000;


//=========================================================
// inter signals
//=========================================================

reg [20:0] state;
reg [15:0] cnt;
reg shift_en;
reg shift1_en;
reg [63:0] r_cmds;
reg shift_en_d1;
reg shift_en_d2;
reg shift_en_d3;


//=========================================================
// fsm_1s
//=========================================================

always @ (posedge clk)
begin
	if(rst)
		begin
			state <= s0;
			cnt <= 0;
			shift_en <= 0;
			shift1_en <= 0;
			om_ddb_addr <= 0;
			flash_wren <= 0;
			flash_rden <= 0;
			flash_era <= 0;
			flash_addr <= 0;
			flash_length <= 0;
			flash_wr_data <= 0;
			flash_wr_valid <= 0;
			o_dub_wren <= 0;
			om_dub_addr <= 0;
			om_dub_din <= 0;       
			o_fram_rden <= 0;
			o_fram_wren <= 0;
			om_fram_addr <= 0;
			om_fram_wr_len <= 0;
			o_fram_wr_dv <= 0;
			o_fram_wdata <= 0;
		end
	else begin
		case(state)
			s0	:	begin
							if(i_down_en && i_flag_wr_ddb)
								begin
									state <= s1;
									cnt <= 1;
									shift_en <= 1;
									om_ddb_addr <= 0;
								end
						end
			s1	:	begin
							if(cnt <= 7)
								begin
									state <= s1;
									cnt <= cnt + 1;
									om_ddb_addr <= om_ddb_addr + 1;
								end
							else begin
								state <= s2;
								shift_en <= 0;
								om_ddb_addr <= 0;
								cnt <= 1;
							end
						end
			s2	:	begin
							if(cnt >= 3)
								begin
									state <= s3;
									cnt <= 1;
								end
							else begin
								state <= s2;
								cnt <= cnt + 1;
							end
						end
			s3	:	begin
							cnt <= 1;
							case(r_cmds[63:56])
								8'h01	:	state <= s4;
								8'h02	:	state <= s5;
								8'h03	:	state <= s6;
								8'h04	:	state <= s7;
								8'h05	:	state <= s8;
								8'h06	:	state <= s9;
								default :	state <= s0;
							endcase
						end
			s4	:	begin
							if(cnt >= top_flash_ot)
								begin
									state <= s0;
								end
							else begin
								if(flash_ready)
									begin
										state <= s10;
										flash_wren <= 1;
										flash_length <= 128;
										flash_addr <= {1'b0,r_cmds[31:24],r_cmds[39:32],r_cmds[47:40]};
										om_ddb_addr <= 8;
										cnt <= 1;
									end
								else begin
									state <= s4;
									cnt <= cnt + 1;
								end
							end
						end
			s5	:	begin
							if(cnt >= top_flash_ot)
								begin
									state <= s0;
								end
							else begin
								if(flash_ready)
									begin
										state <= s12;
										cnt <= 0;
										om_dub_addr <= 11'd7;
										flash_rden <= 1;
										flash_length <= 128;
										flash_addr <= {1'b0,r_cmds[31:24],r_cmds[39:32],r_cmds[47:40]};
									end
								else begin
									state <= s5;
									cnt <= cnt + 1;
								end
							end
						end
			s6	:	begin
							if(cnt >= top_flash_ot)
								begin
									state <= s0;
								end
							else begin
								if(flash_ready)
									begin
										state <= s13;
										flash_era <= 1;
									end
								else begin
									state <= s6;
									cnt <= cnt + 1;
								end
							end
						end
			s7	:	begin
							if(cnt >= top_flash_ot)
								begin
									state <= s0;
								end
							else begin
								if(flash_ready)
									begin
										state <= s14;
										flash_rden <= 1;
										flash_addr <= {1'b1,24'd0};
									end
								else begin
									state <= s7;
									cnt <= cnt + 1;
								end
							end
						end
			s8	:	begin
							if(cnt >= top_flash_ot)
								begin
									state <= s0;
								end
							else begin
								if(i_fram_rdy)
									begin
										state <= s16;
										o_fram_wren <= 1;
										om_fram_wr_len <= 16'd128;
										om_fram_addr <= {r_cmds[39:32],r_cmds[47:40]};
										om_ddb_addr <= 8;
									end
								else begin
									state <= s8;
									cnt <= cnt + 1;
								end
							end
						end
			s9	:	begin
							if(cnt >= top_flash_ot)
								begin
									state <= s0;
								end
							else begin
								if(i_fram_rdy)
									begin
										state <= s18;
										o_fram_rden <= 1;
										om_fram_wr_len <= 16'd128;
										om_fram_addr <= {r_cmds[39:32],r_cmds[47:40]};
										cnt <= 0;
										om_dub_addr <= 7;
									end
								else begin
									state <= s9;
									cnt <= cnt + 1;
								end
							end					
						end
			s10	:	begin
							om_ddb_addr <= om_ddb_addr + 1;
							flash_wren <= 0;
							flash_addr <= 0;
							flash_length <= 0;
							if(cnt >= 3)
								begin
									state <= s11;
									flash_wr_valid <= 1;
									flash_wr_data <= im_ddb_dout;
									cnt <= 1;
								end
							else begin
								state <= s10;
								cnt <= cnt + 1;
							end
						end
			s11	:	begin
							if(cnt >= 128)
								begin
									state <= s5;
									cnt <= 1;
									flash_wr_valid <= 0;
									flash_wr_data <= 0;
								end
							else begin
								state <= s11;
								cnt <= cnt + 1;
								om_ddb_addr <= om_ddb_addr + 1;
								flash_wr_data <= im_ddb_dout;							
							end
						end
			s12	:	begin
							flash_rden <= 0;
							flash_addr <= 0;
							flash_length <= 0;
							if(cnt >= 128)
								begin
									state <= s19;
									o_dub_wren <= 0;
								end
							else begin
								state <= s12;
								o_dub_wren <= flash_rd_valid;
								om_dub_din <= flash_rd_data;
								if(flash_rd_valid)
									begin
										cnt <= cnt + 1;
										om_dub_addr <= om_dub_addr + 1;
									end
							end
						end
			s13	:	begin
							state <= s19;
							flash_era <= 0;
						end
			s14	:	begin
							if(status_reg_en)
								begin
									state <= s15;
									o_dub_wren <= 1;
									om_dub_addr <= 8;
									om_dub_din <= status_reg;
								end
						end
			s15	:	begin
							state <= s19;
							o_dub_wren <= 0;
						end
			s16	:	begin
							om_ddb_addr <= om_ddb_addr + 1;
							o_fram_wren <= 0;
							om_fram_addr <= 0;
							om_fram_wr_len <= 0;
							if(cnt >= 3)
								begin
									state <= s17;
									cnt <= 1;
									o_fram_wr_dv <= 1;
									o_fram_wdata <= im_ddb_dout;
								end
							else begin
								state <= s16;
								cnt <= cnt + 1;
							end		
						end
			s17	:	begin
							om_ddb_addr <= om_ddb_addr + 1;
							if(cnt >= 128)
								begin
									state <= s9;
									cnt <= 1;
									o_fram_wr_dv <= 0;
									o_fram_wdata <= 0;
								end
							else begin
								state <= s17;
								cnt <= cnt + 1;
								o_fram_wdata <= im_ddb_dout;
							end
						end
			s18	:	begin
							if(cnt >= 128)
								begin
									state <= s19;
									o_dub_wren <= 0;
									om_dub_addr <= 0;
									om_dub_din <= 0;
								end
							else begin
								state <= s18;
								o_dub_wren <= i_fram_rd_dv;
								om_dub_din <= im_fram_rdata;
								o_fram_rden <= 0;
								om_fram_wr_len <= 16'd0;
								om_fram_addr <= 0;								
								if(i_fram_rd_dv)
									begin
										cnt <= cnt + 1;
										om_dub_addr <= om_dub_addr + 1;
									end
							end
						end
			s19	:	begin
							state <= s20;
							shift1_en <= 1;
							o_dub_wren <= 1;
							om_dub_addr <= 0;
							om_dub_din <= r_cmds[63:56];
							cnt <= 1;
						end
			s20	:	begin
							if(cnt >= 8)
								begin
									state <= s0;
									shift1_en <= 0;
									o_dub_wren <= 0;
									om_dub_addr <= 0;
									om_dub_din <= 0;
								end
							else begin
								state <= s20;
								om_dub_addr <= om_dub_addr + 1;
								om_dub_din <= r_cmds[63:56];
								cnt <= cnt + 1;
							end
						end
			default	:	state <= s0;
		endcase
	end
end


//=========================================================
// shift reg
//=========================================================

always @ (posedge clk)
begin
	if(rst)
		begin
			shift_en_d1 <= 0;
			shift_en_d2 <= 0;
			shift_en_d3 <= 0;
		end
	else begin
		shift_en_d1 <= shift_en;
		shift_en_d2 <= shift_en_d1;
		shift_en_d3 <= shift_en_d2;	
	end
end

always @ (posedge clk)
begin
	if(rst)
		r_cmds <= 0;
	else if(shift_en_d2 || shift1_en)
		r_cmds <= {r_cmds[55:0],im_ddb_dout};
end


endmodule