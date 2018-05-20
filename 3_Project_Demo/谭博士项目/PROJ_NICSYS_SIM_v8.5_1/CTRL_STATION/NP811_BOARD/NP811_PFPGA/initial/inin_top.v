`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:34:22 04/18/2016 
// Design Name: 
// Module Name:    inin_top 
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
module inin_top(
	input					sys_clk,
	input					fram_clk,
	input					glbl_rst_n,
	
	input					init_start,
	output 				init_ok,
	output 				init_fail,
	
	output	[15:0]	init_check_en,
	input 	[15:0]	init_check_done,
	input 	[15:0]	init_check_error,
	
	output 				init_fram_rden,
	output 	[10:0]	init_fram_length,
	output 	[15:0]	init_fram_addr,
	input 				init_fram_valid,
	input 				init_fram_last,
	input 	[7:0]		init_fram_data,
	
	output 				init_afpga_rden,
	output 				init_afpga_wren,
	output 	[22:0]	init_afpga_addr,
	input 	[7:0]		init_afpga_rdata,
	output 	[7:0]		init_afpga_wdata,
	
	output 				init_cons_wren,
	output 	[15:0]	init_cons_addr,
	output 	[7:0]		init_cons_data,
	output 	[191:0]	init_cons_para,
	
	output 				init_flash_rden,
	output 	[23:0]	init_flash_length,
	output 	[24:0]	init_flash_addr,
	input 				init_flash_valid,
	input 				init_flash_last,
	input 	[7:0]		init_flash_data,
	
	output 				init_sram_wr_start,
	output 				init_sram_wr_done,
	output 				init_xfer_wren,
	output 	[17:0]	init_xfer_addr,
	output 	[7:0]		init_xfer_data,
	output 	[95:0]	init_xfer_para,
	
	output 				init_card_wren,
	output 	[9:0]		init_card_addr,	
	output 	[7:0]		init_card_data,
	
	output 				init_dfpga_wren,
	output 				init_dfpga_wrdone,
	input 				init_dfpga_wrready,
	output 				init_dfpga_rden,
	output 	[19:0]	init_dfpga_addr,
	input 	[7:0]		init_dfpga_data,
	
                                  
	input    [7:0]  	im_station     ,
	input    [3:0]  	im_rack        ,
	input    [4:0]  	im_slot        ,
	output         	o_idread_finish,
	output         	o_station_err  ,
	output  [6:0]  	station_id  ,	
	output         	o_rack_err     ,
	output  [2:0]  	rack_id     ,
	output         	o_slot_err     ,
	output  [3:0]  	slot_id     
);

	wire	 				check_ram_en;
	wire					check_ram_done;
	wire					check_ram_error;
	wire	 				load_ram_en;
	wire					load_ram_done;
	wire					load_ram_error;
	wire	 				comp_crc_en;
	wire					comp_crc_done;
	wire					comp_crc_error;
	wire	 				rd_id_en;
	wire					rd_id_done;
	wire					rd_id_error;
	wire 		[287:0]	load_ram_crc;

	inin_fsm inin_fsm (
		.sys_clk(sys_clk), 
		.glbl_rst_n(glbl_rst_n), 
		.init_start(init_start), 
		.init_ok(init_ok), 
		.init_fail(init_fail), 
		.check_ram_en(check_ram_en), 
		.check_ram_done(check_ram_done), 
		.check_ram_error(check_ram_error), 
		.load_ram_en(load_ram_en), 
		.load_ram_done(load_ram_done), 
		.load_ram_error(load_ram_error), 
		.comp_crc_en(comp_crc_en), 
		.comp_crc_done(1'b1), /////////////////////////
		.comp_crc_error(comp_crc_error), 
		.rd_id_en(rd_id_en), 
		.rd_id_done(rd_id_done), 
		.rd_id_error(rd_id_error)
	);

	init_check_ram init_check_ram (
		.sys_clk(sys_clk), 
		.glbl_rst_n(glbl_rst_n), 
		.check_ram_en(check_ram_en), 
		.check_ram_done(check_ram_done), 
		.check_ram_error(check_ram_error), 
		.init_check_en(init_check_en), 
		.init_check_done(init_check_done), 
		.init_check_error(init_check_error)
	);
	
	init_load_ram init_load_ram (
		.sys_clk(sys_clk), 
		.fram_clk(fram_clk), 
		.glbl_rst_n(glbl_rst_n),
		
		.load_ram_en(load_ram_en), 
		.load_ram_done(load_ram_done), 
		.load_ram_error(load_ram_error), 
		.init_ok(init_ok), 
		
		.init_fram_rden(init_fram_rden),
		.init_fram_length(init_fram_length),
		.init_fram_addr(init_fram_addr),
		.init_fram_valid(init_fram_valid),
		.init_fram_last(init_fram_last),
		.init_fram_data(init_fram_data),
		
		.init_afpga_rden(init_afpga_rden), 
		.init_afpga_wren(init_afpga_wren), 
		.init_afpga_addr(init_afpga_addr), 
		.init_afpga_rdata(init_afpga_rdata), 
		.init_afpga_wdata(init_afpga_wdata), 
		
		.init_cons_wren(init_cons_wren), 
		.init_cons_addr(init_cons_addr), 
		.init_cons_data(init_cons_data), 
		.init_cons_para(init_cons_para), 
		.init_flash_rden(init_flash_rden), 
		.init_flash_length(init_flash_length), 
		.init_flash_addr(init_flash_addr), 
		.init_flash_valid(init_flash_valid), 
		.init_flash_last(init_flash_last), 
		.init_flash_data(init_flash_data),

		.init_sram_wr_start(init_sram_wr_start),
		.init_sram_wr_done(init_sram_wr_done),

		
		.init_xfer_wren(init_xfer_wren), 
		.init_xfer_addr(init_xfer_addr), 
		.init_xfer_data(init_xfer_data), 
		.init_xfer_para(init_xfer_para), 
		.init_card_wren(init_card_wren), 
		.init_card_addr(init_card_addr), 
		.init_card_data(init_card_data),
		.load_ram_crc(load_ram_crc)
	);
	
	id_read id_read (
		.rst_n(glbl_rst_n), 
		.clk(sys_clk), 
		.im_station(im_station), 
		.im_rack(im_rack), 
		.im_slot(im_slot), 
		.o_idread_finish(o_idread_finish), 
		.rd_id_done(rd_id_done), 
		.rd_id_error(rd_id_error), 
		.o_station_err(o_station_err), 
		.station_id(station_id), 
		.o_rack_err(o_rack_err), 
		.rack_id(rack_id), 
		.o_slot_err(o_slot_err), 
		.slot_id(slot_id)
	);
	 
endmodule
