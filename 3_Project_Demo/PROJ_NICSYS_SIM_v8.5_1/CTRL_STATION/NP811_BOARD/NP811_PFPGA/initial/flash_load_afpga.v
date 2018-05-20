`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:06:07 04/19/2016 
// Design Name: 
// Module Name:    flash_load_afpga 
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
module flash_load_afpga(
	input							sys_clk,
	input							glbl_rst_n,
	
	input 						flash_afpga_en,
	input 						init_ok,
	output	reg				flash_afpga_done,
	output	reg				flash_afpga_error,
	
	output 	reg				afpga_flash_rden,
	output 	reg	[23:0]	afpga_flash_length,
	output 	reg	[24:0]	afpga_flash_addr,
	input 						init_flash_valid,
	input 						init_flash_last,
	input 			[7:0]		init_flash_data,
	
	output 						flash_afpga_rden,
	output 						flash_afpga_wren,
	output 	reg	[22:0]	flash_afpga_addr,
	input 			[7:0]		init_afpga_rdata,
	output 			[7:0]		flash_afpga_wdata,
	
	output 	reg	[31:0]		fram_cons_crc
);

	wire crc_right;
	
	parameter afpga_flag = 8'b1000_0000;
	
	localparam idle 	= 	0;
	localparam wr_co 	= 	1;
	
	reg init_flash_last_reg;
	reg init_flash_last_crc;

	reg wr_state;
	reg [7:0]flag_data;
	reg wr_flag;

	reg flash_load_afpga_flag;

	assign crc_right = 1;////////////////////////////////////////

	assign flash_afpga_wren = (init_flash_valid & flash_load_afpga_flag) | wr_flag;
	assign flash_afpga_wdata = ((wr_flag) ? flag_data : init_flash_data) & {8{(init_flash_valid & flash_load_afpga_flag) | wr_flag}};

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			flash_load_afpga_flag <= 0;
		else
			begin
				if(flash_afpga_en) flash_load_afpga_flag <= 1;
				if(flash_afpga_done || flash_afpga_error) flash_load_afpga_flag <= 0;
			end

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				afpga_flash_rden <= 0;
				afpga_flash_length <= 0;
				afpga_flash_addr <= 0;
			end
		else
			begin
				if(flash_afpga_en)
					begin
						afpga_flash_rden <= 1;
						afpga_flash_length <= 24'h20000;
						afpga_flash_addr <= 25'h2e400;
					end
				else
					begin
						afpga_flash_rden <= 0;
						afpga_flash_length <= 0;
						afpga_flash_addr <= 0;
					end
			end

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			fram_cons_crc <= 0;
		else
			if(init_flash_valid) fram_cons_crc <= {init_flash_data,fram_cons_crc[31:8]};
			
	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				wr_state <= idle;
				flash_afpga_addr <= 0;
				flag_data <= 0;
				wr_flag <= 0;
				flash_afpga_done <= 0;
				flash_afpga_error <= 0;
			end
		else
			case(wr_state)
				idle	:	begin
								flash_afpga_done <= 0;
								flash_afpga_error <= 0;
								if(flash_afpga_en)
									begin
										wr_state <= wr_co;
										flash_afpga_addr <= 23'h400000;
									end
								else
									begin
										if(init_ok)
											begin
												flag_data <= afpga_flag;
												wr_flag <= 1;
												flash_afpga_addr <= 0;
											end
										else
											begin
												flag_data <= 0;
												wr_flag <= 0;
											end
									end
							end
				wr_co	:	begin
								if(init_flash_valid) flash_afpga_addr <= flash_afpga_addr + 1'b1;
								if(init_flash_last_crc) 
									begin
										flash_afpga_addr <= 0;
										wr_state <= idle;
										if(crc_right == 1)
											flash_afpga_done <= 1;
										else
											flash_afpga_error <= 1;
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

    M_Crc32De8 fdM_Crc32De8(
        .CpSl_Rst_i (sys_clk)  ,                 
        .CpSl_Clk_i  (~glbl_rst_n) ,                 

        .CpSl_Init_i (flash_afpga_en) ,                 
        .CpSv_Data_i (init_flash_data) ,                 
        .CpSl_CrcEn_i (init_flash_valid) ,                
        .CpSl_CrcEnd_i (init_flash_last_reg),                
        .CpSl_CrcErr_o  ()              
    );

endmodule
