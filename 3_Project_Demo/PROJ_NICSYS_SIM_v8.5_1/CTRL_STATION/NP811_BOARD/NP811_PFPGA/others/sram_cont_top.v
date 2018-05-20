`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:06:28 04/27/2016 
// Design Name: 
// Module Name:    sram_cont_top 
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
module sram_cont_top(
	input					sys_clk,
	input					glbl_rst_n,
		
	input					sram_rd_flag,
	input					sram_wr_start,
	input					sram_wr_done,
		
	input             sram_rd_en,
	input      [17:0] sram_rd_addr,
	output reg [7:0]  sram_rd_data,
	input             sram_wr_en,
	input      [17:0] sram_wr_addr,
	input      [7:0]  sram_wr_data,
	
	output reg        sram_ce1_n,
	output reg        sram_ce2,
	output reg        sram_oe_n,
	output reg        sram_bhen_n,
	output reg        sram_blen_n,
	output            sram_we_n,
	output     [17:0] sram_addr,
	input      [7:0]  sram_in_data,
	output     [7:0]  sram_out_data,
	output            sram_out_en
);

	reg sram_wr_flag;

	reg [7:0]  sram_rd_data_reg;
	
	assign sram_addr = (sram_rd_flag || sram_wr_flag) ? (sram_rd_addr | sram_wr_addr) : 18'd0;
	assign sram_out_en = sram_wr_flag;
	assign sram_out_data = (sram_wr_flag) ? sram_wr_data : 0;
	
	assign sram_we_n = sram_wr_en;
	
	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				sram_rd_data <= 0;
				sram_rd_data_reg <= 0;
			end
		else	
			begin
				sram_rd_data_reg <= sram_in_data;
				sram_rd_data <= sram_rd_data_reg;
			end

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			sram_wr_flag <= 0;
		else	
			begin
				if(sram_wr_start) sram_wr_flag <= 1;
				if(sram_wr_done) sram_wr_flag <= 0;
			end

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				sram_ce1_n <= 0;
				sram_ce2 <= 0;
				sram_oe_n <= 0;
				sram_bhen_n <= 0;
				sram_blen_n <= 0;
			end
		else	
			begin
				if(sram_rd_flag)
					begin
						sram_ce1_n <= 0;
					   sram_ce2 <= 1;
					   sram_oe_n <= 0;
					   sram_bhen_n <= 1;
					   sram_blen_n <= 0;
					end
				else
					if(sram_wr_flag)
						begin
							sram_ce1_n <= 0;
							sram_ce2 <= 1;
							sram_oe_n <= 1;
							sram_bhen_n <= 1;
							sram_blen_n <= 0;
						end
					else
						begin
							sram_ce1_n <= 1;
							sram_ce2 <= 0;
							sram_oe_n <= 1;
							sram_bhen_n <= 1;
							sram_blen_n <= 1;
						end
			end
		
endmodule
