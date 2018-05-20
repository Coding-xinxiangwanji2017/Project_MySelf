`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:09:07 04/20/2016 
// Design Name: 
// Module Name:    data_move 
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
module data_move(
    input  wire         sys_clk_50m      ,
    input  wire         sys_rst_n        ,
	 
    output wire         xfer_afpga_wren  ,	
    output reg          xfer_afpga_rden  ,	
    output wire [22:00] xfer_afpga_addr  ,	
    output wire [07:00] xfer_afpga_wdata ,	
    input  wire [07:00] xfer_afpga_rdata ,
	 
    output wire         xfer_cons_wren   ,	
    output reg          xfer_cons_rden   ,	
    output wire [17:00] xfer_cons_addr   ,	
    output wire [07:00] xfer_cons_wdata  ,	
    input  wire [07:00] xfer_cons_rdata  ,
	 		
    output wire [11:00] lb_rx_raddr  	  ,	
    input  wire [07:00] lb_rx_rdata 	  ,	
    output wire [14:00] cb_rx_raddr  	  ,	
    input  wire [07:00] cb_rx_rdata 	  ,	
    output wire [14:00] rb_rx_raddr  	  ,	
    input  wire [07:00] rb_rx_rdata 	  ,
	 
    output wire         lb_tx_wren       ,	
    output wire [10:00] lb_tx_waddr  	  ,	
    output wire [07:00] lb_tx_wdata 	  ,
    output wire         cb_tx_wren       ,	
    output wire [14:00] cb_tx_waddr  	  ,	
    output wire [07:00] cb_tx_wdata 	  ,
    output wire         rb_tx_wren       ,	
    output wire [14:00] rb_tx_waddr  	  ,	
    output wire [07:00] rb_tx_wdata 	  ,
	 
    input  wire         byte6_valid      ,	
    input  wire [47:00] byte6_data       ,
    output reg          move_done       
);

	parameter offset = 23'h100000;

	localparam idle 	= 	2'b00;
	localparam waitd 	= 	2'b01;

	wire [3:0]sou_area;
	wire [3:0]sou_length;
	wire [15:0]sou_addr;
	
	wire [3:0]des_area;
	wire [3:0]des_length;
	wire [15:0]des_addr;

	reg lb_rx_rden;
	reg cb_rx_rden;
	reg rb_rx_rden;

	reg rd_data_valid;
	reg [7:0]rd_data;
	reg [22:0]rd_addr;
	reg [22:0]wr_addr;

	reg lb_rx_rden_reg;
	reg cb_rx_rden_reg;
	reg rb_rx_rden_reg;
	reg xfer_cons_rden_reg;
	reg xfer_afpga_rden_reg;
	reg lb_rx_rdata_valid;
	reg cb_rx_rdata_valid;
	reg rb_rx_rdata_valid;
	reg xfer_cons_rdata_valid;
	reg xfer_afpga_rdata_valid;	

	reg [1:0]rd_state;
	reg [1:0]rd_length;
	reg rd_error;
	
	reg [1:0]wr_state;
	reg lb_tx_wren_en;
	reg cb_tx_wren_en;
	reg rb_tx_wren_en;
	reg xfer_cons_wren_en;
	reg xfer_afpga_wren_en;

	assign lb_rx_raddr = rd_addr[11:0];
	assign cb_rx_raddr = rd_addr[14:0];
	assign rb_rx_raddr = rd_addr[14:0];
	assign lb_tx_waddr = wr_addr[10:0];
	assign cb_tx_waddr = wr_addr[14:0];
	assign rb_tx_waddr = wr_addr[14:0];
	assign xfer_afpga_addr = (xfer_afpga_wren == 1) ? wr_addr : rd_addr;
	assign xfer_cons_addr = (xfer_cons_wren == 1) ? wr_addr[17:0] : rd_addr[17:0];

	assign sou_area = byte6_data[23:20];
	assign sou_length = byte6_data[19:16];
	assign sou_addr = byte6_data[15:0];
	
	assign des_area = byte6_data[47:44];
	assign des_length = byte6_data[43:40];
	assign des_addr = byte6_data[39:24];
	
	assign	lb_tx_wren = lb_tx_wren_en & rd_data_valid; 
	assign	lb_tx_wdata = rd_data;
	assign	cb_tx_wren = cb_tx_wren_en & rd_data_valid; 
	assign	cb_tx_wdata = rd_data;
	assign	rb_tx_wren = rb_tx_wren_en & rd_data_valid; 
	assign	rb_tx_wdata = rd_data;
	assign	xfer_cons_wren = xfer_cons_wren_en & rd_data_valid;
	assign	xfer_cons_wdata = rd_data;
	assign	xfer_afpga_wren = xfer_afpga_wren_en & rd_data_valid;
	assign	xfer_afpga_wdata = rd_data;

	always @ (posedge sys_clk_50m)///data读取
		if(!sys_rst_n)
			begin
				wr_addr <= 0;
				wr_state <= idle;
				lb_tx_wren_en <= 0;
				cb_tx_wren_en <= 0;
				rb_tx_wren_en <= 0;
				xfer_cons_wren_en <= 0;
				xfer_afpga_wren_en <= 0;
			end
		else
			case(wr_state)
				idle	:	begin
								move_done <= 0;
								if(byte6_valid)
									begin
										if(des_area == 1) begin lb_tx_wren_en <= 1; wr_addr <= {5'd0,des_addr}; end
										if(des_area == 3) begin cb_tx_wren_en <= 1; wr_addr <= {5'd0,des_addr}; end
										if(des_area == 5) begin rb_tx_wren_en <= 1; wr_addr <= {5'd0,des_addr}; end
										if(des_area == 6 || des_area == 7) begin xfer_afpga_wren_en <= 1; wr_addr <= {5'd0,des_addr} + offset; end
										if(des_area == 8) begin xfer_cons_wren_en <= 1; wr_addr <= {5'd0,des_addr}; end
									end
								if(rd_data_valid)
									begin
										wr_state <= waitd;
										wr_addr <= wr_addr + 1'b1;
									end
								if(rd_error)
									begin
										move_done <= 1;
										wr_addr <= 0;
										lb_tx_wren_en <= 0;
										cb_tx_wren_en <= 0;
										rb_tx_wren_en <= 0;
										xfer_cons_wren_en <= 0;
										xfer_afpga_wren_en <= 0;
									end
							end
				waitd	:	if(rd_data_valid == 0)
								begin
									wr_addr <= 0;
									wr_state <= idle;
									move_done <= 1;
									lb_tx_wren_en <= 0;
									cb_tx_wren_en <= 0;
									rb_tx_wren_en <= 0;
									xfer_cons_wren_en <= 0;
									xfer_afpga_wren_en <= 0;
								end
							else
								wr_addr <= wr_addr + 1'b1;
				default	:	wr_state <= idle; 
			endcase

	always @ (posedge sys_clk_50m)///data读取
		if(!sys_rst_n)
			begin
				xfer_afpga_rden <= 0;
				xfer_cons_rden <= 0;
				lb_rx_rden <= 0;
				cb_rx_rden <= 0;
				rb_rx_rden <= 0;
				rd_addr <= 0; 
				rd_length <= 0;
				rd_error <= 0;
				rd_state <= idle;
			end
		else
			case(rd_state)
				idle	:	begin
								if(byte6_valid)
									begin
										rd_state <= waitd;
										case(sou_area)
											0 : begin lb_rx_rden <= 1; rd_addr <= {5'd0,sou_addr}; rd_length <= sou_length[1:0]; end
											2 : begin cb_rx_rden <= 1; rd_addr <= {5'd0,sou_addr}; rd_length <= sou_length[1:0]; end
											4 : begin rb_rx_rden <= 1; rd_addr <= {5'd0,sou_addr}; rd_length <= sou_length[1:0]; end
											6 : begin xfer_afpga_rden <= 1; rd_addr <= {5'd0,sou_addr} + offset; rd_length <= sou_length[1:0]; end
											7 : begin xfer_afpga_rden <= 1; rd_addr <= {5'd0,sou_addr} + offset; rd_length <= sou_length[1:0]; end
											9 : begin xfer_cons_rden <= 1; rd_addr <= {5'd0,sou_addr}; rd_length <= sou_length[1:0]; end
											default	:	rd_error <= 1; 
										endcase
									end
								else
									rd_error <= 0; 
							end
				waitd	:	if(rd_length == 0)		
								begin
									rd_addr <= 0;
									xfer_afpga_rden <= 0;
									xfer_cons_rden <= 0;
									lb_rx_rden <= 0;
									cb_rx_rden <= 0;
									rb_rx_rden <= 0;
									rd_state <= idle;
								end
							else
								begin
									rd_length <= rd_length - 1'b1;
									rd_addr <= rd_addr + 1'b1;
								end
				default	:	rd_addr <= idle; 
			endcase

	always @ (posedge sys_clk_50m)///有效数据产生
		if(!sys_rst_n)
			begin
				lb_rx_rden_reg <= 0;
				cb_rx_rden_reg <= 0;
				rb_rx_rden_reg <= 0;
				xfer_cons_rden_reg <= 0;
				xfer_afpga_rden_reg <= 0;
				lb_rx_rdata_valid <= 0;
				cb_rx_rdata_valid <= 0;
				rb_rx_rdata_valid <= 0;
				xfer_cons_rdata_valid <= 0;
				xfer_afpga_rdata_valid <= 0;
				rd_data_valid <= 0;
				rd_data <= 0;
			end
		else
			begin
				lb_rx_rden_reg <= lb_rx_rden;
				cb_rx_rden_reg <= cb_rx_rden;
				rb_rx_rden_reg <= rb_rx_rden;
				xfer_cons_rden_reg <= xfer_cons_rden;
				xfer_afpga_rden_reg <= xfer_afpga_rden;
				lb_rx_rdata_valid <= lb_rx_rden_reg;
				cb_rx_rdata_valid <= cb_rx_rden_reg;
				rb_rx_rdata_valid <= rb_rx_rden_reg;
				xfer_cons_rdata_valid <= xfer_cons_rden_reg;
				xfer_afpga_rdata_valid <= xfer_afpga_rden_reg;
				if(lb_rx_rdata_valid) begin rd_data_valid <= 1; rd_data <= lb_rx_rdata; end
				if(cb_rx_rdata_valid) begin rd_data_valid <= 1; rd_data <= cb_rx_rdata; end
				if(rb_rx_rdata_valid) begin rd_data_valid <= 1; rd_data <= rb_rx_rdata; end
				if(xfer_cons_rdata_valid) begin rd_data_valid <= 1; rd_data <= xfer_cons_rdata; end
				if(xfer_afpga_rdata_valid) begin rd_data_valid <= 1; rd_data <= xfer_afpga_rdata; end
				if(lb_rx_rdata_valid == 0 && cb_rx_rdata_valid == 0 && rb_rx_rdata_valid == 0 && xfer_cons_rdata_valid == 0 && xfer_afpga_rdata_valid == 0)
					begin
						rd_data_valid <= 0;
						rd_data <= 0;
					end
			end


endmodule
