`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:02 08/09/2016 
// Design Name: 
// Module Name:    pll_100m 
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
module clk_ctrl(
    input clk_100m_p,
	 input clk_100m_n,
	 input rst_n,
    output clk_100m_out,
    output reg locked
    );

  wire rst;
	wire locked_dly1;
	reg locked_dly2;
	reg locked_dly3;
	
	assign rst = ~rst_n;

	pll_100m pll_100m_inst
   (
    .CLK_100m_in_P(clk_100m_p),
    .CLK_100m_in_N(clk_100m_n),    
    .CLK_100m_out(clk_100m_out),     
    .RESET(rst),
    .LOCKED(locked_dly1)
	 ); 	 

	always @ (posedge clk_100m_out)
	if(!rst_n)
		locked_dly2 <= 0;
	else
		locked_dly2 <= locked_dly1;
		
	always @ (posedge clk_100m_out)
	if(!rst_n)
		locked_dly3 <= 0;
	else
		locked_dly3 <= locked_dly2;
		
	always @ (posedge clk_100m_out)
	if(!rst_n)
		locked <= 0;
	else
		locked <= locked_dly3;

endmodule
