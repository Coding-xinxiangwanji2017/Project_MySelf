`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:18:27 04/15/2016 
// Design Name: 
// Module Name:    sn_con 
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
module sn_con(
	sys_clk,
	glbl_rst_n,
	
	sn_error,
//	ack_tx_en,
	id_now, 
	
	got_frame,
	frame_id,
	frame_type,
	frame_sn,

	card_id,
	init_done
);

   input sys_clk;
	input glbl_rst_n;
	
	output reg sn_error;
//	input ack_tx_en;
	input [7:0]id_now; 

	input got_frame;
	input [7:0]frame_id;
	input [7:0]frame_type;
	input [15:0]frame_sn;
	
	input [7:0]card_id;
	input init_done;	

	parameter pass_type 		= 	8'h51;//pass÷°¿‡–Õ

	reg [15:0]sn_id[71:0];
	reg [71:0]sn_error_bus;

	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[0] <= 0;
				sn_error_bus[0] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd0)
				begin
					if(sn_id[0] == frame_sn) sn_error_bus[0] <= 1;
					else begin 	sn_error_bus[0] <= 0; end
					sn_id[0] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[1] <= 0;
				sn_error_bus[1] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd1)
				begin
					if(sn_id[1] == frame_sn) sn_error_bus[1] <= 1;
					else begin 	sn_error_bus[1] <= 0; end
					sn_id[1] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[2] <= 0;
				sn_error_bus[2] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd2)
				begin
					if(sn_id[2] == frame_sn) sn_error_bus[2] <= 1;
					else begin 	sn_error_bus[2] <= 0; end
					sn_id[2] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[3] <= 0;
				sn_error_bus[3] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd3)
				begin
					if(sn_id[3] == frame_sn) sn_error_bus[3] <= 1;
					else begin 	sn_error_bus[3] <= 0; end
					sn_id[3] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[4] <= 0;
				sn_error_bus[4] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd4)
				begin
					if(sn_id[4] == frame_sn) sn_error_bus[4] <= 1;
					else begin 	sn_error_bus[4] <= 0; end
					sn_id[4] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[5] <= 0;
				sn_error_bus[5] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd5)
				begin
					if(sn_id[5] == frame_sn) sn_error_bus[5] <= 1;
					else begin 	sn_error_bus[5] <= 0; end
					sn_id[5] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[6] <= 0;
				sn_error_bus[6] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd6)
				begin
					if(sn_id[6] == frame_sn) sn_error_bus[6] <= 1;
					else begin 	sn_error_bus[6] <= 0; end
					sn_id[6] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[7] <= 0;
				sn_error_bus[7] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd7)
				begin
					if(sn_id[7] == frame_sn) sn_error_bus[7] <= 1;
					else begin 	sn_error_bus[7] <= 0; end
					sn_id[7] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[8] <= 0;
				sn_error_bus[8] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd8)
				begin
					if(sn_id[8] == frame_sn) sn_error_bus[8] <= 1;
					else begin 	sn_error_bus[8] <= 0; end
					sn_id[8] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[9] <= 0;
				sn_error_bus[9] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd9)
				begin
					if(sn_id[9] == frame_sn) sn_error_bus[9] <= 1;
					else begin 	sn_error_bus[9] <= 0; end
					sn_id[9] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[10] <= 0;
				sn_error_bus[10] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd10)
				begin
					if(sn_id[10] == frame_sn) sn_error_bus[10] <= 1;
					else begin 	sn_error_bus[10] <= 0; end
					sn_id[10] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[11] <= 0;
				sn_error_bus[11] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd11)
				begin
					if(sn_id[11] == frame_sn) sn_error_bus[11] <= 1;
					else begin 	sn_error_bus[11] <= 0; end
					sn_id[11] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[12] <= 0;
				sn_error_bus[12] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd12)
				begin
					if(sn_id[12] == frame_sn) sn_error_bus[12] <= 1;
					else begin 	sn_error_bus[12] <= 0; end
					sn_id[12] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[13] <= 0;
				sn_error_bus[13] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd13)
				begin
					if(sn_id[13] == frame_sn) sn_error_bus[13] <= 1;
					else begin 	sn_error_bus[13] <= 0; end
					sn_id[13] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[14] <= 0;
				sn_error_bus[14] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd14)
				begin
					if(sn_id[14] == frame_sn) sn_error_bus[14] <= 1;
					else begin 	sn_error_bus[14] <= 0; end
					sn_id[14] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[15] <= 0;
				sn_error_bus[15] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd15)
				begin
					if(sn_id[15] == frame_sn) sn_error_bus[15] <= 1;
					else begin 	sn_error_bus[15] <= 0; end
					sn_id[15] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[16] <= 0;
				sn_error_bus[16] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd16)
				begin
					if(sn_id[16] == frame_sn) sn_error_bus[16] <= 1;
					else begin 	sn_error_bus[16] <= 0; end
					sn_id[16] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[17] <= 0;
				sn_error_bus[17] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd17)
				begin
					if(sn_id[17] == frame_sn) sn_error_bus[17] <= 1;
					else begin 	sn_error_bus[17] <= 0; end
					sn_id[17] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[18] <= 0;
				sn_error_bus[18] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd18)
				begin
					if(sn_id[18] == frame_sn) sn_error_bus[18] <= 1;
					else begin 	sn_error_bus[18] <= 0; end
					sn_id[18] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[19] <= 0;
				sn_error_bus[19] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd19)
				begin
					if(sn_id[19] == frame_sn) sn_error_bus[19] <= 1;
					else begin 	sn_error_bus[19] <= 0; end
					sn_id[19] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[20] <= 0;
				sn_error_bus[20] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd20)
				begin
					if(sn_id[20] == frame_sn) sn_error_bus[20] <= 1;
					else begin 	sn_error_bus[20] <= 0; end
					sn_id[20] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[21] <= 0;
				sn_error_bus[21] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd21)
				begin
					if(sn_id[21] == frame_sn) sn_error_bus[21] <= 1;
					else begin 	sn_error_bus[21] <= 0; end
					sn_id[21] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[22] <= 0;
				sn_error_bus[22] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd22)
				begin
					if(sn_id[22] == frame_sn) sn_error_bus[22] <= 1;
					else begin 	sn_error_bus[22] <= 0; end
					sn_id[22] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[23] <= 0;
				sn_error_bus[23] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd23)
				begin
					if(sn_id[23] == frame_sn) sn_error_bus[23] <= 1;
					else begin 	sn_error_bus[23] <= 0; end
					sn_id[23] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[24] <= 0;
				sn_error_bus[24] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd24)
				begin
					if(sn_id[24] == frame_sn) sn_error_bus[24] <= 1;
					else begin 	sn_error_bus[24] <= 0; end
					sn_id[24] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[25] <= 0;
				sn_error_bus[25] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd25)
				begin
					if(sn_id[25] == frame_sn) sn_error_bus[25] <= 1;
					else begin 	sn_error_bus[25] <= 0; end
					sn_id[25] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[26] <= 0;
				sn_error_bus[26] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd26)
				begin
					if(sn_id[26] == frame_sn) sn_error_bus[26] <= 1;
					else begin 	sn_error_bus[26] <= 0; end
					sn_id[26] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[27] <= 0;
				sn_error_bus[27] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd27)
				begin
					if(sn_id[27] == frame_sn) sn_error_bus[27] <= 1;
					else begin 	sn_error_bus[27] <= 0; end
					sn_id[27] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[28] <= 0;
				sn_error_bus[28] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd28)
				begin
					if(sn_id[28] == frame_sn) sn_error_bus[28] <= 1;
					else begin 	sn_error_bus[28] <= 0; end
					sn_id[28] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[29] <= 0;
				sn_error_bus[29] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd29)
				begin
					if(sn_id[29] == frame_sn) sn_error_bus[29] <= 1;
					else begin 	sn_error_bus[29] <= 0; end
					sn_id[29] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[30] <= 0;
				sn_error_bus[30] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd30)
				begin
					if(sn_id[30] == frame_sn) sn_error_bus[30] <= 1;
					else begin 	sn_error_bus[30] <= 0; end
					sn_id[30] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[31] <= 0;
				sn_error_bus[31] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd31)
				begin
					if(sn_id[31] == frame_sn) sn_error_bus[31] <= 1;
					else begin 	sn_error_bus[31] <= 0; end
					sn_id[31] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[32] <= 0;
				sn_error_bus[32] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd32)
				begin
					if(sn_id[32] == frame_sn) sn_error_bus[32] <= 1;
					else begin 	sn_error_bus[32] <= 0; end
					sn_id[32] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[33] <= 0;
				sn_error_bus[33] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd33)
				begin
					if(sn_id[33] == frame_sn) sn_error_bus[33] <= 1;
					else begin 	sn_error_bus[33] <= 0; end
					sn_id[33] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[34] <= 0;
				sn_error_bus[34] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd34)
				begin
					if(sn_id[34] == frame_sn) sn_error_bus[34] <= 1;
					else begin 	sn_error_bus[34] <= 0; end
					sn_id[34] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[35] <= 0;
				sn_error_bus[35] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd35)
				begin
					if(sn_id[35] == frame_sn) sn_error_bus[35] <= 1;
					else begin 	sn_error_bus[35] <= 0; end
					sn_id[35] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[36] <= 0;
				sn_error_bus[36] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd36)
				begin
					if(sn_id[36] == frame_sn) sn_error_bus[36] <= 1;
					else begin 	sn_error_bus[36] <= 0; end
					sn_id[36] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[37] <= 0;
				sn_error_bus[37] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd37)
				begin
					if(sn_id[37] == frame_sn) sn_error_bus[37] <= 1;
					else begin 	sn_error_bus[37] <= 0; end
					sn_id[37] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[38] <= 0;
				sn_error_bus[38] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd38)
				begin
					if(sn_id[38] == frame_sn) sn_error_bus[38] <= 1;
					else begin 	sn_error_bus[38] <= 0; end
					sn_id[38] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[39] <= 0;
				sn_error_bus[39] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd39)
				begin
					if(sn_id[39] == frame_sn) sn_error_bus[39] <= 1;
					else begin 	sn_error_bus[39] <= 0; end
					sn_id[39] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[40] <= 0;
				sn_error_bus[40] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd40)
				begin
					if(sn_id[40] == frame_sn) sn_error_bus[40] <= 1;
					else begin 	sn_error_bus[40] <= 0; end
					sn_id[40] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[41] <= 0;
				sn_error_bus[41] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd41)
				begin
					if(sn_id[41] == frame_sn) sn_error_bus[41] <= 1;
					else begin 	sn_error_bus[41] <= 0; end
					sn_id[41] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[42] <= 0;
				sn_error_bus[42] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd42)
				begin
					if(sn_id[42] == frame_sn) sn_error_bus[42] <= 1;
					else begin 	sn_error_bus[42] <= 0; end
					sn_id[42] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[43] <= 0;
				sn_error_bus[43] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd43)
				begin
					if(sn_id[43] == frame_sn) sn_error_bus[43] <= 1;
					else begin 	sn_error_bus[43] <= 0; end
					sn_id[43] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[44] <= 0;
				sn_error_bus[44] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd44)
				begin
					if(sn_id[44] == frame_sn) sn_error_bus[44] <= 1;
					else begin 	sn_error_bus[44] <= 0; end
					sn_id[44] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[45] <= 0;
				sn_error_bus[45] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd45)
				begin
					if(sn_id[45] == frame_sn) sn_error_bus[45] <= 1;
					else begin 	sn_error_bus[45] <= 0; end
					sn_id[45] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[46] <= 0;
				sn_error_bus[46] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd46)
				begin
					if(sn_id[46] == frame_sn) sn_error_bus[46] <= 1;
					else begin 	sn_error_bus[46] <= 0; end
					sn_id[46] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[47] <= 0;
				sn_error_bus[47] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd47)
				begin
					if(sn_id[47] == frame_sn) sn_error_bus[47] <= 1;
					else begin 	sn_error_bus[47] <= 0; end
					sn_id[47] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[48] <= 0;
				sn_error_bus[48] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd48)
				begin
					if(sn_id[48] == frame_sn) sn_error_bus[48] <= 1;
					else begin 	sn_error_bus[48] <= 0; end
					sn_id[48] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[49] <= 0;
				sn_error_bus[49] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd49)
				begin
					if(sn_id[49] == frame_sn) sn_error_bus[49] <= 1;
					else begin 	sn_error_bus[49] <= 0; end
					sn_id[49] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[50] <= 0;
				sn_error_bus[50] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd50)
				begin
					if(sn_id[50] == frame_sn) sn_error_bus[50] <= 1;
					else begin 	sn_error_bus[50] <= 0; end
					sn_id[50] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)  
			begin
				sn_id[51] <= 0;
				sn_error_bus[51] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd51)
				begin
					if(sn_id[51] == frame_sn) sn_error_bus[51] <= 1;
					else begin 	sn_error_bus[51] <= 0; end
					sn_id[51] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)  
			begin
				sn_id[52] <= 0;
				sn_error_bus[52] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd52)
				begin
					if(sn_id[52] == frame_sn) sn_error_bus[52] <= 1;
					else begin 	sn_error_bus[52] <= 0; end
					sn_id[52] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)  
			begin
				sn_id[53] <= 0;
				sn_error_bus[53] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd53)
				begin
					if(sn_id[53] == frame_sn) sn_error_bus[53] <= 1;
					else begin 	sn_error_bus[53] <= 0; end
					sn_id[53] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)  
			begin
				sn_id[54] <= 0;
				sn_error_bus[54] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd54)
				begin
					if(sn_id[54] == frame_sn) sn_error_bus[54] <= 1;
					else begin 	sn_error_bus[54] <= 0; end
					sn_id[54] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)  
			begin
				sn_id[55] <= 0;
				sn_error_bus[55] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd55)
				begin
					if(sn_id[55] == frame_sn) sn_error_bus[55] <= 1;
					else begin 	sn_error_bus[55] <= 0; end
					sn_id[55] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)  
			begin
				sn_id[56] <= 0;
				sn_error_bus[56] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd56)
				begin
					if(sn_id[56] == frame_sn) sn_error_bus[56] <= 1;
					else begin 	sn_error_bus[56] <= 0; end
					sn_id[56] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)  
			begin
				sn_id[57] <= 0;
				sn_error_bus[57] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd57)
				begin
					if(sn_id[57] == frame_sn) sn_error_bus[57] <= 1;
					else begin 	sn_error_bus[57] <= 0; end
					sn_id[57] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)  
			begin
				sn_id[58] <= 0;
				sn_error_bus[58] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd58)
				begin
					if(sn_id[58] == frame_sn) sn_error_bus[58] <= 1;
					else begin 	sn_error_bus[58] <= 0; end
					sn_id[58] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)  
			begin
				sn_id[59] <= 0;
				sn_error_bus[59] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd59)
				begin
					if(sn_id[59] == frame_sn) sn_error_bus[59] <= 1;
					else begin 	sn_error_bus[59] <= 0; end
					sn_id[59] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)  
			begin
				sn_id[60] <= 0;
				sn_error_bus[60] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd60)
				begin
					if(sn_id[60] == frame_sn) sn_error_bus[60] <= 1;
					else begin 	sn_error_bus[60] <= 0; end
					sn_id[60] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[61] <= 0;
				sn_error_bus[61] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd61)
				begin
					if(sn_id[61] == frame_sn) sn_error_bus[61] <= 1;
					else begin 	sn_error_bus[61] <= 0; end
					sn_id[61] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[62] <= 0;
				sn_error_bus[62] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd62)
				begin
					if(sn_id[62] == frame_sn) sn_error_bus[62] <= 1;
					else begin 	sn_error_bus[62] <= 0; end
					sn_id[62] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[63] <= 0;
				sn_error_bus[63] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd63)
				begin
					if(sn_id[63] == frame_sn) sn_error_bus[63] <= 1;
					else begin 	sn_error_bus[63] <= 0; end
					sn_id[63] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[64] <= 0;
				sn_error_bus[64] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd64)
				begin
					if(sn_id[64] == frame_sn) sn_error_bus[64] <= 1;
					else begin 	sn_error_bus[64] <= 0; end
					sn_id[64] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[65] <= 0;
				sn_error_bus[65] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd65)
				begin
					if(sn_id[65] == frame_sn) sn_error_bus[65] <= 1;
					else begin 	sn_error_bus[65] <= 0; end
					sn_id[65] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[66] <= 0;
				sn_error_bus[66] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd66)
				begin
					if(sn_id[66] == frame_sn) sn_error_bus[66] <= 1;
					else begin 	sn_error_bus[66] <= 0; end
					sn_id[66] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[67] <= 0;
				sn_error_bus[67] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd67)
				begin
					if(sn_id[67] == frame_sn) sn_error_bus[67] <= 1;
					else begin 	sn_error_bus[67] <= 0; end
					sn_id[67] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[68] <= 0;
				sn_error_bus[68] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd68)
				begin
					if(sn_id[68] == frame_sn) sn_error_bus[68] <= 1;
					else begin 	sn_error_bus[68] <= 0; end
					sn_id[68] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[69] <= 0;
				sn_error_bus[69] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd69)
				begin
					if(sn_id[69] == frame_sn) sn_error_bus[69] <= 1;
					else begin 	sn_error_bus[69] <= 0; end
					sn_id[69] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[70] <= 0;
				sn_error_bus[70] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd70)
				begin
					if(sn_id[70] == frame_sn) sn_error_bus[70] <= 1;
					else begin 	sn_error_bus[70] <= 0; end
					sn_id[70] <= frame_sn;
				end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			begin
				sn_id[71] <= 0;
				sn_error_bus[71] <= 0;
			end
		else
			if(got_frame == 1 && frame_type == pass_type && frame_id == 8'd71)
				begin
					if(sn_id[71] == frame_sn) sn_error_bus[71] <= 1;
					else begin 	sn_error_bus[71] <= 0; end
					sn_id[71] <= frame_sn;
				end

	always @ (posedge sys_clk)
		if(!glbl_rst_n) 
			sn_error <= 0;
		else
			sn_error <= |sn_error_bus;
					
endmodule
