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
// Name of module : MN811_UT5_B01
// Project        : NicSys8000
// Func           : MN811 DFPGA Top
// Author         : Zhang Xueyan
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FGG484
// version 1.0    : made in Date: 2015.4.21
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

module MN811_UT5_B01(
    //-----------------------------------------------------------
    //-- Global reset, clocks
    //-----------------------------------------------------------
    input  wire             FD_RSTB       ,
    input  wire             CLK50MP2      ,
    input  wire             CLK_25MD1     ,
                                          
    //-----------------------------------------------------------
    //-- Power Detector                   
    //-----------------------------------------------------------
    input wire              FDWR_OV       ,
    input wire              FDWR_UV       , 
    input wire              FPWR_PG1      ,
    input wire              FPWR_PG2      ,
    input wire              FPWR_PG3      ,
                                          
    //-----------------------------------------------------------
    //-- Watchdog                         
    //-----------------------------------------------------------
    input  wire             FD_WDOB       ,
    output wire             FD_WDIB       ,
    //input  wire           FP_WDOA       ,
                                          
    //-----------------------------------------------------------
    //-- Mode Switch                      
    //-----------------------------------------------------------
    input  wire             FP_MKEY1      ,
    input  wire             FP_MKEY2      ,
    input  wire             FP_MKEY3      ,
                                          
    //-----------------------------------------------------------
    //-- Station ID, Rack ID, Slot ID     
    //-----------------------------------------------------------
    input  wire [ 3: 0]     FDP_RACK      ,
    input  wire [ 4: 0]     FDP_SLOT      ,
    input  wire [ 7: 0]     FDP_STAT      ,
                                          
    //-----------------------------------------------------------
    //-- LED indicator                    
    //-----------------------------------------------------------
    output wire             FD_LED4       ,
                                      
    //-----------------------------------------------------------
    //-- M-BUS                            
    //-----------------------------------------------------------
    output wire             TICL_MB_PREM  ,
    input  wire             TICL_MB_RX1   ,
    input  wire             TICL_MB_TX1   ,
    input  wire             TICL_MB_TXEN1 ,
                                          
    input  wire             TICL_MB_RX2   ,
    input  wire             TICL_MB_TX2   ,
    input  wire             TICL_MB_TXEN2 ,
                                          
    //-----------------------------------------------------------
    //-- SRAM1                            
    //-----------------------------------------------------------
    output wire [19: 0]     DSRAM1_A      ,
    output wire             DSRAM1_OE_n   ,
    output wire             DSRAM1_WE_n   ,
    output wire             DSRAM1_CE1_n  ,
    output wire             DSRAM1_CE2    ,
    inout  tri  [15: 0]     DSRAM1_D      ,
    input  wire             DSRAM1_ERR_n  ,
    output wire             DSRAM1_BHE_n  ,
    output wire             DSRAM1_BLE_n  ,
    //-----------------------------------------------------------
    //-- SRAM2                            
    //-----------------------------------------------------------
    output wire [19: 0]     DSRAM2_A      ,
    output wire             DSRAM2_OE_n   ,
    output wire             DSRAM2_WE_n   ,
    output wire             DSRAM2_CE1_n  ,
    output wire             DSRAM2_CE2    ,
    inout  tri  [15: 0]     DSRAM2_D      ,
    input  wire             DSRAM2_ERR_n  ,
    output wire             DSRAM2_BHE_n  ,
    output wire             DSRAM2_BLE_n  ,
                                          
    //-----------------------------------------------------------
    //-- Interface with PFPGA             
    //-----------------------------------------------------------
                         
    output wire [12: 0]     FIO_DAT12_0_A,      //-- Addr
    output wire [20:13]     FIO_DAT20_13_DI,    //-- input data
    input  wire [23:21]     FIO_DAT23_21_DO2_0, //-- output data[2:0]
    input  wire [ 2: 0]     FIO_CS2_0_DO5_3,    //-- output data[5:3]
    input  wire             FIO_RE_DO6,         //-- output data[6]
    input  wire             FIO_ALE_DO7,        //-- output data[7]    
    output wire             FIO_WE,   
                 
    input  wire             FIO_TICK      ,  //-- PFPGA Heartbeat out   
    output wire             FIO_RSTIN     ,  //-- PFPGA Heartbeat in
    input  wire             FIO_RSTO      ,  //-- DFPGA reset
                                          
    input  wire             FIO_CLK       ,  //-- 50Mhz
                                          
    //-----------------------------------------------------------
    //-- Ethernet: RMII interface-1       
    //-----------------------------------------------------------
    input  wire             ETH1_REFCLK,
    input  wire [ 1: 0]     ETH1_RXD_O    ,
    input  wire             ETH1_RXDV_O   ,
 
    //-----------------------------------------------------------
    //-- Ethernet: RMII interface-2       
    //-----------------------------------------------------------
    input  wire             ETH2_REFCLK,
    input  wire [ 1: 0]     ETH2_RXD_O    ,
    input  wire             ETH2_RXDV_O   ,
    
    //-----------------------------------------------------------
    //-- SPI interface                    
    //-----------------------------------------------------------
    output wire             FD_E2P_SCK    ,   
    output wire             FD_E2P_CS     ,
    output wire             FD_E2P_SI     ,
    input  wire             FD_E2P_SO     ,
                                          
                                          
    //-----------------------------------------------------------
    //-- Test LED                         
    //-----------------------------------------------------------
    output wire             TEST_LED4     ,
    output wire             TEST_LED5     ,
    output wire             TEST_LED6     ,
    output wire             TEST_LED7     ,
                                          
    //------------------------------------------------------------
    //-- Test pins                        
    //-----------------------------------------------------------
    output wire [15:0]      FD_TEST       

);




