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
module area2_scan(

	input 	wire				clk,
	input 	wire				rst,
	              		
	input	 	wire				i_start,
	input		wire [11:0] im_base_addr,
	output 	reg 				o_done,
	output  reg         o_error,
	//维护下行数据RAM
	output 	reg [14:0] 	om_cddb_addr,
	input		wire [7:0] 	im_cddb_rdata,
	//维护上行数据RAM
	output 	reg 				o_cudb_wren,
	output 	reg [14:0] 	om_cudb_addr,
	output 	reg [7:0] 	om_cudb_din,
	//fram
	output	reg 				o_fram_rden,
	output	reg					o_fram_wren,
	output  reg [15:0]  om_fram_wr_len,
	output	reg [15:0]	om_fram_addr,
	output 	reg					o_fram_wr_dv,
	output 	reg [7:0] 	o_fram_wdata,
	input 	wire				i_fram_rd_dv,
	input		wire [7:0]  im_fram_rdata,
	input		wire				i_fram_rdy

);


//=========================================================
// Local parameters
//=========================================================

parameter len_d_area = 128;
parameter code_save = 4'h4;
parameter code_req = 4'h0;
parameter top_time_out = 16'd5;

parameter s0 =  13'b0_0000_0000_0001;
parameter s1 =  13'b0_0000_0000_0010;
parameter s2 =  13'b0_0000_0000_0100;
parameter s3 =  13'b0_0000_0000_1000;
parameter s4 =  13'b0_0000_0001_0000;
parameter s5 =  13'b0_0000_0010_0000;
parameter s6 =  13'b0_0000_0100_0000;
parameter s7 =  13'b0_0000_1000_0000;
parameter s8 =  13'b0_0001_0000_0000;
parameter s9 =  13'b0_0010_0000_0000;
parameter s10 = 13'b0_0100_0000_0000;
parameter s11 = 13'b0_1000_0000_0000;
parameter s12 = 13'b1_0000_0000_0000;



