`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:10:00 04/19/2016 
// Design Name: 
// Module Name:    done_and_error_or 
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
module done_and_error_or(
	input					sys_clk,
	input					glbl_rst_n,
	
	output	reg		load_ram_done,
	output	reg		load_ram_error,
	
	input					fram_fsm_done,
	input					fram_fsm_error,
	input					flash_fsm_done,
	input					flash_fsm_error
);

	reg fram_fsm_done_reg;
	reg flash_fsm_done_reg;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				load_ram_done <= 0;
				load_ram_error <= 0;
			end
		else
			begin
				load_ram_done <= fram_fsm_done_reg & flash_fsm_done_reg;
				load_ram_error <= flash_fsm_error | fram_fsm_error;
			end
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				fram_fsm_done_reg <= 0;
				flash_fsm_done_reg <= 0;
			end
		else		
			begin
				if(fram_fsm_done)fram_fsm_done_reg <= 1;
				if(flash_fsm_done)flash_fsm_done_reg <= 1;
				if(load_ram_error == 1 || load_ram_done == 1)
					begin
						fram_fsm_done_reg <= 0;
						flash_fsm_done_reg <= 0;
					end
			end
			
endmodule