//------------------------------------------------------------------------------
//仿真临时程序  开始
//------------------------------------------------------------------------------

 
  //assign TICL_MB_TX1   =  1'bz;
  //assign TICL_MB_TXEN1 =  1'bz;;

  //assign TICL_MB_TX2   =  1'bz;;
  //assign TICL_MB_TXEN2 =  1'bz;;

  assign TICL_MB_PREM  =  1'b0; 




//------------------------------------------------------------------------------
//仿真临时程序  结束
//------------------------------------------------------------------------------









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
//内部变量声明  结束
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



//------------------------------------------------------------------------------
//状态机格式参考  开始
//------------------------------------------------------------------------------
always @ (posedge sys_clk)
begin
    if(sys_rst)
        fsm_curr <= FSM_IDLE;
    else
        fsm_curr <= fsm_next;
end

always @ ( * )
begin
    case(fsm_curr)
        FSM_IDLE:
            fsm_next = FSM_CMD;
        FSM_CMD:
            begin
                if((rx_cmd == 8'h10) && (rx_cnt > 16'd8))
                    fsm_next = FSM_DATA;
                else if(rx_cnt > 16'd8)
                    fsm_next = FSM_IDLE;
                else
                    fsm_next = FSM_CMD;
            end
        FSM_DATA:
            begin
                if(r_a_addr == 8'd137)
                    fsm_next = FSM_IDLE;
                else
                    fsm_next = FSM_DATA;
            end
        default:
            fsm_next = FSM_IDLE;
    endcase
end

always @ (posedge sys_clk)
begin
    if(sys_rst)
        r_a_addr <= 8'd0;
    else
        begin
            case(fsm_curr)
                FSM_IDLE:
                    r_a_addr <= 8'd0;
                FSM_CMD:
                    r_a_addr <= rx_cnt[7:0];
                FSM_DATA:
                    begin
                        if(rxfifo_en)
                            r_a_addr <= r_a_addr + 1'b1;
                        else
                            r_a_addr <= r_a_addr;
                    end
                default:
                    r_a_addr <= 8'd0;
            endcase
        end
end
//------------------------------------------------------------------------------
//状态机格式参考  结束
//------------------------------------------------------------------------------


*/


endmodule
