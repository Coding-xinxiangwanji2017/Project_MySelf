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
// Func           : MN811 BOARD Top
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

module M_NET_Link_2(
    //------------------------------------------
    //--  Global Reset, active low
    //--  Clock: 50MHz
    //------------------------------------------
    input                rst_n            ,
    input                clk_50m          ,

    //------------------------------------------
    //-- Application interface
    //------------------------------------------
    //-- Tx
    input   wire         i_tx_ram_wen      ,
    input   wire[10: 0]  im_tx_ram_waddr   ,
    input   wire[ 7: 0]  im_tx_ram_wd      ,
    input   wire         i_tx_start        ,

    input   wire[10: 0]  im_tx_frm_len     ,
    input   wire[47: 0]  im_smac           ,
    input   wire[47: 0]  im_dmac           ,
    output  wire         o_tx_busy         ,

    //-- Rx
    input   wire         i_rx_ram_ren      ,
    input   wire[10:0 ]  im_rx_ram_raddr   ,
    output  wire[ 7:0 ]  om_rx_ram_rd      ,
    output  wire         o_rx_new_arrival  ,
    output  wire         o_rx_done         ,
    output  wire         o_rx_err          ,
    output  reg [10: 0]  om_rx_frm_len     ,
    output  reg [47: 0]  om_rx_PC_smac     ,
    output  reg          o_rx_match        ,

    output  reg [ 7: 0]  om_rx_app_la      ,
    output  reg [ 7: 0]  om_rx_app_mode    ,
    output  reg [ 7: 0]  om_rx_app_cmd     ,
    output  reg [23: 0]  om_rx_app_addr    ,
    //------------------------------------------
    //-- RMII Module
    //------------------------------------------
    //-- Send: 8bits data and send each 4 clock cycles
    output  wire          o_tx_dv  ,
    output  wire[ 7:0]    om_tx_d  ,

    //-- Receive
    input                 i_rx_start ,
    input                 i_rx_end   ,
    input                 i_rx_dv    ,
    input       [7:0]     im_rx_d
    );

   //=========================================================
   // Parameter defination
   //=========================================================
   parameter DLY       = 1;

   //=========================================================
   // Internal signal definition
   //=========================================================
   wire                rst;

   //----------------------------
   //-- Rx signal
   //----------------------------
   reg  [10: 0]        r_tx_cnt       ;
   reg  [ 3: 0]        r_time_slice   ;
   reg                 r_tx_proc      ;
   reg                 r_tx_sfd_proc  ;
   reg                 r_tx_head_proc ;
   reg                 r_tx_data_proc ;
   reg                 r_tx_crc_proc  ;
   reg                 r_tx_end       ;

   //-- tx buffer interface signals
   reg  [ 7: 0]        r_tx_data_sfd   ;
   wire                r_tx_data_sfd_v ;

   wire [ 7: 0]        w_tx_data_head  ;
   wire                w_tx_data_head_v;
   reg  [14*8-1: 0]    r_head_shift;

   reg  [10: 0]        r_tx_ram_raddr      ;
   wire [ 7: 0]        w_tx_ram_rd         ;
   wire [ 7: 0]        w_tx_data_Payload   ;
   wire                w_tx_data_Payload_v ;

   wire [ 7: 0]        w_tx_data_crc   ;
   wire                w_tx_data_crc_v ;

   reg  [ 7: 0]        r_tx_data   ;
   reg                 r_tx_data_v ;

   wire  [ 7: 0]       w_crc_din      ;
   wire                w_crc_en       ;
   wire                w_crc_init     ;
   wire  [31: 0]       w_crc_rlt      ;
   reg   [31: 0]       r_crc_rlt_shift;

   //----------------------------
   //-- Rx signal
   //----------------------------
   reg  [10:0]         r_rx_counter   ;

   reg  [10:0]         r_rx_ram_waddr ;
   wire [ 7:0]         w_rx_ram_wd    ;
   wire                w_rx_ram_wen   ;
   reg                 r_rx_frm_mac_head ;
   reg                 r_rx_frm_reversed ;

   reg                 r_rx_end_d1    ;
   reg                 r_rx_end_d2    ;
   wire                w_rx_crc_err   ;

   reg                 r_rx_dmac_en;
   reg                 r_rx_smac_en;
   reg  [47: 0]        r_rx_dmac;



   //********************************************************************************
   //  Global control signals: Clock and reset
   //********************************************************************************
   assign rst        = ~rst_n;
   assign ETH_REFCLK = clk_50m;


   //********************************************************************************
   //   Tx control
   //********************************************************************************

   assign o_tx_busy =  r_tx_proc ;
   assign o_rx_new_arrival = i_rx_start;
   //=========================================================
   // timing control
   //=========================================================
   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_time_slice <= 4'b0;
      else
         if ( i_tx_start == 1'b1)
             r_time_slice     <= 4'b1;
         else if ( r_tx_proc == 1'b1 )
             r_time_slice <= { r_time_slice[2:0], r_time_slice[3] } ;
         else
             r_time_slice     <= 4'b0;
   end

   //-- tx counter
   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_tx_cnt <= 11'b0;
      else
         if ( i_tx_start == 1'b1)
             r_tx_cnt     <= 11'b1;
         else if ( r_time_slice[3] == 1'b1 )
             r_tx_cnt <= r_tx_cnt  +  1 ;
   end

   //-- tx process flag
   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_tx_proc <= 1'b0;
      else
         if ( i_tx_start == 1'b1)
             r_tx_proc     <= 1'b1;
         else if ( r_time_slice[3] == 1'b1 && r_tx_cnt == im_tx_frm_len + 26  )
             r_tx_proc     <= 1'b0;
   end

   //-- sfd process flag
   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_tx_sfd_proc <= 1'b0;
      else
         if ( i_tx_start == 1'b1)
             r_tx_sfd_proc     <= 1'b1;
         else if ( r_time_slice[3] == 1'b1 && r_tx_cnt == 8 )
             r_tx_sfd_proc     <= 1'b0;
   end

   //-- frame head data ( dmac, smac, length ) process flag
   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_tx_head_proc <= 1'b0;
      else
         if      ( r_time_slice[3] == 1'b1 && r_tx_cnt == 8 )
             r_tx_head_proc     <= 1'b1;
         else if ( r_time_slice[3] == 1'b1 && r_tx_cnt ==  22 )
             r_tx_head_proc     <= 1'b0;
   end

   //-- payload data process flag
   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_tx_data_proc <= 1'b0;
      else
         if      ( r_time_slice[3] == 1'b1 && r_tx_cnt == 22 )
             r_tx_data_proc     <= 1'b1;
         else if ( r_time_slice[3] == 1'b1 && r_tx_cnt == im_tx_frm_len + 22 )
             r_tx_data_proc     <= 1'b0;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_tx_crc_proc <= 1'b0;
      else
         if      ( r_time_slice[3] == 1'b1 && r_tx_cnt == im_tx_frm_len + 22 )
             r_tx_crc_proc     <= 1'b1;
         else if ( r_time_slice[3] == 1'b1 && r_tx_cnt == im_tx_frm_len + 26 )
             r_tx_crc_proc     <= 1'b0;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_tx_end      <= 1'b0;
      else
         if ( r_time_slice[3] == 1'b1 && r_tx_cnt == im_tx_frm_len + 22  )
             r_tx_end     <= 1'b1;
         else
             r_tx_end     <= 1'b0;
   end

   //=========================================================
   // tx sfd data
   //=========================================================
   assign r_tx_data_sfd_v  =  r_tx_sfd_proc && r_time_slice[1];

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_tx_data_sfd <= 8'b0;
      else
         if ( r_tx_sfd_proc == 1'b1 && r_tx_cnt == 8 )
             r_tx_data_sfd <= 8'hd5;
         else
             r_tx_data_sfd <= 8'h55;
   end

   //=========================================================
   // tx mac head data
   //=========================================================
   assign w_tx_data_head     = r_head_shift[111:104] ;
   assign w_tx_data_head_v   = r_tx_head_proc && r_time_slice[1];
   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_head_shift <= 112'b0;
      else
         if ( i_tx_start == 1'b1)
             //r_head_shift <= {im_dmac, im_smac, 5'b00000,im_tx_frm_len };
             //r_head_shift <= {im_dmac, im_smac, 16'h0800 };
             r_head_shift <= {im_dmac, im_smac, 16'h008a };
         else if ( r_tx_head_proc == 1'b1 && r_time_slice[1] == 1'b1  )
             r_head_shift[111:8] <= r_head_shift[103:0];
   end

   //=========================================================
   // tx buffer read control, payload data
   //=========================================================
   assign w_tx_data_Payload_v   = r_tx_data_proc && r_time_slice[1];
   assign w_tx_data_Payload  =  w_tx_ram_rd;

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_tx_ram_raddr <= 11'b0;
      else
         if ( i_tx_start == 1'b1)
             r_tx_ram_raddr     <= 11'b0;
         else if ( r_tx_data_proc == 1'b1 && r_time_slice[1] == 1'b1 )
             r_tx_ram_raddr <= r_tx_ram_raddr + 1 ;
   end

   //=========================================================
   // tx crc data
   //=========================================================
   assign  w_crc_init         = i_tx_start;
   assign  w_crc_en           = r_tx_data_v && ( r_tx_data_proc || r_tx_head_proc );
   assign  w_crc_din          = r_tx_data  ;
   assign  w_tx_data_crc      = r_crc_rlt_shift[31:24];
   assign  w_tx_data_crc_v    = r_tx_crc_proc && r_time_slice[1];

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_crc_rlt_shift <= 32'b0;
      else
         if ( r_tx_crc_proc == 1'b1 && r_time_slice[0] == 1'b1 && r_tx_cnt == im_tx_frm_len + 23 )
             r_crc_rlt_shift <= w_crc_rlt;
         else if (  r_tx_crc_proc == 1'b1 && r_time_slice[1] == 1'b1 )
             r_crc_rlt_shift[31: 8] <= r_crc_rlt_shift[23: 0];
   end

   //=========================================================
   // tx frame data
   //=========================================================
   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_tx_data <= 8'b0;
      else
         if ( r_tx_data_sfd_v == 1'b1 )
             r_tx_data <= r_tx_data_sfd;
         else if ( w_tx_data_head_v == 1'b1 )
             r_tx_data <= w_tx_data_head;
         else if ( w_tx_data_Payload_v == 1'b1 )
             r_tx_data <= w_tx_data_Payload;
         else if ( w_tx_data_crc_v == 1'b1 )
             r_tx_data <= w_tx_data_crc;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_tx_data_v <= 1'b0;
      else
         r_tx_data_v  <=  r_tx_data_sfd_v || w_tx_data_head_v  || w_tx_data_Payload_v || w_tx_data_crc_v;
   end

   assign  o_tx_dv     = r_tx_data_v;
   assign  om_tx_d     = r_tx_data  ;



   //********************************************************************************
   //   Rx control
   //********************************************************************************
   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_rx_counter     <= 11'b0;
      else
         if ( i_rx_start == 1'b1  )
             r_rx_counter <= 11'b0 ;
         else if ( i_rx_dv == 1'b1 )
             r_rx_counter <= r_rx_counter + 1 ;
   end

   //=========================================================
   // Mac Frame head
   //=========================================================

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_rx_dmac_en <= 1'b0;
      else
         if ( i_rx_start == 1'b1  )
             r_rx_dmac_en <= 1'b1;
         else if (  r_rx_counter == 5 && i_rx_dv == 1'b1 )
             r_rx_dmac_en <= 1'b0 ;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_rx_smac_en <= 1'b0;
      else
         if ( r_rx_counter ==  5 && i_rx_dv == 1'b1)
             r_rx_smac_en <= 1'b1;
         else if (  r_rx_counter ==  11 && i_rx_dv == 1'b1 )
             r_rx_smac_en <= 1'b0 ;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_rx_dmac     <= 48'b0;
      else
         if ( i_rx_start == 1'b1  )
             r_rx_dmac <= 48'b0;
         else if ( r_rx_dmac_en == 1'b1 && i_rx_dv == 1'b1)
             r_rx_dmac <= { r_rx_dmac[39:0], w_rx_ram_wd } ;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_rx_PC_smac     <= 48'b0;
      else
         if ( i_rx_start == 1'b1  )
             om_rx_PC_smac <= 48'b0 ;
         else if ( r_rx_smac_en == 1'b1 && i_rx_dv == 1'b1 )
             om_rx_PC_smac <=  { om_rx_PC_smac[39:0] , w_rx_ram_wd } ;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         o_rx_match <= 1'b0;
      else
         if ( i_rx_start == 1'b1 )
             o_rx_match <= 1'b0;
         else if (  r_rx_end_d1 == 1'b1 )
              if ( r_rx_dmac == im_smac   )
                  o_rx_match <= 1'b1 ;
              else
                  o_rx_match <= 1'b0 ;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_rx_frm_len     <= 11'b0;
      else
         if ( i_rx_start == 1'b1  )
             om_rx_frm_len <= 11'b0 ;
         else if ( w_rx_ram_wen == 1'b1  )
             om_rx_frm_len <= om_rx_frm_len + 1 ;
   end


   //=========================================================
   // Application layer
   //=========================================================

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_rx_app_la <= 8'b0;
      else
         if ( r_rx_counter ==  14 && i_rx_dv == 1'b1)
             om_rx_app_la <= im_rx_d;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_rx_app_mode <= 8'b0;
      else
         if ( r_rx_counter ==  17 && i_rx_dv == 1'b1)
             om_rx_app_mode <= im_rx_d;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_rx_app_cmd <= 8'b0;
      else
         if ( r_rx_counter ==  18 && i_rx_dv == 1'b1)
             om_rx_app_cmd <= im_rx_d;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_rx_app_addr[ 7: 0] <= 8'b0;
         
      else
         if ( r_rx_counter ==  20 && i_rx_dv == 1'b1)
             om_rx_app_addr[ 7: 0] <= im_rx_d;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_rx_app_addr[15: 8] <= 8'b0;
      else
         if ( r_rx_counter ==  21 && i_rx_dv == 1'b1)
             om_rx_app_addr[15: 8] <= im_rx_d;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         om_rx_app_addr[23:16] <= 8'b0;
      else
         if ( r_rx_counter ==  22 && i_rx_dv == 1'b1)
             om_rx_app_addr[23:16]  <= im_rx_d;
   end

   //=========================================================
   // Rx RAM write
   //=========================================================
   assign   w_rx_ram_wd  =  im_rx_d  ;
   assign   w_rx_ram_wen =  i_rx_dv & (~r_rx_frm_mac_head) & (~r_rx_frm_reversed) ;

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_rx_frm_mac_head <= 1'b0;
      else
         if ( i_rx_start == 1'b1)
             r_rx_frm_mac_head <= 1'b1;
         else if ( r_rx_counter == 13 && i_rx_dv == 1'b1)
             r_rx_frm_mac_head <= 1'b0;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_rx_frm_reversed <= 1'b0;
      else
         if ( r_rx_counter == 14 && i_rx_dv == 1'b1)
             r_rx_frm_reversed <= 1'b1;
         else if( r_rx_counter == 16 && i_rx_dv == 1'b1)
             r_rx_frm_reversed <= 1'b0;
   end


   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_rx_ram_waddr     <= 11'b0;
      else
         if ( i_rx_start == 1'b1  )
             r_rx_ram_waddr <= 11'b0 ;
         else if ( w_rx_ram_wen == 1'b1 )
             r_rx_ram_waddr <= r_rx_ram_waddr + 1 ;
   end

   //=========================================================
   // Rx CRC
   //=========================================================
   assign  o_rx_err    =  w_rx_crc_err;
   assign  o_rx_done   =  r_rx_end_d2;

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
         r_rx_end_d1     <= 1'b0;
         r_rx_end_d2     <= 1'b0;
      end
      else
      begin
         r_rx_end_d1     <= i_rx_end;
         r_rx_end_d2     <= r_rx_end_d1;
      end
   end


   //=========================================================
   //  CRC Modules
   //=========================================================
   m_crc32en8_eth u1_m_crc32en8(
    .im_cpsv_data      (w_crc_din    ),
    .rst_n             (rst_n        ),
    .i_cpsl_crcen      (w_crc_en     ),
    .om_cpsv_crcresult (w_crc_rlt    ),
    .sys_clk           (ETH_REFCLK   ),
    .i_cpsl_init       (w_crc_init   )
    );

   m_crc32de8_eth u1_m_crc32de8(
    .rst_n            (rst_n        ),
    .sys_clk          (ETH_REFCLK   ),
    .i_cpsl_init      (i_rx_start   ),
    .im_cpsv_data     (im_rx_d      ),
    .i_cpsl_crcen     (i_rx_dv      ),
    .i_cpsl_crcend    (r_rx_end_d1  ),
    .o_cpsl_crcerr    (w_rx_crc_err )
    );

   //=========================================================
   // RX/TX  Buffer
   //=========================================================
   //-- Tx Buffer
   RAM_2048_8_SDP_WRAP u1_tx_RAM_2048_8_SDP(
    .WD      (im_tx_ram_wd   ),
    .rst_n(rst_n),
    .RD      (w_tx_ram_rd    ),
    .WEN     (i_tx_ram_wen   ),
    .REN     (1'b1           ),
    .WADDR   (im_tx_ram_waddr),
    .RADDR   (r_tx_ram_raddr ),
    .WCLK    (clk_50m)        ,
    .RCLK    (ETH_REFCLK)     ,
    .RDP     (               )
    );

   //-- Rx Buffer
   RAM_2048_8_SDP_WRAP u2_rx_RAM_2048_8_SDP(
    .rst_n(rst_n),
    .WD      (w_rx_ram_wd    ),
    .RD      (om_rx_ram_rd   ),
    .WEN     (w_rx_ram_wen   ),
    .REN     (i_rx_ram_ren   ),
    .WADDR   (r_rx_ram_waddr ),
    .RADDR   (im_rx_ram_raddr),
    .WCLK    (ETH_REFCLK     ),
    .RCLK    (clk_50m        ),
    .RDP     (               )
    );




endmodule
