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
// Name of module : CM811_UT4_B01
// Project        : NicSys8000
// Func           : CM811 PFPGA Top
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
module CM811_UT4_B01( 
    //-----------------------------------------------------------  
    //-- Global reset, clocks                                      
    //-----------------------------------------------------------  
 
    input  wire           FP_RSTA                     ,//negedge rst	                                        
    input  wire           CLK_25MP1                   ,
    input  wire           CLK50MP1                    ,

    //-----------------------------------------------------------  
    //-- Power Detector                                            
    //-----------------------------------------------------------  
                                              
    input  wire           FPWR_DPG                    ,//0 is valid  
    //-----------------------------------------------------------
    //-- Watchdog                                                
    //-----------------------------------------------------------
                                              
    input  wire           FP_WDOA                     ,
    output wire           FP_WDIA                     ,
    //input wire          FD_WDOB                     ,         
    
    //-----------------------------------------------------------
    //-- Station ID, Rack ID, Slot ID                            
    //-----------------------------------------------------------
                                                  
    input  wire    [3:0]  FDP_RACK                    ,
    input  wire    [4:0]  FDP_SLOT                    ,
    input  wire    [7:0]  FDP_STAT                    ,
    //----------------------------------------------------------- 
    //-- LED indicator                                            
    //----------------------------------------------------------- 
                                              
    output wire           FP_LED3                     ,//RUN
    output wire           FP_LED4                     ,//WARNING
    output wire           FP_ERR_LED                  ,//ERR
    output wire           FP_LED6                     ,//COM	
    
    //-----------------------------------------------------------
    //-- Plug monitor, active low                                
    //-----------------------------------------------------------
                                              
    input  wire           PLUG_CON                    ,//1 is not plug, 0 is plug ok

    //-----------------------------------------------------------
    //-- M-BUS                                                                                             
    //-----------------------------------------------------------                                          
                                              
    input  wire           TICL_MB_RX1                 ,
    output wire           TICL_MB_TX1                 ,
    //output wire           TICL_MB_PREM              ,
    output wire           TICL_MB_TXEN1               ,
                                                      
    input  wire           TICL_MB_RX2                 ,
    output wire           TICL_MB_TX2                 ,
    //output wire           TICL_MB_PREM              ,
    output wire           TICL_MB_TXEN2               ,
    //-----------------------------------------------------------
    //-- L-BUS                                                   
    //-----------------------------------------------------------
                                              
    input  wire           TICL_LB_RX1                 ,
    output wire           TICL_LB_TX1                 ,
    //output wire           TICL_LB_PREM              ,
    output wire           TICL_LB_TXEN1               ,
                                                      
    input  wire           TICL_LB_RX2                 ,
    output wire           TICL_LB_TX2                 ,
    //output wire           TICL_LB_PREM              ,
    output wire           TICL_LB_TXEN2               ,
    //-----------------------------------------------------------
    //-- c-BUS                                                   
    //-----------------------------------------------------------                                  
     input  wire         MVD_RA_RX1                  ,              
     output wire         MVD_RA_TX1                  ,
     //output wire         MVD_RA_PREM                 ,        
     output wire         MVD_RA_TXEN1                ,
                                                     
     input  wire         MVD_RA_RX2                  ,          
     output wire         MVD_RA_TX2                  ,          
     //output wire         MVD_RA_PREM                 ,         
     output wire         MVD_RA_TXEN2                ,
    //----------------------------------------------------------- 
    //-- R-BUS                                                    
    //----------------------------------------------------------- 
    
                                        
    input  wire           MVD_RB_RX1                ,
    output wire           MVD_RB_TX1                ,
    output wire           MVD_RB_PREM               ,            
    output wire           MVD_RB_TXEN1              ,
                                                    
    input  wire           MVD_RB_RX2                ,
    output wire           MVD_RB_TX2                ,           
    output wire           MVD_RB_TXEN2              ,
                                                                 
    //-----------------------------------------------------------
    //-- Interface with DFPGA                                    
    //-----------------------------------------------------------

    output wire           FIO_RSTO                    ,//reset dfpga
    output wire           FIO_CLK                     ,//clk
    output wire           FIO_TICK                    ,//heartbeat out
    input  wire           FIO_RSTIN                   ,//heartbeat in
    output wire           FIO_WE                      ,//Wren
                                                      
    output wire [20:0]    FIO_DAT                     ,//[12:0] addr, [20:13] output wire data
                                                      
    input  wire           FIO_DAT21                   ,//==[7:0] input data   
    input  wire           FIO_DAT22                   ,//==[7:0] input data  
    input  wire           FIO_DAT23                   ,//==[7:0] input data  
    input  wire [2:0]     FIO_CS                      ,//==[7:0] input data
    input  wire           FIO_RE                      ,//==[7:0] input data
    input  wire           FIO_ALE                     ,//==[7:0] input data   
    
    //-----------------------------------------------------------   
    //-- C-LINK                                    
    //-----------------------------------------------------------   
    
    output wire           CHANNEL_1_TXPART_TXD_EN     ,
    output wire           CHANNEL_1_TXPART_TXD	      ,
    input  wire           CHANNEL_1_TXPART_RXD        ,
    input  wire           CHANNEL_1_RXPART_RXD        ,
                  
    output wire           CHANNEL_2_TXPART_TXD_EN     ,
    output wire           CHANNEL_2_TXPART_TXD	      ,
    input  wire           CHANNEL_2_TXPART_RXD        ,
    input  wire           CHANNEL_2_RXPART_RXD        ,  
                  
    output wire           CHANNEL_3_TXPART_TXD_EN     ,
    output wire           CHANNEL_3_TXPART_TXD	      ,
    input  wire           CHANNEL_3_TXPART_RXD        ,
    input  wire           CHANNEL_3_RXPART_RXD        ,
                  
    output wire           CHANNEL_4_TXPART_TXD_EN     ,
    output wire           CHANNEL_4_TXPART_TXD	      ,
    input  wire           CHANNEL_4_TXPART_RXD        ,
    input  wire           CHANNEL_4_RXPART_RXD        ,        
                  
    output wire           CHANNEL_5_TXPART_TXD_EN     ,
    output wire           CHANNEL_5_TXPART_TXD	      ,
    input  wire           CHANNEL_5_TXPART_RXD        ,
    input  wire           CHANNEL_5_RXPART_RXD        ,
                  
    output wire           CHANNEL_6_TXPART_TXD_EN     ,
    output wire           CHANNEL_6_TXPART_TXD	      ,
    input  wire           CHANNEL_6_TXPART_RXD        ,
    input  wire           CHANNEL_6_RXPART_RXD        ,

    //----------------------------------------------------------- 
    //-- C-LINK  TX and RX LED  indicator                                                  
    //----------------------------------------------------------- 
                  
    output wire           PFPGA_CH_1_TX_LED           ,
    output wire           PFPGA_CH_1_RX_LED           ,
                                                      
    output wire           PFPGA_CH_2_TX_LED           ,
    output wire           PFPGA_CH_2_RX_LED           ,
                                                      
    output wire           PFPGA_CH_3_TX_LED           ,
    output wire           PFPGA_CH_3_RX_LED           ,
                                                      
    output wire           PFPGA_CH_4_TX_LED           ,
    output wire           PFPGA_CH_4_RX_LED           ,
                                                      
    output wire           PFPGA_CH_5_TX_LED           ,
    output wire           PFPGA_CH_5_RX_LED           ,
                                                      
    output wire           PFPGA_CH_6_TX_LED           ,
    output wire           PFPGA_CH_6_RX_LED           ,   
    
    //-----------------------------------------------------------
    //-- SPI interface                                           
    //-----------------------------------------------------------
    
    output wire            FP_E2P_CS                  ,
    output wire            FP_E2P_SCK                 ,
    input  wire            FP_E2P_SO                  ,
    output wire            FP_E2P_SI                  ,
    
    
    //------------------------------------------------------------
    //-- Test pins                                                
    //------------------------------------------------------------              
    output wire   [15:0]  TEST_T                            
);

                                                                                                 
                                                                                              
                                                                                                 
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
//  clock_ctrl           
wire         sys_clk_50m ;                                                                         
wire         glbl_rst_n ;                                                                         
wire         clk_10m ;                                                                         
wire         clk_12p5m ;                                                                         
wire         clk_12p5m_90 ;                                                                         
wire         clk_12p5m_180 ;                                                                         
wire         clk_12p5m_270 ;                                                                         
wire         clk_100m ;                                                                         
wire         clk_100m_90 ;                                                                         
wire         clk_100m_180 ;                                                                         
wire         clk_100m_270 ;   
//  cm811_inin_top
wire         init_start ;                                                                     
wire         init_ok ;                                                                     
wire         init_fail ;                                                                     
wire [15:00] init_check_en ;                                                                     
wire [15:00] init_check_done ;                                                                     
wire [15:00] init_check_error ; 	

