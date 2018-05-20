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
module area1_scan(

	input wire				clk,
	input wire				rst,
	              		
	input wire				i_start,
	input wire [11:0] im_base_addr,
	output reg 				o_done,
	
	output reg [10:0] om_diag_ram_addr,
	input	wire [7:0] 	im_diag_ram_dout,
	
	output reg 				o_cudb_wren,
	output reg [14:0] om_cudb_addr,
	output reg [7:0] 	om_cudb_din

);

//=========================================================
// Local parameters
//=========================================================

	parameter s0 = 3'b001;
	parameter s1 = 3'b010;
	parameter s2 = 3'b100;


//=========================================================
// internal signals
//=========================================================	

	reg [2:0] state;
	reg [11:0] r_addr;
	reg [15:0] cnt;
	reg rden;
	reg rden_d1;
	reg rden_d2;
	reg rden_d3;
	wire rden_d2_pos;
	wire rden_d2_neg;

//=========================================================
// fsm_1s
//=========================================================	

always @ (posedge clk)
begin
	if(rst)
		begin
			state <= s0;
			rden <= 0;
			om_diag_ram_addr <= 0;
			r_addr <= 0;
			o_done <= 0;
			cnt <= 0;
		end
	else begin
		case(state)
			s0	:	begin
							if(i_start)
								begin
									state <= s1;
									rden <= 1;
									om_diag_ram_addr <= 0;
									r_addr <= im_base_addr;
									cnt <= 1;
								end
						end
			s1	:	begin
							if(cnt >= 16)
								begin
									state <= s2;
									rden <= 0;
									om_diag_ram_addr <= 0;
									o_done <= 1;
								end
							else begin
								state <= s1;
								cnt <= cnt + 1;
								om_diag_ram_addr <= om_diag_ram_addr + 1;
							end
						end
			s2	:	begin
							state <= s0;
							o_done <= 0;
						end
			default	:	state <= s0;
		endcase
	end
end


//=========================================================
// wr data in cudb
//=========================================================	



always @ (posedge clk)
begin
	if(rst)
		begin
			rden_d1 <= 0;
			rden_d2 <= 0;
			rden_d3 <= 0;
		end
	else begin
		rden_d1 <= rden;
		rden_d2 <= rden_d1;
		rden_d3 <= rden_d2;
	end
end

assign rden_d2_pos = rden_d2 & ~rden_d3;
assign rden_d2_neg = ~rden_d2 & rden_d3;

always @ (posedge clk)
begin
	if(rst)
		o_cudb_wren <= 0;
	else
		o_cudb_wren <= rden_d2;
end

always @ (posedge clk)
begin
	if(rst)
		om_cudb_din <= 0;
	else if(rden_d2)
		om_cudb_din <= im_diag_ram_dout;
	else
		om_cudb_din <= 0;
end

always @ (posedge clk)
if(rst)
	om_cudb_addr <= 0;
else if(rden_d2_pos)
	om_cudb_addr <= {r_addr,3'b000};
else if(rden_d2_neg)
	om_cudb_addr <= 0;
else if(rden_d2)
	om_cudb_addr <= om_cudb_addr + 1;
else
	om_cudb_addr <= 0;

endmodule