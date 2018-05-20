`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:47:53 04/19/2016 
// Design Name: 
// Module Name:    fram_load_cons 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fram_load_cons(
	input							sys_clk,
	input							fram_clk,
	input							glbl_rst_n,
			
	input 						fram_cons_en,
	output	reg				fram_cons_done,
	output	reg				fram_cons_error,
	
	output 	reg 				cons_fram_rden,
	output 	reg 	[10:0]	cons_fram_length,
	output 	reg 	[15:0]	cons_fram_addr,
	input 						init_fram_valid,
	input 						init_fram_last,
	input 			[7:0]		init_fram_data,
	 
	output 						fram_cons_wren,
	output 	reg	[15:0]	fram_cons_addr,
	output 			[7:0]		fram_cons_data,
	
	output 	reg	[31:0]	fram_cons_crc
);

	wire crc_right;
	
	localparam idle 	= 	0;
	localparam wr_co 	= 	1;
	
	reg init_fram_last_reg;
	reg init_fram_last_crc;

	reg wr_state;

	reg fram_load_cons_flag;

	assign crc_right = 1;////////////////////////////////////////

	assign fram_cons_wren = init_fram_valid & fram_load_cons_flag;
	assign fram_cons_data = (init_fram_valid & fram_load_cons_flag) ? init_fram_data : 8'b0;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			fram_load_cons_flag <= 0;
		else
			begin
				if(fram_cons_en) fram_load_cons_flag <= 1;
				if(fram_cons_done | fram_cons_error) fram_load_cons_flag <= 0;
			end

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			fram_cons_crc <= 0;
		else
			if(init_fram_valid) fram_cons_crc <= {init_fram_data,fram_cons_crc[31:8]};
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				wr_state <= idle;
				fram_cons_addr <= 0;
				fram_cons_done <= 0;
				fram_cons_error <= 0;
			end
		else
			case(wr_state)
				idle	:	begin
								fram_cons_done <= 0;
								fram_cons_error <= 0;
								if(fram_cons_en)
									begin
										wr_state <= wr_co;
										fram_cons_addr <= 15'h0400;
									end
							end
				wr_co	:	begin
								if(init_fram_valid) fram_cons_addr <= fram_cons_addr + 1'b1;
								if(init_fram_last_crc) 
									begin
										fram_cons_addr <= 0;
										wr_state <= idle;
										if(crc_right == 1)
											fram_cons_done <= 1;
										else
											fram_cons_error <= 1;
									end
							end
				default	:	wr_state <= idle; 
			endcase


	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				init_fram_last_reg <= 0;
				init_fram_last_crc <= 0;
			end
		else
			begin
				init_fram_last_reg <= init_fram_last;
				init_fram_last_crc <= init_fram_last_reg;
			end

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				cons_fram_rden <= 0;
				cons_fram_length <= 0;
				cons_fram_addr <= 0;
			end
		else
			begin
				if(fram_cons_en)
					begin
						cons_fram_rden <= 1;
						cons_fram_length <= 11'h384;
						cons_fram_addr <= 0;
					end
				else
					begin
						cons_fram_rden <= 0;
						cons_fram_length <= 0;
						cons_fram_addr <= 0;
					end
			end

endmodule