wire 			 init_eep_rden;
wire [16:00] init_eep_length;
wire [15:00] init_eep_addr;
wire 			 init_eep_valid;
wire 			 init_eep_last;
wire [7:00]	 init_eep_data;

wire 			 init_cons_wren;
wire [15:00] init_cons_addr;
wire [07:00] init_cons_data;

wire 			 init_dfpga_wren;
wire 			 init_dfpga_wrdone;
wire 			 init_dfpga_wrready;
wire 			 init_dfpga_rden;
wire [19:00] init_dfpga_addr;
wire [07:00] init_dfpga_data;

wire         o_idread_finish;
wire	       o_station_err; 
wire [06:00] station_id; 
wire         o_rack_err     ;
wire [02:00] rack_id     ;
wire         o_slot_err     ;
wire [03:00] slot_id         ;  
//l_bus_top
wire [07:00] id_now;
wire         got_frame;
wire [07:00] frame_id;
wire [07:00] frame_type;
 // token           
wire         ack_tx_en;
wire         cb_pass_tx_en;
wire         token_run;
wire         token_stop;   
 //c_bus_top
wire         lb_txbuf_rden;
wire [15:00] lb_txbuf_addr;
reg  [07:00] lb_txbuf_rdata;
wire         cb_txen;
wire         cb_txd;
wire         lb_rxbuf_wren;
wire [15:00] lb_rxbuf_wraddr;
wire [07:00] lb_rxbuf_wrdata;
wire         sn_error;
//	cm811_clink_para
wire			addr_para_error;
wire			addr_para_ok;
wire [23:0]	para_addr[5:0]; 
//clink   
wire [10:0]	ch_txbuf_raddr[5:0];
wire [7:0]	ch_txbuf_rdata[5:0]; 
wire     	ch_rxbuf_wren[5:0]; 
wire [10:0]	ch_rx_buf_waddr[5:0]; 
wire [7:0]	ch_rxbuf_wdata[5:0]; 
wire [5:0]  clink_rxd;
wire [5:0]  clink_txd;
wire [5:0]  clink_txen;
wire [7:0]	lb_txbuf_rdata_six[5:0];
wire [10:0]	lb_txbuf_addr_six[5:0];

