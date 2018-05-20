`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:40:10 04/19/2016 
// Design Name: 
// Module Name:    load_fram_fasm 
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
module load_fram_fsm(
	input					sys_clk,
	input					glbl_rst_n,

	input 				load_ram_en,
	
	output	reg		fram_fsm_done,
	output	reg		fram_fsm_error,
	input					flash_fsm_done,
	input					flash_fsm_error,
	
	output 	reg		fram_afpga_en,
	input					fram_afpga_done,
	input					fram_afpga_error,
	output 	reg		fram_cons_en,
	input					fram_cons_done,
	input					fram_cons_error
);

	localparam idle 	= 	4'd0;
	localparam afpga 	= 	4'd1;
	localparam cons	= 	4'd2;
	
	reg [3:0] state;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				fram_fsm_done <= 0;
				fram_fsm_error <= 0;
				fram_afpga_en <= 0;
				fram_cons_en <= 0;
				state <= idle;
			end
		else
			case(state)
				idle	:	begin
								fram_fsm_done <= 0;
								fram_fsm_error <= 0;
								fram_afpga_en <= 0;
								fram_cons_en <= 0;
								if(load_ram_en)
									begin
										fram_afpga_en <= 1;
										state <= afpga;						
									end 
							end
				afpga	:	begin                              
								fram_afpga_en <= 0;                     
								if(fram_afpga_error == 1 || flash_fsm_error == 1)                    
									begin                               
										fram_fsm_error <= 1;                  
										state <= idle;
									end
								if(fram_afpga_done)
									begin
										state <= cons;
										fram_cons_en <= 1;
									end
							end
				cons	:	begin                           
								fram_cons_en <= 0;                     
								if(fram_cons_error == 1 || flash_fsm_error == 1)                    
									begin                               
										fram_fsm_error <= 1;                  
										state <= idle;
									end
								if(fram_cons_done)
									begin
										state <= idle;
										fram_fsm_done <= 1;
									end
							end
				default	:	state <= idle; 
			endcase

endmodule
