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
module sub_ctrl(

	input clk,
	input rst,
	
	input process_en,
	input flag_slot_start,
	input [7:0] id_slot,

	output xfer_in_en,
	output xfer_out_en,
	output cal_en,
	output diag_en,
	output sync_trans_en,
	output sync_recv_en,
	output console_in_en,
	output console_out_en

);


reg [7:0] r_all_en;
//{xfer_in,console_in,cal,diag,syn_trans,console_out,syn_recv,xfer_out}

always @ (posedge clk)
begin
	if(rst)
		r_all_en <= 0;
	else if(flag_slot_start)
		begin
			case(id_slot)
				8'd1	:	r_all_en <= 8'b1000_0000;			//xfer_in
				8'd5	:	r_all_en <= 8'b0100_0000;			//console_in
				8'd10	:	r_all_en <= 8'b0010_0000;			//cal
				8'd43	:	r_all_en <= 8'b0001_0000;			//diag
				8'd53	:	r_all_en <= 8'b0000_1000;			//syn_trans
				8'd55	:	r_all_en <= 8'b0000_0100;			//console_out
				8'd65	:	r_all_en <= 8'b0000_0010;			//syn_recv
				8'd67	:	r_all_en <= 8'b0000_0001;			//xfer_out
				8'd71	:	r_all_en <= 8'b0000_0000;			//end
				default	: ;
			endcase
		end
end

//process_en信号控制该模块输出

assign xfer_in_en = process_en & r_all_en[7];
assign console_in_en = process_en & r_all_en[6];
assign cal_en = process_en & r_all_en[5];
assign diag_en = process_en & r_all_en[4];
assign sync_trans_en = process_en & r_all_en[3];
assign console_out_en = process_en & r_all_en[2];
assign sync_recv_en = process_en & r_all_en[1];
assign xfer_out_en = process_en & r_all_en[0];


endmodule