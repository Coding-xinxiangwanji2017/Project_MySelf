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
// Name of module : DO811_UT4_B01
// Project        : NicSys8000
// Func           : DO811 PFPGA Top 
// Author         : Zhang Xueyan
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FGG484
// version 1.0    : made in Date: 2015.12.01
// Modification Logs:
// _____________________________________________________________________________
//   Version   Date         Description(Recorder)
// _____________________________________________________________________________
//     1.0   2016/04/12   Initial version(Tan Xingye)
//                                       
//
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/10ps

module DO811_UT4_B01(   

     //-----------------------------------------------------------  
     //-- Global reset, clocks                                      
     //----------------------------------------------------------- 
     
        
     input  wire             FP_RSTA              , //negedge rst                     
                                                                   
     input  wire             CLK_25MP1            ,                      
     input  wire             CLK50MP1             ,    
     
     //----------------------------------------------------------- 
     //-- Power Detector                                           
     //-----------------------------------------------------------                   
                                                           
     input  wire             FPWR_DPG             , //0 is valid    
     
     //-----------------------------------------------------------                  
     //-- Watchdog                                                                                                       
     //-----------------------------------------------------------    
                                                            
     output wire             FP_WDIA              ,                      
     input  wire             FP_WDOA              ,                      
     //input  wire           FD_WDOB              ,        
     
     //-----------------------------------------------------------
     //--  Rack ID, Slot ID                            
     //-----------------------------------------------------------
                   
     input  wire     [04:00] FDP_SLOT             ,                      
     input  wire     [03:00] FDP_RACK             ,             
     
     //-----------------------------------------------------------  
     //-- Plug monitor, active low                                  
     //-----------------------------------------------------------           
                                                           
                                                           
     input  wire             PLUG_MON             ,//1 is not plug, 0 is plug ok   
     
     //-----------------------------------------------------------   
     //-- LED indicator                                              
     //-----------------------------------------------------------   
                                                                         
     output wire             FP_LED6              , //COM            
     output wire             FP_LED3              , //RUN                
     output wire             FP_LED4              , //WARNING YELLOW     
     output wire             FP_ERR_LED           , //ERR RED            
     output wire		     FP_LED_CHANNEL_01    , 
     output wire		     FP_LED_CHANNEL_02    , 
     output wire		     FP_LED_CHANNEL_03    , 
     output wire		     FP_LED_CHANNEL_04    , 
     output wire		     FP_LED_CHANNEL_05    , 
     output wire		     FP_LED_CHANNEL_06    , 
     output wire		     FP_LED_CHANNEL_07    , 
     output wire		     FP_LED_CHANNEL_08    , 
     output wire		     FP_LED_CHANNEL_09    , 
     output wire		     FP_LED_CHANNEL_10    ,  
     output wire		     FP_LED_CHANNEL_11    , 
     output wire		     FP_LED_CHANNEL_12    , 
     output wire		     FP_LED_CHANNEL_13    , 
     output wire		     FP_LED_CHANNEL_14    , 
     output wire		     FP_LED_CHANNEL_15    , 
     output wire		     FP_LED_CHANNEL_16    ,     
     
     //-----------------------------------------------------------     
     //-- CHannel Power enable                                              
     //-----------------------------------------------------------     
     output wire             FP_24CH_EN           , 
      
     //-----------------------------------------------------------
     //-- CHannel Read-backward                                    
     //-----------------------------------------------------------
     	                                   
     input  wire    		 FD_FEEDBACK_01       , 
     input  wire    		 FD_FEEDBACK_02       , 
     input  wire    		 FD_FEEDBACK_03       , 
     input  wire    		 FD_FEEDBACK_04       , 
     input  wire    		 FD_FEEDBACK_05       , 
     input  wire    		 FD_FEEDBACK_06       , 
     input  wire    		 FD_FEEDBACK_07       , 
     input  wire    		 FD_FEEDBACK_08       , 
     input  wire    		 FD_FEEDBACK_09       , 
     input  wire    		 FD_FEEDBACK_10       , 
     input  wire    		 FD_FEEDBACK_11       , 
     input  wire    		 FD_FEEDBACK_12       , 
     input  wire    		 FD_FEEDBACK_13       , 
     input  wire    		 FD_FEEDBACK_14       , 
     input  wire    		 FD_FEEDBACK_15       , 
     input  wire    		 FD_FEEDBACK_16       , 
     
     //----------------------------------------------------------- 
     //-- CHannel Signal output                                   
     //----------------------------------------------------------- 	                                                          		            
     output wire		     FP_CHANNEL_16        , 
     output wire		     FP_CHANNEL_15        , 
     output wire		     FP_CHANNEL_14        , 
     output wire		     FP_CHANNEL_13        , 
     output wire		     FP_CHANNEL_12        , 
     output wire		     FP_CHANNEL_11        , 
     output wire		     FP_CHANNEL_10        , 
     output wire		     FP_CHANNEL_09        , 
     output wire		     FP_CHANNEL_08        , 
     output wire		     FP_CHANNEL_07        , 
     output wire		     FP_CHANNEL_06        , 
     output wire		     FP_CHANNEL_05        , 
     output wire		     FP_CHANNEL_04        , 
     output wire		     FP_CHANNEL_03        , 
     output wire		     FP_CHANNEL_02        , 
     output wire		     FP_CHANNEL_01        ,
     
                                                                    
     //-----------------------------------------------------------  
     //-- M-BUS                                                     
     //-----------------------------------------------------------  		            
     output wire             TICL_MB_TXEN2        ,                                                                                                              		      
     input  wire             TICL_MB_RX2          ,                                                                                                              
     output wire             TICL_MB_TX2          ,                                                                                                              
     input  wire             TICL_MB_PREM         ,                                                                                                              
     output wire             TICL_MB_TXEN1        ,                                                                                                              
     input  wire             TICL_MB_RX1          ,                                                                                                              
     output wire             TICL_MB_TX1          ,   
     
     //----------------------------------------------------------- 
     //-- L-BUS                                                    
     //----------------------------------------------------------- 
                                                                                                                                                                                                                                                              
     output wire             TICL_LB_TXEN2        ,                                                                                                              
     input  wire             TICL_LB_RX2          ,                                                                                                              
     output wire             TICL_LB_TX2          ,                                                                                                              
     input  wire             TICL_LB_PREM         ,                                                                                                              
     output wire             TICL_LB_TXEN1        ,                                                                                                              
     input  wire             TICL_LB_RX1          ,                                                                                                              
     output wire             TICL_LB_TX1          ,  
     
     //----------------------------------------------------------- 
     //-- SPI interface                                            
     //-----------------------------------------------------------                                                                                                                                                                                                                                                            
     output wire             FP_E2P_SI            ,                                                                                                              
     output wire             FP_E2P_CS            ,                                                                                                              
     output wire             FP_E2P_SCK           ,                                                                                                              
     input  wire             FP_E2P_SO            ,   
     
     //-----------------------------------------------------------    
     //-- Interface with DFPGA                                        
     //-----------------------------------------------------------    
                                                                                                                
     output wire             FIO_RSTO             ,//reset dfpga                                                                                                 
     output wire             FIO_CLK              ,//clk                                                                                                         
     output wire             FIO_TICK             ,//heartbeat out                                                                                               
     input  wire             FIO_RSTIN            ,//heartbeat in                                                                                                
     output wire             FIO_WE               ,//Wren                                                                                                        
                                                                                                                                                        
     output wire     [20:00] FIO_DAT              ,//[12:0] addr; [20:13] output data                                                                            
                                                                                                                                                       
     input  wire             FIO_DAT21            ,//==[7:0] input       data                                                                                          
     input  wire             FIO_DAT22            ,//==[7:0] input       data                                                                                          
     input  wire             FIO_DAT23            ,//==[7:0] input       data                                                                                          
     input  wire     [02:00] FIO_CS               ,//==[7:0] input       data  FIO_CS0 FIO_CS1 FIO_CS2                                                                 
     input  wire             FIO_RE               ,//==[7:0] input       data  FIO_RE                                                                                  
     input  wire             FIO_ALE              ,//==[7:0] input data  FIO_ALE       
     
     //------------------------------------------------------------
     //-- Test pins                                                                                                                    
     //------------------------------------------------------------      
                                                                               
     output wire     [15:00] TEST_T           
); 

                                                                                          
//------------------------------------------------------------------------------           
//参数声明  开始                                                                           
//------------------------------------------------------------------------------           
defparam console_DO.datas_scan_DO.con_ctrl_IO.area3_len = 256;
                                                                
