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
module area3_scan_CM(

	input 	wire				clk,
	input 	wire				rst,

	input	 	wire				i_start,
	input		wire [09:0] im_base_addr,
	output 	reg 				o_done,
	//维护上行数据RAM
	output 	reg 				o_cudb_wren,
	output 	reg [12:0] 	om_cudb_addr,
	output 	reg [7:0] 	om_cudb_din,
	//下行数据RAM接口
	output 	reg [12:0] 	om_ch1_addr,
	input		wire [7:0] 	im_ch1_rdata,
	output 	reg [12:0] 	om_ch2_addr,
	input		wire [7:0] 	im_ch2_rdata,
	output 	reg [12:0] 	om_ch3_addr,
	input		wire [7:0] 	im_ch3_rdata,
	output 	reg [12:0] 	om_ch4_addr,
	input		wire [7:0] 	im_ch4_rdata,
	output 	reg [12:0] 	om_ch5_addr,
	input		wire [7:0] 	im_ch5_rdata,
	output 	reg [12:0] 	om_ch6_addr,
	input		wire [7:0] 	im_ch6_rdata

);


//=========================================================
// Local parameters
//=========================================================	

	parameter s0  = 3'b001;
	parameter s1  = 3'b010;
	parameter s2  = 3'b100;
	
//=========================================================
// internal signals
//=========================================================

	reg [02:00] state;
	reg [15:00] cnt;
	
	reg rden_chx_buf;
	reg rden_chx_buf_d1;
	reg rden_chx_buf_d2;
	reg rden_chx_buf_d3;
	
	reg [12:00] addr_temp;
	reg [12:00] addr_temp_d1;
	reg [12:00] addr_temp_d2;
	reg [12:00] addr_temp_d3;
	
	wire [2:0]  sel_chx;
	
//=========================================================
// fsm_1s
//=========================================================
always @ (posedge clk)
begin
	if(rst)
		begin
			state <= s0;
			cnt <= 0;
			addr_temp <= 0;
			o_done <= 0;
			rden_chx_buf <= 0;
		end
	else begin
		case(state)
			s0	:	begin
							rden_chx_buf <= 0;
							if(i_start)
								begin
									state <= s1;
									cnt <= 1;
									addr_temp <= {im_base_addr[8:0],4'd0};
							    rden_chx_buf <= 1;
								end
							else begin
								state <= s0;
							end
						end
			s1	:	begin
							if(cnt >= 128)
								begin
									state <= s2;
									o_done <= 1;
									rden_chx_buf <= 0;
								end
							else begin
								state <= s1;
								cnt <= cnt + 1;
								addr_temp <= addr_temp + 1;
							end
						end
			s2	:	begin
							state <= s0;
							addr_temp <= 0;							
							o_done <= 0;
						end
			default	:	state <= s0;
		endcase
	end
end


//=========================================================
// output addr generate
//=========================================================

assign sel_chx = {addr_temp[12],1'b0,addr_temp[10]};

always @ (posedge clk)
begin
	if(rst)
		om_ch1_addr <= 0;
	else if(rden_chx_buf && sel_chx == 3'b000)
		om_ch1_addr <= addr_temp[9:0];
	else
		om_ch1_addr <= 0;
end
always @ (posedge clk)
begin
	if(rst)
		om_ch2_addr <= 0;
	else if(rden_chx_buf && sel_chx == 3'b001)
		om_ch2_addr <= addr_temp[9:0];
	else
		om_ch2_addr <= 0;
end
always @ (posedge clk)
begin
	if(rst)
		om_ch3_addr <= 0;
	else if(rden_chx_buf && sel_chx == 3'b010)
		om_ch3_addr <= addr_temp[9:0];
	else
		om_ch3_addr <= 0;
end
always @ (posedge clk)
begin
	if(rst)
		om_ch4_addr <= 0;
	else if(rden_chx_buf && sel_chx == 3'b011)
		om_ch4_addr <= addr_temp[9:0];
	else
		om_ch4_addr <= 0;
end
always @ (posedge clk)
begin
	if(rst)
		om_ch5_addr <= 0;
	else if(rden_chx_buf && sel_chx == 3'b100)
		om_ch5_addr <= addr_temp[9:0];
	else
		om_ch5_addr <= 0;
end
always @ (posedge clk)
begin
	if(rst)
		om_ch6_addr <= 0;
	else if(rden_chx_buf && sel_chx == 3'b101)
		om_ch6_addr <= addr_temp[9:0];
	else
		om_ch6_addr <= 0;
end

//=========================================================
// signal delay
//=========================================================
always @ (posedge clk)
begin
	if(rst)
		begin
			rden_chx_buf_d1 <= 0;
			rden_chx_buf_d2 <= 0;
			rden_chx_buf_d3 <= 0;
		end
	else begin
		rden_chx_buf_d1 <= rden_chx_buf;
		rden_chx_buf_d2 <= rden_chx_buf_d1;
		rden_chx_buf_d3 <= rden_chx_buf_d2;
	end
end

always @ (posedge clk)
begin
	if(rst)
		begin
			addr_temp_d1 <= 0;
			addr_temp_d2 <= 0;
			addr_temp_d3 <= 0;
		end
	else begin
		addr_temp_d1 <= addr_temp;
		addr_temp_d2 <= addr_temp_d1;
		addr_temp_d3 <= addr_temp_d2;
	end
end

//=========================================================
// write cudb buf
//=========================================================
always @ (posedge clk)
begin
	if(rst)
		o_cudb_wren <= 0;
	else if(rden_chx_buf_d3)
		o_cudb_wren <= 1;
	else
		o_cudb_wren <= 0;
end

always @ (posedge clk)
begin
	if(rst)
		om_cudb_addr <= 0;
	else
		om_cudb_addr <= addr_temp_d3;
end

assign sel_chx_din = {addr_temp_d3[12],1'b0,addr_temp_d3[10]};

always @ (posedge clk)
begin
	if(rst)
		om_cudb_din <= 0;
	else if(rden_chx_buf_d3)
		begin
			case(sel_chx_din)
				3'b000	:	om_cudb_din <= im_ch1_rdata;
				3'b001	:	om_cudb_din <= im_ch2_rdata;
				3'b010	:	om_cudb_din <= im_ch3_rdata;
				3'b011	:	om_cudb_din <= im_ch4_rdata;
				3'b100	:	om_cudb_din <= im_ch5_rdata;
				3'b101	:	om_cudb_din <= im_ch6_rdata;
				default		:	om_cudb_din <= 0;
			endcase
		end
	else
		om_cudb_din <= 0;
end



endmodule