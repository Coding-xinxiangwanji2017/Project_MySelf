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
module down_IO(

	input  wire         clk,
	input  wire         rst,
	                
	input  wire         i_down_en,
	input  wire         i_flag_wr_ddb,
	        
	output reg  [10:00] om_ddb_addr,
	input  wire [07:00] im_ddb_dout,
	                    
	output reg          o_dub_wren,
	output reg  [10:00] om_dub_addr,
	output reg  [07:00] om_dub_din,
	input  wire [07:00] im_dub_dout,
		
  output reg          o_e2prom_rden,
  output reg          o_e2prom_wren,
  output reg  [16:00] om_e2prom_addr,
  output reg  [16:00] om_e2prom_wr_len,
  input  wire         om_e2prom_rdy,
  output reg  [07:00] om_e2prom_wdata,
  output reg          om_e2prom_wr_dv,
  output reg          om_e2prom_wr_last,
  input  wire [07:00] im_e2prom_rdata,
  input  wire         i_e2prom_rd_dv,
  input  wire         i_e2prom_rd_last,
  input  wire         status_reg_en,
  input  wire [07:00] status_reg

);

//=========================================================
// local parameter
//=========================================================

parameter top_e2prom_ot = 16'd2117;

parameter s0  = 14'b00_0000_0000_0001;
parameter s1  = 14'b00_0000_0000_0010;
parameter s2  = 14'b00_0000_0000_0100;
parameter s3  = 14'b00_0000_0000_1000;
parameter s4  = 14'b00_0000_0001_0000;
parameter s5  = 14'b00_0000_0010_0000;
parameter s6  = 14'b00_0000_0100_0000;
parameter s7  = 14'b00_0000_1000_0000;
parameter s8  = 14'b00_0001_0000_0000;
parameter s9  = 14'b00_0010_0000_0000;
parameter s10 = 14'b00_0100_0000_0000;
parameter s11 = 14'b00_1000_0000_0000;
parameter s12 = 14'b01_0000_0000_0000;
parameter s13 = 14'b10_0000_0000_0000;


//=========================================================
// inter signals
//=========================================================

reg [13:0] state;
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
			o_e2prom_wren <= 0;
			o_e2prom_rden <= 0;
			om_e2prom_addr <= 0;
			om_e2prom_wr_len <= 0;
			om_e2prom_wdata <= 0;
			om_e2prom_wr_dv <= 0;
			o_dub_wren <= 0;
			om_dub_addr <= 0;
			om_dub_din <= 0;
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
								8'h04	:	state <= s6;
								default :	state <= s0;
							endcase
						end
			s4	:	begin
							if(cnt >= top_e2prom_ot)
								begin
									state <= s0;
								end
							else begin
								if(om_e2prom_rdy)
									begin
										state <= s7;
										o_e2prom_wren <= 1;
										om_e2prom_wr_len <= 128;
										om_e2prom_addr <= {1'b0,r_cmds[31:24],r_cmds[39:32],r_cmds[47:40]};
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
							if(cnt >= top_e2prom_ot)
								begin
									state <= s0;
								end
							else begin
								if(om_e2prom_rdy)
									begin
										state <= s9;
										cnt <= 0;
										om_dub_addr <= 11'd7;
										o_e2prom_rden <= 1;
										om_e2prom_wr_len <= 128;
										om_e2prom_addr <= {1'b0,r_cmds[31:24],r_cmds[39:32],r_cmds[47:40]};
									end
								else begin
									state <= s5;
									cnt <= cnt + 1;
								end
							end
						end
			s6	:	begin
							if(cnt >= top_e2prom_ot)
								begin
									state <= s0;
								end
							else begin
								if(om_e2prom_rdy)
									begin
										state <= s10;
										o_e2prom_rden <= 1;
										om_e2prom_addr <= {1'b1,24'd0};
									end
								else begin
									state <= s6;
									cnt <= cnt + 1;
								end
							end
						end
			s7	:	begin
							om_ddb_addr <= om_ddb_addr + 1;
							o_e2prom_wren <= 0;
							om_e2prom_addr <= 0;
							om_e2prom_wr_len <= 0;
							if(cnt >= 3)
								begin
									state <= s8;
									om_e2prom_wr_dv <= 1;
									om_e2prom_wdata <= im_ddb_dout;
									cnt <= 1;
								end
							else begin
								state <= s7;
								cnt <= cnt + 1;
							end
						end
			s8	:	begin
							if(cnt >= 128)
								begin
									state <= s5;
									cnt <= 1;
									om_e2prom_wr_dv <= 0;
									om_e2prom_wdata <= 0;
								end
							else begin
								state <= s8;
								cnt <= cnt + 1;
								om_ddb_addr <= om_ddb_addr + 1;
								om_e2prom_wdata <= im_ddb_dout;							
							end
						end
			s9	:	begin
							o_e2prom_rden <= 0;
							om_e2prom_addr <= 0;
							om_e2prom_wr_len <= 0;
							if(cnt >= 128)
								begin
									state <= s12;
									o_dub_wren <= 0;
								end
							else begin
								state <= s9;
								o_dub_wren <= i_e2prom_rd_dv;
								om_dub_din <= im_e2prom_rdata;
								if(i_e2prom_rd_dv)
									begin
										cnt <= cnt + 1;
										om_dub_addr <= om_dub_addr + 1;
									end
							end
						end
			s10	:	begin
							if(status_reg_en)
								begin
									state <= s11;
									o_dub_wren <= 1;
									om_dub_addr <= 8;
									om_dub_din <= status_reg;
								end
						end
			s11	:	begin
							state <= s12;
							o_dub_wren <= 0;
						end
			s12	:	begin
							state <= s13;
							shift1_en <= 1;
							o_dub_wren <= 1;
							om_dub_addr <= 0;
							om_dub_din <= r_cmds[63:56];
							cnt <= 1;
						end
			s13	:	begin
							if(cnt >= 8)
								begin
									state <= s0;
									shift1_en <= 0;
									o_dub_wren <= 0;
									om_dub_addr <= 0;
									om_dub_din <= 0;
								end
							else begin
								state <= s13;
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