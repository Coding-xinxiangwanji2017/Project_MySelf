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
// Name of module : NP811_U1_B01
// Project        : NicSys8000
// Func           : NP811 PFPGA Top
// Author         : Zhang Xueyan
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL090-FGG484I
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
module NP811_U1_B01  
( 

//-----------------------------------------------------------
//-- Global reset, clocks
//-----------------------------------------------------------
input  wire           FP_RST               ,//negedge rst
                      
input  wire           CLK_25MFP            ,
input  wire           CLK_50MFP            , 
//-----------------------------------------------------------
//-- Power Detector                    
//-----------------------------------------------------------
                      
input  wire           FDWR_DPG             ,//0 is valid（正常）

//-----------------------------------------------------------
//-- Watchdog                          
//-----------------------------------------------------------
                      
input  wire           FP_WDO               ,
output wire           FP_WDI               , 
//input               FD_WDO               , 					//不用

//-----------------------------------------------------------
//-- Mode Switch                       
//-----------------------------------------------------------
                      
input  wire           FDP_MKEY1            ,//[1]: 1 MTC; [2]: 1 NML [3]: 1 DLD 
input  wire           FDP_MKEY2            , 
input  wire           FDP_MKEY3            ,

//-----------------------------------------------------------
//-- Station ID, Rack ID, Slot ID      
//-----------------------------------------------------------
                      
input  wire   [3:0]   FDP_RACK             ,
input  wire   [4:0]   FDP_SLOT             ,
input  wire   [7:0]   FDP_STAT             ,

                                        
//-----------------------------------------------------------
//-- LED indicator                     
//-----------------------------------------------------------

output wire           FP_LED2              ,//RUN
output wire           FP_LED3Y             ,//Warning
output wire           FP_ERR_LED           ,//err
output wire           FP_LED4              ,//com
output wire           FP_LED6              ,//sync 
output wire           FP_LED5              ,//status1
output wire           FP_LED7              ,//status2 
output wire           FP_LED8              ,//status3 
output wire           FP_LED9              ,//status4
output wire           FP_LED10             ,//debug
output wire           FP_LED11             ,//debug

//----------------------------------------------------------- 
//-- Plug monitor, active low                                 
//-----------------------------------------------------------                 
input                 PLUG_MON             ,//1 is not plug; 0 is plug ok    

//-----------------------------------------------------------
//-- c-BUS                              
//-----------------------------------------------------------

input  wire           MVD_RA_RX1           ,//c-BUS
output wire           MVD_RA_TXEN1         ,
output wire           MVD_RA_TX1           ,

input  wire           MVD_RA_RX2           ,
output wire           MVD_RA_TXEN2         ,
output wire           MVD_RA_TX2           ,

//-----------------------------------------------------------
//-- R-BUS                                                   
//-----------------------------------------------------------                                      
                                      
input  wire           MVD_RB_RX1           , //R-BUS
output wire           MVD_RB_TXEN1         ,
output wire           MVD_RB_TX1           , 
                                      
input  wire           MVD_RB_RX2           , 
output wire           MVD_RB_TXEN2         , 
output wire           MVD_RB_TX2           , 

//-----------------------------------------------------------                                                                
//-- M-BUS                                                    
//-----------------------------------------------------------     
 
input  wire           TICL_MB_RX1          ,  
output wire           TICL_MB_TXEN1        ,     
output wire           TICL_MB_TX1          ,          
                                              
input  wire           TICL_MB_RX2          ,  
output wire           TICL_MB_TXEN2        ,                                        
output wire           TICL_MB_TX2          ,   

//-----------------------------------------------------------     
//-- L-BUS                                                        
//-----------------------------------------------------------                                      
input  wire           TICL_LB_RX1          , 
output wire           TICL_LB_TXEN1        ,
output wire           TICL_LB_TX1          ,
                                      
input  wire           TICL_LB_RX2          ,
output wire           TICL_LB_TXEN2        , 
output wire           TICL_LB_TX2          ,

//-----------------------------------------------------------     
//-- S-LINK                                                       
//-----------------------------------------------------------     
input  wire           RIF_SA_RX0           ,
output wire           RIF_SA_TXEN0         , 
output wire           RIF_SA_TX0           ,
input  wire           RIF_SA_RX1           , 
output wire           RIF_SA_TXEN1         ,
output wire           RIF_SA_TX1           ,

//-----------------------------------------------------------  
//-- sync signal of controls                                                    
//-----------------------------------------------------------  
input  wire           FDP_LOCKINA          , 
output wire           FDP_LOCKOA           , 
input  wire           FDP_LOCKINB          , 
output wire           FDP_LOCKOB           ,   


//-----------------------------------------------------------
//-- SRAM,FRAM                                                 
//-----------------------------------------------------------
output wire  [19:0]   PSRAM_A              ,  
inout  wire  [15:0]   PSRAM_D              ,
                                                                                             
output wire           PSRAM_OE_n           ,
output wire           PSRAM_WE_n           ,
output wire           PSRAM_CE1_n          ,
output wire           PSRAM_CE2            ,
output wire           PSRAM_BHE_n          ,
output wire           PSRAM_BLE_n          ,
input  wire           PSRAM_ERR            ,

output wire           PFRAM_UB_n           ,
output wire           PFRAM_LB_n           ,
output wire           PFRAM_OE_n           ,
output wire           PFRAM_WE_n           ,
output wire           PFRAM_CE_n           ,

//-----------------------------------------------------------
//-- SPI interface                                           
//-----------------------------------------------------------
output wire           FP_SPIF_RST          ,   //not use in sim
output wire           FP_SPI0_SS           ,   //not use in sim
output wire           FP_SPI0_SCK          ,   //not use in sim
input  wire           FP_SPI0_SDO          ,   //not use in sim
output wire           FP_SPI0_SDI          ,   //not use in sim

 //-----------------------------------------------------------
 //-- Interface with AFPGA                                    
 //-----------------------------------------------------------
//
output wire           APIO_RSTO            ,
output wire           APIO_CLK             ,
output wire           APIO_WE              ,
                
input  wire           APIO_TICK            ,//heartbeat in
                               
output wire           APIO_CS1             ,//
output wire           APIO_CS2             ,// 
output wire           APIO_CS3             ,//addr [22:20]
output wire           APIO_ALE             ,//addr[16]
output wire  [23:0]   APIO_DAT             ,//addr[15:0] dataout[7:0]  
input  wire  [7:0]    FAP_IO               ,//datainput

//-----------------------------------------------------------
//-- Interface with DFPGA                                    
//-----------------------------------------------------------

output wire           FIO_RSTO             ,//reset dfpga
output wire           FIO_CLK              ,//clk
output wire           FIO_TICK             ,//heartbeat out
input  wire           FIO_RSTIN            ,//heartbeat in
output wire           FIO_WE               ,//Wren


output wire  [7:0]    FDP_IO               ,//[20:13]addr;                                      
output wire  [20:0]   FIO_DAT              ,//[12:0] addr; [20:13] output wire data
                                       
input  wire           FIO_DAT21            ,//==[7:0] input data   
input  wire           FIO_DAT22            ,//==[7:0] input data  
input  wire           FIO_DAT23            ,//==[7:0] input data  
input  wire  [2:0]    FIO_CS               ,//==[7:0] input data
input  wire           FIO_RE               ,//==[7:0] input data
input  wire           FIO_ALE              ,//==[7:0] input data

//-----------------------------------------------------------
//-- Ethernet: RMII interface-1                              
//-----------------------------------------------------------

                      
input  wire  [1:0]    ETH1_RXD             ,
input  wire           ETH1_CRS             ,//rx valid
                                      
output wire           ETH1_TXEN            ,
output wire  [1:0]    ETH1_TXD             ,
output wire           ETH1_RST_n           ,
output wire           ETH1_REFCLK          ,

                                                               
//------------------------------------------------------------
//-- Test pins                                                
//------------------------------------------------------------
output wire  [15:0]   FP_TP                
);

                                                                                         
                                                                                            
