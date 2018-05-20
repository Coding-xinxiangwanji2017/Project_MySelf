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
// Name of module : Communication_top
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

`timescale 1ns/100ps

module Communication_top(
    input  wire         sys_clk_50m      ,
    input  wire         sys_rst_n        ,	
	                                   
    input  wire         lb_rx_wren       ,	
    input  wire [11:00] lb_rx_waddr      ,	
    input  wire [07:00] lb_rx_wdata       ,	
    input  wire         cb_rx_wren       ,	
    input  wire [14:00] cb_rx_waddr      ,	
    input  wire [07:00] cb_rx_wdata       ,	
    input  wire         rb_rx_wren       ,	
    input  wire [14:00] rb_rx_waddr      ,	
    input  wire [07:00] rb_rx_wdata       ,
	                                   
    input  wire         lb_tx_rden       ,	
    input  wire [10:00] lb_tx_raddr      ,	
    output wire [07:00] lb_tx_rdata      ,	
    input  wire         cb_tx_rden       ,	
    input  wire [14:00] cb_tx_raddr      ,	
    output wire [07:00] cb_tx_rdata      ,
    input  wire         rb_tx_rden       ,	
    input  wire [14:00] rb_tx_raddr      ,	
    output wire [07:00] rb_tx_rdata      ,	
                                      
    input  wire         xfer_in_en       ,	
    input  wire         xfer_out_en      ,	
    input  wire         xnet_en          ,	
	 
    input  wire         init_ok          ,
    input  wire [95:00] init_xfer_para   ,
	 
    output wire         xfer_buf_rden    ,	
    output wire [17:00] xfer_buf_addr    ,	
    input  wire [07:00] xfer_buf_data    ,
	 
    output wire         xfer_afpga_wren  ,	
    output wire         xfer_afpga_rden  ,	
    output wire [22:00] xfer_afpga_addr  ,	
    output wire [07:00] xfer_afpga_wdata ,	
    input  wire [07:00] xfer_afpga_rdata ,
	 
    output wire         xfer_cons_wren   ,	
    output wire         xfer_cons_rden   ,	
    output wire [17:00] xfer_cons_addr   ,	
    output wire [07:00] xfer_cons_wdata  ,	
    input  wire [07:00] xfer_cons_rdata  
);
 	
    wire [11:00] lb_rx_raddr  ;
    wire [07:00] lb_rx_rdata  ;
    wire [14:00] cb_rx_raddr  ;
    wire [07:00] cb_rx_rdata  ;
    wire [14:00] rb_rx_raddr  ;
    wire [07:00] rb_rx_rdata  ;
	 
    wire         lb_tx_wren   ;
    wire [10:00] lb_tx_waddr  ;
	 wire [07:00] lb_tx_wdata  ;
    wire         cb_tx_wren   ;
    wire [14:00] cb_tx_waddr  ;
    wire [07:00] cb_tx_wdata  ;
    wire         rb_tx_wren   ;
    wire [14:00] rb_tx_waddr  ;
    wire [07:00] rb_tx_wdata  ;

	xfer_data_move xfer_data_move (
		.sys_clk_50m(sys_clk_50m), 
		.sys_rst_n(sys_rst_n), 
		.xfer_in_en(xfer_in_en), 
		.xfer_out_en(xfer_out_en), 
		.xnet_en(xnet_en), 
		.init_ok(init_ok), 
		.init_xfer_para(init_xfer_para), 
		.xfer_buf_rden(xfer_buf_rden), 
		.xfer_buf_addr(xfer_buf_addr), 
		.xfer_buf_data(xfer_buf_data), 
		.xfer_afpga_wren(xfer_afpga_wren), 
		.xfer_afpga_rden(xfer_afpga_rden), 
		.xfer_afpga_addr(xfer_afpga_addr), 
		.xfer_afpga_wdata(xfer_afpga_wdata), 
		.xfer_afpga_rdata(xfer_afpga_rdata), 
		.xfer_cons_wren(xfer_cons_wren), 
		.xfer_cons_rden(xfer_cons_rden), 
		.xfer_cons_addr(xfer_cons_addr), 
		.xfer_cons_wdata(xfer_cons_wdata), 
		.xfer_cons_rdata(xfer_cons_rdata), 
		.lb_rx_raddr(lb_rx_raddr), 
		.lb_rx_rdata(lb_rx_rdata), 
		.cb_rx_raddr(cb_rx_raddr), 
		.cb_rx_rdata(cb_rx_rdata), 
		.rb_rx_raddr(rb_rx_raddr), 
		.rb_rx_rdata(rb_rx_rdata), 
		.lb_tx_wren(lb_tx_wren), 
		.lb_tx_waddr(lb_tx_waddr), 
		.lb_tx_wdata(lb_tx_wdata), 
		.cb_tx_wren(cb_tx_wren), 
		.cb_tx_waddr(cb_tx_waddr), 
		.cb_tx_wdata(cb_tx_wdata), 
		.rb_tx_wren(rb_tx_wren), 
		.rb_tx_waddr(rb_tx_waddr), 
		.rb_tx_wdata(rb_tx_wdata)
	);

	RAM_4096_8_DP lb_rx_buf(
		 // Inputs
		 .A_ADDR(lb_rx_waddr),
		 .A_CLK(sys_clk_50m),
		 .A_DIN(lb_rx_wdata),
		 .A_WEN(lb_rx_wren),
		 .B_ADDR(lb_rx_raddr),
		 .B_CLK(sys_clk_50m),
		 .B_DIN(0),
		 .B_WEN(1'b0),
		 /// Outputs
		 .A_DOUT(),
		 .B_DOUT(lb_rx_rdata)
	);

	RAM_26624_8_DP cb_rx_buf(
		 // Inputs
		 .A_ADDR(cb_rx_waddr),
		 .A_CLK(sys_clk_50m),
		 .A_DIN(cb_rx_wdata),
		 .A_WEN(cb_rx_wren),
		 .B_ADDR(cb_rx_raddr),
		 .B_CLK(sys_clk_50m),
		 .B_DIN(0),
		 .B_WEN(1'b0),
		 /// Outputs
		 .A_DOUT(),
		 .B_DOUT(cb_rx_rdata)
	);

	RAM_26624_8_DP rb_rx_buf(
		 // Inputs
		 .A_ADDR(rb_rx_waddr),
		 .A_CLK(sys_clk_50m),
		 .A_DIN(rb_rx_wdata),
		 .A_WEN(rb_rx_wren),
		 .B_ADDR(rb_rx_raddr),
		 .B_CLK(sys_clk_50m),
		 .B_DIN(0),
		 .B_WEN(1'b0),
		 /// Outputs
		 .A_DOUT(),
		 .B_DOUT(rb_rx_rdata)
	);

	RAM_2048_8_DP lb_tx_buf(
		 // Inputs
		 .A_ADDR(lb_tx_waddr),
		 .A_CLK(sys_clk_50m),
		 .A_DIN(lb_tx_wdata),
		 .A_WEN(lb_tx_wren),
		 .B_ADDR(lb_tx_raddr),
		 .B_CLK(sys_clk_50m),
		 .B_DIN(0),
		 .B_WEN(1'b0),
		 // Outputs
		 .A_DOUT(),
		 .B_DOUT(lb_tx_rdata)
	);

	RAM_26624_8_DP cb_tx_buf(
		 // Inputs
		 .A_ADDR(cb_tx_waddr),
		 .A_CLK(sys_clk_50m),
		 .A_DIN(cb_tx_wdata),
		 .A_WEN(cb_tx_wren),
		 .B_ADDR(cb_tx_raddr),
		 .B_CLK(sys_clk_50m),
		 .B_DIN(0),
		 .B_WEN(1'b0),
		 /// Outputs
		 .A_DOUT(),
		 .B_DOUT(cb_tx_rdata)
	);

	RAM_26624_8_DP rb_tx_buf(
		 // Inputs
		 .A_ADDR(rb_tx_waddr),
		 .A_CLK(sys_clk_50m),
		 .A_DIN(rb_tx_wdata),
		 .A_WEN(rb_tx_wren),
		 .B_ADDR(rb_tx_raddr),
		 .B_CLK(sys_clk_50m),
		 .B_DIN(0),
		 .B_WEN(1'b0),
		 /// Outputs
		 .A_DOUT(),
		 .B_DOUT(rb_tx_rdata)
	);
		
endmodule
