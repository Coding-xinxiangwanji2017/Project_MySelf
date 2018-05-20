//`include "s_link_tx_head"
//该模块包括主控状态机用于产生其他块的控制信号，其它块包括：帧头生成模块（根据输入的CMD生成帧头，分三种情况）、
//写发送缓冲区RAM块（根据主控状态机的切换信号、移位使能信号和读数据信号生成写使能和写数据）、读发送数据缓存区块、读写CMD检测块。
module tx_ctrl(
	
	input clk,
	input rst,
	
	input i_ini_dvalid,
	input [7:0] i_ini_data,
	input i_tx_en,
	input [15:0] i_tx_addr,
	input [7:0] i_tx_cmd,
	
	output reg o_sl_txbuf_rden,
	output reg [10:0] o_sl_txbuf_raddr,	
	input [7:0] i_sl_txbuf_rdata,
	
	output reg o_tx_start,
	output reg [10:0] o_tx_data_len,
	output reg o_txbuf_wren,
	output reg [10:0] o_txbuf_waddr,
	output reg [7:0] o_txbuf_wdata

);

//---------------------------------------------------------------------------------//
//                                     parameter decalre
//---------------------------------------------------------------------------------//
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
parameter num_wr = 2;
parameter head_len = 5;


//---------------------------------------------------------------------------------//
//                                     tx_ctrl fsm
//---------------------------------------------------------------------------------//
reg [5:0] state;
parameter idle = 6'b000000;
parameter s0 = 6'b000001;
parameter s1 = 6'b000010;
parameter s2 = 6'b000100;
parameter s3 = 6'b001000;
parameter s4 = 6'b010000;
parameter s5 = 6'b100000;


reg shift_en;
reg shift_en_d1;
reg [1:0] d_switch;

reg [15:0] cnt1;

reg [15:0] r_tx_addr;
reg [7:0] r_tx_cmd;
reg [8*head_len-1:0]r_head;
reg [8*head_len-1:0]r_head_d1;
reg o_sl_txbuf_rden_d1;
reg o_sl_txbuf_rden_d2;
reg [3:0] cnt_wr_cmd;
reg [31:0] r_ver_num;
reg [15:0] cmd_data;
reg [10:0] wr_addr1;
reg [10:0] wr_addr1_d1;
reg [10:0] wr_addr1_d2;
reg wr_en;
reg wr_en_d1;
reg wr_en_d2;
reg head_done_flag;

always @ (posedge clk)
begin
	if(rst)
		begin
			state <= idle;
			o_tx_start <= 0;
			o_tx_data_len <= 0;
			cnt1 <= 0;
			d_switch <= 2'b00;
			o_sl_txbuf_rden <= 0;
			o_sl_txbuf_raddr <= 0;
			shift_en <= 0;
			wr_addr1 <= 0;
			head_done_flag <= 0;
			wr_en <= 0;
		end
	else begin
		case(state)
			idle	:	begin
							 	if(i_tx_en)
							 		begin
							 			state <= s0;
							 			cnt1 <= 0;
							 		end
							 	else begin
							 		state <= idle;
							 		o_tx_start <= 0;
								end
							end
			
			s0	:	begin	//等待帧头生成块完成帧的生成，计时等待
							if(cnt1 >= 4)
								begin
									state <= s1;
									shift_en <= 1;
									head_done_flag <= 1;
									cnt1 <= 0;
									wr_addr1 <= 0;
									d_switch <= 2'b01;
								end
							else begin
								state <= s0;
								cnt1 <= cnt1 + 1;
							end
						end
						
			s1	: begin	//生成移位信号会输出给写发送缓冲区块写使能和写地址
							if(cnt1 >= head_len - 1)
								begin
									state <= s2;
									cnt1 <= 0;
									shift_en <= 0;
								end
							else begin
								state <= s1;
								cnt1 <= cnt1 + 1;
								wr_addr1 <= wr_addr1 + 1;
								head_done_flag <= 0;
							end
						end
						
			s2	:	begin
							if(cnt1 >= 4)
								begin
									state <= s3;
									cnt1 <= 0;
								end
							else begin
								state <= s2;
								cnt1 <= cnt1 + 1;
							end
						end			
			s3	:	begin	//判断CMD指令类型，看是长帧还是短帧
							o_tx_start <= 1;
							wr_addr1 <= head_len;
							if(r_tx_cmd == write || r_tx_cmd == read)
								begin
									state <= s4;
									o_sl_txbuf_rden <= 1;
									o_sl_txbuf_raddr <= r_tx_addr[10:0];
									o_tx_data_len <= head_len + 1024;
									d_switch <= 2'b10;
								end
							else begin
								state <= s5;
								wr_en <= 1;
								o_tx_data_len <= head_len + 16;
								d_switch <= 2'b11;
							end
						end
						 
			s4	:	begin
							if(cnt1 >= 1024 - 1)
								begin
									state <= idle;
									o_sl_txbuf_rden <= 0;
								end
							else begin
								state <= s4;
								cnt1 <= cnt1 + 1;
								o_sl_txbuf_raddr <= o_sl_txbuf_raddr + 1;
								wr_addr1 <= wr_addr1 + 1;
								o_tx_start <= 0;
							end
						end
						
			s5	:	begin
							if(cnt1 >= 16 - 1)
								begin
									state <= idle;
									wr_en <= 0;
								end
							else begin
								state <= s5;
								wr_addr1 <= wr_addr1 + 1;
								cnt1 <= cnt1 + 1;
								o_tx_start <= 0;
							end
						end
						 
			default : state <= idle;
		endcase
	end
