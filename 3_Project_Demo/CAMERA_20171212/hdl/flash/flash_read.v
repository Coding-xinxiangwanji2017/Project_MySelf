`include "flash_head.v"

module flash_read
(
	input              clk        ,
	input              rst_n      ,
	input              read_en    ,
	output wire[4:0]   read_st    , 
	output wire[7:0]   read_cnt   ,
	output reg         read_done  ,
	input     [24:0]   rd_addr    ,
	output reg[15:0]   read_out   ,
	output reg         fifo_wr    ,
	output reg[24:0]   A          ,
	input     [15:0]   dq_i       ,
	output reg [15:0]  dq_o       ,
	output reg         dqe        ,	
	output reg         oe         ,
	output reg         ce         ,
	output reg         we         ,
	output reg         adv        ,
	output reg         wp         ,
	input              wd         ,
	output reg         rst_f
);
	
	reg [4:0] read_sta;
	reg [24:0] read_addr;
	reg [7:0] cnt;
	reg [14:0] cnt_data;
	reg [14:0] z;

  assign read_cnt = cnt;
  assign read_st  = read_sta;
	
	always @ (posedge clk)
	if(!rst_n)
		begin
			read_sta <= 4'd0;
			rst_f <= 0;
		end
	else 
		case(read_sta)
			0	:	begin
						rst_f <= 1;
						oe <= 1;
						ce <= 1;
						adv <= 1;
						we <= 1;
						read_done <= 0;
						read_out <= 16'd0;
						cnt <= 0;
						cnt_data <= 0;
						z <= 15'd2070;//////////////////////
						fifo_wr <= 0;
						A <= 25'd0;
						dq_o <= 16'd0;
						dqe <= 0;
						if(read_en)
							read_sta <= read_sta + 1;
					end
			1	:	begin
						read_addr <= rd_addr;
						read_sta <= read_sta + 1;
						if(rd_addr == 25'h1000000)
							z <= 15'd1558;
					end
											
			2	:	begin
						ce <= 0;
						adv <= 0;
						A  <= 25'h2532;
						if(cnt == `tVLVH - 1)
							begin
								read_sta <= read_sta + 1;
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
								read_sta <= read_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end
			4	:	begin
						dq_o <= 16'h60;
						dqe <= 1;
						if(cnt == `tWLWH - 1)
						begin
							read_sta <= read_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end
			5	:	begin
						we <= 1;
						ce <= 1;
						read_sta <= read_sta + 1;
					end
			6	:	begin
						dq_o <= 16'd0;
						dqe <= 0;
						A <= 25'd0;
						if(cnt == `tWHWL - 1)
						begin
							read_sta <= read_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
			7	:	begin
						A <= 25'h4A64;
						adv <= 0;
						ce <= 0;
						if(cnt == `tVLVH - 1)
						begin
							read_sta <= read_sta + 1;
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
								read_sta <= read_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end	
			9	:	begin
						dq_o <= 16'h03;
						dqe <= 1;
						if(cnt == `tWLWH - 1)
						begin
							read_sta <= read_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end	
			10	:	begin
						we <= 1;
						ce <= 1;
						read_sta <= read_sta + 1;
					end		
			11	:	begin
						dq_o <= 16'd0;
						dqe <= 0;
						A <= 25'd0;
						if(cnt == `tWHWL - 1)
						begin
							read_sta <= read_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
					
			12	:	begin
						A <= read_addr;
						adv <= 0;
						ce <= 0;
						if(cnt == `tVLVH - 1)
						begin
							read_sta <= read_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end					
			13	:	begin
						adv <= 1;
						we <= 0;
						if(cnt == `tDVWH - 1)
							begin
								read_sta <= read_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end	
			14	:	begin
						dq_o <= 16'hffff;
						dqe <= 1;
						if(cnt == `tWLWH - 1)
						begin
							read_sta <= read_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end	
			15	:	begin
						we <= 1;
						ce <= 1;
						read_sta <= read_sta + 1;
					end		
			16	:	begin
						dq_o <= 16'd0;
						dqe <= 0;
						A <= 25'd0;
						if(cnt == `tWHEL - 1)      
						begin
							read_sta <= read_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
			
		17	:	begin
						adv <= 0;
						ce <= 0;
						oe <= 0;
						A <= read_addr;
						if(cnt == `tVLVHC - 1)   
						begin
							read_sta <= read_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
		 18	:	begin         
						adv <= 1;
						if(cnt == 4'd5)  
							begin
								read_sta <= read_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;	
					end	
		 19	:	begin
						A <= 25'd0;
						if(cnt == 4'd3)
							begin
								read_sta <= read_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;	
					end
		 20	:	begin
						if(cnt_data == z)         
							begin
								fifo_wr <= 0;
								read_done <= 1;
								read_sta <= 5'd21;
							end
						else if(wd)
							begin
							  fifo_wr <= 1;
								read_out <= dq_i;
								cnt_data <= cnt_data + 1;
							end
					end
		 21	:	begin
						rst_f <= 0;
						if(cnt == 5'd10)
						begin
							read_sta <= 5'd0;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
		
		endcase	


endmodule 
