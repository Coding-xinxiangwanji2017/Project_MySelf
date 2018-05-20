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
module main_ctrl_console_IO(

	input wire 				clk,
	input wire 				rst,
	
	input wire 				i_down_en,

	input wire 				i_ini_ok,
	
	output reg 				o_start_scan,
	output reg [10:0] om_base_addr,
	input 						i_done_scan
	
);

	//=========================================================
	// Local parameters
	//=========================================================
	
	parameter TOP_ADDR = 6528;
	
	//fsm
	parameter s0 = 3'b001;
	parameter s1 = 3'b010;
	parameter s2 = 3'b100;
	
	
	
	//=========================================================
	// internal signals
	//=========================================================

	reg [2:0] state;
	reg addr_rst;
  reg addr_add;
	//=========================================================
	// main_ctrl_fsm_1s
	//=========================================================


	always @ (posedge clk)
	begin
		if(rst)
			begin
				state <= s0;
				o_start_scan <= 0;
				addr_rst <= 0;
				addr_add <= 0;
			end
		else begin
			case(state)
				s0	:	begin
								if(i_ini_ok)
									begin
										state <= s1;
										addr_rst <= 1;
									end
							end
				s1	:	begin
								addr_rst <= 0;
								addr_add <= 0;
								if(!i_down_en)
									begin
										state <= s2;
										o_start_scan <= 1;
									end
								else begin
									state <= 	s0;
								end
							end
				s2	:	begin
								o_start_scan <= 0;
								if(i_done_scan)
									begin
										state <= s1;
										addr_add <= 1;
									end
								else begin
									state <= s2;
								end
							end
				default : state <= s0;
			endcase
		end
	end

	//=========================================================
	// keep console par
	//=========================================================

	always @ (posedge clk)
	begin
		if(rst)
			om_base_addr <= 0;
		else if(addr_rst || om_base_addr >= TOP_ADDR / 16)
			om_base_addr <= 0;
		else if(addr_add)
			om_base_addr <= om_base_addr + 8;
	end



endmodule