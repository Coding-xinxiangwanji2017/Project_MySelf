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
// Name of module : NP811_BOARD_B01_TOP
// Project        : NicSys8000
// Func           : NP811 BOARD Top
// Author         : Zhang Xueyan
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL150_FCV484
// version 1.0    : made in Date: 2016.4.21
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/04/21   Initial version(Zhang Xueyan)
//
//
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

module NP811_BOARD_B01(
    //-----------------------------------------------------------
    //-- Mode switch
    //-----------------------------------------------------------
    input  wire                M_KEY1        ,
    input  wire                M_KEY2        ,
    input  wire                M_KEY3        ,

    //-----------------------------------------------------------
    //-- Station ID, Rack ID, Slot ID
    //-----------------------------------------------------------
    input  wire [ 3: 0]        RACK          ,
    input  wire [ 4: 0]        SLOT          ,
    input  wire [ 7: 0]        STAT          ,

    //-----------------------------------------------------------
    //-- M-BUS
    //-----------------------------------------------------------
    inout  tri                 MBUS_1_P      ,
    inout  tri                 MBUS_1_N      ,
    inout  tri                 MBUS_2_P      ,
    inout  tri                 MBUS_2_N      ,

    //-----------------------------------------------------------
    //-- L-BUS
    //-----------------------------------------------------------
    inout  tri                 LBUS_B1_P     ,
    inout  tri                 LBUS_B1_N     ,
    inout  tri                 LBUS_B2_P     ,
    inout  tri                 LBUS_B2_N     ,

    //-----------------------------------------------------------
    //-- C-BUS 
    //-----------------------------------------------------------
    inout  tri                 RBUS_A1_P     ,
    inout  tri                 RBUS_A1_N     ,
    inout  tri                 RBUS_A2_P     ,
    inout  tri                 RBUS_A2_N     ,

    //-----------------------------------------------------------
    //-- R-BUS
    //-----------------------------------------------------------
    inout  tri                 RBUS_B1_P     ,
    inout  tri                 RBUS_B1_N     ,
    inout  tri                 RBUS_B2_P     ,
    inout  tri                 RBUS_B2_N     ,

    //-----------------------------------------------------------
    //-- S-LINK
    //-----------------------------------------------------------
    inout  tri                 SLINKA_DO_P   ,
    inout  tri                 SLINKA_DO_N   ,
    inout  tri                 SLINKA_DI_P   ,
    inout  tri                 SLINKA_DI_N   ,
    inout  tri                 SLINKB_DO_P   ,
    inout  tri                 SLINKB_DO_N   ,
    inout  tri                 SLINKB_DI_P   ,
    inout  tri                 SLINKB_DI_N

);


//------------------------------------------------------------------------------
//参数声明  开始
//------------------------------------------------------------------------------
  parameter GND = 1'd0;


  //------------------------------------
  //-- Mode switch
  //------------------------------------
  //parameter M_KEY1   = 1'b0;
  //parameter M_KEY2   = 1'b0;
  //parameter M_KEY3   = 1'b0; 
  
  

//------------------------------------------------------------------------------
//参数声明  结束
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//内部变量声明  开始
//------------------------------------------------------------------------------
  wire          FP_RST    ;
  wire          CLK_25MFP ;
  wire          CLK_50MFP ;

  //--  C-BUS
  
  wire          PFPGA_RA_TXEN1 ;
  wire          PFPGA_RA_TXEN2 ;
  wire          RA_RX1   ; 
  wire          RA_TX1   ;
  wire          RA_RX2   ;
  wire          RA_TX2   ;
  wire          DFPGA_RA_PREM ;
    
  //-- R-BUS
  wire          PFPGA_RB_TXEN1 ;
  wire          PFPGA_RB_TXEN2 ;
  wire          RB_RX1   ; 
  wire          RB_TX1   ;
  wire          RB_RX2   ;
  wire          RB_TX2   ;
  wire          DFPGA_RB_PREM ;
            
  //-- M-BUS
  wire          PFPGA_MB_TXEN1 ;  
  wire          PFPGA_MB_TXEN2 ;  
  wire          MB_RX1   ;
  wire          MB_TX1   ;
  wire          MB_RX2   ;
  wire          MB_TX2   ;
  wire          DFPGA_MB_PREM ;
  
  
 //-- L-BUS
 
  wire          PFPGA_LB_TXEN1 ; 
  wire          PFPGA_LB_TXEN2 ;
  wire          LB_RX1   ;
  wire          LB_TX1   ;
  wire          LB_RX2   ;
  wire          LB_TX2   ;
  wire          DFPGA_LB_PREM ;

