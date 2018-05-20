`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:35:11 04/15/2016 
// Design Name: 
// Module Name:    rd_wr 
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
module rd_wr(
   sys_clk,
	glbl_rst_n,
	
	lb_txbuf_rden,
	lb_txbuf_addr,
	lb_txbuf_rdata,
	
	rd_wr_done,
	rd_wr_start,
	rd_wr_len,
	rd_addr,
	wr_addr,
	
	rd_wr_wren,
	rd_wr_waddr,
	rd_wr_wdata
);

   input sys_clk;
	input glbl_rst_n;
	
	output reg lb_txbuf_rden;
	output reg [15:0]lb_txbuf_addr;
	input [7:0]lb_txbuf_rdata;
	
	output reg rd_wr_done;
	input rd_wr_start;
	input [10:0]rd_wr_len;
	input [15:0]rd_addr;
	input [10:0]wr_addr;
	
	output reg rd_wr_wren;
	output  [10:0]rd_wr_waddr;
	output  [7:0]rd_wr_wdata;

	parameter idle 	= 4'd0;
	parameter rram 	= 4'd1;

	reg [10:0] cnt;
	reg [10:0] len_reg;
	reg state;
	reg wren_reg;

	reg [10:0]rd_wr_waddr_reg;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				cnt <= 0;
				state <= 0;
				lb_txbuf_addr <= 0;
				lb_txbuf_rden <= 0;
				rd_wr_done <= 0;
				len_reg <= 0;
			end
		else 
			case(state)
				idle	:	begin
								rd_wr_done <= 0;
								if(rd_wr_start == 1)
									begin
										lb_txbuf_addr <= rd_addr;
										lb_txbuf_rden <= 1'b1;
										len_reg <= rd_wr_len;
										cnt <= 11'd1;
										state <= rram;
									end
							end
				rram	:	begin
								cnt <= cnt + 11'd1;
								if(cnt == len_reg)
									begin
										rd_wr_done <= 1;
										state <= idle;
										lb_txbuf_rden <= 1'b0;
										lb_txbuf_addr <= 0;
									end
								else
									lb_txbuf_addr <= lb_txbuf_addr + 16'd1;
							end
				default	:	state <= idle; 
			endcase

	assign rd_wr_wdata = (rd_wr_wren) ? lb_txbuf_rdata : 0;
	assign rd_wr_waddr = (rd_wr_wren) ? rd_wr_waddr_reg : 0;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				wren_reg <= 0;
				rd_wr_wren <= 0;
				rd_wr_waddr_reg <= 0;
			end
		else 
			begin
				wren_reg <= lb_txbuf_rden;
				rd_wr_wren <= wren_reg;
				if(rd_wr_start == 1)
					rd_wr_waddr_reg <= wr_addr;
				else
					if(rd_wr_wren == 1)
						rd_wr_waddr_reg <= rd_wr_waddr_reg + 11'd1;
					else
						rd_wr_waddr_reg <= rd_wr_waddr_reg;
			end

endmodule
