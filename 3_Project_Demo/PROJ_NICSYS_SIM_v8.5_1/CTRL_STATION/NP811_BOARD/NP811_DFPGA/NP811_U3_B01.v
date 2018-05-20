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
// Name of module : NP811_U3_B01
// Project        : NicSys8000
// Func           : NP811 DFPGA Top
// Author         : Zhang Xueyan
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL090-FGG484I
// version 1.0    : made in Date: 2015.12.01
// Modification Logs:
// _____________________________________________________________________________
//   Version   Date         Description(Recorder)
// _____________________________________________________________________________
//     1.0   2016/04/12    Initial version(Zhang Xueyan)
//
//
//
////////////////////////////////////////////////////////////////////////////////

module NP811_U3_B01
    (
    
    //-----------------------------------------------------------
    //-- Global reset, clocks
    //-----------------------------------------------------------
    input  wire           FD_RST               ,//negedge rst
    
    input  wire           CLK_25MFD            ,
    input  wire           CLK_50MFD            ,
    
    //-----------------------------------------------------------
    //-- Power Detector
    //-----------------------------------------------------------
    input  wire           FPWR_PG1             ,//0 is valid
    input  wire           FPWR_PG2             ,//0 is valid
    input  wire           FPWR_PG3             ,//0 is valid
    input  wire           FPWR_OV              ,//0 is valid
    input  wire           FPWR_UV              ,//0 is valid
    
    
    //-----------------------------------------------------------
    //-- Watchdog
    //-----------------------------------------------------------
    
    input  wire           FD_WDO               ,
    output wire           FD_WDI               ,
    //input               FD_WDO               ,
    
    //-----------------------------------------------------------
    //-- Mode Switch
    //-----------------------------------------------------------
    
    input  wire           FDP_MKEY1            ,//[1]: 1 MTC; [2]: 1 NML [3]: 1 DLD
    input  wire           FDP_MKEY2            ,
    input  wire           FDP_MKEY3            ,
    
    //-----------------------------------------------------------
    //-- Station ID, Rack ID, Slot ID
    //-----------------------------------------------------------
    input  wire [3:0]     FDP_RACK             ,
    input  wire [4:0]     FDP_SLOT             ,
    input  wire [7:0]     FDP_STAT             ,
    
    
     //-----------------------------------------------------------
     //-- LED indicator
     //-----------------------------------------------------------
    output wire           FD_LED3Y             ,//Warning
    output wire           FD_LED14             ,//debug
    output wire           FD_LED15             ,//debug
    
    //-----------------------------------------------------------
    //-- Plug monitor, active low
    //-----------------------------------------------------------
    
    input  wire           PLUG_MON             , //1 is not plug; 0 is plug ok
    
    //-----------------------------------------------------------
    //-- C-BUS
    //-----------------------------------------------------------
    input  wire           MVD_RA_RX1           ,
    input  wire           MVD_RA_TX1           ,
    output wire           MVD_RA_PREM          ,
    input  wire           MVD_RA_RX2           ,
    input  wire           MVD_RA_TX2           ,
    
    //-----------------------------------------------------------
    //-- R-BUS
    //-----------------------------------------------------------
    input  wire           MVD_RB_RX1           ,
    input  wire           MVD_RB_TX1           ,
    output wire           MVD_RB_PREM          ,
    input  wire           MVD_RB_RX2           ,
    input  wire           MVD_RB_TX2           ,
    //-----------------------------------------------------------
    //-- M-BUS
    //-----------------------------------------------------------
    
    input  wire           TICL_MB_RX1          ,
    input  wire           TICL_MB_TX1          ,
    output wire           TICL_MB_PREM         ,
    input  wire           TICL_MB_RX2          ,
    input  wire           TICL_MB_TX2          ,
    
    //-----------------------------------------------------------
    //-- L-BUS
    //-----------------------------------------------------------
    input  wire           TICL_LB_RX1          ,
    input  wire           TICL_LB_TX1          ,
    output wire           TICL_LB_PREM         ,
    input  wire           TICL_LB_RX2          ,
    input  wire           TICL_LB_TX2          ,
    
    //-----------------------------------------------------------
    //-- S-LINK
    //-----------------------------------------------------------
    input  wire           RIF_SA_RX0           ,
    input  wire           RIF_SA_TX0           ,
    output wire           RIF_SA_PREM          ,
    input  wire           RIF_SA_RX1           ,
    input  wire           RIF_SA_TX1           ,
    
    //-----------------------------------------------------------
    //-- sync signal of controls
    //-----------------------------------------------------------
    input  wire           FDP_LOCKINA          ,
    input  wire           FDP_LOCKOA           ,
    input  wire           FDP_LOCKINB          ,
    input  wire           FDP_LOCKOB           ,
    
    
    //-----------------------------------------------------------
    //-- SRAM, FRAM
    //-----------------------------------------------------------
    output wire  [19:0]   DSRAM_A              ,
    inout  wire  [15:0]   DSRAM_D              ,
    
    output wire           DSRAM_OE_n           ,
    output wire           DSRAM_WE_n           ,
    output wire           DSRAM_CE1_n          ,
    output wire           DSRAM_CE2            ,
    output wire           DSRAM_BHE_n          ,
    output wire           DSRAM_BLE_n          ,
    input  wire           DSRAM_ERR            ,
    
    output wire           DFRAM_UB_n           ,
    output wire           DFRAM_LB_n           ,
    output wire           DFRAM_OE_n           ,
    output wire           DFRAM_WE_n           ,
    output wire           DFRAM_CE_n           ,    
    
    //-----------------------------------------------------------
    //-- SPI interface
    //-----------------------------------------------------------
    
    output wire           FD_SPIF_RST          ,
    output wire           FD_SPI0_SS           ,
    output wire           FD_SPI0_SCK          ,
    input  wire           FD_SPI0_SDO          ,
    output wire           FD_SPI0_SDI          ,
    
    //-----------------------------------------------------------
    //-- Interface with AFPGA
    //-----------------------------------------------------------
    
    output wire           ADIO_RSTO            ,
    output wire           ADIO_CLK             ,
    output wire           ADIO_WE              ,
    
    input  wire           ADIO_TICK            ,//heartbeat in
    
    output wire           ADIO_CS1             ,//
    output wire           ADIO_CS2             ,//
    output wire           ADIO_CS3             ,//addr [22:20]
    output wire           ADIO_ALE             ,//addr[16]
    output wire  [23:0]   ADIO_DAT             ,//addr[15:0] dataout[7:0]
    input  wire   [7:0]   FAD_IO               ,//datainput
    
    //-----------------------------------------------------------
    //-- Interface with PFPGA
    //-----------------------------------------------------------
    
    input  wire           FIO_RSTO             ,//reset dfpga
    input  wire           FIO_CLK              ,//clk
    input  wire           FIO_TICK             ,//heartbeat out
    output wire           FIO_RSTIN            ,//heartbeat in
    input  wire           FIO_WE               ,//Wren
    
    
    input  wire  [7:0]    FDP_IO               ,//[20:13]addr;
    input  wire  [20:0]   FIO_DAT              ,//[12:0] addr; [20:13] output wire data
    
    output wire           FIO_DAT21            ,//==[7:0] input data
    output wire           FIO_DAT22            ,//==[7:0] input data
    output wire           FIO_DAT23            ,//==[7:0] input data
    output wire  [2:0]    FIO_CS               ,//==[7:0] input data
    output wire           FIO_RE               ,//==[7:0] input data
    output wire           FIO_ALE              ,//==[7:0] input data
    
    //-----------------------------------------------------------
    //-- Ethernet: RMII interface-2
    //-----------------------------------------------------------
    
    input  wire  [1:0]    ETH2_RXD             ,
    input  wire           ETH2_CRS             ,//rx valid
    
    output wire           ETH2_TXEN            ,
    output wire  [1:0]    ETH2_TXD             ,
    output wire           ETH2_RST_n           ,
    output wire           ETH2_REFCLK          ,
    
    //------------------------------------------------------------
    //-- Test pins
    //------------------------------------------------------------
    output wire  [15:0]   FD_TP
    );
    





    

   assign   TICL_MB_PREM = 1'b0;
   assign   TICL_LB_PREM = 1'b0;
   assign   MVD_RA_PREM = 1'b0;
   assign   MVD_RB_PREM = 1'b0;
   assign   RIF_SA_PREM = 1'b0;
   
 



