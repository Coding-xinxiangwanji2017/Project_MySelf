`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:43:26 04/19/2016 
// Design Name: 
// Module Name:    init_check_ram 
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
module init_check_ram(
	input							sys_clk,
	input							glbl_rst_n,
		
	input 						check_ram_en,
	output	reg				check_ram_done,
	output	reg				check_ram_error,
	
	output	reg	[15:0]	init_check_en,
	input 			[15:0]	init_check_done,
	input 			[15:0]	init_check_error
);

	localparam idle 	= 	4'd0;
	localparam check 	= 	4'd1;
	
	reg state;
	reg [15:0] init_check_done_reg;

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			init_check_done_reg <= 0;
		else
			begin
				if(check_ram_done == 1 || check_ram_error == 1) init_check_done_reg <= 0;
				if(init_check_done[0]  == 1) init_check_done_reg[0] <= 1;
				if(init_check_done[1]  == 1) init_check_done_reg[1] <= 1;
				if(init_check_done[2]  == 1) init_check_done_reg[2] <= 1;
				if(init_check_done[3]  == 1) init_check_done_reg[3] <= 1;
				if(init_check_done[4]  == 1) init_check_done_reg[4] <= 1;
				if(init_check_done[5]  == 1) init_check_done_reg[5] <= 1;
				if(init_check_done[6]  == 1) init_check_done_reg[6] <= 1;
				if(init_check_done[7]  == 1) init_check_done_reg[7] <= 1;
				if(init_check_done[8]  == 1) init_check_done_reg[8] <= 1;
				if(init_check_done[9]  == 1) init_check_done_reg[9] <= 1;
				if(init_check_done[10] == 1) init_check_done_reg[10] <= 1;
				if(init_check_done[11] == 1) init_check_done_reg[11] <= 1;
				if(init_check_done[12] == 1) init_check_done_reg[12] <= 1;
				if(init_check_done[13] == 1) init_check_done_reg[13] <= 1;
				if(init_check_done[14] == 1) init_check_done_reg[14] <= 1;
				if(init_check_done[15] == 1) init_check_done_reg[15] <= 1;
			end

	always @ (posedge sys_clk)
		if(!glbl_rst_n)
			begin
				check_ram_done <= 0;
				check_ram_error <= 0;
				init_check_en <= 0;
				state <= idle;
			end
		else
			case(state)
				idle	:	begin
								check_ram_done <= 0;
								check_ram_error <= 0;
								if(check_ram_en)
									begin
										init_check_en <= 16'b1111_1111_1111_1111;
										state <= check;
									end
							end
				check	:	begin
								init_check_en <= 0;
								if(|init_check_error)
									begin
										check_ram_error <= 1;
										state <= idle;
									end
								if(&init_check_done_reg)
									begin
										check_ram_done <= 1;
										state <= idle;
									end
							end
				default	:	state <= idle; 
			endcase

endmodule
