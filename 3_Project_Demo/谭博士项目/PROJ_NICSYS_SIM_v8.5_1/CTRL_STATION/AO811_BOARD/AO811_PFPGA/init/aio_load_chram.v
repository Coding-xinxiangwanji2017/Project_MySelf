`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:37:23 05/06/2016 
// Design Name: 
// Module Name:    aio_load_chram 
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
module aio_load_chram(
	input						sys_clk,
	input						glbl_rst_n,
	
	input 					load_chram_en,
	output	reg			load_chram_done,
	output	reg			load_chram_error,
	
	output 	reg			chram_eep_rden,
	output 	reg [16:0]	chram_eep_length,
	output 	reg [15:0]	chram_eep_addr,
	input 					init_eep_valid,
	input 					init_eep_last,
	input 		 [7:0]	init_eep_data,
	
	output 	reg			init_chram_wren,
	output 	reg [11:0]	init_chram_addr,
	output 	reg [7:0]	init_chram_wdata
);

	parameter para_addr = 16'h800;
	parameter para_len  = 17'h1100;/////aio «1100£¨dio «1000
	
	localparam idle 	= 	0;
	localparam wr_rm 	= 	1;
	
	reg init_eep_last_reg;
	reg init_eep_last_crc;
	
	reg state;
	reg wr_flag;
	reg [3:0] checksum;
	
	always @ (posedge sys_clk)//
		if(!glbl_rst_n)
			begin
				init_chram_wren <= 0;
				init_chram_addr <= 0;
				init_chram_wdata <= 0;
				load_chram_done <= 0;
				load_chram_error <= 0;
				wr_flag <= 0;
				state <= idle;
			end
		else
			case(state)
				idle	:	begin
								load_chram_done <= 0;
				            load_chram_error <= 0;
								init_chram_wren <= 0;
								init_chram_addr <= 0;
								init_chram_wdata <= 0;
								wr_flag <= 0;
								if(load_chram_en)
									begin
										state <= wr_rm;
										init_chram_addr <= 12'b1111_1111_1111;
									end
								else
									init_chram_addr <= 0;
							end
				wr_rm	:	begin
								if(init_eep_last_crc)
									begin
										load_chram_done <= 1;
										state <= idle;
									end
								else
									begin
										if(init_eep_valid)
											begin
												wr_flag <= ~wr_flag;
												if(wr_flag == 0)
													begin
														init_chram_addr <= init_chram_addr + 1;
														init_chram_wdata <= init_eep_data;
														init_chram_wren <= 1;
														checksum <= init_eep_data[0] + init_eep_data[1] + init_eep_data[2] + init_eep_data[3] + init_eep_data[4] + init_eep_data[5] + init_eep_data[6] + init_eep_data[7];
													end
												else
													begin
														if(1)//checksum == init_eep_data[7:4]///////////////////////////////////////////////
															begin
																init_chram_wren <= 0;
															end
														else
															begin
																load_chram_error <= 1;
																state <= idle;
															end
													end
											end
									end
							end
				default	:	state <= idle; 
			endcase
	
	always @ (posedge sys_clk)//
		if(!glbl_rst_n)
			begin
				init_eep_last_reg <= 0;
				init_eep_last_crc <= 0;
			end
		else
			begin
				init_eep_last_reg <= init_eep_last;
				init_eep_last_crc <= init_eep_last_reg;
			end
	
	always @ (posedge sys_clk)//
		if(!glbl_rst_n)
			begin
				chram_eep_rden <= 0;
				chram_eep_length <= 0;
				chram_eep_addr <= 0;
			end
		else
			begin
				if(load_chram_en)
					begin
						chram_eep_rden <= 1;
						chram_eep_length <= para_len;
						chram_eep_addr <= para_addr;
					end
				else
					begin
						chram_eep_rden <= 0;
						chram_eep_length <= 0;
						chram_eep_addr <= 0;
					end
			end

endmodule
