`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:31:03 04/15/2016 
// Design Name: 
// Module Name:    tx_con 
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
module tx_con(
   sys_clk,
	glbl_rst_n,
	
	ack_tx_en,
	lpass_tx_en,
	id_now,
	card_id,
	init_done,
		
	rd_wr_done,
	rd_wr_start,
	rd_wr_len,
	rd_addr,
	wr_addr,
	
	tx_data_len,
	tx_start,
	
	tx_con_wren,
	tx_con_waddr,
	tx_con_wdata
);

   input sys_clk;
	input glbl_rst_n;
	
	input ack_tx_en;
	input lpass_tx_en;
	input [7:0]id_now;	
	input [7:0]card_id;
	input init_done;
	
	input rd_wr_done;
	output reg rd_wr_start;
	output reg [10:0]rd_wr_len;
	output reg [15:0]rd_addr;
	output reg [10:0]wr_addr;
		
	output reg [10:0]tx_data_len;
	output reg tx_start;
	
	output reg tx_con_wren;
	output reg [10:0]tx_con_waddr;
	output reg [7:0]tx_con_wdata;
	
	parameter l_bus = 1'b0;
	
	parameter idle 	= 4'd0;
	parameter wram0 	= 4'd1;
	parameter wram1	= 4'd2;
	parameter wram2	= 4'd3;
	parameter wram3 	= 4'd4;
	parameter wend 	= 4'd5;
	parameter wait0 	= 4'd6;
	
	reg [7:0]max_id;
	reg [7:0]min_id;
	reg [7:0]type;
	reg [15:0]sn;
	reg [3:0]state;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				state <= idle;
				tx_data_len <= 11'd0;
				tx_start <= 1'd0;
				rd_wr_start <= 1'd0; 
				tx_con_wren <= 1'd0;  
				tx_con_waddr <= 11'd0;  
				tx_con_wdata <= 8'd0; 
				type <= 8'd0; 
				sn <= 16'd0;
			end
		else
			case(state)
				idle	:	begin	
								tx_start <= 1'd0;
								if(id_now >= min_id && id_now <= max_id)
									begin
										if(ack_tx_en == 1)
											begin
												tx_data_len <= 11'd18;
												state <= wram0;
												type <= 8'h32;
											end
										if(lpass_tx_en)
											begin
												state <= wram0;
												sn <= sn + 16'd1;
												type <= 8'h51;
												if(l_bus == 1)
													tx_data_len <= 11'd68;
												else
													tx_data_len <= 11'd1028;
											end
									end
								end
				wram0	:	begin
								tx_con_wren <= 1'd1;  
								tx_con_waddr <= 11'd0; 
								tx_con_wdata <= id_now; 
								state <= wram1;
							end
				wram1	:	begin
								tx_con_wren <= 1'd1;  
								tx_con_waddr <= 11'd1; 
								tx_con_wdata <= type; 
								state <= wram2;
							end
				wram2	:	begin
								tx_con_wren <= 1'd1;  
								tx_con_waddr <= 11'd2; 
								tx_con_wdata <= sn[15:8]; 
								state <= wram3;
							end
				wram3	:	begin
								tx_con_wren <= 1'd1;  
								tx_con_waddr <= 11'd3; 
								tx_con_wdata <= sn[7:0];
								state <= wend; 
							end
				wend	:	begin
								tx_con_wren <= 1'd0;  
								tx_con_waddr <= 11'd0; 
								tx_con_wdata <= 7'd0;
								rd_wr_start <= 1'b1;
								state <= wait0; 
							end
				wait0	:	begin
								rd_wr_start <= 1'b0;
								if(rd_wr_done == 1)
									begin
										tx_start <= 1'd1;
										state <= idle; 
									end
							end
				default	:	state <= idle; 
			endcase

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				rd_wr_len <= 11'd0;
				wr_addr <= 11'd0;
			end
		else
			begin
				if(ack_tx_en == 1) 
					begin
						rd_wr_len <= 11'd16;
						wr_addr <= 11'd2;
					end
				if(lpass_tx_en == 1)
					if(l_bus == 1)
						begin
							rd_wr_len <= 11'd64; 
							wr_addr <= 11'd4; 
						end
					else
						begin
							rd_wr_len <= 11'd1024; 
							wr_addr <= 11'd4; 
						end
			end
			
	always @ (posedge sys_clk) 
		if(!glbl_rst_n)
			begin
				max_id <= 8'd0;
				min_id <= 8'd0;
			end
		else
			if(init_done == 1)
				case(card_id)
					8'd14	:	if(l_bus == 1)
									begin
										max_id <= 8'd11;
										min_id <= 8'd0;
									end
								else
									begin
										max_id <= 8'd23;
										min_id <= 8'd0;
									end
					8'd13	:	if(l_bus == 1)	
									begin
										max_id <= 8'd23;
										min_id <= 8'd12;
									end
								else
									begin
										max_id <= 8'd47;
										min_id <= 8'd24;
									end
					8'd12	:	begin
                      		max_id <= 8'd53;
									min_id <= 8'd48;
					       	end
					8'd11	:	begin	
					       		max_id <= 8'd59;
									min_id <= 8'd54;
					       	end
					8'd10	:	begin	
					       		max_id <= 8'd65;
									min_id <= 8'd60;
					       	end
					8'd9	:	begin	
					       		max_id <= 8'd71;
									min_id <= 8'd66;
					       	end
//					8'd8	:	begin	
//					       		max_id <= 8'd59;
//									min_id <= 8'd48;
//					       	end               				 /////»·Íø¿¨µÄ°å¿¨idÔÝÊ±²»¿¼ÂÇ
//					8'd7	:	begin	
//                      	max_id <= 8'd71;
//									min_id <= 8'd60;
//					       	end
					default	:	begin
										max_id <= (8'd14 & {8{card_id[4]}}) + (8'd28 & {8{card_id[5]}}) + 8'd30 - {4'd0,card_id[3:0]};
										min_id <= (8'd14 & {8{card_id[4]}}) + (8'd28 & {8{card_id[5]}}) + 8'd30 - {4'd0,card_id[3:0]};
									end
				endcase
			else
				begin
					max_id <= max_id;
					min_id <= min_id;
				end

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				rd_addr <= 0;
			end
		else
			case(card_id)
				8'd14	:	if(l_bus == 1)
								begin
									if(ack_tx_en == 1) rd_addr <= {4'd0,id_now[7:0],4'd0};
									if(lpass_tx_en == 1) rd_addr <= {2'd0,id_now[7:0],6'd0} + 16'h0300;
								end
							else
								begin
									if(ack_tx_en == 1) rd_addr <= {4'd0,id_now[7:0],4'd0};
									if(lpass_tx_en == 1) rd_addr <= {id_now[5:0],10'd0} + 16'h0180;
								end
				8'd13	:	if(l_bus == 1)	
								begin
									if(ack_tx_en == 1) rd_addr <= {4'd0,(id_now[7:0] - 8'd12),4'd0};
									if(lpass_tx_en == 1) rd_addr <= {2'd0,(id_now[7:0] - 8'd12),6'd0} + 16'h00c0;
								end
							else
								begin
									if(ack_tx_en == 1) rd_addr <= {4'd0,(id_now[7:0] - 8'd24),4'd0};
									if(lpass_tx_en == 1) rd_addr <= {(id_now[5:0] - 6'd24),10'd0} + 16'h0180;
								end
				8'd12	:	begin
                     	if(ack_tx_en == 1) rd_addr <= 16'd0;
								if(lpass_tx_en == 1) 
									begin
										rd_addr[9:0] <= 0;
										if(id_now == 48) rd_addr[15:10] <= 6'b000001;
										if(id_now == 49) rd_addr[15:10] <= 6'b000010;
										if(id_now == 50) rd_addr[15:10] <= 6'b000100;
										if(id_now == 51) rd_addr[15:10] <= 6'b001000;
										if(id_now == 52) rd_addr[15:10] <= 6'b010000;
										if(id_now == 53) rd_addr[15:10] <= 6'b100000;
									end
				       	end
				8'd11	:	begin	
				       		if(ack_tx_en == 1) rd_addr <= 16'd0;
								if(lpass_tx_en == 1) 
									begin
										rd_addr[9:0] <= 0;
										if(id_now == 54) rd_addr[15:10] <= 6'b000001;
										if(id_now == 55) rd_addr[15:10] <= 6'b000010;
										if(id_now == 56) rd_addr[15:10] <= 6'b000100;
										if(id_now == 57) rd_addr[15:10] <= 6'b001000;
										if(id_now == 58) rd_addr[15:10] <= 6'b010000;
										if(id_now == 59) rd_addr[15:10] <= 6'b100000;
									end
				       	end
				8'd10	:	begin	
				       		if(ack_tx_en == 1) rd_addr <= 16'd0;
								if(lpass_tx_en == 1) 
									begin
										rd_addr[9:0] <= 0;
										if(id_now == 60) rd_addr[15:10] <= 6'b000001;
										if(id_now == 61) rd_addr[15:10] <= 6'b000010;
										if(id_now == 62) rd_addr[15:10] <= 6'b000100;
										if(id_now == 63) rd_addr[15:10] <= 6'b001000;
										if(id_now == 64) rd_addr[15:10] <= 6'b010000;
										if(id_now == 65) rd_addr[15:10] <= 6'b100000;
									end
				       	end
				8'd9	:	begin	
				       		if(ack_tx_en == 1) rd_addr <= 16'd0;
								if(lpass_tx_en == 1) 
									begin
										rd_addr[9:0] <= 0;
										if(id_now == 66) rd_addr[15:10] <= 6'b000001;
										if(id_now == 67) rd_addr[15:10] <= 6'b000010;
										if(id_now == 68) rd_addr[15:10] <= 6'b000100;
										if(id_now == 69) rd_addr[15:10] <= 6'b001000;
										if(id_now == 70) rd_addr[15:10] <= 6'b010000;
										if(id_now == 71) rd_addr[15:10] <= 6'b100000;
									end
				       	end
//				8'd8	:	begin	
//				       	end                /////»·Íø¿¨µÄ°å¿¨idÔÝÊ±²»¿¼ÂÇ
//				8'd7	:	begin	
//				       	end
				default	:	begin
									if(ack_tx_en == 1) rd_addr[15:0] <= 16'd0;
									if(lpass_tx_en == 1) rd_addr[15:0] <= 16'b1000_0000_0000_0000;
								end
			endcase
	
endmodule
