`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:59:03 04/19/2016 
// Design Name: 
// Module Name:    load_ram_or 
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
module load_ram_or(
	input							sys_clk,
	input							fram_clk,
	input							glbl_rst_n,
				
	input 		 				afpga_fram_rden,
	input 		 	[10:0]	afpga_fram_length,
	input 		 	[15:0]	afpga_fram_addr,
				
	input 		 				cons_fram_rden,
	input 		 	[10:0]	cons_fram_length,
	input 		 	[15:0]	cons_fram_addr, 
				
	input							cons_flash_rden,
	input				[23:0]	cons_flash_length,
	input				[24:0]	cons_flash_addr,
				
	input							xfer_flash_rden,
	input				[23:0]	xfer_flash_length,
	input				[24:0]	xfer_flash_addr,
				
	input							card_flash_rden,
	input				[23:0]	card_flash_length,
	input				[24:0]	card_flash_addr,
				
	input							afpga_flash_rden,
	input				[23:0]	afpga_flash_length,
	input				[24:0]	afpga_flash_addr,
				
	input							fram_cons_wren,
	input				[15:0]	fram_cons_addr,
	input				[7:0]		fram_cons_data,
				
	input							flash_cons_wren,
	input				[15:0]	flash_cons_addr,
	input				[7:0]		flash_cons_data,
			 
	input							fram_afpga_wren,
	input				[22:0]	fram_afpga_addr,
	input				[7:0]		fram_afpga_wdata,
				
	input							flash_afpga_wren,
	input				[22:0]	flash_afpga_addr,
	input				[7:0]		flash_afpga_wdata,		
	
	output 	reg				init_fram_rden,
	output 	reg	[10:0]	init_fram_length,
	output 	reg	[15:0]	init_fram_addr,
	
	output 	reg				init_flash_rden,
	output 	reg	[23:0]	init_flash_length,
	output 	reg	[24:0]	init_flash_addr,
	
	output 						init_afpga_wren,
	output 			[22:0]	init_afpga_addr,
	output 			[7:0]		init_afpga_wdata,
	
	output 	reg				init_cons_wren,
	output 	reg	[15:0]	init_cons_addr,
	output 	reg	[7:0]		init_cons_data
);

	
	assign init_afpga_wren = fram_afpga_wren | flash_afpga_wren;
	assign init_afpga_addr = fram_afpga_addr | flash_afpga_addr;
	assign init_afpga_wdata = fram_afpga_wdata | flash_afpga_wdata;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				init_flash_rden <= 0;
				init_flash_length <= 0; 
				init_flash_addr <= 0; 
				init_cons_wren <= 0;
				init_cons_addr <= 0;
				init_cons_data <= 0;
				init_fram_rden <= 0;
				init_fram_length <= 0;
				init_fram_addr <= 0;
			end
		else
			begin
				init_flash_rden <= cons_flash_rden | xfer_flash_rden | card_flash_rden | afpga_flash_rden;
				init_flash_length <= cons_flash_length | xfer_flash_length | card_flash_length | afpga_flash_length; 
				init_flash_addr <= cons_flash_addr | xfer_flash_addr | card_flash_addr | afpga_flash_addr; 
				init_cons_wren <= fram_cons_wren | flash_cons_wren;
				init_cons_addr <= fram_cons_addr | flash_cons_addr;
				init_cons_data <= fram_cons_data | flash_cons_data;
				init_fram_rden <= afpga_fram_rden | cons_fram_rden;
				init_fram_addr <= afpga_fram_addr | cons_fram_addr;
				init_fram_length <= afpga_fram_length | cons_fram_length;
			end

endmodule