//-- S-LINK 
  wire          PFPGA_SA_TXEN0 ;
  wire          PFPGA_SA_TXEN1 ;
  wire          SA_RX0   ;
  wire          SA_TX0   ;
  wire          SA_RX1   ;
  wire          SA_TX1   ;
  wire          DFPGA_SA_PREM ;
  
 
  //-- PFPGA SRAM
  wire [19: 0]     PSRAM_A;
  wire             PSRAM_OE_n;
  wire             PSRAM_WE_n;
  wire             PSRAM_CE1_n;
  wire             PSRAM_CE2;
  wire [15: 0]     PSRAM_D;
  wire             PSRAM_ERR_n;
  wire             PSRAM_BHE_n;
  wire             PSRAM_BLE_n;
  //-- PFPGA F-RAM
  wire             PFRAM_UB_n;
  wire             PFRAM_LB_n;
  wire             PFRAM_OE_n;
  wire             PFRAM_WE_n;
  wire             PFRAM_CE_n;
  //-- DFPGA SRAM
  wire [19: 0]     DSRAM_A;
  wire             DSRAM_OE_n;
  wire             DSRAM_WE_n;
  wire             DSRAM_CE1_n;
  wire             DSRAM_CE2;
  wire [15: 0]     DSRAM_D;
  wire             DSRAM_ERR_n;
  wire             DSRAM_BHE_n;
  wire             DSRAM_BLE_n;
  //-- DFPGA F-RAM
  wire             DFRAM_UB_n;
  wire             DFRAM_LB_n;
  wire             DFRAM_OE_n;
  wire             DFRAM_WE_n;
  wire             DFRAM_CE_n;

  //-- AFPGA for PFPGA
  wire             APIO_RSTO  ;
  wire             APIO_CLK   ;
  wire             APIO_WE    ;
  wire             APIO_TICK  ;
  wire             APIO_CS1   ;
  wire             APIO_CS2   ;
  wire             APIO_CS3   ;
  wire             APIO_ALE   ;
  wire  [23:0]     APIO_DAT   ;
  wire  [7:0]      FAP_IO     ;
  
  wire             ADIO_RSTO   ;
  wire             ADIO_CLK    ;
  wire             ADIO_WE     ;
  wire             ADIO_TICK   ;
  wire             ADIO_CS1    ;
  wire             ADIO_CS2    ;
  wire             ADIO_CS3    ;
  wire             ADIO_ALE    ;
  wire [23:0]      ADIO_DAT    ;
  wire  [7:0]      FAD_IO      ;
  
  //-- PFPGA <-> DFPGA
  wire           FIO_RSTO   ;
  wire           FIO_CLK    ;
  wire           FIO_TICK   ;
  wire           FIO_RSTIN  ;
  wire           FIO_WE     ;
  wire  [7:0]    FDP_IO     ;
  wire  [20:0]   FIO_DAT    ;
  wire           FIO_DAT21  ;
  wire           FIO_DAT22  ;
  wire           FIO_DAT23  ;
  wire  [2:0]    FIO_CS     ;
  wire           FIO_RE     ;
  wire           FIO_ALE    ;


