`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:47:15 04/19/2016 
// Design Name: 
// Module Name:    init_load_ram 
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
module aio_init_load_ram(
	input					sys_clk,
	input					glbl_rst_n,
	
	input 				load_ram_en,
	output				load_ram_done,
	output				load_ram_error,
	
	output 				init_eep_rden,
	output 	[16:0]	init_eep_length,
	output 	[15:0]	init_eep_addr,
	input 				init_eep_valid,
	input 				init_eep_last,
	input 	[7:0]		init_eep_data,
	
	output 				init_cons_wren,
	output 	[15:0]	init_cons_addr,
	output 	[7:0]		init_cons_data,
	
	output 				init_chram_wren,
	output 	[11:0]	init_chram_addr,	
	output 	[7:0]		init_chram_data,
	
	output 	[63:0]	load_ram_crc
);
 
	wire 					load_cons_en;
	wire					load_cons_done;
	wire					load_cons_error;	
	 
	wire 					load_chram_en;
	wire					load_chram_done;
	wire					load_chram_error;
 
 	wire 					cons_eep_rden;
	wire 	[16:0]		cons_eep_length;
	wire 	[15:0]		cons_eep_addr;
 	
	wire 					chram_eep_rden;
	wire 	[16:0]		chram_eep_length;
	wire 	[15:0]		chram_eep_addr;
	
	assign init_eep_rden = cons_eep_rden | chram_eep_rden;
	assign init_eep_length = cons_eep_length | chram_eep_length;
	assign init_eep_addr = cons_eep_addr | chram_eep_addr;
	
	aio_load_fsm aio_load_fsm (
		.sys_clk(sys_clk), 
		.glbl_rst_n(glbl_rst_n), 
		.load_ram_en(load_ram_en), 
		.load_ram_done(load_ram_done),// 
		.load_ram_error(load_ram_error), 
		.load_cons_en(load_cons_en), 
		.load_cons_done(1'b1),//load_cons_done///////////////////////////////////////// 
		.load_cons_error(load_cons_error), 
		.load_chram_en(load_chram_en), 
		.load_chram_done(load_chram_done), //1'b1
		.load_chram_error(load_chram_error)
	);	
	
	aio_load_cons aio_load_cons (
		.sys_clk(sys_clk), 
		.glbl_rst_n(glbl_rst_n), 
		.load_cons_en(1'b0),//load_cons_en///////////////////////////////////////////// 
		.load_cons_done(load_cons_done), 
		.load_cons_error(load_cons_error), 
		.cons_eep_rden(cons_eep_rden), 
		.cons_eep_length(cons_eep_length), 
		.cons_eep_addr(cons_eep_addr), 
		.init_eep_valid(init_eep_valid), 
		.init_eep_last(init_eep_last), 
		.init_eep_data(init_eep_data), 
		.init_cons_wren(init_cons_wren), 
		.init_cons_addr(init_cons_addr), 
		.init_cons_data(init_cons_data)
	);
	
	aio_load_chram aio_load_chram (
		.sys_clk(sys_clk), 
		.glbl_rst_n(glbl_rst_n), 
		.load_chram_en(load_chram_en), //1'b0
		.load_chram_done(load_chram_done), 
		.load_chram_error(load_chram_error), 
		.chram_eep_rden(chram_eep_rden), 
		.chram_eep_length(chram_eep_length), 
		.chram_eep_addr(chram_eep_addr), 
		.init_eep_valid(init_eep_valid), 
		.init_eep_last(init_eep_last), 
		.init_eep_data(init_eep_data), 
		.init_chram_wren(init_chram_wren), 
		.init_chram_addr(init_chram_addr), 
		.init_chram_wdata(init_chram_data)
	); 
 
endmodule
