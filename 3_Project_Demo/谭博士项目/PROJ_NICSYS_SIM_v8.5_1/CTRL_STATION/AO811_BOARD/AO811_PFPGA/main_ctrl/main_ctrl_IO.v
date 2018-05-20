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
module main_ctrl_IO(

 input               clk,
 input               rst,
                    
 input  wire [07:00] im_mode_byte,
 input  wire         i_rst_req,
 
 output reg  [02:00] om_mode_reg,
 output reg          o_ini_start,
 input  wire         i_ini_done,
 input  wire         i_ini_fail,
 output reg          o_tb_txen,
 output reg          o_mb_txen,
 output reg          o_down_en     

);


//=========================================================
// Local parameters
//=========================================================
 parameter cmd_down = 8'h2;
 parameter cmd_con  = 8'h1;
 parameter cmd_run  = 8'h0;
 parameter mode_rst  = 3'b111;
 parameter mode_down = 3'b100;
 parameter mode_con = 3'b010;
 parameter mode_run = 3'b001;
 
 parameter td_mode_change = 100;

 parameter s0 = 5'b00001;			//initial state
 parameter s1 = 5'b00010;			//down-mode state
 parameter s2 = 5'b00100;			//time delay(mode-change form down to run)
 parameter s3 = 5'b01000;			//run-mode state
 parameter s4 = 5'b10000;			//console-mode state





//=========================================================
// Internal signal 
//=========================================================

reg  [04:00] state;
reg  [15:00] cnt;
reg          r_ini_done;
reg          flag_all_done;
reg          cnt_rst;

//=========================================================
// fsm
//=========================================================
always @ (posedge clk)
begin
	if(rst)
		begin
			state <= s0;
			cnt_rst <= 0;
			o_ini_start <= 0;
			om_mode_reg <= 0;
			o_tb_txen <= 0;
			o_mb_txen <= 1;
			o_down_en <= 0;
		end
	else begin
		case(state)
			s0	:	begin
							if(im_mode_byte == cmd_down)
								begin
									state <= s1;
									
								end
							else begin
								state <= s0;
							end
						end
			s1	:	begin
							om_mode_reg <= mode_down;
							o_tb_txen <= 0;
							o_down_en <= 1;
							if(im_mode_byte == cmd_run || i_rst_req)
								begin
									state <= s2;
									o_ini_start <= 1;
									cnt_rst <= 1;
								end
							else begin
								state <= s1;
							end
						end
			s2	:	begin
							om_mode_reg <= mode_rst;
							o_ini_start <= 0;
							cnt_rst <= 0;
							o_tb_txen <= 0;
							o_down_en <= 0;
							if(flag_all_done)
								begin
									state <= s3;
								end
							else begin
								if(i_ini_fail)
									state <= s0; 
//if initial fail,diag will cap the fail sig from initial module and show on led
//mn811 should be re-downloaded.
								else begin
									state <= s2;
								end
							end
						end
			s3	:	begin
							om_mode_reg <= mode_run;
							o_tb_txen <= 1;
							o_down_en <= 0;
							if(im_mode_byte == cmd_down)
								begin
									state <= s1;
								end
							else if(im_mode_byte == cmd_con)
								begin
									state <= s4;
								end
							else begin
								state <= s3;
							end
						end
			s4	:	begin
							om_mode_reg <= mode_con;
							o_tb_txen <= 1;
							o_down_en <= 0;
							if(im_mode_byte == cmd_run)
								begin
									state <= s3;
								end
							else begin
								state <= s4;
							end
						end
			default : state <= s0;
		endcase
	end
end

//=========================================================
//flag signal generate 
//=========================================================

always @ (posedge clk)
begin
	if(rst)
		flag_all_done <= 0;
	else if(r_ini_done && cnt == td_mode_change)
		flag_all_done <= 1;
	else
		flag_all_done <= 0;
end

always @ (posedge clk)
begin
	if(rst)
		r_ini_done <= 0;
	else if(flag_all_done)
		r_ini_done <= 0;
	else if(i_ini_done)
		r_ini_done <= 1;
end

always @ (posedge clk)
begin
	if(rst)
		cnt <= 16'hffff;
	else if(cnt_rst)
		cnt <= 0;
	else if(cnt <= td_mode_change)
		cnt <= cnt + 1;
end


endmodule