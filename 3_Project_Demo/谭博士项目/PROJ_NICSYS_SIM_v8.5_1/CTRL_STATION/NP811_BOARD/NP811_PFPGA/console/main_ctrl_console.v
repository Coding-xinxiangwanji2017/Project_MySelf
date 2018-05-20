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
module main_ctrl_console(

	input wire 				clk,
	input wire 				rst,
	
	input wire 				i_con_in_en,
	input wire 				i_con_out_en,

	input wire 				i_ini_ok,
	input wire [63:0] im_con_in_par,
	input wire [63:0] im_con_out_par,
	input wire [63:0] im_con_var_par,
	
	output reg 				o_start_scan,
	output reg [11:0] om_base_addr,
	input 						i_done_scan,
	
	output reg 				o_afpga_wren,
	output reg [22:0]	om_afpga_addr,
	output reg [7:0] 	om_afpga_wdata

);

	//=========================================================
	// Local parameters
	//=========================================================
	
	//fsm
	parameter s0 = 8'b00000001;
	parameter s1 = 8'b00000010;
	parameter s2 = 8'b00000100;
	parameter s3 = 8'b00001000;
	parameter s4 = 8'b00010000;
	parameter s5 = 8'b00100000;
	parameter s6 = 8'b01000000;
	parameter s7 = 8'b10000000;
	
	
	
	//=========================================================
	// internal signals
	//=========================================================

	
	reg [15:0] cnt;
	reg [7:0] state;
	wire con_in_en_pos;
	wire con_out_en_pos;
	reg con_in_en_d1;
	reg con_in_en_d2;
	reg con_out_en_d1;
	reg con_out_en_d2;

	reg [15:0] len_con_in;
	reg [15:0] ba_con_in;
	reg [15:0] len_con_out;
	reg [15:0] ba_con_out;
	reg [15:0] len_con_var;
	reg [15:0] ba_con_var;

	//=========================================================
	// generate posedge signals
	//=========================================================


	always @ (posedge clk)
	begin
		if(rst)
			begin
				con_in_en_d1 <= 0;
				con_in_en_d2 <= 0;
			end
		else begin
			con_in_en_d1 <= i_con_in_en;
			con_in_en_d2 <= con_in_en_d1;				
		end
	end
	
	always @ (posedge clk)
	begin
		if(rst)
			begin
				con_out_en_d1 <= 0;
				con_out_en_d2 <= 0;
			end
		else begin
			con_out_en_d1 <= i_con_out_en;
			con_out_en_d2 <= con_out_en_d1;				
		end
	end

	assign con_in_en_pos = con_in_en_d1 & ~con_in_en_d2;
	assign con_out_en_pos = con_out_en_d1 & ~con_out_en_d2;

	//=========================================================
	// main_ctrl_fsm_1s
	//=========================================================


	always @ (posedge clk)
	begin
		if(rst)
			begin
				state <= s0;
				om_base_addr <= 0;
				o_start_scan <= 0;
				cnt <= 1;
				o_afpga_wren <= 0;
				om_afpga_addr <= 0;
				om_afpga_wdata <= 0;
			end
		else begin
			case(state)
				s0	:	begin
								if(con_in_en_pos)
									begin
										state <= s1;
										om_base_addr <= ba_con_in[15:4];
										cnt <= 1;
									end
							end
				s1	:	begin
								if(i_con_in_en && cnt <= 16'd16 + len_con_in)
									begin
										state <= s2;
										o_start_scan <= 1;
									end
								else begin
									state <= 	s7;
									o_afpga_wren <= 1;
									om_afpga_addr <= 23'h00_0000;
									om_afpga_wdata <= {5'b0,3'b011};
								end
							end
				s2	:	begin
								if(i_done_scan)
									begin
										state <= s1;
										om_base_addr <= om_base_addr + 8;
										cnt <= cnt + 1;
									end
								else begin
									state <= s2;
									o_start_scan <= 0;
								end
							end
				s7	:	begin
								o_afpga_wren <= 0;
								om_afpga_addr <= 0;
								om_afpga_wdata <= 0;
								if(con_out_en_pos)
									begin
										state <= s3;
										om_base_addr <= ba_con_out[15:4];
										cnt <= 1;
									end
							end	
				s3	:	begin
								if(!i_con_out_en)	
									begin
										state <= s0;
									end
								else begin
									if(cnt <= len_con_out)
											begin
												state <= s4;
												o_start_scan <= 1;
											end
									else begin
										state <= s5;
										om_base_addr <= ba_con_var[15:4];
										cnt <= 1;
									end
								end
							end
				s4	:	begin
								if(i_done_scan)
									begin
										state <= s3;
										om_base_addr <= om_base_addr + 8;
										cnt <= cnt + 1;										
									end
								else begin
									state <= s4;
									o_start_scan <= 0;
								end
							end
				s5	:	begin
								if(i_con_out_en && cnt <= len_con_var)
									begin
										state <= s6;
										o_start_scan <= 1;
									end
								else begin
									state <= s0;
								end
							end
				s6	:	begin
								if(i_done_scan)
									begin
										state <= s5;
										om_base_addr <= om_base_addr + 8;
										cnt <= cnt + 1;										
									end
								else begin
									state <= s6;
									o_start_scan <= 0;
								end
							end
				default	:	state <= s0;
			endcase
		end
	end

	//=========================================================
	// keep console par
	//=========================================================

	always @ (posedge clk)
	begin
		if(rst)
			begin
				len_con_in <= 0;
				ba_con_in <= 0;
			end
		else if(i_ini_ok)
			begin
				len_con_in <= im_con_in_par[15:0];
				ba_con_in <= im_con_in_par[47:32];
			end
	end
	
	always @ (posedge clk)
	begin
		if(rst)
			begin
				len_con_out <= 0;
				ba_con_out <= 0;
			end
		else if(i_ini_ok)
			begin
				len_con_out <= im_con_out_par[15:0];
				ba_con_out <= im_con_out_par[47:32];
			end
	end
	
	always @ (posedge clk)
	begin
		if(rst)
			begin
				len_con_var <= 0;
				ba_con_var <= 0;
			end
		else if(i_ini_ok)
			begin
				len_con_var <= im_con_var_par[15:0];
				ba_con_var <= im_con_var_par[47:32];
			end
	end


endmodule