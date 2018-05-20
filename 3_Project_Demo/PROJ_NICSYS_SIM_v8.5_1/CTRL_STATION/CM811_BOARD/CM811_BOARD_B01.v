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
// Name of module : CM811_BOARD_B01
// Project        : NicSys8000
// Func           : CM811 BOARD 
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

`timescale 1ns/100ps

module CM811_BOARD_B01(
    
    //-----------------------------------------------------------
    //-- Station ID, Rack ID, Slot ID        
    //-----------------------------------------------------------
    input  wire [ 3: 0]        RACK             ,
    input  wire [ 4: 0]        SLOT             ,
    input  wire [ 7: 0]        STAT             ,
                                             
                                             
    //-----------------------------------------------------------
    //-- M-BUS                               
    //-----------------------------------------------------------
                                             
    inout  tri                 MBUS_1_P         ,
    inout  tri                 MBUS_1_N         ,
    inout  tri                 MBUS_2_P         ,
    inout  tri                 MBUS_2_N         ,                
                                             
                                             
    //-----------------------------------------------------------
    //-- L-BUS                               
    //-----------------------------------------------------------
                                             
    inout  tri                 LBUS_B1_P        ,
    inout  tri                 LBUS_B1_N        ,
    inout  tri                 LBUS_B2_P        ,
    inout  tri                 LBUS_B2_N        ,                
                                             
    //-----------------------------------------------------------
    //-- R-BUS-A                               
    //-----------------------------------------------------------
                                             
    inout  tri                 RBUS_A1_P        ,      
    inout  tri                 RBUS_A1_N        ,
    inout  tri                 RBUS_A2_P        ,
    inout  tri                 RBUS_A2_N        ,             
                                             
    //-----------------------------------------------------------
    //-- R-BUS-B                              
    //-----------------------------------------------------------
                                             
    inout  tri                 RBUS_B1_P        ,    
    inout  tri                 RBUS_B1_N        ,
    inout  tri                 RBUS_B2_P        ,
    inout  tri                 RBUS_B2_N        ,             
                                             
    //-----------------------------------------------------------
    //-- C-LINK                              
    //-----------------------------------------------------------
                                             
    output wire                    Channel_1_TX_P   ,
    output wire                    Channel_1_TX_N   ,
    input  wire                    Channel_1_RX_P   ,
    input  wire                    Channel_1_RX_N   ,                
    output wire                    Channel_2_TX_P   ,                                                                                                                                                                                                              
    output wire                    Channel_2_TX_N   ,   
    input  wire                    Channel_2_RX_P   ,   
    input  wire                    Channel_2_RX_N   , 
    output wire                    Channel_3_TX_P   ,
    output wire                    Channel_3_TX_N   ,
    input  wire                    Channel_3_RX_P   ,
    input  wire                    Channel_3_RX_N   ,
    output wire                    Channel_4_TX_P   ,
    output wire                    Channel_4_TX_N   ,
    input  wire                    Channel_4_RX_P   ,
    input  wire                    Channel_4_RX_N   ,
    output wire                    Channel_5_TX_P   ,                                     
    output wire                    Channel_5_TX_N   ,
    input  wire                    Channel_5_RX_P   ,
    input  wire                    Channel_5_RX_N   ,
    output wire                    Channel_6_TX_P   ,
    output wire                    Channel_6_TX_N   ,
    input  wire                    Channel_6_RX_P   ,
    input  wire                    Channel_6_RX_N   
                                           
);  
    
    //------------------------------------------------------------------------------          
    //参数声明  开始                                                                          
    //------------------------------------------------------------------------------          
    parameter GND = 1'd0;                                                                     
                                                                                              
    //------------------------------------------------------------------------------          
    //参数声明  结束                                                                          
    //------------------------------------------------------------------------------          
                                                                                              
    //------------------------------------------------------------------------------          
    //内部变量声明  开始                                                                      
    //----------------------------------------------------------------------------------      
    wire             FP_RSTA;                                                                 
    wire             CLK50MP1;                                                                
    wire             CLK_25MP1;                                                               
                                                                                              
                                                                                              
    wire             MB_PREM;                                                                 
    wire             MB_RX1;                                                                  
    wire             MB_TX1;                                                                  
    wire             MB_TXEN1;                                                                
    wire             MB_RX2;                                                                  
    wire             MB_TX2;                                                                  
    wire             MB_TXEN2;                                                                
                                                                                              
                                                                                              
    wire             LB_PREM;                                                                 
    wire             LB_RX1;                                                                  
    wire             LB_TX1;                                                                  
    wire             LB_TXEN1;                                                                
    wire             LB_RX2;                                                                  
    wire             LB_TX2;                                                                  
    wire             LB_TXEN2;  
    
    wire             RA_PREM ;  
    wire             RA_TXEN1 ;   
    wire             RA_TXEN2 ;  
    wire             RA_RX1   ;        
    wire             RA_TX1   ;        
    wire             RA_RX2   ;        
    wire             RA_TX2   ; 
    
    wire             RB_PREM ;   
    wire             RB_TXEN1 ;  
    wire             RB_TXEN2 ;  
    wire             RB_RX1   ;  
    wire             RB_TX1   ;  
    wire             RB_RX2   ;  
    wire             RB_TX2   ;  
                        
    wire             CHANNEL_1_TXPART_TXD_EN       ;
    wire             DFPGA_CHANNEL_1_TXPART_TXD_EN ;
    wire             CHANNEL_1_TXPART_TXD	       ;
    wire             CHANNEL_1_TXPART_RXD          ;
    wire             CHANNEL_1_RXPART_RXD          ;
                                   
    wire             CHANNEL_2_TXPART_TXD_EN       ;
    wire             DFPGA_CHANNEL_2_TXPART_TXD_EN ;
    wire             CHANNEL_2_TXPART_TXD	       ;
    wire             CHANNEL_2_TXPART_RXD          ;
    wire             CHANNEL_2_RXPART_RXD          ;
                                                   
    wire             CHANNEL_3_TXPART_TXD_EN       ;
    wire             DFPGA_CHANNEL_3_TXPART_TXD_EN ;
    wire             CHANNEL_3_TXPART_TXD	       ;
    wire             CHANNEL_3_TXPART_RXD          ;
    wire             CHANNEL_3_RXPART_RXD          ;
                                        
    wire             CHANNEL_4_TXPART_TXD_EN       ;
    wire             DFPGA_CHANNEL_4_TXPART_TXD_EN ;
    wire             CHANNEL_4_TXPART_TXD	       ;
    wire             CHANNEL_4_TXPART_RXD          ;
    wire             CHANNEL_4_RXPART_RXD          ;
                                        
    wire             CHANNEL_5_TXPART_TXD_EN       ;
    wire             DFPGA_CHANNEL_5_TXPART_TXD_EN ;
    wire             CHANNEL_5_TXPART_TXD	       ;
    wire             CHANNEL_5_TXPART_RXD          ;
    wire             CHANNEL_5_RXPART_RXD          ;
                                        
    wire             CHANNEL_6_TXPART_TXD_EN       ;
    wire             DFPGA_CHANNEL_6_TXPART_TXD_EN ;
    wire             CHANNEL_6_TXPART_TXD	       ;
    wire             CHANNEL_6_TXPART_RXD          ;
    wire             CHANNEL_6_RXPART_RXD          ;
                                                                                                                                                                                                                           
    //-- PFPGA <-> DFPGA                                                                      
    wire           FIO_RSTO   ;                                                               
    wire           FIO_CLK    ;                                                               
    wire           FIO_TICK   ;                                                               
    wire           FIO_RSTIN  ;                                                               
    wire           FIO_WE     ;                                                               
    wire  [20:0]   FIO_DAT    ;                                                               
    wire           FIO_DAT21  ;                                                               
    wire           FIO_DAT22  ;                                                               
    wire           FIO_DAT23  ;                                                               
    wire  [2:0]    FIO_CS     ;                                                               
    wire           FIO_RE     ;                                                               
    wire           FIO_ALE    ;                                                               
                                                                                              
//------------------------------------------------------------------------------              
//板卡上FPGA例化 开始                                                                         
//------------------------------------------------------------------------------              
                                                                                              
  //************************************************************                              
  //--  Process FPGA                                                                          
  //************************************************************                              
  CM811_UT4_B01 u_CM811_UT4_B01(                                                              
    //-----------------------------------------------------------                             
    //-- Global reset, clocks                                                                 
    //-----------------------------------------------------------                             
    .FP_RSTA                  (FP_RSTA    ),                                                  
    .CLK_25MP1                (CLK_25MP1  ),                                                  
    .CLK50MP1                 (CLK50MP1   ),                                                  
    //-----------------------------------------------------------                             
    //-- Power Detector                                                                       
    //-----------------------------------------------------------                             
    .FPWR_DPG                 (),//0 is valid                                                  
    //-----------------------------------------------------------                             
    //-- Watchdog                                                                             
    //-----------------------------------------------------------                             
    .FP_WDOA                  (),                                                             
    .FP_WDIA                  (),                                                             
    //.FD_WDOB                (),                                                             
    //-----------------------------------------------------------                             
    //-- Rack ID, Slot ID                                                                     
    //-----------------------------------------------------------                             
    .FDP_RACK                 (RACK  ),                                                       
    .FDP_SLOT                 (SLOT  ),                                                       
    .FDP_STAT                 (STAT  ),                                                                                          
                                                                                              
    //-----------------------------------------------------------                             
    //-- Plug monitor, active low                                                             
    //-----------------------------------------------------------                             
     .PLUG_CON      (),                                                                       
                                                                                              
    //-----------------------------------------------------------                             
    //-- LED indicator                                                                        
    //-----------------------------------------------------------                             
    .FP_LED3                        (), //RUN                                                       
    .FP_LED4                        (), //WARNING                                             
    .FP_ERR_LED                     (), //ERR RED                                                   
    .FP_LED6                        (), //COM                                                       
    .PFPGA_CH_1_TX_LED              (),                                                             
    .PFPGA_CH_1_RX_LED              (),                                                             
    .PFPGA_CH_2_TX_LED              (),                                                             
    .PFPGA_CH_2_RX_LED              (),                                                             
    .PFPGA_CH_3_TX_LED              (),                                                             
    .PFPGA_CH_3_RX_LED              (),                                                             
    .PFPGA_CH_4_TX_LED              (),                                                             
    .PFPGA_CH_4_RX_LED              (),                                                             
    .PFPGA_CH_5_TX_LED              (),                                                             
    .PFPGA_CH_5_RX_LED              (),                                                             
    .PFPGA_CH_6_TX_LED              (),                                                             
    .PFPGA_CH_6_RX_LED              (),                                                             
                                                                                              
  	 //-----------------------------------------------------------                            
  	 //-- C-LINK                                                              
  	 //-----------------------------------------------------------                            
  	                                                                                          
  	.CHANNEL_1_TXPART_TXD_EN        (CHANNEL_1_TXPART_TXD_EN),                                                             
  	.CHANNEL_1_TXPART_TXD	        (CHANNEL_1_TXPART_TXD	),                                                             
  	.CHANNEL_1_TXPART_RXD           (CHANNEL_1_TXPART_RXD   ),                                                             
  	.CHANNEL_1_RXPART_RXD           (CHANNEL_1_RXPART_RXD   ),                                                             
  	                                                                                   
  	.CHANNEL_2_TXPART_TXD_EN        (CHANNEL_2_TXPART_TXD_EN ),                                                             
  	.CHANNEL_2_TXPART_TXD	        (CHANNEL_2_TXPART_TXD	 ),                                                             
  	.CHANNEL_2_TXPART_RXD           (CHANNEL_2_TXPART_RXD    ),                                                             
  	.CHANNEL_2_RXPART_RXD           (CHANNEL_2_RXPART_RXD    ),                                                             
  	                                                                                   
  	.CHANNEL_3_TXPART_TXD_EN        (CHANNEL_3_TXPART_TXD_EN),                                                             
  	.CHANNEL_3_TXPART_TXD	        (CHANNEL_3_TXPART_TXD	),                                                             
  	.CHANNEL_3_TXPART_RXD           (CHANNEL_3_TXPART_RXD   ),                                                             
  	.CHANNEL_3_RXPART_RXD           (CHANNEL_3_RXPART_RXD   ),                                                             
  	                                                                                   
  	.CHANNEL_4_TXPART_TXD_EN        (CHANNEL_4_TXPART_TXD_EN),                                                             
  	.CHANNEL_4_TXPART_TXD	        (CHANNEL_4_TXPART_TXD	),                                                             
  	.CHANNEL_4_TXPART_RXD           (CHANNEL_4_TXPART_RXD   ),                                                             
  	.CHANNEL_4_RXPART_RXD           (CHANNEL_4_RXPART_RXD   ),                                                             
  	                                                                                            	                                                                                          
  	.CHANNEL_5_TXPART_TXD_EN        (CHANNEL_5_TXPART_TXD_EN),                                                             
  	.CHANNEL_5_TXPART_TXD	        (CHANNEL_5_TXPART_TXD	),                                                             
  	.CHANNEL_5_TXPART_RXD           (CHANNEL_5_TXPART_RXD   ),                                                             
  	.CHANNEL_5_RXPART_RXD           (CHANNEL_5_RXPART_RXD   ),                                                             
  	                                                                                          
  	.CHANNEL_6_TXPART_TXD_EN        (CHANNEL_6_TXPART_TXD_EN),                         
  	.CHANNEL_6_TXPART_TXD	        (CHANNEL_6_TXPART_TXD	),                         
  	.CHANNEL_6_TXPART_RXD           (CHANNEL_6_TXPART_RXD   ),                         
  	.CHANNEL_6_RXPART_RXD           (CHANNEL_6_RXPART_RXD   ),                                                 
  	                                                           	                                                       	                                                       	                               	                               	                                  	                                                        	                                                        	                                                        	                                                       	                                                       	                                                       	                                                       	                                                       	                                                       	                                                       	                                                       	                                                       	                                                       	                                                        	                                                        	                                                        	                                                        	                                                        	                                                        	                                                       	                                                        	                                                        	                                                        	                                                                                                                                             
  	//-----------------------------------------------------------                             
    //-- M-BUS                                                                                
    //----------------  -------------------------------------------                           
    //.TICL_MB_PREM       (MB_PREM ),                                                           
                                                                                              
    .TICL_MB_RX1        (MB_RX1  ),                                                           
    .TICL_MB_TX1        (MB_TX1  ),                                                           
    .TICL_MB_TXEN1      (MB_TXEN1),                                                           
                                                                                              
    .TICL_MB_RX2        (MB_RX2  ),                                                           
    .TICL_MB_TX2        (MB_TX2  ),                                                           
    .TICL_MB_TXEN2      (MB_TXEN2),                                                           
                                                                                              
    //-----------------------------------------------------------                             
    //-- L-BUS                                                                                
    //-----------------------------------------------------------                             
    //.TICL_LB_PREM       (LB_PREM ),                                                           
                                                                                              
    .TICL_LB_RX1        (LB_RX1  ),                                                           
    .TICL_LB_TXEN1      (LB_TXEN1),                                                           
    .TICL_LB_TX1        (LB_TX1  ),                                                           
    .TICL_LB_RX2        (LB_RX2  ),                                                           
    .TICL_LB_TXEN2      (LB_TXEN2),                                                           
    .TICL_LB_TX2        (LB_TX2  ),      
                                                         
    //-----------------------------------------------------------                                                                   
    //-- C-BUS                                                                                                                      
    //-----------------------------------------------------------   
    //.MVD_RA_PREM         (RA_PREM),
                                                                        
    .MVD_RA_RX1           (RA_RX1  ),//C-BUS                                                                                        
    .MVD_RA_TXEN1         (RA_TXEN1),                                                                                         
    .MVD_RA_TX1           (RA_TX1  ),                                                                                               
    .MVD_RA_RX2           (RA_RX2  ),                                                                                               
    .MVD_RA_TXEN2         (RA_TXEN2),                                                                                         
    .MVD_RA_TX2           (RA_TX2  ),   
    
    //-----------------------------------------------------------   
    //-- R-BUS                                                      
    //-----------------------------------------------------------   
    //.MVD_RB_PREM         (RB_PREM),                               
                                                                    
    .MVD_RB_RX1           (RB_RX1  ),//R-BUS                        
    .MVD_RB_TXEN1         (RB_TXEN1),                               
    .MVD_RB_TX1           (RB_TX1  ),                               
    .MVD_RB_RX2           (RB_RX2  ),                               
    .MVD_RB_TXEN2         (RB_TXEN2),                               
    .MVD_RB_TX2           (RB_TX2  ),                               
    
                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    //-----------------------------------------------------------                             
    //-- SPI interface , EEPROM AT25512                                                       
    //-----------------------------------------------------------                             
    .FP_E2P_SCK         (),                                                                   
    .FP_E2P_CS          (),                                                                   
    .FP_E2P_SI          (),                                                                   
    .FP_E2P_SO          (),                                                                   
                                                                                              
    //-----------------------------------------------------------                             
    //-- Interface with DFPGA                                                                 
    //-----------------------------------------------------------                             
    .FIO_RSTO             (FIO_RSTO ),//reset dfpga                                           
    .FIO_CLK              (FIO_CLK  ),//clk                                                   
    .FIO_TICK             (FIO_TICK ),//heartbeat out                                         
    .FIO_RSTIN            (FIO_RSTIN),//heartbeat in                                          
    .FIO_WE               (FIO_WE   ),//Wren                                                  
                                                                                              
    .FIO_DAT              (FIO_DAT  ),//[12:0] addr; [20:13] output wire data                 
                                                                                              
    .FIO_DAT21            (FIO_DAT21),//==[7:0] input data                                    
    .FIO_DAT22            (FIO_DAT22),//==[7:0] input data                                    
    .FIO_DAT23            (FIO_DAT23),//==[7:0] input data                                    
    .FIO_CS               (FIO_CS   ),//==[7:0] input data                                    
    .FIO_RE               (FIO_RE   ),//==[7:0] input data                                    
    .FIO_ALE              (FIO_ALE  ),//==[7:0] input data                                    
    //-----------------------------------------------------------                             
    //-- Test pins                                                                            
    //-----------------------------------------------------------                             
    .TEST_T               ()                                                                  
);                                                                                            
                                                                                              
                                                                                              
                                                                                              
//************************************************************                                
//--  Diagnose FPGA                                                                           
//************************************************************                                
    CM811_UT5_B01 u1_CM811_UT5_B01(                                                           
    //-----------------------------------------------------------                             
    //-- Global reset, clocks                                                                 
    //-----------------------------------------------------------                             
    .FD_RSTB        (FP_RSTA   ),                                                             
    .CLK50MP2       (CLK50MP1  ),                                                             
    .CLK_25MD1      (CLK_25MP1 ),                                                             
    //-----------------------------------------------------------                             
    //-- Power Detector                                                                       
    //-----------------------------------------------------------                             
    .FPWR_OV       (),                                                                        
    .FPWR_UV       (),                                                                        
    .FPWR_PG1      (),                                                                        
    .FPWR_PG2      (),                                                                        
    .FPWR_PG3      (),                                                                        
                                                                                              
    //-----------------------------------------------------------                             
    //-- Watchdog                                                                             
    //-----------------------------------------------------------                             
    .FD_WDOB       (),                                                                        
    .FD_WDIB       (),                                                                        
    //.FP_WDOA     ()  ,                                                                      
                                                                                              
    //-----------------------------------------------------------                             
    //--Rack ID, Slot ID                                                                      
    //-----------------------------------------------------------                             
    .FDP_RACK      (RACK),                                                                    
    .FDP_SLOT      (SLOT),   
    .FDP_STAT      (STAT),                                                                  
                                                                                              
    //-----------------------------------------------------------                             
    //-- Plug monitor, active low                                                             
    //-----------------------------------------------------------                             
    .PLUG_CON              (), //1 is not plug; 0 is plug ok                                  
                                                                                              
    //-----------------------------------------------------------                             
    //-- LED indicator                                                                        
    //-----------------------------------------------------------                             
    .FD_LED6               (),                                                                  
                                                                                              
     //-----------------------------------------------------------                                        
     //-- C-LINK                                                                                          
     //-----------------------------------------------------------                                        
                                                                                                                                                                         
    .DFPGA_CHANNEL_1_TXPART_TXD_EN       (DFPGA_CHANNEL_1_TXPART_TXD_EN),                                                                                                 
    .CHANNEL_1_TXPART_TXD	             (CHANNEL_1_TXPART_TXD	       ),                                                                                                 
    .CHANNEL_1_TXPART_RXD                (CHANNEL_1_TXPART_RXD         ),                                                                                                 
    .CHANNEL_1_RXPART_RXD                (CHANNEL_1_RXPART_RXD         ),                                                                                                 
                                                                                                                                        
    .DFPGA_CHANNEL_2_TXPART_TXD_EN       (DFPGA_CHANNEL_2_TXPART_TXD_EN ),                                                                                                 
    .CHANNEL_2_TXPART_TXD	             (CHANNEL_2_TXPART_TXD	        ),                                                                                                 
    .CHANNEL_2_TXPART_RXD                (CHANNEL_2_TXPART_RXD          ),                                                                                                 
    .CHANNEL_2_RXPART_RXD                (CHANNEL_2_RXPART_RXD          ),                                                                                                 
                                                                                                                                        
    .DFPGA_CHANNEL_3_TXPART_TXD_EN       (DFPGA_CHANNEL_3_TXPART_TXD_EN),                                                                                                 
    .CHANNEL_3_TXPART_TXD	             (CHANNEL_3_TXPART_TXD	       ),                                                                                                 
    .CHANNEL_3_TXPART_RXD                (CHANNEL_3_TXPART_RXD         ),                                                                                                 
    .CHANNEL_3_RXPART_RXD                (CHANNEL_3_RXPART_RXD         ),                                                                                                 
                                                                                                                                        
    .DFPGA_CHANNEL_4_TXPART_TXD_EN       (DFPGA_CHANNEL_4_TXPART_TXD_EN),                                                                                                 
    .CHANNEL_4_TXPART_TXD	             (CHANNEL_4_TXPART_TXD	       ),                                                                                                 
    .CHANNEL_4_TXPART_RXD                (CHANNEL_4_TXPART_RXD         ),                                                                                                 
    .CHANNEL_4_RXPART_RXD                (CHANNEL_4_RXPART_RXD         ),                                                                                                 
                                                                                                                                        
    .DFPGA_CHANNEL_5_TXPART_TXD_EN       (DFPGA_CHANNEL_5_TXPART_TXD_EN),                                                                                                 
    .CHANNEL_5_TXPART_TXD	             (CHANNEL_5_TXPART_TXD	       ),                                                                                                 
    .CHANNEL_5_TXPART_RXD                (CHANNEL_5_TXPART_RXD         ),                                                                                                 
    .CHANNEL_5_RXPART_RXD                (CHANNEL_5_RXPART_RXD         ),                                                                                                 
                                                                                                                                        
    .DFPGA_CHANNEL_6_TXPART_TXD_EN       (DFPGA_CHANNEL_6_TXPART_TXD_EN),                                                                                                 
    .CHANNEL_6_TXPART_TXD	             (CHANNEL_6_TXPART_TXD	       ),                                                                                                 
    .CHANNEL_6_TXPART_RXD                (CHANNEL_6_TXPART_RXD         ),                                                                                                 
    .CHANNEL_6_RXPART_RXD                (CHANNEL_6_RXPART_RXD         ),   
    //-----------------------------------------------------------                                                                                                
    //-- M-BUS                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    //-----------------------------------------------------------                                                        
    .TICL_MB_PREM       (MB_PREM ),
                                                                  
    .TICL_MB_RX1        (MB_RX1  ),                                                           
    .TICL_MB_TX1        (MB_TX1  ),                                                           
    .TICL_MB_TXEN1      (MB_TXEN1),                                                           
    .TICL_MB_RX2        (MB_RX2  ),                                                           
    .TICL_MB_TX2        (MB_TX2  ),                                                           
    .TICL_MB_TXEN2      (MB_TXEN2),                                                           
    //-----------------------------------------------------------                             
    //-- L-BUS                                                                                
    //-----------------------------------------------------------                             
    .TICL_LB_PREM       (LB_PREM ),                                                           
                                                                                              
    .TICL_LB_RX1        (LB_RX1  ),                                                           
    .TICL_LB_TXEN1      (LB_TXEN1),                                                           
    .TICL_LB_TX1        (LB_TX1  ),                                                           
    .TICL_LB_RX2        (LB_RX2  ),                                                           
    .TICL_LB_TXEN2      (LB_TXEN2),                                                           
    .TICL_LB_TX2        (LB_TX2  ),     
    
    //-----------------------------------------------------------          
    //-- C-BUS                                                             
    //-----------------------------------------------------------          
                                                                               
     .MVD_RA_PREM         (RA_PREM),                                        
                                                                                                                                                      
    .MVD_RA_RX1           (RA_RX1  ),//C-BUS                               
    .MVD_RA_TXEN1         (RA_TXEN1),                                      
    .MVD_RA_TX1           (RA_TX1  ),                                      
    .MVD_RA_RX2           (RA_RX2  ),                                      
    .MVD_RA_TXEN2         (RA_TXEN2),                                      
    .MVD_RA_TX2           (RA_TX2  ),   
    
    
    //-----------------------------------------------------------       
    //-- R-BUS                                                          
    //-----------------------------------------------------------       
                                                                        
    .MVD_RB_PREM         (RB_PREM),                                    
                                                                       
   .MVD_RB_RX1           (RB_RX1  ),//R-BUS                            
   .MVD_RB_TXEN1         (RB_TXEN1),                                   
   .MVD_RB_TX1           (RB_TX1  ),                                   
   .MVD_RB_RX2           (RB_RX2  ),                                   
   .MVD_RB_TXEN2         (RB_TXEN2),                                   
   .MVD_RB_TX2           (RB_TX2  ),                                   
                                                                        
                                                                                                                                                                                                     
    //-----------------------------------------------------------                             
    //-- Interface with PFPGA                                                                 
    //-----------------------------------------------------------                             
    .FIO_RSTO             (FIO_RSTO ),//reset dfpga                                           
    .FIO_CLK              (FIO_CLK  ),//clk                                                   
    .FIO_TICK             (FIO_TICK ),//heartbeat out                                         
    .FIO_RSTIN            (FIO_RSTIN),//heartbeat in                                          
    .FIO_WE               (FIO_WE   ),//Wren                                                  
    .FIO_DAT              (FIO_DAT  ),//[12:0] addr; [20:13] output wire data                 
    .FIO_DAT21            (FIO_DAT21),//==[7:0] input data                                    
    .FIO_DAT22            (FIO_DAT22),//==[7:0] input data                                    
    .FIO_DAT23            (FIO_DAT23),//==[7:0] input data                                    
    .FIO_CS               (FIO_CS   ),//==[7:0] input data                                    
    .FIO_RE               (FIO_RE   ),//==[7:0] input data                                    
    .FIO_ALE              (FIO_ALE  ),//==[7:0] input data                                    
    //-----------------------------------------------------------                             
    //-- SPI interface ,EEPROM AT25512                                                        
    //-----------------------------------------------------------                             
    .FD_E2P_SCK    (),                                                                        
    .FD_E2P_CS     (),                                                                        
    .FD_E2P_SI     (),                                                                        
    .FD_E2P_SO     (),                                                                        
     //------------------------------------------------------------                           
     //-- Test pins                                                                           
     //-----------------------------------------------------------                            
    .FD_TEST       ()                                                                         
 );                                                                                           
                                                                                              
//------------------------------------------------------------------------------              
//板卡上FPGA例化 结束                                                                         
//------------------------------------------------------------------------------              
                                                                                              
                                                                                              
                                                                                              
//------------------------------------------------------------------------------              
//仿真模块例化 开始                                                                           
//------------------------------------------------------------------------------              
                                                                                              
    //************************************************************                            
    //--  Clock and Reset on board                                                            
    //************************************************************                            
                                                                                              
    //-- 50MHz clock                                                                          
    sysclkgen                                                                                 
     #(                                                                                       
      .CLK_PERIOD   (20 ),                                                                    
      .HIGH_PERIOD  (10 )                                                                     
     )                                                                                        
     u1_sysclkgen                                                                             
     (                                                                                        
      .clk      (CLK50MP1   )                                                                 
     );                                                                                       
                                                                                              
    //-- 25MHz clock                                                                          
    sysclkgen                                                                                 
     #(                                                                                       
      .CLK_PERIOD   (40 ),                                                                    
      .HIGH_PERIOD  (20 )                                                                     
     )                                                                                        
     u2_sysclkgen                                                                             
     (                                                                                        
      .clk      (CLK_25MP1  )                                                                 
     );                                                                                       
                                                                                              
    rstgen                                                                                    
    #(                                                                                        
     .LEVEL    ("LOW"  ),//HIGH,LOW                                                           
     .KEEP     (307    )                                                                      
     )                                                                                        
     u1_rstgen                                                                                
     (                                                                                        
      .rst       (FP_RSTA   )                                                                 
  );                                                                                          
                                                                                              
                                                                                              
  //************************************************************                              
  //--  LVD206D, M-Bus converter                                                              
  //************************************************************                              
                                                                                              
   SN74AUP1G u1_SN74AUP1G(                                                                    
    .A            (MB_TXEN1),                                                                 
    .OE_n         (MB_PREM ),                                                                  
    .Y            (MB_DE1  )                                                                  
    );                                                                                        
                                                                                              
   SN74AUP1G u2_SN74AUP1G(                                                                    
    .A            (MB_TXEN2),                                                                 
    .OE_n         (MB_PREM ),                                                                 
    .Y            (MB_DE2  )                                                                  
    );                                                                                        
                                                                                              
   LVD206D u1_M_BUS_LVD206D(                                                                  
    .D            (MB_TX1  ),                                                                 
    .DE           (MB_DE1  ),                                                                 
    .R            (MB_RX1  ),                                                                 
    .RE_n         (GND     ),                                                                 
    .A            (MBUS_1_P),                                                                 
    .B            (MBUS_1_N)                                                                  
    );                                                                                        
                                                                                              
   LVD206D u2_M_BUS_LVD206D(                                                                  
    .D            (MB_TX2  ),                                                                 
    .DE           (MB_DE2  ),                                                                 
    .R            (MB_RX2  ),                                                                 
    .RE_n         (GND     ),                                                                 
    .A            (MBUS_2_P),                                                                 
    .B            (MBUS_2_N)                                                                  
    );                                                                                        
                                                                                              
   //************************************************************                             
   //--  LVD206D, L-Bus converter                                                             
   //************************************************************                             
                                                                                              
    SN74AUP1G u3_SN74AUP1G(                                                                   
    .A            (LB_TXEN1),                                                                 
    .OE_n         (LB_PREM ),                                                                 
    .Y            (LB_DE1  )                                                                  
    );                                                                                        
                                                                                              
   SN74AUP1G u4_SN74AUP1G(                                                                    
    .A            (LB_TXEN2),                                                                 
    .OE_n         (LB_PREM ),                                                                 
    .Y            (LB_DE2  )                                                                  
    );                                                                                        
                                                                                              
                                                                                              
    LVD206D u1_L_BUS_LVD206D(                                                                 
     .D            (LB_TX1  ),                                                                
     .DE           (LB_DE1  ),                                                                
     .R            (LB_RX1  ),                                                                
     .RE_n         (GND     ),                                                                
     .A            (LBUS_B1_P),                                                               
     .B            (LBUS_B1_N)                                                                
     );                                                                                       
                                                                                              
    LVD206D u2_L_BUS_LVD206D(                                                                 
     .D            (LB_TX2  ),                                                                
     .DE           (LB_DE2  ),                                                                
     .R            (LB_RX2  ),                                                                
     .RE_n         (GND     ),                                                                
     .A            (LBUS_B2_P),                                                               
     .B            (LBUS_B2_N)                                                                
    );                                                                                        
            
    //************************************************************                
    //--  LVD206D, C-Bus converter                                               
    //************************************************************               
                                                                                 
     SN74AUP1G u5_SN74AUP1G(                                                     
     .A            (RA_TXEN1),                                                   
     .OE_n         (RA_PREM ),                                                   
     .Y            (RA_DE1  )                                                    
     );                                                                          
                                                                                 
    SN74AUP1G u6_SN74AUP1G(                                                      
     .A            (RA_TXEN2),                                                   
     .OE_n         (RA_PREM ),                                                   
     .Y            (RA_DE2  )                                                    
     );                                                                          
                                                                                 
                                                                         
     LVD206D u1_C_BUS_LVD206D(                                           
      .D            (RA_TX1  ),                                          
      .DE           (RA_DE1  ),                                          
      .R            (RA_RX1  ),                                          
      .RE_n         (GND     ),                                          
      .A            (RBUS_A1_P),                                         
      
      .B            (RBUS_A1_N)                                          
      );                                                                 
                                                                         
     LVD206D u2_C_BUS_LVD206D(                                           
      .D            (RA_TX2  ),                                          
      .DE           (RA_DE2  ),                                          
      .R            (RA_RX2  ),                                          
      .RE_n         (GND     ),                                          
      .A            (RBUS_A2_P),                                         
      .B            (RBUS_A2_N)     
                                           
     ); 
     
    //************************************************************                 
    //--  LVD206D, R-Bus converter                                                 
    //************************************************************                 
                                                                                   
     SN74AUP1G u7_SN74AUP1G(                                                       
     .A            (RB_TXEN1),                                                     
     .OE_n         (RB_PREM ),                                                     
     .Y            (RB_DE1  )                                                      
     );                                                                            
                                                                                   
    SN74AUP1G u8_SN74AUP1G(                                                        
     .A            (RB_TXEN2),                                                     
     .OE_n         (RB_PREM ),                                                     
     .Y            (RB_DE2  )                                                      
     );                                                                            
                                                                                   
                                                                                   
     LVD206D u1_R_BUS_LVD206D(                                                     
      .D            (RB_TX1  ),                                                    
      .DE           (RB_DE1  ),                                                    
      .R            (RB_RX1  ),                                                    
      .RE_n         (GND     ),                                                    
      .A            (RBUS_B1_P),                                                   
                                                                                   
      .B            (RBUS_B1_N)                                                    
      );                                                                           
                                                                                   
     LVD206D u2_R_BUS_LVD206D(                                                     
      .D            (RB_TX2  ),                                                    
      .DE           (RB_DE2  ),                                                    
      .R            (RB_RX2  ),                                                    
      .RE_n         (GND     ),                                                    
      .A            (RBUS_B2_P),                                                   
      .B            (RBUS_B2_N)                                                    
                                                                                   
     );                                                                            
                              
     
    //************************************************************   
    //--  LVD206D, C-lINK converter                                   
    //************************************************************   
     SN74AUP1G u9_SN74AUP1G(     
     .A            (CHANNEL_1_TXPART_TXD_EN),   
     .OE_n         (DFPGA_CHANNEL_1_TXPART_TXD_EN  ),   
     .Y            (CHANNEL_1_TX_DE1  )    
     );                          
                                 
     LVD206D u1_CHANNEL_1_TX_LVD206D(  
      .D            (CHANNEL_1_TXPART_TXD ), 
      .DE           (CHANNEL_1_TX_DE1 ), 
      .R            (CHANNEL_1_TXPART_RXD  ), 
      .RE_n         (GND     ), 
      .A            (Channel_1_TX_P),
      .B            (Channel_1_TX_N) 
      );                          
     LVD206D u1_CHANNEL_1_RX_LVD206D(   
      .D            (GND  ),  
      .DE           (GND  ),  
      .R            (CHANNEL_1_RXPART_RXD  ),  
      .RE_n         (GND     ),  
      .A            (Channel_1_RX_P), 
      .B            (Channel_1_RX_N)  
      );                         
      SN74AUP1G u10_SN74AUP1G(     
     .A            (CHANNEL_2_TXPART_TXD_EN),   
     .OE_n         (DFPGA_CHANNEL_2_TXPART_TXD_EN  ),   
     .Y            (CHANNEL_2_TX_DE1  )    
     );                          
                                 
     LVD206D u1_CHANNEL_2_TX_LVD206D(  
      .D            (CHANNEL_2_TXPART_TXD ), 
      .DE           (CHANNEL_2_TX_DE1 ), 
      .R            (CHANNEL_2_TXPART_RXD  ), 
      .RE_n         (GND     ), 
      .A            (Channel_2_TX_P),
      .B            (Channel_2_TX_N) 
      );                          
     LVD206D u1_CHANNEL_2_RX_LVD206D(   
      .D            (GND  ),  
      .DE           (GND  ),  
      .R            (CHANNEL_2_RXPART_RXD  ),  
      .RE_n         (GND     ),  
      .A            (Channel_2_RX_P), 
      .B            (Channel_2_RX_N)  
      );                         
     
      SN74AUP1G u11_SN74AUP1G(     
     .A            (CHANNEL_3_TXPART_TXD_EN),   
     .OE_n         (DFPGA_CHANNEL_3_TXPART_TXD_EN  ),   
     .Y            (CHANNEL_3_TX_DE1  )    
     );                          
                                 
     LVD206D u1_CHANNEL_3_TX_LVD206D(  
      .D            (CHANNEL_3_TXPART_TXD ), 
      .DE           (CHANNEL_3_TX_DE1 ), 
      .R            (CHANNEL_3_TXPART_RXD  ), 
      .RE_n         (GND     ), 
      .A            (Channel_3_TX_P),
      .B            (Channel_3_TX_N) 
      );                          
     LVD206D u1_CHANNEL_3_RX_LVD206D(   
      .D            (GND  ),  
      .DE           (GND  ),  
      .R            (CHANNEL_3_RXPART_RXD  ),  
      .RE_n         (GND     ),  
      .A            (Channel_3_RX_P), 
      .B            (Channel_3_RX_N)  
      );                         
     
      SN74AUP1G u12_SN74AUP1G(     
     .A            (CHANNEL_4_TXPART_TXD_EN),   
     .OE_n         (DFPGA_CHANNEL_4_TXPART_TXD_EN  ),   
     .Y            (CHANNEL_4_TX_DE1  )    
     );                          
                                 
     LVD206D u1_CHANNEL_4_TX_LVD206D(  
      .D            (CHANNEL_4_TXPART_TXD ), 
      .DE           (CHANNEL_4_TX_DE1 ), 
      .R            (CHANNEL_4_TXPART_RXD  ), 
      .RE_n         (GND     ), 
      .A            (Channel_4_TX_P),
      .B            (Channel_4_TX_N) 
      );                          
     LVD206D u1_CHANNEL_4_RX_LVD206D(   
      .D            (GND  ),  
      .DE           (GND  ),  
      .R            (CHANNEL_4_RXPART_RXD  ),  
      .RE_n         (GND     ),  
      .A            (Channel_4_RX_P), 
      .B            (Channel_4_RX_N)  
      );                         
     
      SN74AUP1G u13_SN74AUP1G(     
     .A            (CHANNEL_5_TXPART_TXD_EN),   
     .OE_n         (DFPGA_CHANNEL_5_TXPART_TXD_EN  ),   
     .Y            (CHANNEL_5_TX_DE1  )    
     );                          
                                 
     LVD206D u1_CHANNEL_5_TX_LVD206D(  
      .D            (CHANNEL_5_TXPART_TXD ), 
      .DE           (CHANNEL_5_TX_DE1 ), 
      .R            (CHANNEL_5_TXPART_RXD  ), 
      .RE_n         (GND     ), 
      .A            (Channel_5_TX_P),
      .B            (Channel_5_TX_N) 
      );                          
     LVD206D u1_CHANNEL_5_RX_LVD206D(   
      .D            (GND  ),  
      .DE           (GND  ),  
      .R            (CHANNEL_5_RXPART_RXD  ),  
      .RE_n         (GND     ),  
      .A            (Channel_5_RX_P), 
      .B            (Channel_5_RX_N)  
      );                         
     
      SN74AUP1G u14_SN74AUP1G(     
     .A            (CHANNEL_6_TXPART_TXD_EN),   
     .OE_n         (DFPGA_CHANNEL_6_TXPART_TXD_EN  ),   
     .Y            (CHANNEL_6_TX_DE1  )    
     );                          
                                 
     LVD206D u1_CHANNEL_6_TX_LVD206D(  
      .D            (CHANNEL_6_TXPART_TXD ), 
      .DE           (CHANNEL_6_TX_DE1 ), 
      .R            (CHANNEL_6_TXPART_RXD  ), 
      .RE_n         (GND     ), 
      .A            (Channel_6_TX_P),
      .B            (Channel_6_TX_N) 
      );                          
     LVD206D u1_CHANNEL_6_RX_LVD206D(   
      .D            (GND  ),  
      .DE           (GND  ),  
      .R            (CHANNEL_6_RXPART_RXD  ),  
      .RE_n         (GND     ),  
      .A            (Channel_6_RX_P), 
      .B            (Channel_6_RX_N)  
      );                         
                                                  
         
                                                    
                                                                                                                                                                                                                                                                                                                                                         
                                                                                                
//------------------------------------------------------------------------------              
//仿真模块例化 结束                                                                           
//------------------------------------------------------------------------------              
                                                                                              
                                                                                              
                                                                                              
                                                                                              
//------------------------------------------------------------------------------              
//逻辑参考  开始                                                                              
//------------------------------------------------------------------------------              
                                                                                              
                                                                                              
                                                                                              
//------------------------------------------------------------------------------              
//逻辑参考  结束                                                                              
//------------------------------------------------------------------------------              
                                                                                              
                                                                                              
                                                                                              
                                                                                              
                                                                                              
                                                                                              
endmodule                                                                                     
                                                                                              