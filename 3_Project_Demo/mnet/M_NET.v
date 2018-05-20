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
// Name of module : mn811_led
// Project        : NicSys8000
// Func           : led_blink_2hz
// Author         : Liu zhikai
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FG484
// version 1.0    : made in Date: 2015.12.01
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/04/12   Initial version(Liu Zhikai)
//
//
//
////////////////////////////////////////////////////////////////////////////////



`timescale 1ns / 100ps

module M_NET(
    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input                rst_n           ,

    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input                clk_50m         ,

    //------------------------------------------
    //-- Ethernet, RMII interface
    //------------------------------------------
    input       [1:0]    ETH2_RXD         ,
    input                ETH2_RXDV        ,
    input                ETH2_RXER        ,
    input                ETH2_INTRP       ,
    inout                ETH2_MDIO        ,
    output               ETH2_TXEN        ,
    output     [1:0]     ETH2_TXD         ,
    output               ETH2_RST_n       ,
    //-- REFCLK, Output for PFPGA, input for
    output               ETH2_REFCLK      ,
    input                ETH2_LEDG        ,
    input                ETH2_LEDY        ,
    output  reg   [1:0]  ETH2_COM_LED     ,
    //------------------------------------------
    //-- Ethernet, RMII interface
    //------------------------------------------
    input       [1:0]    ETH1_RXD         ,
    input                ETH1_RXDV        ,
    input                ETH1_RXER        ,
    input                ETH1_INTRP       ,
    inout                ETH1_MDIO        ,
    output               ETH1_TXEN        ,
    output     [1:0]     ETH1_TXD         ,
    output               ETH1_RST_n       ,
    //-- REFCLK, Output for PFPGA, input for
    output               ETH1_REFCLK      ,
    input                ETH1_LEDG        ,
    input                ETH1_LEDY        ,
    output   reg  [1:0]  ETH1_COM_LED     ,


    //------------------------------------------
    //-- system control signals
    //------------------------------------------
    input   wire[2:0]         im_sys_mode       ,
    input   wire[6:0]         im_station_id     ,

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
    output  wire             o_SRAM_0_REQ_BUSY    ,

    output  wire             o_SRAM_1_RD_n        ,
    output  wire             o_SRAM_1_WE_n        ,
    output  wire [19: 0]     om_SRAM_1_A          ,
    input   wire[15: 0]      im_SRAM_1_D_RD       ,
    output  wire [15: 0]     om_SRAM_1_D_WE       ,
    input   wire             i_SRAM_1_ERR         ,
    input   wire             i_SRAM_1_BUSY        ,
    output  wire             o_SRAM_1_REQ_BUSY    ,


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
   // Local parameters
   //=========================================================
   parameter DLY           = 1;
   parameter LED_DEALY_1s  = 26'd50000000;  
   parameter RUN_ACT   = 2'b00;
   parameter RUN_OFF   = 2'b01;
   parameter RUN_BLINK = 2'b10;
   parameter RUN_REV   = 2'b11;
   //=========================================================
   // Internal signal definition
   //=========================================================
   wire      [7:0]      RMII2_Tx_D   ;
   wire                 RMII2_Tx_DV  ;
   wire      [7:0]      RMII2_Rx_D   ;
   wire                 RMII2_Rx_DV  ;

   wire                 RMII2_Rx_Start;
   wire                 RMII2_Rx_End;

   wire      [7:0]      RMII1_Tx_D   ;
   wire                 RMII1_Tx_DV  ;
   wire      [7:0]      RMII1_Rx_D   ;
   wire                 RMII1_Rx_DV  ;

   wire                 RMII1_Rx_Start;
   wire                 RMII1_Rx_End;

   wire      [7:0]      RMII_Tx_D   ;
   wire                 RMII_Tx_DV  ;
   wire      [7:0]      RMII_Rx_D   ;
   wire                 RMII_Rx_DV  ;

   wire                 RMII_Rx_Start;
   wire                 RMII_Rx_End;

   wire           w_tx_ram_wen    ;
   wire[10: 0]    w_tx_ram_waddr  ;
   wire[ 7: 0]    w_tx_ram_wd     ;
   wire           w_tx_start      ;

   wire[10: 0]    w_tx_frm_len    ;
   wire[47: 0]    w_smac          ;
   wire[47: 0]    w_dmac          ;
   wire           w_tx_busy       ;

   //-- Rx
   wire           w_rx_ram_ren    ;
   wire[10: 0]    w_rx_ram_raddr  ;

   wire[ 7:0 ]    w_rx_ram_rd      ;
   wire           w_rx_new_arrival ;
   wire           w_rx_done        ;
   wire           w_rx_err         ;
   wire [10: 0]   w_rx_frm_len     ;
   wire [47: 0]   w_rx_PC_smac     ;
   wire           w_rx_match       ;

   wire[ 7: 0]    w_rx_app_la      ;
   wire[ 7: 0]    w_rx_app_mode    ;
   wire[ 7: 0]    w_rx_app_cmd     ;
   wire[23: 0]    w_rx_app_addr    ;
   reg [25:0]     cnt1              ;
   reg            led_off1          ;  
   reg [25:0]     cnt2              ; 
   reg            led_off2          ; 

   //=========================================================
   //
   //=========================================================
   assign ETH2_REFCLK = clk_50m;
   assign ETH2_RST_n  = rst_n;

   assign ETH1_REFCLK = clk_50m;
   assign ETH1_RST_n  = rst_n;

   assign LOCAL_MAC_ADDR =  {40'b1, 1'b0, im_station_id} ;

   
   always @ (posedge clk_50m or negedge rst_n)
   begin
     if(!rst_n)
         cnt1<=LED_DEALY_1s;
       else if(ETH1_TXEN)
         cnt1<=26'd0;
       else if(cnt1 < LED_DEALY_1s)
         cnt1<=cnt1+1'b1;
   end
   
   always @ (posedge clk_50m or negedge rst_n)
   begin
     if(!rst_n)
         cnt2<=LED_DEALY_1s;
       else if(ETH2_TXEN)
         cnt2<=26'd0;
       else if(cnt2 < LED_DEALY_1s)
         cnt2<=cnt2+1'b1;
   end
   
   always @ (posedge clk_50m or negedge rst_n)
   begin
     if(!rst_n)
         ETH1_COM_LED <= RUN_OFF;
       else if(cnt1 == LED_DEALY_1s)
         ETH1_COM_LED <= RUN_OFF;
       else
         ETH1_COM_LED <= RUN_BLINK;
   end
   
      always @ (posedge clk_50m or negedge rst_n)
   begin
     if(!rst_n)
         ETH2_COM_LED <= RUN_OFF;
       else if(cnt2 == LED_DEALY_1s)
         ETH2_COM_LED <= RUN_OFF;
       else
         ETH2_COM_LED <= RUN_BLINK;
   end
   //=========================================================
   //
   //=========================================================
   M_NET_RMII u1_M_NET_RMII_inst(
    //------------------------------------------
    //--  clock,  reset(active low)
    //------------------------------------------
    .clk       (ETH2_REFCLK),
    .rst_n     (rst_n),
    //------------------------------------------
    //-- phy side
    //------------------------------------------
    .rx_en_p     (ETH2_RXDV),
    .rxd_p       (ETH2_RXD),
    .tx_en_p     (ETH2_TXEN),
    .txd_p       (ETH2_TXD),
    //------------------------------------------
    //-- system side
    //------------------------------------------
    //-- Send: 8bits data and send each 4 clock cycles
    .tx_data_en    (RMII2_Tx_DV   ), // RMII_Tx_DV
    .tx_data       (RMII2_Tx_D    ), // RMII_Tx_D
    .rx_start      (RMII2_Rx_Start),
    .rx_end        (RMII2_Rx_End  ),
    .rx_data_en_p  (RMII2_Rx_DV   ),
    .rx_data_p     (RMII2_Rx_D    )
    );

   M_NET_RMII u2_M_NET_RMII_inst(
    //------------------------------------------
    //--  clock,  reset(active low)
    //------------------------------------------
    .clk       (ETH1_REFCLK),
    .rst_n     (rst_n),
    //------------------------------------------
    //-- phy side
    //------------------------------------------
    .rx_en_p     (ETH1_RXDV),
    .rxd_p       (ETH1_RXD),
    .tx_en_p     (ETH1_TXEN),
    .txd_p       (ETH1_TXD),
    //------------------------------------------
    //-- system side
    //------------------------------------------
    //-- Send: 8bits data and send each 4 clock cycles
    .tx_data_en    (RMII1_Tx_DV   ), //RMII_Tx_DV
    .tx_data       (RMII1_Tx_D    ), //RMII_Tx_D
    .rx_start      (RMII1_Rx_Start),
    .rx_end        (RMII1_Rx_End  ),
    .rx_data_en_p  (RMII1_Rx_DV   ),
    .rx_data_p     (RMII1_Rx_D    )
    );


   M_NET_MUX u1_M_NET_MUX(

   .sys_clk               (clk_50m           ),
   .rst_n                 (rst_n             ),
   .im_mode_reg           (im_sys_mode       ),

   .i_rx_start_1          (RMII1_Rx_Start    ),
   .i_rx_end_1            (RMII1_Rx_End      ),
   .i_rx_data_en_p_1      (RMII1_Rx_DV       ),
   .im_rx_data_p_1        (RMII1_Rx_D        ),

   .i_rx_start_2          (RMII2_Rx_Start    ),
   .i_rx_end_2            (RMII2_Rx_End      ),
   .i_rx_data_en_p_2      (RMII2_Rx_DV       ),
   .im_rx_data_p_2        (RMII2_Rx_D        ),

   .o_rx_start            (RMII_Rx_Start     ),
   .o_rx_end              (RMII_Rx_End       ),
   .om_rx_data_p          (RMII_Rx_D         ),
   .o_rx_data_en_p        (RMII_Rx_DV        ),
   
   .im_tx_data            (RMII_Tx_D         ),
   .i_tx_data_en          (RMII_Tx_DV        ),
   .i_tx_busy             (w_tx_busy         ),

   .o_tx_data_en_1        (RMII1_Tx_DV       ),
   .om_tx_data_1          (RMII1_Tx_D        ),
   .o_tx_data_en_2        (RMII2_Tx_DV       ),
   .om_tx_data_2          (RMII2_Tx_D        )

   );

   M_NET_Link_2 u1_M_NET_Link(
    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    .rst_n              (rst_n)      ,
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    .clk_50m            (clk_50m )     ,

    //------------------------------------------
    //-- Application interface
    //------------------------------------------
    //-- Tx
    .i_tx_ram_wen       (w_tx_ram_wen     ),
    .im_tx_ram_waddr    (w_tx_ram_waddr   ),
    .im_tx_ram_wd       (w_tx_ram_wd      ),
    .i_tx_start         (w_tx_start       ),
    .im_tx_frm_len      (w_tx_frm_len     ),
    .im_smac            (w_smac),
    .im_dmac            (w_dmac),
    .o_tx_busy          (w_tx_busy  ),

    //-- Rx
    .i_rx_ram_ren       (w_rx_ram_ren   ),
    .im_rx_ram_raddr    (w_rx_ram_raddr),
    .om_rx_ram_rd       (w_rx_ram_rd   ),
    .o_rx_new_arrival   (w_rx_new_arrival),
    .o_rx_done          (w_rx_done      ),
    .o_rx_err           (w_rx_err       ),
    .om_rx_frm_len      (w_rx_frm_len  ),
    .om_rx_PC_smac      (w_rx_PC_smac),
    .o_rx_match         (w_rx_match),

    .om_rx_app_la       (w_rx_app_la  ),
    .om_rx_app_mode     (w_rx_app_mode),
    .om_rx_app_cmd      (w_rx_app_cmd ),
    .om_rx_app_addr     (w_rx_app_addr),

    //------------------------------------------
    //-- RMII Module
    //------------------------------------------
    //-- Send: 8bits data and send each 4 clock cycles
    .o_tx_dv            (RMII_Tx_DV),
    .om_tx_d            (RMII_Tx_D ),

    //-- receive:
    .i_rx_start         (RMII_Rx_Start),
    .i_rx_end           (RMII_Rx_End),
    .i_rx_dv            (RMII_Rx_DV),
    .im_rx_d            (RMII_Rx_D )
    );





   M_NET_APP_2 u1_M_NET_APP_2(
    //------------------------------------------
    //--  Global Reset, active low
    //--  Clock: 50MHz
    //------------------------------------------
    .rst_n             (rst_n  ),
    .clk_50m           (clk_50m),

    //-----------------------------------------------------------
    //-- Station ID, Rack ID, Slot ID
    //-----------------------------------------------------------
    .im_sys_mode       (im_sys_mode  ),
    .im_station_id     (im_station_id),

    //------------------------------------------
    //-- Link layer interface
    //------------------------------------------
    //-- Tx
    .o_tx_ram_wen      (w_tx_ram_wen   ),
    .om_tx_ram_waddr   (w_tx_ram_waddr),
    .om_tx_ram_wd      (w_tx_ram_wd   ),
    .o_tx_start        (w_tx_start     ),

    .om_tx_frm_len     (w_tx_frm_len  ),
    .om_smac           (w_smac        ),
    .om_dmac           (w_dmac        ),
    .i_tx_busy         (w_tx_busy      ),

    //-- Rx
    .o_rx_ram_ren      (w_rx_ram_ren   ),
    .om_rx_ram_raddr   (w_rx_ram_raddr),

    .im_rx_ram_rd      (w_rx_ram_rd   ),
    .i_rx_new_arrival  (w_rx_new_arrival),
    .i_rx_done         (w_rx_done      ),
    .i_rx_err          (w_rx_err       ),
    .im_rx_frm_len     (w_rx_frm_len   ),
    .im_rx_PC_smac     (w_rx_PC_smac   ),
    .i_rx_match        (w_rx_match     ),

    .im_rx_app_la      (w_rx_app_la    ),
    .im_rx_app_mode    (w_rx_app_mode  ),
    .im_rx_app_cmd     (w_rx_app_cmd   ),
    .im_rx_app_addr    (w_rx_app_addr  ),

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
    .o_dl_done         (o_dl_done    ),


    //------------------------------
    //-- SRAM Interface
    //------------------------------
    .o_SRAM_0_RD_n     (o_SRAM_0_RD_n ),
    .o_SRAM_0_WE_n     (o_SRAM_0_WE_n ),
    .om_SRAM_0_A       (om_SRAM_0_A   ),
    .im_SRAM_0_D_RD    (im_SRAM_0_D_RD),
    .om_SRAM_0_D_WE    (om_SRAM_0_D_WE),
    .i_SRAM_0_ERR      (i_SRAM_0_ERR  ),
    .i_SRAM_0_BUSY     (i_SRAM_0_BUSY    ),
    .o_SRAM_0_REQ_BUSY (o_SRAM_0_REQ_BUSY),

    .o_SRAM_1_RD_n     (o_SRAM_1_RD_n ),
    .o_SRAM_1_WE_n     (o_SRAM_1_WE_n ),
    .om_SRAM_1_A       (om_SRAM_1_A   ),
    .im_SRAM_1_D_RD    (im_SRAM_1_D_RD),
    .om_SRAM_1_D_WE    (om_SRAM_1_D_WE),
    .i_SRAM_1_ERR      (i_SRAM_1_ERR  ),
    .i_SRAM_1_BUSY     (i_SRAM_1_BUSY    ),
    .o_SRAM_1_REQ_BUSY (o_SRAM_1_REQ_BUSY),

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
    .i_ram_rst_done    (i_ram_rst_done),
    .im_scan_cycle     (im_scan_cycle ),
    .i_load_finish     (i_load_finish )

    );

endmodule