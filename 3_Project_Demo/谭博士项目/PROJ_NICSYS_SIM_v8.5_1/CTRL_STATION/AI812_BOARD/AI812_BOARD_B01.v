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
// Name of module : AI812_BOARD_B01
// Project        : NicSys8000
// Func           : AI812 BOARD 
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

module AI812_BOARD_B01(
    
                                             
    //-----------------------------------------------------------
    //-- Station ID, Rack ID, Slot ID        
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
    //-- AI  channel input signal                           
    //-----------------------------------------------------------
                                             
    input  wire                Current_IN_1       ,
    input  wire                COM_IN_1           ,
    input  wire                Voltage_IN_1       ,
    input  wire                Current_IN_2       ,               
    input  wire                COM_IN_2           ,                                                                                                                                                                                                            
    input  wire                Voltage_IN_2       ,
    input  wire                Current_IN_3       ,
    input  wire                COM_IN_3           ,
    input  wire                Voltage_IN_3       , 
    input  wire                Current_IN_4       , 
    input  wire                COM_IN_4           , 
    input  wire                Voltage_IN_4       , 
    input  wire                Current_IN_5       , 
    input  wire                COM_IN_5           , 
    input  wire                Voltage_IN_5       , 
    input  wire                Current_IN_6       , 
    input  wire                COM_IN_6           ,
    input  wire                Voltage_IN_6       ,
    input  wire                Current_IN_7       ,
    input  wire                COM_IN_7           ,
    input  wire                Voltage_IN_7       ,
    input  wire                Current_IN_8       ,
    input  wire                COM_IN_8           ,
    input  wire                Voltage_IN_8       ,
    input  wire                Current_IN_9       ,
    input  wire                COM_IN_9           ,
    input  wire                Voltage_IN_9       ,
    input  wire                Current_IN_10      ,
    input  wire                COM_IN_10          ,
    input  wire                Voltage_IN_10      ,       
    input  wire                Current_IN_11      ,
    input  wire                COM_IN_11          ,
    input  wire                Voltage_IN_11      ,
    input  wire                Current_IN_12      ,
    input  wire                COM_IN_12          ,                                        
    input  wire                Voltage_IN_12      
      
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
                                     
  assign MB_PREM = 1'b0;
  assign LB_PREM = 1'b0;                                   
                                                                                                         
//------------------------------------------------------------------------------           
//板卡上FPGA例化 开始                                                                      
//------------------------------------------------------------------------------           
                                                                                           
  //************************************************************                           
  //--  Process FPGA                                                                       
  //************************************************************                           
  AI812_UT4_B01 u_AI812_UT4_B01(                                                           
    //-----------------------------------------------------------                          
    //-- Global reset, clocks                                                              
    //-----------------------------------------------------------                          
    .FP_RSTA                  (FP_RSTA    ),                                               
    .CLK_25MP1                (CLK_25MP1  ),                                               
    .CLK50MP1                 (CLK50MP1   ),                                               
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                    	  	                           	                           	                           	                           	                           	                          	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                          	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                           	                          	                          	                                                                                       
  	 //-----------------------------------------------------------                         
  	 //-- CHANNEL  signal  input                                                           
  	 //-----------------------------------------------------------                         
  	                                                        
  	.SPI_DOUT_A               (),                                        
  	.SPI_DIN_A                (),                                        
  	.SPI_SCLK_A               (),                                        
  	.SPI_CS_A                 (),                                           
  	                                                              
  	.SPI_DOUT_B               (),                                           
  	.SPI_DIN_B                (),                                           
  	.SPI_SCLK_B               (),                                           
  	.SPI_CS_B                 (),                                           
  	                                                               
  	.SPI_DOUT_C               (),                                           
  	.SPI_DIN_C                (),                                         
  	.SPI_SCLK_C               (),                                         
  	.SPI_CS_C                 (),                                         
  	                                                                
  	.SPI_DOUT_D               (),                                           
  	.SPI_DIN_D                (),                                           
  	.SPI_SCLK_D               (),                                           
  	.SPI_CS_D                 (),                                           
  	                                                                 
  	                                                              
  	.SPI_DOUT_E               (),                                         
  	.SPI_DIN_E                (),                                         
  	.SPI_SCLK_E               (),                                         
  	.SPI_CS_E                 (),                                         
  	                                                                
  	.SPI_DOUT_F               (),                                         
  	.SPI_DIN_F                (),                                         
  	.SPI_SCLK_F               (),                                         
  	.SPI_CS_F                 (),                                         
  	                          
  	.SPI_CS_G                 (),
  	.SPI_SCLK_G               (),
  	.SPI_DIN_G                (),
  	.SPI_DOUT_G               (),
  	           
  	.SPI_CS_H                 (), 
  	.SPI_SCLK_H               (), 
  	.SPI_DIN_H                (), 
  	.SPI_DOUT_H               (), 
  	                              
  	.SPI_CS_J                 (), 
  	.SPI_SCLK_J               (), 
  	.SPI_DIN_J                (), 
  	.SPI_DOUT_J               (), 
  	                              
  	.SPI_CS_K                 (), 
  	.SPI_SCLK_K               (), 
  	.SPI_DIN_K                (), 
  	.SPI_DOUT_K               (), 
  	                         
  	.SPI_CS_L                 (),    
  	.SPI_SCLK_L               (), 
  	.SPI_DIN_L                (), 
  	.SPI_DOUT_L               (), 
  	                              
  	.SPI_CS_M                 (),    
  	.SPI_SCLK_M               (), 
  	.SPI_DIN_M                (), 
  	.SPI_DOUT_M               (), 
  	                           
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
    AI812_UT5_B01 u1_AI812_UT5_B01(                                                            
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
    //-- CHANNEL  signal  input                                                                                 
    //-----------------------------------------------------------                                               
                                                                                                                 
    .SPI_DOUT_A               (),                                                                                
    .SPI_DIN_A                (),                                                                                
    .SPI_SCLK_A               (),                                                                                
    .SPI_CS_A                 (),                                                                                
                                                                                                                 
    .SPI_DOUT_B               (),                                                                                
    .SPI_DIN_B                (),                                                                                
    .SPI_SCLK_B               (),                                                                                
    .SPI_CS_B                 (),                                                                                
                                                                                                                 
    .SPI_DOUT_C               (),                                                                                
    .SPI_DIN_C                (),                                                                                
    .SPI_SCLK_C               (),                                                                                
    .SPI_CS_C                 (),                                                                                
                                                                                                                 
    .SPI_DOUT_D               (),                                                                                
    .SPI_DIN_D                (),                                                                                
    .SPI_SCLK_D               (),                                                                                
    .SPI_CS_D                 (),                                                                                
                                                                                                                 
                                                                                                          
    .SPI_DOUT_E               (),                                                                                
    .SPI_DIN_E                (),                                                                                
    .SPI_SCLK_E               (),                                                                                
    .SPI_CS_E                 (),                                                                                
                                                                                                                 
    .SPI_DOUT_F               (),                                                                                
    .SPI_DIN_F                (),                                                                                
    .SPI_SCLK_F               (),                                                                                
    .SPI_CS_F                 (),                                                                                
                                                                                                                 
    .SPI_CS_G                 (),                                                                                
    .SPI_SCLK_G               (),                                                                                
    .SPI_DIN_G                (),                                                                                
    .SPI_DOUT_G               (),                                                                                
                                                                                                                 
    .SPI_CS_H                 (),                                                                                
    .SPI_SCLK_H               (),                                                                                
    .SPI_DIN_H                (),                                                                                
    .SPI_DOUT_H               (),                                                                                
                                                                                                                 
    .SPI_CS_J                 (),                                                                                
    .SPI_SCLK_J               (),                                                                                
    .SPI_DIN_J                (),                                                                                
    .SPI_DOUT_J               (),                                                                                
                                                                                                                 
    .SPI_CS_K                 (),                                                                                
    .SPI_SCLK_K               (),                                                                                
    .SPI_DIN_K                (),                                                                                
    .SPI_DOUT_K               (),                                                                                
                                                                                                                 
    .SPI_CS_L                 (),                                                                                
    .SPI_SCLK_L               (),                                                                                
    .SPI_DIN_L                (),                                                                                
    .SPI_DOUT_L               (),                                                                                
                                                                                                                 
    .SPI_CS_M                 (),                                                                                
    .SPI_SCLK_M               (),                                                                                
    .SPI_DIN_M                (),                                                                                
    .SPI_DOUT_M               (),                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   //-----------------------------------------------------------                              
    //-- M-BUS                                                                                 
    //-----------------------------------------------------------                              
    .TICL_MB_PREM       (MB_PREM ),                                                            
    .TICL_MB_RX1        (MB_RX1  ),                                                            
    .TICL_MB_TX1        (  ),         //MB_TX1                                                   
    .TICL_MB_TXEN1      (),           //MB_TXEN1                                                 
    .TICL_MB_RX2        (MB_RX2  ),                                                            
    .TICL_MB_TX2        (  ),         //MB_TX2                                                   
    .TICL_MB_TXEN2      (),           //MB_TXEN2                                                 
    //-----------------------------------------------------------                              
    //-- L-BUS                                                                                 
    //-----------------------------------------------------------                              
    .TICL_LB_PREM       (LB_PREM ),                                                            
                                                                                               
    .TICL_LB_RX1        (LB_RX1  ),                                                            
    .TICL_LB_TXEN1      (),           //LB_TXEN1                                                 
    .TICL_LB_TX1        (  ),         //LB_TX1                                                   
    .TICL_LB_RX2        (LB_RX2  ),                                                            
    .TICL_LB_TXEN2      (),           //LB_TXEN2                                                 
    .TICL_LB_TX2        (  ),         //LB_TX2                                                   
                                                                                               
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
    .DE           (MB_DE1  ), //MB_DE1 /////////////////////////////////////////                                       
    .R            (MB_RX1  ),                                        
    .RE_n         (GND     ),                                        
    .A            (MBUS_1_P),                                        
    .B            (MBUS_1_N)                                         
    );                                                               
                                                                     
   LVD206D u2_M_BUS_LVD206D(                                         
    .D            (MB_TX2  ),                                        
    .DE           (MB_DE2  ), //MB_DE2//////////////////////////////////////////////////////                                       
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
    .OE_n         (LB_PREM ), //LB_PREM///////////////////////////////////////////////////////                                       
    .Y            (LB_DE1  )                                         
    );                                                               
                                                                     
   SN74AUP1G u4_SN74AUP1G(                                           
    .A            (LB_TXEN2),                                        
    .OE_n         (LB_PREM),//LB_PREM//////////////////////////////////////////////                                        
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
 