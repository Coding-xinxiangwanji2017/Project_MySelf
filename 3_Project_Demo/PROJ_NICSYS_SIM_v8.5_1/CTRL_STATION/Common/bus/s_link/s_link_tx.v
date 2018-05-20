//`include "s_link_tx_head"

module s_link_tx(
		
	input clk,															//系统时钟
	input rst,															//系统复位，高有效
	
	input [3:0] i_slot_id,									//板卡号，该模块用来区分主备控制卡
	input i_join_start,											//指示该板卡是加入还是启动的令牌环
	input i_console_en,											//同步数据搬运使能
	input i_ini_dvalid,											//初始化输出数据有效信号
	input [7:0] i_ini_data,									//初始化输出数据
	input i_got_frame,											//接收到一个帧
	input [7:0] i_cmd_frame,								//接收帧的CMD
	output [1:0] o_trans_rslt,						//本次数据传输的结果：2'b10正确，其余错误
	
	output o_sl_txbuf_rden,							//读数据发送缓存区接口
	output [10:0] o_sl_txbuf_raddr,	
	input [7:0] i_sl_txbuf_rdata,	
	
	output o_tx_start,									//与链路层发送模块的接口
	output [10:0] o_tx_data_len,
	output o_txbuf_wren,
	output [10:0] o_txbuf_waddr,
	output [7:0] o_txbuf_wdata
	
	);

	wire tx_en;
	wire [7:0] tx_cmd;
	wire [15:0] tx_addr;


	dia_ctrl dia_ctrl_host(
	
	.clk(clk),
	.rst(rst),
	
	.i_slot_id(i_slot_id),
	.i_join_start(i_join_start),
	.i_console_en(i_console_en),
	.i_got_frame(i_got_frame),
	.i_cmd_frame(i_cmd_frame),
	.o_trans_rslt(o_trans_rslt),
	
	.o_tx_en(tx_en),
	.o_tx_cmd(tx_cmd),
	.o_tx_addr(tx_addr)
	);

	tx_ctrl tx_ctrl(
	
	.clk(clk),
	.rst(rst),
	
	.i_ini_dvalid(i_ini_dvalid),
	.i_ini_data(i_ini_data),
	.i_tx_en(tx_en),
	.i_tx_addr(tx_addr),
	.i_tx_cmd(tx_cmd),
	
	.o_sl_txbuf_rden(o_sl_txbuf_rden),
	.o_sl_txbuf_raddr(o_sl_txbuf_raddr),	
	.i_sl_txbuf_rdata(i_sl_txbuf_rdata),
	
	.o_tx_start(o_tx_start),
	.o_tx_data_len(o_tx_data_len),
	.o_txbuf_wren(o_txbuf_wren),
	.o_txbuf_waddr(o_txbuf_waddr),
	.o_txbuf_wdata(o_txbuf_wdata)

);




















endmodule