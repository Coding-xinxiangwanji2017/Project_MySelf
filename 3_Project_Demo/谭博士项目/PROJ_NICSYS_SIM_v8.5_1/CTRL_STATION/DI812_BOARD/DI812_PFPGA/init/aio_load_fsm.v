`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:26:44 05/06/2016 
// Design Name: 
// Module Name:    aio_load_fsm 
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
module aio_load_fsm(
	input					sys_clk,
	input					glbl_rst_n,
    
	input 				load_ram_en,
	output	reg		load_ram_done,
	output	reg		load_ram_error,
	
	output 	reg		load_cons_en,
	input					load_cons_done,
	input					load_cons_error,	
	 
	output 	reg		load_chram_en,
	input					load_chram_done,
	input					load_chram_error 
);

	localparam idle 	= 	4'd0;
	localparam cons 	= 	4'd1;
	localparam chram	= 	4'd2;
	
	reg [1:0] state;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				load_ram_done <= 0;                          
				load_ram_error <= 0;                         
				load_cons_en <= 0;                           
				load_chram_en <= 0;                          
				state <= idle;                               
			end                                             
		else	                                             
			case(state)
				idle	:	begin
								load_ram_done <= 0; 
								load_ram_error <= 0; 
								if(load_ram_en)
									begin
										load_cons_en <= 1; 
										state <= cons;
									end
							end
				cons	:	begin
								load_cons_en <= 0;
								if(load_cons_done)
									begin
										load_chram_en <= 1; 
										state <= chram;
									end
								if(load_cons_error)
									begin
										load_ram_error <= 1; 
										state <= idle;
									end
							end
				chram	:	begin
								load_chram_en <= 0;
								if(load_chram_done)
									begin
										load_ram_done <= 1; 
										state <= idle;
									end
								if(load_chram_error)
									begin
										load_ram_error <= 1; 
										state <= idle;
									end
				
							end
				default	:	state <= idle; 
			endcase

			 
endmodule                                                
