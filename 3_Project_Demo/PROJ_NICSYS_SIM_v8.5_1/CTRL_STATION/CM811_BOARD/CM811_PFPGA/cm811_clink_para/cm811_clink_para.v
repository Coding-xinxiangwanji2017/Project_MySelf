`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:09:16 05/11/2016 
// Design Name: 
// Module Name:    cm811_clink_para 
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
module cm811_clink_para(
	input					sys_clk,
	input					glbl_rst_n,
	
	input 				init_cons_wren,
	input 	[15:0]	init_cons_addr,
	input 	[7:0]		init_cons_data,
	
	output reg			addr_para_error,
	output reg			addr_para_ok,
	output reg [23:0]	para_addr1,
	output reg [23:0]	para_addr2,
	output reg [23:0]	para_addr3,
	output reg [23:0]	para_addr4,
	output reg [23:0]	para_addr5,
	output reg [23:0]	para_addr6
);

	reg [3:0] checksum;

	
	always @ (posedge sys_clk)//
		if(!glbl_rst_n)
			begin
				addr_para_error <= 0;
			   addr_para_ok <= 0;
			   para_addr1 <= 0;
			   para_addr2 <= 0;
			   para_addr3 <= 0;
			   para_addr4 <= 0;
			   para_addr5 <= 0;
			   para_addr6 <= 0;
			end
		else 	
			begin
				if(init_cons_wren == 1 && init_cons_addr == 16'h400) begin para_addr1[23:16] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h402) begin para_addr1[15:8] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h404) begin para_addr1[7:0] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h480) begin para_addr2[23:16] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h482) begin para_addr2[15:8] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h484) begin para_addr2[7:0] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h500) begin para_addr3[23:16] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h502) begin para_addr3[15:8] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h504) begin para_addr3[7:0] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h580) begin para_addr4[23:16] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h582) begin para_addr4[15:8] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h584) begin para_addr4[7:0] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h600) begin para_addr5[23:16] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h602) begin para_addr5[15:8] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h604) begin para_addr5[7:0] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h680) begin para_addr6[23:16] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h682) begin para_addr6[15:8] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h684) begin para_addr6[7:0] <= init_cons_data; checksum <= init_cons_data[0] + init_cons_data[1] + init_cons_data[2] + init_cons_data[3] + init_cons_data[4] + init_cons_data[5] + init_cons_data[6] + init_cons_data[7]; end
				if(init_cons_wren == 1 && init_cons_addr == 16'h401 && checksum != init_cons_data[7:4]) addr_para_error <= 1;
				if(init_cons_wren == 1 && init_cons_addr == 16'h403 && checksum != init_cons_data[7:4]) addr_para_error <= 1;
				if(init_cons_wren == 1 && init_cons_addr == 16'h405 && checksum != init_cons_data[7:4]) addr_para_error <= 1; 
				if(init_cons_wren == 1 && init_cons_addr == 16'h481 && checksum != init_cons_data[7:4]) addr_para_error <= 1; 
				if(init_cons_wren == 1 && init_cons_addr == 16'h483 && checksum != init_cons_data[7:4]) addr_para_error <= 1; 
				if(init_cons_wren == 1 && init_cons_addr == 16'h485 && checksum != init_cons_data[7:4]) addr_para_error <= 1;  
				if(init_cons_wren == 1 && init_cons_addr == 16'h501 && checksum != init_cons_data[7:4]) addr_para_error <= 1; 
				if(init_cons_wren == 1 && init_cons_addr == 16'h503 && checksum != init_cons_data[7:4]) addr_para_error <= 1; 
				if(init_cons_wren == 1 && init_cons_addr == 16'h505 && checksum != init_cons_data[7:4]) addr_para_error <= 1;  
				if(init_cons_wren == 1 && init_cons_addr == 16'h581 && checksum != init_cons_data[7:4]) addr_para_error <= 1; 
				if(init_cons_wren == 1 && init_cons_addr == 16'h583 && checksum != init_cons_data[7:4]) addr_para_error <= 1; 
				if(init_cons_wren == 1 && init_cons_addr == 16'h585 && checksum != init_cons_data[7:4]) addr_para_error <= 1;  
				if(init_cons_wren == 1 && init_cons_addr == 16'h601 && checksum != init_cons_data[7:4]) addr_para_error <= 1; 
				if(init_cons_wren == 1 && init_cons_addr == 16'h603 && checksum != init_cons_data[7:4]) addr_para_error <= 1; 
				if(init_cons_wren == 1 && init_cons_addr == 16'h605 && checksum != init_cons_data[7:4]) addr_para_error <= 1;  
				if(init_cons_wren == 1 && init_cons_addr == 16'h681 && checksum != init_cons_data[7:4]) addr_para_error <= 1; 
				if(init_cons_wren == 1 && init_cons_addr == 16'h683 && checksum != init_cons_data[7:4]) addr_para_error <= 1; 
				if(init_cons_wren == 1 && init_cons_addr == 16'h685 && checksum != init_cons_data[7:4]) addr_para_error <= 1;  
				if(init_cons_wren == 1 && init_cons_addr == 16'h686 && addr_para_error == 0) addr_para_ok <= 1;
				if(addr_para_ok == 1) addr_para_ok <= 0;
			end

endmodule
