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
// Name of module : tb_STATION
// Project        : NicSys8000
// Func           : testbench for control station
// Author         : Tan Xingye
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FGG484
// version 1.0    : made in Date: 2016.4.21
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/04/21   Initial version(Tan Xingye)
//
//
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps


module tb_STATION 
   #(
    parameter STAT    =  8'b0000_0000
    )
   (
    //-----------------------------------------------------------
    //-- C-LINK
    //-----------------------------------------------------------

    output wire            Channel_1_TX_P,
    output wire            Channel_1_TX_N,
    input  wire            Channel_1_RX_P,
    input  wire            Channel_1_RX_N,

    output wire            Channel_2_TX_P,
    output wire            Channel_2_TX_N,
    input  wire            Channel_2_RX_P,
    input  wire            Channel_2_RX_N,

    output wire            Channel_3_TX_P,
    output wire            Channel_3_TX_N,
    input  wire            Channel_3_RX_P,
    input  wire            Channel_3_RX_N,

    output wire            Channel_4_TX_P,
    output wire            Channel_4_TX_N,
    input  wire            Channel_4_RX_P,
    input  wire            Channel_4_RX_N,

    output wire            Channel_5_TX_P,
    output wire            Channel_5_TX_N,
    input  wire            Channel_5_RX_P,
    input  wire            Channel_5_RX_N,

    output wire            Channel_6_TX_P,
    output wire            Channel_6_TX_N,
    input  wire            Channel_6_RX_P,
    input  wire            Channel_6_RX_N,

    //-----------------------------------------------------------
    //-- M-NET, Ethernet: RMII interface-2
    //-----------------------------------------------------------
    output wire             ETH2_RST_n,
    output wire             ETH2_REFCLK,
    input  wire [ 1: 0]     ETH2_RXD_O,
    input  wire             ETH2_RXDV_O,
    input  wire             ETH2_RXER,
    output wire             ETH2_TXEN,
    output wire [ 1: 0]     ETH2_TXD,
    output wire             ETH2_COM_LED
);

//------------------------------------------------------------------------------
//参数声明  开始
//------------------------------------------------------------------------------
  parameter GND = 1'd0;


  //------------------------------------
  //-- Station ID，Rack ID, Slot ID
  //------------------------------------
  //parameter STAT    =  8'b0000_0000;

//------------------------------------------------------------------------------
//参数声明  结束
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//内部变量声明  开始
//------------------------------------------------------------------------------
  wire          w_MBUS_1_P;
  wire          w_MBUS_1_N;
  wire          w_MBUS_2_P;
  wire          w_MBUS_2_N;

  wire          w_LBUS_1_P;
  wire          w_LBUS_1_N;
  wire          w_LBUS_2_P;
  wire          w_LBUS_2_N;




//------------------------------------------------------------------------------
//模块调用参考 开始
//------------------------------------------------------------------------------


  //************************************************************
  //--  Main Rack
  //************************************************************

  defparam u1_tb_MAIN_RACK.STAT   =  STAT;
  defparam u1_tb_MAIN_RACK.RACK   =  4'b0000;
  tb_MAIN_RACK u1_tb_MAIN_RACK(
    //-----------------------------------------------------------
    //-- M-BUS
    //-----------------------------------------------------------
    .MBUS_1_P       (w_MBUS_1_P),
    .MBUS_1_N       (w_MBUS_1_N),
    .MBUS_2_P       (w_MBUS_2_P),
    .MBUS_2_N       (w_MBUS_2_N),

    //-----------------------------------------------------------
    //-- L-BUS
    //-----------------------------------------------------------
    .LBUS_B1_P       (w_LBUS_1_P),
    .LBUS_B1_N       (w_LBUS_1_N),
    .LBUS_B2_P       (w_LBUS_2_P),
    .LBUS_B2_N       (w_LBUS_2_N),

    //-----------------------------------------------------------
    //-- C-LINK
    //-----------------------------------------------------------
    .Channel_1_TX_P    (Channel_1_TX_P         ),
    .Channel_1_TX_N    (Channel_1_TX_N         ),
    .Channel_1_RX_P    (Channel_1_RX_P         ),
    .Channel_1_RX_N    (Channel_1_RX_N         ),

                                       
    .Channel_2_TX_P    (Channel_2_TX_P         ),
    .Channel_2_TX_N    (Channel_2_TX_N         ),
    .Channel_2_RX_P    (Channel_2_RX_P         ),
    .Channel_2_RX_N    (Channel_2_RX_N         ),
                                       
    .Channel_3_TX_P    (Channel_3_TX_P         ),
    .Channel_3_TX_N    (Channel_3_TX_N         ),
    .Channel_3_RX_P    (Channel_3_RX_P         ),
    .Channel_3_RX_N    (Channel_3_RX_N         ),
                                       
    .Channel_4_TX_P    (Channel_4_TX_P         ),
    .Channel_4_TX_N    (Channel_4_TX_N         ),
    .Channel_4_RX_P    (Channel_4_RX_P         ),
    .Channel_4_RX_N    (Channel_4_RX_N         ),
                                       
    .Channel_5_TX_P    (Channel_5_TX_P         ),
    .Channel_5_TX_N    (Channel_5_TX_N         ),
    .Channel_5_RX_P    (Channel_5_RX_P         ),
    .Channel_5_RX_N    (Channel_5_RX_N         ),
                                       
    .Channel_6_TX_P    (Channel_6_TX_P         ),
    .Channel_6_TX_N    (Channel_6_TX_N         ),
    .Channel_6_RX_P    (Channel_6_RX_P         ),
    .Channel_6_RX_N    (Channel_6_RX_N         ),
                                       


    //-----------------------------------------------------------
    //-- Ethernet: RMII interface-2
    //-----------------------------------------------------------
    .ETH2_RST_n          (ETH2_RST_n     ),
    .ETH2_REFCLK         (ETH2_REFCLK    ),
    .ETH2_RXD_O          (ETH2_RXD_O     ),
    .ETH2_RXDV_O         (ETH2_RXDV_O    ),
    .ETH2_RXER           (ETH2_RXER      ),
    .ETH2_TXEN           (ETH2_TXEN      ),
    .ETH2_TXD            (ETH2_TXD       ),
    .ETH2_COM_LED        (ETH2_COM_LED   )

    //-----------------------------------------------------------
    //-- Inpit/Output digital/anloag signals
    //-- Fron DI/DO/AI/AO
    //-----------------------------------------------------------

);

