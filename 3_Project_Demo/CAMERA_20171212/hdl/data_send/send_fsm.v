`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:13:24 08/16/2016 
// Design Name: 
// Module Name:    send_fsm 
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
module send_fsm(
    input clk,
    input rst_n,
    input [1:0] rx_full,
    output reg  rx,
    output reg  rom_rd,
    output reg  [12:0] rom_addr,
    output reg  [7:0]  data_change,
	 output reg  data_flag
    );
    
    parameter num = 13'd6;  ////////////  n + 1
    
    reg [15:0] row;
    reg [31:0] sum;
	 reg [15:0] cnt;
	 reg [15:0] count;
	 
	 always @ (posedge clk)
	 if(!rst_n)
	 	cnt <= 0;
	 else if(!rx_full && (count != num + 1)) 
	 	cnt <= cnt + 1;	
	 else
	 	cnt <= 0; 
	 
	 always @ (posedge clk)
	 if(!rst_n)
	 	rom_rd <= 0;
	 else if((count == 0 || count == num) && (cnt >= 35 || cnt ==0))
		rom_rd <= 0;
	 else if(cnt >= 13'd4141 || cnt == 0)
	 	rom_rd <= 0;
	 else
	 	rom_rd <= 1;
	 	
	 always @ (posedge clk)
	 if(!rst_n)
	 	rx <= 0;
	 else 
	 	rx <= rom_rd;	

	 always @ (posedge clk)
	 if(!rst_n)
	 	rom_addr <= 13'd0;
	 else if((count == 0 || count == num) && (cnt >= 35 || cnt <=1))
		rom_addr <= 13'd0;
	 else if(cnt >= 13'd4141 || cnt == 0 || cnt <=1)
	 	rom_addr <= 13'd0;
	 else
	 	rom_addr <= rom_addr + 1; 
	 	
//	 always @ (posedge clk)
//	 if(!rst_n)
//	 	data_change <= 8'd0;
//	 else if(cnt == 13'd18)
//	 	data_change <= row[15:8];
//	 else if(cnt == 13'd19)
//	 	data_change <= row[7:0];
//	 else if(cnt == 13'd4137)
//	 	data_change <= sum[31:24];
//	 else if(cnt == 13'd4138)
//	 	data_change <= sum[23:16];
//	 else if(cnt == 13'd4139)
//	 	data_change <= sum[15:8];
//	 else if(cnt == 13'd4140)
//	 	data_change <= sum[7:0];
		
	 always @ (posedge clk)
	 if(!rst_n)
	 	data_change <= 8'd0;
	 else if(count == 0 || count == num)
		case(cnt)
			17		:	begin
							if(count == 0)
								data_change <= 8'h10;
							else if(count == num)
								data_change <= 8'h11;
						end
			18		:	data_change <= 8'h00;
			32		:	data_change <= sum[31:24];
			33		:	data_change <= sum[23:16];
			34		:	data_change <= sum[15:8];
			35		:	data_change <= sum[7:0];
			default	:	data_change <= 0;
		endcase
	 else
		case(cnt)
			18		:	data_change <= row[15:8];
			19		:	data_change <= row[7:0];
			4138	:	data_change <= sum[31:24];
			4139	:	data_change <= sum[23:16];
			4140	:	data_change <= sum[15:8];
			4141	:	data_change <= sum[7:0];
			default	:	data_change <= 0;
		endcase
	
	 always @ (posedge clk)
	 if(!rst_n)
	 	data_flag <= 0;
	 else if(count == 0 || count == num)
		case(cnt)
			17		:	data_flag <= 1;
			18		:	data_flag <= 1;
			32		:	data_flag <= 1;
			33		:	data_flag <= 1;
			34		:	data_flag <= 1;
			35		:	data_flag <= 1;
			default	:	data_flag <= 0;
		endcase
	 else
		case(cnt)
			18		:	data_flag <= 1;
			19		:	data_flag <= 1;
			4138	:	data_flag <= 1;
			4139	:	data_flag <= 1;
			4140	:	data_flag <= 1;
			4141	:	data_flag <= 1;
			default	:	data_flag <= 0;
		endcase
		
	 always @ (posedge clk)
	 if(!rst_n)
	 	row <= 11'd0;
	 else if(cnt == 13'd4141)
		row <= row + 1;
		
	 always @ (posedge clk)
	 if(!rst_n)
	 	sum <= 11'd0;
	 else if(count == 0)
		sum <= 32'h3c990;
	 else if(count == num)
		sum <= 32'h3c991;		
	 else 
		sum <= 32'h40bc29a + row[15:0];
	 
	 always @ (posedge clk)
	 if(!rst_n)
		count <= 0;
	 else if(cnt == 13'd42 && count == 0)
		count <= count + 1;		
	 else if(cnt == 13'd4141)
		count <= count + 1;
		
endmodule
