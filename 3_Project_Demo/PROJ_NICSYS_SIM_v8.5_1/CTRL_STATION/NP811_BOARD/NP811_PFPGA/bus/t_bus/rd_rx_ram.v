`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:11:57 04/15/2016 
// Design Name: 
// Module Name:    rd_rx_ram 
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
module rd_rx_ram(
	sys_clk,
	glbl_rst_n,

	rx_data_valid,
	rx_data,
	
	got_frame,
	frame_id,
	frame_type,
	frame_sn,
	
	rx_buff_rden,
	rx_buff_rdaddr,
	rx_buff_rddata,
	
	load_rd_en,
	ack_rd_en,
	pass_rd_en
);

   input sys_clk;
	input glbl_rst_n;
	
	output reg rx_data_valid;
	output [7:0]rx_data;
		
	output reg got_frame;
	output reg [7:0]frame_id;
	output reg [7:0]frame_type;
	output reg [15:0]frame_sn;
	
	output reg rx_buff_rden;
	output reg [10:0]rx_buff_rdaddr;
	input [7:0]rx_buff_rddata;
	
	input load_rd_en;
	input ack_rd_en;
	input pass_rd_en;

	parameter l_bus = 1'b1;
	
	parameter idle 	= 4'd1;
	parameter load 	= 4'd2;
	parameter ack		= 4'd3;
	parameter pass 	= 4'd4;
	
	reg data_valid_reg;
	reg [10:0]rd_cnt;
	reg [3:0]state;

	assign rx_data = rx_buff_rddata;

	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				got_frame <= 0;
				frame_id <= 0;
				frame_type <= 0;
				frame_sn <= 0;
				rx_buff_rden <= 0;
				rx_buff_rdaddr <= 0;
				rd_cnt <= 0;
				state <= idle;
			end
		else
			case(state)
				idle	:	begin
								got_frame <= 0;
								if(load_rd_en)	begin state <= load; rx_buff_rden <= 1; rx_buff_rdaddr <= 0; rd_cnt <= 0;end
								if(ack_rd_en)	begin state <= ack;	rx_buff_rden <= 1; rx_buff_rdaddr <= 2; rd_cnt <= 0;end
								if(pass_rd_en)	begin state <= pass;	rx_buff_rden <= 1; rx_buff_rdaddr <= 4; rd_cnt <= 0;end
							end
				load	:	begin
								rx_buff_rdaddr <= rx_buff_rdaddr + 1'b1;
								rd_cnt <= rd_cnt + 1'b1; 
								if(rd_cnt == 11'd2) frame_id <= rx_buff_rddata;
								if(rd_cnt == 11'd3) frame_type <= rx_buff_rddata;
								if(rd_cnt == 11'd4) frame_sn[15:8] <= rx_buff_rddata;
								if(rd_cnt == 11'd5) 
									begin
										frame_sn[7:0] <= rx_buff_rddata;
										got_frame <= 1;
										rx_buff_rdaddr <= 0;
										state <= idle; 
										rx_buff_rden <= 0;
									end
							end
				ack	:	begin
								rx_buff_rdaddr <= rx_buff_rdaddr + 1'b1;
								rd_cnt <= rd_cnt + 1'b1;
								if(rd_cnt == 11'd15)
									begin
										rx_buff_rden <= 0;
										rx_buff_rdaddr <= 0;
										state <= idle; 
									end
							end
				pass	:	begin
								rx_buff_rdaddr <= rx_buff_rdaddr + 1'b1;
								rd_cnt <= rd_cnt + 1'b1;
								if(l_bus == 1)
									begin
										if(rd_cnt == 11'd63)
											begin
												rx_buff_rdaddr <= 0;
												rx_buff_rden <= 0;
												state <= idle; 
											end
									end
								else
									begin
										if(rd_cnt == 11'd1023)
											begin
												rx_buff_rden <= 0;
												rx_buff_rdaddr <= 0;
												state <= idle; 
											end
									end
							end
				default	:	state <= idle;
			endcase
			

	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				data_valid_reg <= 0;
				rx_data_valid <= 0;
			end
		else
			begin
				data_valid_reg <= rx_buff_rden;
				rx_data_valid <= data_valid_reg;
			end

endmodule
