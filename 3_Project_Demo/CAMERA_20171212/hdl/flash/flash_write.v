`include "flash_head.v"

module flash_write
(
	input               clk         ,
	input               rst_n       ,
	input               write_en    ,
	output reg          write_done  ,
	input     [24:0]    wr_addr     ,
	input     [24:0]    block_addr  ,
	input     [15:0]    write_in    , 
	output reg          fifo_rd     ,	
	output reg[24:0]    A           ,
	input     [15:0]    dq_i        ,
	output reg[15:0]    dq_o        ,
	output reg          dqe         ,	
	output reg          oe          ,
	output reg          ce          ,
	output reg          we          ,
	output reg          adv         ,
	output reg          wp          ,
	input               wd          ,
	output reg          rst_f
);

	reg [15:0] SR;
	
	reg [4:0] write_sta;
	reg [24:0] write_addr;
	reg [24:0] word_addr;
	
	reg [7:0] cnt;
	reg [9:0] x;
	reg [3:0] y;
	reg [9:0] z;
	reg [3:0] n;
	
	always @ (posedge clk)
	if(!rst_n)
		begin
			write_sta <= 4'd0;
			rst_f <= 0;
		end
	else
		case(write_sta)
			0	:	begin
						rst_f <= 1;
						oe <= 1;
						ce <= 1;
						adv <= 1;
						we <= 1;
						write_done <= 0;
						cnt <= 0;
						x <= 0;
						y <= 0;
						z <= 10'd511;
						n <= 4'd4;
						write_addr <= 25'd0;
						word_addr <= 25'd0;
						A <= 25'd0;
						dqe <= 0;
						dq_o <= 0;
						if(write_en)
							write_sta <= write_sta + 1;
					end
			1	:	begin
						write_addr <= wr_addr;
						word_addr <= wr_addr;
						if(block_addr == 25'h1000000)
							n <= 4'd3;
						write_sta <= write_sta + 1;
					end
			2	:	begin
						ce <= 0;
						adv <= 0;
						A <= block_addr;///write_addr;
						if(cnt == `tVLVH - 1)
							begin
								write_sta <= write_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end
			3	:	begin
						we <= 0;
						adv <= 1;
						if(cnt == `tDVWH - 1)
							begin
								write_sta <= write_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end
			4	:	begin
						dq_o  <= 16'he9;
						dqe <= 1;
						if(cnt == `tWLWH - 1)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end
			5	:	begin
						we <= 1;
						ce <= 1;
						if(cnt == 4'd3)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end
			6	:	begin
						dq_o  <= 16'd0;
						dqe <= 0;
						if(cnt == `tWHWL - 1)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
			7	:	begin
						A <= write_addr;
						adv <= 0;
						ce <= 0;
						if(cnt == `tVLVH - 1)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end					
			8	:	begin
						adv <= 1;
						we <= 0;
						if(cnt == `tDVWH - 1)
							begin
								write_sta <= write_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end	
			9	:	begin
						dq_o  <= z;
						dqe <= 1;
						if(cnt == `tWLWH - 1)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end	
		10	:	begin
						we <= 1;
						ce <= 1;
						if(cnt == 4'd3)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end		
		11	:	begin
						dq_o  <= 16'd0;
						dqe <= 0;
						A <= 25'd0;
						if(cnt == `tEHEL - 1)
						begin
							write_sta <= write_sta + 1;
							//write_done <= 1;									//write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end
		12	:	begin
						fifo_rd <= 1;	
						write_sta <= write_sta + 1;
					end		
		13	:	begin
						fifo_rd <= 0;	
						A <= word_addr;
						adv <= 0;
						ce <= 0;
						if(cnt == `tVLVH - 1)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end					
		14	:	begin
						adv <= 1;
						we <= 0;
						if(cnt == `tDVWH - 1)
							begin
								write_sta <= write_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end	
		15	:	begin
						dq_o  <= write_in;
						dqe <= 1;
						if(cnt == `tWLWH - 1)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end	
			
		16	:	begin
						we <= 1;
						ce <= 1;
						if(cnt == 4'd3)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end
							
		17	:	begin
						dq_o  <= 16'd0;
						dqe <= 0;
						A <= 25'd0;
						if(cnt == `tEHEL - 1)
						begin
							if(x == z)                 ///512 - 1
								begin
									write_sta <= write_sta + 1;
									cnt <= 0;
								end
							else
								begin
									word_addr <= word_addr + 1;
									x <= x + 1;
									write_sta <= 5'd10;
								end
						end
					else 
						cnt <= cnt + 1;	
					end	
		18	:	begin
						A <= write_addr;
						adv <= 0;
						ce <= 0;
						if(cnt == `tVLVH - 1)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end					
		19	:	begin
						adv <= 1;
						we <= 0;
						if(cnt == `tDVWH - 1)
							begin
								write_sta <= write_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end	
		20	:	begin
						dq_o  <= 16'hd0;
						dqe <= 1;
						if(cnt == `tWLWH - 1)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end	
		21	:	begin
						we <= 1;
						ce <= 1;
						if(cnt == 4'd3)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end			
		22	:	begin
						dq_o <= 16'd0;
						dqe <= 0;
						A <= 25'd0;
						if(cnt == `tEHEL - 1)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
		23	:	begin
						A <= block_addr;
						ce <= 0;
						if(cnt == `tAVQV - 1)
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
		24	:	begin
					oe <= 0;
					if(cnt == 4'd6)            //yanchi 00d0
						begin
							write_sta <= write_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
				end
		25  :	begin
//					if(wait_data)
//						begin
								SR <= dq_i; 
								write_sta <= write_sta + 1;		
//						end							
					end
		26  :	begin
						oe <= 1;
						ce <= 1;
						if(SR[7] && (y == n))      
							begin
								write_done <= 1;
								write_sta <= 5'd27;
							end
						else if(SR[7])		
							begin	
								y <= y + 1;
								word_addr <= word_addr + 1;
								write_addr <= write_addr + 10'h200;
								x <= 0;
								SR <= 0;
								if(y == 4'd3 && (block_addr != 25'h1000000))
									z <= 10'd21;
								write_sta <= 5'd2;
							end
						else 
							write_sta <= 5'd23;//////////////22
					end
		27	:	begin
						if(cnt == 5'd20)
						begin
							write_sta <= 5'd0;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
		endcase

endmodule