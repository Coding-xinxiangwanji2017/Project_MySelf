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
module console(

	input  wire 				 clk,
	input  wire 				 rst,
	//模式寄存器接口
	input	 wire	[2:0] 	 im_mode_reg,
	//与process 接口                  	
	input  wire 				 i_con_in_en,
	input  wire 				 i_con_out_en,
	input  wire					 i_down_en,
  //与初始化模块接口                  	
	input  wire 				 i_ini_ok,
	input  wire [63:0] 	 im_con_in_par,
	input  wire [63:0] 	 im_con_out_par,
	input  wire [63:0] 	 im_con_var_par,
	//与诊断表RAM接口
	output wire [10:0]   om_diag_ram_addr,
	input	 wire [7:0] 	 im_diag_ram_dout,
	//维护下行命令RAM对外接口
	input  wire 				 i_cdcb_a_wren,
	input  wire [11:0]	 im_cdcb_a_addr,
	input  wire	[7:0] 	 im_cdcb_a_din,
	output wire [7:0]  	 om_cdcb_a_dout,
	//维护上行命令RAM对外接口
	input  wire 				 i_cucb_a_wren,
	input  wire [11:0]	 im_cucb_a_addr,
	input  wire	[7:0] 	 im_cucb_a_din,
	output wire [7:0]  	 om_cucb_a_dout,
	//维护上行数据RAM对外接口
	input	 wire					 i_cudb_a_wren,
	input  wire [14:0] 	 im_cudb_a_addr,
	input  wire [7:0]    im_cudb_a_din,
	output wire	[7:0]		 om_cudb_a_dout,
	//维护下行数据RAM对外接口
	input  wire				   i_cddb_a_wren,
	input  wire [14:0]   im_cddb_a_addr,
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
	//afpga
	output wire 				 o_afpga_wren,
	output wire [22:0]	 om_afpga_addr,
	output wire [7:0] 	 om_afpga_wdata,
	input  wire [7:0] 	 im_afpga_rdata,
	//flash wr_ctrl
	output wire          flash_rden,
  output wire          flash_wren,
  output wire          flash_era,
  output wire  [24:00] flash_addr,
  output wire  [24:00] flash_length,
  input  wire          flash_ready,
  output wire  [07:00] flash_wr_data,
  output wire          flash_wr_valid,
  output wire          flash_wr_last,
  input  wire [07:00]  flash_rd_data,
  input  wire          flash_rd_valid,
  input  wire          flash_rd_last,
  input  wire          status_reg_en,
  input  wire [07:00]  status_reg,
	//fram 控制器接口
	output wire 				 o_fram_rden,
	output wire				   o_fram_wren,
	output wire [15:0]	 om_fram_addr,
	output wire [15:0]   om_fram_wr_len,
	output wire				   o_fram_wr_dv,
	output wire [7:0] 	 o_fram_wdata,
	input  wire				   i_fram_rd_dv,
	input	 wire [7:0]    im_fram_rdata,
	input	 wire				   i_fram_rdy,
	
	input  wire          i_flag_wr_ddb
	
);

//=========================================================
// inter signals
//=========================================================

	wire 				start_scan;
	wire [11:0] base_addr;
	wire				done_scan;
	
	wire 				start_con;
	wire [11:0] con_base_addr;
	wire				done_con;
	wire        error_con;
	
	wire        cdcb_b_wren;
	wire [11:0] cdcb_b_addr;
	wire [7:0]  cdcb_b_din;
	wire [7:0]  cdcb_b_dout;
	
	wire        cucb_b_wren;
	wire [11:0] cucb_b_addr;
	wire [7:0]  cucb_b_din;
	wire [7:0]  cucb_b_dout;
	
	wire        cddb_b_wren;
	wire [14:0] cddb_b_addr;
	wire [7:0]  cddb_b_din;
	wire [7:0]  cddb_b_dout;
	
	wire        cudb_b_wren;
	wire [14:0] cudb_b_addr;
	wire [7:0]  cudb_b_din;
	wire [7:0]  cudb_b_dout;
	
	wire        afpga_wren0;
	wire [22:0] afpga_addr0;
	wire [7:0]  afpga_din0;
	
	wire        afpga_wren1;
	wire [22:0] afpga_addr1;
	wire [7:0]  afpga_din1;

	wire        fram_rden1;
	wire        fram_wren1;
	wire [15:0] fram_addr1;
	wire [15:0] fram_wr_len1;
	wire        fram_wr_dv1;
	wire [7:0]  fram_wdata1;
	                  
	wire        fram_rden2; 
	wire        fram_wren2; 
	wire [15:0] fram_addr2; 
	wire [15:0] fram_wr_len2;
	wire        fram_wr_dv2;
	wire [7:0]  fram_wdata2;
	
	wire [10:0] ddb_b_addr;
	wire [7:0]  ddb_b_dout;
	
	wire        dub_b_wren;
	wire [10:0] dub_b_addr;
	wire [7:0]  dub_b_din;
	wire [7:0]  dub_b_dout;

	