reg  [5:0]  choo_cb_data_reg;                                    
reg  [5:0]  choo_cb_data; 
 //mbus
wire     	mb_txd;
wire     	mb_txen;
wire     	lcdcb_wren; 
wire [10:0] lcdcb_waddr; 
wire [7:0]	lcdcb_wdata;
wire        lcddb_wren; 
wire [12:0]	lcddb_waddr; 
wire [7:0]  lcddb_wdata;
wire        lddb_wren; 
wire [10:0]	lddb_waddr; 
wire [7:0]	lddb_wdata; 
wire        ldub_rden; 
wire [10:0]	ldub_raddr;
wire [7:0]  ldub_rdata;
wire [10:0]	lcucb_raddr;
wire [7:0]  lcucb_rdata;
wire [12:0]	lcudb_raddr;
wire [7:0]  lcudb_rdata;
wire        wr_lddb_flag;
wire        card_reset_reg;
wire [7:0]  mode_reg;
//console
wire        o_console_en;
wire        i_init_ok;
wire [10:0]	om_ch1_addr;
wire [10:0]	om_ch2_addr;
wire [10:0]	om_ch3_addr;
wire [10:0]	om_ch4_addr;
wire [10:0]	om_ch5_addr;
wire [10:0]	om_ch6_addr;
wire        flash_rden_con;
wire [16:0] flash_addr_con;
wire [16:0] flash_length_con;
//flash
wire         flash_rden     ;
wire         flash_wren     ;
wire [16:00] flash_addr     ;
wire [16:00] flash_length   ;
wire         flash_ready    ;
wire [07:00] flash_wr_data  ;
wire         flash_wr_valid ;
wire         flash_wr_last  ;
wire [07:00] flash_rd_data  ;
wire         flash_rd_valid ;
wire         flash_rd_last  ;
                            
wire         status_reg_en  ;
wire [07:00] status_reg     ;

