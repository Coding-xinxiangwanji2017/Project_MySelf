`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:02:50 08/02/2016 
// Design Name: 
// Module Name:    moove_fsm 
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
module move_fsm(

	input clk,
	input rst_n,
	input enable,
	input flash_done,
	input empty,
	output wire [8:0] o_state,
//	inout [35:0] CONTROL0, 
	output reg busy,
	output reg done,
	output reg [13:0] row,
	output reg rd_req,
	output reg rd_en,
	output [23:0] sram_waddr,
	output reg wr_req,
	output reg ram_wr,
	output reg fifo_wr,
	output reg [11:0] ram_addr,
	output reg rst_rfifo
);
    
	parameter idle 		 	   = 9'b000_000_001;
	parameter row_sta      = 9'b000_000_010;
	parameter read_req		 = 9'b000_000_100;
	parameter read_req_n	 = 9'b000_001_000;
	parameter read_flash 	 = 9'b000_010_000;
	parameter write_req 	 = 9'b000_100_000;	
	parameter write_sram   = 9'b001_000_000;
	parameter write_ram	   = 9'b010_000_000;
	parameter die          = 9'b100_000_000;
	
	reg [11:0] cnt;
	reg [3:0] cnt1;
	reg [8:0] state;
	reg fifo_wr_r;
	reg ram_wr_r;
	
	reg r_flash_done1;
	reg r_flash_done2;
	
	wire w_flash_done;
	
	always @ (posedge clk)
  begin
  	if(!rst_n)
  		r_flash_done1 <= 0;
  	else
  		r_flash_done1 <= flash_done;
  end	
	
	always @ (posedge clk)
  begin
  	if(!rst_n)
  		r_flash_done2 <= 0;
  	else
  		r_flash_done2 <= r_flash_done1;
  end
  
  assign w_flash_done = (~r_flash_done1) & r_flash_done2;
	
	assign sram_waddr = {2'd0,row[10:0],11'd0};
  assign o_state = state;
	always @ (posedge clk)
	if(!rst_n)
	begin
		state <= idle;
		cnt1 <= 0;
	end
	else
		case(state)
			idle	:	begin
								cnt1 <= 0;
								if(enable)
									state <= row_sta;
								else 
									state <= idle;
							end
		    row_sta     :   begin
		                        if(!enable)
		                            state <= idle;
		                        else 
		                            state <= read_req; 
		                     end
			read_req	:	begin
										if(!enable)
											state <= idle;
										else if(cnt1 == 1)
											begin
												state <= read_req_n;
												cnt1 <= 0;
											end
										else 
											cnt1 <= cnt1 + 1;
									end
			read_req_n	:	begin
											if(!enable)
												state <= idle;
											else if(w_flash_done && (row[13:11] == 3'd3))
												state <= write_ram;
											else if(w_flash_done) 
												state <= read_flash;
										  else
										  	state <= read_req_n;
										end						
			read_flash	:	begin
											if(!enable)
												state <= idle;
											else if(cnt == 12'd2069)
												state <= write_req;
										end	
			write_req		:	begin
											if(!enable)
												state <= idle;
											else
												state <= write_sram;
										end											
			write_sram	:	begin
											if(!enable)
												state <= idle;
											else if(empty)
												state <= read_req;
										end	
			write_ram : begin
										if(!enable)
											state <= idle;
										else if(cnt == 11'd1557)
												state <= die;
									 end	
			die			:		begin
										if(!enable)
											state <= idle;
									end			
			default :  state <= idle;	
											
		endcase 
	
	always @ (posedge clk)
		if(!rst_n)
			begin
				busy <= 0;
				done <= 0;
		    row <= 14'h000;
		    rd_req <= 0;
		    rd_en <= 0;
			  wr_req <= 0;
			  ram_wr_r <= 0;
			  fifo_wr_r <= 0;
           rst_rfifo <= 0; 
		    cnt <= 0;
		   end
		else
			case(state)
				idle	:	begin
									busy <= 0;
									done <= 0;
							    row <= 14'h000;                 ////001,000,0000,0000
							    rd_req <= 0;
							    rd_en <= 0;
								  wr_req <= 0;
								  ram_wr_r <= 0;
								  fifo_wr_r <= 0;
								  cnt <= 0;
                          rst_rfifo <= 0; 
							    cnt <= 0;
							   end
			    row_sta     :   begin
			                    row <= 14'h800;
			                end
				read_req		:	begin
												busy <= 1;
												rd_req <= 1;
												wr_req <= 0;
												rst_rfifo <= 1; 
											end			   
				read_req_n	:	begin
				                rst_rfifo <= 0; 
												rd_req <= 0;  
											end
				read_flash	:	begin
												rd_en <= 1;
												fifo_wr_r <= 1;
												if(cnt == 12'd2069)
													begin
														cnt <= 0;
													end
												else
													cnt <= cnt + 1;
											end	
				write_req		:	begin
												rd_en <= 0;
												fifo_wr_r <= 0;
												wr_req <= 1;
											end			
				write_sram	:	begin
                      wr_req <= 0;
//												if(empty && row == 14'h804)
//													row <= 14'h1800;													
                      if(empty)
													row <= row + 1;
											else
												  row <= row;
											end	
											
				write_ram	:	begin
												rd_en <= 1;
												ram_wr_r <= 1;
												if(cnt == 11'd1557)
													begin
														cnt <= 0;
											end
										else
											cnt <= cnt + 1;

										end	
				die				:	begin
											rd_en <= 0;
											ram_wr_r <= 0;
											busy <= 0;
											done <= 1;
										end	
												
			endcase
			
	always @ (posedge clk)
		if(!rst_n)
			fifo_wr <= 0;
		else
			fifo_wr <= fifo_wr_r;
			
	always @ (posedge clk)
		if(!rst_n)
			ram_wr <= 0;
		else
			ram_wr <= ram_wr_r;
			
	always @ (posedge clk)
		if(!rst_n)
			ram_addr <= 0;
		else if(ram_wr)	
			ram_addr <= ram_addr + 1;
		else
			ram_addr <= 0;
			
		wire [255:0] TRIG0;
		
		assign TRIG0[11:0] = cnt;
	   assign TRIG0[15:12] = cnt1;
	   assign TRIG0[19:16] = state;
	   assign TRIG0[20] = fifo_wr_r;
	   assign TRIG0[21] = ram_wr_r; 
	   assign TRIG0[22] = busy;
	   assign TRIG0[23] = done; 
		assign TRIG0[24] = wr_req;
		assign TRIG0[25] = rst_rfifo;
		assign TRIG0[26] = rd_en;
		assign TRIG0[27] = rd_req;
		assign TRIG0[28] = fifo_wr;
		assign TRIG0[29] = enable;
		assign TRIG0[30] = empty;
		
//		ila ila1 (
//		 .CONTROL(CONTROL0), // INOUT BUS [35:0]
//		 .CLK(clk), // IN
//		 .TRIG0(TRIG0), // IN BUS 
//		 .TRIG1(TRIG1), // IN BUS 
//		 .TRIG2(TRIG2), // IN BUS 
//		 .TRIG3(TRIG3)  // IN BUS 
//	    );

endmodule
