`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:44:02 08/03/2016 
// Design Name: 
// Module Name:    neg_clk 
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
module sync_detect(
    input clk_100,
    input rst_n,
    input sync_in_p,
	 input sync_in_n,
	  output o_sync_in,
    output sync_out
    );
	 
	 wire sync_in;
	 reg sync_delay_1;
	 reg sync_delay_2;
	 reg flag;
	 reg [15:0] cnt;
	 wire w_sync_in;

   IBUFGDS u1_BUFG_100M (
       .O (w_sync_in),
       .I (sync_in_p),
       .IB (sync_in_n)
       );
  assign sync_in = ~w_sync_in;
  assign o_sync_in = sync_in;

	always @ (posedge clk_100)
	if(!rst_n)
		sync_delay_1 <= 0;
	else
		sync_delay_1 <= sync_in;
		
	always @ (posedge clk_100)
	if(!rst_n)
		sync_delay_2 <= 0;
	else
		sync_delay_2 <= sync_delay_1;
		
	always @ (posedge clk_100)
	if(!rst_n)
		cnt <= 0;
	else if(sync_in)
		cnt <= cnt + 1;
	else 
		cnt <= 0;
		
	always @ (posedge clk_100)
	if(!rst_n)
		flag <= 0;
	else if(cnt > 13'd3500)
		flag <= 1;
	else if(!sync_delay_2)
		flag <= 0;
		
	assign sync_out = (flag == 1)? (sync_delay_1 ^ sync_delay_2) : 0;

endmodule