/*

  //************************************************************
  //--  IO Rack #1
  //************************************************************
  defparam u1_tb_IO_RACK.STAT   =  STAT;
  defparam u1_tb_IO_RACK.RACK   =  4'b0001;
  tb_IO_RACK u1_tb_IO_RACK(
    //-----------------------------------------------------------
    //-- M-BUS
    //-----------------------------------------------------------
    .MBUS_1_P       (w_MBUS_1_P),
    .MBUS_1_N       (w_MBUS_1_N),
    .MBUS_2_P       (w_MBUS_2_P),
    .MBUS_2_N       (w_MBUS_2_N),

    //-----------------------------------------------------------
    //-- L-BUS
    //-----------------------------------------------------------
    .LBUS_1_P       (w_LBUS_1_P),
    .LBUS_1_N       (w_LBUS_1_N),
    .LBUS_2_P       (w_LBUS_2_P),
    .LBUS_2_N       (w_LBUS_2_N)

    //-----------------------------------------------------------
    //-- Inpit/Output digital/anloag signals
    //-- Fron DI/DO/AI/AO
    //-----------------------------------------------------------

);


  //************************************************************
  //--  IO Rack #2
  //************************************************************
  defparam u2_tb_IO_RACK.STAT   =  STAT;
  defparam u2_tb_IO_RACK.RACK   =  4'b0010;
  tb_IO_RACK u2_tb_IO_RACK(
    //-----------------------------------------------------------
    //-- M-BUS
    //-----------------------------------------------------------
    .MBUS_1_P       (w_MBUS_1_P),
    .MBUS_1_N       (w_MBUS_1_N),
    .MBUS_2_P       (w_MBUS_2_P),
    .MBUS_2_N       (w_MBUS_2_N),

    //-----------------------------------------------------------
    //-- L-BUS
    //-----------------------------------------------------------
    .LBUS_1_P       (w_LBUS_1_P),
    .LBUS_1_N       (w_LBUS_1_N),
    .LBUS_2_P       (w_LBUS_2_P),
    .LBUS_2_N       (w_LBUS_2_N)

    //-----------------------------------------------------------
    //-- Inpit/Output digital/anloag signals
    //-- Fron DI/DO/AI/AO
    //-----------------------------------------------------------

);


  //************************************************************
  //--  IO Rack #3
  //************************************************************
  defparam u3_tb_IO_RACK.STAT   =  STAT;
  defparam u3_tb_IO_RACK.RACK   =  4'b0011;
  tb_IO_RACK u3_tb_IO_RACK(
    //-----------------------------------------------------------
    //-- M-BUS
    //-----------------------------------------------------------
    .MBUS_1_P       (w_MBUS_1_P),
    .MBUS_1_N       (w_MBUS_1_N),
    .MBUS_2_P       (w_MBUS_2_P),
    .MBUS_2_N       (w_MBUS_2_N),

    //-----------------------------------------------------------
    //-- L-BUS
    //-----------------------------------------------------------
    .LBUS_1_P       (w_LBUS_1_P),
    .LBUS_1_N       (w_LBUS_1_N),
    .LBUS_2_P       (w_LBUS_2_P),
    .LBUS_2_N       (w_LBUS_2_N)

    //-----------------------------------------------------------
    //-- Inpit/Output digital/anloag signals
    //-- Fron DI/DO/AI/AO
    //-----------------------------------------------------------

);



*/

//------------------------------------------------------------------------------
//逻辑参考  开始
//------------------------------------------------------------------------------


  //-------------------------------------------------
  //  Connection
  //-------------------------------------------------
  



//------------------------------------------------------------------------------
//逻辑参考  结束
//------------------------------------------------------------------------------








endmodule