//=========================================================
// wire or
//=========================================================
	
	assign o_afpga_wren = afpga_wren0 | afpga_wren1;
	assign om_afpga_addr = afpga_addr0 | afpga_addr1;
	assign om_afpga_wdata = afpga_din0 | afpga_din1;
	
	assign o_fram_rden = fram_rden1 | fram_rden2;
	assign o_fram_wren = fram_wren1 | fram_wren2;
	assign om_fram_addr = fram_addr1 | fram_addr2;
	assign om_fram_wr_len = fram_wr_len1 | fram_wr_len2; 
	assign o_fram_wr_dv = fram_wr_dv1 | fram_wr_dv2;
	assign o_fram_wdata = fram_wdata1 | fram_wdata2;

//=========================================================
// instation
//=========================================================

main_ctrl_console main_ctrl_console(

	.clk(clk),
	.rst(rst),
	
	.i_con_in_en(i_con_in_en),
	.i_con_out_en(i_con_out_en),
  
	.i_ini_ok(i_ini_ok),
	.im_con_in_par(im_con_in_par),
	.im_con_out_par(im_con_out_par),
	.im_con_var_par(im_con_var_par),
	
	.o_start_scan(start_scan),
	.om_base_addr(base_addr),
	.i_done_scan(done_scan),
	
	.o_afpga_wren(afpga_wren0), 
	.om_afpga_addr(afpga_addr0),
	.om_afpga_wdata(afpga_din0)
  
);

cmds_scan cmds_scan(

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

datas_scan datas_scan(
	
	.clk(clk),
	.rst(rst),
	
	.i_start_con(start_con),
	.im_base_addr(con_base_addr),
	.o_done_con(done_con),
	.o_error_con(error_con),
  
	.im_mode_reg(im_mode_reg),
	
	.om_diag_ram_addr(om_diag_ram_addr),
	.im_diag_ram_dout(im_diag_ram_dout),
	
	.o_fram_rden(fram_rden1),
	.o_fram_wren(fram_wren1),
	.om_fram_addr(fram_addr1),
	.om_fram_wr_len(fram_wr_len1),
	.o_fram_wr_dv(fram_wr_dv1),
	.o_fram_wdata(fram_wdata1),
	.i_fram_rd_dv(i_fram_rd_dv),
	.im_fram_rdata(im_fram_rdata),
	.i_fram_rdy(i_fram_rdy),
	
	.o_cudb_wren(cudb_b_wren),
	.om_cudb_addr(cudb_b_addr),
	.om_cudb_din(cudb_b_din),

	.o_cddb_wren(cddb_b_wren),
	.om_cddb_addr(cddb_b_addr),
	.om_cddb_wdata(cddb_b_din),	
	.im_cddb_rdata(cddb_b_dout),
	
	.o_afpga_wren(afpga_wren1),
	.om_afpga_addr(afpga_addr1),
	.om_afpga_wdata(afpga_din1),
	.im_afpga_rdata(im_afpga_rdata)

);

down down(

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
	
	.o_fram_rden(fram_rden2),
	.o_fram_wren(fram_wren2),
	.om_fram_addr(fram_addr2),
	.om_fram_wr_len(fram_wr_len2),
	.o_fram_wr_dv(fram_wr_dv2),
	.o_fram_wdata(fram_wdata2),
	.i_fram_rd_dv(i_fram_rd_dv),
	.im_fram_rdata(im_fram_rdata),
	.i_fram_rdy(i_fram_rdy),
	
  .flash_rden(flash_rden),
  .flash_wren(flash_wren),
  .flash_era(flash_era),
  .flash_addr(flash_addr),
  .flash_length(flash_length),
  .flash_ready(flash_ready),
  .flash_wr_data(flash_wr_data),
  .flash_wr_valid(flash_wr_valid),
  .flash_wr_last(),
  .flash_rd_data(flash_rd_data),
  .flash_rd_valid(flash_rd_valid),
  .flash_rd_last(flash_rd_last),
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
RAM_32K_8_DP cddb(
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
RAM_32K_8_DP cudb(
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



endmodule