//------------------------------------------------------------------------------           
//参数声明  结束                                                                           
//------------------------------------------------------------------------------           
                                                                                           
                                                                                           
                                                                                           
//------------------------------------------------------------------------------           
//内部变量声明  开始                                                                       
//------------------------------------------------------------------------------           
//------------------------------------------------------------------------------
//wire decaler
//------------------------------------------------------------------------------
// clock_ctrl
wire         sys_clk_50m  ;  
wire         clk_10m      ; 
wire         clk_12p5m    ; 
wire         clk_12p5m_90 ;
wire         clk_12p5m_180;
wire         clk_12p5m_270;
wire         clk_100m     ;
wire         clk_100m_90  ;
wire         clk_100m_180 ;
wire         clk_100m_270 ;
wire         glbl_rst_n   ;
wire         glbl_rst     ;

//initial
wire         init_start;
wire         init_ok;
wire         init_fail;

wire [15:00] init_check_en;
wire [15:00] init_check_done;
wire [15:00] init_check_error;

wire 			   init_eep_rden;
wire [16:00] init_eep_length;
wire [15:00] init_eep_addr;

wire 			   init_cudb_wren;
wire [15:00] init_cudb_addr;
wire [07:00] init_cudb_din;

wire 			   init_chram_wren;
wire [11:00] init_chram_addr;	
wire [07:00] init_chram_data;

