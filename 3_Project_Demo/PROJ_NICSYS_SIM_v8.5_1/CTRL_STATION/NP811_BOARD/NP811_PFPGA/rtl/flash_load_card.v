`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:36:35 04/19/2016 
// Design Name: 
// Module Name:    flash_load_card 
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
module flash_load_card(
	input							sys_clk,
	input							glbl_rst_n,
	
	input 						flash_card_en,
	output	reg				flash_card_done,
	output	reg				flash_card_error,
	
	output 	reg				card_flash_rden,
	output 	reg	[23:0]	card_flash_length,
	output 	reg	[24:0]	card_flash_addr,
	input 						init_flash_valid,
	input 						init_flash_last,
	input 			[7:0]		init_flash_data,
	
	output 						init_card_wren,
	output 	reg	[9:0]		init_card_addr,
	output 			[7:0]		init_card_data,
	
	output 	reg	[31:0]		flash_card_crc
);

	wire crc_right;
	
	localparam idle 	= 	0;
	localparam wr_co 	= 	1;
	
	reg init_flash_last_reg;
	reg init_flash_last_crc;

	reg wr_state;

	reg flash_load_card_en;

	assign crc_right = 1;////////////////////////////////////////

	assign init_card_wren = init_flash_valid & flash_load_card_en;
	assign init_card_data = (init_flash_valid & flash_load_card_en) ? init_flash_data : 8'b0;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			flash_load_card_en <= 0;
		else
			begin
				if(flash_card_en) flash_load_card_en <= 1;
				if(flash_card_error || flash_card_done) flash_load_card_en <= 0;
			end

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			flash_card_crc <= 0;
		else
			if(init_flash_valid) flash_card_crc <= {init_flash_data,flash_card_crc[31:8]};
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				wr_state <= idle;
				init_card_addr <= 0;
				flash_card_done <= 0;
				flash_card_error <= 0;
			end
		else
			case(wr_state)
				idle	:	begin
								flash_card_done <= 0;
								flash_card_error <= 0;
								if(flash_card_en)
									begin
										wr_state <= wr_co;
										init_card_addr <= 0;
									end
							end
				wr_co	:	begin
								if(init_flash_valid) init_card_addr <= init_card_addr + 1'b1;
								if(init_flash_last_crc) 
									begin
										init_card_addr <= 0;
										wr_state <= idle;
										if(crc_right == 1)
											flash_card_done <= 1;
										else
											flash_card_error <= 1;
									end
							end
				default	:	wr_state <= idle; 
			endcase


	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				init_flash_last_reg <= 0;
				init_flash_last_crc <= 0;
			end
		else
			begin
				init_flash_last_reg <= init_flash_last;
				init_flash_last_crc <= init_flash_last_reg;
			end

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				card_flash_rden <= 0;
				card_flash_length <= 0;
				card_flash_addr <= 0;
			end
		else
			begin
				if(flash_card_en)
					begin
						card_flash_rden <= 1;
						card_flash_length <= 24'd868;
						card_flash_addr <= 25'h4e400;
					end
				else
					begin
						card_flash_rden <= 0;
						card_flash_length <= 0;
						card_flash_addr <= 0;
					end
			end

    M_Crc32De8 flM_Crc32De8(
        .CpSl_Rst_i (sys_clk)  ,                 
        .CpSl_Clk_i  (~glbl_rst_n) ,                 

        .CpSl_Init_i (flash_card_en) ,                 
        .CpSv_Data_i (init_flash_data) ,                 
        .CpSl_CrcEn_i (init_flash_valid) ,                
        .CpSl_CrcEnd_i (init_flash_last_reg),                
        .CpSl_CrcErr_o  ()              
    );

endmodule
