`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:34:41 04/19/2016 
// Design Name: 
// Module Name:    inin_fsm 
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
module aio_inin_fsm(
	input					sys_clk,
	input					glbl_rst_n,
	
	input					init_start,
	output	reg 		init_ok,
	output	reg  		init_fail,
	
	output	reg  		check_ram_en,
	input					check_ram_done,
	input					check_ram_error,
	output	reg  		load_ram_en,
	input					load_ram_done,
	input					load_ram_error,
	output	reg  		comp_crc_en,
	input					comp_crc_done,
	input					comp_crc_error,
	output	reg  		rd_id_en,
	input					rd_id_done,
	input					rd_id_error
);
	
	localparam idle 	= 	4'd0;
	localparam check 	= 	4'd1;
	localparam load	= 	4'd2;
	localparam comp	= 	4'd3;
	localparam rd_id	= 	4'd4;
	
	reg [3:0] state;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				init_ok <= 0;
				init_fail <= 0;
				check_ram_en <= 0;
				load_ram_en <= 0;
				comp_crc_en <= 0;
				rd_id_en <= 0;
				state <= idle;
			end
		else
			case(state)
				idle	:	begin
								init_ok <= 0;
								init_fail <= 0;
								if(init_start)
									begin
										check_ram_en <= 1;
										state <= check;						
									end                                 
							end                                       
				check	:	begin                                     
								check_ram_en <= 0;                     
								if(check_ram_error)                    
									begin                               
										init_fail <= 1;                  
										state <= idle;
									end
								if(check_ram_done)
									begin
										state <= load;
										load_ram_en <= 1;
									end
							end
				load	:	begin
								load_ram_en <= 0;
								if(load_ram_error)
									begin
										init_fail <= 1;
										state <= idle;
									end
								if(load_ram_done)
									begin
										state <= comp;
										comp_crc_en <= 1;
									end
							end
				comp	:	begin												
								comp_crc_en <= 0;                   
								if(comp_crc_error)                  
									begin                            
										init_fail <= 1;               
										state <= idle;                
									end                              
								if(comp_crc_done)                   	
									begin
										state <= rd_id;
										rd_id_en <= 1;
									end
							end
				rd_id	:	begin
								rd_id_en <= 0;
								if(rd_id_error)
									begin
										init_fail <= 1;
										state <= idle;
									end
								if(rd_id_done)
									begin
										state <= idle;
										init_ok <= 1;
									end
							end
				default	:	state <= idle; 
			endcase

endmodule
