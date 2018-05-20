`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:51:54 04/19/2016 
// Design Name: 
// Module Name:    flash_load_cons 
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
module flash_load_cons(
	input							sys_clk,
	input							glbl_rst_n,
	
	input 						flash_cons_en,
	output	reg				flash_cons_done,
	output	reg				flash_cons_error,
	
	output 	reg				cons_flash_rden,
	output 	reg	[23:0]	cons_flash_length,
	output 	reg	[24:0]	cons_flash_addr,
	input 						init_flash_valid,
	input 						init_flash_last,
	input 			[7:0]		init_flash_data,
	
	output 						flash_cons_wren,
	output 	reg	[15:0]	flash_cons_addr,
	output 			[7:0]		flash_cons_data,
	output 	reg	[191:0]	init_cons_para,
	
	output 	reg	[63:0]	flash_cons_crc
);

	wire crc_right;
	
	parameter pcb = 32'h1111_1111;
	parameter code = 32'h2222_2222;
	
	localparam idle 	= 	4'd0;
	localparam wr_co 	= 	4'd1;
	localparam wr_pa 	= 	4'd2;
	localparam pcb1 	= 	4'd3;
	localparam pcb2 	= 	4'd4;
	localparam pcb3 	= 	4'd5;
	localparam pcb4 	= 	4'd6;
	localparam code1 	= 	4'd7;
	localparam code2 	= 	4'd8;
	localparam code3 	= 	4'd9;
	localparam code4 	= 	4'd10;
		
	reg init_flash_last_reg;
	reg init_flash_last_crc;

	reg [223:0]cons_para_reg;

	reg wr_cons;
	reg rd_para;
	reg [3:0]wr_state;
	reg [7:0]wr_data;
	reg wr_cont;

	assign crc_right = 1;////////////////////////////////////////

	
	assign flash_cons_wren = (wr_cons & init_flash_valid) | wr_cont;
	assign flash_cons_data = ((wr_cont) ? wr_data : init_flash_data) & ({8{(wr_cons & init_flash_valid) | wr_cont}});
  
	always @ (posedge sys_clk)//
		if(!glbl_rst_n)
			begin
				wr_cons <= 0;
				rd_para <= 0;
				flash_cons_addr <= 0;
				flash_cons_done <= 0;
				flash_cons_error <= 0;
				wr_cont <= 0;
				wr_data <= 0;
				wr_state <= idle;
			end
		else  
			case(wr_state)
				idle	:	begin
								rd_para <= 0;
								flash_cons_done <= 0;
								flash_cons_addr <= 0;
								flash_cons_error <= 0;
								wr_cont <= 0;
								wr_data <= 0;
								if(flash_cons_en)
									begin
										flash_cons_addr <= 0;
										wr_cons <= 1;
										wr_state <= wr_co;
									end
							end
				wr_co	:	begin
								if(init_flash_last_crc)
									begin
										if(crc_right)
											begin
												wr_state <= wr_pa;
												rd_para <= 1;
												wr_cons <= 0;
												flash_cons_addr <= 0;
											end
										else
											begin
												wr_state <= idle;
												flash_cons_error <= 1;
												wr_cons <= 0;
												flash_cons_addr <= 0;
											end
									end
								else
									if(init_flash_valid) flash_cons_addr <= flash_cons_addr + 1'b1;
							end
				wr_pa	:	begin
								rd_para <= 0;
								if(init_flash_last_crc)
									begin
										if(crc_right)
											begin
												wr_state <= pcb1;
											end
										else
											begin
												flash_cons_error <= 1;
												wr_state <= idle;
											end
									end
							end
				pcb1	:	begin wr_cont <= 1;wr_data <= pcb[7:0];flash_cons_addr <= 16'h0300; wr_state <= pcb2;end
				pcb2	:	begin wr_cont <= 1;wr_data <= pcb[15:8];flash_cons_addr <= 16'h0301; wr_state <= pcb3;end 
				pcb3	:	begin wr_cont <= 1;wr_data <= pcb[23:16];flash_cons_addr <= 16'h0302; wr_state <= pcb4;end 
				pcb4	:	begin wr_cont <= 1;wr_data <= pcb[31:24];flash_cons_addr <= 16'h0303; wr_state <= code1;end 
				code1	:	begin wr_cont <= 1;wr_data <= code[7:0];flash_cons_addr <= 16'h0304; wr_state <= code2;end
				code2	:	begin wr_cont <= 1;wr_data <= code[15:8];flash_cons_addr <= 16'h0305; wr_state <= code3;end
				code3	:	begin wr_cont <= 1;wr_data <= code[23:16];flash_cons_addr <= 16'h0306; wr_state <= code4;end
				code4	:	begin wr_cont <= 1;wr_data <= code[31:24];flash_cons_addr <= 16'h0307; wr_state <= idle;flash_cons_done <= 1;end
				default	:	wr_state <= idle; 
			endcase
  
	always @ (posedge sys_clk)//对last信号打一拍作为计算crc结束的信号，打两拍作为查看crc结果的使能
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

	always @ (posedge sys_clk)//取出读出的crc
		if(!glbl_rst_n)
			flash_cons_crc <= 0;
		else
			begin
				flash_cons_crc[63:32] <= cons_para_reg[223:192];
				if(rd_para)	
					flash_cons_crc[31:0] <= cons_para_reg[223:192];
			end

	always @ (posedge sys_clk)//将cons的长度和首地址保存，顺便保存crc
		if(!glbl_rst_n)
			begin
				cons_para_reg <= 0;
				init_cons_para <= 0;
			end
		else
			begin
				if(init_flash_valid) cons_para_reg <= {init_flash_data,cons_para_reg[223:8]};
				if(flash_cons_done) init_cons_para <= cons_para_reg[191:0];
			end

	always @ (posedge sys_clk)//读flash的控制
		if(!glbl_rst_n)
			begin
				cons_flash_rden <= 0;
				cons_flash_length <= 0;
				cons_flash_addr <= 0;
			end
		else
			begin
				if(flash_cons_en)
					begin
						cons_flash_rden <= 1;
						cons_flash_length <= 11'h384;
						cons_flash_addr <= 0;
					end
				else 
					begin
						if(rd_para)
							begin
								cons_flash_rden <= 1;
								cons_flash_length <= 11'd28;
								cons_flash_addr <= 25'h0000400;
							end
						else
							begin
								cons_flash_rden <= 0;
								cons_flash_length <= 0;
								cons_flash_addr <= 0;
							end
					end
			end

    M_Crc32De8 fcM_Crc32De8(
        .CpSl_Rst_i (sys_clk)  ,                 
        .CpSl_Clk_i  (~glbl_rst_n) ,                 

        .CpSl_Init_i (flash_cons_en) ,                 
        .CpSv_Data_i (init_flash_data) ,                 
        .CpSl_CrcEn_i (init_flash_valid) ,                
        .CpSl_CrcEnd_i (init_flash_last_reg),                
        .CpSl_CrcErr_o  ()              
    );

endmodule
