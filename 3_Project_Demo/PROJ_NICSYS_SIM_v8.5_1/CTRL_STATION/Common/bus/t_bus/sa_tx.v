`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:57:22 04/14/2016 
// Design Name: 
// Module Name:    sa_tx 
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
module sa_tx(
   sys_clk,
	glbl_rst_n,
	
	ack_tx_en,
	lpass_tx_en,
	id_now,
	lb_txbuf_rden,
	lb_txbuf_addr,
	lb_txbuf_rdata,
	card_id,
	init_done,
	tx_buff_wren,
	tx_buff_wraddr,
	tx_buff_wrdata,
	tx_data_len,
	tx_start
);

   input sys_clk;
	input glbl_rst_n;
	
	input ack_tx_en;
	input lpass_tx_en;
	input [7:0]id_now;
	output lb_txbuf_rden;
	output [15:0]lb_txbuf_addr;
	input [7:0]lb_txbuf_rdata;
	input [7:0]card_id;
	input init_done;
	output tx_buff_wren;
	output [10:0]tx_buff_wraddr;
	output [7:0]tx_buff_wrdata;
	output [10:0]tx_data_len;
	output tx_start;

	wire rd_wr_wren;
	wire [10:0]rd_wr_waddr;
	wire [7:0]rd_wr_wdata;
	
	wire rd_wr_done;
	wire rd_wr_start;
	wire [10:0]rd_wr_len;
	wire [15:0]rd_addr;
	wire [10:0]wr_addr;
	
	wire tx_con_wren;
	wire [10:0]tx_con_waddr;
	wire [7:0]tx_con_wdata;

	tx_con tx_con(
		.sys_clk(sys_clk),
		.glbl_rst_n(glbl_rst_n),
		
		.ack_tx_en(ack_tx_en),
		.lpass_tx_en(lpass_tx_en),
		.id_now(id_now),
		.card_id(card_id),
		.init_done(init_done),
				
		.rd_wr_done(rd_wr_done),
		.rd_wr_start(rd_wr_start),
		.rd_wr_len(rd_wr_len),
		.rd_addr(rd_addr),
		.wr_addr(wr_addr),
		
		.tx_data_len(tx_data_len),
		.tx_start(tx_start),
	
		.tx_con_wren(tx_con_wren),
		.tx_con_waddr(tx_con_waddr),
		.tx_con_wdata(tx_con_wdata)
	);

	rd_wr rd_wr(
		.sys_clk(sys_clk),
		.glbl_rst_n(glbl_rst_n),
		
		.lb_txbuf_rden(lb_txbuf_rden),
		.lb_txbuf_addr(lb_txbuf_addr),
		.lb_txbuf_rdata(lb_txbuf_rdata),
		
		.rd_wr_done(rd_wr_done),
		.rd_wr_start(rd_wr_start),
		.rd_wr_len(rd_wr_len),
		.rd_addr(rd_addr),
		.wr_addr(wr_addr),
		
		.rd_wr_wren(rd_wr_wren),
		.rd_wr_waddr(rd_wr_waddr),
		.rd_wr_wdata(rd_wr_wdata)
	);

	sa_tx_or sa_tx_or(
		.sys_clk(sys_clk),
		.glbl_rst_n(glbl_rst_n),
		
		.tx_con_wren(tx_con_wren),
		.tx_con_waddr(tx_con_waddr),
		.tx_con_wdata(tx_con_wdata),
		
		.rd_wr_wren(rd_wr_wren),
		.rd_wr_waddr(rd_wr_waddr),
		.rd_wr_wdata(rd_wr_wdata),
		
		.tx_buff_wren(tx_buff_wren),
		.tx_buff_wraddr(tx_buff_wraddr),
		.tx_buff_wrdata(tx_buff_wrdata)
	);

endmodule