wire 			   init_dfpga_wren;
wire 			   init_dfpga_wrdone;
wire 			   init_dfpga_wrready;
wire 			   init_dfpga_rden;
wire [19:00] init_dfpga_addr;
wire [07:00] init_dfpga_data;

wire         idread_finish;
wire         rack_err     ;
wire [02:00] rack_id        ;
wire         slot_err     ;
wire [03:00] slot_id        ;                                                                                      

//console
wire 				 cdcb_a_wren;
wire [10:00] cdcb_a_addr;
wire [07:00] cdcb_a_din;
wire [07:00] cdcb_a_dout;

wire 				  cucb_a_wren;
wire [10:00]	cucb_a_addr;
wire [07:00]  cucb_a_din;
wire [07:00]  cucb_a_dout;

wire					cudb_a_wren;
wire [12:00]  cudb_a_addr;
wire [07:00]  cudb_a_din;
wire [07:00]	cudb_a_dout;

wire				  cddb_a_wren;
wire [12:00]  cddb_a_addr;
wire [07:00]  cddb_a_din;	
wire [07:00]  cddb_a_dout;

wire          ddb_a_wren;
wire [10:00]  ddb_a_addr;
wire [07:00]  ddb_a_din;
wire [07:00]  ddb_a_dout;

wire          dub_a_wren;
wire [10:00]  dub_a_addr;
wire [07:00]  dub_a_din;
wire [07:00]  dub_a_dout;

wire          d_chan_buf_wren;
wire          d_chan_buf_rden;
wire [11:00]  d_chan_buf_addr;
wire [07:00]  d_chan_buf_din;
wire [07:00]  d_chan_buf_dout;

wire          e2prom_rden_con;
wire          e2prom_wren_con;
wire [16:00]  e2prom_addr_con;
wire [16:00]  e2prom_wr_len_con;
wire [07:00]  e2prom_wdata_con;
wire          e2prom_wr_dv_con;

wire          lb_tx_wren;
wire [05:00]  lb_tx_addr;
wire [07:00]  lb_tx_din;
wire [07:00]  lb_tx_dout;

