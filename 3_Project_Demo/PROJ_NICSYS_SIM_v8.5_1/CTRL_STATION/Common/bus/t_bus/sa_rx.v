`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:00:42 04/14/2016 
// Design Name: 
// Module Name:    sa_rx 
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
module sa_rx(
	sys_clk,
	glbl_rst_n,
	
	ack_tx_en,
	id_now,
	card_id,
	init_done,
	diag_ack_wren,
	lb_rxbuf_wren,
	lb_rxbuf_wraddr,
	lb_rxbuf_wrdata,
	got_frame,
	frame_id,
	frame_type,
	sn_error,
	rx_buff_rden,
	rx_buff_rdaddr,
	rx_buff_rddata,
	rx_crc_rslt,
	rx_start,
	rx_done
);

   input sys_clk;
	input glbl_rst_n;
		
	input ack_tx_en;
	input [7:0]id_now;
	
	input [7:0]card_id;
	input init_done;	
	
	output diag_ack_wren;
	output lb_rxbuf_wren;
	output [15:0]lb_rxbuf_wraddr;
	output [7:0]lb_rxbuf_wrdata;
	
	output got_frame;
	output [7:0]frame_id;
	output [7:0]frame_type;
	
	output sn_error;
	
	output rx_buff_rden;
	output [10:0]rx_buff_rdaddr;
	input [7:0]rx_buff_rddata;
	input rx_crc_rslt;
	input rx_start;
	input rx_done;

	wire rx_data_valid;
	wire [7:0]rx_data;
	wire ack_rd_en;
	wire pass_rd_en;

	wr_rxbuf wr_rxbuf(
		.sys_clk(sys_clk),
		.glbl_rst_n(glbl_rst_n),
		
		.card_id(card_id),
		.init_done(init_done),
		
		.diag_ack_wren(diag_ack_wren),
		.lb_rxbuf_wren(lb_rxbuf_wren),
		.lb_rxbuf_wraddr(lb_rxbuf_wraddr),
		.lb_rxbuf_wrdata(lb_rxbuf_wrdata),
			
		.ack_rd_en(ack_rd_en),
		.pass_rd_en(pass_rd_en),
		.id_now(frame_id),
	
		.rx_data_valid(rx_data_valid),
		.rx_data(rx_data)
	);

	rx_ram_con rx_ram_con(
		.sys_clk(sys_clk),
		.glbl_rst_n(glbl_rst_n),

		.card_id(card_id),
		.init_done(init_done),

		.rx_data_valid(rx_data_valid),
		.rx_data(rx_data),
		
		.got_frame(got_frame),
		.frame_id(frame_id),
		.frame_type(frame_type),
		.sn_error(sn_error),
		
//		.ack_tx_en(ack_tx_en),
		.id_now(id_now),
			
		.ack_rd_en(ack_rd_en),
		.pass_rd_en(pass_rd_en),
		
		.rx_buff_rden(rx_buff_rden),
		.rx_buff_rdaddr(rx_buff_rdaddr),
		.rx_buff_rddata(rx_buff_rddata),
		.rx_crc_rslt(rx_crc_rslt),
		.rx_start(rx_start),
		.rx_done(rx_done)
	);

endmodule 
