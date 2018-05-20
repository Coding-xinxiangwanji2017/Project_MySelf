`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:59:46 04/15/2016 
// Design Name: 
// Module Name:    wr_rxbuf 
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
module wr_rxbuf(
	sys_clk,
	glbl_rst_n,
	
	card_id,
	init_done,
	
	diag_ack_wren,
	lb_rxbuf_wren,
	lb_rxbuf_wraddr,
	lb_rxbuf_wrdata,
	
	ack_rd_en,
	pass_rd_en,
	id_now,
	
	rx_data_valid,
	rx_data
);

   input sys_clk;
	input glbl_rst_n;
	
	input [7:0]card_id;
	input init_done;
	
	output diag_ack_wren;
	output lb_rxbuf_wren;
	output reg [15:0]lb_rxbuf_wraddr;
	output [7:0]lb_rxbuf_wrdata;
	
	input ack_rd_en;
	input pass_rd_en;
	input [7:0]id_now;
	
	input rx_data_valid;
	input [7:0]rx_data;

	parameter l_bus = 1'b1;
	
	parameter idle 	= 4'd1;
	parameter wait0 	= 4'd2;
	parameter wrbuf	= 4'd3;

	reg [15:0]wr_addr;
	reg [5:0]rc_rx_load;
	reg l_rx_load;
	reg cont_card;
	reg io_card;
	reg [3:0]state;
	reg diag_ack;
	reg wr_buf;

	assign lb_rxbuf_wrdata = (diag_ack | rx_data_valid | wr_buf) ? rx_data : 0;
	assign diag_ack_wren = diag_ack & rx_data_valid;
	assign lb_rxbuf_wren = wr_buf & rx_data_valid;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				state <= idle;
				lb_rxbuf_wraddr <= 0;
				diag_ack <= 0;
				wr_buf <= 0;
			end
		else
			case(state)
				idle	:	begin
								if(cont_card == 1)
									begin
										if(ack_rd_en == 1)
											begin
												state <= wait0;
												diag_ack <= 1;
												wr_buf <= 1;
												lb_rxbuf_wraddr <= wr_addr;
											end
										if(pass_rd_en == 1)
											begin
												state <= wait0;
												diag_ack <= 0;
												wr_buf <= 1;
												lb_rxbuf_wraddr <= wr_addr;
											end
									end
								else if(io_card == 1)
									begin
										if(l_rx_load == 0 && pass_rd_en == 1)
											begin
												wr_buf <= 1;
												state <= wait0;
												lb_rxbuf_wraddr <= wr_addr;
											end
										if(ack_rd_en == 1)	wr_buf <= 0;
									end
								else
									begin
										if(ack_rd_en == 1)	wr_buf <= 0;
										if(pass_rd_en == 1)
											begin
												if(id_now <= 23)
													begin
														state <= wait0;
														wr_buf <= 1;
														lb_rxbuf_wraddr <= wr_addr;
													end
												if((id_now == 24 || id_now == 30 || id_now == 36 || id_now == 42) && rc_rx_load[0] == 0)
													begin
														state <= wait0;
														wr_buf <= 1;
														lb_rxbuf_wraddr <= wr_addr;
													end
												if((id_now == 25 || id_now == 31 || id_now == 37 || id_now == 43) && rc_rx_load[1] == 0)
													begin
														state <= wait0;
														wr_buf <= 1;
														lb_rxbuf_wraddr <= wr_addr;
													end
												if((id_now == 26 || id_now == 32 || id_now == 38 || id_now == 44) && rc_rx_load[2] == 0)
													begin
														state <= wait0;
														wr_buf <= 1;
														lb_rxbuf_wraddr <= wr_addr;
													end
												if((id_now == 27 || id_now == 33 || id_now == 39 || id_now == 45) && rc_rx_load[3] == 0)
													begin
														state <= wait0;
														wr_buf <= 1;
														lb_rxbuf_wraddr <= wr_addr;
													end
												if((id_now == 28 || id_now == 34 || id_now == 40 || id_now == 46) && rc_rx_load[3] == 0)
													begin
														state <= wait0;
														wr_buf <= 1;
														lb_rxbuf_wraddr <= wr_addr;
													end
												if((id_now == 29 || id_now == 35 || id_now == 41 || id_now == 47) && rc_rx_load[3] == 0)
													begin
														state <= wait0;
														wr_buf <= 1;
														lb_rxbuf_wraddr <= wr_addr;
													end
											end
									end
							end
				wait0	:	if(rx_data_valid == 1)
								begin
									lb_rxbuf_wraddr <= lb_rxbuf_wraddr + 1'b1;
									state <= wrbuf;
								end
							else
								begin
									lb_rxbuf_wraddr <= wr_addr;
								end
				wrbuf	:	begin
								if(rx_data_valid == 0)
									begin
										state <= idle;
										wr_buf <= 0;
										lb_rxbuf_wraddr <= 0;
										diag_ack <= 0;
									end
								else
									lb_rxbuf_wraddr <= lb_rxbuf_wraddr + 1'b1;
							end
				default	:	state <= idle;
			endcase

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				wr_addr <= 0;
				rc_rx_load <= 0;
				l_rx_load <= 0;
				cont_card <= 0;
				io_card <= 0;
			end
		else
			case(card_id)
				8'd14	:	begin
								cont_card <= 1;
								if(l_bus == 1)
									begin
										if(ack_rd_en == 1) wr_addr <= {4'd0,id_now[7:0]-8'd24,4'd0};
										if(pass_rd_en == 1) wr_addr <= {2'd0,id_now[7:0]-8'd24,6'd0} + 16'h0300;
									end
								else
									begin
										if(ack_rd_en == 1) wr_addr <= {4'd0,id_now[7:0]-8'd48,4'd0};
										if(pass_rd_en == 1) wr_addr <= {id_now[6:0]-8'd48,10'd0} + 16'h0180;
									end
							end
				8'd13	:	begin
								cont_card <= 1;
								if(l_bus == 1)
									begin
										if(ack_rd_en == 1) wr_addr <= {4'd0,id_now[7:0]-8'd24,4'd0};
										if(pass_rd_en == 1) wr_addr <= {2'd0,id_now[7:0]-8'd24,6'd0} + 16'h0300;
									end
								else
									begin
										if(ack_rd_en == 1) wr_addr <= {4'd0,id_now[7:0]-8'd48,4'd0};
										if(pass_rd_en == 1) wr_addr <= {id_now[6:0]-8'd48,10'd0} + 16'h0180;
									end
							end
				8'd12	:	begin
								if(id_now == 48) rc_rx_load <= 0;
								if(pass_rd_en == 1) 
									begin
										wr_addr[9:0] <= 0;
										if(id_now == 0 || id_now == 24) wr_addr[15:10] <= 6'b000001;
										if(id_now == 1 || id_now == 25) wr_addr[15:10] <= 6'b000010;
										if(id_now == 2 || id_now == 26) wr_addr[15:10] <= 6'b000100;
										if(id_now == 3 || id_now == 27) wr_addr[15:10] <= 6'b001000;
										if(id_now == 4 || id_now == 28) wr_addr[15:10] <= 6'b010000;
										if(id_now == 5 || id_now == 29) wr_addr[15:10] <= 6'b100000;
										if(id_now == 0) rc_rx_load[0] <= 1;
										if(id_now == 1) rc_rx_load[1] <= 1;
										if(id_now == 2) rc_rx_load[2] <= 1;
										if(id_now == 3) rc_rx_load[3] <= 1;
										if(id_now == 4) rc_rx_load[4] <= 1;
										if(id_now == 5) rc_rx_load[5] <= 1;
									end
				       	end
				8'd11	:	begin	
								if(id_now == 48) rc_rx_load <= 0;
								if(pass_rd_en == 1) 
									begin
										wr_addr[9:0] <= 0;
										if(id_now == 6 ||  id_now == 30) wr_addr[15:10] <= 6'b000001;
										if(id_now == 7 ||  id_now == 31) wr_addr[15:10] <= 6'b000010;
										if(id_now == 8 ||  id_now == 32) wr_addr[15:10] <= 6'b000100;
										if(id_now == 9 ||  id_now == 33) wr_addr[15:10] <= 6'b001000;
										if(id_now == 10 || id_now == 34) wr_addr[15:10] <= 6'b010000;
										if(id_now == 11 || id_now == 35) wr_addr[15:10] <= 6'b100000;
										if(id_now == 6 ) rc_rx_load[0] <= 1;
										if(id_now == 7 ) rc_rx_load[1] <= 1;
										if(id_now == 8 ) rc_rx_load[2] <= 1;
										if(id_now == 9 ) rc_rx_load[3] <= 1;
										if(id_now == 10) rc_rx_load[4] <= 1;
										if(id_now == 11) rc_rx_load[5] <= 1;
									end
				       	end
				8'd10	:	begin	
								if(id_now == 48) rc_rx_load <= 0;
								if(pass_rd_en == 1) 
									begin
										wr_addr[9:0] <= 0;
										if(id_now == 12 || id_now == 36) wr_addr[15:10] <= 6'b000001;
										if(id_now == 13 || id_now == 37) wr_addr[15:10] <= 6'b000010;
										if(id_now == 14 || id_now == 38) wr_addr[15:10] <= 6'b000100;
										if(id_now == 15 || id_now == 39) wr_addr[15:10] <= 6'b001000;
										if(id_now == 16 || id_now == 40) wr_addr[15:10] <= 6'b010000;
										if(id_now == 17 || id_now == 41) wr_addr[15:10] <= 6'b100000;
										if(id_now == 12) rc_rx_load[0] <= 1;
										if(id_now == 13) rc_rx_load[1] <= 1;
										if(id_now == 14) rc_rx_load[2] <= 1;
										if(id_now == 15) rc_rx_load[3] <= 1;
										if(id_now == 16) rc_rx_load[4] <= 1;
										if(id_now == 17) rc_rx_load[5] <= 1;
									end
				       	end
				8'd9	:	begin	
								if(id_now == 48) rc_rx_load <= 0;
								if(pass_rd_en == 1) 
									begin
										wr_addr[9:0] <= 0;
										if(id_now == 18 || id_now == 42) wr_addr[15:10] <= 6'b000001;
										if(id_now == 19 || id_now == 43) wr_addr[15:10] <= 6'b000010;
										if(id_now == 20 || id_now == 44) wr_addr[15:10] <= 6'b000100;
										if(id_now == 21 || id_now == 45) wr_addr[15:10] <= 6'b001000;
										if(id_now == 22 || id_now == 46) wr_addr[15:10] <= 6'b010000;
										if(id_now == 23 || id_now == 47) wr_addr[15:10] <= 6'b100000;
										if(id_now == 18) rc_rx_load[0] <= 1;
										if(id_now == 19) rc_rx_load[1] <= 1;
										if(id_now == 20) rc_rx_load[2] <= 1;
										if(id_now == 21) rc_rx_load[3] <= 1;
										if(id_now == 22) rc_rx_load[4] <= 1;
										if(id_now == 23) rc_rx_load[5] <= 1;
									end
				       	end
//				8'd8	:	begin	
//				       	end                /////»·Íø¿¨µÄ°å¿¨idÔÝÊ±²»¿¼ÂÇ
//				8'd7	:	begin	
//				       	end
				default	:	begin
									if(ack_rd_en == 1) wr_addr[15:0] <= 16'd0;
									if(id_now == 25) l_rx_load <= 0;
									if(pass_rd_en == 1) 
										begin
											wr_addr[15:0] <= 16'b1000_0000_0000_0000;
											if(id_now <= 11) l_rx_load <= 1;
										end
									io_card <= 1;
								end
			endcase
	
endmodule
