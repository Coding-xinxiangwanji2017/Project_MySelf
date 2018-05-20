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

  -- Module Funcion : MN811 PFPGA top file
  -- Initial Author : Tan Xingye


  -- Modification Logs:
     --------------------------------------------------------------------------------
       Version      Date            Description(Recorder)
     --------------------------------------------------------------------------------
         1.0     2016/04/12     Initial version(Tan Xingye)




/*=======================================================================================*/


`timescale 1ns / 100ps

module MN811_PFPGA(

    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input                FP_RSTA_n        ,
    
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input                 CLK_25MP1       ,
    input                 CLK_50MP1       ,
    
    //------------------------------------------
    //--  DFPGA
    //------------------------------------------
    inout                FIO_DAT[23:0]    ,
    inout                FIO_CS0          ,
    inout                FIO_CS1          ,
    inout                FIO_CS2          ,
    inout                FIO_RE           ,
    inout                FIO_WE           ,
    inout                FIO_ALE          ,
    inout                FIO_TICK         ,
    inout                FIO_RSTIN        ,
    inout                FIO_RSTO         ,
    inout                FIO_CLK          ,

    /*
    //------------------------------------------
    //-- JTAG
    //------------------------------------------
    inout                FPJTAG_SEL       ,
    inout                FPJTAG_TCK       ,
    inout                FPJTAG_TDI       ,
    inout                FPJTAG_TDO       ,
    inout                FPJTAG_TMS       ,
    inout                FPJTAG_TRST      ,
    */
    
    //------------------------------------------ 
    //-- Power detection, heartbeat detection
    //------------------------------------------
    input                FDWR_OV          ,
    input                FDWR_UV          ,
    output               FPWR_DPG         ,
    
    //------------------------------------------
    //-- Rack ID and Slot ID
    //------------------------------------------
    input                FDP_RACK[3:0]    ,
    input                FDP_SLOT[4:0]    ,
    //-- Station ID
    input                FDP_STAT[7:0]    ,

    //-- Mode keys
    input                FP_MKEY[3:1]     ,
    
    //------------------------------------------ 
    //-- LED indicator
    //------------------------------------------
    output               FP_LED3          ,
    output               FP_LED4          ,
    output               FP_ERR_LED       ,
    output               FP_LED6          ,
    
    //------------------------------------------
    //-- Test Signals
    //------------------------------------------
    output               TEST_T[16:1]     ,
    
    //------------------------------------------
    //-- Ethernet #1
    //------------------------------------------
    input                ETH1_RXD[1:0]    ,
    input                ETH1_RXDV        ,
    input                ETH1_RXER        ,
    input                ETH1_INTRP       ,
    inout                ETH1_MDIO        ,
    output               ETH1_TXEN        ,
    output               ETH1_TXD[1:0]    ,
    output               ETH1_RST_n       ,
    output               ETH1_REFCLK      ,
    input                ETH1_LEDG        ,
    input                ETH1_LEDY        ,
    input                ETH1_COM_LED     ,
    
    //------------------------------------------
    //-- Ethernet #2
    //------------------------------------------
    input                ETH2_RXD[1:0]    ,
    input                ETH2_RXDV        ,
    input                ETH2_RXER        ,
    input                ETH2_INTRP       ,
    inout                ETH2_MDIO        ,
    output               ETH2_TXEN        ,
    output               ETH2_TXD[1:0]    ,
    output               ETH2_RST_n       ,
    output               ETH2_REFCLK      ,
    input                ETH2_LEDG        ,
    input                ETH2_LEDY        ,
    input                ETH2_COM_LED     ,
    //------------------------------------------
    //-- Watchdog
    //------------------------------------------
    input                FP_WDOA          ,
    output               FP_WDIA          ,
    output               FD_WDOB          ,
    //------------------------------------------
    //-- M-BUS
    //------------------------------------------
    output               TICL_MB_PREM     ,
    output               TICL_MB_TXEN1    ,
    input                TICL_MB_RX1      ,
    output               TICL_MB_TX1      ,
    output               TICL_MB_TXEN2    ,
    input                TICL_MB_RX2      ,
    output               TICL_MB_TX2      ,
    //------------------------------------------
    //-- I2C Bus
    //------------------------------------------
    output               I2C_SCL_TEMSR    ,
    inout                I2C_SDA_TEMSR    ,
    //------------------------------------------
    //-- SRAM #1
    //------------------------------------------
    output               PSRAM1_A[19:0]   ,
    output               PSRAM1_OE_n      ,
    output               PSRAM1_WE_n      ,
    output               PSRAM1_CE1_n     ,
    output               PSRAM1_CE2       ,
    inout                PSRAM1_D[15:0]   ,
    input                PSRAM1_ERR_n     ,
    output               PSRAM1_BHE_n     ,
    output               PSRAM1_BLE_n     ,
    //------------------------------------------
    //-- SRAM #2                          ,
    //------------------------------------------
    output               PSRAM2_A[19:0]   ,
    output               PSRAM2_OE_n      ,
    output               PSRAM2_WE_n      ,
    output               PSRAM2_CE1_n     ,
    output               PSRAM2_CE2       ,
    inout                PSRAM2_D[15:0]   ,
    input                PSRAM2_ERR_n     ,
    output               PSRAM2_BHE_n     ,
    output               PSRAM2_BLE_n     ,
    
    //------------------------------------------
    //--
    //------------------------------------------
    input                PLUG_MON         ,
    input                FP_FLGDEN
    );



   //=========================================================
   // Local parameters
   //=========================================================
   parameter DLY       = 1;
   parameter IDLE      = 4'b0001,
             WAIT_CMP  = 4'b0010,
             CALCULATE = 4'b0100,
             WAIT_OUT  = 4'b1000;

   //=========================================================
   // Internal signal definition
   //=========================================================
   reg[3  : 0]   curr_state;
   reg[3  : 0]   next_state;
   reg           tmp_input_ena;
   reg[31 : 0]   tmp_input_real;
   reg[31 : 0]   tmp_input_imag;
   reg           tmp_real_type;
   reg           tmp_imag_type;
   reg[1:0]      tmp_quadrant_type; // 0, 1, 2, 3

   wire          tmp_output_ena;
   wire[15 : 0]  tmp_output_data;

   //=========================================================
   // Current state
   //=========================================================
   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         curr_state <= IDLE;
      else
         curr_state <= #DLY next_state;
   end

   //=========================================================
   // Next state
   //=========================================================
   always @(input_ena or curr_state or tmp_output_ena)
   begin
      case ( curr_state )
         IDLE :
            if ( input_ena == 1'b1 )
               next_state = WAIT_CMP;
            else
               next_state = IDLE;
         WAIT_CMP :
            next_state = CALCULATE;
         CALCULATE :
            next_state = WAIT_OUT;
         WAIT_OUT :
            if ( tmp_output_ena == 1'b1 )
               next_state = IDLE;
            else
               next_state = WAIT_OUT;
         default:
            next_state = IDLE;
      endcase
   end

   //=========================================================
   // tmp_input_ena : Using D Flip-flop to buffer
   //=========================================================
   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         tmp_input_ena <= 1'b0;
      else
         if ( curr_state == IDLE)
            tmp_input_ena <= #DLY input_ena;
         else
            tmp_input_ena <= #DLY 1'b0;
   end

   //=========================================================
   // tmp_input_real : the input_real is change to value larger than 0
   //=========================================================
   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         tmp_input_real <= 0;
      else
         if ( curr_state == IDLE && input_ena == 1'b1 )
            if ( input_real > 0 )
               tmp_input_real <= #DLY input_real;
            else
               tmp_input_real <= #DLY (~input_real) + 1;
         else
            tmp_input_real <= #DLY tmp_input_real;
   end


endmodule
