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
//     1.0   2016/04/25   Initial version(xu peidong)
//
//
//
////////////////////////////////////////////////////////////////////////////////

module M_bus_top(
    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input reset                           ,  
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input sysclk                             ,
    input synclk                             ,
    input clk_phy_p0                         ,
    input clk_phy_p90                        ,
    input clk_phy_p180                       ,
    input clk_phy_p270                       ,
    //------------------------------------------
    //--  input
    //-------------------------------------------
    input [7:0]lcudb_rdata                ,
    input [7:0]lcucb_rdata                ,
    input [7:0]ldub_rdata                 ,
    input [3:0]slot_id                    ,
    input [2:0]rack_id                    ,                     
    input read_id_done                        ,
    input lb_rxd                          ,
    //------------------------------------------
    //--  output
    //-------------------------------------------
    output  lcudb_rden                 ,
    output  [23:0]lcudb_raddr          ,
    output  lcucb_rden                 ,
    output  [23:0]lcucb_raddr          ,
    output  ldub_rden                  ,
    output  [23:0]ldub_raddr           ,  
    //------------------------------------------
    //--  local download RAM
    //------------------------------------------
    output  lddb_wren                               ,
    output  [23:0]lddb_waddr                        ,
    output  [7:0]lddb_wdata                         ,
    //------------------------------------------
    //--  local console order RAM
    //------------------------------------------
    output  lcdcb_wren                              ,
    output  [23:0]lcdcb_waddr                       ,
    output  [7:0]lcdcb_wdata                        ,
    //------------------------------------------
    //--  local console data  RAM
    //------------------------------------------
    output  lcddb_wren                              ,
    output  [23:0]lcddb_waddr                       ,
    output  [7:0]lcddb_wdata                       ,
    //------------------------------------------
    //--  output
    //------------------------------------------
    output card_reset_reg                           ,
    output wr_lddb_flag                             ,
    output lb_txd                                   ,
    output lb_txen                                  ,
    output CRC_err                                  ,
    output [7:0]mode_reg                      
);
wire [10:0]tx_buf_waddr;
wire [7:0]tx_buf_wdata;
wire [10:0]tx_data_len;
wire tx_buf_wren;
wire tx_start;
wire rx_buf_rden;
wire [7:0]rx_buf_rdata;
wire [10:0]rx_buf_raddr;
wire [1:0]rx_crc_rslt;
wire rx_done;
wire rx_start;

M_bus m_bus(.clk(sysclk),
            .reset(reset),
            .lcudb_rdata(lcudb_rdata),
            .lcucb_rdata(lcucb_rdata),
            .ldub_rdata(ldub_rdata),
            .slot_id(slot_id),
            .rack_id(rack_id),
            .ini_done(read_id_done),
            .lcudb_rden(lcudb_rden),
            .lcudb_raddr(lcudb_raddr),
            .lcucb_rden(lcucb_rden),
            .lcucb_raddr(lcucb_raddr),
            .ldub_rden(ldub_rden),
            .ldub_raddr(ldub_raddr),
            .tx_buf_wren(tx_buf_wren),
            .tx_buf_waddr(tx_buf_waddr),
            .tx_buf_wdata(tx_buf_wdata),
            .tx_data_len(tx_data_len),
            .tx_start(tx_start),
            .lddb_wren(lddb_wren),
            .lddb_waddr(lddb_waddr),
            .lddb_wdata(lddb_wdata),
            .lcdcb_wren(lcdcb_wren),
            .lcdcb_waddr(lcdcb_waddr),
            .lcdcb_wdata(lcdcb_wdata),
            .lcddb_wren(lcddb_wren),
            .lcddb_waddr(lcddb_waddr),
            .lcddb_wdata(lcddb_wdata),
            .rx_buf_rdata(rx_buf_rdata),
            .rx_crc_rslt(rx_crc_rslt),
            .rx_start(rx_start),
            .rx_done(rx_done),
            .rx_buf_rden(rx_buf_rden),
            .rx_buf_raddr(rx_buf_raddr),
            .card_reset_reg(card_reset_reg),
            .wr_lddb_flag(wr_lddb_flag),
            .CRC_err(CRC_err),
            .mode_reg(mode_reg));
            
link Link(.Rclk(synclk),
          .rst(reset),
          .tx_buf_wren(tx_buf_wren),
          .tx_buf_waddr(tx_buf_waddr),
          .tx_buf_wdata(tx_buf_wdata),
          .tx_data_len(tx_data_len),
          .tx_start(tx_start),
          .sys_clk(sysclk),
          .clk_phy_p0(clk_phy_p0),
          .clk_phy_p90(clk_phy_p90),
          .clk_phy_p180(clk_phy_p180),
          .clk_phy_p270(clk_phy_p270),
          .rx_buf_rden(rx_buf_rden),
          .rx_buf_raddr(rx_buf_raddr),
          .lb_rxd(lb_rxd),
          .lb_txd(lb_txd),
          .lb_txen(lb_txen),
          .o_rx_done(rx_done),
          .rx_buf_rdata(rx_buf_rdata),
          .o_rx_crc_rslt(rx_crc_rslt),
          .o_rx_start(rx_start));

endmodule