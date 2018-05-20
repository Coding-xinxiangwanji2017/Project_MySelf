`include "flash_head.v"

module flash_fsm
(
	input         clk           ,
	input   		  rst_n         ,
	input [13:0] row_in   ,
	input   		  wr_flash      ,
	input   	     rd_flash      ,
	input  		  era           ,
	output  reg[13:0]      row  ,
	output  reg   unlock_en     ,
	input         unlock_done   ,
	output  reg   erase_en      ,
	input         erase_done    ,
	output  reg   read_en       ,
	input         read_done     ,
	output  reg   write_en      ,
	input         write_done    ,
	output  reg   lock_en       ,
	input         lock_done     ,
	output  reg   done_toe      ,
	output  reg   done_move         
);
	
	reg [3:0] state;
	
	always @ (posedge clk)
	if(!rst_n)
		state <= `idle;
	else 
		case(state)
			`idle		:		begin
										if(era) 
											state <= `unlock;
										else if(wr_flash)
											state <= `write;
										else if(rd_flash)
											state <= `read;
									end
		
			`unlock	:		begin
										if(unlock_done)
											state <= `erase;
										else 
											state <= `unlock;
									end		

			`erase	:		begin
										if(erase_done)
											state <= `idle;
										else 
											state <= `erase;
									end
								
			`write	:		begin
										if(write_done)
											state <= `idle;
										else 
											state <= `write;
									end	
								
			`lock		:		begin
										if(lock_done)
											state <= `idle;
										else 
											state <= `lock;
									end	
											
			`read		:		begin
										if(read_done)
											state <= `idle;
										else 
											state <= `read;
									end
		endcase		
		
	always @ (posedge clk)
	if(!rst_n)
		begin
			unlock_en	<= 0;
			erase_en	<= 0;
			write_en	<= 0;
			lock_en	<= 0;
			read_en	<= 0;
  		done_toe <= 0;
  		done_move <= 0;
		end
	else 
		case(state)
			`idle		:		begin
										unlock_en	<= 0;
										erase_en	<= 0;
										write_en	<= 0;
										lock_en	<= 0;
										read_en	<= 0;
										done_toe <= 0;
										done_move <= 0;
										if(wr_flash || rd_flash || era)
											row <= row_in;
									end
		
			`unlock	:		unlock_en	<= 1;

			`erase	:		begin
										erase_en	<= 1;
										unlock_en <= 0;
										if(erase_done)
											done_toe <= 1;
									end
								
			`write	:		begin
										write_en	<= 1;
										erase_en <= 0;
										unlock_en <= 0;
										if(write_done)
											done_toe <= 1;
									end
								
			`lock		:		begin
										lock_en	<= 1;
										write_en <= 0;
									end
											
			`read		:		begin
										read_en	<= 1;
										write_en <= 0;
										if(read_done)
											done_move <= 1;
									end
		endcase		

endmodule