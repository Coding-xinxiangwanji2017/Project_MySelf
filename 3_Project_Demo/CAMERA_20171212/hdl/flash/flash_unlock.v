`include "flash_head.v"

module flash_unlock
(
	input             clk           ,
	input             rst_n         ,
	input             unlock_en     ,
	output reg        unlock_done   ,
	input     [24:0]  block_addr    ,
	output reg[24:0]  A             ,
	input     [15:0]  dq_i          ,
	output reg[15:0]  dq_o          ,
	output reg        dqe           ,
	output reg        oe            ,
	output reg        ce            ,
	output reg        we            ,
	output reg        adv           ,
	output reg        wp            ,
	input             wd            ,
	output reg        rst_f         
);
	
	reg [4:0] unlock_sta;
	reg [24:0] unlock_addr;
	reg [7:0] cnt;
	reg [5:0] x;
	reg [9:0] z;
	
	always @ (posedge clk)
	if(!rst_n)
		begin
			unlock_sta <= 5'd0;
			rst_f <= 0;
		end
	else 
		case(unlock_sta)
			0	:	begin
						rst_f <= 1;
						oe <= 1;
						ce <= 1;
						adv <= 1;
						we <= 1;
						unlock_done <= 0;
						cnt <= 0;
						x <= 0;
						z <= 10'd63;    /////////////////63
						unlock_addr <= 25'd0;
						A <= 25'd0;
						dqe <= 0;
						dq_o <= 16'd0;
						if(unlock_en)
							unlock_sta <= unlock_sta + 1;
					end
			1	:	begin
						unlock_addr <= block_addr;
						unlock_sta <= unlock_sta + 1;
						if(block_addr == 25'h1000000)
							z <= 0;
					end
			2	:	begin
						if(cnt == `tRST - 1)
							begin
								unlock_sta <= unlock_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end
			3	:	begin
						ce <= 0;
						adv <= 0;
						A  <= unlock_addr;
						if(cnt == `tVLVH - 1)
							begin
								unlock_sta <= unlock_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end
			4	:	begin
						we <= 0;
						adv <= 1;
						if(cnt == `tDVWH - 1)
							begin
								unlock_sta <= unlock_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end
			5	:	begin
						dq_o <= 16'h60;
						dqe <= 1;
						if(cnt == `tWLWH - 1)
						begin
							unlock_sta <= unlock_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end
			6	:	begin
						we <= 1;
						ce <= 1;
						unlock_sta <= unlock_sta + 1;
					end		
			
			7	:	begin
						dq_o <= 16'd0;
						dqe <= 0;
						A <= 25'd0;
						if(cnt == `tWHWL - 1)
						begin
							unlock_sta <= unlock_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end					
			8	:	begin
						A <= unlock_addr;
						adv <= 0;
						ce <= 0;
						if(cnt == `tVLVH - 1)
						begin
							unlock_sta <= unlock_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end					
			9	:	begin
						adv <= 1;
						we <= 0;
						if(cnt == `tDVWH - 1)
							begin
								unlock_sta <= unlock_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end	
			10	:	begin
						dq_o<= 16'hd0;
						dqe <= 1;
						if(cnt == `tWLWH - 1)
						begin
							unlock_sta <= unlock_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end	
		11	: begin
						we <= 1;
						ce <= 1;
						unlock_sta <= unlock_sta + 1;
					end			
		12	:	begin
						dq_o <= 16'd0;
						dqe <= 0;
						A <= 25'd0;
						if(cnt == `tWHWL - 1)
						begin
							unlock_sta <= unlock_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
			13	:	begin
							A <= unlock_addr;
							adv <= 0;
							ce <= 0;
							if(cnt == `tVLVH - 1)
							begin
								unlock_sta <= unlock_sta + 1;
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
									unlock_sta <= unlock_sta + 1;
									cnt <= 0;
								end
							else 
								cnt <= cnt + 1;
						end	
			15	:	begin
							dq_o <= 16'hff;
							dqe <= 1;
							if(cnt == `tWLWH - 1)
							begin
								unlock_sta <= unlock_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
						end	
			16	:	begin
							we <= 1;
							ce <= 1;
							unlock_sta <= unlock_sta + 1;
						end
			17	:	begin
							dq_o <= 16'd0;
							dqe <= 0;
							A <= 25'd0;
							if(x == z)             //////`nBLOCK - 1/////
								begin
									unlock_sta <= 5'd18;
									unlock_done <= 1;	
								end
							else 
								begin
									unlock_addr <= unlock_addr + 25'h20000;
									x <= x + 1;
									unlock_sta <= 5'd2;
							end
						end	
			18	:	begin
							if(cnt == 5'd20)
								begin
									unlock_sta <= 5'd0;
									cnt <= 0;
								end
							else 
								cnt <= cnt + 1;	
						end			
		endcase

endmodule