/*

//------------------------------------------------------------------------------
//参数声明  开始
//------------------------------------------------------------------------------
parameter FSM_IDLE = 2'd0;
parameter FSM_CMD  = 2'd1;
parameter FSM_DATA = 2'd2;
//------------------------------------------------------------------------------
//参数声明  结束
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
//内部变量声明  开始
//------------------------------------------------------------------------------
wire         w_sys_clk ;
wire         w_sys_rst ;
wire [15:00] w_ad_data ;
reg  [07:00] r_a_addr  ;

reg  [01:00] fsm_curr  ;
reg  [01:00] fsm_next  ;
//------------------------------------------------------------------------------
//内部变量声明  开始
//------------------------------------------------------------------------------




//------------------------------------------------------------------------------
//模块调用参考  开始
//------------------------------------------------------------------------------
clock u_clock(
    .sys_clk_50m   (sys_clk_50m   ),
    .sys_clk       (w_sys_clk     ),
    .sys_rst       (w_sys_rst     )
    );

adc_din u_adc_din(
    .sys_clk       (w_sys_clk     ),
    .sys_rst       (w_sys_rst     ),
    .im_adc_data   (im_adc_data   ),
    .om_ad_data    (w_ad_data     )
    );

emif_ctrl u_emif_ctrl(
    .sys_clk       (w_sys_clk     ),
    .sys_rst       (w_sys_rst     ),
    .o_arm_inte    (o_arm_inte    ),
    .o_gain_chl_en (o_gain_chl_en ),
    .om_gain_chl   (om_gain_chl   ),
    .om_band_high  (om_band_high  ),
    .om_band_low   (om_band_low   ),
    .im_ad_data    (w_ad_data     ),
    .io_emif_data  (io_emif_data  ),
    .im_emif_addr  (im_emif_addr  ),
    .i_emif_cen    (i_emif_cen    ),
    .i_emif_oen    (i_emif_oen    ),
    .i_emif_wen    (i_emif_wen    )
    );

led u_led(
    .sys_clk       (w_sys_clk     ),
    .sys_rst       (w_sys_rst     ),
    .o_led_out     (o_led_out     )
    );

led u1_led(
    .sys_clk       (w_sys_clk     ),
    .sys_rst       (w_sys_rst     ),
    .o_led_out     (o_led_out     )
    );

led u2_led(
    .sys_clk       (w_sys_clk     ),
    .sys_rst       (w_sys_rst     ),
    .o_led_out     (o_led_out     )
    );
//------------------------------------------------------------------------------
//模块调用参考  结束
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//逻辑参考  开始
//------------------------------------------------------------------------------
//输入数据缓存一级
always @ (posedge sys_clk)
begin
    if(sys_rst)
        begin
            r_tcfifo_we <= 'b0;
            r_tcfifo_wdata <= 'd0;
        end
    else
        begin
            r_tcfifo_we <= tcfifo_we;
            r_tcfifo_wdata <= tcfifo_wdata;
        end
end

assign io_emif_data = (r_dpram_a_ren == 1'b1) ? im_dpram_a_rdata : 16'hzzzz;

//------------------------------------------------------------------------------
//逻辑参考  结束
//------------------------------------------------------------------------------





*/


endmodule