//------------------------------------------------------------------------------            
//参数声明                                                                              
//------------------------------------------------------------------------------            
         

                                                                                         
//------------------------------------------------------------------------------            
//内部变量声明                                                                         
//------------------------------------------------------------------------------                                                                   
 //clk & rst_n
 wire         clk_12p5m;
 wire         clk_12p5m_90;
 wire         clk_12p5m_180;
 wire         clk_12p5m_270;
              
 wire         clk_100m;
 wire         clk_100m_90;
 wire         clk_100m_180;
 wire         clk_100m_270;
              
 wire         sys_clk_50m;  
 wire         glb_rst_n;     
       
 //process
 wire         start_token;
 wire         join_start;
              
 wire         down_en;       
 wire         xfer_in_en;    
 wire         xfer_out_en;   
 wire         cal_en;        
 wire         diag_en;       
 wire         sync_trans_en; 
 wire         sync_recv_en;  
 wire         console_in_en; 
 wire         console_out_en;
              
 wire         mb_tx_en;
 wire         lb_tx_en;
 wire         cb_tx_en;
 wire         rb_tx_en;
                                                                                      
 //fram
 wire         fram_rden;   
 wire         fram_wren;   
 wire [15:00] fram_address;  
 wire [15:00] fram_data_len;
 wire         fram_wdata_dv;
 wire         fram_wdata_last; 
 wire [07:00] fram_wdata;  
 wire         fram_rdata_dv;
 wire         fram_rdata_last;  
 wire [07:00] fram_rdata; 
 wire         fram_ready;    
 
 //flash
 wire         flash_rden     ;
 wire         flash_wren     ;
 wire         flash_era      ;
 wire [24:00] flash_addr     ;
 wire [24:00] flash_length   ;
 wire         flash_ready    ;
 wire [07:00] flash_wr_data  ;
 wire         flash_wr_valid ;
 wire         flash_wr_last  ;
 wire [07:00] flash_rd_data  ;
 wire         flash_rd_valid ;
 wire         flash_rd_last  ;                        
 wire         status_reg_en  ;
 wire [07:00] status_reg     ;
 
 //afpga
 wire         afpga_wren;
 wire [22:00] afpga_addr;
 wire [07:00] afpga_din;
 wire [07:00] afpga_dout;
   
 //tb_rx/tx_buf
 wire         lb_rx_wren; 
 wire [11:00] lb_rx_waddr;
 wire [07:00] lb_rx_wdata;
 wire         lb_tx_rden; 
 wire [11:00] lb_tx_raddr;
 wire [07:00] lb_tx_rdata;
 
 wire         cb_rx_wren; 
 wire [14:00] cb_rx_waddr;
 wire [07:00] cb_rx_wdata;
 wire         cb_tx_rden; 
 wire [14:00] cb_tx_raddr;
 wire [07:00] cb_tx_rdata;
 
 wire         rb_rx_wren; 
 wire [14:00] rb_rx_waddr;
 wire [07:00] rb_rx_wdata;
 wire         rb_tx_rden; 
 wire [14:00] rb_tx_raddr;
 wire [07:00] rb_tx_rdata;
 
 //t_bus
 wire         lb_got_frame;
 wire [07:00] lb_frame_id;
 wire [07:00] lb_frame_type;
 
 wire         lb_txen;
 wire         lb_txd;
 wire         cb_txen;
 wire         cb_txd;
 wire         rb_txen;
 wire         rb_txd;
 
 //m_bus
 wire         mb_txen;
 wire         mb_txd;
 
 //s_link
 wire [01:00] sl_trans_rslt;
 wire         sl_txen;
 wire         sl_txd;
 
 //Initial
 wire         init_start;
 wire         init_ok;   
 wire         init_fail; 
              
 wire         init_fram_rden; 
 wire [15:00] init_fram_length;
 wire [15:00] init_fram_addr;  
 
 wire         init_afpga_wren; 
 wire [22:00] init_afpga_addr;
 wire [07:00] init_afpga_rdata;
 wire [07:00] init_afpga_wdata;
 
 wire         init_cudb_wren;
 wire [15:00] init_cudb_addr;
 wire [07:00] init_cudb_data;
 wire [191:0] init_con_para;
 
 wire         init_flash_rden;  
 wire [23:00] init_flash_length;
 wire [24:00] init_flash_addr;  
 
 wire         init_xfer_wren;
 wire [17:00] init_xfer_addr;
 wire [07:00] init_xfer_data;
 wire [95:00] init_xfer_para;
 
 wire         init_card_wren;
 wire [10:00] init_card_addr;
 wire [07:00] init_card_din;
                                                                              
 wire         init_sram_wr_start;
 wire         init_sram_wr_done ;
              
 wire         init_idread_finish ;
 wire         init_station_err   ;
 wire [06:00] init_station_id    ;
 wire         init_rack_err      ;
 wire [02:00] init_rack_id       ;
 wire         init_slot_err      ;
 wire [03:00] init_slot_id       ;
 
 //communication
 wire [00:00] xfer_afpga_wren; 
 wire [00:00] xfer_afpga_rden; 
 wire [22:00] xfer_afpga_addr; 
 wire [07:00] xfer_afpga_wdata;
 wire [00:00] xfer_cddb_wren; 
 wire [00:00] xfer_cddb_rden; 
 wire [14:00] xfer_cddb_addr; 
 wire [07:00] xfer_cddb_wdata;
 
 wire         xfer_buf_rden;
 wire [17:00] xfer_buf_addr;
 wire [07:00] xfer_buf_data;
 
 //console
 wire         cdcb_a_wren;
 wire [10:00] cdcb_a_addr;
 wire [07:00] cdcb_a_din;
 wire [07:00] cdcb_a_dout;
 
 wire         cucb_a_wren;
 wire [10:00] cucb_a_addr;
 wire [07:00] cucb_a_din;
 wire [07:00] cucb_a_dout;
 
 wire         cudb_a_wren;
 wire [14:00] cudb_a_addr;
 wire [07:00] cudb_a_din; 
 wire [07:00] cudb_a_dout;
 
 wire         cddb_a_wren;
 wire [14:00] cddb_a_addr;
 wire [07:00] cddb_a_din; 
 wire [07:00] cddb_a_dout;
 
 wire         ddb_a_wren;
 wire [10:00] ddb_a_addr;
 wire [07:00] ddb_a_din; 
 wire [07:00] ddb_a_dout;
 
 wire         dub_a_wren;
 wire [10:00] dub_a_addr;
 wire [07:00] dub_a_din; 
 wire [07:00] dub_a_dout;
 
 wire         con_afpga_wren;
 wire [22:00] con_afpga_addr;
 wire [07:00] con_afpga_wdata;
 
 wire         con_flash_rden;  
 wire         con_flash_wren;  
 wire         con_flash_era;   
 wire [24:00] con_flash_addr;  
 wire [24:00] con_flash_length;
 wire [07:00] con_flash_wr_data;
 wire         con_flash_wr_valid;
 
 wire         con_fram_rden;
 wire         con_fram_wren; 
 wire [15:00] con_fram_addr;  
 wire [15:00] con_fram_data_len;
 wire         con_fram_wdata_dv;
 wire [07:00] con_fram_wdata;
 
 wire         flag_wr_ddb;
 
 //token
 wire         ack_tx_en;
 wire         lb_pass_tx_en;
 wire         cb_pass_tx_en;
 wire         rb_pass_tx_en;
 wire [07:00] id_now; 
 
 //sync
 wire         sync_afpga_wren;
 wire [22:00] sync_afpga_addr;
 wire [07:00] sync_afpga_wdata;
 
 wire         sl_rx_buf_wren;
 wire [10:00] sl_rx_buf_waddr;
 wire [07:00] sl_rx_buf_din;
 
 wire         sl_tx_buf_rden;
 wire [10:00] sl_tx_buf_raddr;
 wire [07:00] sl_tx_buf_dout;
 
 //sram  
 wire [17:00] sram_addr;     
 wire [07:00] sram_in_data;  
 wire [07:00] sram_out_data;
 wire         sram_out_en ; 
 //fram   
 wire [07:00] fram_data_in ;
 wire [07:00] fram_data_out;
 wire         fram_data_en ;
 wire [15:00] fram_addr    ; 
 
 //mode_reg
 wire [2:0]   mode_reg;
 
 assign mode_reg = {FDP_MKEY3,FDP_MKEY1,FDP_MKEY2};			//3'b010 :维护；3'b001 :运行
   																											//[1]: 1 MTC; [2]: 1 NML [3]: 1 DLD 
