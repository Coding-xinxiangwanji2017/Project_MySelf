`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:00:57 04/19/2016 
// Design Name: 
// Module Name:    init_rd_id 
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
module init_rd_id(
	input							sys_clk,
	input							glbl_rst_n,
	
	input 						rd_id_en,
	output	reg				rd_id_done,
	output	reg				rd_id_error,
	
	input 			[7:0]		init_id_in,
	output 	reg	[7:0]		init_id_out
);

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				rd_id_done <= 0;
				rd_id_error <= 0;
				init_id_out <= 0;
			end
		else
			if(rd_id_en == 1)
				begin
					if(init_id_in == 0)
						rd_id_error <= 1;
					else
						begin
							rd_id_done <= 1;
							init_id_out <= init_id_in;
						end
				end
			else
				begin
					rd_id_done <= 0;
					rd_id_error <= 0;
				end

endmodule