end



//---------------------------------------------------------------------------------//
//                                     写发送缓冲区RAM
//---------------------------------------------------------------------------------//
//该块根据d_switch的不同选择不同的信号作为写使能和写地址

always @ (posedge clk)
begin
	if(rst)
		o_txbuf_wren <= 0;
	else begin
		case(d_switch)
			2'b10	:	o_txbuf_wren <= o_sl_txbuf_rden_d2;
			2'b11	:	o_txbuf_wren <= wr_en_d2;
			2'b01	:	o_txbuf_wren <= shift_en_d1;
			default :	o_txbuf_wren <= 0;
		endcase
	end
end

always @ (posedge clk)
begin
	if(rst)
		o_txbuf_waddr <= 0;
	else begin
		case(d_switch)
			2'b10	:	o_txbuf_waddr <= wr_addr1_d2;
			2'b11	:	o_txbuf_waddr <= wr_addr1_d2;
			2'b01	:	o_txbuf_waddr <= wr_addr1_d1;
			default :	o_txbuf_waddr <= 0;
		endcase
	end
end

always @ (posedge clk)
begin
	if(rst)
		o_txbuf_wdata <= 0;
	else begin
		case(d_switch)
			2'b10	:	o_txbuf_wdata <= i_sl_txbuf_rdata;
			2'b11	:	o_txbuf_wdata <= 8'h5a;
			2'b01	:	o_txbuf_wdata <= r_head_d1[8*(head_len)-1:8*(head_len-1)];
			default :	o_txbuf_wdata <= 0;
		endcase
	end
end

always @ (posedge clk)
begin
	if(rst)
		begin
			o_sl_txbuf_rden_d1 <= 0;
			o_sl_txbuf_rden_d2 <= 0;
		end
	else begin
		o_sl_txbuf_rden_d1 <= o_sl_txbuf_rden;
		o_sl_txbuf_rden_d2 <= o_sl_txbuf_rden_d1;
	end
end

always @ (posedge clk)
begin
	if(rst)
		begin
			wr_en_d1 <= 0;
			wr_en_d2 <= 0;
		end
	else begin
		wr_en_d1 <= wr_en;
		wr_en_d2 <= wr_en_d1;
	end
end

always @ (posedge clk)
begin
	if(rst)
		begin
			wr_addr1_d1 <= 0;
			wr_addr1_d2 <= 0;
		end
	else begin
		wr_addr1_d1 <= wr_addr1;
		wr_addr1_d2 <= wr_addr1_d1;
	end
end

always @ (posedge clk)
begin
	if(rst)
		shift_en_d1 <= 0;
	else
		shift_en_d1 <= shift_en;
end


//缓存接收到的addr和CMD

always @ (posedge clk)
begin
	if(rst)
		begin
			r_tx_addr <= 0;
			r_tx_cmd <= 0;
		end
	else if(i_tx_en)
		begin
			r_tx_addr <= i_tx_addr;
			r_tx_cmd <= i_tx_cmd;
		end
end

//---------------------------------------------------------------------------------//
//                                     生成CMD_DATA
//---------------------------------------------------------------------------------//
//读写指令计数器在检测到读写指令之后进行更新+1，ping指令或者ping_req会重置该计数器


always @ (posedge clk)
begin
	if(rst)
		cnt_wr_cmd <= 0;
	else if(i_tx_en && (i_tx_cmd == ping_req || i_tx_cmd == ping_resp))
		cnt_wr_cmd <= 0;
	else if(i_tx_en && (i_tx_cmd == write || i_tx_cmd == read))
		cnt_wr_cmd <= cnt_wr_cmd + 1;
end

always @ (posedge clk)
	if(rst)
		cmd_data <= 0;
	else if(cnt_wr_cmd == 0)
		cmd_data <= 16'ha55a;
	else if(cnt_wr_cmd == num_wr)
		cmd_data <= 16'h55aa;
	else
		cmd_data <= 0;

//---------------------------------------------------------------------------------//
//                                     帧头生成块
//---------------------------------------------------------------------------------//
//该模块根据CMD的不同生成帧头，将帧头装入8*head_len位宽的寄存器中

always @ (posedge clk)
begin
	if(rst)
		r_head <= 0;
	else begin
		case(r_tx_cmd)
			ping_req	:	r_head <= {r_tx_cmd,r_ver_num};
			write,read	: r_head <= {r_tx_cmd,r_tx_addr,cmd_data};
			default		:	r_head <= {r_tx_cmd,32'd0};
		endcase
	end
end

always @ (posedge clk)
begin
	if(rst)
		r_head_d1 <= 0;
	else if(head_done_flag)
		r_head_d1 <= r_head;
	else if(shift_en)
		r_head_d1 <= {r_head_d1[8*(head_len-1)-1:0],r_head_d1[8*(head_len)-1:8*(head_len-1)]};
end

//获取flash内存储的版本号
always @ (posedge clk)
begin
	if(rst)
		r_ver_num <= 0;
	else if(i_ini_dvalid)
		r_ver_num <= {r_ver_num[8*(head_len-1)-1:0],i_ini_data};
end


endmodule