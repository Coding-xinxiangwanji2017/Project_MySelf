`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:01:34 04/20/2016 
// Design Name: 
// Module Name:    move_con 
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
module move_con(
    input  wire         sys_clk_50m      ,
    input  wire         sys_rst_n        ,	
	 
    input  wire         xfer_in_en       ,	
    input  wire         xfer_out_en      ,	
    input  wire         xnet_en          ,
	 
    output reg          xfer_buf_rden    ,	
    output reg  [17:00] xfer_buf_addr    ,	
    input  wire [07:00] xfer_buf_data    ,
	 
    input  wire [17:00] xfer_in_addr  	  ,
    input  wire [17:00] xfer_in_length	  ,
    input  wire [17:00] xfer_out_addr    ,
    input  wire [17:00] xfer_out_length  ,
    input  wire [17:00] xnet_addr  	     ,
    input  wire [17:00] xnet_length	     ,
	 
    output reg          byte6_valid      ,	
    output reg  [47:00] byte6_data       ,
    input  wire         move_done       
);

	localparam idle 	= 	2'b00;
	localparam rbuf 	= 	2'b01;
	localparam waitd 	= 	2'b10;
	localparam waitx 	= 	2'b11;

	reg [1:0]state;
	reg [17:0]rd_length;
	reg [17:0]rd_cnt;
	reg [2:0]valid_cnt;
	reg data_valid;
	reg xfer_buf_rden_reg;
	
	reg [1:0]rd_delay_cnt;
	
	wire xfer_en = xfer_in_en | xfer_out_en | xnet_en;

	always @ (posedge sys_clk_50m)
		if(!sys_rst_n)
			begin
				valid_cnt <= 0;
				data_valid <= 0;
				xfer_buf_rden_reg <= 0;
				byte6_valid <= 0;
				byte6_data <= 0;
			end
		else
			begin
				xfer_buf_rden_reg <= xfer_buf_rden;
				data_valid <= xfer_buf_rden_reg;
				if(valid_cnt == 5)
					begin
						byte6_valid <= 1;
					end
				else
					begin
						byte6_valid <= 0;
					end
				if(data_valid == 1) byte6_data <= {xfer_buf_data,byte6_data[47:8]};
				if(data_valid == 1)
					begin
						if(valid_cnt == 5)
							valid_cnt <= 0;
						else
							valid_cnt <= valid_cnt + 1'b1;
					end
			end

	always @ (posedge sys_clk_50m)
		if(!sys_rst_n)
			begin
				xfer_buf_rden <= 0;
				xfer_buf_addr <= 0;
				rd_length <= 0;
				rd_cnt <= 0;
				state <= idle;
				rd_delay_cnt <= 0;
			end
		else
			case(state)
				idle	:	begin
								rd_cnt <= 0;
								rd_delay_cnt <= 0;
								if(xfer_in_en)
									begin
										xfer_buf_addr <= xfer_in_addr;
										rd_length <= xfer_in_length;
										state <= waitd;
									end
								if(xfer_out_en)
									begin
										xfer_buf_addr <= xfer_out_addr;
										rd_length <= xfer_out_length;
										state <= waitd;
									end
								if(xnet_en)
									begin
										xfer_buf_addr <= xnet_addr;
										rd_length <= xnet_length;
										state <= waitd;
									end
							end
				rbuf	:	begin
								xfer_buf_addr <= xfer_buf_addr + 1'b1;
								if(rd_cnt == 5)
									begin
										state <= waitd;
										rd_length <= rd_length - 18'd6;
										rd_cnt <= 0;
										xfer_buf_rden <= 0;
									end
								else
									begin
										rd_cnt <= rd_cnt + 1'b1;
									end
							end
				waitd	:	begin
								if(xfer_en == 0)  
									begin
										state <= idle;
										xfer_buf_rden <= 0;
										xfer_buf_addr <= 0;
									end
								else
									begin
										if(rd_length == 0)
											begin
												state <= waitx;
											   xfer_buf_rden <= 0;
											   xfer_buf_addr <= 0;
											end
										else
											begin
												if(rd_delay_cnt == 2)	
													begin
														xfer_buf_rden <= 1;
														rd_delay_cnt <= 0;
														state <= rbuf;
													end
												else
													begin
														rd_delay_cnt <= rd_delay_cnt + 1'b1;
													end
											end
									end
							end
				waitx	:	begin
								if(xfer_en == 0)
									state <= idle;
							end
				default	:	state <= idle; 
			endcase

endmodule
