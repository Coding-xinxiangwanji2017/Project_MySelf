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
module Clink_top(
  
    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input reset,
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------  
    input sys_clk,
    //------------------------------------------
    //--  rx
    //------------------------------------------ 
    output ch1_rxbuf_wren,
    output [10:0]ch1_rxbuf_waddr,
    output [7:0]ch1_rxbuf_wdata,
    output ch1_sn_err,
    output ch1_crc_err,
    output ch1_DA_err,
    //------------------------------------------
    //--  common                                   
    //------------------------------------------
    input ini_done,
    input [3:0]station_id,
    input [3:0]slot_id,
    //------------------------------------------
    //--  tx                                  
    //------------------------------------------
    input [7:0]ch1_txbuf_rdata,
    input da_valid,
    input [23:0]ch1_da,
    output [10:0]ch1_txbuf_raddr,
    output ch1_txbuf_rden,
    //------------------------------------------
    //--  link                                 
    //------------------------------------------
    input clk_phy_p0,
    input clk_phy_p90,
    input clk_phy_p180,
    input clk_phy_p270,
    input syn_clk,
    input lb_rxd,
    output lb_txd,
    output lb_txen   
);

wire tx_buf_wren;
wire [10:0]tx_buf_waddr;
wire [7:0]tx_buf_wdata;
wire [10:0]tx_data_len;
wire tx_start;

wire rx_buf_rden;
wire [10:0]rx_buf_raddr;
wire [7:0]rx_buf_rdata;
wire [1:0]rx_crc_rslt;
wire rx_start;
wire rx_done;

Clink_rx rx(.clk(sys_clk),
            .reset(reset),
            .ch1_rxbuf_wren(ch1_rxbuf_wren),
            .ch1_rxbuf_waddr(ch1_rxbuf_waddr),
            .ch1_rxbuf_wdata(ch1_rxbuf_wdata),
            .ch1_sn_err(ch1_sn_err),
            .ch1_crc_err(ch1_crc_err),
            .ch1_DA_err(ch1_DA_err),
            .rx_buf_rden(rx_buf_rden),
            .rx_buf_raddr(rx_buf_raddr),
            .rx_buf_rdata(rx_buf_rdata),
            .rx_crc_rslt(rx_crc_rslt),
            .rx_start(rx_start),
            .rx_done(rx_done),
            .ini_done(ini_done),
            .station_id(station_id),
            .slot_id(slot_id));
            
Clink_tx tx(.clk(sys_clk),
            .reset(reset),
            .ini_done(ini_done),
            .station_id(station_id),
            .slot_id(slot_id),
            .ch1_txbuf_rden(ch1_txbuf_rden),
            .ch1_txbuf_raddr(ch1_txbuf_raddr),
            .ch1_txbuf_rdata(ch1_txbuf_rdata),
            .da_valid(da_valid),
            .ch1_da(ch1_da),
            .tx_buf_wren(tx_buf_wren),
            .tx_buf_waddr(tx_buf_waddr),
            .tx_buf_wdata(tx_buf_wdata),
            .tx_data_len(tx_data_len),
            .tx_start(tx_start));

link_c link_c(.Rclk(syn_clk),
              .rst(reset),
              .tx_buf_wren(tx_buf_wren),
              .tx_buf_waddr(tx_buf_waddr),
              .tx_buf_wdata(tx_buf_wdata),
              .tx_data_len(tx_data_len),
              .tx_start(tx_start),
              .sys_clk(sys_clk),
              .clk_phy_p0(clk_phy_p0),
              .clk_phy_p90(clk_phy_p90),
              .clk_phy_p180(clk_phy_p180),
              .clk_phy_p270(clk_phy_p270),
              .rx_buf_rden(rx_buf_rden),
              .rx_buf_raddr(rx_buf_raddr),
              .o_rx_done(rx_done),
              .rx_buf_rdata(rx_buf_rdata),
              .o_rx_crc_rslt(rx_crc_rslt),
              .o_rx_start(rx_start),
              .lb_rxd(lb_rxd),
              .lb_txd(lb_txd),
              .lb_txen(lb_txen));
          
endmodule