//main-ctrl
wire          down_en;
wire          mbus_en;
wire          tbus_en;
wire [02:00]  mode_reg;

//token

//di ch top

wire          do_ch_wren; 
wire [11:00]  do_ch_addr ;
wire [07:00]  do_ch_wdata;
wire [15:00]  do_din_feedback; 
wire [15:00]  do_fd_channel;   
wire [31:00]  do_led_ctrl;     

//M_Bus
wire          card_reset_reg;
wire          wr_lddb_flag  ;
wire          CRC_err       ;
wire          mb_txd				;
wire          mb_txen       ;

wire [12:00]  cudb_a_addr_mb;
wire [07:00]  mode_byte;

//l_bus_top
wire          lb_txen;
wire          lb_txd ;
wire          got_frame;
wire [07:00]  frame_id;
wire [07:00]  frame_type;
wire          ack_tx_en; 
wire          lpass_tx_en;
wire [07:00]  id_now;
wire          lb_txbuf_rden;
wire [15:00]  lb_txbuf_addr;
wire [07:00]  lb_txbuf_rdata;
wire          lb_rxbuf_wren;
wire [15:00]  lb_rxbuf_wraddr;
wire [07:00]  lb_rxbuf_wrdata;
                        
reg           lb_txbuf_addr_reg;
reg           lb_txbuf_data_choo; 
wire [07:00]  lb_txbuf_ack_rdata;             
wire [07:00]  lb_txbuf_pass_rdata;    
//e2prom app Interface
wire         e2prom_rden          ;
wire         e2prom_wren          ;
wire [16:00] e2prom_addr          ;
wire [16:00] e2prom_length        ;
wire         e2prom_ready         ;
wire [07:00] e2prom_wr_data       ;
wire         e2prom_wr_valid      ;
wire         e2prom_wr_last       ;
wire [07:00] e2prom_rd_data       ;
wire         e2prom_rd_valid      ;
wire         e2prom_rd_last       ;
wire         e2prom_status_reg_en ;
wire [07:00] e2prom_status_reg    ;
                                     

//------------------------------------------------------------------------------
//output 
//------------------------------------------------------------------------------
//L_Bus
assign lb_txbuf_ack_rdata = 0;

always @ (posedge sys_clk_50m)
	begin
		lb_txbuf_addr_reg <= lb_txbuf_addr[15];
		lb_txbuf_data_choo <= lb_txbuf_addr_reg;
	end

assign lb_txbuf_rdata = (lb_txbuf_data_choo) ? lb_txbuf_pass_rdata : lb_txbuf_ack_rdata;

assign TICL_LB_TXEN2 = lb_txen & tbus_en;
assign TICL_LB_TXEN1 = lb_txen & tbus_en;
                   //oe_n
assign TICL_LB_TX1 = lb_txd;
assign TICL_LB_TX2 = lb_txd;

//M_Bus
assign TICL_MB_TXEN2  = mb_txen & mbus_en  ;
assign TICL_MB_TX2  = mb_txd ; 
								//oe_n
assign TICL_MB_TXEN1  = mb_txen & mbus_en  ;
assign TICL_MB_TX1  = mb_txd ;

//

assign do_ch_wren = init_chram_wren | d_chan_buf_wren;
assign do_ch_addr = init_chram_addr | d_chan_buf_addr;
assign do_ch_wdata = init_chram_data | d_chan_buf_din;

//chx interface
 
