`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:05:32 04/11/2016 
// Design Name: 
// Module Name:    token 
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
module token(
	sys_clk,
	glbl_rst_n,
	start_token,
	got_frame,
	frame_id,
	frame_type,
	ack_tx_en,
	lb_pass_tx_en,
	cb_pass_tx_en,
	rb_pass_tx_en,
	id_now,
	id_check_rslt_en,
	id_check_rslt,
	token_run,
	token_stop
);

	input sys_clk;
	input glbl_rst_n;
	input start_token;
	input got_frame;
	input [7:0]frame_id;
	input [7:0]frame_type;
	
	output reg ack_tx_en;
	output reg lb_pass_tx_en;
	output reg cb_pass_tx_en;
	output reg rb_pass_tx_en;
	output reg [7:0]id_now;
	output reg id_check_rslt_en;
	output reg [1:0]id_check_rslt;
	output reg token_run;
	output reg token_stop;

	parameter offset 			= 	14'd20;//偏移窗口大小
	parameter slot 			= 	14'd10416;//一个时隙的周期数
	parameter ack_time 	 	= 	14'd1;//发送ack帧的时间
	parameter ack_rx_time 	= 	14'h0485;//理论接受到ack帧的时间ack_rx_time-ack_time='d1148
	parameter lpass_time 	= 	14'h103a;//发送l_bus的pass帧时间
	parameter cpass_time 	= 	14'h68f;//发送c_bus的pass帧时间
	parameter rpass_time 	= 	14'h68f;//发送r_bus的pass帧时间
	parameter pass_rx_time 	= 	14'h1cb7;//理论接受l_bus的pass帧时间pass_rx_time-lpass_time='d3197
	
	parameter ack_type 		= 	8'h32;//ack帧类型
	parameter pass_type 		= 	8'h51;//pass帧类型
	parameter id_rslt_ok 	= 	2'b01;//pass帧类型
	parameter id_rslt_no 	= 	2'b10;//pass帧类型
	
	localparam idle 	= 	2'b00;
	localparam run 	= 	2'b01;
	localparam error 	= 	2'b10;

	reg [1:0]state;
	reg [13:0]cnt_slot;
	reg [1:0]error_cnt;
	
	reg [7:0]ack_tx_id;
	reg [7:0]lpass_tx_id;
	reg [7:0]rpass_tx_id;
	reg [7:0]cpass_tx_id;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				state <= idle;
				cnt_slot <= 0;
				error_cnt <= 0;
				id_now <= 0;
				id_check_rslt_en <= 0;
				id_check_rslt <= 0;
				token_run <= 0;
				token_stop <= 0;
			end
		else
			case(state)
				idle	:	if(got_frame == 1)
								begin
									if(frame_type == ack_type)
										begin
											state <= run;
											id_now <= frame_id;
											cnt_slot <= ack_rx_time;
											token_run <= 1;
										end
									if(frame_type == pass_type)
										begin
											state <= run;
											id_now <= frame_id;
											cnt_slot <= pass_rx_time;
											token_run <= 1;
										end
								end
							else
								if(start_token == 1)
									state <= run;
									
				run	:	if(cnt_slot == slot)
								begin
									cnt_slot <= 14'd0;
									if(id_now == 7'd71)
										id_now <= 8'd0;
									else
										id_now <= id_now + 8'd1;
								end
							else
								if(got_frame == 1)
									if(id_now == frame_id)
										begin
											id_check_rslt <= id_rslt_ok;
											id_check_rslt_en <= 1'b1;
											if(frame_type == ack_type)
												if(cnt_slot >= ack_rx_time - offset && cnt_slot <= ack_rx_time + offset)
													begin
														cnt_slot <= ack_rx_time;
														error_cnt <= 2'd0;
													end
												else
													begin
														cnt_slot <= ack_rx_time;
														error_cnt <= error_cnt + 2'd01;
													end
											if(frame_type == pass_type)
												if(cnt_slot >= pass_rx_time - offset && cnt_slot <= pass_rx_time + offset)
													begin
														cnt_slot <= pass_rx_time;
														error_cnt <= 2'd0;
													end
												else
													begin
														cnt_slot <= ack_rx_time;
														error_cnt <= error_cnt + 2'd01;
													end
										end
									else
										begin
											id_check_rslt <= id_rslt_no;
											id_check_rslt_en <= 1'b1;
											error_cnt <= error_cnt + 2'd01;
										end
								else
									begin
										cnt_slot <= cnt_slot + 14'd1;
										id_check_rslt_en <= 1'b0;
										id_check_rslt <= 0;
										if(error_cnt == 2'd3) state <= error;
									end
									
				error	:	begin
								cnt_slot <= 0;
								error_cnt <= 0;
								id_now <= 0;
								id_check_rslt_en <= 0;
								id_check_rslt <= 0;
								token_stop <= 1;
							end
				default	:	state <= idle; 
			endcase
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				ack_tx_en <= 0;
				lb_pass_tx_en <= 0;
				cb_pass_tx_en <= 0; 
				rb_pass_tx_en <= 0;
				ack_tx_id <= 8'd73;
				lpass_tx_id <= 8'd73;
				rpass_tx_id <= 8'd73;
				cpass_tx_id <= 8'd73;
			end
		else
			begin
				if(cnt_slot == ack_time && id_now != ack_tx_id)
					begin
						ack_tx_en <= 1;
						ack_tx_id <= id_now;
					end
				else
					ack_tx_en <= 0;
					
				if(cnt_slot == lpass_time && id_now != lpass_tx_id)
					begin
						lb_pass_tx_en <= 1;
						lpass_tx_id <= id_now;
					end
				else
					lb_pass_tx_en <= 0;
					
				if(cnt_slot == cpass_time && id_now != cpass_tx_id)
					begin
						cb_pass_tx_en <= 1;
						cpass_tx_id <= id_now;
					end
				else
					cb_pass_tx_en <= 0;
					
				if(cnt_slot == rpass_time && id_now != rpass_tx_id)
					begin
						rb_pass_tx_en <= 1;
						rpass_tx_id <= id_now;
					end
				else
					rb_pass_tx_en <= 0;
			end
			
endmodule
