//`include "s_link_tx_head"

module s_link_tx(
		
	input clk,															//ϵͳʱ��
	input rst,															//ϵͳ��λ������Ч
	
	input [3:0] i_slot_id,									//�忨�ţ���ģ�����������������ƿ�
	input i_join_start,											//ָʾ�ð忨�Ǽ��뻹�����������ƻ�
	input i_console_en,											//ͬ�����ݰ���ʹ��
	input i_ini_dvalid,											//��ʼ�����������Ч�ź�
	input [7:0] i_ini_data,									//��ʼ���������
	input i_got_frame,											//���յ�һ��֡
	input [7:0] i_cmd_frame,								//����֡��CMD
	output [1:0] o_trans_rslt,						//�������ݴ���Ľ����2'b10��ȷ���������
	
	output o_sl_txbuf_rden,							//�����ݷ��ͻ������ӿ�
	output [10:0] o_sl_txbuf_raddr,	
	input [7:0] i_sl_txbuf_rdata,	
	
	output o_tx_start,									//����·�㷢��ģ��Ľӿ�
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