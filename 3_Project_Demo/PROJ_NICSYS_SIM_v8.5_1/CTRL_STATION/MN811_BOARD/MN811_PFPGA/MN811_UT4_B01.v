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
// Name of module : MN811_UT4_C01_TOP
// Project        : NicSys8000
// Func           : MN811 DFPGA Top
// Author         : Zhang Xueyan
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

`timescale 1ns/100ps

module MN811_UT4_B01(
    //-----------------------------------------------------------
    //-- Global reset, clocks
    //-----------------------------------------------------------
    input  wire             FP_RSTA,
    input  wire             CLK_25MP1,
    input  wire             CLK50MP1,

    //-----------------------------------------------------------
    //-- Power Detector
    //-----------------------------------------------------------
    output wire             FPWR_DPG,

    //-----------------------------------------------------------
    //-- Watchdog
    //-----------------------------------------------------------
    input  wire             FP_WDOA,
    output wire             FP_WDIA,
    //input  wire             FD_WDOB,

    //-----------------------------------------------------------
    //-- Station ID, Rack ID, Slot ID
    //-----------------------------------------------------------
    input  wire             FP_MKEY1,
    input  wire             FP_MKEY2,
    input  wire             FP_MKEY3,

    //-----------------------------------------------------------
    //-- Station ID, Rack ID, Slot ID
    //-----------------------------------------------------------
    input  wire [ 3: 0]     FDP_RACK,
    input  wire [ 4: 0]     FDP_SLOT,
    input  wire [ 7: 0]     FDP_STAT,

    //-----------------------------------------------------------
    //-- LED indicator
    //-----------------------------------------------------------
    output wire             FP_LED3,
    output wire             FP_LED4,
    output wire             FP_ERR_LED,
    output wire             FP_LED6,

    //-----------------------------------------------------------
    //-- Plug monitor, active low
    //-----------------------------------------------------------
    input  wire             PLUG_MON,

    //-----------------------------------------------------------
    //-- M-BUS
    //-----------------------------------------------------------
    output wire             TICL_MB_PREM,
    input  wire             TICL_MB_RX1,
    output wire             TICL_MB_TX1,
    output wire             TICL_MB_TXEN1,

    input  wire             TICL_MB_RX2,
    output wire             TICL_MB_TX2,
    output wire             TICL_MB_TXEN2,

    //-----------------------------------------------------------
    //-- SRAM1
    //-----------------------------------------------------------
    output wire [19: 0]     PSRAM1_A,
    output wire             PSRAM1_OE_n,
    output wire             PSRAM1_WE_n,
    output wire             PSRAM1_CE1_n,
    output wire             PSRAM1_CE2,
    inout  tri  [15: 0]     PSRAM1_D,
    input  wire             PSRAM1_ERR_n,
    output wire             PSRAM1_BHE_n,
    output wire             PSRAM1_BLE_n,
    //-----------------------------------------------------------
    //-- SRAM2
    //-----------------------------------------------------------
    output wire [19: 0]     PSRAM2_A,
    output wire             PSRAM2_OE_n,
    output wire             PSRAM2_WE_n,
    output wire             PSRAM2_CE1_n,
    output wire             PSRAM2_CE2,
    inout  tri  [15: 0]     PSRAM2_D,
    input  wire             PSRAM2_ERR_n,
    output wire             PSRAM2_BHE_n,
    output wire             PSRAM2_BLE_n,

    //-----------------------------------------------------------
    //-- Interface with DFPGA
    //-----------------------------------------------------------
    output wire [12: 0]     FIO_DAT12_0_A,      //-- Addr
    output wire [20:13]     FIO_DAT20_13_DO,    //-- output data
    input  wire [23:21]     FIO_DAT23_21_DI2_0, //-- input data[2:0]
    input  wire [ 2: 0]     FIO_CS2_0_DI5_3,    //-- input data[5:3]
    input  wire             FIO_RE_DI6,         //-- input data[6]
    input  wire             FIO_ALE_DI7,        //-- input data[7]
    output wire             FIO_WE,

    output wire             FIO_TICK,   //-- Heartbeat out
    input  wire             FIO_RSTIN,  //-- Heartbeat in
    output wire             FIO_RSTO,   //-- DFPGA reset

    output wire             FIO_CLK,   //-- 50Mhz

    //-----------------------------------------------------------
    //-- Ethernet: RMII interface-1
    //-----------------------------------------------------------
    output wire             ETH1_RST_n,
    output wire             ETH1_REFCLK,

    input  wire [ 1: 0]     ETH1_RXD_O,
    input  wire             ETH1_RXDV_O,
    input  wire             ETH1_RXER,
    output wire             ETH1_TXEN,
    output wire [ 1: 0]     ETH1_TXD,

    output wire             ETH1_COM_LED, // work normal ind

    //inout  tri              ETH1_MDIO,
    //output wire             ETH1_MDC,
    //input  wire             ETH1_LEDG,
    //input  wire             ETH1_LEDY,
    //input  wire             ETH1_INTRP,
    //-----------------------------------------------------------
    //-- Ethernet: RMII interface-2
    //-----------------------------------------------------------
    output wire             ETH2_RST_n,
    output wire             ETH2_REFCLK,

    input  wire [ 1: 0]     ETH2_RXD_O,
    input  wire             ETH2_RXDV_O,
    input  wire             ETH2_RXER,
    output wire             ETH2_TXEN,
    output wire [ 1: 0]     ETH2_TXD,

    output wire             ETH2_COM_LED,

    //inout  tri              ETH2_MDIO,
    //output wire             ETH2_MDC,
    //input  wire             ETH2_LEDG,
    //input  wire             ETH2_LEDY,
    //input  wire             ETH2_INTRP,

    //-----------------------------------------------------------
    //-- SPI interface
    //-----------------------------------------------------------
    output wire             FP_E2P_SCK,
    output wire             FP_E2P_CS,
    input  wire             FP_E2P_SI,
    output wire             FP_E2P_SO,

    //-----------------------------------------------------------
    //-- I2C interface
    //-----------------------------------------------------------
    //output wire             I2C_SCL_TEMSR,
    //output wire             I2C_SDA_TEMSR,

    //-----------------------------------------------------------
    //-- Test LED
    //-----------------------------------------------------------
    output wire             TEST_LED0,
    output wire             TEST_LED1,
    output wire             TEST_LED2,
    output wire             TEST_LED3,

    //------------------------- ----------------------------------
    //-- Test pins
    //-----------------------------------------------------------
    output wire [15:0]      TEST_T

);



//------------------------------------------------------------------------------
//参数声明  开始
//------------------------------------------------------------------------------
parameter HI_IMP = 1'bz;   //-- High Impedance
parameter VDD    = 1'd1;
parameter GND    = 1'd0;
//------------------------------------------------------------------------------
//参数声明  结束
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
//内部变量声明  开始
//------------------------------------------------------------------------------
   wire clk_12p5m;
   wire clk_12p5m_90;
   wire clk_12p5m_180;
   wire clk_12p5m_270;

   wire clk_100m;
   wire clk_100m_90;
   wire clk_100m_180;
   wire clk_100m_270;


   wire sys_clk_50m;
   wire glb_rst_n;
   wire glb_rst;


   wire lb_rxd;
   wire lb_txd;
   wire lb_txen;


//------------------------------------------------------------------------------
//内部变量声明  结束
//------------------------------------------------------------------------------
  assign glb_rst       = ~glb_rst_n;
  assign TICL_MB_PREM  = HI_IMP;

  assign lb_rxd        =  TICL_MB_RX1 | TICL_MB_RX2;
  assign TICL_MB_TX1   =  lb_txd;
  assign TICL_MB_TXEN1 =  lb_txen;

  assign TICL_MB_TX2   =  lb_txd;
  assign TICL_MB_TXEN2 =  lb_txen;

  assign TICL_MB_PREM  =  1'bz; 
  


//------------------------------------------------------------------------------
//模块调用参考  开始
//------------------------------------------------------------------------------

   //------------------------------------------------------------------------------
   //PLL调用
   //------------------------------------------------------------------------------

   clock_ctrl plls(
    .sys_clk_in      (CLK50MP1),
    .clk_50m         (sys_clk_50m),
    .clk_10m         (),
    .clk_12p5m       (clk_12p5m),
    .clk_12p5m_90    (clk_12p5m_90),
    .clk_12p5m_180   (clk_12p5m_180),
    .clk_12p5m_270   (clk_12p5m_270),
    .clk_100m        (clk_100m),
    .clk_100m_90     (clk_100m_90),
    .clk_100m_180    (clk_100m_180),
    .clk_100m_270    (clk_100m_270),
    .glb_rst_n       (glb_rst_n)
   );



/*


  M_NET u1_M_NET(

    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    .rst_n            (FP_RSTA),

    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    .clk_50m          (CLK50MP1),

    //------------------------------------------
    //-- Ethernet, RMII interface
    //------------------------------------------
    .ETH_RXD         (ETH2_RXD_O ),
    .ETH_RXDV        (ETH2_RXDV_O),
    .ETH_RXER        (ETH2_RXER  ),
    .ETH_INTRP       (ETH2_INTRP ),
    .ETH_MDIO        (ETH2_MDIO  ),
    .ETH_TXEN        (ETH2_TXEN  ),
    .ETH_TXD         (ETH2_TXD   ),
    .ETH_RST_n       (ETH2_RST_n ),
    //-- REFCLK, Output for PFPGA, input for
    .ETH_REFCLK      (ETH_REFCLK ),
    .ETH_LEDG        (ETH_LEDG   ),
    .ETH_LEDY        (ETH_LEDY   ),
    .ETH_COM_LED     (ETH_COM_LED),

    //------------------------------------------
    //-- application interface:
    //------------------------------------------
    //-- TX
    .Tx_Ram_Wr    (),
    .Tx_Ram_Addr  (),
    .Tx_Ram_Data  (),
    .Tx_Start     (),
    .Tx_Busy      (),

    //-- Rx
    .Rx_Ram_Rd     (),
    .Rx_Ram_Addr   (),
    .Rx_Ram_Data   (),
    .Rx_Done       ()
    );


*/


//------------------------------------------------------------------------------
//模块调用  结束
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//逻辑参考  开始
//------------------------------------------------------------------------------





//------------------------------------------------------------------------------
//逻辑参考  结束
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
//状态机格式参考  开始
//------------------------------------------------------------------------------






//------------------------------------------------------------------------------
//状态机格式参考  结束
//------------------------------------------------------------------------------







//------------------------------------------------------------------------------
// M_BUS 仿真  开始
//------------------------------------------------------------------------------
   tb_M_BUS_DL u1_tb_M_BUS_DL(
    //-- reset
    .rst             (glb_rst),
    //-- Clocks
    .sys_clk          (sys_clk_50m     ),   //- 50M
    //.clk_phy_p0       (clk_12p5m),    
    //.clk_phy_p90      (clk_12p5m_90), 
    //.clk_phy_p180     (clk_12p5m_180),
    //.clk_phy_p270     (clk_12p5m_270),
    
    .clk_phy_p0       (clk_100m),    
    .clk_phy_p90      (clk_100m_90), 
    .clk_phy_p180     (clk_100m_180),
    .clk_phy_p270     (clk_100m_270),    
    
    
    

    //-- PHY interface
    .lb_rxd           (lb_rxd),
    .lb_txd           (lb_txd),
    .lb_txen          (lb_txen)
    );


//------------------------------------------------------------------------------
// M_BUS 仿真    结束
//------------------------------------------------------------------------------




endmodule