//main ctrl
wire om_mode_reg;
wire i_down_en;
//------------------------------------------------------------------------------                 
//内部变量声明  开始                                                                             
//------------------------------------------------------------------------------                 
                                                                                                                                                                                      
//------------------------------------------------------------------------------                 
//逻辑参考  开始                                                                                 
//------------------------------------------------------------------------------ 
assign MVD_RB_TX1    = 1;    //
assign MVD_RB_TXEN1  = 0;    //
assign  MVD_RB_TX2   = 1;    //
assign  MVD_RB_TXEN2 = 0;    //


assign flash_rden = init_eep_rden | flash_rden_con;    //
assign flash_addr = init_eep_addr | flash_addr_con;    //
assign flash_length = init_eep_length | flash_length_con;//

always @ (posedge sys_clk_50m)
	begin
		choo_cb_data_reg <= lb_txbuf_addr[15:10];
		choo_cb_data <= choo_cb_data_reg;
	end
	
always @ (*)
	case(choo_cb_data)
		6'b000001	:	lb_txbuf_rdata <= lb_txbuf_rdata_six[0];
		6'b000010	:	lb_txbuf_rdata <= lb_txbuf_rdata_six[1];
		6'b000100	:	lb_txbuf_rdata <= lb_txbuf_rdata_six[2];
		6'b001000	:	lb_txbuf_rdata <= lb_txbuf_rdata_six[3];
		6'b010000	:	lb_txbuf_rdata <= lb_txbuf_rdata_six[4];
		6'b100000	:	lb_txbuf_rdata <= lb_txbuf_rdata_six[5];
		default	:	lb_txbuf_rdata <= lb_txbuf_rdata;
	endcase
	
	assign lb_txbuf_addr_six[0] = {1'b0,lb_txbuf_addr[9:0]} | om_ch1_addr;
	assign lb_txbuf_addr_six[1] = {1'b0,lb_txbuf_addr[9:0]} | om_ch2_addr;
	assign lb_txbuf_addr_six[2] = {1'b0,lb_txbuf_addr[9:0]} | om_ch3_addr; 
	assign lb_txbuf_addr_six[3] = {1'b0,lb_txbuf_addr[9:0]} | om_ch4_addr; 
	assign lb_txbuf_addr_six[4] = {1'b0,lb_txbuf_addr[9:0]} | om_ch5_addr; 
	assign lb_txbuf_addr_six[5] = {1'b0,lb_txbuf_addr[9:0]} | om_ch6_addr; 
	
	assign clink_rxd = {CHANNEL_1_RXPART_RXD,CHANNEL_2_RXPART_RXD,CHANNEL_3_RXPART_RXD,CHANNEL_4_RXPART_RXD,CHANNEL_5_RXPART_RXD,CHANNEL_6_RXPART_RXD} ;
	
	assign CHANNEL_1_TXPART_TXD_EN = clink_txen[0];
	assign CHANNEL_2_TXPART_TXD_EN = clink_txen[1];
	assign CHANNEL_3_TXPART_TXD_EN = clink_txen[2];
	assign CHANNEL_4_TXPART_TXD_EN = clink_txen[3];
	assign CHANNEL_5_TXPART_TXD_EN = clink_txen[4];
	assign CHANNEL_6_TXPART_TXD_EN = clink_txen[5];
	
	assign CHANNEL_1_TXPART_TXD = clink_txd[0];
	assign CHANNEL_2_TXPART_TXD = clink_txd[1];
	assign CHANNEL_3_TXPART_TXD = clink_txd[2];
	assign CHANNEL_4_TXPART_TXD = clink_txd[3];
	assign CHANNEL_5_TXPART_TXD = clink_txd[4];
	assign CHANNEL_6_TXPART_TXD = clink_txd[5];
	
	assign MVD_RA_TXEN1 = cb_txen;
	assign MVD_RA_TXEN2 = cb_txen;
	assign MVD_RA_TX1 = cb_txd;
	assign MVD_RA_TX2 = cb_txd;
	
	assign TICL_MB_TXEN1 = mb_txen;
	assign TICL_MB_TXEN2 = mb_txen;
	assign TICL_MB_TX1 = mb_txd;
	assign TICL_MB_TX2 = mb_txd;
	
	assign TICL_LB_TX1  = 1;
	assign TICL_LB_TXEN1  = 0;
	
	assign TICL_LB_TX2   = 1;
	assign TICL_LB_TXEN2   = 0;
//------------------------------------------------------------------------------                 
//逻辑参考  结束                                                                                 
//------------------------------------------------------------------------------                                                                                                   
                                                                                                 
//------------------------------------------------------------------------------                 
//模块调用参考  开始                                                                             
//------------------------------------------------------------------------------ 
//eeprom_axi eeprom_axi (
//    .sys_clk(sys_clk_50m), 
//    .glbl_rst_n(glbl_rst_n), 
//    .flash_rden(flash_rden), 
//    .flash_wren(flash_wren), 
//    .flash_addr(flash_addr), 
//    .flash_length(flash_length), 
//    .flash_ready(flash_ready), 
//    .flash_wr_data(flash_wr_data), 
//    .flash_wr_valid(flash_wr_valid), 
//    .flash_wr_last(flash_wr_last), 
//    .flash_rd_data(flash_rd_data), 
//    .flash_rd_valid(flash_rd_valid), 
//    .flash_rd_last(flash_rd_last), 
//    .status_reg_en(status_reg_en), 
//    .status_reg(status_reg), 
//    .spi_clk(FP_E2P_SCK), 
//    .spi_cs_n(FP_E2P_CS), 
//    .spi_di(FP_E2P_SO), 
//    .spi_do(FP_E2P_SI), 
//    .spi_wp_n(), 
//    .spi_hold_n()
//    );

	cm811_inin_top cm811_inin_top (
		.sys_clk              (sys_clk_50m), 
		.glbl_rst_n           (glbl_rst_n), 
		.init_start           (init_start), 
		.init_ok              (init_ok), 
		.init_fail            (init_fail), 
		.init_check_en        (init_check_en), 
		.init_check_done      (16'hffff), 
		.init_check_error     (init_check_error), 
		.init_eep_rden        (init_eep_rden), 
		.init_eep_length      (init_eep_length), 
		.init_eep_addr        (init_eep_addr), 
		.init_eep_valid       (flash_rd_valid), 
		.init_eep_last        (flash_rd_last), 
		.init_eep_data        (flash_rd_data), 
		.init_cons_wren       (init_cons_wren), 
		.init_cons_addr       (init_cons_addr), 
		.init_cons_data       (init_cons_data), 
		.init_dfpga_wren      (init_dfpga_wren), 
		.init_dfpga_wrdone    (init_dfpga_wrdone), 
		.init_dfpga_wrready   (init_dfpga_wrready), 
		.init_dfpga_rden      (init_dfpga_rden), 
		.init_dfpga_addr      (init_dfpga_addr), 
		.init_dfpga_data      (init_dfpga_data), 
		.im_rack              (FDP_RACK), 
		.im_slot              (FDP_SLOT), 
		.im_station           (FDP_STAT),
		.o_idread_finish      (o_idread_finish),
		.o_station_err        (o_station_err), 
		.station_id           (station_id),  
		.o_rack_err           (o_rack_err), 
		.rack_id              (rack_id), 
		.o_slot_err           (o_slot_err), 
		.slot_id              (slot_id)
	);
		 
	M_bus_top M_bus_top (
		.reset(~glbl_rst_n), 
		.sysclk(sys_clk_50m), 
		.synclk(clk_100m), 
		.clk_phy_p0(clk_100m), 
		.clk_phy_p90(clk_100m_90), 
		.clk_phy_p180(clk_100m_180), 
		.clk_phy_p270(clk_100m_270), 
		.lcudb_rdata(lcudb_rdata), 
		.lcucb_rdata(lcucb_rdata), 
		.ldub_rdata(ldub_rdata), 
		.slot_id(slot_id), 
		.rack_id(rack_id), 
		.read_id_done(o_idread_finish), 
		.lb_rxd(TICL_MB_RX1), 
		.lcudb_rden(), //////////////////////////
		.lcudb_raddr(lcudb_raddr), 
		.lcucb_rden(), ////////////////////////////////
		.lcucb_raddr(lcucb_raddr), 
		.ldub_rden(), ////////////////////////////////////
		.ldub_raddr(ldub_raddr), 
		.lddb_wren(lddb_wren), 
		.lddb_waddr(lddb_waddr), 
		.lddb_wdata(lddb_wdata), 
		.lcdcb_wren(lcdcb_wren), 
		.lcdcb_waddr(lcdcb_waddr), 
		.lcdcb_wdata(lcdcb_wdata), 
		.lcddb_wren(lcddb_wren), 
		.lcddb_waddr(lcddb_waddr), 
		.lcddb_wdata(lcddb_wdata), 
		.card_reset_reg(card_reset_reg), 
		.wr_lddb_flag(wr_lddb_flag), 
		.lb_txd(mb_txd), 
		.lb_txen(mb_txen), 
		.mode_reg(mode_reg),
		.CRC_err()///////////////////////////////////////
	);

	clock_ctrl clock_ctrl (
		.sys_clk_in           (CLK50MP1), 
		.clk_50m              (sys_clk_50m), 
		.clk_10m              (clk_10m), 
		.clk_12p5m            (clk_12p5m), 
		.clk_12p5m_90         (clk_12p5m_90), 
		.clk_12p5m_180        (clk_12p5m_180), 
		.clk_12p5m_270        (clk_12p5m_270), 
		.clk_100m             (clk_100m), 
		.clk_100m_90          (clk_100m_90), 
		.clk_100m_180         (clk_100m_180), 
		.clk_100m_270         (clk_100m_270), 
		.glb_rst_n            (glbl_rst_n)
	); 

	cm811_clink_para cm811_clink_para (
		.sys_clk              (sys_clk_50m), 
		.glbl_rst_n           (glbl_rst_n), 
		.init_cons_wren       (init_cons_wren), 
		.init_cons_addr       (init_cons_addr), 
		.init_cons_data       (init_cons_data), 
		.addr_para_error      (addr_para_error), 
		.addr_para_ok         (addr_para_ok), 
		.para_addr1           (para_addr[0]), 
		.para_addr2           (para_addr[1]), 
		.para_addr3           (para_addr[2]), 
		.para_addr4           (para_addr[3]), 
		.para_addr5           (para_addr[4]), 
		.para_addr6           (para_addr[5])
	);	

	l_bus_top l_bus_top (
		.sys_clk              (sys_clk_50m), 
		.glbl_rst_n           (glbl_rst_n), 
		.lb_clk_0             (clk_12p5m), 
		.lb_clk_90            (clk_12p5m_90), 
		.lb_clk_180           (clk_12p5m_180), 
		.lb_clk_270           (clk_12p5m_270), 
		.ack_tx_en            (1'b0), //不发送不连
		.lpass_tx_en          (1'b0), //不发送不连
		.id_now               (id_now), 
		.lb_txbuf_rden        (), //输出不连
		.lb_txbuf_addr        (), //输出不连
		.lb_txbuf_rdata       (8'b0),    
		.card_id              (8'd6),       
		.init_done            (init_ok),     
		.lb_txen              (), //输出不连
		.lb_txd               (), //输出不连
		.diag_ack_wren        (), //输出不连
		.lb_rxbuf_wren        (), //输出不连
		.lb_rxbuf_wraddr      (),//输出不连 
		.lb_rxbuf_wrdata      (), //输出不连
		.got_frame            (got_frame), 
		.frame_id             (frame_id), 
		.frame_type           (frame_type), 
		.sn_error             (), //输出不连
		.lb_rxd               (TICL_LB_RX1)
	);


main_ctrl_CM main_ctrl_CM (
    .clk(sys_clk_50m), 
    .rst(~glbl_rst_n), 
    .im_mode_byte(mode_reg),
    .i_slot_start(ack_tx_en),
    .om_mode_reg(),
    .im_id_now(id_now),
    .i_rst_req(card_reset_reg),
    .i_ini_done(init_ok), 
    .i_ini_fail(init_fail), 
    .o_ini_start(init_start), 
    .o_down_en(i_down_en), 
    .o_console_en(o_console_en), 
    .o_mb_txen(), 
    .o_tb_txen()
    );  
eeprom_axi_tb eeprom_axi_tb(
    .sys_clk         (sys_clk_50m),
    .glbl_rst_n      (glbl_rst_n),         
    .flash_rden      (flash_rden),
    .flash_wren      (flash_wren),
    .flash_addr      (flash_addr),
    .flash_length    (flash_length),
    .flash_ready     (flash_ready),
    .flash_wr_data   (flash_wr_data),
    .flash_wr_valid  (flash_wr_valid),
    .flash_wr_last   (flash_wr_last),
    .flash_rd_data   (flash_rd_data),
    .flash_rd_valid  (flash_rd_valid),
    .flash_rd_last   (flash_rd_last),         
    .status_reg_en   (status_reg_en),
    .status_reg      (status_reg)
); 
    
		 	
	token token (
		.sys_clk              (sys_clk_50m), 
		.glbl_rst_n           (glbl_rst_n), 
		.start_token          (1'b0), 
		.got_frame            (got_frame), 
		.frame_id             (frame_id), 
		.frame_type           (frame_type), 
		.ack_tx_en            (ack_tx_en), 
		.lb_pass_tx_en        (),  //输出不连
		.cb_pass_tx_en        (cb_pass_tx_en), 
		.rb_pass_tx_en        (),  //输出不连
		.id_now               (id_now), 
		.id_check_rslt_en     (),//输出不连 
		.id_check_rslt        (), //输出不连
		.token_run            (token_run), 
		.token_stop           (token_stop)
	);
	
	cr_bus_top cr_bus_top (
		.sys_clk              (sys_clk_50m), 
		.glbl_rst_n           (glbl_rst_n), 
		.cr_clk_0             (clk_100m), 
		.cr_clk_90            (clk_100m_90), 
		.cr_clk_180           (clk_100m_180), 
		.cr_clk_270           (clk_100m_270), 
		.ack_tx_en            (ack_tx_en), 
		.lpass_tx_en          (cb_pass_tx_en), 
		.id_now               (id_now), 
		.lb_txbuf_rden        (lb_txbuf_rden), 
		.lb_txbuf_addr        (lb_txbuf_addr), 
		.lb_txbuf_rdata       (lb_txbuf_rdata), 
		.card_id              ({1'b0,rack_id,slot_id}), 
		.init_done            (init_ok), 
		.lb_txen              (cb_txen), 
		.lb_txd               (cb_txd), 
		.diag_ack_wren        (), //输出不连
		.lb_rxbuf_wren        (lb_rxbuf_wren), 
		.lb_rxbuf_wraddr      (lb_rxbuf_wraddr), 
		.lb_rxbuf_wrdata      (lb_rxbuf_wrdata), 
		.got_frame            (), //输出不连
		.frame_id             (), //输出不连
		.frame_type           (), //输出不连
		.sn_error             (sn_error), //诊断需要
		.lb_rxd               (MVD_RA_RX1)
	);	

console_CM console_CM (
    .clk(sys_clk_50m), 
    .rst(~glbl_rst_n), 
    .i_console_en(o_console_en), 
    .i_down_en(i_down_en),
    .im_mode_reg(om_mode_reg), 
    .i_ini_ok(init_ok), 
    .om_diag_ram_addr(), 
    .im_diag_ram_dout(), 
    .i_cdcb_a_wren(lcdcb_wren), 
    .im_cdcb_a_addr(lcdcb_waddr), 
    .im_cdcb_a_din(lcdcb_wdata), 
    .om_cdcb_a_dout(), 
    .i_cucb_a_wren(1'b0), 
    .im_cucb_a_addr(lcucb_raddr), 
    .im_cucb_a_din(8'd0), 
    .om_cucb_a_dout(lcucb_rdata), 
    .i_cudb_a_wren(1'b0), 
    .im_cudb_a_addr(lcudb_raddr), 
    .im_cudb_a_din(8'd0), 
    .om_cudb_a_dout(lcudb_rdata), 
    .i_cddb_a_wren(lcddb_wren), 
    .im_cddb_a_addr(lcddb_waddr), 
    .im_cddb_a_din(lcddb_wdata), 
    .om_cddb_a_dout(), 
    .i_ddb_a_wren(lddb_wren), 
    .im_ddb_a_addr(lddb_waddr), 
    .im_ddb_a_din(lddb_wdata), 
    .om_ddb_a_dout(), 
    .i_dub_a_wren(1'b0), 
    .im_dub_a_addr(ldub_raddr), 
    .im_dub_a_din(8'd0), 
    .om_dub_a_dout(ldub_rdata), 
    .o_e2prom_rden(flash_rden_con), 
    .o_e2prom_wren(flash_wren), 
    .om_e2prom_addr(flash_addr_con), 
    .om_e2prom_wr_len(flash_length_con), 
    .im_e2prom_ready(flash_ready), 
    .om_e2prom_wdata(flash_wr_data), 
    .o_e2prom_wr_dv(flash_wr_valid), 
    .om_e2prom_wr_last(flash_wr_last), 
    .im_e2prom_rd_data(flash_rd_data), 
    .i_e2prom_rd_valid(flash_rd_valid), 
    .i_e2prom_rd_last(flash_rd_last), 
    .i_status_reg_en(status_reg_en), 
    .im_status_reg(status_reg), 
    .om_ch1_addr(om_ch1_addr),          
    .im_ch1_rdata(lb_txbuf_rdata_six[0]), 
    .om_ch2_addr(om_ch2_addr), 
    .im_ch2_rdata(lb_txbuf_rdata_six[1]), 
    .om_ch3_addr(om_ch3_addr), 
    .im_ch3_rdata(lb_txbuf_rdata_six[2]), 
    .om_ch4_addr(om_ch4_addr), 
    .im_ch4_rdata(lb_txbuf_rdata_six[3]), 
    .om_ch5_addr(om_ch5_addr), 
    .im_ch5_rdata(lb_txbuf_rdata_six[4]), 
    .om_ch6_addr(om_ch6_addr), 
    .im_ch6_rdata(lb_txbuf_rdata_six[5]), 
    .i_flag_wr_ddb(wr_lddb_flag)                       //和c-bus有交集
    );


genvar i;
  generate
	for (i = 0; i < 6; i = i + 1) 
		begin
			Clink_top Clink_top (
				.reset(~glbl_rst_n), 
				.sys_clk(sys_clk_50m), 
				.ch1_rxbuf_wren(ch_rxbuf_wren[i]), 
				.ch1_rxbuf_waddr(ch_rx_buf_waddr[i]), 
				.ch1_rxbuf_wdata(ch_rxbuf_wdata[i]), 
				.ch1_sn_err(), /////////错误信号，暂时不用
				.ch1_crc_err(), /////////错误信号，暂时不用 
				.ch1_DA_err(), /////////错误信号，暂时不用 
				.ini_done(init_ok), 
				.station_id(0),//station_id 
				.slot_id(0), //slot_id
				.da_valid(addr_para_ok), 
				.ch1_da(24'd0), //para_addr[i]//////从eeprom里读出的地址，现在eeprom没有数据先赋0
				.ch1_txbuf_rden(),/////////////////// 
				.ch1_txbuf_raddr(ch_txbuf_raddr[i]), 
				.ch1_txbuf_rdata(ch_txbuf_rdata[i]), 
				.clk_phy_p0(clk_100m), 
				.clk_phy_p90(clk_100m_90), 
				.clk_phy_p180(clk_100m_180), 
				.clk_phy_p270(clk_100m_270), 
				.syn_clk(clk_100m), 
				.lb_rxd(clink_rxd[i]),// 
				.lb_txd(clink_txd[i]), 
				.lb_txen(clink_txen[i])
			);
			RAM_2048_8_DP clink_rd_cbus_wr(
				// Inputs
				.A_ADDR({1'b0,lb_rxbuf_wraddr[9:0]}),
				.A_CLK(sys_clk_50m),
				.A_DIN(lb_rxbuf_wrdata),
				.A_WEN(lb_rxbuf_wraddr[i+10] & lb_rxbuf_wren),
				.B_ADDR(ch_txbuf_raddr[i]),
				.B_CLK(sys_clk_50m),
				.B_DIN(8'b0),
				.B_WEN(1'b0),
				// Outputs
				.A_DOUT(),
				.B_DOUT(ch_txbuf_rdata[i])
			);
			RAM_2048_8_DP clink_wr_cbus_rd(
				// Inputs
				.A_ADDR(ch_rx_buf_waddr[i]),
				.A_CLK(sys_clk_50m),
				.A_DIN(ch_rxbuf_wdata[i]),
				.A_WEN(ch_rxbuf_wren[i]),
				.B_ADDR(lb_txbuf_addr_six[i]),
				.B_CLK(sys_clk_50m),
				.B_DIN(8'd0),
				.B_WEN(1'b0),
				// Outputs
				.A_DOUT(),
				.B_DOUT(lb_txbuf_rdata_six[i])
			);
		end
endgenerate

//------------------------------------------------------------------------------                 
//模块调用参考  结束                                                                             
//------------------------------------------------------------------------------                 
                                                                                                 
                                                                                                 
               
                                                                                                 
                                                                                           
                                                                                            
                                                                                                 
                                                                                                 
endmodule                                                                                        
































































































































