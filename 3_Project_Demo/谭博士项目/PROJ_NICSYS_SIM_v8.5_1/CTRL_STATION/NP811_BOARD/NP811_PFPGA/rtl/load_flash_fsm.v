`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:33:47 04/19/2016 
// Design Name: 
// Module Name:    load_flash_fsm 
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
module load_flash_fsm(
	input					sys_clk,
	input					glbl_rst_n,
	
	input 				load_ram_en,
	input					fram_fsm_done,
	input					fram_fsm_error,
	output	reg		flash_fsm_done,
	output	reg		flash_fsm_error,
		
	output 	reg		flash_afpga_en,
	input					flash_afpga_done,
	input					flash_afpga_error,
	output 	reg		flash_cons_en,
	input					flash_cons_done,
	input					flash_cons_error,
	output 	reg		flash_xfer_en,
	input					flash_xfer_done,
	input					flash_xfer_error,
	output 	reg		flash_card_en,
	input					flash_card_done,
	input					flash_card_error
);

	localparam idle 	= 	4'd0;
	localparam xfer 	= 	4'd1;
	localparam card	= 	4'd2;
	localparam afpga	= 	4'd3;
	localparam cons	= 	4'd4;
	
	reg [3:0] state;
			
	always @ (posedge sys_clk) 
		if(!glbl_rst_n)
			begin
				flash_fsm_done <= 0;
				flash_fsm_error <= 0;
				flash_afpga_en <= 0;
				flash_cons_en <= 0;
				flash_xfer_en <= 0;
				flash_card_en <= 0;
				state <= idle;
			end
		else
			case(state)
				idle	:	begin
								flash_fsm_done <= 0;
								flash_fsm_error <= 0;
								flash_afpga_en <= 0;
								flash_cons_en <= 0;
								flash_xfer_en <= 0;
								flash_card_en <= 0;
								if(fram_fsm_done)
									begin
										flash_xfer_en <= 1;
										state <= xfer;						
									end 
							end
				xfer	:	begin                              
								flash_xfer_en <= 0;                     
								if(flash_xfer_error == 1 || fram_fsm_error == 1)                    
									begin                               
										flash_fsm_error <= 1;                  
										state <= idle;
									end
								if(flash_xfer_done)
									begin
										state <= card;
										flash_card_en <= 1;							
									end                                        
							end                                              
				card	:	begin                                
								flash_card_en <= 0;                     
								if(flash_card_error == 1 || fram_fsm_error == 1)                    
									begin                               
										flash_fsm_error <= 1;                  
										state <= idle;
									end
								if(flash_card_done)
									begin
										state <= afpga;
										flash_afpga_en <= 1;							
									end                                         
							end                                              
				afpga	:	begin                              
								flash_afpga_en <= 0;                     
								if(flash_afpga_error == 1 || fram_fsm_error == 1)                    
									begin                               
										flash_fsm_error <= 1;                  
										state <= idle;
									end
								if(flash_afpga_done)
									begin
										state <= cons;
										flash_cons_en <= 1;							
									end                                          
							end                                              
				cons	:	begin                            
								flash_cons_en <= 0;                     
								if(flash_cons_error == 1 || fram_fsm_error == 1)                    
									begin                               
										flash_fsm_error <= 1;                  
										state <= idle;
									end
								if(flash_cons_done)
									begin
										state <= idle;
										flash_fsm_done <= 1;							
									end                                           
							end                                              	
				default	:	state <= idle;                                 
			endcase                                                       
                                                                       
			                                                              
			                                                              
endmodule                                                               
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        