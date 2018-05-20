////////////////////////////////////////////////////////////////////////////////
// Copyright (c)2015 CNCS Incorporated
// All Rights Reserved
// THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of CNCS Inc.
// The copyright notice above does not evidence any actual or intended
// publication of such source code.
// No part of this code may be reproduced, stored in a retrieval system,
// or transmitted, in any form or by any means, electronic, mechanical,
// photocopying, recording, or otherwise, without the prior written
// permission of CNCS
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Name of module : NP811_U1_C01_TOP
// Project        : NicSys8000
// Func           : Project TOP
// Author         : Liu zhikai
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FG484
// version 1.0    : made in Date: 2015.12.01
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/04/12   Initial version(Tan Xingye)
//
//
//
////////////////////////////////////////////////////////////////////////////////
module sync_top(

 input  wire        clk,
 input  wire        rst_n,
                    
 input  wire        sync_trans_en,
 input  wire        sync_recv_en,
 input  wire [1:0]  sync_Btoa_en,
                
 input  wire        sl_tx_buf_rden,
 input  wire [10:0] sl_tx_buf_raddr,
 output wire [7:0]  sl_tx_buf_dout,

 input  wire        sl_rx_buf_wren,
 input  wire [10:0] sl_rx_buf_waddr,
 input  wire [7:0]  sl_rx_buf_din,
 
 output wire 				o_afpga_wren,
 output wire [22:0]	om_afpga_addr,
 output wire [7:0] 	om_afpga_wdata,
 input  wire [7:0] 	im_afpga_rdata

);


//=========================================================
// inter signals
//=========================================================

wire sl_tx_buf_wren;
wire [10:0] sl_tx_buf_waddr;
wire [7:0] sl_tx_buf_din;

wire sl_rx_buf_rden;
wire [10:0] sl_rx_buf_raddr;
wire [7:0] sl_rx_buf_dout;

wire [23:0] slink_waddr;
wire [23:0] slink_raddr;


assign om_afpga_addr = slink_waddr[22:0] | slink_raddr[22:0];

//=========================================================
// instation
//=========================================================

sync_trans sync_trans(

 .reset           (~rst_n),

 .clk             (clk),

 .slink_data      (im_afpga_rdata),                                              //AFPGA DATA OUT
 .sync_trans_en   (sync_trans_en),

 .slink_rden      (),                                              //AFPGA DATA en
 .slink_raddr     (slink_raddr),                                       //AFPGA DATA address
 .slink_tx_wren   (sl_tx_buf_wren),                                           //BUFFER en
 .slink_tx_waddr  (sl_tx_buf_waddr),                                    //BUFFER address
 .slink_tx_data   (sl_tx_buf_din)                                      //BUFFER data

);

sync_recv sync_recv(

 .reset           (~rst_n),
 .clk             (clk),
 
 .slink_rx_data   (sl_rx_buf_dout),                                     //BUFFER DOUT
 .sync_recv_en    (sync_recv_en),
 .sync_Btoa_en     (sync_Btoa_en),
 
 .slink_rx_rden   (sl_rx_buf_rden),                                     //BUFfER en
 .slink_rx_address(sl_rx_buf_raddr),                            //BUFFER address
 .slink_wen       (o_afpga_wren),                                         //AFPGA Write en
 .slink_waddr     (slink_waddr),                                 //AFPGA write addr
 .slink_data      (om_afpga_wdata)                                   //AFPGA write data
);

//ram_2048_sdp
RAM_2048_8_SDP sl_rx_buf(
 .WD         (sl_rx_buf_din),
 .RD         (sl_rx_buf_dout),
 .WEN        (sl_rx_buf_wren),
 .REN        (sl_rx_buf_rden),
 .WADDR      (sl_rx_buf_waddr),
 .RADDR      (sl_rx_buf_raddr),
 .WCLK       (clk),
 .RCLK       (clk)
);

RAM_2048_8_SDP sl_tx_buf(
 .WD         (sl_tx_buf_din),
 .RD         (sl_tx_buf_dout),
 .WEN        (sl_tx_buf_wren),
 .REN        (sl_tx_buf_rden),
 .WADDR      (sl_tx_buf_waddr),
 .RADDR      (sl_tx_buf_raddr),
 .WCLK       (clk),
 .RCLK       (clk)
);




endmodule