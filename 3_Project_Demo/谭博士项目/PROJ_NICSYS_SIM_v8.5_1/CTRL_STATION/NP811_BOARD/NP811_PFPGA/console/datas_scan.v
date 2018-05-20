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
module datas_scan(
	
	input		wire				clk,
	input		wire				rst,
	
	input 	wire				i_start_con,
	input 	wire [11:0] im_base_addr,
	output	wire				o_done_con,
	output  wire        o_error_con,

	input		wire	[2:0] im_mode_reg,
	//诊断表RAM接口
	output	wire [10:0] om_diag_ram_addr,
	input		wire [7:0] 	im_diag_ram_dout,
	//fram 控制器接口
	output	wire 				o_fram_rden,
	output	wire				o_fram_wren,
	output	wire [15:0]	om_fram_addr,
	output 	wire				o_fram_wr_dv,
	output 	wire [7:0] 	o_fram_wdata,
	output	wire [15:0] om_fram_wr_len,
	input 	wire				i_fram_rd_dv,
	input		wire [7:0]  im_fram_rdata,
	input		wire				i_fram_rdy,
	//上行数据RAM接口
	output	wire				o_cudb_wren,
	output 	wire [14:0] om_cudb_addr,
	output 	wire [7:0] 	om_cudb_din,
	//下行数据RAM接口
	output 	wire				o_cddb_wren,
	output 	wire [14:0] om_cddb_addr,
	output 	wire [7:0] 	om_cddb_wdata,	
	input		wire [7:0] 	im_cddb_rdata,
	//afpga
	output wire 				o_afpga_wren,
	output wire [22:0]	om_afpga_addr,
	output wire [7:0] 	om_afpga_wdata,
	input  wire [7:0] 	im_afpga_rdata

);


//=========================================================
// Local parameters
//=========================================================




//=========================================================
// internal signals
//=========================================================
	wire start1;
	wire done1;
	wire start2;
	wire done2;
	wire error2;
	wire start3;
	wire done3;
	wire error3;
	wire [11:0] base_addr;
	
	wire fram_rden2;
	wire fram_wren2;
	wire [15:0] fram_wr_len2;
	wire [15:0] fram_addr2;
	wire fram_wr_dv2;
	wire [7:0] fram_wdata2;
	wire fram_rden3;
	wire fram_wren3;
	wire [15:0] fram_wr_len3;
	wire [15:0] fram_addr3;
	wire fram_wr_dv3;
	wire [7:0] fram_wdata3;
	
	wire [14:0] cddb_addr2;
	wire cddb_wren3;
	wire [14:0] cddb_addr3;
	wire [7:0] cddb_wdata3;
	
	wire cudb_wren1;
	wire [14:0] cudb_addr1;
	wire [7:0] cudb_din1;
	wire cudb_wren2;
	wire [14:0] cudb_addr2;
	wire [7:0] cudb_din2;
	wire cudb_wren3;
	wire [14:0] cudb_addr3;
	wire [7:0] cudb_din3;

//=========================================================
// wire or
//=========================================================
//fram
assign o_fram_rden = fram_rden2 | fram_rden3;
assign o_fram_wren = fram_wren2 | fram_wren3;
assign om_fram_addr = fram_addr2 | fram_addr3;
assign o_fram_wr_dv = fram_wr_dv2 | fram_wr_dv3;
assign o_fram_wdata = fram_wdata2 | fram_wdata3;
assign om_fram_wr_len = fram_wr_len2 | fram_wr_len3;

//cddb
assign o_cddb_wren = cddb_wren3;
assign om_cddb_addr = cddb_addr2 | cddb_addr3;
assign om_cddb_wdata = cddb_wdata3;

//cudb
assign o_cudb_wren = cudb_wren1 | cudb_wren2 | cudb_wren3;
assign om_cudb_addr = cudb_addr1 | cudb_addr1 | cudb_addr1;
assign om_cudb_din = cudb_din1 | cudb_din2 | cudb_din3;


//=========================================================
// instation
//=========================================================


con_ctrl con_ctrl(

	.clk(clk),
	.rst(rst),
	
	.i_start_con(i_start_con),
	.im_base_addr(im_base_addr),
	.o_done_con(o_done_con),
	.o_error_con(o_error_con),
	
	.type_area(),
	
	.o_start1(start1),
	.i_done1(done1),
	.o_start2(start2),
	.i_done2(done2),
	.i_error2(error2),
	.o_start3(start3),
	.i_done3(done3),
	.i_error3(error3),
	.om_base_addr(base_addr)
	
);

area1_scan area1_scan(

	.clk(clk),
	.rst(rst),
	
	.i_start(start1),
	.im_base_addr(base_addr),
	.o_done(done1),
	
	.om_diag_ram_addr(om_diag_ram_addr),
	.im_diag_ram_dout(im_diag_ram_dout),
	
	.o_cudb_wren(cudb_wren1),
	.om_cudb_addr(cudb_addr1),
	.om_cudb_din(cudb_din1)

);


area2_scan area2_scan(

	.clk(clk),
	.rst(rst),
	
	.i_start(start2),
	.im_base_addr(base_addr),
	.o_done(done2),
	.o_error(error2),
	
	.om_cddb_addr(cddb_addr2),
	.im_cddb_rdata(im_cddb_rdata),
	
	.o_cudb_wren(cudb_wren2),
	.om_cudb_addr(cudb_addr2),
	.om_cudb_din(cudb_din2),
	
	.o_fram_rden(fram_rden2),
	.o_fram_wren(fram_wren2),
	.om_fram_wr_len(fram_wr_len2),
	.om_fram_addr(fram_addr2),
	.o_fram_wr_dv(fram_wr_dv2),
	.o_fram_wdata(fram_wdata2),
	.i_fram_rd_dv(i_fram_rd_dv),
	.im_fram_rdata(im_fram_rdata),
	.i_fram_rdy(i_fram_rdy)

);

area3_scan area3_scan(

	.clk(clk),
	.rst(rst),
	
	.mode_reg(im_mode_reg),
	.i_start(start3),
	.im_base_addr(base_addr),
	.o_done(done3),
	.o_error(error3),
	
	.o_cudb_wren(cudb_wren3),
	.om_cudb_addr(cudb_addr3),
	.om_cudb_din(cudb_din3),
	
	.o_cddb_wren(cddb_wren3),
	.om_cddb_addr(cddb_addr3),
	.om_cddb_wdata(cddb_wdata3),	
	.im_cddb_rdata(im_cddb_rdata),
	
	.o_afpga_wren(o_afpga_wren),
	.om_afpga_addr(om_afpga_addr),
	.om_afpga_wdata(om_afpga_wdata),
	.im_afpga_rdata(im_afpga_rdata),
	
	.o_fram_rden(fram_rden3),
	.o_fram_wren(fram_wren3),
	.om_fram_wr_len(fram_wr_len3),
	.om_fram_addr(fram_addr3),
	.o_fram_wr_dv(fram_wr_dv3),
	.o_fram_wdata(fram_wdata3),
	.i_fram_rd_dv(i_fram_rd_dv),
	.im_fram_rdata(im_fram_rdata),
	.i_fram_rdy(i_fram_rdy)
	
);




endmodule