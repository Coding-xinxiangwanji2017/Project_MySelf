`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:47:27 04/19/2016 
// Design Name: 
// Module Name:    fram_load_afpga 
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
module fram_load_afpga(
	input							sys_clk,
	input							fram_clk,
	input							glbl_rst_n,
			
	input 						fram_afpga_en,
	output	reg				fram_afpga_done,
	output	reg				fram_afpga_error,
	
	output 	reg 				afpga_fram_rden,
	output 	reg 	[10:0]	afpga_fram_length,
	output 	reg 	[15:0]	afpga_fram_addr,
	input 						init_fram_valid,
	input 						init_fram_last,
	input 			[7:0]		init_fram_data,
	
	output 	reg				fram_afpga_wren,
	output 	reg	[22:0]	fram_afpga_addr,
	output 	reg	[7:0]		fram_afpga_wdata
);

	parameter afpga_start_addr = 	23'h100000 ;//Æ«ÒÆ´°¿Ú´óÐ¡

	localparam idle 	= 	2'd0;
	localparam rd_fr 	= 	2'd1;
	localparam wr_af	= 	2'd1;

	reg init_fram_last_reg;

	reg [1:0]rd_state;
	reg [4:0]rd_cnt;
	
	reg data_flag;
	reg [1:0]wr_state;
	reg [7:0]checksum;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				fram_afpga_wren <= 0;
				fram_afpga_addr <= 0;
				fram_afpga_wdata <= 0;
				fram_afpga_done <= 0;
				fram_afpga_error <= 0;
				checksum <= 0;
				data_flag <= 0;
				wr_state <= idle;
			end
		else
			case(wr_state)
				idle	:	begin
								fram_afpga_wren <= 0;
								fram_afpga_wdata <= 0;
								fram_afpga_done <= 0;
								fram_afpga_error <= 0;
								data_flag <= 0;
								if(fram_afpga_en) 
									begin
										wr_state <= wr_af;
										fram_afpga_addr[20] <= 1;
										fram_afpga_addr[13:0] <= 14'b1111_1111_1111_11;
									end
							end
				wr_af	:	begin
								if(init_fram_valid) 
									begin
										data_flag <= ~data_flag;
										if(data_flag == 0)
											begin
												fram_afpga_addr[13:0] <= fram_afpga_addr[13:0] + 1'b1;
												fram_afpga_wren <= 1;
												fram_afpga_wdata <= init_fram_data;
												checksum <= init_fram_data[0] + init_fram_data[1] + init_fram_data[2] + init_fram_data[3] + init_fram_data[4] + init_fram_data[5] + init_fram_data[6] + init_fram_data[7] ;
											end
										if(data_flag == 1)
											begin
												fram_afpga_wren <= 0;
												if(1)////////////////checksum[3:0] == init_fram_data[7:4]
													begin
														if(fram_afpga_addr[13:0] == 14'h1ff)//14'h3bff///////////////
															begin
																fram_afpga_wren <= 0;
																fram_afpga_addr <= 0;
																wr_state <= idle;
																fram_afpga_done <= 1;
															end
													end
												else
													begin
														wr_state <= idle;
														fram_afpga_error <= 1;
													end
											end
									end
							end
				default	:	wr_state <= idle; 
			endcase

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				afpga_fram_rden <= 0;
				afpga_fram_length <= 0;
				afpga_fram_addr <= 0;
				rd_state <= idle;
			end
		else
			case(rd_state)
				idle	:	begin
								if(fram_afpga_en)
									begin
										afpga_fram_rden <= 1;
										afpga_fram_length <= 11'd1024;
										afpga_fram_addr <= 16'h0400;
										rd_cnt <= 1;
										rd_state <= rd_fr;
									end
							end
				rd_fr	:	begin
								if(fram_afpga_error == 1)
									begin
										afpga_fram_rden <= 0;
										afpga_fram_length <= 0;
										afpga_fram_addr <= 0;
										rd_cnt <= 0;
										rd_state <= idle;
									end
								else
									begin
										if(rd_cnt == 1)//30//////////////////////////////////////
											begin
												afpga_fram_rden <= 0;
												afpga_fram_length <= 0;
												afpga_fram_addr <= 0;
												rd_cnt <= 0;
												rd_state <= idle;
											end
										else
											begin
												if(init_fram_last_reg)
													begin
														afpga_fram_rden <= 1;
														afpga_fram_length <= 11'd1024;
														afpga_fram_addr <= afpga_fram_addr + 16'd1024;
														rd_cnt <= rd_cnt + 1'b1;
													end
												else
													begin
														afpga_fram_rden <= 0;
													end
											end
									end
							end
				default	:	rd_state <= idle; 
			endcase

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			init_fram_last_reg <= 0;
		else
			init_fram_last_reg <= init_fram_last;
			
endmodule