//assign FD_FEEDBACK_01 = do_din_feedback[00];
//assign FD_FEEDBACK_02 = do_din_feedback[01];
//assign FD_FEEDBACK_03 = do_din_feedback[02];
//assign FD_FEEDBACK_04 = do_din_feedback[03];
//assign FD_FEEDBACK_05 = do_din_feedback[04];
//assign FD_FEEDBACK_06 = do_din_feedback[05];
//assign FD_FEEDBACK_07 = do_din_feedback[06];
//assign FD_FEEDBACK_08 = do_din_feedback[07];
//assign FD_FEEDBACK_09 = do_din_feedback[08];
//assign FD_FEEDBACK_10 = do_din_feedback[09];
//assign FD_FEEDBACK_11 = do_din_feedback[10];
//assign FD_FEEDBACK_12 = do_din_feedback[11];
//assign FD_FEEDBACK_13 = do_din_feedback[12];
//assign FD_FEEDBACK_14 = do_din_feedback[13];
//assign FD_FEEDBACK_15 = do_din_feedback[14];
//assign FD_FEEDBACK_16 = do_din_feedback[15];
//
//
//assign FP_CHANNEL_01 = do_fd_channel[00];
//assign FP_CHANNEL_02 = do_fd_channel[01];
//assign FP_CHANNEL_03 = do_fd_channel[02];
//assign FP_CHANNEL_04 = do_fd_channel[03];
//assign FP_CHANNEL_05 = do_fd_channel[04];
//assign FP_CHANNEL_06 = do_fd_channel[05];
//assign FP_CHANNEL_07 = do_fd_channel[06];
//assign FP_CHANNEL_08 = do_fd_channel[07];
//assign FP_CHANNEL_09 = do_fd_channel[08];
//assign FP_CHANNEL_10 = do_fd_channel[09];
//assign FP_CHANNEL_11 = do_fd_channel[10];
//assign FP_CHANNEL_12 = do_fd_channel[11];
//assign FP_CHANNEL_13 = do_fd_channel[12];
//assign FP_CHANNEL_14 = do_fd_channel[13];
//assign FP_CHANNEL_15 = do_fd_channel[14];
//assign FP_CHANNEL_16 = do_fd_channel[15];

