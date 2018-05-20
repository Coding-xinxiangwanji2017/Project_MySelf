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
// Name of module : M_NET_rx_buffer
// Project        : MN811_UT4_B01
// Func           : M_NET_rx_buffer
// Author         : Zhang xueyan
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FGG484
// version 1.0    : made in Date: 2016.11.12
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/11/12   Initial version(Zhangxueyan)
//
//
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

module M_NET_rx_buffer(
   //-----------------------------------------------------------
   //--clock reset
   //-----------------------------------------------------------
    input  wire            sys_clk             ,//system clock ,50m
    input  wire            rst_n               ,//reset ,active low

   //-----------------------------------------------------------
   //--rx
   //-----------------------------------------------------------

    input  wire            i_rx_start          ,// start to recive data
    input  wire            i_rx_end            ,// stop  receiving data
    input  wire            i_rx_data_en_p      ,// receive data enable
    input  wire  [07:00]   im_rx_data_p        ,// receive data
    output reg             o_req               ,// request to send
    input  wire  [07:00]   im_rd_addr          ,// read address
    output  wire [07:00]   om_rd_data           // read data

);

   //=======================================================
   // Local parameters
   //=======================================================

    parameter   NUM                 = 8'd156; // frame length ,except frame board and lead code
   //=======================================================
   // Internal signal definition
   //=======================================================
    reg [07:00]   r_count  ;
    reg           r_rx_en  ;
    reg [07:00]   r_rx_addr;

   //=======================================================
   // r_cycle
   //=======================================================

    //receive data busy
     always @(posedge sys_clk or negedge rst_n)
     begin
       if(!rst_n)
         r_rx_en  <= 1'b0;
       else if(i_rx_start)
         r_rx_en  <= 1'b1;
       else if(i_rx_end )
         r_rx_en  <= 1'b0;
       else
         r_rx_en  <= r_rx_en;
     end

    //frame length counter
     always @(posedge sys_clk or negedge rst_n)
     begin
       if(!rst_n)
         r_count  <= 8'd0;
       else if (r_rx_en && i_rx_data_en_p)
         r_count  <= r_count + 1;
       else if(r_rx_en)
         r_count  <= r_count;
       else
         r_count  <= 8'd0;
     end

    // write ram address
     always @(posedge sys_clk or negedge rst_n)
     begin
       if(!rst_n)
         r_rx_addr  <= 8'd0;
       else if (i_rx_data_en_p && (r_count == NUM-1))
         r_rx_addr  <= 8'd0;
       else if (r_rx_en && i_rx_data_en_p)
         r_rx_addr  <= r_rx_addr + 1;
       else if (r_rx_en)
         r_rx_addr  <= r_rx_addr;
       else
         r_rx_addr  <= 8'd0;
     end

   //request to send
    always @(posedge sys_clk or negedge rst_n)
     begin
       if(!rst_n)
         o_req  <= 1'b0;
       else if ((r_count == NUM) && (i_rx_end == 1))
         o_req  <= 1'b1;
       else
         o_req  <= 1'b0;
     end

   // store frame data,depth 256
    RAM_256_8_DP u1_RAM_256_8_DP(
        .A_ADDR                (im_rd_addr      ),
        .A_CLK                 (sys_clk         ),
        .B_ADDR                (8'd0            ),
        .B_CLK                 (sys_clk         ),
        .C_ADDR                (r_rx_addr       ),
        .C_CLK                 (sys_clk         ),
        .C_DIN                 (im_rx_data_p    ),
        .C_WEN                 (i_rx_data_en_p  ),

        .A_DOUT                (om_rd_data      ),
        .B_DOUT                (                )
    );

endmodule