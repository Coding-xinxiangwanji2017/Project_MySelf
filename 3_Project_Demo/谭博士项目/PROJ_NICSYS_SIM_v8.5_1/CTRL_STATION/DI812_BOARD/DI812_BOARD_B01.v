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
// Name of module : DI812_BOARD_B01
// Project        : NicSys8000
// Func           : DI812 BOARD 
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

module DI812_BOARD_B01(
    
                                             
    //-----------------------------------------------------------
    //-- Station ID, Rack ID, Slot ID        
    //-----------------------------------------------------------
    input  wire [ 3: 0]        RACK          ,
    input  wire [ 4: 0]        SLOT          ,
                                             
                                             
    //-----------------------------------------------------------
    //-- M-BUS                               
    //-----------------------------------------------------------
                                             
    inout  tri                 MBUS_1_P      ,
    inout  tri                 MBUS_1_N      ,
    inout  tri                 MBUS_2_P      ,
    inout  tri                 MBUS_2_N      ,                
                                             
                                             
    //-----------------------------------------------------------
    //-- L-BUS                               
    //-----------------------------------------------------------
                                             
    inout  tri                 LBUS_B1_P     ,
    inout  tri                 LBUS_B1_N     ,
    inout  tri                 LBUS_B2_P     ,
    inout  tri                 LBUS_B2_N     ,                
                                             
                                             
    //-----------------------------------------------------------
    //-- DI  channel input signal                           
    //-----------------------------------------------------------
                                             
    input  wire                DI_01         ,
    input  wire                DI_02         ,
    input  wire                DI_03         ,
    input  wire                DI_04         ,               
    input  wire                DI_05         ,                                                                                                                                                                                                            
    input  wire                DI_06         ,
    input  wire                DI_07         ,
    input  wire                DI_08         ,
    input  wire                DI_09         , 
    input  wire                DI_10         , 
    input  wire                DI_11         , 
    input  wire                DI_12         , 
    input  wire                DI_13         , 
    input  wire                DI_14         , 
    input  wire                DI_15         , 
    input  wire                DI_16         , 
    input  wire                DI_17         ,
    input  wire                DI_18         ,
    input  wire                DI_19         ,
    input  wire                DI_20         ,
    input  wire                DI_21         ,
    input  wire                DI_22         ,
    input  wire                DI_23         ,
    input  wire                DI_24         ,
    input  wire                DI_25         ,
    input  wire                DI_26         ,
    input  wire                DI_27         ,
    input  wire                DI_28         ,
    input  wire                DI_29         ,
    input  wire                DI_30         ,
    input  wire                DI_31         ,
    input  wire                DI_32         ,                                        
     //----------------------------------------------------------- 
     //-- DI  channel isolation  power                                 
     //----------------------------------------------------------- 
    input  wire                DI_24VA       ,//CHANNEL 1~8
    input  wire                DI_24VB       ,//CHANNEL 9~16
    input  wire                DI_24VC       ,//CHANNEL 17~24
    input  wire                DI_24VD        //CHANNEL 25~32
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
  DI812_UT4_B01 u_DI812_UT4_B01(                                                      
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
    .FP_LED_CHANNEL_01        (),
    .FP_LED_CHANNEL_02        (),
    .FP_LED_CHANNEL_03        (),
    .FP_LED_CHANNEL_04        (),
    .FP_LED_CHANNEL_05        (),
    .FP_LED_CHANNEL_06        (),
    .FP_LED_CHANNEL_07        (),
    .FP_LED_CHANNEL_08        (),
    .FP_LED_CHANNEL_09        (),
    .FP_LED_CHANNEL_10        (),
    .FP_LED_CHANNEL_11        (),
    .FP_LED_CHANNEL_12        (),
    .FP_LED_CHANNEL_13        (),
    .FP_LED_CHANNEL_14        (),
    .FP_LED_CHANNEL_15        (),
    .FP_LED_CHANNEL_16        (),
    .FP_LED_CHANNEL_17        (),
    .FP_LED_CHANNEL_18        (),
    .FP_LED_CHANNEL_19        (),
    .FP_LED_CHANNEL_20        (),
    .FP_LED_CHANNEL_21        (),
    .FP_LED_CHANNEL_22        (),
    .FP_LED_CHANNEL_23        (),
    .FP_LED_CHANNEL_24        (),
    .FP_LED_CHANNEL_25        (),
    .FP_LED_CHANNEL_26        (),
    .FP_LED_CHANNEL_27        (),
    .FP_LED_CHANNEL_28        (),
    .FP_LED_CHANNEL_29        (),
    .FP_LED_CHANNEL_30        (),
    .FP_LED_CHANNEL_31        (),
    .FP_LED_CHANNEL_32        (),
    
    //-----------------------------------------------------------     
    //-- CHANNEL  Power enable                                        
    //-----------------------------------------------------------     
  	.FP_24CH_EN              (),
  	//-----------------------------------------------------------  
  	//-- CHANNEL  Test signal                                      
  	//-----------------------------------------------------------  
  	.FD_TEST_OPEN_01     (),                       
  	.FD_TEST_CLOSE_01    (),                       
  	.FD_TEST_OPEN_02     (),                       
  	.FD_TEST_CLOSE_02    (),                       
  	.FD_TEST_OPEN_03     (),                       
  	.FD_TEST_CLOSE_03    (),                       
  	.FD_TEST_OPEN_04     (),                       
  	.FD_TEST_CLOSE_04    (),                       
  	.FD_TEST_OPEN_05     (),                       
  	.FD_TEST_CLOSE_05    (),                       
  	.FD_TEST_OPEN_06     (),                       
  	.FD_TEST_CLOSE_06    (),                       
  	.FD_TEST_OPEN_07     (),                       
  	.FD_TEST_CLOSE_07    (),                       
  	.FD_TEST_OPEN_08     (),                       
  	.FD_TEST_CLOSE_08    (),                       
  	.FD_TEST_OPEN_09     (),                       
  	.FD_TEST_CLOSE_09    (),                       
  	.FD_TEST_OPEN_10     (),                       
  	.FD_TEST_CLOSE_10    (),                       
  	.FD_TEST_OPEN_11     (),                       
  	.FD_TEST_CLOSE_11    (),                       
  	.FD_TEST_OPEN_12     (),                       
  	.FD_TEST_CLOSE_12    (),                       
  	.FD_TEST_OPEN_13     (),                       
  	.FD_TEST_CLOSE_13    (),                       
  	.FD_TEST_CLOSE_14    (),                       
  	.FD_TEST_OPEN_14     (),                       
  	.FD_TEST_OPEN_15     (),                       
  	.FD_TEST_CLOSE_15    (),                       
  	.FD_TEST_CLOSE_16    (),                       
  	.FD_TEST_OPEN_16     (),                       
  	.FD_TEST_OPEN_17     (),                       
  	.FD_TEST_CLOSE_17    (),                       
  	.FD_TEST_CLOSE_18    (),                       
  	.FD_TEST_OPEN_18     (),                       
  	.FD_TEST_CLOSE_19    (),                       
  	.FD_TEST_OPEN_19     (),                       
  	.FD_TEST_CLOSE_20    (),                       
  	.FD_TEST_OPEN_20     (),                       
  	.FD_TEST_CLOSE_21    (),                       
  	.FD_TEST_OPEN_21     (),                       
  	.FD_TEST_CLOSE_22    (),                       
  	.FD_TEST_OPEN_22     (),                       
  	.FD_TEST_CLOSE_23    (),                       
  	.FD_TEST_OPEN_23     (),                       
  	.FD_TEST_CLOSE_24    (),                       
  	.FD_TEST_OPEN_24     (),                       
  	.FD_TEST_CLOSE_25    (),                       
  	.FD_TEST_OPEN_25     (),                       
  	.FD_TEST_CLOSE_26    (),                       
  	.FD_TEST_OPEN_26     (),                       
  	.FD_TEST_CLOSE_27    (),                       
  	.FD_TEST_OPEN_27     (),                       
  	.FD_TEST_CLOSE_28    (),                       
  	.FD_TEST_OPEN_28     (),                       
  	.FD_TEST_CLOSE_29    (),                       
  	.FD_TEST_OPEN_29     (),                       
  	.FD_TEST_CLOSE_30    (),                       
  	.FD_TEST_OPEN_30     (),                       
  	.FD_TEST_CLOSE_31    (),                       
  	.FD_TEST_OPEN_31     (),                       
  	.FD_TEST_CLOSE_32    (),                       
  	.FD_TEST_OPEN_32     (),     
  	
  	                                                                         
  	 //-----------------------------------------------------------           
  	 //-- CHANNEL  signal  input                                             
  	 //-----------------------------------------------------------           
  	.FP_DIN_01         (),                                        
  	.FP_DIN_02         (),                                        
  	.FP_DIN_03         (),                                        
  	.FP_DIN_04         (),                                        
  	.FP_DIN_05         (),                                        
  	.FP_DIN_06         (),                                        
  	.FP_DIN_07         (),                                        
  	.FP_DIN_08         (),                                        
  	.FP_DIN_09         (),                                        
  	.FP_DIN_10         (),                                        
  	.FP_DIN_11         (),                                        
  	.FP_DIN_12         (),                                        
  	.FP_DIN_13         (),                                        
  	.FP_DIN_14         (),                                        
  	.FP_DIN_15         (),                                        
  	.FP_DIN_16         (),                                        
  	.FP_DIN_17         (),                                        
  	.FP_DIN_18         (),                                        
  	.FP_DIN_19         (),                                        
  	.FP_DIN_20         (),                                        
  	.FP_DIN_21         (),                                                          
  	.FP_DIN_22         (),                                         
  	.FP_DIN_23         (),                                         
  	.FP_DIN_24         (),                                         
  	.FP_DIN_25         (),                                         
  	.FP_DIN_26         (),                                         
  	.FP_DIN_27         (),                                         
  	.FP_DIN_28         (),                                         
  	.FP_DIN_29         (),                                         
  	.FP_DIN_30         (),                                         
  	.FP_DIN_31         (),                                         
  	.FP_DIN_32         (),                                                                                                                           
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
    DI812_UT5_B01 u1_DI812_UT5_B01(                                 
    //-----------------------------------------------------------  
    //-- Global reset, clocks                                      
    //-----------------------------------------------------------  
    .FD_RSTB        (FP_RSTA   ),                                  
    .CLK50MP2       (CLK50MP1  ),                                  
    .CLK_25MD1      (CLK_25MP1 ),                                  
    //-----------------------------------------------------------          
    //-- Power Detector                                                   
    //-----------------------------------------------------------         
    .FDWR_OV       (),                                                    
    .FDWR_UV       (),                                                    
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
    //-- Power signal                                                  
    //-----------------------------------------------------------      
     
     .FD_24CH_EN         (),
     .FD_MNT_24VA        (),
     .FD_MNT_24VD        (),
     .FD_MNT_24VC        (),
     .FD_MNT_24VB        (),
                                                                        
    //-----------------------------------------------------------      
    //-- Channel enable signal                                         
    //-----------------------------------------------------------      
    .FD_DITST_EN_02      (),
    .FD_DITST_EN_04      (),
    .FD_DITST_EN_01      (),
    .FD_DITST_EN_03      (),
    //-----------------------------------------------------------               
    //-- CHANNEL  Test signal                                                                          
    //-----------------------------------------------------------                                      
    .FD_TEST_OPEN_01     (),                                                                           
    .FD_TEST_CLOSE_01    (),                                                                           
    .FD_TEST_OPEN_02     (),                                                                           
    .FD_TEST_CLOSE_02    (),                                                                           
    .FD_TEST_OPEN_03     (),                                                                           
    .FD_TEST_CLOSE_03    (),                                                                           
    .FD_TEST_OPEN_04     (),                                                                           
    .FD_TEST_CLOSE_04    (),                                                                           
    .FD_TEST_OPEN_05     (),                                                                           
    .FD_TEST_CLOSE_05    (),                                                                           
    .FD_TEST_OPEN_06     (),                                                                           
    .FD_TEST_CLOSE_06    (),                                                                           
    .FD_TEST_OPEN_07     (),                                                                           
    .FD_TEST_CLOSE_07    (),                                                                           
    .FD_TEST_OPEN_08     (),                                                                           
    .FD_TEST_CLOSE_08    (),                                                                           
    .FD_TEST_OPEN_09     (),                                                                           
    .FD_TEST_CLOSE_09    (),                                                                           
    .FD_TEST_OPEN_10     (),                                                                           
    .FD_TEST_CLOSE_10    (),                                                                           
    .FD_TEST_OPEN_11     (),                                                                           
    .FD_TEST_CLOSE_11    (),                                                                           
    .FD_TEST_OPEN_12     (),                                                                           
    .FD_TEST_CLOSE_12    (),                                                                           
    .FD_TEST_OPEN_13     (),                                                                           
    .FD_TEST_CLOSE_13    (),                                                                           
    .FD_TEST_CLOSE_14    (),                                                                           
    .FD_TEST_OPEN_14     (),                                                                           
    .FD_TEST_OPEN_15     (),                                                                           
    .FD_TEST_CLOSE_15    (),                                                                           
    .FD_TEST_CLOSE_16    (),                                                                           
    .FD_TEST_OPEN_16     (),                                                                           
    .FD_TEST_OPEN_17     (),                                                                           
    .FD_TEST_CLOSE_17    (),                                                                           
    .FD_TEST_CLOSE_18    (),                                                                           
    .FD_TEST_OPEN_18     (),                                                                           
    .FD_TEST_CLOSE_19    (),                                                                           
    .FD_TEST_OPEN_19     (),                                                                           
    .FD_TEST_CLOSE_20    (),                                                                           
    .FD_TEST_OPEN_20     (),                                                                           
    .FD_TEST_CLOSE_21    (),                                                                           
    .FD_TEST_OPEN_21     (),                                                                           
    .FD_TEST_CLOSE_22    (),                                                                           
    .FD_TEST_OPEN_22     (),                                                                           
    .FD_TEST_CLOSE_23    (),                                                                           
    .FD_TEST_OPEN_23     (),                                                                           
    .FD_TEST_CLOSE_24    (),                                                                           
    .FD_TEST_OPEN_24     (),                                                                           
    .FD_TEST_CLOSE_25    (),                                                                           
    .FD_TEST_OPEN_25     (),                                                                           
    .FD_TEST_CLOSE_26    (),                                                                           
    .FD_TEST_OPEN_26     (),                                                                           
    .FD_TEST_CLOSE_27    (),                                                                           
    .FD_TEST_OPEN_27     (),                                                                           
    .FD_TEST_CLOSE_28    (),                                                                           
    .FD_TEST_OPEN_28     (),                                                                           
    .FD_TEST_CLOSE_29    (),                                                                           
    .FD_TEST_OPEN_29     (),                                                                           
    .FD_TEST_CLOSE_30    (),                                                                           
    .FD_TEST_OPEN_30     (),                                                                           
    .FD_TEST_CLOSE_31    (),                                                                           
    .FD_TEST_OPEN_31     (),                                                                           
    .FD_TEST_CLOSE_32    (),                                                                           
    .FD_TEST_OPEN_32     (),                                                                           
    	                                                                                                   
                                                                                             
     //-----------------------------------------------------------                           
     //-- CHANNEL  signal  input                                                             
     //-----------------------------------------------------------                           
    .FD_DIN_01           (),                                                                   
    .FD_DIN_02           (),                                                                   
    .FD_DIN_03           (),                                                                   
    .FD_DIN_04           (),                                                                   
    .FD_DIN_05           (),                                                                   
    .FD_DIN_06           (),                                                                   
    .FD_DIN_07           (),                                                                   
    .FD_DIN_08           (),                                                                   
    .FD_DIN_09           (),                                             
    .FD_DIN_10           (),                                             
    .FD_DIN_11           (),                                             
    .FD_DIN_12           (),                                             
    .FD_DIN_13           (),                                             
    .FD_DIN_14           (),                                             
    .FD_DIN_15           (),                                             
    .FD_DIN_16           (),                                             
    .FD_DIN_17           (),                                             
    .FD_DIN_18           (),                                             
    .FD_DIN_19           (),                                             
    .FD_DIN_20           (),                                             
    .FD_DIN_21           (),                                             
    .FD_DIN_22           (),                                            
    .FD_DIN_23           (),                                            
    .FD_DIN_24           (),                                            
    .FD_DIN_25           (),                                            
    .FD_DIN_26           (),                                            
    .FD_DIN_27           (),                                            
    .FD_DIN_28           (),                                            
    .FD_DIN_29           (),                                            
    .FD_DIN_30           (),                                            
    .FD_DIN_31           (),                                            
    .FD_DIN_32           (),      
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























































































































