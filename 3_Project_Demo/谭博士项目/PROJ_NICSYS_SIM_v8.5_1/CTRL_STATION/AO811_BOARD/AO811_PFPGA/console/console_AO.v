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
module console_AO(

	input  wire 				 clk,
	input  wire 				 rst,
	
	input	 wire	       	 i_down_en,
	input  wire [02:0]   im_mode_reg,
  //与初始化模块接口                  	
	input  wire 				 i_ini_ok,
	//与诊断表RAM接口
	output wire [10:0]   om_diag_ram_addr,
	input	 wire [7:0] 	 im_diag_ram_dout,
	//维护下行命令RAM对外接口
	input  wire 				 i_cdcb_a_wren,
	input  wire [10:0]	 im_cdcb_a_addr,
	input  wire	[7:0] 	 im_cdcb_a_din,
	output wire [7:0]  	 om_cdcb_a_dout,
	//维护上行命令RAM对外接口
	input  wire 				 i_cucb_a_wren,
	input  wire [10:0]	 im_cucb_a_addr,
	input  wire	[7:0] 	 im_cucb_a_din,
	output wire [7:0]  	 om_cucb_a_dout,
	//维护上行数据RAM对外接口
	input	 wire					 i_cudb_a_wren,
	input  wire [12:0] 	 im_cudb_a_addr,
	input  wire [7:0]    im_cudb_a_din,
	output wire	[7:0]		 om_cudb_a_dout,
	//维护下行数据RAM对外接口
	input  wire				   i_cddb_a_wren,
	input  wire [12:0]   im_cddb_a_addr,
	input  wire [7:0] 	 im_cddb_a_din,	
	output wire [7:0] 	 om_cddb_a_dout,
	//下装下行ram对外接口
	input  wire          i_ddb_a_wren,
	input  wire [10:0]   im_ddb_a_addr,
	input  wire [7:0]    im_ddb_a_din,
	output wire [7:0]    om_ddb_a_dout,
	//下装上行ram对外接口
	input  wire          i_dub_a_wren,
	input  wire [10:0]   im_dub_a_addr,
	input  wire [7:0]    im_dub_a_din,
	output wire [7:0]    om_dub_a_dout,
	//通道处理RAM
	output wire          o_d_chan_buf_wren,
	output wire          o_d_chan_buf_rden,
	output wire [11:00]  om_d_chan_buf_addr,
	output wire [07:00]  om_d_chan_buf_din,
	input  wire [07:00]  im_d_chan_buf_dout,

	//eeprom wr_ctrl
	output wire          o_e2prom_rden,
  output wire          o_e2prom_wren,
  output wire [16:00]  om_e2prom_addr,
  output wire [16:00]  om_e2prom_wr_len,
  input  wire          i_e2prom_ready,
  output wire [07:00]  om_e2prom_wdata,
  output wire          o_e2prom_wr_dv,
  output wire          o_e2prom_wr_last,
  input  wire [07:00]  im_e2prom_rd_data,
  input  wire          i_e2prom_rd_valid,
  input  wire          i_e2prom_rd_last,
  input  wire          i_status_reg_en,
  input  wire [07:00]  im_status_reg,
	
	input  wire [05:00]  im_lb_tx_addr,
	output wire [07:00]  om_lb_tx_dout,
	
	input  wire          i_lb_rx_wren,
	input  wire [05:00]  im_lb_rx_addr,
	input  wire [07:00]  im_lb_rx_din,
	
	
	input  wire          i_flag_wr_ddb
	
);

//=========================================================
// inter signals
//=========================================================

	wire 				start_scan;
	wire [9:0]  base_addr;
	wire				done_scan;
	
	wire 				start_con;
	wire [9:0]  con_base_addr;
	wire				done_con;
	wire        error_con;
	
	wire        cdcb_b_wren;
	wire [10:0] cdcb_b_addr;
	wire [7:0]  cdcb_b_din;
	wire [7:0]  cdcb_b_dout;
	
	wire        cucb_b_wren;
	wire [10:0] cucb_b_addr;
	wire [7:0]  cucb_b_din;
	wire [7:0]  cucb_b_dout;
	
	wire        cddb_b_wren;
	wire [12:0] cddb_b_addr;
	wire [7:0]  cddb_b_din;
	wire [7:0]  cddb_b_dout;
	
	wire        cudb_b_wren;
	wire [12:0] cudb_b_addr;
	wire [7:0]  cudb_b_din;
	wire [7:0]  cudb_b_dout;

	wire        e2prom_rden1;
	wire        e2prom_wren1;
	wire [15:0] e2prom_addr1;
	wire [15:0] e2prom_wr_len1;
	wire        e2prom_wr_dv1;
	wire [7:0]  e2prom_wdata1;
  
	wire        e2prom_rden2; 
	wire        e2prom_wren2; 
	wire [16:0] e2prom_addr2; 
	wire [15:0] e2prom_wr_len2;
	wire        e2prom_wr_dv2;
	wire [7:0]  e2prom_wdata2;
	
	wire [10:0] ddb_b_addr;
	wire [7:0]  ddb_b_dout;
	
	wire        dub_b_wren;
	wire [10:0] dub_b_addr;
	wire [7:0]  dub_b_din;
	wire [7:0]  dub_b_dout;
	
	wire        lb_tx_b_wren;
	wire [5:0]  lb_tx_b_addr;
	wire [7:0]  lb_tx_b_din;

	wire        lb_rx_b_rden;
	wire [5:0]  lb_rx_b_addr;
	wire [7:0]  lb_rx_b_dout;
	
