`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:44:45 04/27/2016 
// Design Name: 
// Module Name:    fram_sram_mult 
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
module fram_sram_mult(
	input					sys_clk,
	input					glbl_rst_n,
	
	input      [17:0] sram_addr,
	input      [15:0] fram_addr,
	output     [19:0] fram_sram_addr,
	
	output     [7:0]  sram_in_data,
	input      [7:0]  sram_out_data,
	input             sram_out_en,
	output     [7:0]  fram_in_data,
	input      [7:0]  fram_out_data,
	input             fram_out_en,
	inout      [15:0] fram_sram_data
);

	assign fram_sram_addr = {2'b00,sram_addr} | {4'd0000,fram_addr};

	assign fram_sram_data = (sram_out_en | fram_out_en) ? {8'd0,sram_out_data} | {8'd0,fram_out_data} : 16'hZZZZ;

	assign sram_in_data = fram_sram_data[7:0];
	
	assign fram_in_data = fram_sram_data[7:0];

endmodule