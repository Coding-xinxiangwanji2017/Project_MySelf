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
module main_ctrl(

	input clk,
	input rst,

	input [2:0] mode_reg,
	input [3:0] slot_id,

	input flag_slot_start,
	input [7:0] id_slot,
	output reg flag_start_token,
	
	output reg process_en,

	output reg join_start,

	output reg ini_start,
	input ini_done,
	input ini_fail,

	output reg mb_tx_en,
	output reg lb_tx_en,
	output reg cb_tx_en,
	output reg rb_tx_en,

	output reg down_en

);

	//=========================================================
	// Local parameters
	//=========================================================

	parameter down_mode = 3'b100;
	parameter console_mode = 3'b010;
	parameter run_mode = 3'b001;
	
	parameter max_ini_time = 600000;
	parameter mul_fac1 = 600;				//3s计时采用2段计数，1段的计数周期为mul_fac1,2段计数周期为mul_fac2，由板卡类型确定
	parameter top_cnt3 = 1;					//在第1个令牌环周期进入正常运行状态

	parameter max_id_slot = 8'd71;
	parameter slot_id_npa = 4'd14;
	parameter slot_id_npb = 4'd13;

	parameter idle = 5'b00000;			//初始化状态检测模式开关进入s0或者s1
	parameter s0 = 5'b00001;				//非下装模式则启动初始化模块之后等待初始化模块的返回结果
	parameter s1 = 5'b00010;				//初始化返回结果为成功后，等待3s/3.5s在此期间检测令牌环的令牌
	parameter s2 = 5'b00100;				//等待系统运行5个令牌环周期
	parameter s3 = 5'b01000;				//结束上电启动，系统正常运行
	parameter s4 = 5'b10000;				//下载模式

	
	//=========================================================
	// Internal signal definition
	//=========================================================


	reg [15:0] cnt2;			//3.5s等待计时器的2段计数器，1段为cnt1
	reg [15:0] cnt3;			//令牌环周期计数器
	reg flag_token_start;
	
	reg [4:0] state;

	reg	[19:0] cnt1;
	reg [19:0] top_cnt1;
	reg	cnt1_rst;
	reg	cnt1_en;
	reg	cnt2_rst;
	reg	cnt2_en;
	reg	cnt3_rst;
	reg	cnt3_en;
	
	reg [15:0] mul_fac2;

	//=========================================================
	// main_ctrl_fsm_1s
	//=========================================================

always @ (posedge clk)
begin
	if(rst)
		begin
			state <= idle;
			join_start <= 1;
			down_en <= 0;
			mb_tx_en <= 0;
			lb_tx_en <= 0;
			cb_tx_en <= 0;
			rb_tx_en <= 0;
			ini_start <= 0;
			cnt1_rst <= 1;
			cnt1_en <= 0;
			top_cnt1 <= 0;
			cnt2_rst <= 1;
			cnt2_en <= 0;
			cnt3_rst <= 1;
			cnt3_en <= 0;
			flag_start_token <= 0;
			process_en <= 0;
		end
	else begin
		case(state)
			idle	:	begin
								if(mode_reg == down_mode)
									begin
										state <= s4;
										down_en <= 1;
										mb_tx_en <= 1;
									end
								else begin
									state <= s0;
									ini_start <= 1;
									lb_tx_en <= 0;
									cb_tx_en <= 0;
									rb_tx_en <= 0;
									cnt1_rst <= 1;
									cnt1_en <= 1;
									top_cnt1 <= max_ini_time;
								end
							end
							
			s0		:	begin
								if(cnt1 >= top_cnt1)
									begin
										cnt1_en <= 0;
										state <= idle;
									end
								else begin
									if(ini_done)
										begin
											state <= s1;
											cnt1_rst <= 1;
											cnt2_rst <= 1;
											top_cnt1 <= mul_fac1;
											cnt2_en <= 1;
											lb_tx_en <= 1;
											cb_tx_en <= 1;
											rb_tx_en <= 1;
										end
									else if(ini_fail)
										begin
											cnt1_en <= 0;
											state <= idle;
										end
									else begin
										state <= s0;
										ini_start <= 0;
										cnt1_rst <= 0;
									end
								end
							end
							
			s1		:	begin
								if(cnt2 >= mul_fac2)
									begin
										state <= s2;
										join_start <= 0;
										flag_start_token <= 1;
										cnt1_en <= 0;
										cnt3_rst <= 1;
										cnt3_en <= 1;
										process_en <= 1;
									end
								else begin
									if(flag_slot_start)
										begin
										state <= s2;
										join_start <= 1;
										cnt1_en <= 0;
										cnt3_rst <= 1;
										cnt3_en <= 1;
										process_en <= 1;
										end
									else begin
										state <= s1;
										cnt2_rst <= 0;
										cnt1_rst <= 0;
									end
								end
							end
							
			s2		:	begin
								if(cnt3 >= top_cnt3)
									begin
										state <= s3;
										join_start <= 1;
										cnt3_en <= 0;
									end
								else begin
									state <= s2;
									cnt3_rst <= 0;
									flag_start_token <= 0;
									mb_tx_en <= 1;
								end
							end
							
			s3		:	begin
								if(mode_reg == down_mode)
									begin
										state <= s4;
										down_en <= 1;
										lb_tx_en <= 0;
										cb_tx_en <= 0;
										rb_tx_en <= 0;
										process_en <= 0;
									end
							end
							
			s4		:	begin
								if(mode_reg != down_mode)
									begin
										state <= idle;
										down_en <= 0;
										mb_tx_en <= 0;
									end
							end
		
			default	:	state <= idle;
		endcase
	end
end

	//=========================================================
	// cnt1/2/3
	//=========================================================

always @ (posedge clk)
begin
	if(rst)
		cnt1 <= 0;
	else if(cnt1_rst)
		cnt1 <= 0;
	else if(cnt1 >= top_cnt1)
		cnt1 <= 0;
	else if(cnt1_en)
		cnt1 <= cnt1 + 1;
end

always @ (posedge clk)
begin
	if(rst)
		cnt2 <= 0;
	else if(cnt2_rst)
		cnt2 <= 0;
	else if(cnt2_en && cnt1 >= top_cnt1)
		cnt2 <= cnt2 + 1;
end

always @ (posedge clk)
begin
	if(rst)
		cnt3 <= 0;
	else if(cnt3_rst)
		cnt3 <= 0;
	else if(cnt3_en && flag_token_start)
		cnt3 <= cnt3 + 1;
end

//令牌环周期开始flag信号生成

always @ (posedge clk)
begin
	if(rst)
		flag_token_start <= 0;
	else if(flag_slot_start && id_slot == max_id_slot)
		flag_token_start <= 1;
	else
		flag_token_start <= 0;
end

//根据板卡ID确定mul_fac2

always @ (posedge clk)
begin
	if(rst)
		mul_fac2 <= 16'd30;
	else if(slot_id == slot_id_npa)
		mul_fac2 <= 16'd30;
	else if(slot_id == slot_id_npb)
		mul_fac2 <= 16'd70;
end


endmodule