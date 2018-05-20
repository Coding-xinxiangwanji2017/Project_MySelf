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
// Name of module : AO811_BOARD_B01
// Project        : NicSys8000
// Func           : AO811 BOARD 
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

module AO811_BOARD_B01(
    
                                             
    //-----------------------------------------------------------
    //-- Rack ID, Slot ID        
    //-----------------------------------------------------------
    input  wire [ 3: 0]        RACK               ,
    input  wire [ 4: 0]        SLOT               ,
                                             
                                             
    //-----------------------------------------------------------
    //-- M-BUS                               
    //-----------------------------------------------------------
                                             
    inout  tri                 MBUS_1_P           ,
    inout  tri                 MBUS_1_N           ,
    inout  tri                 MBUS_2_P           ,
    inout  tri                 MBUS_2_N           ,                
                                             
                                             
    //-----------------------------------------------------------
    //-- L-BUS                               
    //-----------------------------------------------------------
                                             
    inout  tri                 LBUS_B1_P          ,
    inout  tri                 LBUS_B1_N          ,
    inout  tri                 LBUS_B2_P          ,
    inout  tri                 LBUS_B2_N          ,                
                                             
                                             
    //-----------------------------------------------------------
    //-- AO  channel output signal                           
    //-----------------------------------------------------------
                                             
    output wire                VOUT1              ,
    output wire                COM1               ,
    output wire                IOUT1              ,
    output wire                VOUT2              ,               
    output wire                COM2               ,                                                                                                                                                                                                            
    output wire                IOUT2              ,
    output wire                VOUT3              ,
    output wire                COM3               ,
    output wire                IOUT3              , 
    output wire                VOUT4              , 
    output wire                COM4               , 
    output wire                IOUT4              , 
    output wire                VOUT5              , 
    output wire                COM5               , 
    output wire                IOUT5              , 
    output wire                VOUT6              ,      
    output wire                COM6               ,
    output wire                IOUT6              ,
    output wire                VOUT7              ,
    output wire                COM7               ,
    output wire                IOUT7              ,
    output wire                VOUT8              ,
    output wire                COM8               ,
    output wire                IOUT8              
                                            
   
);                                                



    //----------------------------------------------------------------------------
    //参数声明  开始                                                              
    //----------------------------------------------------------------------------
    parameter GND = 1'd0;                                                         
                                                                                  
    //----------------------------------------------------------------------------
    //参数声明  结束                                                              
    //----------------------------------------------------------------------------
                                                                                  
    //----------------------------------------------------------------------------
    //内部变量声明  开始                                                          
    //----------------------------------------------------------------------------
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
  AO811_UT4_B01 u_AO811_UT4_B01(                                                                                                                                                                                    
    //-----------------------------------------------------------                                                                                                                                                   
    //-- Global reset, clocks                                                                                                                                                                                       
    //-----------------------------------------------------------                                                                                                                                                   
    .FP_RSTA                  (FP_RSTA  ),                                                                                                                                                                        
    .CLK_25MP1                (CLK_25MP1),                                                                                                                                                                        
    .CLK50MP1                 (CLK50MP1 ),                                                                                                                                                                        
    //-----------------------------------------------------------                                                                                                                                                   
    //-- Power Detector                                                                                                                                                                                             
    //-----------------------------------------------------------                                                                                                                                                   
    .DPWR_PG                 (),//0 is valid                                                                                                                                                                        
    //-----------------------------------------------------------                                                                                                                                                   
    //-- Watchdog                                                                                                                                                                                                   
    //-----------------------------------------------------------                                                                                                                                                   
    .FP_WDOA                  (),                                                                                                                                                                                   
    .FP_WDIA                  (),                                                                                                                                                                                   
    //.FD_WDOB                (),                                                                                                                                                                                   
    //-----------------------------------------------------------                                                                                                                                                   
    //-- Rack ID, Slot ID                                                                                                                                                                                           
    //-----------------------------------------------------------                                                                                                                                                   
    .FDP_RACK                 (RACK),                                                                                                                                                                             
    .FDP_SLOT                 (SLOT),                                                                                                                                                                             
                                                                                                                                                                                                                    
                                                                                                                                                                                                                    
    //-----------------------------------------------------------                                                                                                                                                   
    //-- Plug monitor, active low                                                                                                                                                                                   
    //-----------------------------------------------------------                                                                                                                                                   
     .PLUG_MON      (),                                                                                                                                                                                             
                                                                                                                                                                                                                    
    //-----------------------------------------------------------                                                                                                                                                   
    //-- LED indicator                                                                                                                                                                                              
    //-----------------------------------------------------------                                                                                                                                                   
    .FP_LED3                  (), //RUN                                                                                                                                                                             
    .FP_LED4                  (), //WARNING YELLOW                                                                                                                                                                  
    .FP_ERR_LED               (), //ERR RED                                                                                                                                                                         
    .FP_LED6                  (), //COM                                                                                                                                                                             
    .PF_LED_CHANNEL_01        (),                                                                                                                                                                                   
    .PF_LED_CHANNEL_02        (),                                                                                                                                                                                   
    .PF_LED_CHANNEL_03        (),                                                                                                                                                                                   
    .PF_LED_CHANNEL_04        (),                                                                                                                                                                                   
    .PF_LED_CHANNEL_05        (),                                                                                                                                                                                   
    .PF_LED_CHANNEL_06        (),                                                                                                                                                                                   
    .PF_LED_CHANNEL_07        (),                                                                                                                                                                                   
    .PF_LED_CHANNEL_08        (),                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
  	 //-----------------------------------------------------------                                                                                                                                                  
  	 //-- CHANNEL  signal  input                                                                                                                                                                                    
  	 //-----------------------------------------------------------                                                                                                                                                  
  	                                                                                                                                                                                                                
  	.F_D_SDO_A                (),                                                                                                                                                                                   
  	.F_D_SDIN_A               (),                                                                                                                                                                                   
  	.F_D_SCLK_A               (),                                                                                                                                                                                   
  	.F_D_CS_A                 (),                                                                                                                                                                                   
  	                                                                                                                                                                                                                
  	.F_D_SDO_B                (),                                                                                                                                                                                   
  	.F_D_SDIN_B               (),                                                                                                                                                                                   
  	.F_D_SCLK_B               (),                                                                                                                                                                                   
  	.F_D_CS_B                 (),                                                                                                                                                                                   
  	                                                                                                                                                                                                                
  	.F_D_SDO_C                (),                                                                                                                                                                                   
  	.F_D_SDIN_C               (),                                                                                                                                                                                   
  	.F_D_SCLK_C               (),                                                                                                                                                                                   
  	.F_D_CS_C                 (),                                                                                                                                                                                   
  	                                                                                                                                                                                                                 
  	.F_D_SDO_D                (),                                                                                                                                                                                   
  	.F_D_SDIN_D               (),                                                                                                                                                                                   
  	.F_D_SCLK_D               (),                                                                                                                                                                                   
  	.F_D_CS_D                (),                                                                                                                                                                                   
  	                                                                                                                                                                                                                
  	                                                                                                                                                                                                                
  	.F_D_SDO_E                (),                                                                                                                                                                                   
  	.F_D_SDIN_E               (),                                                                                                                                                                                   
  	.F_D_SCLK_E               (),                                                                                                                                                                                   
  	.F_D_CS_E                 (),                                                                                                                                                                                   
  	                                                                                                                                                                                                                 
  	.F_D_CS_F                 (),                                                                                                                                                                                   
  	.F_D_SCLK_F               (),                                                                                                                                                                                   
  	.F_D_SDIN_F               (),                                                                                                                                                                                   
  	.F_D_SDO_F                (),                                                                                                                                                                                   
  	                                                                                                                                                                                                                
  	.F_D_CS_G                 (),                                                                                                                                                                                   
  	.F_D_SCLK_G               (),                                                                                                                                                                                   
  	.F_D_SDIN_G               (),                                                                                                                                                                                   
  	.F_D_SDO_G                (),                                                                                                                                                                                   
  	                                                                                                                                                                                                               
  	.F_D_CS_H                 (),                                                                                                                                                                                   
  	.F_D_SCLK_H               (),                                                                                                                                                                                   
  	.F_D_SDIN_H               (),                                                                                                                                                                                   
  	.F_D_SDO_H                (),       
  	                          
  	//----------------------------------------------------------- 
  	//-- CHannel Read-backward                                    
  	//----------------------------------------------------------- 
  	
  	.F_A_CS_A                 (),
  	.F_A_SCLK_A               (),
  	.F_A_SDIN_A               (),
  	.F_A_SDO_A                (),
  	                        
  	.F_A_CS_B                 (),
  	.F_A_SCLK_B               (),
  	.F_A_SDIN_B               (),
  	.F_A_SDO_B                (),
  	                         
  	.F_A_CS_C                 (),
  	.F_A_SCLK_C               (),
  	.F_A_SDIN_C               (),
  	.F_A_SDO_C                (),
  	                        
  	.F_A_CS_D                 (),
  	.F_A_SCLK_D               (),
  	.F_A_SDIN_D               (),
  	.F_A_SDO_D                (),
  	                          
  	.F_A_CS_E                 (),                                                                                                                                                               
  	.F_A_SCLK_E               (),                                                                                                                                                                                                   
  	.F_A_SDIN_E               (),                                                                                                                                                               
  	.F_A_SDO_E                (),                                                                                                                                                               
  	                                                                                                                                                                                   
  	.F_A_SDO_F                (),                                                                                                                                                               
  	.F_A_SDIN_F               (),                                                                                                                                                               
  	.F_A_SCLK_F               (),                                                                                                                                                               
  	.F_A_CS_F                 (),                                                                                                                                                               
  	                                                                                                                                                                                      
  	.F_A_SDO_G                (),                                                                                                                                                               
  	.F_A_SDIN_G               (),                                                                                                                                                               
  	.F_A_SCLK_G               (),                                                                                                                                                               
  	.F_A_CS_G                 (),                                                                                                                                                               
  	                                                                                                                                                                                    
  	.F_A_SDO_H                (),                                                                                                                                                               
  	.F_A_SDIN_H               (),                                                                                                                                                               
  	.F_A_SCLK_H               (),                                                                                                                                                               
  	.F_A_CS_H                 (),                                                                                                                                                               
  	                                                                                                                                                                            
  	                                                                                                                                                                                                                                                                                                                                                                                           
  	//-----------------------------------------------------------                                                                                                                                                   
    //-- M-BUS                                                                                                                                                                                                      
    //----------------  -------------------------------------------                                                                                                                                                 
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
    AO811_UT5_B01 u1_AO811_UT5_B01(                                                                                                                                                                                 
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
                                                                                                                                                                                                                    
    //-----------------------------------------------------------                                                                                                                                                   
    //-- Plug monitor, active low                                                                                                                                                                                   
    //-----------------------------------------------------------                                                                                                                                                   
    .PLUG_MON              (), //1 is not plug; 0 is plug ok                                                                                                                                                        
                                                                                                                                                                                                                    
    //-----------------------------------------------------------                                                                                                                                                   
    //-- LED indicator                                                                                                                                                                                              
    //-----------------------------------------------------------                                                                                                                                                   
    .FD_LED4             (),                                                                                                                                                                                        
    //-----------------------------------------------------------                                                                                                                                                                                                                                                                        
    //-- CHannel Read-backward                                                                                                                                                                                                                                            
    //-----------------------------------------------------------                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                          
    .F_A_CS_A                 (),                                                                                                                                                                                                                                                                                                        
    .F_A_SCLK_A               (),                                                                                                                                                                                                                                                                     
    .F_A_SDIN_A               (),                                                                                                                                                                                                                                                                     
    .F_A_SDO_A                (),                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                      
    .F_A_CS_B                 (),                                                                                                                                                                                                                                                                     
    .F_A_SCLK_B               (),                                                                                                                                                                                                                                                                     
    .F_A_SDIN_B               (),                                                                                                                                                                                                                                                                     
    .F_A_SDO_B                (),                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                      
    .F_A_CS_C                 (),                                                                                                                                                                                                                                                                     
    .F_A_SCLK_C               (),                                                                                                                                                                                                                                                                     
    .F_A_SDIN_C               (),                                                                                                                                                                                                                                                                     
    .F_A_SDO_C                (),                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                      
    .F_A_CS_D                 (),                                                                                                                                                                                                                                                                     
    .F_A_SCLK_D               (),                                                                                                                                                                                                                                                                     
    .F_A_SDIN_D               (),                                                                                                                                                                                                                                                                     
    .F_A_SDO_D                (),                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                      
    .F_A_CS_E                 (),                                                                                                                                                                                                                                                                     
    .F_A_SCLK_E               (),                                                                                                                                                                                                                                                                     
    .F_A_SDIN_E               (),                                                                                                                                                                                                                                                                     
    .F_A_SDO_E                (),                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                      
    .F_A_SDO_F                (),                                                                                                                                                                                                                                                                     
    .F_A_SDIN_F               (),                                                                                                                                                                                                                                                                     
    .F_A_SCLK_F               (),                                                                                                                                                                                                                                                                     
    .F_A_CS_F                 (),                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                      
    .F_A_SDO_G                (),                                                                                                                                                                                                                                                                     
    .F_A_SDIN_G               (),                                                                                                                                                                                                                                                                     
    .F_A_SCLK_G               (),                                                                                                                                                                                                                                                                     
    .F_A_CS_G                 (),                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                      
    .F_A_SDO_H                (),                                                                                                                                                                                                                                                                     
    .F_A_SDIN_H               (),                                                                                                                                                                                                                                                                     
    .F_A_SCLK_H               (),                                                                                                                                                                                                                                                                     
    .F_A_CS_H                 (),                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
   //-----------------------------------------------------------                                                                                                                                                                                                                   
   //-- M-BUS                                                                                                                                                                                                        
   //-----------------------------------------------------------                                                                                                                                                     
    .TICL_MB_PREM       (MB_PREM ),                                                                                                                                                                                 
    .TICL_MB_RX1        (MB_RX1  ),                                                                                                                                                                                 
    .TICL_MB_TX1        (  ),          //MB_TX1                                                                                                                                                                       
    .TICL_MB_TXEN1      (),            //MB_TXEN1                                                                                                                                                                     
    .TICL_MB_RX2        (MB_RX2  ),                                                                                                                                                                                 
    .TICL_MB_TX2        (  ),          //MB_TX2                                                                                                                                                                       
    .TICL_MB_TXEN2      (),            //MB_TXEN2                                                                                                                                                                     
    //-----------------------------------------------------------                                                                                                                                                   
    //-- L-BUS                                                                                                                                                                                                      
    //-----------------------------------------------------------                                                                                                                                                   
    .TICL_LB_PREM       (LB_PREM ),                                                                                                                                                                                 
                                                                                                                                                                                                                    
    .TICL_LB_RX1        (LB_RX1  ),                                                                                                                                                                                 
    .TICL_LB_TXEN1      (),            //LB_TXEN1                                                                                                                                                                     
    .TICL_LB_TX1        (  ),          //LB_TX1                                                                                                                                                                       
    .TICL_LB_RX2        (LB_RX2  ),                                                                                                                                                                                 
    .TICL_LB_TXEN2      (),            //LB_TXEN2                                                                                                                                                                     
    .TICL_LB_TX2        (  ),          //LB_TX2                                                                                                                                                                       
                                                                                                                                                                                                                    
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
                                                                                                                           