//------------------------------------------------------------------------------
//板卡上FPGA例化 开始
//------------------------------------------------------------------------------


  //************************************************************
  //--  Process FPGA
  //************************************************************
   NP811_U1_B01 u1_NP811_U1_B01(
    //-----------------------------------------------------------
    //-- Global reset, clocks
    //-----------------------------------------------------------
    .FP_RST              (FP_RST   ),//negedge rst
    .CLK_25MFP           (CLK_25MFP),
    .CLK_50MFP           (CLK_50MFP),
    //-----------------------------------------------------------
    //-- Power Detector
    //-----------------------------------------------------------
    .FDWR_DPG             (),//0 is valid

    //-----------------------------------------------------------
    //-- Watchdog
    //-----------------------------------------------------------
    .FP_WDO                (),
    .FP_WDI                (),
    //.FP_WDO              () ,

    //-----------------------------------------------------------
    //-- Mode Switch
    //-----------------------------------------------------------
    .FDP_MKEY1            (M_KEY1),//[1]: 1 MTC; [2]: 1 NML [3]: 1 DLD
    .FDP_MKEY2            (M_KEY2),
    .FDP_MKEY3            (M_KEY3),

    //-----------------------------------------------------------
    //-- Station ID, Rack ID, Slot ID
    //-----------------------------------------------------------
    .FDP_RACK             (RACK),
    .FDP_SLOT             (SLOT),
    .FDP_STAT             (STAT),


    //-----------------------------------------------------------
    //-- LED indicator
    //-----------------------------------------------------------
    .FP_LED2              (),//RUN
    .FP_LED3Y             (),//Warning
    .FP_ERR_LED           (),//err
    .FP_LED4              (),//com
    .FP_LED6              (),//sync
    .FP_LED5              (),//status1
    .FP_LED7              (),//status2
    .FP_LED8              (),//status3
    .FP_LED9              (),//status4
    .FP_LED10             (),//debug
    .FP_LED11             (),//debug

    //-----------------------------------------------------------
    //-- Plug monitor, active low
    //-----------------------------------------------------------
    .PLUG_MON             (),//1 is not plug; 0 is plug ok

    //-----------------------------------------------------------
    //-- C-BUS
    //-----------------------------------------------------------
    .MVD_RA_RX1           (RA_RX1  ),//C-BUS
    .MVD_RA_TXEN1         (PFPGA_RA_TXEN1),
    .MVD_RA_TX1           (RA_TX1  ),
    .MVD_RA_RX2           (RA_RX2  ),
    .MVD_RA_TXEN2         (PFPGA_RA_TXEN2),
    .MVD_RA_TX2           (RA_TX2  ),

    //-----------------------------------------------------------
    //-- R-BUS
    //-----------------------------------------------------------
    .MVD_RB_RX1           (RB_RX1  ), //R-BUS
    .MVD_RB_TXEN1         (PFPGA_RB_TXEN1),
    .MVD_RB_TX1           (RB_TX1  ),
    .MVD_RB_RX2           (RB_RX2  ),
    .MVD_RB_TXEN2         (PFPGA_RB_TXEN2),
    .MVD_RB_TX2           (RB_TX2  ),

    //-----------------------------------------------------------
    //-- M-BUS
    //-----------------------------------------------------------
     //input wire         TICL_MB_PREM         ,//this for DFPGA using

    .TICL_MB_RX1          (MB_RX1  ),
    .TICL_MB_TXEN1        (PFPGA_MB_TXEN1),
    .TICL_MB_TX1          (MB_TX1  ),
    .TICL_MB_RX2          (MB_RX2  ),
    .TICL_MB_TXEN2        (PFPGA_MB_TXEN2),
    .TICL_MB_TX2          (MB_TX2  ),    

    //-----------------------------------------------------------
    //-- L-BUS
    //-----------------------------------------------------------
    //.TICL_LB_PREM          (TICL_LB_PREM ),//this for DFPGA using

    .TICL_LB_RX1           (LB_RX1  ),
    .TICL_LB_TXEN1         (PFPGA_LB_TXEN1),
    .TICL_LB_TX1           (LB_TX1  ),
    .TICL_LB_RX2           (LB_RX2  ),
    .TICL_LB_TXEN2         (PFPGA_LB_TXEN2),
    .TICL_LB_TX2           (LB_TX2  ),
    //-----------------------------------------------------------
    //-- S-LINK
    //-----------------------------------------------------------
    //.TICL_LB_PREM          (TICL_LB_PREM  ),//this for DFPGA using
    .RIF_SA_RX0            (SA_RX0  ),
    .RIF_SA_TXEN0          (PFPGA_SA_TXEN0  ),
    .RIF_SA_TX0            (SA_TX0    ),
    .RIF_SA_RX1            (SA_RX1    ),
    .RIF_SA_TXEN1          (PFPGA_SA_TXEN1  ),
    .RIF_SA_TX1            (SA_TX1    ),

    //-----------------------------------------------------------
    //-- sync signal of controls
    //-----------------------------------------------------------
    .FDP_LOCKINA            (),
    .FDP_LOCKOA             (),
    .FDP_LOCKINB            (),
    .FDP_LOCKOB             (),


    //-----------------------------------------------------------
    //-- SRAM,FRAM
    //-----------------------------------------------------------
    .PSRAM_A              (PSRAM_A),
    .PSRAM_D              (PSRAM_D),

    .PSRAM_OE_n           (PSRAM_OE_n ),
    .PSRAM_WE_n           (PSRAM_WE_n ),
    .PSRAM_CE1_n          (PSRAM_CE1_n),
    .PSRAM_CE2            (PSRAM_CE2  ),
    .PSRAM_BHE_n          (PSRAM_BHE_n),
    .PSRAM_BLE_n          (PSRAM_BLE_n),
    .PSRAM_ERR            (PSRAM_ERR  ),

    .PFRAM_UB_n           (PFRAM_UB_n ),
    .PFRAM_LB_n           (PFRAM_LB_n ),
    .PFRAM_OE_n           (PFRAM_OE_n ),
    .PFRAM_WE_n           (PFRAM_WE_n ),
    .PFRAM_CE_n           (PFRAM_CE_n ),

    //-----------------------------------------------------------
    //-- SPI interface, Flash W25K64
    //-----------------------------------------------------------
    .FP_SPIF_RST          (),
    .FP_SPI0_SS           (),
    .FP_SPI0_SCK          (),
    .FP_SPI0_SDO          (),
    .FP_SPI0_SDI          (),

     //-----------------------------------------------------------
     //-- Interface with AFPGA
     //-----------------------------------------------------------
    .APIO_RSTO            (APIO_RSTO ),
    .APIO_CLK             (APIO_CLK  ),
    .APIO_WE              (APIO_WE   ),

    .APIO_TICK            (APIO_TICK ),//heartbeat in

    .APIO_CS1             (APIO_CS1  ),//
    .APIO_CS2             (APIO_CS2  ),//
    .APIO_CS3             (APIO_CS3  ),//addr [22:20]
    .APIO_ALE             (APIO_ALE  ),//addr[16]
    .APIO_DAT             (APIO_DAT  ),//addr[15:0] dataout[7:0]
    .FAP_IO               (FAP_IO    ),//datainput

    //-----------------------------------------------------------
    //-- Interface with DFPGA
    //-----------------------------------------------------------
    .FIO_RSTO             (FIO_RSTO ),//reset dfpga
    .FIO_CLK              (FIO_CLK  ),//clk
    .FIO_TICK             (FIO_TICK ),//heartbeat out
    .FIO_RSTIN            (FIO_RSTIN),//heartbeat in
    .FIO_WE               (FIO_WE   ),//Wren

    .FDP_IO               (FDP_IO   ),//[20:13]addr;
    .FIO_DAT              (FIO_DAT  ),//[12:0] addr; [20:13] output wire data

    .FIO_DAT21            (FIO_DAT21),//==[7:0] input data
    .FIO_DAT22            (FIO_DAT22),//==[7:0] input data
    .FIO_DAT23            (FIO_DAT23),//==[7:0] input data
    .FIO_CS               (FIO_CS   ),//==[7:0] input data
    .FIO_RE               (FIO_RE   ),//==[7:0] input data
    .FIO_ALE              (FIO_ALE  ),//==[7:0] input data

    //-----------------------------------------------------------
    //-- Ethernet: RMII interface-1
    //-----------------------------------------------------------
    .ETH1_RXD             (),
    .ETH1_CRS             (),//rx valid
    .ETH1_TXEN            (),
    .ETH1_TXD             (),
    .ETH1_RST_n           (),
    .ETH1_REFCLK          (),
    
    //------------------------------------------------------------
    //-- Test pins
    //------------------------------------------------------------
    .FP_TP                ()
    );




   //************************************************************
   //--  Diagnose FPGA
   //************************************************************
   NP811_U3_B01 u1_NP811_U3_B01(

    //-----------------------------------------------------------
    //-- Global reset, clocks
    //-----------------------------------------------------------
    .FD_RST               (FP_RST   ),//negedge rst
    .CLK_25MFD            (CLK_25MFP),
    .CLK_50MFD            (CLK_50MFD),

    //-----------------------------------------------------------
    //-- Power Detector
    //-----------------------------------------------------------
    .FPWR_PG1             (),//0 is valid
    .FPWR_PG2             (),//0 is valid
    .FPWR_PG3             (),//0 is valid
    .FPWR_OV              (),//0 is valid
    .FPWR_UV              (),//0 is valid


    //-----------------------------------------------------------
    //-- Watchdog
    //-----------------------------------------------------------
    .FD_WDO               (),
    .FD_WDI               (),
    //.FP_WDO               (),

    //-----------------------------------------------------------
    //-- Mode Switch
    //-----------------------------------------------------------
    .FDP_MKEY1            (M_KEY1 ),//[1]: 1 MTC; [2]: 1 NML [3]: 1 DLD
    .FDP_MKEY2            (M_KEY2 ),
    .FDP_MKEY3            (M_KEY3 ),

    //-----------------------------------------------------------
    //-- Station ID, Rack ID, Slot ID
    //-----------------------------------------------------------
    .FDP_RACK             (RACK),
    .FDP_SLOT             (SLOT),
    .FDP_STAT             (STAT),

     //-----------------------------------------------------------
     //-- LED indicator
     //-----------------------------------------------------------
     .FD_LED3Y             (),//Warning
     .FD_LED14             (),//debug
     .FD_LED15             (),//debug

    //-----------------------------------------------------------
    //-- Plug monitor, active low
    //-----------------------------------------------------------
    .PLUG_MON              (), //1 is not plug; 0 is plug ok

    //-----------------------------------------------------------
    //-- C-BUS
    //-----------------------------------------------------------
    .MVD_RA_RX1           (RA_RX1 ),
    .MVD_RA_TX1           (RA_TX1 ),
    .MVD_RA_PREM          (DFPGA_RA_PREM),
    .MVD_RA_RX2           (RA_RX2 ),
    .MVD_RA_TX2           (RA_TX2 ),

    //-----------------------------------------------------------
    //-- R-BUS
    //-----------------------------------------------------------
    .MVD_RB_RX1           (RB_RX1 ),
    .MVD_RB_TX1           (RB_TX1 ),
    .MVD_RB_PREM          (DFPGA_RB_PREM),
    .MVD_RB_RX2           (RB_RX2 ),
    .MVD_RB_TX2           (RB_TX2 ),
    //-----------------------------------------------------------
    //-- M-BUS
    //-----------------------------------------------------------
    .TICL_MB_RX1          (MB_RX1 ),
    .TICL_MB_TX1          (MB_TX1 ),
    .TICL_MB_PREM         (DFPGA_MB_PREM),
    .TICL_MB_RX2          (MB_RX2 ),
    .TICL_MB_TX2          (MB_TX2 ),

    //-----------------------------------------------------------
    //-- L-BUS
    //-----------------------------------------------------------
    .TICL_LB_RX1          (LB_RX1 ),
    .TICL_LB_TX1          (LB_TX1 ),
    .TICL_LB_PREM         (DFPGA_LB_PREM),
    .TICL_LB_RX2          (LB_RX2 ),
    .TICL_LB_TX2          (LB_TX2 ),

    //-----------------------------------------------------------
    //-- S-LINK
    //-----------------------------------------------------------
    .RIF_SA_RX0           (SA_RX0 ),
    .RIF_SA_TX0           (SA_TX0 ),
    .RIF_SA_PREM          (DFPGA_SA_PREM),
    .RIF_SA_RX1           (SA_RX1 ),
    .RIF_SA_TX1           (SA_TX1 ),

    //-----------------------------------------------------------
    //-- sync signal of controls
    //-----------------------------------------------------------
    .FDP_LOCKINA          (),
    .FDP_LOCKOA           (),
    .FDP_LOCKINB          (),
    .FDP_LOCKOB           (),


    //-----------------------------------------------------------
    //-- SRAM, FRAM
    //-----------------------------------------------------------
    .DSRAM_A              (DSRAM_A),
    .DSRAM_D              (DSRAM_D),

    .DSRAM_OE_n           (DSRAM_OE_n ),
    .DSRAM_WE_n           (DSRAM_WE_n ),
    .DSRAM_CE1_n          (DSRAM_CE1_n),
    .DSRAM_CE2            (DSRAM_CE2  ),
    .DSRAM_BHE_n          (DSRAM_BHE_n),
    .DSRAM_BLE_n          (DSRAM_BLE_n),
    .DSRAM_ERR            (DSRAM_ERR  ),

    .DFRAM_UB_n           (DFRAM_UB_n ),
    .DFRAM_LB_n           (DFRAM_LB_n ),
    .DFRAM_OE_n           (DFRAM_OE_n ),
    .DFRAM_WE_n           (DFRAM_WE_n ),
    .DFRAM_CE_n           (DFRAM_CE_n ),

    //-----------------------------------------------------------
    //-- SPI interface, Flash W25K64
    //-----------------------------------------------------------
    .FD_SPIF_RST          (),
    .FD_SPI0_SS           (),
    .FD_SPI0_SCK          (),
    .FD_SPI0_SDO          (),
    .FD_SPI0_SDI          (),

    //-----------------------------------------------------------
    //-- Interface with AFPGA
    //-----------------------------------------------------------
    .ADIO_RSTO            (ADIO_RSTO),
    .ADIO_CLK             (ADIO_CLK ),
    .ADIO_WE              (ADIO_WE  ),
    .ADIO_TICK            (ADIO_TICK),//heartbeat in
    .ADIO_CS1             (ADIO_CS1 ),//
    .ADIO_CS2             (ADIO_CS2 ),//
    .ADIO_CS3             (ADIO_CS3 ),//addr [22:20]
    .ADIO_ALE             (ADIO_ALE ),//addr[16]
    .ADIO_DAT             (ADIO_DAT ),//addr[15:0] dataout[7:0]
    .FAD_IO               (FAD_IO   ),//datainput

    //-----------------------------------------------------------
    //-- Interface with PFPGA
    //-----------------------------------------------------------
    .FIO_RSTO             (FIO_RSTO ),//reset dfpga
    .FIO_CLK              (FIO_CLK  ),//clk
    .FIO_TICK             (FIO_TICK ),//heartbeat out
    .FIO_RSTIN            (FIO_RSTIN),//heartbeat in
    .FIO_WE               (FIO_WE   ),//Wren
    .FDP_IO               (FDP_IO   ),//[20:13]addr;
    .FIO_DAT              (FIO_DAT  ),//[12:0] addr; [20:13] output wire data
    .FIO_DAT21            (FIO_DAT21),//==[7:0] input data
    .FIO_DAT22            (FIO_DAT22),//==[7:0] input data
    .FIO_DAT23            (FIO_DAT23),//==[7:0] input data
    .FIO_CS               (FIO_CS   ),//==[7:0] input data
    .FIO_RE               (FIO_RE   ),//==[7:0] input data
    .FIO_ALE              (FIO_ALE  ),//==[7:0] input data

    //-----------------------------------------------------------
    //-- Ethernet: RMII interface-2
    //-----------------------------------------------------------

    .ETH2_RXD            (),
    .ETH2_CRS            (),//rx valid
    .ETH2_TXEN           (),
    .ETH2_TXD            (),
    .ETH2_RST_n          (),
    .ETH2_REFCLK         (),

    //------------------------------------------------------------
    //-- Test pins
    //------------------------------------------------------------
    .FD_TP               ()
    );


