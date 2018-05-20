//`include "s_link_tx_head"

module dia_ctrl(
	
	input clk,
	input rst,
	
	input [3:0] i_slot_id,
	input i_join_start,			//高电平代表开始的令牌环
	input i_console_en,
	input i_got_frame,
	input [7:0] i_cmd_frame,
	output reg [1:0] o_trans_rslt,
		
	output reg o_tx_en,
	output reg [7:0] o_tx_cmd,
	output reg [15:0] o_tx_addr

);


//---------------------------------------------------------------------------------//
//                                     parameter decalre
//---------------------------------------------------------------------------------//

`define slot_id_NPA 6'd14
`define slot_id_NPB 6'd13

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

parameter top_cnt_tds = 15'd400;
parameter top_cnt_tdl = 15'd12000;


//---------------------------------------------------------------------------------//
//                                     reg/wire decalre
//---------------------------------------------------------------------------------//



//---------------------------------------------------------------------------------//
//                                     判断主备和中间信号产生
//---------------------------------------------------------------------------------//

reg host_en;
reg vice_en;

always@(posedge clk)
begin
	if(rst)
		host_en <= 1'b0;
	else if(i_slot_id == `slot_id_NPA)
		host_en <= 1'b1;
end

always@(posedge clk)
begin
	if(rst)
		vice_en <= 1'b0;
	else if(i_slot_id == `slot_id_NPB)
		vice_en <= 1'b1;
end

//中间信号产生
reg console_en_d1;
wire console_en_pos;
reg i_got_frame_d1;
reg i_got_frame_d2;

always @ (posedge clk)
begin
	if(rst)
		console_en_d1 <= 0;
	else
		console_en_d1 <= i_console_en;
end

assign console_en_pos = i_console_en && ~console_en_d1;

always @ (posedge clk)
begin
	if(rst)
		begin
			i_got_frame_d1 <= 0;
			i_got_frame_d2 <= 0;
		end
	else begin
		i_got_frame_d1 <= i_got_frame;
		i_got_frame_d2 <= i_got_frame_d1;
	end
end

//---------------------------------------------------------------------------------//
//                                     主卡会话控制
//---------------------------------------------------------------------------------//
reg tx_en1;
reg [7:0] tx_cmd1;
reg [15:0] tx_addr1;
reg [14:0] cnt1;
reg [2:0] cnt_read;
reg cnt_read_en;
reg cnt_read_rst;
reg [1:0] trans_rslt1;

reg [8:0] state_host;
parameter idle_host = 9'b0_0000_0000;
parameter s0_host = 9'b0_0000_0001;
parameter s1_host = 9'b0_0000_0010;
parameter s2_host = 9'b0_0000_0100;
parameter s3_host = 9'b0_0000_1000;
parameter s4_host = 9'b0_0001_0000;
parameter s5_host = 9'b0_0010_0000;
parameter s6_host = 9'b0_0100_0000;
parameter s7_host = 9'b0_1000_0000;
parameter s8_host = 9'b1_0000_0000;

