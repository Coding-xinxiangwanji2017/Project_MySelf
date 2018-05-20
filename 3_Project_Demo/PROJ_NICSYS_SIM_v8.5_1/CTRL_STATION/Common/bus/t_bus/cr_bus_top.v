`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:12:18 04/26/2016 
// Design Name: 
// Module Name:    cr_bus_top 
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
module cr_bus_top(
	sys_clk,
	glbl_rst_n,
	cr_clk_0,
	cr_clk_90,
	cr_clk_180,
	cr_clk_270,

	ack_tx_en,
	lpass_tx_en,
	id_now,
	lb_txbuf_rden,
	lb_txbuf_addr,
	lb_txbuf_rdata,
	card_id,
	init_done,

	lb_txen,
	lb_txd,

	diag_ack_wren,
	lb_rxbuf_wren,
	lb_rxbuf_wraddr,
	lb_rxbuf_wrdata,
	got_frame,
	frame_id,
	frame_type,
	sn_error,
	
	lb_rxd
);

   input sys_clk;
	input glbl_rst_n;
	
	input cr_clk_0;
	input cr_clk_90;
	input cr_clk_180;
	input cr_clk_270;
	
	input ack_tx_en;
	input lpass_tx_en;
	input [7:0]id_now;
	output lb_txbuf_rden;
	output [15:0]lb_txbuf_addr;
	input [7:0]lb_txbuf_rdata;
	input [7:0]card_id;
	input init_done;
	
	output lb_txen;
	output lb_txd;

	output diag_ack_wren;
	output lb_rxbuf_wren;
	output [15:0]lb_rxbuf_wraddr;
	output [7:0]lb_rxbuf_wrdata;
	output got_frame;
	output [7:0]frame_id;
	output [7:0]frame_type;
	output sn_error;

	input lb_rxd;
	
	wire rx_buff_rden;
	wire [10:0]rx_buff_rdaddr;
	wire [7:0]rx_buff_rddata;
	wire rx_crc_rslt;
	wire rx_start;
	wire rx_done;
	
	wire tx_buff_wren;
	wire [10:0]tx_buff_wraddr;
	wire [7:0]tx_buff_wrdata;
	wire [10:0]tx_data_len;
	wire tx_start;

	defparam	sa_tx.tx_con.l_bus = 1'b0;
	defparam	sa_rx.wr_rxbuf.l_bus = 1'b0;
	defparam	sa_rx.rx_ram_con.rd_rx_ram.l_bus = 1'b0;
	defparam	sa_rx.rx_ram_con.rx_con_fsm.l_bus = 1'b0;

	sa_tx sa_tx(
		.sys_clk(sys_clk),
		.glbl_rst_n(glbl_rst_n),
		 
		.ack_tx_en(ack_tx_en),
		.lpass_tx_en(lpass_tx_en),
		.id_now(id_now),
		.lb_txbuf_rden(lb_txbuf_rden),
		.lb_txbuf_addr(lb_txbuf_addr),
		.lb_txbuf_rdata(lb_txbuf_rdata),
		.card_id(card_id),
		.init_done(init_done),
		.tx_buff_wren(tx_buff_wren),
		.tx_buff_wraddr(tx_buff_wraddr),
		.tx_buff_wrdata(tx_buff_wrdata),
		.tx_data_len(tx_data_len),
		.tx_start(tx_start)
	);

	sa_rx sa_rx(
		.sys_clk(sys_clk),
		.glbl_rst_n(glbl_rst_n),
		
		.ack_tx_en(ack_tx_en),
		.id_now(id_now),
		.card_id(card_id),
		.init_done(init_done),
		.diag_ack_wren(diag_ack_wren),
		.lb_rxbuf_wren(lb_rxbuf_wren),
		.lb_rxbuf_wraddr(lb_rxbuf_wraddr),
		.lb_rxbuf_wrdata(lb_rxbuf_wrdata),
		.got_frame(got_frame),
		.frame_id(frame_id),
		.frame_type(frame_type),
		.sn_error(sn_error),
		.rx_buff_rden(rx_buff_rden),
		.rx_buff_rdaddr(rx_buff_rdaddr),
		.rx_buff_rddata(rx_buff_rddata),
		.rx_crc_rslt(rx_crc_rslt),
		.rx_start(rx_start),
		.rx_done(rx_done)
	);

	rx_link rx_link(
		
		.sys_clk(sys_clk),
		.clk_phy_p0(cr_clk_0),
		.clk_phy_p90(cr_clk_90),
		.clk_phy_p180(cr_clk_180),
		.clk_phy_p270(cr_clk_270),
		.rst(~glbl_rst_n),
		.rx_buf_rden(rx_buff_rden),
		.rx_buf_raddr(rx_buff_rdaddr),
		.rx_buf_rdata(rx_buff_rddata),
		.lb_rxd(lb_rxd),
		
		.o_rx_done(rx_done),
		.o_rx_crc_rslt(rx_crc_rslt),
		.o_rx_start(rx_start)
	);	

	tx_lianlu_top tx_lianlu_top(
		.wclk(sys_clk),
		.Rclk(cr_clk_0),
		.rst(~glbl_rst_n),
		.tx_buf_wren(tx_buff_wren),
		.tx_buf_waddr(tx_buff_wraddr),
		.tx_buf_wdata(tx_buff_wrdata),
		.tx_data_len(tx_data_len),
		.tx_start(tx_start),
		.lb_txen(lb_txen),
		.lb_txd(lb_txd)
	);

endmodule
