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
// Name of module : MN811_BOARD_B01
// Project        : NicSys8000
// Func           :
// Author         : Zhang Xueyan
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FGG484
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

`timescale 1ns / 100ps

module M_NET_APP_DATA(
    //------------------------------------------
    //--  Global Reset, active low
    //--  Clock: 50MHz
    //------------------------------------------
    input                rst_n             ,
    input                clk_50m           ,

    input   wire[6:0]         im_station_id     ,
    //------------------------------------------
    //-- Link layer interface
    //------------------------------------------
    //-- Tx
    output  reg          o_tx_ram_wen      ,
    output  reg [10: 0]  om_tx_ram_waddr   ,
    output  reg [ 7: 0]  om_tx_ram_wd      ,
    output  wire          o_tx_start        ,

    output  wire[10: 0]  om_tx_frm_len     ,
    output  wire[47: 0]  om_smac           ,
    output  wire[47: 0]  om_dmac           ,
    input   wire         i_tx_busy         ,

    //-- Rx
    output  reg          o_rx_ram_ren      ,
    output  wire[10:0 ]  om_rx_ram_raddr   ,

    input   wire[ 7:0 ]  im_rx_ram_rd      ,
    input   wire         i_rx_done         ,
    input   wire         i_rx_err          ,
    input   wire [10: 0] im_rx_frm_len     ,
    input   wire[47: 0]  im_rx_PC_smac        ,
    input   wire         i_rx_match        ,

    //------------------------------------------
    //-- Memory interface
    //------------------------------------------

    //------------------------------
    //--  Transmit download  RAM,
    //--  Uplink, 2K Bytes
    //------------------------------
    output  reg             o_tdub_rden       ,
    output  reg [10:0]      om_tdub_raddr     ,
    input   wire[ 7:0]      im_tdub_rdata     ,
    //------------------------------
    //--  Transmit download  RAM
    //--  Downink, 2K Bytes
    //------------------------------
    output reg              o_tddb_wren       ,
    output reg [10:0]       om_tddb_waddr     ,
    output reg[ 7:0]        om_tddb_wdata     ,

    //------------------------------
    //-- SRAM Interface
    //------------------------------
    output  wire            o_SRAM_0_RD_n        ,
    output  reg             o_SRAM_0_WE_n        ,
    output  reg [19: 0]     om_SRAM_0_A          ,
    input   wire[15: 0]     im_SRAM_0_D_RD       ,
    output  reg [15: 0]     om_SRAM_0_D_WE       ,
    input   wire            i_SRAM_0_ERR         ,

    output  reg             o_SRAM_1_RD_n        ,
    output  wire            o_SRAM_1_WE_n        ,
    output  reg [19: 0]     om_SRAM_1_A          ,
    input   wire[15: 0]     im_SRAM_1_D_RD       ,
    output  wire[15: 0]     om_SRAM_1_D_WE       ,
    input   wire            i_SRAM_1_ERR         ,

    //------------------------------
    //--  Transmit console up cmd RAM
    //--  Uplink, 36K Bytes
    //------------------------------
    output  reg             o_tcucb_rden      ,
    output  reg [15:0]      om_tcucb_raddr    ,
    input   wire[ 7:0]      im_tcucb_rdata    ,
    //------------------------------
    //--  Transmit console up cmd RAM
    //--  Downink, 36K Bytes
    //------------------------------
    output reg              o_tcdcb_wren      ,
    output reg [15:0]       om_tcdcb_waddr    ,
    output reg [ 7:0]       om_tcdcb_wdata    ,

    //------------------------------
    //-- Control signals
    //------------------------------
    input  wire[19: 0]      im_data_proc_addr     ,
    input  wire[ 1: 0]      im_data_porc_cmd      ,
    input  wire[ 1: 0]      im_data_proc_mode     ,

    input  wire             i_data_dl_proc_start  ,
    input  wire             i_data_cons_proc_start,
    input  wire             i_data_run_proc_start,

    output wire             o_dl_done,
    output wire             o_run_done,

    input  wire             i_rd_cmd_req ,
    input  wire [19: 0]     i_rd_cmd_base_addr,
    output reg              o_rd_cmd_ack ,

    output reg [ 7: 0]     om_ram_la    ,
    output reg [ 7: 0]     om_ram_mode   ,
    output reg [ 7: 0]     om_ram_cmd   ,
    output reg [23: 0]     om_ram_addr


    );

   //=========================================================
   // Parameter defination
   //=========================================================
   parameter DLY       = 1;


   parameter ETHERNET_FRAME_LEN   = 137;
   parameter TIMER_DL_CYCLE       = 150;
   parameter TIMER_CONS_CYCLE     = 150;

   parameter TX_APP_DATA_LEN     = 138;

   //=========================================================
   // Internal signal definition
   //=========================================================
   wire                rst;

   wire[15: 0]         w_data_proc_addr_cmd  ;

   reg                 r_dl_proc;
   reg                 r_dl_end;
   reg                 r_run_end;

   //-- download frame data
   reg                 r_dl_head_valid;
   wire    [ 7: 0]      w_dl_head_data;
   reg                 r_dl_payload_valid;
   wire    [ 7: 0]      w_dl_payload_data;



   reg  r_tdub_rden_valid_pre1;
   reg  r_tdub_rden_valid;

   reg  r_tcucb_rden_valid_pre1;
   reg  r_tcucb_rden_valid;

   reg  r_sram_rden_valid_pre1;
   reg  r_sram_rden_valid;

   reg    [15: 0]   r_SRAM_1_D_RD_d1;


   reg   [4:0]    r_rd_cmd_cnt;
   reg            r_rd_cmd_req_d1;
   wire           w_rd_cmd_Start;

   reg            r_rd_cmd_ram_rden;
   reg   [19:0]   r_rd_cmd_ram_addr;
   reg            r_rd_cmd_ram_rden_d1,r_rd_cmd_ram_rden_d2;
   reg            r_rd_cmd_ram_d_v;





   //********************************************************************************
   //  Global control signals: Clock and reset
   //********************************************************************************
   assign rst        = ~rst_n;

   assign   w_data_proc_addr_cmd = im_data_proc_addr[19:4];

   assign   o_dl_done = r_dl_end ;

   assign   o_run_done = r_run_end ;

   //********************************************************************************
   //  Error signals
   //********************************************************************************





   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin




      end
      else
      begin







      end
   end

   //********************************************************************************
   //--  Read cmd parameters control
   //********************************************************************************




   assign   w_rd_cmd_Start = i_rd_cmd_req & (~r_rd_cmd_req_d1);

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_rd_cmd_req_d1 <= 1'b0;
      else
         r_rd_cmd_req_d1 <= i_rd_cmd_req;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_rd_cmd_cnt <= 5'b0;
      else
         if ( w_rd_cmd_Start == 1'b1)
             r_rd_cmd_cnt <= 5'b0;
         else if ( r_rd_cmd_req_d1 == 1'b1 )
             r_rd_cmd_cnt <= r_rd_cmd_cnt + 1 ;
         else if (r_rd_cmd_cnt == 12)
             r_rd_cmd_cnt <= 5'b0;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         o_rd_cmd_ack <= 1'b0;
      else
         if ( i_rd_cmd_req == 1'b1 && r_rd_cmd_cnt == 10 )
             o_rd_cmd_ack <= 1'b1;
         else
             o_rd_cmd_ack <= 1'b0 ;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_rd_cmd_ram_rden <= 1'b0;
      else
         if ( w_rd_cmd_Start == 1'b1)
             r_rd_cmd_ram_rden <= 1'b1;
         //else if ( r_rd_cmd_req_d1 == 8 )
         else if ( r_rd_cmd_ram_addr == i_rd_cmd_base_addr[19:4] + 7 )
             r_rd_cmd_ram_rden <= 1'b0 ;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_rd_cmd_ram_addr <= 20'b0;
      else
         if ( w_rd_cmd_Start == 1'b1)
             r_rd_cmd_ram_addr <= i_rd_cmd_base_addr[19:4];
         else if ( r_rd_cmd_ram_rden == 1'b1 )
             r_rd_cmd_ram_addr <= r_rd_cmd_ram_addr + 1 ;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
          r_rd_cmd_ram_rden_d1 <= 1'b0;
          r_rd_cmd_ram_rden_d2 <= 1'b0;
          r_rd_cmd_ram_d_v     <= 1'b0;
      end
      else
      begin
          r_rd_cmd_ram_rden_d1 <= r_rd_cmd_ram_rden;
          r_rd_cmd_ram_rden_d2 <= r_rd_cmd_ram_rden_d1;
          r_rd_cmd_ram_d_v     <= r_rd_cmd_ram_rden_d2;
      end
   end

   //assign r_rd_cmd_ram_d_v =  r_rd_cmd_ram_rden_d2;


   //------------------------------
   //-- Latch cmd data
   //------------------------------
   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_ram_la <= 8'b0;
      else
         if ( r_rd_cmd_ram_d_v == 1'b1 && r_rd_cmd_cnt == 3)
             om_ram_la <= im_tcucb_rdata;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_ram_mode <= 8'b0;
      else
         if ( r_rd_cmd_ram_d_v == 1'b1 && r_rd_cmd_cnt == 4)
             om_ram_mode <= im_tcucb_rdata;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_ram_cmd <= 8'b0;
      else
         if ( r_rd_cmd_ram_d_v == 1'b1 && r_rd_cmd_cnt == 5)
             om_ram_cmd <= im_tcucb_rdata;
   end

//   always @(posedge clk_50m or negedge rst_n)
//   begin
//      if ( rst_n == 1'b0 )
//         om_ram_addr[19:16] <= 4'b0;
//      else
//         if ( r_rd_cmd_ram_d_v == 1'b1 && r_rd_cmd_cnt == 6)
//             om_ram_addr[19:16] <= im_tcucb_rdata[3:0];
//   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_ram_addr[ 7: 0] <= 8'b0;
      else
         if ( r_rd_cmd_ram_d_v == 1'b1 && r_rd_cmd_cnt == 7)
             om_ram_addr[ 7: 0] <= im_tcucb_rdata[7:0];
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_ram_addr[15: 8] <= 8'b0;
      else
         if ( r_rd_cmd_ram_d_v == 1'b1 && r_rd_cmd_cnt == 8)
             om_ram_addr[15: 8] <= im_tcucb_rdata;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_ram_addr[23: 16] <= 4'b0;
      else
         if ( r_rd_cmd_ram_d_v == 1'b1 && r_rd_cmd_cnt == 9)
             om_ram_addr[23: 16] <= im_tcucb_rdata;
   end

   //********************************************************************************
   //--  Ethernet rx interface
   //--  download and console process
   //********************************************************************************

   reg [8: 0]r_conuter_dl;
   wire      w_dl_start;


   assign w_dl_start  = i_data_dl_proc_start | i_data_cons_proc_start | i_data_run_proc_start ;

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_conuter_dl <= 9'b0;
      else
         if ( w_dl_start == 1'b1)
             r_conuter_dl <= 9'b0;
         else if ( r_dl_proc == 1'b1 )
             r_conuter_dl <= r_conuter_dl + 1 ;
         else
             r_conuter_dl <= 9'b0;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_dl_proc <= 1'b0;
      else
         if ( w_dl_start == 1'b1)
             r_dl_proc <= 1'b1;
         //else if ( r_conuter_dl == TIMER_DL_CYCLE   && im_data_proc_mode == 2'b10  )    //-- download
         //    r_dl_proc <= 1'b0;
         //else if ( r_conuter_dl == TIMER_CONS_CYCLE && im_data_proc_mode == 2'b01  )    //-- console
         //    r_dl_proc <= 1'b0;
         else if ( r_conuter_dl == TIMER_DL_CYCLE   )
             r_dl_proc <= 1'b0;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_dl_end <= 1'b0;
      else
         //if      (r_dl_proc == 1'b1 && r_conuter_dl == TIMER_DL_CYCLE   && im_data_proc_mode == 2'b10  )    //-- download
         //    r_dl_end <= 1'b1;
         //else if (r_dl_proc == 1'b1 && r_conuter_dl == TIMER_CONS_CYCLE && im_data_proc_mode == 2'b01  )    //-- console

         if (r_dl_proc == 1'b1 && r_conuter_dl == TIMER_CONS_CYCLE && (im_data_proc_mode == 2'b10 || im_data_proc_mode == 2'b01) )
             r_dl_end <= 1'b1;
         else
             r_dl_end <= 1'b0;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_run_end <= 1'b0;
      else
         //if      (r_dl_proc == 1'b1 && r_conuter_dl == TIMER_DL_CYCLE   && im_data_proc_mode == 2'b10  )    //-- download
         //    r_dl_end <= 1'b1;
         //else if (r_dl_proc == 1'b1 && r_conuter_dl == TIMER_CONS_CYCLE && im_data_proc_mode == 2'b01  )    //-- console

         if (r_dl_proc == 1'b1 && r_conuter_dl == TIMER_CONS_CYCLE && (im_data_proc_mode == 2'b00) )
             r_run_end <= 1'b1;
         else
             r_run_end <= 1'b0;
   end

   //=========================================================
   // ethernet rx buffer read control
   // rx-buffer read en, address
   //=========================================================

   assign om_rx_ram_raddr = {2'b0, r_conuter_dl};

   assign w_dl_head_data    = im_rx_ram_rd   ;
   assign w_dl_payload_data = im_rx_ram_rd   ;

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         o_rx_ram_ren <= 1'b0;
      else
         if ( w_dl_start == 1'b1)
             o_rx_ram_ren     <= 1'b1;
         else if ( r_conuter_dl == ETHERNET_FRAME_LEN )
             o_rx_ram_ren <= 1'b0;
   end


   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_dl_head_valid <= 1'b0;
      else
         if ( r_dl_proc == 1'b1 && r_conuter_dl == 1 )
             r_dl_head_valid <= 1'b1;
         else if ( r_dl_proc == 1'b1 && (r_conuter_dl == 9  ))
             r_dl_head_valid <= 1'b0;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_dl_payload_valid <= 1'b0;
      else
         if ( r_dl_proc == 1'b1 &&  r_conuter_dl == 9  )
             r_dl_payload_valid <= 1'b1;
         else if ( r_dl_proc == 1'b1 &&  r_conuter_dl == 137 )
             r_dl_payload_valid <= 1'b0;
   end





   //=========================================================
   // tddb buffer
   //
   //=========================================================

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         o_tddb_wren <= 1'b0;
      else
        // if (  (im_data_proc_mode == 2'b10 )  || (im_data_proc_mode == 2'b01 && im_data_porc_cmd == 2'b01 ) )
         if  (im_data_proc_mode == 2'b10 )
         o_tddb_wren <= r_dl_head_valid | r_dl_payload_valid;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_tddb_waddr <= 11'b0;
      else
         if ( w_dl_start == 1'b1 )
             om_tddb_waddr <= 11'b0;
         else if ( o_tddb_wren == 1'b1  )
             om_tddb_waddr <= om_tddb_waddr + 1;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_tddb_wdata <= 8'b0;
      else
         if ( r_dl_head_valid == 1'b1 )
             om_tddb_wdata <= w_dl_head_data;
         else if ( r_dl_payload_valid == 1'b1  )
             om_tddb_wdata <= w_dl_payload_data;
   end


   //=========================================================
   // tcdcb buffer
   //
   //=========================================================

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         o_tcdcb_wren <= 1'b0;
      else
         if (im_data_proc_mode == 2'b01 && im_data_porc_cmd == 2'b01 )
             o_tcdcb_wren <= r_dl_head_valid;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_tcdcb_waddr <= 11'b0;
      else
         if ( w_dl_start == 1'b1 )
             om_tcdcb_waddr <= w_data_proc_addr_cmd;
         else if ( o_tcdcb_wren == 1'b1  )
             om_tcdcb_waddr <= om_tcdcb_waddr + 1;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_tcdcb_wdata <= 8'b0;
      else
         if ( r_dl_head_valid == 1'b1 )
             om_tcdcb_wdata <= w_dl_head_data;
         else
             om_tcdcb_wdata <= 8'b0;
   end

   //=========================================================
   // SRAM download write
   //
   //=========================================================
   assign  o_SRAM_0_RD_n  = 1'b1      ;

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         o_SRAM_0_WE_n <= 1'b1;
      else
         if (im_data_proc_mode == 2'b01 && im_data_porc_cmd == 2'b01 )
             o_SRAM_0_WE_n <= ~r_dl_payload_valid;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_SRAM_0_A <= 20'b0;
      else
         if ( w_dl_start == 1'b1 )
             om_SRAM_0_A <= im_data_proc_addr;
         //if ( i_data_cons_proc_start  == 1'b1 )
         //    om_SRAM_0_A <= im_data_proc_addr ;               
         //else if (  i_data_run_proc_start == 1'b1 )
         //    om_SRAM_0_A <= im_data_proc_addr  - 8'h80;      // 2016/10/28
         else if ( o_SRAM_0_WE_n == 1'b0  )
             om_SRAM_0_A <= om_SRAM_0_A + 1;
         else if ( r_dl_proc != 1'b1 )
             om_SRAM_0_A <= 20'b0;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_SRAM_0_D_WE <= 16'b0;
      else
         if ( r_dl_payload_valid == 1'b1  )
            // om_SRAM_0_D_WE <= { 8'b0, w_dl_head_data } ;
             om_SRAM_0_D_WE <= { 8'b0, w_dl_payload_data } ;             
         else
             om_SRAM_0_D_WE <= 16'b0;
   end



   //********************************************************************************
   //--  Ethernet tx interface
   //--  upload
   //********************************************************************************

   assign o_tx_start = r_dl_end || r_run_end;


   assign om_tx_frm_len = TX_APP_DATA_LEN;

   assign om_smac =  { {40{1'b1}}, 1'b0, im_station_id} ;
   assign om_dmac =  im_rx_PC_smac ;

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         o_tx_ram_wen <= 1'b0;
      else
         if ( w_dl_start == 1'b1)
             o_tx_ram_wen     <= 1'b0;
         else
             o_tx_ram_wen <= r_tcucb_rden_valid || r_sram_rden_valid || r_tdub_rden_valid ;
   end


   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_tx_ram_waddr <= 11'b0;
      else
         if ( w_dl_start == 1'b1 )
             om_tx_ram_waddr <= 11'b0;
         else if ( o_tx_ram_wen == 1'b1  )
             if ( om_tx_ram_waddr == 0 )
                 om_tx_ram_waddr <= 3 ;
             else
                 om_tx_ram_waddr <= om_tx_ram_waddr + 1;
   end


   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_tx_ram_wd <= 8'b0;
      else
         if ( r_tcucb_rden_valid == 1'b1 )
             om_tx_ram_wd <= im_tcucb_rdata;
         else if ( r_tdub_rden_valid == 1'b1 )
             om_tx_ram_wd <= im_tdub_rdata;
         else if ( r_sram_rden_valid == 1'b1 )
             om_tx_ram_wd <= r_SRAM_1_D_RD_d1;
         else
             om_tx_ram_wd <= 8'b0;
   end


   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_SRAM_1_D_RD_d1 <= 16'b0;
      else
         r_SRAM_1_D_RD_d1 <= im_SRAM_1_D_RD ;
   end


   //=========================================================
   // tdub buffer
   //
   //=========================================================

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         o_tdub_rden <= 1'b0;
      else
         if  (im_data_proc_mode == 2'b10 )
             o_tdub_rden <= r_dl_head_valid | r_dl_payload_valid;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_tdub_raddr <= 11'b0;
      else
         if ( w_dl_start == 1'b1 )
             om_tdub_raddr <= 11'b0;
         else if ( o_tdub_rden == 1'b1  )
             om_tdub_raddr <= om_tdub_raddr + 1;
   end


   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
           r_tdub_rden_valid_pre1  <= 1'b0;
           r_tdub_rden_valid       <= 1'b0;
      end
      else
      begin
           r_tdub_rden_valid_pre1  <= o_tdub_rden;
           r_tdub_rden_valid       <= r_tdub_rden_valid_pre1;
      end
   end



   //=========================================================
   // tcucb buffer
   //
   //=========================================================

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         o_tcucb_rden <= 1'b0;
      else
         if  (i_rd_cmd_req == 1'b1)
             o_tcucb_rden <= r_rd_cmd_ram_rden;
         else if  (im_data_proc_mode == 2'b01 || im_data_proc_mode == 2'b00   )
             o_tcucb_rden <= r_dl_head_valid;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_tcucb_raddr <= 16'b0;
      else
         if (i_rd_cmd_req == 1'b1)
             om_tcucb_raddr <= r_rd_cmd_ram_addr;
        // else if ( w_dl_start == 1'b1 )
        //     om_tcucb_raddr <= w_data_proc_addr_cmd ;  
         else if ( i_data_cons_proc_start  == 1'b1 )
             om_tcucb_raddr <= w_data_proc_addr_cmd ;               
         else if (  i_data_run_proc_start == 1'b1 )
             om_tcucb_raddr <= w_data_proc_addr_cmd  - 8;      // 2016/10/28
         else if ( o_tcucb_rden == 1'b1  )
             om_tcucb_raddr <= om_tcucb_raddr + 1;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
           r_tcucb_rden_valid_pre1  <= 1'b0;
           r_tcucb_rden_valid       <= 1'b0;
      end
      else
      begin
           r_tcucb_rden_valid_pre1  <= o_tcucb_rden && (~i_rd_cmd_req)  ;
           r_tcucb_rden_valid       <= r_tcucb_rden_valid_pre1;
      end
   end



   //=========================================================
   // SRAM upload write
   //
   //=========================================================

   assign o_SRAM_1_WE_n = 1'b1;
   assign om_SRAM_1_D_WE = 16'b0;

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         o_SRAM_1_RD_n <= 1'b1;
      else
         if (im_data_proc_mode == 2'b01 || im_data_proc_mode == 2'b00   )
             o_SRAM_1_RD_n <= ~r_dl_payload_valid;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_SRAM_1_A <= 20'b0;
      else
            //if ( w_dl_start == 1'b1 )
            //    om_SRAM_1_A <= im_data_proc_addr;
            if ( i_data_cons_proc_start  == 1'b1 )
                om_SRAM_1_A <= im_data_proc_addr ;               
            else if (  i_data_run_proc_start == 1'b1 )
                om_SRAM_1_A <= im_data_proc_addr  - 8'h80;      // 2016/10/28
            else if ( o_SRAM_1_RD_n == 1'b0  )
                om_SRAM_1_A <= om_SRAM_1_A + 1;
            else if ( r_dl_proc != 1'b1 )
             om_SRAM_1_A <= 20'b0;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
           r_sram_rden_valid_pre1  <= 1'b0;
           r_sram_rden_valid       <= 1'b0;
      end
      else
      begin
           r_sram_rden_valid_pre1  <= ~o_SRAM_1_RD_n;
           r_sram_rden_valid       <= r_sram_rden_valid_pre1;
      end
   end




endmodule
