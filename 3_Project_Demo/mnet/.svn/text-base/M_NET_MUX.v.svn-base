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
// Name of module : M_NET_MUX
// Project        : MN811_UT4_B01
// Func           : M_NET_MUX
// Author         : Zhang xueyan
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FGG484
// version 1.0    : made in Date: 2016.11.12
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/11/12   Initial version(Zhang xueyan)
//
//
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

module M_NET_MUX(
   //-----------------------------------------------------------
   //--clock reset
   //-----------------------------------------------------------
    input  wire            sys_clk                ,
    input  wire            rst_n                  ,

   //-----------------------------------------------------------
   //--mode
   //-----------------------------------------------------------
   input  wire  [02:00]   im_mode_reg             ,

   //-----------------------------------------------------------
   //--tx
   //-----------------------------------------------------------

    input  wire           i_rx_start_1            ,
    input  wire           i_rx_end_1              ,
    input  wire           i_rx_data_en_p_1        ,
    input  wire  [07:00]  im_rx_data_p_1          ,

    input  wire           i_rx_start_2            ,
    input  wire           i_rx_end_2              ,
    input  wire           i_rx_data_en_p_2        ,
    input  wire  [07:00]  im_rx_data_p_2          ,

    output wire           o_rx_start              ,
    output wire           o_rx_end                ,
    output wire  [07:00]  om_rx_data_p            ,
    output wire           o_rx_data_en_p          ,


   //-----------------------------------------------------------
   //-- tx  data
   //-----------------------------------------------------------

    input  wire  [07:00]   im_tx_data             ,
    input  wire            i_tx_data_en           ,
    input  wire            i_tx_busy              ,


    output wire            o_tx_data_en_1         ,
    output wire  [07:00]   om_tx_data_1           ,
    output wire            o_tx_data_en_2         ,
    output wire  [07:00]   om_tx_data_2

);

   //=======================================================
   // Internal signal definition
   //=======================================================
    wire          w_req1     ;
    wire          w_req2     ;
    wire [07:00]  w_rd_addr1 ;
    wire [07:00]  w_rd_addr2 ;
    wire [07:00]  w_rd_data1 ;
    wire [07:00]  w_rd_data2 ;

   //=======================================================
   // Internal logic
   //=======================================================

M_NET_rx_buffer u1_M_NET_rx_buffer(
  //-----------------------------------------------------------
  //--clock reset
  //-----------------------------------------------------------
    .sys_clk             (sys_clk         ),
    .rst_n               (rst_n           ),

  //-----------------------------------------------------------
  //--rx
  //-----------------------------------------------------------
    .i_rx_start          (i_rx_start_1    ),
    .i_rx_end            (i_rx_end_1      ),
    .i_rx_data_en_p      (i_rx_data_en_p_1),
    .im_rx_data_p        (im_rx_data_p_1  ),
    .o_req               (w_req1          ),
    .im_rd_addr          (w_rd_addr1      ),
    .om_rd_data          (w_rd_data1      )
);

M_NET_rx_buffer u2_M_NET_rx_buffer(

  //-----------------------------------------------------------
  //--clock reset
  //-----------------------------------------------------------
    .sys_clk             (sys_clk         ),
    .rst_n               (rst_n           ),

  //-----------------------------------------------------------
  //--rx
  //-----------------------------------------------------------
    .i_rx_start          (i_rx_start_2    ),
    .i_rx_end            (i_rx_end_2      ),
    .i_rx_data_en_p      (i_rx_data_en_p_2),
    .im_rx_data_p        (im_rx_data_p_2  ),
    .o_req               (w_req2          ),
    .im_rd_addr          (w_rd_addr2      ),
    .om_rd_data          (w_rd_data2      )
);

M_NET_req_ctrl  u1_M_NET_req_ctrl(
  //-----------------------------------------------------------
  //--clock reset
  //-----------------------------------------------------------
    .sys_clk             (sys_clk         ),
    .rst_n               (rst_n           ),
  //-----------------------------------------------------------
  //-- req
  //-----------------------------------------------------------
    .i_req_1             (w_req1          ),
    .i_req_2             (w_req2          ),
    .im_mode_reg         (im_mode_reg     ),


  //-----------------------------------------------------------
  //-- tx  data
  //-----------------------------------------------------------
    .om_rd_addr_1        (w_rd_addr1      ),
    .im_rd_data_1        (w_rd_data1      ),
    .om_rd_addr_2        (w_rd_addr2      ),
    .im_rd_data_2        (w_rd_data2      ),
    .o_rx_start          (o_rx_start      ),
    .om_rx_data_p        (om_rx_data_p    ),
    .o_rx_data_en_p      (o_rx_data_en_p  ),
    .o_rx_end            (o_rx_end        ),

  //-----------------------------------------------------------
  //-- rx  data
  //-----------------------------------------------------------
    .im_tx_data          (im_tx_data      ),
    .i_tx_data_en        (i_tx_data_en    ),
    .i_tx_busy           (i_tx_busy       ),
    .o_tx_data_en_1      (o_tx_data_en_1  ),
    .om_tx_data_1        (om_tx_data_1    ),
    .o_tx_data_en_2      (o_tx_data_en_2  ),
    .om_tx_data_2        (om_tx_data_2    )

);
endmodule