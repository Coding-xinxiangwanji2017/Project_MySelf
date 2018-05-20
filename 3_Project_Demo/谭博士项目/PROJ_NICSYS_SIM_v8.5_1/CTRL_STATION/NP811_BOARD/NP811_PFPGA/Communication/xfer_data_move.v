`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:44:05 04/20/2016 
// Design Name: 
// Module Name:    xfer_data_move 
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
module xfer_data_move(
    input  wire         sys_clk_50m      ,
    input  wire         sys_rst_n        ,	

    input  wire         xfer_in_en       ,	
    input  wire         xfer_out_en      ,	
    input  wire         xnet_en          ,	
	 
    input  wire         init_ok          ,
    input  wire [95:00] init_xfer_para   ,
	 
    output wire         xfer_buf_rden    ,	
    output wire [17:00] xfer_buf_addr    ,	
    input  wire [07:00] xfer_buf_data    ,
	 
    output wire         xfer_afpga_wren  ,	
    output wire         xfer_afpga_rden  ,	
    output wire [22:00] xfer_afpga_addr  ,	
    output wire [07:00] xfer_afpga_wdata ,	
    input  wire [07:00] xfer_afpga_rdata ,
	 
    output wire         xfer_cons_wren   ,	
    output wire         xfer_cons_rden   ,	
    output wire [17:00] xfer_cons_addr   ,	
    output wire [07:00] xfer_cons_wdata  ,	
    input  wire [07:00] xfer_cons_rdata  ,
	 		
    output wire [11:00] lb_rx_raddr  	  ,	
    input  wire [07:00] lb_rx_rdata 	  ,	
    output wire [14:00] cb_rx_raddr  	  ,	
    input  wire [07:00] cb_rx_rdata 	  ,	
    output wire [14:00] rb_rx_raddr  	  ,	
    input  wire [07:00] rb_rx_rdata 	  ,
	 
    output wire         lb_tx_wren       ,	
    output wire [10:00] lb_tx_waddr  	  ,	
    output wire [07:00] lb_tx_wdata 	  ,
    output wire         cb_tx_wren       ,	
    output wire [14:00] cb_tx_waddr  	  ,	
    output wire [07:00] cb_tx_wdata 	  ,
    output wire         rb_tx_wren       ,	
    output wire [14:00] rb_tx_waddr  	  ,	
    output wire [07:00] rb_tx_wdata 	  
);

    wire  [17:00] xfer_in_addr  	  ;
    wire  [17:00] xfer_in_length	  ;
    wire  [17:00] xfer_out_addr    ;
    wire  [17:00] xfer_out_length  ;
    wire  [17:00] xnet_addr  	     ;
    wire  [17:00] xnet_length	     ;
		     
    wire          byte6_valid      ;   
    wire  [47:00] byte6_data       ;   
    wire          move_done        ;   

	addr_gnen addr_gnen (       
		.sys_clk_50m(sys_clk_50m), 
		.sys_rst_n(sys_rst_n), 
		.init_ok(init_ok), 
		.init_xfer_para(init_xfer_para), 
		.xfer_in_addr(xfer_in_addr), 
		.xfer_in_length(xfer_in_length), 
		.xfer_out_addr(xfer_out_addr), 
		.xfer_out_length(xfer_out_length), 
		.xnet_addr(xnet_addr), 
		.xnet_length(xnet_length)
	);

	move_con move_con (
		.sys_clk_50m(sys_clk_50m), 
		.sys_rst_n(sys_rst_n), 
		.xfer_in_en(xfer_in_en), 
		.xfer_out_en(xfer_out_en), 
		.xnet_en(xnet_en), 
		.xfer_buf_rden(xfer_buf_rden), 
		.xfer_buf_addr(xfer_buf_addr), 
		.xfer_buf_data(xfer_buf_data), 
		.xfer_in_addr(xfer_in_addr), 
		.xfer_in_length(xfer_in_length), 
		.xfer_out_addr(xfer_out_addr), 
		.xfer_out_length(xfer_out_length), 
		.xnet_addr(xnet_addr), 
		.xnet_length(xnet_length), 
		.byte6_valid(byte6_valid), 
		.byte6_data(byte6_data), 
		.move_done(move_done)
	);

	data_move data_move (
		.sys_clk_50m(sys_clk_50m), 
		.sys_rst_n(sys_rst_n), 
		.xfer_afpga_wren(xfer_afpga_wren), 
		.xfer_afpga_rden(xfer_afpga_rden), 
		.xfer_afpga_addr(xfer_afpga_addr), 
		.xfer_afpga_wdata(xfer_afpga_wdata), 
		.xfer_afpga_rdata(xfer_afpga_rdata), 
		.xfer_cons_wren(xfer_cons_wren), 
		.xfer_cons_rden(xfer_cons_rden), 
		.xfer_cons_addr(xfer_cons_addr), 
		.xfer_cons_wdata(xfer_cons_wdata), 
		.xfer_cons_rdata(xfer_cons_rdata), 
		.lb_rx_raddr(lb_rx_raddr), 
		.lb_rx_rdata(lb_rx_rdata), 
		.cb_rx_raddr(cb_rx_raddr), 
		.cb_rx_rdata(cb_rx_rdata), 
		.rb_rx_raddr(rb_rx_raddr), 
		.rb_rx_rdata(rb_rx_rdata), 
		.lb_tx_wren(lb_tx_wren), 
		.lb_tx_waddr(lb_tx_waddr), 
		.lb_tx_wdata(lb_tx_wdata), 
		.cb_tx_wren(cb_tx_wren), 
		.cb_tx_waddr(cb_tx_waddr), 
		.cb_tx_wdata(cb_tx_wdata), 
		.rb_tx_wren(rb_tx_wren), 
		.rb_tx_waddr(rb_tx_waddr), 
		.rb_tx_wdata(rb_tx_wdata), 
		.byte6_valid(byte6_valid), 
		.byte6_data(byte6_data), 
		.move_done(move_done)
	);	

endmodule
