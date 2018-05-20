//s_link_rx.v
//检测rx_done，判断crc正确与否，正确则读取CMD输出，如果CMD为读或者写则读取ADDR并根据ADDR读取DATA数据存储到内存中
module s_link_rx(

	input clk,
	input rst,
	
	input i_rx_start,
	input i_rx_done,
	input [1:0] i_crc_rslt,
	output reg o_rx_buf_rden,
	output reg [10:0] o_rx_buf_raddr,
	input [7:0] i_rx_buf_rdata,
	
	output reg o_got_frame,
	output reg [7:0] o_cmd_frame,
	
	output reg o_sl_rxbuf_wren,
	output reg [10:0] o_sl_rxbuf_waddr,
	output reg [7:0] o_sl_rxbuf_wdata
	
);

//---------------------------------------------------------------------------------//
//                                     parameter decalre
//---------------------------------------------------------------------------------//

parameter head_len = 5;
//指令声明
parameter not_use = 8'hff;
parameter ping_req = 8'h01;
parameter ping_resp = 8'h10;
parameter ready_req = 8'h02;
parameter ready_resp = 8'h20;
parameter wr_req = 8'h06;
parameter wr_ready = 8'h60;
parameter write = 8'h70;
parameter wr_sucess = 8'h66;
parameter wr_fail = 8'h77;
parameter rd_req = 8'h08;
parameter rd_ready = 8'h80;
parameter read = 8'h90;
parameter rd_sucess = 8'h88;
parameter rd_fail = 8'h99;

//---------------------------------------------------------------------------------//
//                                     reg/wire
//---------------------------------------------------------------------------------//


reg shift_en_d1;
reg shift_en_d2;
reg shift_en_d3;
reg wr_en_d1;
reg wr_en_d2;
reg wr_en_d3;
reg [8*head_len - 1:0] r_head;
wire wr_addr_rst;
reg [10:0] wr_addr;

reg [3:0] state;
parameter idle = 4'b0000;
parameter s0 = 4'b0001;
parameter s1 = 4'b0010;
parameter s2 = 4'b0100;
parameter s3 = 4'b1000;

reg [15:0] cnt;
reg [15:0] ini_wr_addr;
reg shift_en;
reg wr_en;


//---------------------------------------------------------------------------------//
//                                     fsm
//---------------------------------------------------------------------------------//

always @ (posedge clk)
begin
	if(rst)
		begin
			state <= idle;
			cnt <= 0;
			o_rx_buf_rden <= 0;
			o_rx_buf_raddr <= 0;
			o_got_frame <= 0;
			o_cmd_frame <= 0;
			ini_wr_addr <= 0;
			shift_en <= 0;
			wr_en <= 0;
		end
	else begin
		case(state)
			idle	:	begin
								if(i_rx_done && i_crc_rslt == 2'b01)
									begin
										state <= s0;
										o_rx_buf_rden <= 1;
										shift_en <= 1;
										cnt <= 0;
										o_rx_buf_raddr <= 0;
									end
								else begin
									state <= idle;
								end
							end
							
			s0		:	begin
								if(cnt >= head_len - 1)
									begin
										state <= s1;
										o_rx_buf_rden <= 0;
										shift_en <= 0;
										cnt <= 0;
									end
								else begin
									state <= s0;
									cnt <= cnt + 1;
									o_rx_buf_raddr <= o_rx_buf_raddr + 1;
								end
							end
							
			s1		:	begin
								if(cnt >= 2)
									begin
										state <= s2;
										o_got_frame <= 1;
										o_cmd_frame <= r_head[8*head_len - 1:8*(head_len - 1)];
										ini_wr_addr <= r_head[8*(head_len - 1) - 1:8*(head_len - 3)]; 
										cnt <= 0;
									end
								else begin
									state <= s1;
									cnt <= cnt + 1;
								end
							end
							
			s2		:	begin
								if(o_cmd_frame == write || o_cmd_frame == read)
									begin
										state <= s3;
										o_rx_buf_rden <= 1;
										wr_en <= 1;
										cnt <= 0;
										o_got_frame <= 0;
										o_rx_buf_raddr <= head_len;
									end
								else begin
									state <= idle;
									cnt <= 0;
									o_got_frame <= 0;
								end
							end
							
			s3		:	begin
								if(cnt >= 1024 - 1)
									begin
										state <= idle;
										cnt <= 0;
										o_rx_buf_rden <= 0;
										wr_en <= 0;
									end
								else begin
									state <= s3;
									cnt <= cnt + 1;
									o_rx_buf_raddr <= o_rx_buf_raddr + 1;
								end
							end
			
			default	:	state <= idle;
		endcase
	end
end


//---------------------------------------------------------------------------------//
//                                     延迟信号
//---------------------------------------------------------------------------------//

always @ (posedge clk)
begin
	if(rst)
		begin
			shift_en_d1 <= 0;
			shift_en_d2 <= 0;
			shift_en_d3 <= 0;
		end
	else begin
		shift_en_d1 <= shift_en;
		shift_en_d2 <= shift_en_d1;
		shift_en_d3 <= shift_en_d2;		
	end
end

always @ (posedge clk)
begin
	if(rst)
		begin
			wr_en_d1 <= 0;
			wr_en_d2 <= 0;
			wr_en_d3 <= 0;
		end
	else begin
		wr_en_d1 <= wr_en;
		wr_en_d2 <= wr_en_d1;
		wr_en_d3 <= wr_en_d2;		
	end
end

always @ (posedge clk)
begin
	if(rst)
		r_head <= 0;
	else if(shift_en_d2)
		r_head <= {r_head[8*(head_len - 1) - 1:0],i_rx_buf_rdata};
end

//生成写输出信号

assign wr_addr_rst = wr_en_d1 & ~wr_en_d2;

always @ (posedge clk)
begin
	if(rst)
		wr_addr <= 0;
	else if(wr_addr_rst)
		wr_addr <= ini_wr_addr;
	else if(wr_en_d2)
		wr_addr <= wr_addr + 1;
end

always @ (posedge clk)
begin
	if(rst)
		begin
			o_sl_rxbuf_wren <= 0;
			o_sl_rxbuf_waddr <= 0;
			o_sl_rxbuf_wdata	<= 0;
		end
	else begin
		o_sl_rxbuf_wren <= wr_en_d2;
		o_sl_rxbuf_waddr <= wr_addr;
		o_sl_rxbuf_wdata	<= i_rx_buf_rdata;
	end
end


endmodule