//------------------------------------------------------------------------------
//板卡上FPGA例化 结束
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
//仿真模块例化 开始
//------------------------------------------------------------------------------


  //************************************************************
  //--  Clock and Reset on board
  //************************************************************

  //-- 50MHz clock
  sysclkgen
   #(
    .CLK_PERIOD   (20 ),
    .HIGH_PERIOD  (10 )
   )
   u1_sysclkgen
   (
    .clk      (CLK_50MFP   )
   );

  //-- 25MHz clock
  sysclkgen
   #(
    .CLK_PERIOD   (40 ),
    .HIGH_PERIOD  (20 )
   )
   u2_sysclkgen
   (
    .clk      (CLK_25MFP  )
   );

  rstgen
  #(
   .LEVEL    ("LOW"  ),//HIGH,LOW
   .KEEP     (307    )
   )
   u1_rstgen
   (
    .rst       (FP_RST   )
);



  //************************************************************
  //--  F-RAM
  //************************************************************

   //-----------------------------------------------------------
   //-- PFPGA F-RAM,
   //-----------------------------------------------------------
  FM28V102A u1_FM28V102A(
    .dq          (PSRAM_D[15:0]),
    .addr        (PSRAM_A),
    .ce_         (PFRAM_CE_n),
    .we_         (PFRAM_WE_n),
    .oe_         (PFRAM_OE_n),
    .ub_         (PFRAM_UB_n),
    .lb_         (PFRAM_LB_n)
    );


   //-----------------------------------------------------------
   //-- DFPGA F-RAM,
   //-----------------------------------------------------------
  FM28V102A u2_FM28V102A(
    .dq          (DSRAM_D[15:0]),
    .addr        (DSRAM_A),
    .ce_         (DFRAM_CE_n),
    .we_         (DFRAM_WE_n),
    .oe_         (DFRAM_OE_n),
    .ub_         (DFRAM_UB_n),
    .lb_         (DFRAM_LB_n)
    );


  //************************************************************
  //--  Async SRAM
  //************************************************************
   parameter SRAM_ADDR_BITS     =  20;
   parameter SRAM_DATA_BITS     =  16;
   parameter SRAM_Mode          =  2;           //--  tRC := 10 ns;
   parameter SRAM_depth         =  1048576;     //--  1M: 1048576;
   parameter SRAM_TimingInfo    =  1'b1;
   parameter SRAM_TimingChecks  =  1'b1;

   //-----------------------------------------------------------
   //-- PFPGA SRAM
   //-----------------------------------------------------------
   CY7C1061GE30_10
     #(
     .ADDR_BITS      (SRAM_ADDR_BITS   ),
     .DATA_BITS      (SRAM_DATA_BITS   ),
     .depth          (SRAM_depth       ),
     .TimingInfo     (SRAM_TimingInfo  ),
     .TimingChecks   (SRAM_TimingChecks)
     )
     u1_CY7C1061GE30_10(
    .Model      (SRAM_Mode     ), //: IN integer;
    .CE_b       (PSRAM_CE1_n  ), //: IN Std_Logic;                                                  -- Chip Enable CE#
    .WE_b       (PSRAM_WE_n   ), //: IN Std_Logic;                                                  -- Write Enable WE#
    .OE_b       (PSRAM_OE_n   ), //: IN Std_Logic;                                                 -- Output Enable OE#
    .BHE_b      (PSRAM_BHE_n  ), //: IN std_logic;                                                 -- Byte Enable High BHE#
    .BLE_b      (PSRAM_BLE_n  ), //: IN std_logic;                                                 -- Byte Enable Low BLE#
    .DS_b       (PSRAM_CE2    ), //: IN std_logic;                                                 --Deep sleep Enable DS#
    .A          (PSRAM_A      ), //: IN Std_Logic_Vector(ADDR_BITS-1 downto 0);                    -- Address Inputs A
    .DQ         (PSRAM_D      ), //: INOUT Std_Logic_Vector(DATA_BITS-1 downto 0):=(others=>'Z');   -- Read/Write Data IO
    .ERR        (PSRAM_ERR_n  )  //: OUT std_logic --ERR output pin
    );

   //-----------------------------------------------------------
   //-- DFPGA SRAM
   //-----------------------------------------------------------

   CY7C1061GE30_10
    #(
     .ADDR_BITS      (SRAM_ADDR_BITS   ),
     .DATA_BITS      (SRAM_DATA_BITS   ),
     .depth          (SRAM_depth       ),
     .TimingInfo     (SRAM_TimingInfo  ),
     .TimingChecks   (SRAM_TimingChecks)
     )
     u2_CY7C1061GE30_10(
    .Model      (SRAM_Mode    ), //: IN integer;
    .CE_b       (DSRAM_CE1_n  ), //: IN Std_Logic;                                                  -- Chip Enable CE#
    .WE_b       (DSRAM_WE_n   ), //: IN Std_Logic;                                                  -- Write Enable WE#
    .OE_b       (DSRAM_OE_n   ), //: IN Std_Logic;                                                 -- Output Enable OE#
    .BHE_b      (DSRAM_BHE_n  ), //: IN std_logic;                                                 -- Byte Enable High BHE#
    .BLE_b      (DSRAM_BLE_n  ), //: IN std_logic;                                                 -- Byte Enable Low BLE#
    .DS_b       (DSRAM_CE2    ), //: IN std_logic;                                                 --Deep sleep Enable DS#
    .A          (DSRAM_A      ), //: IN Std_Logic_Vector(ADDR_BITS-1 downto 0);                    -- Address Inputs A
    .DQ         (DSRAM_D      ), //: INOUT Std_Logic_Vector(DATA_BITS-1 downto 0):=(others=>'Z');   -- Read/Write Data IO
    .ERR        (DSRAM_ERR_n  )  //: OUT std_logic --ERR output pin
    );

  //************************************************************
  //--  LVD206D, M-Bus converter
  //************************************************************
   SN74AUP1G u1_SN74AUP1G(
    .A            (PFPGA_MB_TXEN1),
    .OE_n         (DFPGA_MB_PREM ),
    .Y            (MB_DE1  )
    );
   
   SN74AUP1G u2_SN74AUP1G(
    .A            (PFPGA_MB_TXEN2),
    .OE_n         (DFPGA_MB_PREM ),
    .Y            (MB_DE2  )
    );
  
  
  
   LVD206D u1_M_BUS_LVD206D(
    .D            (MB_TX1  ),
    .DE           (MB_DE1  ),
    .R            (MB_RX1  ),
    .RE_n         (GND     ),
    .A            (MBUS_1_P),
    .B            (MBUS_1_N)    
    );
    
   LVD206D u2_M_BUS_LVD206D(
    .D            (MB_TX2  ),
    .DE           (MB_DE2  ),
    .R            (MB_RX2  ),
    .RE_n         (GND     ),
    .A            (MBUS_2_P),
    .B            (MBUS_2_N)
    );


  //************************************************************
  //--  LVD206D, C-Bus converter
  //************************************************************
     SN74AUP1G u3_SN74AUP1G(
    .A            (PFPGA_RA_TXEN1),
    .OE_n         (DFPGA_RA_PREM ),
    .Y            (RA_DE1  )
    );
   
   SN74AUP1G u4_SN74AUP1G(
    .A            (PFPGA_RA_TXEN2),
    .OE_n         (DFPGA_RA_PREM ),
    .Y            (RA_DE2  )
    );
   
   LVD206D u1_C_BUS_LVD206D(
    .D            (RA_TX1  ),
    .DE           (RA_DE1),
    .R            (RA_RX1  ),
    .RE_n         (GND           ),
    .A            (RBUS_A1_P),
    .B            (RBUS_A1_N)
    );

   LVD206D u2_C_BUS_LVD206D(
    .D            (RA_TX2  ),
    .DE           (RA_DE2),
    .R            (RA_RX2  ),
    .RE_n         (GND           ),
    .A            (RBUS_A2_P),
    .B            (RBUS_A2_N)
    );

    //************************************************************
  //--  LVD206D, R-Bus converter
  //************************************************************
     SN74AUP1G u5_SN74AUP1G(
    .A            (PFPGA_RB_TXEN1),
    .OE_n         (DFPGA_RB_PREM ),
    .Y            (RB_DE1  )
    );
   
    SN74AUP1G u6_SN74AUP1G(
    .A            (PFPGA_RB_TXEN2),
    .OE_n         (DFPGA_RB_PREM ),
    .Y            (RB_DE2  )
    );
  
   LVD206D u1_R_BUS_LVD206D(
    .D            (RB_TX1  ),
    .DE           (RB_DE1),
    .R            (RB_RX1  ),
    .RE_n         (GND           ),
    .A            (RBUS_B1_P),
    .B            (RBUS_B1_N)
    );

   LVD206D u2_R_BUS_LVD206D(
    .D            (RB_TX2  ),
    .DE           (RB_DE2),
    .R            (RB_RX2  ),
    .RE_n         (GND           ),
    .A            (RBUS_B2_P),
    .B            (RBUS_B2_N)
    );
  
  //************************************************************
  //--  LVD206D, L-Bus converter
  //************************************************************
    SN74AUP1G u7_SN74AUP1G(
    .A            (PFPGA_LB_TXEN1),
    .OE_n         (DFPGA_LB_PREM ),/////////////////////
    .Y            (LB_DE1  )
    );
   
    SN74AUP1G u8_SN74AUP1G(
    .A            (PFPGA_LB_TXEN2),
    .OE_n         (DFPGA_LB_PREM ),//////////////////////////////////
    .Y            (LB_DE2  )
    );
  
  
   LVD206D u1_L_BUS_LVD206D(
    .D            (LB_TX1  ),
    .DE           (LB_DE1),
    .R            (LB_RX1  ),
    .RE_n         (GND     ),
    .A            (LBUS_B1_P),
    .B            (LBUS_B1_N)
    );

   LVD206D u2_L_BUS_LVD206D(
    .D            (LB_TX2  ),
    .DE           (LB_DE2),
    .R            (LB_RX2  ),
    .RE_n         (GND      ),
    .A            (LBUS_B2_P),
    .B            (LBUS_B2_N)
    );

   //************************************************************   
   //--  LVD207D,  S-LINK converter                                   
   //************************************************************   

    SN74AUP1G u9_SN74AUP1G(               
    .A            (PFPGA_SA_TXEN0),       
    .OE_n         (DFPGA_SA_PREM ),       
    .Y            (SA_DE0  )                                               
    );                                                                     
                                                                           
    SN74AUP1G u10_SN74AUP1G(                                               
    .A            (PFPGA_SA_TXEN1),                                        
    .OE_n         (DFPGA_SA_PREM ),                                        
    .Y            (SA_DE1  )                                               
    );                                                                     
                                          
    LVD207D u1_S_LINK_LVD207D(                
     .D            (SA_TX0  ),               
     .DE           (SA_DE0),
     .R            (SA_RX0  ),      
     .RE_n         (GND     ),                                         
     .A            (SLINKA_DI_P ),                                     
     .B            (SLINKA_DI_N) ,                                           
     .Y            (SLINKA_DO_P),                                      
     .Z            (SLINKA_DO_N)  
     
   );                                       
                                      
    LVD207D u2_S_LINK_LVD207D(                                         
     .D            (SA_TX1  ),                                            
     .DE           (SA_DE1),       
     .R            (SA_RX1  ),             
     .RE_n         (GND     ),       
     .A            (SLINKB_DI_P ),     
     .B            (SLINKB_DI_N),    
     .Y            (SLINKB_DO_P),    
     .Z            (SLINKB_DO_N)              
                                          
    );                                    





//------------------------------------------------------------------------------
//仿真模块例化 结束
//------------------------------------------------------------------------------






















endmodule
