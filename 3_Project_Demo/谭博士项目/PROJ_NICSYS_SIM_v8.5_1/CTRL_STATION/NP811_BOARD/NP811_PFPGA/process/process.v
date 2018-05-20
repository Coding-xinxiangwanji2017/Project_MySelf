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
//模块根据模式开关控制板卡的整体的上电和运行流程，并在正常运行时产生使能信号对各功能模块进行功能启动和关闭
module process(

	input       clk,
	input       rst,

	input [2:0] mode_reg,
	input [3:0] slot_id,

	input       flag_slot_start,
	input [7:0] id_slot,
	output      flag_start_token,

	output      join_start,

	output      ini_start,
	input       ini_done,
	input       ini_fail,

	output      mb_tx_en,
	output      lb_tx_en,
	output      cb_tx_en,
	output      rb_tx_en,

	output      down_en,
	output      xfer_in_en,
	output      xfer_out_en,
	output      cal_en,
	output      diag_en,
	output      sync_trans_en,
	output      sync_recv_en,
	output      console_in_en,
	output      console_out_en
	
);


wire process_en;


main_ctrl main_ctrl(

	.clk(clk),
	.rst(rst),
	
	.mode_reg(mode_reg),	
	.slot_id(slot_id),	
	.flag_slot_start(flag_slot_start),
	.id_slot(id_slot),
	.flag_start_token(flag_start_token),	
	.process_en(process_en),
	.join_start(join_start),
	
	.ini_start(ini_start),
	.ini_done(ini_done),
	.ini_fail(ini_fail),
	
	.mb_tx_en(mb_tx_en),
	.lb_tx_en(lb_tx_en),
	.cb_tx_en(cb_tx_en),
	.rb_tx_en(rb_tx_en),
	.down_en(down_en)
	
);

sub_ctrl sub_ctrl(
	
	.clk(clk),
	.rst(rst),
	
	.process_en(process_en),
	.flag_slot_start(flag_slot_start),
	.id_slot(id_slot),
	
	.xfer_in_en(xfer_in_en),
	.xfer_out_en(xfer_out_en),
	.cal_en(cal_en),
	.diag_en(diag_en),
	.sync_trans_en(sync_trans_en),
	.sync_recv_en(sync_recv_en),
	.console_in_en(console_in_en),
	.console_out_en(console_out_en)
	
);





endmodule