//------------------------------------------------------------------------------
//signal route 
//------------------------------------------------------------------------------
//cudb
assign cudb_a_wren = init_cudb_wren;
assign cudb_a_addr = cudb_a_addr_mb | init_cudb_addr;
assign cudb_a_din = init_cudb_din;
//e2prom
assign e2prom_rden      =  e2prom_rden_con | init_eep_rden;//
assign e2prom_wren      =  e2prom_wren_con   ;
assign e2prom_addr      =  {1'b0,init_eep_addr} | e2prom_addr_con   ;
assign e2prom_length    =   init_eep_length | e2prom_wr_len_con  ;
assign e2prom_wr_data   =  e2prom_wdata_con   ;
assign e2prom_wr_valid  =  e2prom_wr_dv_con  ; 

assign glbl_rst = ~glbl_rst_n;                                                  
                                                                                                                                                   
//------------------------------------------------------------------------------            
//PLL调用                                                                        
//------------------------------------------------------------------------------

clock_ctrl clock_ctrl (
    .sys_clk_in       (CLK50MP1), 
    .clk_50m          (sys_clk_50m), 
    .clk_10m          (clk_10m), 
    .clk_12p5m        (clk_12p5m), 
    .clk_12p5m_90     (clk_12p5m_90), 
    .clk_12p5m_180    (clk_12p5m_180), 
    .clk_12p5m_270    (clk_12p5m_270), 
    .clk_100m         (clk_100m), 
    .clk_100m_90      (clk_100m_90), 
    .clk_100m_180     (clk_100m_180), 
    .clk_100m_270     (clk_100m_270), 
    .glb_rst_n        (glbl_rst_n)
    );
 
//------------------------------------------------------------------------------            
//功能模块调用                                                                        
//------------------------------------------------------------------------------ 
//main_ctrl 
main_ctrl_IO main_ctrl_IO(

 .clk(sys_clk_50m),
 .rst(~glbl_rst_n),
 
 .im_mode_byte(mode_byte),
 .i_rst_req(card_reset_reg),
 
 .om_mode_reg(mode_reg),
 .o_ini_start(init_start),
 .i_ini_done(init_ok),
 .i_ini_fail(init_fail),
 .o_tb_txen(tbus_en),
 .o_mb_txen(mbus_en),
 .o_down_en(down_en)     

);
 
//Initial
aio_inin_top aio_inin_top(
 
 .sys_clk(sys_clk_50m),
 .glbl_rst_n(glbl_rst_n),
 
 .init_start(init_start),
 .init_ok(init_ok),
 .init_fail(init_fail),
 
 .init_check_en(),						//not use now
 .init_check_done(16'hffff),          //not use now
 .init_check_error(),         //nots use now
 
 .init_eep_rden(init_eep_rden),
 .init_eep_length(init_eep_length),
 .init_eep_addr(init_eep_addr),
 .init_eep_valid(e2prom_rd_valid),
 .init_eep_last(e2prom_rd_last),
 .init_eep_data(e2prom_rd_data),

 .init_cons_wren(init_cudb_wren),
 .init_cons_addr(init_cudb_addr),
 .init_cons_data(init_cudb_din),
 
 .init_chram_wren(init_chram_wren),
 .init_chram_addr(init_chram_addr),	
 .init_chram_data(init_chram_data),
 
 .init_dfpga_wren(),						//not use now
 .init_dfpga_wrdone(),          //not use now
 .init_dfpga_wrready(),         //not use now
 .init_dfpga_rden(),            //not use now
 .init_dfpga_addr(),            //not use now
 .init_dfpga_data(),            //not use now
 
 .im_rack        (FDP_RACK),
 .im_slot        (FDP_SLOT),
 .o_idread_finish(idread_finish),
 .o_rack_err     (rack_err),
 .rack_id        (rack_id),
 .o_slot_err     (slot_err),
 .slot_id        (slot_id)

); 

//console 
 
console_DO console_DO(

 .clk(sys_clk_50m),
 .rst(~glbl_rst_n),
 
 .i_down_en(down_en),
 .im_mode_reg(mode_reg),
                	
 .i_ini_ok(init_ok),
 
 .om_diag_ram_addr(),          //not use now
 .im_diag_ram_dout(),          //not use now
 
 .i_cdcb_a_wren(cdcb_a_wren),
 .im_cdcb_a_addr(cdcb_a_addr),
 .im_cdcb_a_din(cdcb_a_din),
 .om_cdcb_a_dout(cdcb_a_dout),
 
 .i_cucb_a_wren(1'b0),
 .im_cucb_a_addr(cucb_a_addr),
 .im_cucb_a_din(cucb_a_din),
 .om_cucb_a_dout(cucb_a_dout),
 
 .i_cudb_a_wren(1'b0),
 .im_cudb_a_addr(cudb_a_addr),
 .im_cudb_a_din(cudb_a_din),
 .om_cudb_a_dout(cudb_a_dout),

 .i_cddb_a_wren(cddb_a_wren),
 .im_cddb_a_addr(cddb_a_addr),
 .im_cddb_a_din(cddb_a_din),	
 .om_cddb_a_dout(cddb_a_dout),
 
 .i_ddb_a_wren(ddb_a_wren),
 .im_ddb_a_addr(ddb_a_addr),
 .im_ddb_a_din(ddb_a_din),
 .om_ddb_a_dout(ddb_a_dout),
 
 .i_dub_a_wren(1'b0),
 .im_dub_a_addr(dub_a_addr),
 .im_dub_a_din(dub_a_din),
 .om_dub_a_dout(dub_a_dout),
 
 .o_d_chan_buf_wren(d_chan_buf_wren),
 .o_d_chan_buf_rden(d_chan_buf_rden),
 .om_d_chan_buf_addr(d_chan_buf_addr),
 .om_d_chan_buf_din(d_chan_buf_din),
 .im_d_chan_buf_dout(d_chan_buf_dout),

 .o_e2prom_rden(e2prom_rden_con),
 .o_e2prom_wren(e2prom_wren_con),
 .om_e2prom_addr(e2prom_addr_con),
 .om_e2prom_wr_len(e2prom_wr_len_con),
 .i_e2prom_ready(e2prom_ready),
 .om_e2prom_wdata(e2prom_wdata_con),
 .o_e2prom_wr_dv(e2prom_wr_dv_con),
 .o_e2prom_wr_last(),												//no use
 .im_e2prom_rd_data(e2prom_rd_data),
 .i_e2prom_rd_valid(e2prom_rd_valid),
 .i_e2prom_rd_last(e2prom_rd_last),
 .i_status_reg_en(e2prom_status_reg_en),
 .im_status_reg(e2prom_status_reg),

 .im_lb_tx_addr(lb_txbuf_addr),
 .om_lb_tx_dout(lb_txbuf_pass_rdata),
 
 .i_flag_wr_ddb(wr_lddb_flag)

); 
 
//token 
token token (
    .sys_clk(sys_clk_50m), 
    .glbl_rst_n(glbl_rst_n), 
    .start_token(1'b0), 
    .got_frame(got_frame), 
    .frame_id(frame_id), 
    .frame_type(frame_type), 
    .ack_tx_en(ack_tx_en), 
    .lb_pass_tx_en(lpass_tx_en), 
    .id_now(id_now), 
    .id_check_rslt_en(), /////////////////////////检验接受到id和当前令牌环id是否一样
    .id_check_rslt(),    /////////////////////////检验接受到id和当前令牌环id是否一样
    .token_run(),        ////////////////////////令牌环在运行
    .token_stop()        /////////////////////////令牌环因错误停止
    ); 

//di_ch_top
DO_CH_TOP DO_CH_TOP( 

 .clk          (sys_clk_50m),
 .rst          (glbl_rst_n),
 .i_parwren    (do_ch_wren),
 .im_paraddr   (do_ch_addr),
 .im_pardata   (do_ch_wdata),
 .i_rdren      (d_chan_buf_rden),
 .im_rdaddr    (do_ch_addr),
 .om_rddata    (d_chan_buf_dout),
 
 .i_din_feedback(do_din_feedback), 
 .o_fd_channel  (do_fd_channel),         // output 
 .led_ctrl      (do_led_ctrl)

); 

//ai input sim module
genvar gv_a;
generate
for(gv_a = 0; gv_a < 16; gv_a = gv_a + 1)
begin
do_channel_feedback_tb do_channel_feedback_tb( 
 .fp_channel    (do_fd_channel[gv_a]),
 .fd_channel    (1'b0),//1'b0
 .din_feedback  (do_din_feedback[gv_a])

);
end
endgenerate
 
 
//------------------------------------------------------------------------------            
//总线模块调用                                                                        
//------------------------------------------------------------------------------ 
//M_Bus
M_bus_top M_bus_top(

 .reset          (~glbl_rst_n),  
                 
 .sysclk         (sys_clk_50m),
 .synclk         (clk_100m),
 .clk_phy_p0     (clk_100m),
 .clk_phy_p90    (clk_100m_90),
 .clk_phy_p180   (clk_100m_180),
 .clk_phy_p270   (clk_100m_270),
 
 .lcudb_rdata    (cudb_a_dout),
 .lcucb_rdata    (cucb_a_dout),
 .ldub_rdata     (dub_a_dout),
 .slot_id        (slot_id),
 .rack_id        (rack_id),                     
 .read_id_done   (idread_finish),
 .lb_rxd         (TICL_MB_RX1),
 
 .lcudb_rden     (),								//no use
 .lcudb_raddr    (cudb_a_addr_mb),
 .lcucb_rden     (),								//no use
 .lcucb_raddr    (cucb_a_addr),
 .ldub_rden      (),								//no use
 .ldub_raddr     (dub_a_addr),  
 
 .lddb_wren      (ddb_a_wren),
 .lddb_waddr     (ddb_a_addr),
 .lddb_wdata     (ddb_a_din),

 .lcdcb_wren     (cdcb_a_wren),
 .lcdcb_waddr    (cdcb_a_addr),
 .lcdcb_wdata    (cdcb_a_din),
 
 .lcddb_wren     (cddb_a_wren),
 .lcddb_waddr    (cddb_a_addr),
 .lcddb_wdata    (cddb_a_din),
 
 .card_reset_reg (card_reset_reg),
 .wr_lddb_flag   (wr_lddb_flag),
 .lb_txd         (mb_txd),
 .lb_txen        (mb_txen),
 .CRC_err        (),									//not use now
 .mode_reg       (mode_byte)
                                                      
); 
 
//L_bus                                                                                      
l_bus_top l_bus_top (

 .sys_clk(sys_clk_50m), 
 .glbl_rst_n(glbl_rst_n), 
 .lb_clk_0(clk_12p5m), 
 .lb_clk_90(clk_12p5m_90), 
 .lb_clk_180(clk_12p5m_180), 
 .lb_clk_270(clk_12p5m_270),
 
 .ack_tx_en(ack_tx_en), 
 .lpass_tx_en(lpass_tx_en), 
 .id_now(id_now), 
 .lb_txbuf_rden (),      /////////////////////////发送buff的读取
 .lb_txbuf_addr (lb_txbuf_addr),      /////////////////////////发送buff的读取
 .lb_txbuf_rdata(lb_txbuf_rdata),     /////////////////////////发送buff的读取 
 .card_id({1'b0,rack_id,slot_id}),       /////////////////////////板卡id先赋值，后由上电模块给
 .init_done(init_ok),     /////////////////////////初始化完成标志先置1，后由上电模块给
 .lb_txen(lb_txen), 
 .lb_txd(lb_txd), 
 
 .lb_rxbuf_wren  (lb_rxbuf_wren),   /////////////////////////接受buff的写入
 .lb_rxbuf_wraddr(lb_rxbuf_wraddr), /////////////////////////接受buff的写入
 .lb_rxbuf_wrdata(lb_rxbuf_wrdata), /////////////////////////接受buff的写入 
 .got_frame(got_frame), 
 .frame_id(frame_id), 
 .frame_type(frame_type), 
 .sn_error(),        /////////////////////////sn错误标志，以后给诊断模块
 .lb_rxd(TICL_LB_RX1)

);       

//------------------------------------------------------------------------------            
//外部器件接口模块调用                                                                        
//------------------------------------------------------------------------------	  
// eeprom_axi eeprom_axi(
// 
// .sys_clk        (sys_clk_50m),
// .glbl_rst_n     (glbl_rst_n),
// 
// .flash_rden     (e2prom_rden),
// .flash_wren     (e2prom_wren),
// .flash_addr     (e2prom_addr),
// .flash_length   (e2prom_length),
// .flash_ready    (e2prom_ready),
// .flash_wr_data  (e2prom_wr_data),
// .flash_wr_valid (e2prom_wr_valid),
// .flash_wr_last  (),												//no use
// .flash_rd_data  (e2prom_rd_data),
// .flash_rd_valid (e2prom_rd_valid),
// .flash_rd_last  (e2prom_rd_last),
// 
// .status_reg_en  (e2prom_status_reg_en),
// .status_reg     (e2prom_status_reg),
// 
// .spi_clk        (FP_E2P_SCK),
// .spi_cs_n       (FP_E2P_CS),
// .spi_di         (FP_E2P_SO),
// .spi_do         (FP_E2P_SI),
// .spi_wp_n       (),												//no use
// .spi_hold_n     ()													//no use
// 
//);         

 eeprom_axi_tb eeprom_axi_tb(
  .sys_clk        (sys_clk_50m),
  .glbl_rst_n     (glbl_rst_n),
  
  .flash_rden     (e2prom_rden),
  .flash_wren     (e2prom_wren),
  .flash_addr     (e2prom_addr),
  .flash_length   (e2prom_length),
  .flash_ready    (e2prom_ready),
  .flash_wr_data  (e2prom_wr_data),
  .flash_wr_valid (e2prom_wr_valid),
  .flash_wr_last  (e2prom_wr_last),
  .flash_rd_data  (e2prom_rd_data),
  .flash_rd_valid (e2prom_rd_valid),
  .flash_rd_last  (e2prom_rd_last),
  
  .status_reg_en  (e2prom_status_reg_en),
  .status_reg     (e2prom_status_reg)
 
 );                                                          
                                                                                           
                                                                                           
endmodule                                                                                  






