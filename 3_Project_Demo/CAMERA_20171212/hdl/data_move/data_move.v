`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:55:21 08/02/2016 
// Design Name: 
// Module Name:    data_moove 
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
module data_move(

    input clk,
    input rst_n,
    input enable,
    input flash_done,
    input [15:0] flash_in,
    input fifo_rd_en     ,
    
//	 inout [35:0] CONTROL0,
    output busy,
    output done,
    output [13:0] row,
	 	output rd_req,
	 	output rd_en,
	 	output rst_rfifo,
	 
	  output wr_req,
    output [23:0] sram_waddr,
    output [31:0] sram_rdata,

    output wire o_empty,
    output wire o_fifo_rd_en,
    output wire[8:0] o_state,
	 
	  output ram_wr,
	  output [11:0] ram_addr,
	  output [15:0] ram_data

    );

		wire fifo_wr;
		wire rst;
		wire empty;
		wire [31:0] data_out;
		
		assign rst = ~rst_n;
		assign sram_rdata = data_out;
		assign ram_data = flash_in;
		
		assign o_empty = empty;
		assign o_fifo_rd_en = fifo_rd_en;
		
		
		move_fsm fsm_inst(
	    .clk(clk),
	    .rst_n(rst_n),
		  .enable(enable),
	    .flash_done(flash_done),
	    .empty(empty),
	    .o_state(o_state),
//		 .CONTROL0(CONTROL0),
	    .busy(busy),
	    .done(done),
	    .row(row),
	    .rd_req(rd_req),
	    .rd_en(rd_en),
		  .sram_waddr(sram_waddr),
		  .wr_req(wr_req),
	  	.ram_wr(ram_wr),
		  .fifo_wr(fifo_wr),
	    .ram_addr(ram_addr),
	    .rst_rfifo(rst_rfifo)
	   );
    
    fifo fifo_inst(
		 .rst(rst),
		 .wr_clk(clk),
	   .rd_clk(clk),
		 .din(flash_in),
		 .wr_en(fifo_wr),
	   .rd_en(fifo_rd_en     ),
	   .dout(data_out),
	   .full(),
     .empty(empty)
    );


//		wire [255:0] TRIG0;
//		
//		assign TRIG0[15:0] = flash_in;
//	   assign TRIG0[47:16] = sram_rdata;
//	   assign TRIG0[79:48] = data_out;
//	   assign TRIG0[80] = flash_done;
//	   assign TRIG0[81] = enable; 
//	   assign TRIG0[82] = busy;
//	   assign TRIG0[83] = done; 
//		assign TRIG0[84] = wr_req;
//		assign TRIG0[85] = rst_rfifo;
//		assign TRIG0[86] = rd_en;
//		assign TRIG0[87] = rd_req;
//		assign TRIG0[88] = fifo_wr;
//		assign TRIG0[89] = fifo_rd_en;
//		assign TRIG0[90] = empty;
//		assign TRIG0[91] = ram_wr;
//		assign TRIG0[107:92] = ram_data;
		
		
		
//		ila ila1 (
//		 .CONTROL(CONTROL0), // INOUT BUS [35:0]
//		 .CLK(clk), // IN
//		 .TRIG0(TRIG0), // IN BUS 
//		 .TRIG1(TRIG1), // IN BUS 
//		 .TRIG2(TRIG2), // IN BUS 
//		 .TRIG3(TRIG3)  // IN BUS 
//	    );








endmodule