//=========================================================
// wire or
//=========================================================

	assign o_e2prom_rden = e2prom_rden1 | e2prom_rden2;
	assign o_e2prom_wren = e2prom_wren1 | e2prom_wren2;
	assign om_e2prom_addr = {1'b0,e2prom_addr1} | e2prom_addr2;
	assign om_e2prom_wr_len = {1'b0,(e2prom_wr_len1 | e2prom_wr_len2)}; 
	assign o_e2prom_wr_dv = e2prom_wr_dv1 | e2prom_wr_dv2;
	assign om_e2prom_wdata = e2prom_wdata1 | e2prom_wdata2;
	
//=========================================================
// instation
//=========================================================

main_ctrl_console_IO main_ctrl_console_IO(

	.clk(clk),
	.rst(rst),
	
	.i_down_en(i_down_en),
  
	.i_ini_ok(i_ini_ok),
	
	.o_start_scan(start_scan),
	.om_base_addr(base_addr),
	.i_done_scan(done_scan)
	  
);

cmds_scan_IO cmds_scan_IO(

	.clk(clk),
	.rst(rst),
  
	.i_start_scan(start_scan),			
	.im_base_addr(base_addr),
	.o_done_scan(done_scan),
	
	.o_cdcb_wren(cdcb_b_wren),
	.om_cdcb_addr(cdcb_b_addr),
	.im_cdcb_dout(cdcb_b_dout),
  
	.o_cucb_wren(cucb_b_wren),
	.om_cucb_addr(cucb_b_addr),
	.om_cucb_din(cucb_b_din),
	
	.o_start_con(start_con),
	.om_base_addr(con_base_addr),
	.i_done_con(done_con),
	.i_error_con(error_con)

);

datas_scan_AO datas_scan_AO(
	
	.clk(clk),
	.rst(rst),
	
	.i_mode_reg(im_mode_reg),
	.i_start_con(start_con),
	.im_base_addr(con_base_addr),
	.o_done_con(done_con),
	.o_error_con(error_con),
	
	.om_diag_ram_addr(om_diag_ram_addr),
	.im_diag_ram_dout(im_diag_ram_dout),
	
  .o_e2prom_rden(e2prom_rden1),
  .o_e2prom_wren(e2prom_wren1),
  .om_e2prom_addr(e2prom_addr1),
  .om_e2prom_wr_len(e2prom_wr_len1),
  .i_e2prom_rdy(i_e2prom_ready),
  .o_e2prom_wdata(e2prom_wdata1),
  .o_e2prom_wr_dv(e2prom_wr_dv1),
  .im_e2prom_rdata(im_e2prom_rd_data),
  .i_e2prom_rd_dv(i_e2prom_rd_valid),

	.o_cudb_wren(cudb_b_wren),
	.om_cudb_addr(cudb_b_addr),
	.om_cudb_din(cudb_b_din),

	.o_cddb_wren(cddb_b_wren),
	.om_cddb_addr(cddb_b_addr),
	.om_cddb_wdata(cddb_b_din),	
	.im_cddb_rdata(cddb_b_dout),
	
	.o_dchannel_wren(o_d_chan_buf_wren),
	.o_dchannel_rden(o_d_chan_buf_rden),
	.om_dchannel_addr(om_d_chan_buf_addr),
	.om_dchannel_wdata(om_d_chan_buf_din),	
	.im_dchannel_rdata(im_d_chan_buf_dout),

	.o_lb_rx_rden(lb_rx_b_rden), 
  .om_lb_rx_addr(lb_rx_b_addr),
  .im_lb_rx_rdata(lb_rx_b_dout),

	.o_lb_tx_wren(lb_tx_b_wren), 
  .om_lb_tx_addr(lb_tx_b_addr),
  .om_lb_tx_wdata(lb_tx_b_din)

);

down_IO down_IO(

	.clk(clk),
	.rst(rst),
	
	.i_down_en(i_down_en),
	.i_flag_wr_ddb(i_flag_wr_ddb),
	
	.om_ddb_addr(ddb_b_addr),
	.im_ddb_dout(ddb_b_dout),
	
	.o_dub_wren(dub_b_wren),
	.om_dub_addr(dub_b_addr),
	.om_dub_din(dub_b_din),
	.im_dub_dout(dub_b_dout),
	
  .o_e2prom_rden(e2prom_rden2),
  .o_e2prom_wren(e2prom_wren2),
  .om_e2prom_addr(e2prom_addr2),
  .om_e2prom_wr_len(e2prom_wr_len2),
  .om_e2prom_rdy(i_e2prom_ready),
  .om_e2prom_wdata(e2prom_wdata2),
  .om_e2prom_wr_dv(e2prom_wr_dv2),
  .om_e2prom_wr_last(),
  .im_e2prom_rdata(im_e2prom_rd_data),
  .i_e2prom_rd_dv(i_e2prom_rd_valid),
  .i_e2prom_rd_last(),
  .status_reg_en(status_reg_en),
  .status_reg(status_reg)

);

//ram inst
//维护下行命令RAM
RAM_2048_8_DP cdcb(
    // Inputs
    .A_ADDR(im_cdcb_a_addr),
    .A_CLK(clk),
    .A_DIN(im_cdcb_a_din),
    .A_WEN(i_cdcb_a_wren),
    .B_ADDR(cdcb_b_addr),
    .B_CLK(clk),
    .B_DIN(),
    .B_WEN(cdcb_b_wren),
    // Outputs
    .A_DOUT(om_cdcb_a_dout),
    .B_DOUT(cdcb_b_dout)
);
//维护上行命令RAM
RAM_2048_8_DP cucb(
    // Inputs
    .A_ADDR(im_cucb_a_addr),
    .A_CLK(clk),
    .A_DIN(im_cucb_a_din),
    .A_WEN(i_cucb_a_wren),
    .B_ADDR(cucb_b_addr),
    .B_CLK(clk),
    .B_DIN(cucb_b_din),
    .B_WEN(cucb_b_wren),
    // Outputs
    .A_DOUT(om_cucb_a_dout),
    .B_DOUT()
);
//维护下行数据RAM
RAM_8K_8_DP cddb(
    // Inputs
    .A_ADDR(im_cddb_a_addr),
    .A_CLK(clk),
    .A_DIN(im_cddb_a_din),
    .A_WEN(i_cddb_a_wren),
    .B_ADDR(cddb_b_addr),
    .B_CLK(clk),
    .B_DIN(cddb_b_din),
    .B_WEN(cddb_b_wren),
    // Outputs
    .A_DOUT(om_cddb_a_dout),
    .B_DOUT(cddb_b_dout)
);
//维护上行数据ram
RAM_8K_8_DP cudb(
    // Inputs
    .A_ADDR(im_cudb_a_addr),
    .A_CLK(clk),
    .A_DIN(im_cudb_a_din),
    .A_WEN(i_cudb_a_wren),
    .B_ADDR(cudb_b_addr),
    .B_CLK(clk),
    .B_DIN(cudb_b_din),
    .B_WEN(cudb_b_wren),
    // Outputs
    .A_DOUT(om_cudb_a_dout),
    .B_DOUT()
);


//下装下行ram
RAM_2048_8_DP ddb(
    // Inputs
    .A_ADDR(im_ddb_a_addr),
    .A_CLK(clk),
    .A_DIN(im_ddb_a_din),
    .A_WEN(i_ddb_a_wren),
    .B_ADDR(ddb_b_addr),
    .B_CLK(clk),
    .B_DIN(0),
    .B_WEN(0),
    // Outputs
    .A_DOUT(om_ddb_a_dout),
    .B_DOUT(ddb_b_dout)
);

//下装上行ram
RAM_2048_8_DP dub(
    // Inputs
    .A_ADDR(im_dub_a_addr),
    .A_CLK(clk),
    .A_DIN(im_dub_a_din),
    .A_WEN(i_dub_a_wren),
    .B_ADDR(dub_b_addr),
    .B_CLK(clk),
    .B_DIN(dub_b_din),
    .B_WEN(dub_b_wren),
    // Outputs
    .A_DOUT(om_dub_a_dout),
    .B_DOUT(dub_b_dout)
);
//lb_tx_buf
RAM_64_8_DP lb_tx_buf(
    // Inputs
    .A_ADDR(im_lb_tx_addr),
    .A_CLK(clk),
    .B_ADDR(6'd0),
    .B_CLK(1'b0),
    .C_ADDR(lb_tx_b_addr),
    .C_CLK(clk),
    .C_DIN(lb_tx_b_din),
    .C_WEN(lb_tx_b_wren),
    // Outputs
    .A_DOUT(om_lb_tx_dout),
    .B_DOUT()
);

RAM_64_8_DP lb_rx_buf(
    // Inputs
    .A_ADDR(lb_rx_b_addr),
    .A_CLK(clk),
    .B_ADDR(6'd0),
    .B_CLK(1'b0),
    .C_ADDR(im_lb_rx_addr),
    .C_CLK(clk),
    .C_DIN(im_lb_rx_din),
    .C_WEN(i_lb_rx_wren),
    // Outputs
    .A_DOUT(lb_rx_b_dout),
    .B_DOUT()
);


endmodule










