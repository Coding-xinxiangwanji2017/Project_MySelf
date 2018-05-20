`include "flash_head.v"

module flash_erase
(
	input                clk          ,
	input                rst_n        ,
	input                erase_en     ,
	output  reg          erase_done   ,
	input      [24:0]    block_addr   ,
	output  reg[24:0]    A            ,
	input      [15:0]    dq_i         ,
	output  reg[15:0]    dq_o         ,	
	output  reg          dqe          ,
	output  reg          oe           ,
	output  reg          ce           ,
	output  reg          we           ,
	output  reg          adv          ,
	output  reg          wp           ,
	input                wd           ,                
	output  reg          rst_f
);

	reg [15:0] SR;
	
	reg [4:0] erase_sta;
	reg [24:0] erase_addr;
	reg [7:0] cnt;
	reg [5:0] c;
	reg [7:0] z;
	
	always @ (posedge clk)
	if(!rst_n)
		begin
			rst_f <= 0;
			erase_sta <= 5'd0;
		end
	else 
		case(erase_sta)
			0	:	begin
						rst_f <= 1;
						oe <= 1;
						ce <= 1;
						adv <= 1;
						we <= 1;
						erase_done <= 0;
						cnt <= 0;
						c <= 0;
						z <= 10'd63;                 //////////////63
						erase_addr <= 25'd0;
						A <= 25'd0;
						dq_o <= 16'd0;
						dqe <= 0;
						if(erase_en)
							erase_sta <= erase_sta + 1;
					end
			1	:	begin
						erase_addr <= block_addr;
						erase_sta <= erase_sta + 1;
						if(block_addr == 25'h1000000)
							z <= 0;
					end
			2	:	begin
						ce <= 0;
						adv <= 0;
						A  <= erase_addr;
						if(cnt == `tVLVH - 1)
							begin
								erase_sta <= erase_sta + 1;
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
								erase_sta <= erase_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end
			4	:	begin
						dq_o <= 16'h20;
						dqe <= 1;
						if(cnt == `tWLWH - 1)
						begin
							erase_sta <= erase_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end
			5	:	begin
						we <= 1;
						ce <= 1;
						erase_sta <= erase_sta + 1; 
					end
			6	:	begin
						dq_o <= 16'd0;
						dqe <= 0;
						A <= 25'd0;
						if(cnt == `tWHWL - 1)
						begin
							erase_sta <= erase_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
			7	:	begin
						A <= erase_addr;
						adv <= 0;
						ce <= 0;
						if(cnt == `tVLVH - 1)
						begin
							erase_sta <= erase_sta + 1;
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
								erase_sta <= erase_sta + 1;
								cnt <= 0;
							end
						else 
							cnt <= cnt + 1;
					end	
			9	:	begin
						dq_o <= 16'hd0;
						dqe <= 1;
						if(cnt == `tWLWH - 1)
						begin
							erase_sta <= erase_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
					end	
		10	:	begin
						we <= 1;
						ce <= 1;
						erase_sta <= erase_sta + 1;
					end		
		11	:	begin
						dq_o <= 16'd0;
						dqe <= 0;
						A <= 25'd0;
						if(cnt == `tEHEL - 1)
						begin
							erase_sta <= erase_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
		12	:	begin
						A <= erase_addr;
						ce <= 0;
						if(cnt == `tAVQV - 1)
						begin
							erase_sta <= erase_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
		13	:	begin
					oe <= 0;
					if(cnt == 4'd6)            //yanchi 00d0
						begin
							erase_sta <= erase_sta + 1;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;
				end	
		14  :	begin
					erase_sta <= erase_sta + 1;
					if(wd)                          //////////////////
							SR <= dq_i; 										
					end
		15  :	begin
						oe <= 1;
						ce <= 1;
						if(SR[7] && (c == z))    //////////`nBLOCK - 1
							begin
								erase_done <= 1;
								erase_sta <= 5'd16;
							end
						else if(SR[7])		
							begin	
								c <= c + 1;
								erase_addr <= erase_addr + 25'h20000;
								erase_sta <= 5'd2;
							end
						else 
							erase_sta <= 5'd12;
					end
		16	:	begin
						if(cnt == 3)
						begin
							erase_sta <= 5'd0;
							cnt <= 0;
						end
					else 
						cnt <= cnt + 1;	
					end	
		endcase

endmodule 