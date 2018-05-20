`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:27:28 04/15/2016 
// Design Name: 
// Module Name:    rx_con_fsm 
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
module rx_con_fsm(
	sys_clk,
	glbl_rst_n,

	rx_crc_rslt,
	rx_start,
	rx_done,
	
	load_rd_en,
	ack_rd_en,
	pass_rd_en,
	
	got_frame,
	frame_id,
	frame_type,
	
	sn_error,
	
	card_id,
	init_done
);

   input sys_clk;
	input glbl_rst_n;
	
	input rx_crc_rslt;
	input rx_start;
	input rx_done;
	
	output reg load_rd_en;
	output reg ack_rd_en;
	output reg pass_rd_en;

	input got_frame;
	input [7:0]frame_id;
	input [7:0]frame_type;
	
	input sn_error;
	
	input [7:0]card_id;
	input init_done;

	parameter l_bus = 1'b1;
	parameter ack_type 		= 	8'h32;//ack帧类型
	parameter pass_type 		= 	8'h51;//pass帧类型
	
	parameter init 	= 4'd4;
	parameter idle 	= 4'd1;
	parameter wait0 	= 4'd2;
	parameter sn_ac	= 4'd3;
	parameter sn_pa 	= 4'd5;
	
	reg [7:0]max_id;
	reg [7:0]min_id;
	reg [7:0]max_id_cb;
	reg [7:0]min_id_cb;
	reg id_lb;
	reg id_cb;
	reg [3:0]state;
	reg [3:0]cnt;

	wire rx_done_ok;
	
	assign rx_done_ok = rx_done & rx_crc_rslt;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				load_rd_en <= 0;
				ack_rd_en <= 0;
				pass_rd_en <= 0;
				cnt <= 0;
				state <= init;
			end
		else
			case(state)
				init	:	if(init_done == 1)
								state <= idle;
							else
								state <= init;
				idle	:	begin
								cnt <= 0;
								pass_rd_en <= 0;
								ack_rd_en <= 0;
								if(rx_done_ok == 1)
									begin
										state <= wait0;
										load_rd_en <= 1;
									end
							end
				wait0	:	begin
								load_rd_en <= 0;
								if(got_frame == 1)
									begin
										if(id_lb == 1)
											begin
												if(frame_id == max_id || frame_id == min_id)
													begin
														if(frame_type == ack_type) state <= sn_ac; 
														if(frame_type == pass_type) state <= sn_pa;
													end
												else
													state <= idle;
											end
										else if(id_cb == 1)
											begin
												if((frame_id <= max_id && frame_id >= min_id) || (frame_id <= max_id_cb && min_id_cb >= min_id))
													begin
														if(frame_type == ack_type) state <= sn_ac; 
														if(frame_type == pass_type) state <= sn_pa;
													end
												else
													state <= idle;
											end
										else
											begin
												if(frame_id <= max_id && frame_id >= min_id)
													begin
														if(frame_type == ack_type) state <= sn_ac; 
														if(frame_type == pass_type) state <= sn_pa;
													end
												else
													state <= idle;
											end
									end
							end
				sn_ac	:	begin
								cnt <= cnt + 1'b1;
								if(sn_error == 1) state <= idle;
								if(cnt == 4'd3) 
									begin
										state <= idle;
										ack_rd_en <= 1;
									end
							end
				sn_pa	:	begin
								cnt <= cnt + 1'b1;
								if(sn_error == 1) state <= idle;
								if(cnt == 4'd3) 
									begin
										state <= idle;
										pass_rd_en <= 1;
									end
							end
				default	:	state <= idle; 
			endcase
			
	always @ (posedge sys_clk) 
		if(!glbl_rst_n)
			begin
				max_id <= 8'd0;
				min_id <= 8'd0;
				id_lb <= 0;
				id_cb <= 0;
			end
		else
			if(init_done == 1)
				case(card_id)
					8'd14	:	if(l_bus == 1)
									begin
										max_id <= 8'd71;
										min_id <= 8'd24;
									end
								else
									begin
										max_id <= 8'd71;
										min_id <= 8'd48;
									end
					8'd13	:	if(l_bus == 1)	
									begin
										max_id <= 8'd71;
										min_id <= 8'd24;
									end
								else
									begin
										max_id <= 8'd71;
										min_id <= 8'd48;
									end
					8'd12	:	begin
                      		max_id <= 8'd5;
									min_id <= 8'd0;
									max_id_cb <= 8'd29;
									min_id_cb <= 8'd24;
									id_cb <= 1;
					       	end
					8'd11	:	begin	
					       		max_id <= 8'd11;
									min_id <= 8'd6;
									max_id_cb <= 8'd35;
									min_id_cb <= 8'd30;
									id_cb <= 1;
					       	end
					8'd10	:	begin	
					       		max_id <= 8'd17;
									min_id <= 8'd12;
									max_id_cb <= 8'd41;
									min_id_cb <= 8'd36;
									id_cb <= 1;
					       	end
					8'd9	:	begin	
					       		max_id <= 8'd23;
									min_id <= 8'd18;
									max_id_cb <= 8'd47;
									min_id_cb <= 8'd42;
									id_cb <= 1;
					       	end
//					8'd8	:	begin	
//					       		max_id <= 8'd59;
//									min_id <= 8'd48;
//					       	end               				 /////环网卡的板卡id暂时不考虑
//					8'd7	:	begin	
//                      	max_id <= 8'd71;
//									min_id <= 8'd60;
//					       	end
					default	:	begin
										id_lb <= 1;
										max_id <= (((8'd14 & {8{card_id[4]}}) + (8'd28 & {8{card_id[5]}}) + 8'd6 - {4'd0,card_id[3:0]}) >> 2) + 8'd12;
										min_id <= ((8'd14 & {8{card_id[4]}}) + (8'd28 & {8{card_id[5]}}) + 8'd6 - {4'd0,card_id[3:0]}) >> 2;
									end
				endcase
			else
				begin
					max_id <= max_id;
					min_id <= min_id;
				end
			
endmodule
