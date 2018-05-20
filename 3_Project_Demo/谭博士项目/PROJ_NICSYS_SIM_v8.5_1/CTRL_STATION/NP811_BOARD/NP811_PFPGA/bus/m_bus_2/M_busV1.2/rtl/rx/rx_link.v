//rx_link
module rx_link(
	
	input sys_clk,
	input clk_phy_p0,
	input clk_phy_p90,
	input clk_phy_p180,
	input clk_phy_p270,
	input rst,
	input rx_buf_rden,
	input [10:0]rx_buf_raddr,
	input lb_rxd,
	
	output reg o_rx_done,
	output [7:0]rx_buf_rdata,
	output reg [1:0]o_rx_crc_rslt,
	output reg o_rx_start
	
);

//信号展宽
wire rx_start;
wire rx_done;
wire [1:0] rx_crc_rslt;
reg [2:0]rx_start_d;
wire rx_start_or;
reg rx_start_or_d1;
reg [2:0]rx_done_d;
wire rx_done_or;
reg rx_done_or_d1;
reg [5:0] rx_crc_rslt_d;
wire [1:0] rx_crc_rslt_or;
reg [1:0] rx_crc_rslt_or_d1;

always @ (posedge clk_phy_p0)
begin
	if(rst)
		begin
	  rx_start_d<=3'd0;
		end
	else begin
		rx_start_d<={rx_start_d[1:0],rx_start};
	end
end

always @ (posedge clk_phy_p0)
begin
	if(rst)
		begin
			rx_done_d <=3'd0;
		end
	else begin
		rx_done_d<={rx_done_d[1:0],rx_done};
	end
end

always @ (posedge clk_phy_p0)
begin
	if(rst)
		begin
			rx_crc_rslt_d <=6'd0;
		end
	else begin
		rx_crc_rslt_d <={rx_crc_rslt_d[3:0],rx_crc_rslt};	
	end
end

assign rx_start_or =  rx_start_d[0] | rx_start_d[1] | rx_start_d[2];
assign rx_crc_rslt_or[0] = rx_crc_rslt_d[0] | rx_crc_rslt_d[2] | rx_crc_rslt_d[4];
assign rx_crc_rslt_or[1] = rx_crc_rslt_d[1] | rx_crc_rslt_d[3] | rx_crc_rslt_d[5];
assign rx_done_or = rx_done_d[0] | rx_done_d[1] | rx_done_d[2];


//信号同步  sys-clk

always @ (posedge sys_clk)
begin
	if(rst)
		begin
			rx_start_or_d1 <= 0;
			rx_done_or_d1 <= 0;
			rx_crc_rslt_or_d1 <= 0;
		end
	else begin
		rx_start_or_d1 <= rx_start_or;
		rx_done_or_d1 <= rx_done_or;
		rx_crc_rslt_or_d1 <= rx_crc_rslt_or;
	end
end

always @ (posedge sys_clk)
begin
	if(rst)
		begin
			o_rx_start <= 0;
			o_rx_crc_rslt <= 0;
		end
	else begin
		o_rx_start <= rx_start_or & ~rx_start_or_d1;
		o_rx_done <= rx_done_or & ~rx_done_or_d1;
		o_rx_crc_rslt <= rx_crc_rslt_or & ~rx_crc_rslt_or_d1;
	end
end

RX_link_top RX_link_top(
	.clk(sys_clk),
	.wclk(clk_phy_p0),
	.clk_phy_p0(clk_phy_p0),
	.clk_phy_p90(clk_phy_p90),
	.clk_phy_p180(clk_phy_p180),
	.clk_phy_p270(clk_phy_p270),
	.rst(rst),
	.rx_buf_rden(rx_buf_rden),
	.rx_buf_raddr(rx_buf_raddr),
	.rx_buf_rdata(rx_buf_rdata),
	.rx_crc_rslt(rx_crc_rslt),
	.rx_start(rx_start),
	.rx_done(rx_done),
	.lb_rxd(lb_rxd)
);

endmodule