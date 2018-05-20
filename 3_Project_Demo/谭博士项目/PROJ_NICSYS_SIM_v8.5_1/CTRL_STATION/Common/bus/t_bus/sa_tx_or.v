`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:52:43 04/15/2016 
// Design Name: 
// Module Name:    sa_tx_or 
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
module sa_tx_or(
   sys_clk,
	glbl_rst_n,
	
	tx_con_wren,
	tx_con_waddr,
	tx_con_wdata,
	
	rd_wr_wren,
	rd_wr_waddr,
	rd_wr_wdata,
	
	tx_buff_wren,
	tx_buff_wraddr,
	tx_buff_wrdata
);

   input sys_clk;
	input glbl_rst_n;

	input tx_con_wren;
	input [10:0]tx_con_waddr;
	input [7:0]tx_con_wdata;
	
	input rd_wr_wren;
	input [10:0]rd_wr_waddr;
	input [7:0]rd_wr_wdata;
	
	output reg tx_buff_wren;
	output reg [10:0]tx_buff_wraddr;
	output reg [7:0]tx_buff_wrdata;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				tx_buff_wren <= 0;
				tx_buff_wraddr <= 0;
				tx_buff_wrdata <= 0;
			end
		else
			begin
				tx_buff_wren <= tx_con_wren | rd_wr_wren;
				tx_buff_wraddr <= tx_con_waddr | rd_wr_waddr;
				tx_buff_wrdata <= tx_con_wdata | rd_wr_wdata;
			end

endmodule