//=========================================================
// internal signals
//=========================================================

	reg [12:0] state;
	reg [3:0] cs;
	reg [14:0] r_addr;
	reg [15:0] cnt;
	reg [15:0] cnt1;
	reg        read_only;

	reg [15:0] r_data;

	reg [15:0] cnt_rd_cddb;
	wire cddb_rden;
	reg cddb_rden_d1;
	reg cddb_rden_d2;
	reg cddb_rden_d3;
	wire cddb_rden_d2_pos;
	wire cddb_rden_pos;
	
	reg rden_buf;
	reg rden_buf_d1;
	reg rden_buf_d2;
	reg rden_buf_d3;
	reg wren_buf;
	reg [10:0] raddr_buf;
	reg [10:0] waddr_buf;
	reg [7:0] wdata_buf;
	wire [7:0] rdata_buf;

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
			raddr_buf <= 0;
			rden_buf <= 0;
			cs <= 0;
			o_fram_rden <= 0;
			o_fram_wren <= 0;
			om_fram_wr_len <= 0;
			om_fram_addr <= 0;
			o_fram_wr_dv <= 0;
			o_fram_wdata <= 0;
			o_cudb_wren <= 0;
			om_cudb_addr <= 0;
			om_cudb_din <= 0;
			read_only <= 0;
		end
	else begin
		case(state)
			s0	:	begin
							o_done <= 0;
							o_error <= 0;
							if(i_start)
								begin
									state <= s10;
									cnt <= 1;
								end
							else begin
								state <= s0;
							end
						end
			s10	:	begin
							if(cnt <= 2)
								begin
									state <= s10;
									cnt <= cnt + 1;
								end
							else begin
								state <= s1;
								cnt1 <= 1;
								raddr_buf <= 0;
								om_fram_wr_len <= 2;
								om_cudb_addr <= r_addr;
							end
						end
			s1	:	begin
							o_cudb_wren <= 0;
							if(cnt1 <= len_d_area / 2)
								begin
									state <= s2;
									rden_buf <= 1;
									cnt <= 1;
								end
							else begin
								state <= s0;
								o_done <= 1;
								raddr_buf <=0;
			          om_fram_wr_len <= 0;
			          om_fram_addr <= 0;	
			          o_fram_wdata <= 0;
			          om_cudb_addr <= 0;	
							  om_cudb_din <= 0;						
							end
						end
			s2	:	begin
							raddr_buf <= raddr_buf + 1;
							if(cnt <= 1)
								begin
									state <= s2;
									cnt <= cnt + 1;
								end
							else begin
								state <= s3;
								rden_buf <= 0;
								cnt <= 1;
							end
						end
			s3	:	begin
							if(cnt <= 2)
								begin
									state <= s3;
									cnt <= cnt + 1;
								end
							else begin
								state <= s4;
							end
						end
			s4	:	begin
							cs <= r_data[15] + r_data[14] + r_data[13] + r_data[12] + r_data[11] + r_data[10] + r_data[9] + r_data[8];
							cnt <= 1;
							if(r_data[3:0] == code_save)
								begin
									state <= s5;
								end
							else if(r_data[3:0] == code_req)
							  begin
							    state <= s7;
							    cnt <= 1;
							    read_only <= 1;
							  end
							else begin
								state <= s11;
							end
						end
			s5	:	begin
							state <= s6;
							o_fram_wren <= 1;
							om_fram_wr_len <= 16'd2;
							om_fram_addr <= r_addr - 1024;
							o_fram_wr_dv <= 1;
							o_fram_wdata <= r_data[15:8];
						end
			s6	:	begin
							state <= s7;
							o_fram_wren <= 0;
							o_fram_wdata <= {cs,4'd0};
						end
			s7	:	begin
							o_fram_wr_dv <= 0;
							o_cudb_wren <= 0;
							if(cnt >= top_time_out)
								begin
									state <= s11;
								end
							else begin
								if(i_fram_rdy)
									begin
										state <= s8;
										o_fram_rden <= 1;
										cnt <= 1;
									end
								else begin
									state <= s7;
									cnt <= cnt + 1;
								end
							end
						end
			s8	:	begin
							if(i_fram_rd_dv)
							  begin
							    if(read_only)
							      begin
							        state <= s9;
							        r_data <= {r_data[7:0],im_fram_rdata};
							      end
							     else begin
						        if(im_fram_rdata == r_data[15:8])
						          state <= s9;
						        else
							        state <= s11;
							     end
							  end
							 else
							  state <= s8;
						end
			s9	:	begin
							if(i_fram_rd_dv)
							  begin
							    if(read_only)
							      begin
							        state <= s12;
							        r_data <= {r_data[7:0],im_fram_rdata};
							        o_cudb_wren <= 1;
							        om_cudb_addr <= om_cudb_addr + 1;
							        om_cudb_din <= r_data[7:0];
							      end
							     else begin
						        if(im_fram_rdata == {cs,4'd0})
						          state <= s12;
						        else
							        state <= s11;
							     end
							  end
							 else
							  state <= s9;
						end

			s11 : begin
			        state <= s0;
			        o_error <= 1;
			        raddr_buf <= 0;
			        om_fram_wr_len <= 0;
			        om_fram_addr <= 0;	
			        om_cudb_addr <= 0;					        
			      end
			s12 : begin
			        state <= s1;
			        cnt1 <= cnt1 + 1;
			      	om_cudb_addr <= om_cudb_addr + 1;
			      	om_fram_addr <= om_fram_addr + 2;
							om_cudb_din <= r_data[7:0];
			      end
			
			default	:	state <= s0;
		endcase
	end
end

//=========================================================
// rd data cap(r_data gen) && r_addr_cap
//=========================================================
//r_data
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
//r_addr
always @ (posedge clk)
begin
	if(rst)
		r_addr <= 0;
	else if(i_start)
		r_addr <= {im_base_addr[10:0],4'd0};
end

//=========================================================
// read 128byte from cddb into buffer
//=========================================================


//read
always @ (posedge clk)
begin
	if(rst)
		cnt_rd_cddb <= 128;
	else if(i_start)
		cnt_rd_cddb <= 0;
	else if(cnt <= 127)
		cnt_rd_cddb <= cnt_rd_cddb + 1;
end

assign cddb_rden = (cnt_rd_cddb >=0 && cnt_rd_cddb <= 127)? 1'b1 : 1'b0;

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

always @ (posedge clk)
begin
	if(rst)
		om_cddb_addr <= 0;
	else if(i_start)
	  om_cddb_addr <= {im_base_addr[10:0],4'd0};
	else if(cddb_rden)
		om_cddb_addr <= om_cddb_addr + 1;
	else
		om_cddb_addr <= 0;
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
end

always @ (posedge clk)
begin
	if(rst)
		wdata_buf <= 0;
	else if(cddb_rden_d2)
		wdata_buf <= im_cddb_rdata;
end


//=========================================================
// buffer inst
//=========================================================
RAM_2048_8_SDP RAM_2048_8_SDP(
    // Inputs
    .RADDR(raddr_buf),
    .RCLK(clk),
    .REN(rden_buf),
    .WADDR(waddr_buf),
    .WCLK(clk),
    .WD(wdata_buf),
    .WEN(wren_buf),
    // Outputs
    .RD(rdata_buf)
);


endmodule