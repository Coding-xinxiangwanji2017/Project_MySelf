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



//`define SIMULATION

`timescale 1ns / 100ps

module M_NET_APP_2(
    //------------------------------------------
    //--  Global Reset, active low
    //--  Clock: 50MHz
    //------------------------------------------
    input                rst_n             ,
    input                clk_50m           ,

    //-----------------------------------------------------------
    //-- Station ID, Rack ID, Slot ID
    //-----------------------------------------------------------
    input   wire[ 2: 0]  im_sys_mode       ,
    input   wire[ 6: 0]  im_station_id     ,

    //------------------------------------------
    //-- Link layer interface
    //------------------------------------------
    //-- Tx
    output  wire         o_tx_ram_wen      ,
    output  wire[10: 0]  om_tx_ram_waddr   ,
    output  wire[ 7: 0]  om_tx_ram_wd      ,
    output  wire         o_tx_start        ,

    output  wire[10: 0]  om_tx_frm_len     ,
    output  wire[47: 0]  om_smac           ,
    output  wire[47: 0]  om_dmac           ,
    input   wire         i_tx_busy         ,

    //-- Rx
    output  wire         o_rx_ram_ren      ,
    output  wire[10: 0]  om_rx_ram_raddr   ,

    input  wire[ 7:0 ]   im_rx_ram_rd      ,
    input  wire          i_rx_new_arrival  ,
    input  wire          i_rx_done         ,
    input  wire          i_rx_err          ,
    input  wire[10: 0]   im_rx_frm_len     ,
    input  wire[47: 0]   im_rx_PC_smac     ,
    input  wire          i_rx_match        ,

    input  wire[ 7: 0]   im_rx_app_la      ,
    input  wire[ 7: 0]   im_rx_app_mode    ,
    input  wire[ 7: 0]   im_rx_app_cmd     ,
    input  wire[23: 0]   im_rx_app_addr    ,

    //------------------------------------------
    //-- Memory interface
    //------------------------------------------

    //------------------------------
    //--  Transmit download  RAM,
    //--  Uplink, 2K Bytes
    //------------------------------
    output  wire            o_tdub_rden       ,
    output  wire [10:0]     om_tdub_raddr     ,
    input   wire[ 7:0]      im_tdub_rdata     ,
    //------------------------------
    //--  Transmit download  RAM,
    //--  Downink, 2K Bytes
    //------------------------------
    output  wire              o_tddb_wren       ,
    output  wire [10: 0]      om_tddb_waddr     ,
    output  wire [ 7: 0]      om_tddb_wdata     ,

    output  wire              o_dl_done         ,

    //------------------------------
    //-- SRAM Interface
    //------------------------------
    output  wire             o_SRAM_0_RD_n        ,
    output  wire             o_SRAM_0_WE_n        ,
    output  wire [19: 0]     om_SRAM_0_A          ,
    input   wire[15: 0]      im_SRAM_0_D_RD       ,
    output  wire [15: 0]     om_SRAM_0_D_WE       ,
    input   wire             i_SRAM_0_ERR         ,
    input   wire             i_SRAM_0_BUSY        ,
    output  reg              o_SRAM_0_REQ_BUSY    ,

    output  wire             o_SRAM_1_RD_n        ,
    output  wire             o_SRAM_1_WE_n        ,
    output  wire [19: 0]     om_SRAM_1_A          ,
    input   wire[15: 0]      im_SRAM_1_D_RD       ,
    output  wire [15: 0]     om_SRAM_1_D_WE       ,
    input   wire             i_SRAM_1_ERR         ,
    input   wire             i_SRAM_1_BUSY        ,
    output  reg              o_SRAM_1_REQ_BUSY       ,

    //------------------------------
    //--  Transmit console up cmd RAM
    //--  Uplink, 36K Bytes
    //------------------------------
    output  wire            o_tcucb_rden      ,
    output  wire[15:0]      om_tcucb_raddr    ,
    input   wire[ 7:0]      im_tcucb_rdata    ,
    //------------------------------
    //--  Transmit console up cmd RAM
    //--  Downink, 36K Bytes
    //------------------------------
    output wire              o_tcdcb_wren      ,
    output wire [15:0]       om_tcdcb_waddr    ,
    output wire [ 7:0]       om_tcdcb_wdata    ,
    
    input                    i_ram_rst_done    ,
    
    input       [15:0]       im_scan_cycle     ,
    input                    i_load_finish     

    );

   //=========================================================
   // Parameter defination
   //=========================================================
   parameter DLY       = 1;

   parameter TIMER_RUN_CYCLE     = 50000;

   parameter HEX_4k           =  4*1024;
   parameter HEX_8k           =  8*1024;
   parameter HEX_16k          = 16*1024;
   parameter HEX_24k          = 24*1024;
   parameter HEX_32k          = 32*1024;
   parameter HEX_64k          = 64*1024;


`ifdef SIMULATION
   parameter FSM_IDLE         = "IDLE      ";
   parameter FSM_DL_WAIT      = "DL_WAIT   ";
   parameter FSM_DL_DOING     = "DL_DOING  ";
   parameter FSM_RUN_WAIT     = "RUN_WAIT  ";
   parameter FSM_RUN_DOING    = "RUN_DOING ";
   parameter FSM_CONS_WAIT    = "CONS_WAIT ";
   parameter FSM_CONS_DOING   = "CONS_DOING";

   parameter FSM_CONS_WAIT2   = "CONS_WAIT2";
   parameter FSM_RUN_WAIT2    = "RUN_WAIT2 ";

   parameter FSM_CONS_READ    = "CONS_READ ";
   parameter FSM_RUN_READ     = "RUN_READ  ";

   parameter state_wid_msb = 80-1;

