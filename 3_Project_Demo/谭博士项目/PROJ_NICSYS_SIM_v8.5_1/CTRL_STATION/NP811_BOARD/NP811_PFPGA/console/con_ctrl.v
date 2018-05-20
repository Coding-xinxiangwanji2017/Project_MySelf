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
module con_ctrl(

	input		wire				clk,
	input		wire				rst,
	
	input 	wire				i_start_con,
	input 	wire [11:0] im_base_addr,
	output	reg					o_done_con,
	output  reg         o_error_con,
	
	output	reg [2:0] 	type_area,
	
	output	reg					o_start1,
	input		wire				i_done1,
	output	reg					o_start2,
	input		wire				i_done2,
	input   wire        i_error2,
	output	reg					o_start3,
	input		wire				i_done3,
	input   wire        i_error3,
	output	reg	[11:0]  om_base_addr
	
);

//=========================================================
// Local parameters
//=========================================================

	parameter s0 = 6'b00_0001;
	parameter s1 = 6'b00_0010;
	parameter s2 = 6'b00_0100;
	parameter s3 = 6'b00_1000;
	parameter s4 = 6'b01_0000;
	parameter s5 = 6'b10_0000;

	parameter type_area1 = 3'b001;
	parameter type_area2 = 3'b010;
	parameter type_area3 = 3'b100;

//=========================================================
// internal signals
//=========================================================	

	reg [5:0] state;

//=========================================================
// fsm_1s
//=========================================================	

always @ (posedge clk)
begin
	if(rst)
		begin
			state <= s0;
			o_start1 <= 0;   
			o_start2 <= 0;
			o_start3 <= 0;
			o_done_con <= 0;
			o_error_con <= 0;
		end
	else begin
		case(state)
			s0	:	begin
							if(i_start_con)
								begin
									state <= s1;
								end
						end
			s1	:	begin
							if(type_area == 3'b001)
								begin
									state <= s2;
									o_start1 <= 1;
								end
							else if(type_area == 3'b010)
								begin
									state <= s3;
									o_start2 <= 1;
								end
							else begin
								state <= s4;
								o_start3 <= 1;
							end
						end
			s2	:	begin
							if(i_done1)
								begin
									state <= s5;
									o_done_con <= 1;
								end
							else begin
								state <= s2;
								o_start1 <= 0;
							end
						end
			s3	:	begin
							if(i_done2)
								begin
									state <= s5;
									o_done_con <= 1;
								end
							else if(i_error2)
								begin
									state <= s5;
									o_error_con <= 1;
								end
							else begin
								state <= s3;
								o_start2 <= 0;
							end
						end
			s4	:	begin
							if(i_done3)
								begin
									state <= s5;
									o_done_con <= 1;
								end
							else if(i_error3)
								begin
									state <= s5;
									o_error_con <= 1;
								end
							else begin
								state <= s4;
								o_start3 <= 0;
							end
						end
			s5	:	begin
							state <= s0;
							o_done_con <= 0;
							o_error_con <= 0;
						end
			default	:	state <= s0;
		endcase
	end
end

//=========================================================
// cap addr & type_area gen
//=========================================================	

always @ (posedge clk)
begin
	if(rst)
		om_base_addr <= 0;
	else if(i_start_con)
		om_base_addr <= im_base_addr;
end

always @ (posedge clk)
begin
	if(rst)
		type_area <= 3'b000;
	else if(i_start_con)
		begin
			if(im_base_addr < 12'd64)
				type_area <= 3'b001;
			else if(im_base_addr < 12'd128)
				type_area <= 3'b010;
			else
				type_area <= 3'b100;
		end
end

endmodule