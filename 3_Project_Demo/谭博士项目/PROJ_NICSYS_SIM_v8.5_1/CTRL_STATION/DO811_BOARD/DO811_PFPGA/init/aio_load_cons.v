`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:33:13 05/06/2016 
// Design Name: 
// Module Name:    aio_load_cons 
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
module aio_load_cons(
	input						sys_clk,
	input						glbl_rst_n,

	input 					load_cons_en,
	output	reg 			load_cons_done,
	output	reg 			load_cons_error,
	
	output 	reg			cons_eep_rden,
	output 	reg [16:0]	cons_eep_length,
	output 	reg [15:0]	cons_eep_addr,
	input 					init_eep_valid,
	input 					init_eep_last,
	input 		 [7:0]	init_eep_data,
	
	output 	reg			init_cons_wren,
	output 	reg [15:0]	init_cons_addr,
	output 	reg [7:0]	init_cons_data
);

	parameter para1_addr = 16'h0000;
	parameter para1_len  = 17'h384;

	parameter para2_addr = 16'h0400;
	parameter para2_len  = 17'h384;
	
	parameter cons2_addr  = 16'h3ff;

	parameter pcb = 32'h1111_1111;
	parameter code = 32'h2222_2222;

	localparam idle 	= 	0;
	localparam cons1 	= 	1;
	localparam cons2 	= 	2;
	
	localparam widle 	= 	0;
	localparam wait1 	= 	1;
	localparam wait2 	= 	2;
	localparam wrco1 	= 	3;
	localparam wrco2 	= 	4;
	localparam pcb1 	= 	5;
	localparam pcb2 	= 	6;
	localparam pcb3 	= 	7;
	localparam pcb4 	= 	8;
	localparam code1 	= 	9;
	localparam code2 	= 	10;
	localparam code3 	= 	11;
	localparam code4 	= 	12;
	
	reg [1:0] rd_state;
	reg [3:0] wr_state;
	
	reg init_eep_last_reg;
	reg init_eep_last_crc;
	
	wire CpSl_CrcErr_o;
	
	assign CpSl_CrcErr_o = 1'b1;//////////////////////////////////////////////////////
	
	always @ (posedge sys_clk)//
		if(!glbl_rst_n)
			begin
				init_eep_last_reg <= 0;
				init_eep_last_crc <= 0;
			end
		else
			begin
				init_eep_last_reg <= init_eep_last;
				init_eep_last_crc <= init_eep_last_reg;
			end
	
	always @ (posedge sys_clk)//
		if(!glbl_rst_n)
			begin
				init_cons_wren <= 0;
				init_cons_addr <= 0;
				init_cons_data <= 0;
				load_cons_done <= 0;
				load_cons_error <= 0;
				wr_state <= widle;
			end
		else
			case(wr_state)
				widle	:	begin
								init_cons_wren <= 0;
								init_cons_addr <= 0;
								init_cons_data <= 0;
								load_cons_done <= 0;
								load_cons_error <= 0;
								if(load_cons_en)
									wr_state <= wait1;
							end
				wait1	:	begin
								if(init_eep_valid)
									begin
										init_cons_wren <= 1;
										init_cons_data <= init_eep_data;
										wr_state <= wrco1;
									end
							end
				wrco1	:	begin
								if(init_eep_last_crc)
									begin
										if(CpSl_CrcErr_o)
											begin
												wr_state <= wrco2;
												init_cons_addr <= cons2_addr;
											end
										else
											begin
												wr_state <= widle;
												load_cons_error <= 1;
											end
									end
								else
									begin
										if(init_eep_valid)
											begin
												init_cons_wren <= 1;
												init_cons_data <= init_eep_data;
												init_cons_addr <= init_cons_addr + 1'b1;
											end
										else
											begin
												init_cons_wren <= 0;
											end
									end
							end
				wrco2	:	begin
								if(init_eep_last_crc)
									begin
										if(CpSl_CrcErr_o)
											begin
												wr_state <= pcb1;
											end
										else
											begin
												wr_state <= widle;
												load_cons_error <= 1;
											end
									end
								else
									begin
										if(init_eep_valid)
											begin
												init_cons_wren <= 1;
												init_cons_data <= init_eep_data;
												init_cons_addr <= init_cons_addr + 1'b1;
											end
										else
											begin
												init_cons_wren <= 0;
											end
									end
							end
				pcb1	:	begin wr_state <= pcb2;  init_cons_wren <= 1; init_cons_addr <= 16'h0300; init_cons_data <= pcb[7:0];   end
				pcb2	:	begin wr_state <= pcb3;  init_cons_wren <= 1; init_cons_addr <= 16'h0301; init_cons_data <= pcb[15:8];   end
				pcb3	:	begin wr_state <= pcb4;  init_cons_wren <= 1; init_cons_addr <= 16'h0302; init_cons_data <= pcb[23:16];   end
				pcb4	:	begin wr_state <= code1; init_cons_wren <= 1; init_cons_addr <= 16'h0303; init_cons_data <= pcb[31:24];   end
				code1	:	begin wr_state <= code2; init_cons_wren <= 1; init_cons_addr <= 16'h0304; init_cons_data <= code[7:0];      end
				code2	:	begin wr_state <= code3; init_cons_wren <= 1; init_cons_addr <= 16'h0305; init_cons_data <= code[15:8];     end
				code3	:	begin wr_state <= code4; init_cons_wren <= 1; init_cons_addr <= 16'h0306; init_cons_data <= code[23:16];    end
				code4	:	begin wr_state <= widle; init_cons_wren <= 1; init_cons_addr <= 16'h0307; init_cons_data <= code[31:24];  load_cons_done <= 1;  end
				default	:	wr_state <= widle; 
			endcase
	
	always @ (posedge sys_clk)//
		if(!glbl_rst_n)
			begin
				cons_eep_rden <= 0;
				cons_eep_length <= 0;
				cons_eep_addr <= 0;
				rd_state <= idle;
			end
		else 
			case(rd_state)
				idle	:	begin
								if(load_cons_en)
									begin
										rd_state <= cons1;
										cons_eep_rden <= 1;
										cons_eep_length <= para1_len;
										cons_eep_addr <= para1_addr;
									end
							end
				cons1	:	begin
								if(init_eep_last)
									begin
										rd_state <= cons2;
									   cons_eep_rden <= 1;
									   cons_eep_length <= para2_len;
									   cons_eep_addr <= para2_addr;
									end
								else
									begin
										cons_eep_rden <= 0;
									   cons_eep_length <= 0;
									   cons_eep_addr <= 0;
									end
							end
				cons2	:	begin
								rd_state <= idle;
								cons_eep_rden <= 0;
								cons_eep_length <= 0;
								cons_eep_addr <= 0;
							end
				default	:	rd_state <= idle; 
			endcase


    M_Crc32De8 fcM_Crc32De8(
        .CpSl_Rst_i (sys_clk)  ,                 
        .CpSl_Clk_i  (~glbl_rst_n) ,                 

        .CpSl_Init_i (load_cons_en) ,                 
        .CpSv_Data_i (init_eep_data) ,                 
        .CpSl_CrcEn_i (init_eep_valid) ,                
        .CpSl_CrcEnd_i (init_eep_last_reg),                
        .CpSl_CrcErr_o  ()   //CpSl_CrcErr_o           
    );
		
endmodule
