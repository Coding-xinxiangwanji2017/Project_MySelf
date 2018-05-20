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
module datas_scan_CM(
	
	input		wire				clk,
	input		wire				rst,
	
	input 	wire				i_start_con,
	input 	wire [11:0] im_base_addr,
	output	wire				o_done_con,
	output  wire        o_error_con,

	//诊断表RAM接口
	output	wire [10:0] om_diag_ram_addr,
	input		wire [7:0] 	im_diag_ram_dout,
	//fram 控制器接口
	output	wire 				o_e2prom_rden,
	output	wire				o_e2prom_wren,
	output	wire [16:0]	om_e2prom_addr,
	output 	wire				o_e2prom_wr_dv,
	output 	wire [7:0] 	o_e2prom_wdata,
	output	wire [15:0] om_e2prom_wr_len,
	input 	wire				i_e2prom_rd_dv,
	input		wire [7:0]  im_e2prom_rdata,
	input		wire				i_e2prom_rdy,
	//上行数据RAM接口
	output	wire				o_cudb_wren,
	output 	wire [12:0] om_cudb_addr,
	output 	wire [7:0] 	om_cudb_din,
	//下行数据RAM接口
	output 	wire				o_cddb_wren,
	output 	wire [12:0] om_cddb_addr,
	output 	wire [7:0] 	om_cddb_wdata,	
	input		wire [7:0] 	im_cddb_rdata,
	
	output 	wire [12:0] om_ch1_addr,
	input		wire [7:0] 	im_ch1_rdata,
	output 	wire [12:0] om_ch2_addr,
	input		wire [7:0] 	im_ch2_rdata,
	output 	wire [12:0] om_ch3_addr,
	input		wire [7:0] 	im_ch3_rdata,
	output 	wire [12:0] om_ch4_addr,
	input		wire [7:0] 	im_ch4_rdata,
	output 	wire [12:0] om_ch5_addr,
	input		wire [7:0] 	im_ch5_rdata,
	output 	wire [12:0] om_ch6_addr,
	input		wire [7:0] 	im_ch6_rdata

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
	
	wire e2prom_rden2;
	wire e2prom_wren2;
	wire [15:0] e2prom_wr_len2;
	wire [15:0] e2prom_addr2;
	wire e2prom_wr_dv2;
	wire [7:0] e2prom_wdata2;
	wire e2prom_rden3;
	wire e2prom_wren3;
	wire [15:0] e2prom_wr_len3;
	wire [15:0] e2prom_addr3;
	wire e2prom_wr_dv3;
	wire [7:0] e2prom_wdata3;
	
	wire [14:0] cddb_addr2;
	wire cddb_wren3;
	wire [14:0] cddb_addr3;
	wire [7:0] cddb_wdata3;
	wire cddb_wren4;
	wire [14:0] cddb_addr4;
	wire [7:0] cddb_wdata4;
	
	wire cudb_wren1;
	wire [12:0] cudb_addr1;
	wire [7:0] cudb_din1;
	wire cudb_wren2;
	wire [12:0] cudb_addr2;
	wire [7:0] cudb_din2;
	wire cudb_wren3;
	wire [12:0] cudb_addr3;
	wire [7:0] cudb_din3;
	wire cudb_wren4;
	wire [12:0] cudb_addr4;
	wire [7:0] cudb_din4;
	
	wire        rden_buf;
	wire [10:0] raddr_buf;
	wire [07:0] rdata_buf;
	wire        wren_buf;
	wire [10:0] waddr_buf;
  wire [07:0] wdata_buf;  
	wire        rden_buf2;
	wire [10:0] raddr_buf2;
	wire        wren_buf2;
	wire [10:0] waddr_buf2;
  wire [07:0] wdata_buf2;


//=========================================================
// wire or
//=========================================================
//fram
assign o_e2prom_rden = e2prom_rden2;
assign o_e2prom_wren = e2prom_wren2;
assign om_e2prom_addr = e2prom_addr2;
assign o_e2prom_wr_dv = e2prom_wr_dv2;
assign o_e2prom_wdata = e2prom_wdata2;
assign om_e2prom_wr_len = e2prom_wr_len2;

//cddb
assign o_cddb_wren = 1'b0; 
assign om_cddb_addr = cddb_addr2;

//cudb
assign o_cudb_wren = cudb_wren1 | cudb_wren2 | cudb_wren3;
assign om_cudb_addr = cudb_addr1 | cudb_addr2 | cudb_addr3;
assign om_cudb_din = cudb_din1 | cudb_din2 | cudb_din3;

//buf 128byte
assign rden_buf = rden_buf2;
assign raddr_buf = raddr_buf2; 
assign wren_buf = wren_buf2;
assign waddr_buf = waddr_buf2;
assign wdata_buf = wdata_buf2;

//=========================================================
// instation
//=========================================================

con_ctrl_CM con_ctrl_CM(

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

area1_scan_IO area1_scan_IO(

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

area2_scan_IO area2_scan_IO(

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
	
	.o_e2prom_rden(e2prom_rden2),
	.o_e2prom_wren(e2prom_wren2),
	.om_e2prom_wr_len(e2prom_wr_len2),
	.om_e2prom_addr(e2prom_addr2),
	.o_e2prom_wr_dv(e2prom_wr_dv2),
	.o_e2prom_wdata(e2prom_wdata2),
	.i_e2prom_rd_dv(i_e2prom_rd_dv),
	.im_e2prom_rdata(im_e2prom_rdata),
	.i_e2prom_rdy(i_e2prom_rdy),
	
	.rden_buf(rden_buf2),
	.raddr_buf(raddr_buf2),
	.rdata_buf(rdata_buf),
	.wren_buf(wren_buf2),
	.waddr_buf(waddr_buf2),
  .wdata_buf(wdata_buf2)

);

area3_scan_CM area3_scan_CM(

	.clk(clk),
	.rst(rst),

	.i_start(start3),
	.im_base_addr(base_addr),
	.o_done(done3),
	
	.o_cudb_wren(cudb_wren3),
	.om_cudb_addr(cudb_addr3),
	.om_cudb_din(cudb_din3),
	
	.om_ch1_addr(om_ch1_addr), 
	.im_ch1_rdata(im_ch1_rdata),
	.om_ch2_addr(om_ch2_addr), 
	.im_ch2_rdata(im_ch2_rdata),
	.om_ch3_addr(om_ch3_addr), 
	.im_ch3_rdata(im_ch3_rdata),
	.om_ch4_addr(om_ch4_addr), 
	.im_ch4_rdata(im_ch4_rdata),
	.om_ch5_addr(om_ch5_addr), 
	.im_ch5_rdata(im_ch5_rdata),
	.om_ch6_addr(om_ch6_addr), 
	.im_ch6_rdata(im_ch6_rdata)

);

//128byte data buf
RAM_2048_8_SDP buf_128byte(
    // Inputs
    .RADDR(raddr_buf),//
    .RCLK(clk),
    .REN(rden_buf),//
    .WADDR(waddr_buf),
    .WCLK(clk),
    .WD(wdata_buf),
    .WEN(wren_buf),
    // Outputs
    .RD(rdata_buf)//
);



endmodule