//主控制器控制状态机
always @ (posedge clk)
begin
	if(rst)
		begin
			state_host <= idle_host;
			trans_rslt1 <= 0;
			tx_en1 <= 0;
			tx_cmd1 <= not_use;
			tx_addr1 <= 0;
			cnt1 <= 0;
			cnt_read_rst <= 1;
			cnt_read_en <= 0;
		end
	else begin
		case(state_host)
			idle_host :	begin
										if(console_en_pos && host_en)
											begin
												state_host <= s0_host;
												trans_rslt1 <= 0;
												tx_addr1 <= 0;
											end
										else begin
											state_host <= idle_host;
											tx_en1 <= 0;
										end
									end
			
			s0_host :	begin		//检测i_console_en，发出ping_req
									if(i_console_en)
										begin
											state_host <= s1_host;
											tx_en1 <= 1;
											tx_cmd1 <= ping_req;
											
											cnt1 <= 0;
										end
									else begin
										state_host <= idle_host;
									end
								end
			
			s1_host : begin		//等待ping_resp，发出ready_req
									if(cnt1 >= top_cnt_tds)
										begin
											state_host <= s0_host;
											cnt1 <= 0;
										end
									else begin
										if(i_got_frame && i_cmd_frame == ping_resp)
											begin
												state_host <= s2_host;
												tx_en1 <= 1;
												tx_cmd1 <= ready_req;
												cnt1 <= 0;
											end
										else begin
											state_host <= s1_host;
											tx_en1 <= 0;
											cnt1 <= cnt1 + 1;
										end
									end
								end
			
			s2_host :	begin		//等待ready_resp，根据i_join_start选择读还是写
									if(cnt1 >= top_cnt_tds)
										begin
											state_host <= s0_host;
										end
									else begin
										if(i_got_frame && i_cmd_frame == ready_resp)
											begin
												cnt1 <= 0;
												tx_en1 <= 1;
												if(i_join_start)
													begin
														state_host <= s3_host;
														tx_cmd1 <= wr_req;
													end
												else begin
													state_host <= s6_host;
													tx_cmd1 <= rd_req;
												end
											end
										else begin
											state_host <= s2_host;
											tx_en1 <= 0;
											cnt1 <= cnt1 + 1;
										end
									end
								end

			s3_host :	begin
									if(cnt1 >= top_cnt_tds)
										begin
											state_host <= s0_host;
										end
									else begin
										if(i_got_frame && i_cmd_frame == wr_ready)
											begin
												state_host <= s4_host;
												tx_en1 <= 1;
												tx_cmd1 <= write;
												tx_addr1 <= 0;
												cnt1 <= 0;
											end
										else begin
											state_host <= s3_host;
											tx_en1 <= 0;
											cnt1 <= cnt1 + 1;
										end
									end
								end
			
			s4_host :	begin
									if(cnt1 >= top_cnt_tdl / 2)
										begin
											state_host <= s5_host;
											tx_en1 <= 1;
											tx_cmd1 <= write;
											tx_addr1 <= 1024;
											cnt1 <= 0;
										end
									else begin
										state_host <= s4_host;
										tx_en1 <= 0;
										cnt1 <= cnt1 + 1;
									end
								end
			
			s5_host :	begin
									if(cnt1 >= top_cnt_tds / 2 + top_cnt_tdl / 2)
										begin
											state_host <= s0_host;
										end
									else if(i_got_frame && i_cmd_frame == wr_sucess)
										begin
											state_host <= idle_host;
										end
									else if(i_got_frame && i_cmd_frame == wr_fail)
										begin
											state_host <= s0_host;
										end
									else begin
										state_host <= s5_host;
										cnt1 <= cnt1 + 1;
										tx_en1 <= 0;
									end
								end
			
			s6_host :	begin
									if(cnt1 >= top_cnt_tds)
										begin
											state_host <= s0_host;
										end
									else begin
										if(i_got_frame && i_cmd_frame == rd_ready)
											begin
												state_host <= s7_host;
												cnt1 <= 0;
												cnt_read_en <= 1;
												cnt_read_rst <= 1;
											end
										else begin
											state_host <= s6_host;
											tx_en1 <= 0;
											cnt1 <= cnt1 + 1;
										end
									end
								end
			
			s7_host : begin
									if(cnt1 >= top_cnt_tdl)
										begin
											state_host <= s8_host;
											tx_en1 <= 1;
											tx_cmd1 <= rd_fail;
											cnt1 <= 0;
											cnt_read_en <= 0;
										end
									else begin
										if(cnt_read >= 2'd2)
											begin
												state_host <= idle_host;
												tx_en1 <= 1;
												tx_cmd1 <= rd_sucess;
												cnt_read_en <= 0;
												trans_rslt1 <= 2'b10;
											end
										else begin
											state_host <= s7_host;
											tx_en1 <= 0;
											cnt1 <= cnt1 + 1;
											cnt_read_en <= 1;
											cnt_read_rst <= 0;
										end
									end
								end
			
			s8_host : begin
									if(cnt1 >= top_cnt_tds / 2)
										begin
											state_host <= s0_host;
											cnt1 <= 0;
										end
									else begin
										state_host <= s8_host;
										tx_en1 <= 0;
										cnt1 <= cnt1 + 1;
									end
								end
			
			default	:	begin	state_host <= idle_host;	end
		endcase
	end
end

//读指令计数器

always @ (posedge clk)
begin
	if(rst)
		cnt_read <= 0;
	else if(cnt_read_rst)
		cnt_read <= 0;
	else if(cnt_read_en && i_got_frame && i_cmd_frame == read)
		cnt_read <= cnt_read + 1;
end

//---------------------------------------------------------------------------------//
//                                     备卡会话控制
//---------------------------------------------------------------------------------//
reg tx_en3;
reg [7:0] tx_cmd3;
reg [14:0] cnt2;
reg [2:0] cnt_write;
reg cnt_write_en;
reg cnt_write_rst;
reg [1:0] trans_rslt2;
reg tx_en2;
reg [7:0] tx_cmd2;
reg tx_addr2;

reg ping_resp_en;
reg ready_resp_en;

reg [5:0] state_vice;
parameter idle_vice = 6'b00_0000;
parameter s0_vice = 6'b00_0001;
parameter s1_vice = 6'b00_0010;
parameter s2_vice = 6'b00_0100;
parameter s3_vice = 6'b00_1000;
parameter s4_vice = 6'b01_0000;
parameter s5_vice = 6'b10_0000;

//备卡会话状态机
always @ (posedge clk)
begin
	if(rst)
		begin
			state_vice <= idle_vice;
			trans_rslt2 <= 0;
			cnt2 <= 0;
			cnt_write_en <= 0;
			cnt_write_rst <= 1;
			tx_en3 <= 0;
			tx_cmd3 <= 0;
			tx_addr2 <= 0;
		end
	else begin
		case(state_vice)
			idle_vice : begin
										if(console_en_pos && vice_en)
											begin
												state_vice <= s0_vice;
												trans_rslt2 <= 0;
											end
										else begin
											state_vice <= idle_vice;
											tx_en3 <= 0;
										end
									end
					
			s0_vice : begin
									if(!i_console_en)
										begin
											state_vice <= idle_vice;
										end
									else begin
										if(i_got_frame && i_cmd_frame == wr_req)
											begin
												state_vice <= s4_vice;
												tx_en3 <= 1;
												tx_cmd3 <= wr_ready;
												cnt2 <= 0;
												cnt_write_en <= 1;
												cnt_write_rst <= 1;
											end
										else if(i_got_frame && i_cmd_frame == rd_req)
											begin
												state_vice <= s1_vice;
												tx_en3 <= 1;
												tx_cmd3 <= rd_ready;
												cnt2 <= 0;
											end
										else begin
											state_vice <= s0_vice;
											tx_en3 <= 0;
											cnt2 <= 0;
										end
									end
								end

			s1_vice : begin
									if(cnt2 >= top_cnt_tds / 2)
										begin
											state_vice <= s2_vice;
											cnt2 <= 0;
											tx_en3 <= 1;
											tx_cmd3 <= read;
											tx_addr2 <= 0;
										end
									else begin
										state_vice <= s1_vice;
										cnt2 <= cnt2 + 1;
										tx_en3 <= 0;
									end
								end
			
			s2_vice : begin
									if(cnt2 >= top_cnt_tdl / 2)
										begin
											state_vice <= s3_vice;
											cnt2 <= 0;
											tx_en3 <= 1;
											tx_cmd3 <= read;
											tx_addr2 <= 1024;
										end
									else begin
										state_vice <= s2_vice;
										cnt2 <= cnt2 + 1;
										tx_en3 <= 0;
									end
								end
			
			s3_vice : begin
									if(cnt2 >= top_cnt_tds / 2 + top_cnt_tdl / 2)
										begin
											state_vice <= s0_vice;
										end
									else begin
										if(i_got_frame && i_cmd_frame == rd_fail)
											begin
												state_vice <= s0_vice;
											end
										else if(i_got_frame && i_cmd_frame == rd_sucess)
											begin
												state_vice <= idle_vice;
											end
										else begin
											state_vice <= s3_vice;
											tx_en3 <= 0;
											cnt2 <= cnt2 + 1;
										end
									end
								end
			
			s4_vice : begin
									if(cnt2 >= top_cnt_tdl)
										begin
											state_vice <= s0_vice;
											tx_en3 <= 1;
											tx_cmd3 <= wr_fail;
											cnt_write_en <= 0;
										end
									else begin
										if(cnt_write >= 2'd2)
											begin
												state_vice <= idle_vice;
												cnt_write_en <= 0;
												trans_rslt2 <= 2'b10;
												tx_en3 <= 1;
												tx_cmd3 <= wr_sucess;
											end
										else begin
											state_vice <= s4_vice;
											tx_en3 <= 0;
											cnt2 <= cnt2 + 1;
											cnt_write_en <= 1;
											cnt_write_rst <= 0;
										end
									end
								end
			
			default	: state_vice <= idle_vice;
		endcase
	end
end

//计时器和超时标志产生

always @ (posedge clk)
begin
	if(rst)
		cnt_write <= 0;
	else if(cnt_write_rst)
		cnt_write <= 0;
	else if(cnt_write_en && i_got_frame && i_cmd_frame == write)
		cnt_write <= cnt_write + 1;
end

//备卡指令有效信号生成
always @ (posedge clk)
begin
	if(rst)
		ping_resp_en <= 0;
	else if(i_got_frame && i_cmd_frame == ping_req)
		ping_resp_en <= 1;
	else
		ping_resp_en <= 0;
end

always @ (posedge clk)
begin
	if(rst)
		ready_resp_en <= 0;
	else if(i_got_frame && i_cmd_frame == ready_req && i_console_en)
		ready_resp_en <= 1;
	else
		ready_resp_en <= 0;
end

//备卡指令信号生成

always @ (posedge clk)
begin
	if(rst)
		begin
			tx_en2 <= 0;
			tx_cmd2 <= 0;
		end
	else if(ping_resp_en)
		begin
			tx_en2 <= i_got_frame_d1;
			tx_cmd2 <= ping_resp;
		end
	else if(ready_resp_en)
		begin
			tx_en2 <= i_got_frame_d1;
			tx_cmd2 <= ready_resp;
		end
	else begin
		tx_en2 <= tx_en3;
		tx_cmd2 <= tx_cmd3;
	end
end

//---------------------------------------------------------------------------------//
//                                     output select
//---------------------------------------------------------------------------------//

always @ (posedge clk)
begin
	if(rst)
		begin
			o_tx_en <= 0;
			o_tx_cmd <= 0;
			o_trans_rslt <= 0;
			o_tx_addr <= 0;
		end
	else if(host_en)
		begin
			o_tx_en <= tx_en1;
			o_tx_cmd <= tx_cmd1;
			o_trans_rslt <= trans_rslt1;
			o_tx_addr <= tx_addr1;
		end
	else if(vice_en)
		begin
			o_tx_en <= tx_en2;
			o_tx_cmd <= tx_cmd2;
			o_trans_rslt <= trans_rslt2;
			o_tx_addr <= tx_addr2;
		end
	else
		begin
			o_tx_en <= 0;
			o_tx_cmd <= 0;
			o_trans_rslt <= 0;
			o_tx_addr <= 0;
		end
end


endmodule