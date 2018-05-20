/*=======================================================================================*\
--  Copyright (c)2015 CNCS Incorporated
\*=======================================================================================*\
  All Rights Reserved
  THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of CNCS Inc.

  The copyright notice above does not evidence any actual or intended publication of
  such source code. No part of this code may be reproduced, stored in a retrieval
  system, or transmitted, in any form or by any means, electronic, mechanical,
  photocopying, recording, or otherwise, without the prior written permission of CNCS.

/*=======================================================================================*\
--  RTL File Attribute
\*=======================================================================================*\
  -- Project     : NicSys8000N
  -- Simulator   : Modelsim 10.2         Windows-7 64bit
  -- Synthesizer : LiberoSoC v11.5 SP2   Windows-7 64bit
  -- FPGA Type   : Microsemi  M2GL050-FGG484

  -- Module Funcion : M_NET top file
  -- Initial Author : Tan Xingye


  -- Modification Logs:
     --------------------------------------------------------------------------------
       Version      Date            Description(Recorder)
     --------------------------------------------------------------------------------
         1.0     2016/04/12     Initial version(Tan Xingye)




/*=======================================================================================*/


`timescale 1ns / 100ps

module M_NET(

    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input                rst_n            ,

    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input                clk_50m          ,

    //------------------------------------------
    //-- Ethernet, RMII interface
    //------------------------------------------
    input       [1:0]         ETH_RXD    ,
    input                ETH_RXDV        ,
    input                ETH_RXER        ,
    input                ETH_INTRP       ,
    inout                ETH_MDIO        ,
    output               ETH_TXEN        ,
    output     [1:0]     ETH_TXD    ,
    output               ETH_RST_n       ,
    //-- REFCLK, Output for PFPGA, input for
    output               ETH_REFCLK      ,
    input                ETH_LEDG        ,
    input                ETH_LEDY        ,
    input                ETH_COM_LED     ,

    //------------------------------------------
    //-- application interface:
    //------------------------------------------
    //-- TX
    input         Tx_Ram_Wr         ,
    input  [7:0]  Tx_Ram_Addr,
    input  [7:0]  Tx_Ram_Data,
    input         Tx_Start,
    output        Tx_Busy,

    //-- Rx
    input          Rx_Ram_Rd,
    input   [7:0]  Rx_Ram_Addr,
    output  [7:0]  Rx_Ram_Data,
    output         Rx_Done
    );



   //=========================================================
   // Local parameters
   //=========================================================
   parameter DLY       = 1;


   //=========================================================
   // Internal signal definition
   //=========================================================
   wire      [7:0]      RMII_Tx_D   ;
   wire                 RMII_Tx_DV  ;
   wire      [7:0]      RMII_Rx_D   ;
   wire                 RMII_Rx_DV  ;


   assign ETH_REFCLK = clk_50m;


   //=========================================================
   //
   //=========================================================
   M_NET_RMII RMII_inst(
    //------------------------------------------
    //--  clock,  reset(active low)
    //------------------------------------------
    .clk       (ETH_REFCLK),
    .rst_n     (rst_n),
    //------------------------------------------
    //-- phy side
    //------------------------------------------
    .rx_en     (ETH_RXDV),
    .rxd       (ETH_RXD),
    .tx_en     (ETH_TXEN),
    .txd       (ETH_TXD),
    //------------------------------------------
    //-- system side
    //------------------------------------------
    //-- Send: 8bits data and send each 4 clock cycles
    .tx_data_en  (RMII_Tx_DV),
    .tx_data     (RMII_Tx_D ),
    .rx_data_en  (RMII_Rx_DV),
    .rx_data     (RMII_Rx_D )
    );



   //=========================================================
   // Component Declarations
   //=========================================================


   M_NET_Link M_NET_Link_inst(

    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    .rst_n       (rst_n)      ,
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    .clk_50m     (clk_50m )     ,
    //------------------------------------------
    //-- Application
    //------------------------------------------
    .Tx_Ram_WEN    (Tx_Ram_Wr)     ,
    .Tx_Ram_WADDR  (Tx_Ram_Addr)      ,
    .Tx_Ram_WD     (Tx_Ram_Data)     ,
    .Tx_Start      (Tx_Start)     ,
    .Tx_Busy       (Tx_Busy)   ,
    //-- Rx
    .Rx_Ram_REN         (),
    .Rx_Ram_RADDR       (),
    .Rx_Ram_RD          (),
    .Rx_Done            (),
    .Rx_Err             (),
    //------------------------------------------
    //-- RMII Module
    //------------------------------------------
    //-- Send: 8bits data and send each 4 clock cycles
    .Tx_Data_En    (RMII_Tx_DV),
    .Tx_Data       (RMII_Tx_D ),

    .Rx_Start      (RMII_Rx_Start),
    .Rx_end        (RMII_Rx_End),
    .Rx_Data_En    (RMII_Rx_DV),
    .Rx_Data       (RMII_Rx_D )
    );








endmodule