`else
   parameter FSM_IDLE         = 11'b00000000001;
   parameter FSM_DL_WAIT      = 11'b00000000010;
   parameter FSM_DL_DOING     = 11'b00000000100;
   parameter FSM_RUN_WAIT     = 11'b00000001000;
   parameter FSM_RUN_DOING    = 11'b00000010000;
   parameter FSM_CONS_WAIT    = 11'b00000100000;
   parameter FSM_CONS_DOING   = 11'b00001000000;

   parameter FSM_CONS_WAIT2   = 11'b00010000000;
   parameter FSM_RUN_WAIT2    = 11'b00100000000;

   parameter FSM_CONS_READ    = 11'b01000000000;
   parameter FSM_RUN_READ     = 11'b10000000000;

   parameter state_wid_msb = 11-1;
`endif


   //=========================================================
   // Internal signal definition
   //=========================================================

   wire                rst;
   reg    [ state_wid_msb: 0]      fsm_curr  ;
   reg    [ state_wid_msb: 0]      fsm_next  ;

   //----------------------------
   //-- Rx signal
   //----------------------------
   reg  [19: 0]      r_data_sram_base_addr;
   reg  [15: 0]      r_cmd_ram_base_addr;
   reg  [ 1: 0]      r_frm_mode;
   reg  [ 1: 0]      r_frm_cmd;

   reg               r_dl_req        ;
   reg               r_dl_ack        ;
   wire              w_dl_done;

   reg      [15:0]   r_run_counter   ;                      //20161102,for count 1ms
   
   reg               r_run_req, r_run_req_d1;
   reg               r_run_ack;
   wire              w_run_done;

   reg     [12:0]    r_run_sram_base_addr;
   wire    [19:0]    w_run_sram_base_addr_20;

   reg   [1:0]       r_data_proc_mode_pre1;
   reg   [1:0]       r_data_proc_mode  ;
   
   reg  [19: 0]      r_data_proc_addr  ;
   reg   [1:0]       r_data_porc_cmd   ;

   reg               r_data_proc_dl_start_pre1;
   reg               r_data_proc_dl_start_pre2;
   reg               r_data_proc_cons_start_pre1;
   reg               r_data_proc_cons_start_pre2;
   reg               r_data_proc_run_start_pre1;
   reg               r_data_proc_run_start_pre2;

   reg               r_data_dl_proc_start  ;
   reg               r_data_cons_proc_start;
   reg               r_data_run_proc_start ;

   reg  [7: 0]       r_logic_addr;
   reg  [7: 0]       r_la_minus_8;
   reg  [19:0]       r_sram_addr;

   reg [1:0]         r_sys_mode;

   reg               r_rd_cmd_req;
   wire              w_rd_cmd_ack;

   wire [ 7: 0]      w_ram_la      ;
   wire [ 7: 0]      w_ram_mode    ;
   wire [ 7: 0]      w_ram_cmd     ;
   wire [19: 0]      w_ram_addr    ;

   reg  [ 1: 0]      r_ram_mode_decode;
   reg  [ 1: 0]      r_ram_cmd_decode;
   
   reg  [15:0]       r_run_cnt     ;                    //count for exact ms


   //********************************************************************************
   //  Global control signals: Clock and reset
   //********************************************************************************
   assign rst        = ~rst_n;

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_sys_mode <= 2'b00;
      else
         if       (im_sys_mode == 3'b100 )
             r_sys_mode <= 2'b10;
         else if  (im_sys_mode == 3'b001 )
             r_sys_mode <= 2'b01;
         else if  (im_sys_mode == 3'b010 )
             r_sys_mode <= 2'b00;
         else
             r_sys_mode <= 2'b11;
   end

   assign o_dl_done = ( r_data_proc_mode == 2'b10 )?  w_dl_done : 1'b0;
   //assign w_run_done  =  w_dl_done;

   //********************************************************************************
   //   Main FSM
   //********************************************************************************

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
        fsm_curr <= FSM_IDLE;
      else
        fsm_curr <= fsm_next;
   end

   always @ ( * )
   begin

       o_SRAM_0_REQ_BUSY = 1'b0;
       o_SRAM_1_REQ_BUSY = 1'b0;
       r_rd_cmd_req      = 1'b0;

       case(fsm_curr)
           FSM_IDLE:
               begin
                   if (r_sys_mode == 2'b10 & i_ram_rst_done)
                       fsm_next = FSM_DL_WAIT;
                   else if (r_sys_mode == 2'b01 & i_ram_rst_done)
                       fsm_next = FSM_CONS_WAIT;
                   else if (r_sys_mode == 2'b00 & i_ram_rst_done & i_load_finish)
                       fsm_next = FSM_RUN_WAIT;
                   else
                       fsm_next = FSM_IDLE;
               end
           FSM_DL_WAIT:
               begin
                   if (r_sys_mode != 2'b10)
                       fsm_next = FSM_IDLE;
                   else if (r_dl_req == 1'b1 )
                       fsm_next = FSM_DL_DOING;
                   else
                       fsm_next = FSM_DL_WAIT;
                end
           FSM_CONS_WAIT:
               begin
                   if (r_sys_mode != 2'b01)
                       fsm_next = FSM_IDLE ;
                   else if (r_dl_req == 1'b1 )
                   begin
                       fsm_next = FSM_CONS_WAIT2;
                       o_SRAM_0_REQ_BUSY = 1'b1;
                       o_SRAM_1_REQ_BUSY = 1'b1;
                   end
                   else
                       fsm_next = FSM_CONS_WAIT;
                end

           FSM_CONS_WAIT2:
               begin

                   o_SRAM_0_REQ_BUSY = 1'b1;
                   o_SRAM_1_REQ_BUSY = 1'b1;

                   if ( (r_dl_req == 1'b1) && (i_SRAM_0_BUSY==1'b0)&&(i_SRAM_1_BUSY==1'b0) )
                       fsm_next = FSM_CONS_DOING;
                   else if  (r_dl_req == 1'b0 || r_sys_mode != 2'b01)
                       fsm_next = FSM_CONS_WAIT;
                   else
                       fsm_next = FSM_CONS_WAIT2;
                end
//           FSM_CONS_READ:
//               begin
//
//                   o_SRAM_0_REQ_BUSY = 1'b1;
//                   o_SRAM_1_REQ_BUSY = 1'b1;
//
//                   r_rd_cmd_req      = 1'b1;
//
//                   if  (w_rd_cmd_ack == 1'b1)
//                       fsm_next = FSM_CONS_DOING;
//                   else
//                       fsm_next = FSM_CONS_READ;
//                end
           FSM_RUN_WAIT:
               begin

                   if (r_sys_mode != 2'b00)
                       fsm_next = FSM_IDLE;
                   else if  (r_run_req == 1'b1 )
                   begin
                       fsm_next = FSM_RUN_WAIT2;
                       o_SRAM_0_REQ_BUSY = 1'b1;
                       o_SRAM_1_REQ_BUSY = 1'b1;
                   end
                   else
                       fsm_next = FSM_RUN_WAIT;
               end

           FSM_RUN_WAIT2:
               begin

                   o_SRAM_0_REQ_BUSY = 1'b1;
                   o_SRAM_1_REQ_BUSY = 1'b1;

                   if (r_run_req == 1'b1 && i_SRAM_1_BUSY==1'b0 )
                       fsm_next = FSM_RUN_READ;
                   else if (r_run_req == 1'b0 || r_sys_mode != 2'b00)
                       fsm_next = FSM_RUN_WAIT;
                   else
                       fsm_next = FSM_RUN_WAIT2;
               end

           FSM_RUN_READ:
               begin

                   o_SRAM_0_REQ_BUSY = 1'b1;
                   o_SRAM_1_REQ_BUSY = 1'b1;

                   r_rd_cmd_req      = 1'b1;

                   if  (w_rd_cmd_ack == 1'b1 )
                   begin
                      //if (r_ram_mode_decode == 2'b00 && (r_ram_cmd_decode == 2'b01 || r_ram_cmd_decode == 2'b10) )  
                      if   (r_ram_cmd_decode == 2'b01)         // do not care the Mode from the frame. || r_ram_cmd_decode == 2'b10
                           fsm_next = FSM_RUN_DOING;
                      else
                           fsm_next = FSM_RUN_WAIT;  
                   end
                   else
                       fsm_next = FSM_RUN_READ;
                end

           FSM_DL_DOING:
               begin
                   if (w_dl_done == 1'b1)
                       fsm_next = FSM_DL_WAIT;
                   else
                       fsm_next = FSM_DL_DOING;
               end
           FSM_CONS_DOING:
               begin
                   o_SRAM_0_REQ_BUSY = 1'b1;
                   o_SRAM_1_REQ_BUSY = 1'b1;

                   if (w_dl_done == 1'b1)
                       fsm_next = FSM_CONS_WAIT;
                   else
                       fsm_next = FSM_CONS_DOING;
               end
           FSM_RUN_DOING:
               begin
                   o_SRAM_0_REQ_BUSY = 1'b1;
                   o_SRAM_1_REQ_BUSY = 1'b1;

                   if (w_run_done == 1'b1)
                       fsm_next = FSM_RUN_WAIT;
                   else
                       fsm_next = FSM_RUN_DOING;
               end
           default:
               fsm_next = FSM_IDLE;
       endcase
   end


   //------------------------------------------
   //--  "Mode" follow system parameter 
   //------------------------------------------
   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
           r_data_proc_mode_pre1 <= 2'b0;
       else
          if    ( fsm_curr == FSM_DL_DOING )
              r_data_proc_mode_pre1 <= 2'b10;
          else if   ( fsm_curr == FSM_CONS_DOING )
              r_data_proc_mode_pre1 <= 2'b01;
          else if   ( fsm_curr == FSM_RUN_DOING )
              r_data_proc_mode_pre1 <= 2'b00;
   end


   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_data_proc_dl_start_pre1 <= 1'b0;
      else
         if       (fsm_curr == FSM_DL_WAIT && fsm_next == FSM_DL_DOING)
             r_data_proc_dl_start_pre1 <= 1'b1;
         else
             r_data_proc_dl_start_pre1 <= 1'b0;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_data_proc_cons_start_pre1 <= 1'b0;
      else
         if        (fsm_curr == FSM_CONS_WAIT2   &&  fsm_next == FSM_CONS_DOING )
             r_data_proc_cons_start_pre1 <= 1'b1;
         else
             r_data_proc_cons_start_pre1 <= 1'b0;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_data_proc_run_start_pre1 <= 1'b0;
      else
         if    (fsm_curr == FSM_RUN_READ   &&  fsm_next == FSM_RUN_DOING )
             r_data_proc_run_start_pre1 <= 1'b1;
         else
             r_data_proc_run_start_pre1 <= 1'b0;
   end



   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
         r_data_proc_dl_start_pre2   <= 1'b0;
         r_data_proc_cons_start_pre2 <= 1'b0;
         r_data_proc_run_start_pre2  <= 1'b0;
      end
      else
      begin
         r_data_proc_dl_start_pre2    <= r_data_proc_dl_start_pre1;
         r_data_proc_cons_start_pre2  <= r_data_proc_cons_start_pre1;
         r_data_proc_run_start_pre2   <= r_data_proc_run_start_pre1;
      end
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
         r_data_dl_proc_start      <= 1'b0;
         r_data_cons_proc_start    <= 1'b0;
         r_data_run_proc_start     <= 1'b0;
      end
      else
      begin
         r_data_dl_proc_start      <= r_data_proc_dl_start_pre2;
         r_data_cons_proc_start    <= r_data_proc_cons_start_pre2;
         r_data_run_proc_start     <= r_data_proc_run_start_pre2;

      end
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
         r_data_proc_mode   <= 1'b0;
         r_data_porc_cmd    <= 1'b0;
         r_data_proc_addr   <= 1'b0;
      end
      else
      begin
         if ( r_data_proc_dl_start_pre2 == 1'b1 || r_data_proc_cons_start_pre2 == 1'b1  )
         begin
             r_data_proc_addr       <= r_data_sram_base_addr;
             r_data_porc_cmd        <= r_frm_cmd;
             r_data_proc_mode       <= r_data_proc_mode_pre1;
         end
         else if ( r_data_proc_run_start_pre2 == 1'b1  )
         begin
             //r_data_proc_addr       <= w_ram_addr;
             r_data_proc_addr       <= w_run_sram_base_addr_20;

             r_data_porc_cmd        <= r_ram_cmd_decode;
             //r_data_proc_mode       <= r_ram_mode_decode;             //////////////////////////////
             r_data_proc_mode       <= r_data_proc_mode_pre1;
         end
      end
   end

   //=========================================================
   //   download control
   //=========================================================
   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_dl_req <= 1'b0;
      else
         if    ((i_rx_done == 1'b1  && i_rx_err == 1'b1  ) && (r_sys_mode == 2'b10 || r_sys_mode == 2'b01 ) && (r_frm_mode == r_sys_mode) && (i_tx_busy == 1'b0) && i_rx_match == 1'b1   )       //  (i_rx_done == 1'b1  && i_rx_err == 1'b0  )
             r_dl_req <= 1'b1;
         else if  (r_dl_ack == 1'b1 || i_rx_new_arrival == 1'b1 )
             r_dl_req <= 1'b0;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_dl_ack <= 1'b0;
      else
         if       ( r_data_proc_dl_start_pre1 == 1'b1 || r_data_proc_cons_start_pre1 == 1'b1  )
             r_dl_ack <= 1'b1;
         else
             r_dl_ack <= 1'b0;
   end

   //=========================================================
   //   run control
   //=========================================================
   //assign w_req_pulse = r_run_req && r_run_req_d1;

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_run_counter <= 16'b0;
      else
         if       (r_run_counter == TIMER_RUN_CYCLE  )
             r_run_counter <= 16'b0;
         //else if ( fsm_curr != FSM_RUN_DOING && i_tx_busy == 1'b0 )
         //else if ( fsm_curr == FSM_RUN_WAIT && i_tx_busy == 1'b0 )
         else if ( fsm_curr == FSM_RUN_WAIT  )
             r_run_counter <= r_run_counter +  1;
   end
   
   
   always@(posedge clk_50m or negedge rst_n)
     begin
       if ( rst_n == 1'b0 )
          r_run_cnt <= 16'd0               ;
       else if((fsm_curr  == FSM_RUN_READ)&&(w_rd_cmd_ack == 1'b1)&&(r_ram_cmd_decode != 2'b01)) //added 17.06.11
         r_run_cnt <= im_scan_cycle        ;                              // added 17.06.11           
       else if((r_run_counter == TIMER_RUN_CYCLE)&&(r_run_cnt<im_scan_cycle))
          r_run_cnt <= r_run_cnt + 1'b1    ;
       else if(r_run_cnt == im_scan_cycle)
          r_run_cnt <= 16'd0               ;
     end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_run_req <= 1'b0;
      else
         if ( fsm_curr == FSM_RUN_WAIT || fsm_curr == FSM_RUN_WAIT2)
         begin
            if       (r_run_cnt == im_scan_cycle &&  i_tx_busy == 1'b0 )
                r_run_req <= 1'b1;
            else if ( r_run_ack  == 1'b1 )
                r_run_req <= 1'b0;
         end
         else
         begin
              r_run_req <= 1'b0;
         end
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_run_req_d1 <= 1'b0;
      else
         r_run_req_d1 <= r_run_req;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_run_ack <= 1'b0;
      else
         if       ( r_data_proc_run_start_pre1 == 1'b1  )
             r_run_ack <= 1'b1;
         else
             r_run_ack <= 1'b0;
   end


   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_run_sram_base_addr <= 13'b0;
      else
         //if    (w_run_done == 1'b1 )
         if    (w_rd_cmd_ack == 1'b1 )
             r_run_sram_base_addr <= r_run_sram_base_addr +  1;
   end

   assign   w_run_sram_base_addr_20 = {r_run_sram_base_addr, 7'b0 } ;



   //=========================================================
   // generate addrss
   // purify mode, cmd
   //=========================================================

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_logic_addr <= 8'b0;
      else
         if ( fsm_curr == FSM_RUN_DOING || fsm_curr == FSM_RUN_READ )
             r_logic_addr <= w_ram_la;
         else
             r_logic_addr <= im_rx_app_la;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_sram_addr <= 8'b0;
      else
         if ( fsm_curr == FSM_RUN_DOING || fsm_curr == FSM_RUN_READ )
             r_sram_addr <= w_ram_addr;
         else
             r_sram_addr <= im_rx_app_addr[19:0];
   end


   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_la_minus_8 <= 8'b0;
      else
         r_la_minus_8 <= r_logic_addr - 8 ;
   end

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_data_sram_base_addr <= 20'b0;
      else
         if (i_rx_done == 1'b1 )
         begin
               case(r_logic_addr)
                 8'hFE:
                     r_data_sram_base_addr <= r_sram_addr;
                 8'h00:
                     r_data_sram_base_addr <= HEX_4k +  r_sram_addr;
                 8'h01:
                     r_data_sram_base_addr <= HEX_4k + HEX_32k                                                  + r_sram_addr;
                 8'h02:
                     r_data_sram_base_addr <= HEX_4k + HEX_64k                                                  + r_sram_addr;
                 8'h03:
                     r_data_sram_base_addr <= HEX_4k + HEX_64k + HEX_8k                                         + r_sram_addr;
                 8'h04:
                     r_data_sram_base_addr <= HEX_4k + HEX_64k + HEX_16k                                        + r_sram_addr;
                 8'h05:
                     r_data_sram_base_addr <= HEX_4k + HEX_64k + HEX_24k                                        + r_sram_addr;
                 8'h06:
                     r_data_sram_base_addr <= HEX_4k + HEX_64k + HEX_32k                                        + r_sram_addr;
                 8'h07:
                     r_data_sram_base_addr <= HEX_4k + HEX_64k + HEX_32k + HEX_32k                              + r_sram_addr;
                 default:
                     r_data_sram_base_addr <= HEX_4k + HEX_64k + HEX_32k + HEX_64k + {r_la_minus_8[6:0], 13'b0} + r_sram_addr;
               endcase
        end
   end


   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_frm_mode <= 2'b0;
      else
         //if (i_rx_done == 1'b1 )
         begin
             if       (im_rx_app_mode == 8'h00 )
                 r_frm_mode <= 2'b00;
             else if  (im_rx_app_mode == 8'h01 )
                 r_frm_mode <= 2'b01;
             else if  (im_rx_app_mode == 8'h02 )
                 r_frm_mode <= 2'b10;
         end
   end


   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_frm_cmd <= 2'b0;
      else
         if (i_rx_done == 1'b1 )
         begin
           if       (im_rx_app_cmd == 8'h01 )
               r_frm_cmd <= 2'b01;
           else if  (im_rx_app_cmd == 8'h02 )
               r_frm_cmd <= 2'b10;
           else if  (im_rx_app_cmd == 8'h00 )
               r_frm_cmd <= 2'b00;
         end
   end

   //=========================================================
   // Run mode, fame parameter
   //=========================================================

   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_ram_mode_decode <= 2'b00;
      else
         if       (w_ram_mode == 8'h02 )
             r_ram_mode_decode <= 2'b10;
         else if  (w_ram_mode == 8'h01 )
             r_ram_mode_decode <= 2'b01;
         else if  (w_ram_mode == 8'h00 )
             r_ram_mode_decode <= 2'b00;
         else
             r_ram_mode_decode <= 2'b11;
   end


   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         r_ram_cmd_decode <= 2'b00;
      else
         if       (w_ram_cmd == 8'h01 )
             r_ram_cmd_decode <= 2'b01;
         else if  (w_ram_cmd == 8'h02 )
             r_ram_cmd_decode <= 2'b10;
         else
             r_ram_cmd_decode <= 2'b00;
   end

   //********************************************************************************
   //   Main FSM
   //********************************************************************************

   M_NET_APP_DATA u1_M_NET_APP_DATA(
    //------------------------------------------
    //--  Global Reset, active low
    //--  Clock: 50MHz
    //------------------------------------------
    .rst_n             (rst_n  ),
    .clk_50m           (clk_50m),
    .im_station_id     (im_station_id),
    //------------------------------------------
    //-- Link layer interface
    //------------------------------------------
    //-- Tx
    .o_tx_ram_wen      (o_tx_ram_wen   ),
    .om_tx_ram_waddr   (om_tx_ram_waddr),
    .om_tx_ram_wd      (om_tx_ram_wd   ),
    .o_tx_start        (o_tx_start     ),

    .om_tx_frm_len     (om_tx_frm_len  ),
    .om_smac           (om_smac        ),
    .om_dmac           (om_dmac        ),
    .i_tx_busy         (i_tx_busy      ),

    //-- Rx
    .o_rx_ram_ren      (o_rx_ram_ren   ),
    .om_rx_ram_raddr   (om_rx_ram_raddr),

    .im_rx_ram_rd      (im_rx_ram_rd   ),
    .i_rx_done         (i_rx_done      ),
    .i_rx_err          (i_rx_err       ),
    .im_rx_frm_len     (im_rx_frm_len  ),
    .im_rx_PC_smac     (im_rx_PC_smac  ),
    .i_rx_match        (i_rx_match     ),

    //------------------------------------------
    //-- Memory interface
    //------------------------------------------

    //------------------------------
    //--  Transmit download  RAM,
    //--  Uplink, 2K Bytes
    //------------------------------
    .o_tdub_rden       (o_tdub_rden  ),
    .om_tdub_raddr     (om_tdub_raddr),
    .im_tdub_rdata     (im_tdub_rdata),
    //------------------------------
    //--  Transmit download  RAM
    //--  Downink, 2K Bytes
    //------------------------------
    .o_tddb_wren       (o_tddb_wren  ),
    .om_tddb_waddr     (om_tddb_waddr),
    .om_tddb_wdata     (om_tddb_wdata),

    //------------------------------
    //-- SRAM Interface
    //------------------------------
    .o_SRAM_0_RD_n     (o_SRAM_0_RD_n ),
    .o_SRAM_0_WE_n     (o_SRAM_0_WE_n ),
    .om_SRAM_0_A       (om_SRAM_0_A   ),
    .im_SRAM_0_D_RD    (im_SRAM_0_D_RD),
    .om_SRAM_0_D_WE    (om_SRAM_0_D_WE),
    .i_SRAM_0_ERR      (i_SRAM_0_ERR  ),

    .o_SRAM_1_RD_n     (o_SRAM_1_RD_n ),
    .o_SRAM_1_WE_n     (o_SRAM_1_WE_n ),
    .om_SRAM_1_A       (om_SRAM_1_A   ),
    .im_SRAM_1_D_RD    (im_SRAM_1_D_RD),
    .om_SRAM_1_D_WE    (om_SRAM_1_D_WE),
    .i_SRAM_1_ERR      (i_SRAM_1_ERR  ),

    //------------------------------
    //--  Transmit console up cmd RAM
    //--  Uplink, 36K Bytes
    //------------------------------
    .o_tcucb_rden      (o_tcucb_rden  ),
    .om_tcucb_raddr    (om_tcucb_raddr),
    .im_tcucb_rdata    (im_tcucb_rdata),
    //------------------------------
    //--  Transmit console up cmd RAM
    //--  Downink, 36K Bytes
    //------------------------------
    .o_tcdcb_wren      (o_tcdcb_wren  ),
    .om_tcdcb_waddr    (om_tcdcb_waddr),
    .om_tcdcb_wdata    (om_tcdcb_wdata),

    //------------------------------
    //-- Control signals
    //------------------------------
    .im_data_proc_addr     (r_data_proc_addr),
    .im_data_porc_cmd      (r_data_porc_cmd ),
    .im_data_proc_mode     (r_data_proc_mode),

    .i_data_dl_proc_start   (r_data_dl_proc_start  ),
    .i_data_cons_proc_start (r_data_cons_proc_start),
    .i_data_run_proc_start  (r_data_run_proc_start ),

    .o_dl_done              (w_dl_done),
    .o_run_done             (w_run_done),

    .i_rd_cmd_req           (r_rd_cmd_req),
    .i_rd_cmd_base_addr     (w_run_sram_base_addr_20),
    .o_rd_cmd_ack           (w_rd_cmd_ack),

    .om_ram_la               (w_ram_la  ),
    .om_ram_mode             (w_ram_mode),
    .om_ram_cmd              (w_ram_cmd ),
    .om_ram_addr             (w_ram_addr)
    );





endmodule
