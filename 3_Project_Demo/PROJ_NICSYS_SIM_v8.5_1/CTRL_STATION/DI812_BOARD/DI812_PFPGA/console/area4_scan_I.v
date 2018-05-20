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
module area4_scan_I(

	input 	wire				clk,
	input 	wire				rst,

	input   wire [02:0] i_mode_reg,	
	input	 	wire				i_start,
	input		wire [09:0] im_base_addr,
	output 	reg 				o_done,
	output  reg         o_error,
	//维护上行数据RAM
	output 	reg 				o_cudb_wren,
	output 	reg [12:0] 	om_cudb_addr,
	output 	reg [7:0] 	om_cudb_din,
	//下行数据RAM接口
	output  reg         o_cddb_wren,
	output 	reg [12:0] 	om_cddb_addr,
	output 	reg [7:0] 	om_cddb_wdata,	
	input		wire [7:0] 	im_cddb_rdata,
	//dchannel
	output  reg         o_dchannel_rden,
	output 	reg [11:0]  om_dchannel_addr,
	input  wire [7:0] 	im_dchannel_rdata,
	//lb_tx_buf
	output  reg         o_lb_tx_wren,
	output  reg [5:0]   om_lb_tx_addr,
	output  reg [7:0]   om_lb_tx_wdata,
	
	output  reg         rden_buf,
	output  reg         wren_buf,
	output  reg  [10:0] raddr_buf,
	output  reg  [10:0] waddr_buf,
	output  reg  [7:0]  wdata_buf,
	input   wire [7:0]  rdata_buf	
	
);


//=========================================================
// Local parameters
//=========================================================

	parameter len_d_area = 128;
	parameter top_time_out = 16'd1000;
	parameter code_save = 4'h4;
	parameter code_req = 4'h0;
	parameter code_reserve = 4'hf;

	parameter mode_dowm = 3'b100;
	parameter mode_con = 3'b010;
	parameter mode_run = 3'b001;

	parameter s0  = 13'b0_0000_0000_0001;
	parameter s1  = 13'b0_0000_0000_0010;
	parameter s2  = 13'b0_0000_0000_0100;
	parameter s3  = 13'b0_0000_0000_1000;
	parameter s4  = 13'b0_0000_0001_0000;
	parameter s5  = 13'b0_0000_0010_0000;
	parameter s6  = 13'b0_0000_0100_0000;
	parameter s7  = 13'b0_0000_1000_0000;
	parameter s8  = 13'b0_0001_0000_0000;
	parameter s9  = 13'b0_0010_0000_0000;
	parameter s10 = 13'b0_0100_0000_0000;
	parameter s11 = 13'b0_1000_0000_0000;
	parameter s12 = 13'b1_0000_0000_0000;


//=========================================================
// internal signals
//=========================================================

	reg [12:0] state;

	reg [12:0] r_addr;
	reg [15:0] cnt;
	reg [15:0] cnt1;

	reg [15:0] r_data;
	reg [7:0] r_data3;
	
	reg cddb_rden;
	reg cddb_rden_d1;
	reg cddb_rden_d2;
	reg cddb_rden_d3;
	wire cddb_rden_d2_pos;
	
	reg [7:0] r_data2;
	reg o_dchannel_rden_d1;
	reg o_dchannel_rden_d2;
	reg o_dchannel_rden_d3;
	
	reg rden_buf_d1;
	reg rden_buf_d2;
	reg rden_buf_d3;
	
//=========================================================
// fsm_1s
//=========================================================