//------------------------------------------------------------------------------            
//BUS PHY SIGNALS ROUTE                                                                              
//------------------------------------------------------------------------------ 
 assign TICL_LB_TXEN1 = lb_txen;  // & lb_tx_en
 assign TICL_LB_TX1 = lb_txd;                //
 assign TICL_LB_TXEN2 = lb_txen;  //& lb_tx_en
 assign TICL_LB_TX2 = lb_txd;                //
                                             //
 assign MVD_RA_TXEN1 = rb_txen;   //& rb_tx_en
 assign MVD_RA_TX1 = rb_txd;                 //
 assign MVD_RA_TXEN2 = rb_txen;   //& rb_tx_en
 assign MVD_RA_TX2 = rb_txd;                 //
                                             //
 assign MVD_RB_TXEN1 = cb_txen;   // & cb_tx_en
 assign MVD_RB_TX1 = cb_txd;                 //
 assign MVD_RB_TXEN2 = cb_txen;   //& cb_tx_en
 assign MVD_RB_TX2 = cb_txd;                 //
                                             //
 assign TICL_MB_TXEN1 = mb_txen;  //& mb_tx_en
 assign TICL_MB_TX1 = mb_txd;                //
 assign TICL_MB_TXEN2 = mb_txen;  //& mb_tx_en
 assign TICL_MB_TX2 = mb_txd;
                                
 assign RIF_SA_TXEN0 = sl_txen;
 assign RIF_SA_TX0 = sl_txd;                           
 assign RIF_SA_TXEN1 = sl_txen;
 assign RIF_SA_TX1 = sl_txd; 
 
