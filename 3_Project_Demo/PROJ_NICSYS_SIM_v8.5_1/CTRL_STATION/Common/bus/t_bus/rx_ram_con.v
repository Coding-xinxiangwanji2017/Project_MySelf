`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:54:08 04/15/2016 
// Design Name: 
// Module Name:    rx_ram_con 
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
module rx_ram_con(
	sys_clk,
	glbl_rst_n,

	card_id,
	init_done,

	rx_data_valid,
	rx_data,
	
	got_frame,
	frame_id,
	frame_type,
	
	sn_error,
//	ack_tx_en,
	id_now,
	
	rx_buff_rden,
	rx_buff_rdaddr,
	rx_buff_rddata,
	rx_crc_rslt,
	rx_start,
	rx_done,
	
	ack_rd_en,
	pass_rd_en
);

   input sys_clk;
	input glbl_rst_n;
	
	input [7:0]card_id;
	input init_done;	
	
	output rx_data_valid;
	output [7:0]rx_data;
	
	output got_frame;
	output [7:0]frame_id;
	output [7:0]frame_type;
	
	output sn_error;
//	input ack_tx_en;
	input [7:0]id_now;

	output rx_buff_rden;
	output [10:0]rx_buff_rdaddr;
	input [7:0]rx_buff_rddata;
	input rx_crc_rslt;
	input rx_start;
	input rx_done;
	
	output ack_rd_en;
	output pass_rd_en;

	wire [15:0]frame_sn;
	wire load_rd_en;

	rd_rx_ram rd_rx_ram(
		.sys_clk(sys_clk),
		.glbl_rst_n(glbl_rst_n),

		.rx_data_valid(rx_data_valid),
		.rx_data(rx_data),
		
		.got_frame(got_frame),
		.frame_id(frame_id),
		.frame_type(frame_type),
		.frame_sn(frame_sn),
		
		.rx_buff_rden(rx_buff_rden),
		.rx_buff_rdaddr(rx_buff_rdaddr),
		.rx_buff_rddata(rx_buff_rddata),
	
		.load_rd_en(load_rd_en),
		.ack_rd_en(ack_rd_en),
		.pass_rd_en(pass_rd_en)
	);

	sn_con sn_con(
		.sys_clk(sys_clk),
		.glbl_rst_n(glbl_rst_n),
		
		.sn_error(sn_error),
//		.ack_tx_en(ack_tx_en),
		.id_now(id_now), 
		
		.got_frame(got_frame),
		.frame_id(frame_id),
		.frame_type(frame_type),
		.frame_sn(frame_sn),

		.card_id(card_id),
		.init_done(init_done)
	);

	rx_con_fsm rx_con_fsm(
		.sys_clk(sys_clk),
		.glbl_rst_n(glbl_rst_n),

		.rx_crc_rslt(rx_crc_rslt),
		.rx_start(rx_start),
		.rx_done(rx_done),
		
		.load_rd_en(load_rd_en),
		.ack_rd_en(ack_rd_en),
		.pass_rd_en(pass_rd_en),
		
		.got_frame(got_frame),
		.frame_id(frame_id),
		.frame_type(frame_type),
		
		.sn_error(sn_error),
		
		.card_id(card_id),
		.init_done(init_done)
	);

endmodule