always @ (posedge clk)
begin
	if(rst)
		begin
			state <= s0;
			cnt <= 0;
			cnt1 <= 0;
			r_addr <= 0;
			rden_buf <= 0;
			o_cudb_wren <= 0;
			om_cudb_addr <= 0;
			om_cudb_din <= 0;
			o_cddb_wren <= 0;
			om_cddb_addr <= 0;
			om_cddb_wdata <= 0;
			raddr_buf <= 0;
			o_dchannel_rden <= 0;
			om_dchannel_addr <= 0;
			cddb_rden <= 0;
			o_error <= 0;
			o_done <= 0;
			o_lb_tx_wren <= 0;
			om_lb_tx_addr <= 0;
			om_lb_tx_wdata <= 0;
		end
	else begin
		case(state)
			s0	:	begin
							o_done <= 0;
							o_error <= 0;
							if(i_start)
								begin
									state <= s12;
									cnt <= 1;
									cddb_rden <= 1;
									om_cddb_addr <= {im_base_addr[8:0],4'd0};
								end
							else begin
								state <= s0;
							end
						end
						
			s12 : begin
			        if(cnt <= 127)
			          begin
			            state <= s12;
			            cnt <= cnt + 1;
			            om_cddb_addr <= om_cddb_addr + 1;
			          end
			        else begin
			          state <= s11;
			          cddb_rden <= 0;
			          cnt <= 1;
			        end
			      end
			s11	:	begin
							if(cnt <= 2)
								begin
									state <= s11;
									cnt <= cnt + 1;
								end
							else begin
								state <= s1;
								cnt1 <= 1;
								raddr_buf <= 0;
							  om_dchannel_addr <= {1'b0,r_addr[12],1'b0,r_addr[10:1]};
								om_cudb_addr <= r_addr;
								om_cddb_addr <= r_addr + 1;
								om_lb_tx_addr <= 0;			
							end
						end
			s1	:	begin
							if(cnt1 <= len_d_area / 2)
								begin
									state <= s2;
									rden_buf <= 1;
									cnt <= 1;
								end
							else begin
								state <= s0;
								o_done <= 1;
								raddr_buf <= 0;
								om_dchannel_addr <= 0;
								om_cudb_addr <= 0;
								om_cudb_din <= 0;
								om_cddb_addr <= 0;
								om_cddb_wdata <= 0;
								om_lb_tx_addr <= 0;
								om_lb_tx_wdata <= 0;
							end
						end
			s2	:	begin
							raddr_buf <= raddr_buf + 1;							
							if(cnt <= 1)
								begin
									state <= s2;
									cnt <= cnt + 1;
									raddr_buf <= raddr_buf + 1;
								end
							else begin
								state <= s3;
								rden_buf <= 0;
								cnt <= 1;
							end
						end
			s3	:	begin
							if(cnt <= 1)
								begin
									state <= s3;
									cnt <= cnt + 1;
								end
							else begin
								state <= s4;							
							end
						end
			s4	:	begin
							if(r_data[3:0] == code_req)
								begin
									state <= s5;
									o_dchannel_rden <= 1;
									cnt <= 1;
								end
							else begin
								state <= s8;
							end
						end
			s5	:	begin
							o_dchannel_rden <= 0;
							if(cnt <= 2)
								begin
									state <= s5;
									cnt <= cnt + 1;
								end
							else begin
								state <= s6;
								o_cudb_wren <= 1;
								om_cudb_din <= r_data2;
								o_lb_tx_wren <= 1;
								om_lb_tx_wdata <= r_data2;
							end
						end
			s6	:	begin
							state <= s7;
							om_cudb_addr <= om_cudb_addr + 1;
							om_cudb_din <= r_data[7:0];
							o_lb_tx_wren <= 0;
							om_lb_tx_addr <= om_lb_tx_addr + 1;
						end
			s7	:	begin
							state <= s1;
							cnt1 <= cnt1 + 1;
							o_cudb_wren <= 0;
							om_cudb_addr <= om_cudb_addr + 1;
							om_cddb_addr <= om_cddb_addr + 2;
							om_dchannel_addr <= om_dchannel_addr + 1;
						end
			s8	:	begin	
							cnt <= 1;						
							state <= s9;
							o_cddb_wren <= 1;
							om_cddb_wdata <= r_data3;
						end
			s9	:	begin
							state <= s6;
							o_cddb_wren <= 0;
							o_cudb_wren <= 1;
							om_cudb_din <= r_data[15:8];
							o_lb_tx_wren <= 1;
							om_lb_tx_wdata <= r_data[15:8];
						end
			s10 : begin
		          state <= s0;
		          o_error <= 1;
		          raddr_buf <= 0;
							om_dchannel_addr <= 0;
							om_cudb_addr <= 0;
							om_cudb_din <= 0;
							om_cddb_addr <= 0;
							om_cddb_wdata <= 0;
							om_lb_tx_addr <= 0;
		        end	
			default	:	state <= s0;
		endcase
	end
end

//=========================================================
// gen r_data3
//=========================================================
always @ (posedge clk)
begin
	if(rst)
		r_data3 <= 0;
	else begin
		case(r_data[3:0])
			4'h2	:	begin	
								if(i_mode_reg == mode_run)
									r_data3 <= 8'h00;
								else
									r_data3 <= r_data[7:0];
							end
			4'h3	:	r_data3 <= r_data[7:0];
			default	:	r_data3 <= 8'h00;
		endcase
	end
end

//=========================================================
// cap im_base_addr & addr convert
//=========================================================
always @ (posedge clk)
begin
	if(rst)
		r_addr <= 0;
	else if(i_start)
		r_addr <= {im_base_addr[8:0],4'd0};
end

//=========================================================
// buf_data_cap & dchannel_data_cap
//=========================================================
//buf_data cap
always @ (posedge clk)
begin
	if(rst)
		begin
			rden_buf_d1 <= 0;
			rden_buf_d2 <= 0;
			rden_buf_d3 <= 0;
		end
	else begin
		rden_buf_d1 <= rden_buf;
		rden_buf_d2 <= rden_buf_d1;
		rden_buf_d3 <= rden_buf_d2;	
	end
end

always @ (posedge clk)
begin
	if(rst)
		r_data <= 0;
	else if(rden_buf_d2)
		r_data <= {r_data[7:0],rdata_buf};
end

//afpga_dta cap
always @ (posedge clk)
begin
	if(rst)
		begin
			o_dchannel_rden_d1 <= 0;
			o_dchannel_rden_d2 <= 0;
			o_dchannel_rden_d3 <= 0;
		end
	else begin
		o_dchannel_rden_d1 <= o_dchannel_rden;
		o_dchannel_rden_d2 <= o_dchannel_rden_d1;
		o_dchannel_rden_d3 <= o_dchannel_rden_d2;	
	end
end

always @ (posedge clk)
begin
	if(rst)
		r_data2 <= 0;
	else if(o_dchannel_rden_d1)
		r_data2 <= im_dchannel_rdata;
end

//=========================================================
// write 128byte from cddb into buffer
//=========================================================

always @ (posedge clk)
begin
	if(rst)
		begin
			cddb_rden_d1 <= 0;
			cddb_rden_d2 <= 0;
			cddb_rden_d3 <= 0;			
		end
	else begin
		cddb_rden_d1 <= cddb_rden;
		cddb_rden_d2 <= cddb_rden_d1;
		cddb_rden_d3 <= cddb_rden_d2;
	end
end

//write
always @ (posedge clk)
begin
	if(rst)
		wren_buf <= 0;
	else
		wren_buf <= cddb_rden_d2;
end

assign cddb_rden_d2_pos = cddb_rden_d2 & ~cddb_rden_d3;

always @ (posedge clk)
begin
	if(rst)
		waddr_buf <= 0;
	else if(cddb_rden_d2_pos)
		waddr_buf <= 0;
	else if(cddb_rden_d2)
		waddr_buf <= waddr_buf + 1;
	else
		waddr_buf <= 0;
end

always @ (posedge clk)
begin
	if(rst)
		wdata_buf <= 0;
	else if(cddb_rden_d2)
		wdata_buf <= im_cddb_rdata;
	else
		wdata_buf <= 0;
end


endmodule