//------------------------------------------------------------------------------            
//AFPGA INTERFACE ROUTE                                                                              
//------------------------------------------------------------------------------  
 //assign APIO_RSTO = 1'b1;															//not use
 //assign APIO_CLK = sys_clk_50m;
 //assign APIO_WE = afpga_wren;        
 //assign APIO_TICK = 1'b1;         											//not use for sim
 //assign APIO_CS1 = afpga_addr[22];
 //assign APIO_CS2 = afpga_addr[21];
 //assign APIO_CS3 = afpga_addr[20];
 //assign APIO_ALE = afpga_addr[16];
 //assign APIO_DAT = {afpga_addr[15:0],afpga_dout};
 //assign FAP_IO = afpga_din;    
  reg [7:0]afpga_dout_reg;
  wire [7:0]afpga_dout_wire;
//------------------------------------------------------------------------------            
//INTERNAL SIGNALS ROUTE                                                                        
//------------------------------------------------------------------------------
 //afpga interface signals
 assign afpga_wren = xfer_afpga_wren | con_afpga_wren | init_afpga_wren;//sync_afpga_wren |
 assign afpga_addr =  xfer_afpga_addr | con_afpga_addr | init_afpga_addr;//sync_afpga_addr | 
 assign afpga_din = xfer_afpga_wdata | con_afpga_wdata | init_afpga_wdata;//sync_afpga_wdata ||  
 
 //flash_ctrler interface signals
 assign flash_rden = con_flash_rden | init_flash_rden;
 assign flash_wren = con_flash_wren;
 assign flash_era = con_flash_era;
 assign flash_addr = con_flash_addr | init_flash_addr;
 assign flash_length = con_flash_length | {1'b0,init_flash_length};
 assign flash_wr_data = con_flash_wr_data;
 assign flash_wr_valid = con_flash_wr_valid;
 assign flash_wr_last = 1'b0;
 
 //fram_wr_ctrler interface signals
 assign fram_rden = con_fram_rden | init_fram_rden;
 assign fram_wren = con_fram_wren;
 assign fram_address = con_fram_addr | init_fram_addr;
 assign fram_data_len = con_fram_data_len | {5'd0,init_fram_length[10:0]};
 assign fram_wdata_dv = con_fram_wdata_dv;
 assign fram_wdata_last = 1'b0;
 assign fram_wdata = con_fram_wdata;
 
//------------------------------------------------------------------------------            
//PLL调用                                                                        
//------------------------------------------------------------------------------ 
 
 clock_ctrl plls(
  
  .sys_clk_in      (CLK_50MFP),
  
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
    
//------------------------------------------------------------------------------            
//功能模块调用                                                                        
//------------------------------------------------------------------------------        

 inin_top initial_module(
	.sys_clk               (sys_clk_50m),
	.fram_clk              (),
	.glbl_rst_n            (glb_rst_n),
	
	.init_start            (init_start),
	.init_ok               (init_ok),
	.init_fail             (init_fail),
	
	.init_check_en         (),
	.init_check_done       (16'hffff),
	.init_check_error      (16'h0000),

	.init_fram_rden        (init_fram_rden),
	.init_fram_length      (init_fram_length),
	.init_fram_addr        (init_fram_addr),
	.init_fram_valid       (fram_rdata_dv),
	.init_fram_last        (fram_rdata_last),
	.init_fram_data        (fram_rdata),
	
	.init_afpga_rden       (),
	.init_afpga_wren       (init_afpga_wren),
	.init_afpga_addr       (init_afpga_addr),
	.init_afpga_rdata      (afpga_dout),
	.init_afpga_wdata      (init_afpga_wdata),

	.init_cons_wren        (init_cudb_wren),
	.init_cons_addr        (init_cudb_addr),
	.init_cons_data        (init_cudb_data),
	.init_cons_para        (init_con_para),
	
	.init_flash_rden       (init_flash_rden),
	.init_flash_length     (init_flash_length),
	.init_flash_addr       (init_flash_addr),
	.init_flash_valid      (flash_rd_valid),
	.init_flash_last       (flash_rd_last),
	.init_flash_data       (flash_rd_data),
 	.init_sram_wr_start    (init_sram_wr_start), 
  .init_sram_wr_done     (init_sram_wr_done),  

	.init_xfer_wren        (init_xfer_wren),
	.init_xfer_addr        (init_xfer_addr),
	.init_xfer_data        (init_xfer_data),
	.init_xfer_para        (init_xfer_para),
	
	.init_card_wren        (init_card_wren),
	.init_card_addr        (init_card_addr),	
	.init_card_data        (init_card_din),
	
	.init_dfpga_wren       (),
	.init_dfpga_wrdone     (),
	.init_dfpga_wrready    (),
	.init_dfpga_rden       (),
	.init_dfpga_addr       (),
	.init_dfpga_data       (),

	.im_station            (FDP_STAT),  
 	.im_rack               (FDP_RACK),  
 	.im_slot               (FDP_SLOT), 

	.o_idread_finish       (init_idread_finish),    
	.o_station_err         (init_station_err),    
	.station_id            (init_station_id),	      
	.o_rack_err            (init_rack_err),    
	.rack_id               (init_rack_id),
	.o_slot_err            (init_slot_err),    
	.slot_id               (init_slot_id)     
 );

 Communication_top Communication(
  .sys_clk_50m      (sys_clk_50m),
  .sys_rst_n        (glb_rst_n),	
	            
  .lb_rx_wren       (lb_rx_wren),	
  .lb_rx_waddr      (lb_rx_waddr),	
  .lb_rx_wdata      (lb_rx_wdata),	
  .cb_rx_wren       (cb_rx_wren),	
  .cb_rx_waddr      (cb_rx_waddr),	
  .cb_rx_wdata      (cb_rx_wdata),	
  .rb_rx_wren       (rb_rx_wren),	
  .rb_rx_waddr      (rb_rx_waddr),	
  .rb_rx_wdata      (rb_rx_wdata),
	             
  .lb_tx_rden       (lb_tx_rden),	
  .lb_tx_raddr      (lb_tx_raddr),	
  .lb_tx_rdata      (lb_tx_rdata),	
  .cb_tx_rden       (cb_tx_rden),	
  .cb_tx_raddr      (cb_tx_raddr),	
  .cb_tx_rdata      (cb_tx_rdata),
  .rb_tx_rden       (rb_tx_rden),	
  .rb_tx_raddr      (rb_tx_raddr),	
  .rb_tx_rdata      (rb_tx_rdata),	
                
  .xfer_in_en       (xfer_in_en),	
  .xfer_out_en      (xfer_out_en),	
  .xnet_en          (cal_en),	
	
  .init_ok          (init_ok),
  .init_xfer_para   (init_xfer_para),
	//
  .xfer_buf_rden    (xfer_buf_rden),	
  .xfer_buf_addr    (xfer_buf_addr),	
  .xfer_buf_data    (xfer_buf_data),
	//		
  .xfer_afpga_wren  (xfer_afpga_wren),	
  .xfer_afpga_rden  (),	
  .xfer_afpga_addr  (xfer_afpga_addr),	
  .xfer_afpga_wdata (xfer_afpga_wdata),	
  .xfer_afpga_rdata (afpga_dout),
	//与维护下行数据RAM接口	
  .xfer_cons_wren   (xfer_cddb_wren),	
  .xfer_cons_rden   (),	
  .xfer_cons_addr   (xfer_cddb_addr),	
  .xfer_cons_wdata  (xfer_cddb_wdata),	
  .xfer_cons_rdata  (cddb_a_dout)
 );

 process process(
	
	.clk                (sys_clk_50m),
	.rst                (~glb_rst_n),
                   
	.mode_reg         	(mode_reg),
	.slot_id            (init_slot_id),   
	                    
	.flag_slot_start    (ack_tx_en),
	.id_slot            (id_now),
	.flag_start_token   (start_token),
	
	.join_start         (join_start),
 	
	.ini_start          (init_start),
	.ini_done           (init_ok),
	.ini_fail           (init_fail),
	
	.mb_tx_en           (mb_tx_en),
	.lb_tx_en           (lb_tx_en),
	.cb_tx_en           (cb_tx_en),
	.rb_tx_en           (rb_tx_en),
	
	.down_en            (down_en),
	.xfer_in_en         (xfer_in_en),
	.xfer_out_en        (xfer_out_en),
	.cal_en             (cal_en),
	.diag_en            (diag_en),
	.sync_trans_en      (sync_trans_en),
	.sync_recv_en       (sync_recv_en),
	.console_in_en      (console_in_en),
	.console_out_en     (console_out_en)
	
 );

 console console(

  .clk                (sys_clk_50m),
  .rst                (~glb_rst_n),
  
  .im_mode_reg        (mode_reg),
           	
  .i_con_in_en        (console_in_en),
  .i_con_out_en       (console_out_en),
  .i_down_en          (down_en),
                	
  .i_ini_ok           (init_ok),
  .im_con_in_par      (init_con_para[63:0]),//init_con_para[63:0]
  .im_con_out_par     (init_con_para[127:64]),//init_con_para[127:64]
  .im_con_var_par     (init_con_para[191:128]),//init_con_para[191:128]
  
  .om_diag_ram_addr   (),											//后续与诊断模块连接
  .im_diag_ram_dout   (),

  .i_cdcb_a_wren      (cdcb_a_wren),
  .im_cdcb_a_addr     (cdcb_a_addr),
  .im_cdcb_a_din      (cdcb_a_din),
  .om_cdcb_a_dout     (cdcb_a_dout),

  .i_cucb_a_wren      (1'b0),
  .im_cucb_a_addr     (cucb_a_addr),
  .im_cucb_a_din      (cucb_a_din),
  .om_cucb_a_dout     (cucb_a_dout),

  .i_cudb_a_wren      (1'b0),
  .im_cudb_a_addr     (cudb_a_addr),
  .im_cudb_a_din      (cudb_a_din),
  .om_cudb_a_dout     (cudb_a_dout),

  .i_cddb_a_wren      (cddb_a_wren),
  .im_cddb_a_addr     (cddb_a_addr),
  .im_cddb_a_din      (cddb_a_din),	
  .om_cddb_a_dout     (cddb_a_dout),

  .i_ddb_a_wren       (ddb_a_wren),
  .im_ddb_a_addr      (ddb_a_addr),
  .im_ddb_a_din       (ddb_a_din),
  .om_ddb_a_dout      (ddb_a_dout),

  .i_dub_a_wren       (1'b0),
  .im_dub_a_addr      (dub_a_addr),
  .im_dub_a_din       (dub_a_din),
  .om_dub_a_dout      (dub_a_dout),

  .o_afpga_wren       (con_afpga_wren),
  .om_afpga_addr      (con_afpga_addr),
  .om_afpga_wdata     (con_afpga_wdata),
  .im_afpga_rdata     (afpga_dout),

  .flash_rden         (con_flash_rden),
  .flash_wren         (con_flash_wren),
  .flash_era          (con_flash_era),
  .flash_addr         (con_flash_addr),
  .flash_length       (con_flash_length),
  .flash_ready        (flash_ready),
  .flash_wr_data      (con_flash_wr_data),
  .flash_wr_valid     (con_flash_wr_valid),
  .flash_wr_last      (),											//未用到
  .flash_rd_data      (flash_rd_data),
  .flash_rd_valid     (flash_rd_valid),
  .flash_rd_last      (),											//未用到
  .status_reg_en      (status_reg_en),
  .status_reg         (status_reg),

  .o_fram_rden        (con_fram_rden),
  .o_fram_wren        (con_fram_wren),
  .om_fram_addr       (con_fram_addr),
  .om_fram_wr_len     (con_fram_data_len),
  .o_fram_wr_dv       (con_fram_wdata_dv),
  .o_fram_wdata       (con_fram_wdata),
  .i_fram_rd_dv       (fram_rdata_dv),
  .im_fram_rdata      (fram_rdata),
  .i_fram_rdy         (fram_ready),
  .i_flag_wr_ddb      (flag_wr_ddb)

 );

 token token(

	.sys_clk            (sys_clk_50m),
	.glbl_rst_n         (glb_rst_n),
	.start_token        (start_token),
	.got_frame          (lb_got_frame),
	.frame_id           (lb_frame_id),
	.frame_type         (lb_frame_type),
	.ack_tx_en          (ack_tx_en),
	.lb_pass_tx_en      (lb_pass_tx_en),
	.cb_pass_tx_en      (cb_pass_tx_en),
	.rb_pass_tx_en      (rb_pass_tx_en),
	.id_now             (id_now),
	.id_check_rslt_en   (),										//not use now
	.id_check_rslt      (),										//not use now
	.token_run          (),										//not use now
	.token_stop         ()										//not use now
	
 );

 sync_top sync_top(

  .clk                      (sys_clk_50m),
  .rst_n                    (glb_rst_n),
  
  .sync_trans_en            (sync_trans_en),
  .sync_recv_en             (sync_recv_en),
  .sync_Btoa_en             (sl_trans_rslt),
  
  .sl_tx_buf_rden           (sl_tx_buf_rden),
  .sl_tx_buf_raddr          (sl_tx_buf_raddr),
  .sl_tx_buf_dout           (sl_tx_buf_dout),
  
  .sl_rx_buf_wren           (sl_rx_buf_wren),
  .sl_rx_buf_waddr          (sl_rx_buf_waddr),
  .sl_rx_buf_din            (sl_rx_buf_din),
  
  .o_afpga_wren             (sync_afpga_wren),
  .om_afpga_addr            (sync_afpga_addr),
  .om_afpga_wdata           (sync_afpga_wdata),
  .im_afpga_rdata           (afpga_dout)

 );

 np811_led np811_led(                                                                                                       
  
  .rst_n       (glb_rst_n),                                                                      
  .clk         (sys_clk_50m),                                                                      
  .i_led_en    (18'b10_01_01_10_01_01_01_01_01),    //all blink  18'b10_01_01_10_01_01_01_01_01                                                           
              			            //single led needs 2 bit:( 2'b00:on; 2'b01:off; 2'b10:blink; 2'b11:rev)
              			            //i_led_en[17:0]->run,err_y,err_r,com,syn,st1,st2,st3,st4              
  .o_run_led   (FP_LED2),                                                                        
  .o_err_y_led (FP_LED3Y),     //warning                                                             
  .o_err_r_led (FP_ERR_LED),   //err                                                                 
  .o_com_led   (FP_LED4),                                                                      
  .o_syn_led   (FP_LED6),                                                                      
  .o_st1_led   (),             //not use                                                          
  .o_st2_led   (),             //                                                         
  .o_st3_led   (),             //                                                         
  .o_st4_led   ()              //
                                                                         
 );                                                                                                                      
    
//watchdog
 watchdog watchdog(
 
  .clk           (sys_clk_50m),
  .rst_n         (glb_rst_n),
  .i_dog_en      (1'b1),							//1'b1: enable; 1'b0:disable;
  .o_wdi         (FP_WDI)
  
 );

//------------------------------------------------------------------------------            
//总线模块调用                                                                        
//------------------------------------------------------------------------------ 
//m_bus
 M_bus_top M_bus_top(
 
  .reset            (~glb_rst_n),  
                    
  .sysclk           (sys_clk_50m),
  .synclk           (clk_100m),
  .clk_phy_p0       (clk_100m),
  .clk_phy_p90      (clk_100m_90),
  .clk_phy_p180     (clk_100m_180),
  .clk_phy_p270     (clk_100m_270),
  
  .lcudb_rdata      (cudb_a_dout),
  .lcucb_rdata      (cucb_a_dout),
  .ldub_rdata       (dub_a_dout),
  .slot_id          (init_slot_id), 
  .rack_id          (init_rack_id),         
  .read_id_done     (init_idread_finish),
  .lb_rxd           (TICL_MB_RX1),
                    
  .lcudb_rden       (),									//不用
  .lcudb_raddr      (cudb_a_addr),
  .lcucb_rden       (),									//不用
  .lcucb_raddr      (cucb_a_addr),
  .ldub_rden        (),									//不用
  .ldub_raddr       (dub_a_addr),  
                    
  .lddb_wren        (ddb_a_wren),
  .lddb_waddr       (ddb_a_addr),
  .lddb_wdata       (ddb_a_din),
                   
  .lcdcb_wren       (cdcb_a_wren),
  .lcdcb_waddr      (cdcb_a_addr),
  .lcdcb_wdata      (cdcb_a_din),
                    
  .lcddb_wren       (cddb_a_wren),
  .lcddb_waddr      (cddb_a_addr),
  .lcddb_wdata      (cddb_a_din),
                    
  .card_reset_reg   (),									//控制卡不用
  .wr_lddb_flag     (flag_wr_ddb),		
  .lb_txd           (mb_txd),
  .lb_txen          (mb_txen),
  .CRC_err          ()										//后边与diag连接
                                                 
 );


//t_bus
 l_bus_top l_bus_top(
  
  .sys_clk           (sys_clk_50m),
  .glbl_rst_n        (glb_rst_n),
  .lb_clk_0          (clk_12p5m),
  .lb_clk_90         (clk_12p5m_90),
  .lb_clk_180        (clk_12p5m_180),
  .lb_clk_270        (clk_12p5m_270),
 
  .ack_tx_en         (ack_tx_en),
  .lpass_tx_en       (lb_pass_tx_en),
  .id_now            (id_now),
  .lb_txbuf_rden     (lb_tx_rden),
  .lb_txbuf_addr     (lb_tx_raddr),
  .lb_txbuf_rdata    (lb_tx_rdata),////8'd22////////////////////////////////////////////////////////////////////////////////////
  .card_id           ({1'b0,init_rack_id,init_slot_id}),
  .init_done         (init_ok),///////////////////////////////////////// ///////////////////////////////////////////////
  
  .lb_txen           (lb_txen),
  .lb_txd            (lb_txd),
  
  .diag_ack_wren     (),														//同c_bus说明
  .lb_rxbuf_wren     (lb_rx_wren),								  //
  .lb_rxbuf_wraddr   (lb_rx_waddr),								//
  .lb_rxbuf_wrdata   (lb_rx_wdata),								//
  .got_frame         (lb_got_frame),								//
  .frame_id          (lb_frame_id),								//
  .frame_type        (lb_frame_type),							//
  .sn_error          (),
  
  .lb_rxd            (TICL_LB_RX1)
 
 );
 
 cr_bus_top c_bus_top(
 	
  .sys_clk          (sys_clk_50m),
  .glbl_rst_n       (glb_rst_n),
  .cr_clk_0         (clk_100m),
  .cr_clk_90        (clk_100m_90),
  .cr_clk_180       (clk_100m_180),
  .cr_clk_270       (clk_100m_270),
  
  .ack_tx_en        (ack_tx_en),
  .lpass_tx_en      (cb_pass_tx_en),
  .id_now           (id_now),
  .lb_txbuf_rden    (cb_tx_rden),
  .lb_txbuf_addr    (cb_tx_raddr),
  .lb_txbuf_rdata   (cb_tx_rdata),////8'd33/////////////////////////
  .card_id          ({1'b0,init_rack_id,init_slot_id}),
  .init_done        (init_ok),
 
  .lb_txen          (cb_txen),
  .lb_txd           (cb_txd),
  
  .diag_ack_wren    (),														//诊断模块组态检查RAM的写使能
  .lb_rxbuf_wren    (cb_rx_wren),
  .lb_rxbuf_wraddr  (cb_rx_waddr),									//诊断模块组态检查RAM的写地址
  .lb_rxbuf_wrdata  (cb_rx_wdata),									//诊断模块组态检查RAM的数据输入
  .got_frame        (),														//在c_bus里边未用到
  .frame_id         (),														//
  .frame_type       (),														//
  .sn_error         (),														//后续与诊断模块连接
  
  .lb_rxd           (MVD_RB_RX1)
 );
 
 cr_bus_top r_bus_top(
 	
  .sys_clk          (sys_clk_50m),
  .glbl_rst_n       (glb_rst_n),
  .cr_clk_0         (clk_100m),
  .cr_clk_90        (clk_100m_90),
  .cr_clk_180       (clk_100m_180),
  .cr_clk_270       (clk_100m_270),
  
  .ack_tx_en        (ack_tx_en),
  .lpass_tx_en      (rb_pass_tx_en),
  .id_now           (id_now),
  .lb_txbuf_rden    (rb_tx_rden),
  .lb_txbuf_addr    (rb_tx_raddr),
  .lb_txbuf_rdata   (rb_tx_rdata),////8'd44/////////////////////
  .card_id          ({1'b0,init_rack_id,init_slot_id}),
  .init_done        (init_ok),
 
  .lb_txen          (rb_txen),
  .lb_txd           (rb_txd),
  
  .diag_ack_wren    (),
  .lb_rxbuf_wren    (rb_rx_wren),
  .lb_rxbuf_wraddr  (rb_rx_waddr),
  .lb_rxbuf_wrdata  (rb_rx_wdata),
  .got_frame        (),
  .frame_id         (),
  .frame_type       (),
  .sn_error         (),
  
  .lb_rxd           (MVD_RA_RX1)
 );
 //s_link
 s_link s_link(
 	
  .sys_clk            (sys_clk_50m),
  .glb_rst            (~glb_rst_n),
  
  .syn_clk            (clk_100m),
  .syn_clk_90         (clk_100m_90),
  .syn_clk_180        (clk_100m_180),
  .syn_clk_270        (clk_100m_270),
  
  .i_console_en       (console_out_en),
  .i_join_start       (join_start), 
  .i_slot_id          (init_slot_id),
  .i_ini_dvalid       (1'b1),									//后边需要更改数据获取方式
  .i_ini_data         (8'hee),									//
  .o_trans_rslt       (sl_trans_rslt),					//该信号功能需要后续补充
  
  .sl_rxbuf_wren      (sl_rx_buf_wren),
  .sl_rxbuf_waddr     (sl_rx_buf_waddr),
  .sl_rxbuf_wdata     (sl_rx_buf_din),
  
  .sl_txbuf_rden      (sl_tx_buf_rden),
  .sl_txbuf_raddr     (sl_tx_buf_raddr),
  .sl_txbuf_rdata     (sl_tx_buf_dout),
 
  .sl_rxd             (RIF_SA_RX0),
  .sl_txd             (sl_txd),
  .sl_txen            (sl_txen)
 
 );

//------------------------------------------------------------------------------            
//外部器件接口模块调用                                                                        
//------------------------------------------------------------------------------ 
//flash
 flash_axi_tb flash_axi_tb(
  .sys_clk        (sys_clk_50m),
  .glbl_rst_n     (glb_rst_n),
  
  .flash_rden     (flash_rden),
  .flash_wren     (flash_wren),
  .flash_era      (flash_era),
  .flash_addr     (flash_addr),
  .flash_length   (flash_length),
  .flash_ready    (flash_ready),
  .flash_wr_data  (flash_wr_data),
  .flash_wr_valid (flash_wr_valid),
  .flash_wr_last  (flash_wr_last),
  .flash_rd_data  (flash_rd_data),
  .flash_rd_valid (flash_rd_valid),
  .flash_rd_last  (flash_rd_last),
  
  .status_reg_en  (status_reg_en),
  .status_reg     (status_reg)
 
 );

//fram   
 fram_axi fram_axi(
  
  .sys_clk         (sys_clk_50m),
  .glbl_rst_n      (glb_rst_n),
 
  .flash_wren      (fram_wren),
  .flash_rden      (fram_rden),
  .flash_addr      (fram_address),
  .flash_length    (fram_data_len),
  .flash_ready     (fram_ready),
  .flash_wr_data   (fram_wdata),
  .flash_wr_valid  (fram_wdata_dv),
  .flash_wr_last   (fram_wdata_last),
  .flash_rd_data   (fram_rdata),
  .flash_rd_valid  (fram_rdata_dv),
  .flash_rd_last   (fram_rdata_last),
 
  .fram_data_in    (fram_data_in), 
  .fram_data       (fram_data_out),  
  .fram_data_en    (fram_data_en),
  .fram_addr       (fram_addr),												//同上
  .fram_lbn        (PFRAM_LB_n),
  .fram_ubn        (PFRAM_UB_n),
  .fram_cen        (PFRAM_CE_n),
  .fram_oen        (PFRAM_OE_n),
  .fram_wen        (PFRAM_WE_n)
  
 );      
   
//sram                                                                             
 sram_cont_top sram_cont_top(
	.sys_clk(sys_clk_50m),
	.glbl_rst_n(glb_rst_n),
	
	.sram_rd_flag(xfer_in_en | xfer_out_en | xnet_en),
	.sram_wr_start(init_sram_wr_start),
	.sram_wr_done(init_sram_wr_done),
	
	.sram_rd_en(xfer_buf_rden),
	.sram_rd_addr(xfer_buf_addr),
	.sram_rd_data(xfer_buf_data),
	.sram_wr_en(init_xfer_wren),
	.sram_wr_addr(init_xfer_addr),
	.sram_wr_data(init_xfer_data),

	.sram_ce1_n(PSRAM_CE1_n),
	.sram_ce2(PSRAM_CE2),
	.sram_oe_n(PSRAM_OE_n),
	.sram_bhen_n(PSRAM_BHE_n),
	.sram_blen_n(PSRAM_BLE_n),
	.sram_we_n(PSRAM_WE_n),
	.sram_addr(sram_addr),
	.sram_in_data(sram_in_data),
	.sram_out_data(sram_out_data),
	.sram_out_en(sram_out_en)
 );                                                                                           
  
 fram_sram_mult fram_sram_mult(
	.sys_clk(sys_clk_50m),
	.glbl_rst_n(glb_rst_n),
	
	.sram_addr(sram_addr),
	.fram_addr(fram_addr),
	.fram_sram_addr(PSRAM_A),

	.sram_in_data(sram_in_data),
	.sram_out_data(sram_out_data),
	.sram_out_en(sram_out_en),
	.fram_in_data(fram_data_in),
	.fram_out_data(fram_data_out),
	.fram_out_en(fram_data_en),
	.fram_sram_data(PSRAM_D)
 ); 
  
 ///////////////////////////////仿真时用的afpga                                       
  afpga_model afpga_model(
                   .clk          (sys_clk_50m  ),
                   .rst_n        (glb_rst_n    ),
                                
                   .i_pfpga_rst_n(1'b1),
                   
                   .i_pfpga_clk  (sys_clk_50m),
                   .i_pfpga_wr   (afpga_wren),
                   .im_pfpga_addr(afpga_addr),
                   .im_pfpga_data(afpga_din),
                   .om_pfpga_data(afpga_dout_wire),
                   
                   .o_heart_beat(),
                   .test()
                  );
  
	always @ (posedge sys_clk_50m)
		afpga_dout_reg <= afpga_dout_wire;
	
	assign afpga_dout = afpga_dout_reg;
  
endmodule                                                                                   