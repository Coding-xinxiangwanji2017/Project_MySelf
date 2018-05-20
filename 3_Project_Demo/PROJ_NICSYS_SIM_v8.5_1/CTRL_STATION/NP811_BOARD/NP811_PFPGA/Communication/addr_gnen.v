`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:52:38 04/20/2016 
// Design Name: 
// Module Name:    addr_gnen 
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
module addr_gnen(
    input  wire         sys_clk_50m      ,
    input  wire         sys_rst_n        ,

    input  wire         init_ok          ,
    input  wire [95:00] init_xfer_para   ,
	 
    output reg  [17:00] xfer_in_addr  	  ,
    output reg  [17:00] xfer_in_length	  ,
    output reg  [17:00] xfer_out_addr    ,
    output reg  [17:00] xfer_out_length  ,
    output reg  [17:00] xnet_addr  	     ,
    output reg  [17:00] xnet_length	  
);

	wire [31:0] in_length;
	wire [31:0] out_length;
	wire [31:0] xet_length;

	assign in_length = init_xfer_para[31:0];
	assign out_length = init_xfer_para[63:32];
	assign xet_length = init_xfer_para[95:64];

	always @ (posedge sys_clk_50m)
		if(!sys_rst_n)
			begin
				xfer_in_addr <= 0; 	 
			   xfer_in_length <= 0;	 
			   xfer_out_addr <= 0;   
			   xfer_out_length <= 0; 
			   xnet_addr <= 0;  	    
			   xnet_length <= 0;	  
			end
		else
			if(init_ok == 1)
				begin
					xfer_in_addr <= 0; 	 
					xfer_in_length <= in_length[17:0]; 
					xfer_out_addr <= in_length[17:0];
					xfer_out_length <= out_length[17:0]; 
					xnet_addr <= in_length[17:0] + out_length[17:0];    
					xnet_length <= xet_length[17:0];		
				end

endmodule
