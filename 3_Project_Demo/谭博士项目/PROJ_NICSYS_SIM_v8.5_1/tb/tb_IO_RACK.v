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
// Name of module : tb_IO_RACK
// Project        : NicSys8000
// Func           : Rack simulator
// Author         : Tan Xingye 
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FGG484
// version 1.0    : made in Date: 2016.4.21
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/04/21   Initial version(Tan Xingye)
//
//
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

module tb_IO_RACK(
    //-----------------------------------------------------------
    //-- M-BUS
    //-----------------------------------------------------------
    inout  tri              MBUS_1_P,
    inout  tri              MBUS_1_N,
    inout  tri              MBUS_2_P,
    inout  tri              MBUS_2_N,
    
    //-----------------------------------------------------------
    //-- L-BUS
    //-----------------------------------------------------------
    inout  tri              LBUS_B1_P,
    inout  tri              LBUS_B1_N,
    inout  tri              LBUS_B2_P,
    inout  tri              LBUS_B2_N
    
    //-----------------------------------------------------------
    //-- Inpit/Output digital/anloag signals
    //-- Fron DI/DO/AI/AO                                            
    //-----------------------------------------------------------
       
    
    
    
         
);



//------------------------------------------------------------------------------
//参数声明  开始
//------------------------------------------------------------------------------
  parameter GND = 1'd0;
  
  
  //------------------------------------
  //-- Station ID, Rack ID, Slot ID
  //------------------------------------
  parameter STAT    =  8'b0000_0000;
  parameter RACK    =  4'b0000;
  
  parameter SLOT_01 =  5'b0_0001;
  parameter SLOT_02 =  5'b0_0010;
  parameter SLOT_03 =  5'b0_0011;
  parameter SLOT_04 =  5'b0_0100;
  parameter SLOT_05 =  5'b0_0101;
  parameter SLOT_06 =  5'b0_0110;
  parameter SLOT_07 =  5'b0_0111;
  parameter SLOT_08 =  5'b0_1000;
  parameter SLOT_09 =  5'b0_1001;
  parameter SLOT_10 =  5'b0_1010;
  parameter SLOT_11 =  5'b0_1011;
  parameter SLOT_12 =  5'b0_1100;
  parameter SLOT_13 =  5'b0_1101;
  parameter SLOT_14 =  5'b0_1110;
  parameter SLOT_15 =  5'b0_1111;

//------------------------------------------------------------------------------
//参数声明  结束
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
//内部变量声明  开始
//------------------------------------------------------------------------------
// wire          MBUS_1_P;
// wire          MBUS_1_N;
// wire          MBUS_2_P;
// wire          MBUS_2_N;
// 
// wire          LBUS_B1_P;
// wire          LBUS_B1_N;
// wire          LBUS_B2_P;
// wire          LBUS_B2_N;
  
  wire          w_DI_01;                 
  wire          w_DI_02;                 
  wire          w_DI_03;                 
  wire          w_DI_04;                 
  wire          w_DI_05;                 
  wire          w_DI_06;                 
  wire          w_DI_07;                 
  wire          w_DI_08;                 
  wire          w_DI_09;                 
  wire          w_DI_10;                 
  wire          w_DI_11;                 
  wire          w_DI_12;                 
  wire          w_DI_13;                 
  wire          w_DI_14;                 
  wire          w_DI_15;                 
  wire          w_DI_16;                 
  wire          w_DI_17;                 
  wire          w_DI_18;                 
  wire          w_DI_19;                 
  wire          w_DI_20;                 
  wire          w_DI_21;                 
  wire          w_DI_22;                 
  wire          w_DI_23;                 
  wire          w_DI_24;                 
  wire          w_DI_25;                 
  wire          w_DI_26;                 
  wire          w_DI_27;                 
  wire          w_DI_28;                 
  wire          w_DI_29;                 
  wire          w_DI_30;                 
  wire          w_DI_31;                 
  wire          w_DI_32;                 
                                        
  wire          w_CHANNEL_P_01;          
  wire          w_CHANNEL_N_01;          
  wire          w_CHANNEL_P_02;          
  wire          w_CHANNEL_N_02;          
  wire          w_CHANNEL_P_03;          
  wire          w_CHANNEL_N_03;          
  wire          w_CHANNEL_P_04;          
  wire          w_CHANNEL_N_04;          
  wire          w_CHANNEL_P_05;          
  wire          w_CHANNEL_N_05;          
  wire          w_CHANNEL_P_06;          
  wire          w_CHANNEL_N_06;          
  wire          w_CHANNEL_P_07;          
  wire          w_CHANNEL_N_07;          
  wire          w_CHANNEL_P_08;          
  wire          w_CHANNEL_N_08;          
  wire          w_CHANNEL_P_09;          
  wire          w_CHANNEL_N_09;          
  wire          w_CHANNEL_P_10;          
  wire          w_CHANNEL_N_10;          
  wire          w_CHANNEL_P_11;          
  wire          w_CHANNEL_N_11;          
  wire          w_CHANNEL_P_12;          
  wire          w_CHANNEL_N_12;          
  wire          w_CHANNEL_P_13;          
  wire          w_CHANNEL_N_13;          
  wire          w_CHANNEL_P_14;          
  wire          w_CHANNEL_N_14;          
  wire          w_CHANNEL_P_15;          
  wire          w_CHANNEL_N_15;          
  wire          w_CHANNEL_P_16;          
  wire          w_CHANNEL_N_16;          
                                        
  wire          w_Current_IN_1 ;         
  wire          w_COM_IN_1     ;         
  wire          w_Voltage_IN_1 ;         
  wire          w_Current_IN_2 ;         
  wire          w_COM_IN_2     ;         
  wire          w_Voltage_IN_2 ;         
  wire          w_Current_IN_3 ;         
  wire          w_COM_IN_3     ;         
  wire          w_Voltage_IN_3 ;         
  wire          w_Current_IN_4 ;         
  wire          w_COM_IN_4     ;         
  wire          w_Voltage_IN_4 ;         
  wire          w_Current_IN_5 ;         
  wire          w_COM_IN_5     ;         
  wire          w_Voltage_IN_5 ;         
  wire          w_Current_IN_6 ;         
  wire          w_COM_IN_6     ;         
  wire          w_Voltage_IN_6 ;         
  wire          w_Current_IN_7 ;         
  wire          w_COM_IN_7     ;         
  wire          w_Voltage_IN_7 ;         
  wire          w_Current_IN_8 ;         
  wire          w_COM_IN_8     ;         
  wire          w_Voltage_IN_8 ;         
  wire          w_Current_IN_9 ;         
  wire          w_COM_IN_9     ;         
  wire          w_Voltage_IN_9 ;         
  wire          w_Current_IN_10;         
  wire          w_COM_IN_10    ;         
  wire          w_Voltage_IN_10;         
  wire          w_Current_IN_11;         
  wire          w_COM_IN_11    ;         
  wire          w_Voltage_IN_11;         
  wire          w_Current_IN_12;         
  wire          w_COM_IN_12    ;         
  wire          w_Voltage_IN_12;         
                                        
                                        
  wire          w_VOUT1 ;                
  wire          w_COM1  ;                
  wire          w_IOUT1 ;                
  wire          w_VOUT2 ;                
  wire          w_COM2  ;                
  wire          w_IOUT2 ;                
  wire          w_VOUT3 ;                
  wire          w_COM3  ;                
  wire          w_IOUT3 ;                
  wire          w_VOUT4 ;                
  wire          w_COM4  ;                
  wire          w_IOUT4 ;                
  wire          w_VOUT5 ;                
  wire          w_COM5  ;                
  wire          w_IOUT5 ;                
  wire          w_VOUT6 ;                
  wire          w_COM6  ;                
  wire          w_IOUT6 ;                
  wire          w_VOUT7 ;                
  wire          w_COM7  ;                
  wire          w_IOUT7 ;                
  wire          w_VOUT8 ;                
  wire          w_COM8  ;                
  wire          w_IOUT8 ;                









 /*
  
//------------------------------------------------------------------------------
//模块调用参考 开始
//------------------------------------------------------------------------------
  //************************************************************       
  //--  DI812 Board                                                    
  //--  Slot ID =06                                                 
  //************************************************************        
    DI812_BOARD_B01 u1_DI812_BOARD_B01(                                  
                                                                      
    //----------------------------------------------------------        
    //--Rack ID, Slot ID                                                 
    //----------------------------------------------------------        
    .RACK                  (RACK),                                      
    .SLOT                  (SLOT_06),                                   
                                                                        
    //----------------------------------------------------------        
    //-- M-BUS                                                          
    //----------------------------------------------------------        
    .MBUS_1_P               (MBUS_1_P),                               
    .MBUS_1_N               (MBUS_1_N),                               
    .MBUS_2_P               (MBUS_2_P),                               
    .MBUS_2_N               (MBUS_2_N),                               
                                                                        
    //----------------------------------------------------------        
    //-- L-BUS                                                          
    //----------------------------------------------------------        
    .LBUS_B1_P               (LBUS_B1_P),                             
    .LBUS_B1_N               (LBUS_B1_N),                             
    .LBUS_B2_P               (LBUS_B2_P),                             
    .LBUS_B2_N               (LBUS_B2_N),                             
                                                                        
                                                                        
    //----------------------------------------------------------        
    //-- DI  channel input signal                                       
    //----------------------------------------------------------        
                                                                        
    .DI_01            (w_DI_01),                                        
    .DI_02            (w_DI_02),                                        
    .DI_03            (w_DI_03),                                        
    .DI_04            (w_DI_04),                                        
    .DI_05            (w_DI_05),                                        
    .DI_06            (w_DI_06),                                        
    .DI_07            (w_DI_07),                                        
    .DI_08            (w_DI_08),                                        
    .DI_09            (w_DI_09),                                        
    .DI_10            (w_DI_10),                                        
    .DI_11            (w_DI_11),                                        
    .DI_12            (w_DI_12),                                        
    .DI_13            (w_DI_13),                                        
    .DI_14            (w_DI_14),                                        
    .DI_15            (w_DI_15),                                        
    .DI_16            (w_DI_16),                                        
    .DI_17            (w_DI_17),                                        
    .DI_18            (w_DI_18),                                        
    .DI_19            (w_DI_19),                                        
    .DI_20            (w_DI_20),                                        
    .DI_21            (w_DI_21),                                        
    .DI_22            (w_DI_22),                                        
    .DI_23            (w_DI_23),                                        
    .DI_24            (w_DI_24),                                        
    .DI_25            (w_DI_25),                                        
    .DI_26            (w_DI_26),                                        
    .DI_27            (w_DI_27),                                        
    .DI_28            (w_DI_28),                                        
    .DI_29            (w_DI_29),                                        
    .DI_30            (w_DI_30),                                        
    .DI_31            (w_DI_31),                                        
    .DI_32            (w_DI_32)                                         
                                                                        
);                                                                      
                                                                      
                                                                      
  //***********************************************************         
  //--  DO811 Board                                                     
  //--  Slot ID =05                                                       
  //***********************************************************         
   DO811_BOARD_B01 u1_DO811_BOARD_B01(                                  
                                                                      
    //---------------------------------------------------------         
    //-- Rack ID, Slot ID                                               
    //---------------------------------------------------------         
    .RACK                  (RACK),                                      
    .SLOT                  (SLOT_05),                                   
                                                                        
    //---------------------------------------------------------         
    //-- M-BUS                                                          
    //---------------------------------------------------------         
    .MBUS_1_P               (MBUS_1_P),                               
    .MBUS_1_N               (MBUS_1_N),                               
    .MBUS_2_P               (MBUS_2_P),                               
    .MBUS_2_N               (MBUS_2_N),                               
                                                                        
    //---------------------------------------------------------         
    //-- L-BUS                                                          
    //---------------------------------------------------------         
    .LBUS_B1_P               (LBUS_B1_P),                             
    .LBUS_B1_N               (LBUS_B1_N),                             
    .LBUS_B2_P               (LBUS_B2_P),                             
    .LBUS_B2_N               (LBUS_B2_N),                             
                                                                        
                                                                        
    //---------------------------------------------------------         
    //-- DO  channel input signal                                       
    //---------------------------------------------------------         
                                                                        
                                                                        
    .CHANNEL_P_01            (w_CHANNEL_P_01),                          
    .CHANNEL_N_01            (w_CHANNEL_N_01),                          
    .CHANNEL_P_02            (w_CHANNEL_P_02),                          
    .CHANNEL_N_02            (w_CHANNEL_N_02),                          
    .CHANNEL_P_03            (w_CHANNEL_P_03),                          
    .CHANNEL_N_03            (w_CHANNEL_N_03),                          
    .CHANNEL_P_04            (w_CHANNEL_P_04),                          
    .CHANNEL_N_04            (w_CHANNEL_N_04),                          
    .CHANNEL_P_05            (w_CHANNEL_P_05),                          
    .CHANNEL_N_05            (w_CHANNEL_N_05),                          
    .CHANNEL_P_06            (w_CHANNEL_P_06),                          
    .CHANNEL_N_06            (w_CHANNEL_N_06),                          
    .CHANNEL_P_07            (w_CHANNEL_P_07),                          
    .CHANNEL_N_07            (w_CHANNEL_N_07),                          
    .CHANNEL_P_08            (w_CHANNEL_P_08),                          
    .CHANNEL_N_08            (w_CHANNEL_N_08),                          
    .CHANNEL_P_09            (w_CHANNEL_P_09),                          
    .CHANNEL_N_09            (w_CHANNEL_N_09),                          
    .CHANNEL_P_10            (w_CHANNEL_P_10),                          
    .CHANNEL_N_10            (w_CHANNEL_N_10),                          
    .CHANNEL_P_11            (w_CHANNEL_P_11),                          
    .CHANNEL_N_11            (w_CHANNEL_N_11),                          
    .CHANNEL_P_12            (w_CHANNEL_P_12),                          
    .CHANNEL_N_12            (w_CHANNEL_N_12),                          
    .CHANNEL_P_13            (w_CHANNEL_P_13),                          
    .CHANNEL_N_13            (w_CHANNEL_N_13),                          
    .CHANNEL_P_14            (w_CHANNEL_P_14),                          
    .CHANNEL_N_14            (w_CHANNEL_N_14),                          
    .CHANNEL_P_15            (w_CHANNEL_P_15),                          
    .CHANNEL_N_15            (w_CHANNEL_N_15),                          
    .CHANNEL_P_16            (w_CHANNEL_P_16),                          
    .CHANNEL_N_16            (w_CHANNEL_N_16)                          
                                                                        
);                                                                     
                                                                       
                                                                       
  //************************************************************         
  //--  AI812 Board                                                      
  //--  Slot ID =04                                                        
  //************************************************************         
    AI812_BOARD_B01 u1_AI812_BOARD_B01(                                   
                                                                       
    //----------------------------------------------------------         
    //-- Rack ID, Slot ID                                                
    //----------------------------------------------------------         
    .RACK                  (RACK),                                       
    .SLOT                  (SLOT_04),                                    
                                                                         
    //----------------------------------------------------------         
    //-- M-BUS                                                           
    //----------------------------------------------------------         
    .MBUS_1_P               (MBUS_1_P),                                
    .MBUS_1_N               (MBUS_1_N),                              
    .MBUS_2_P               (MBUS_2_P),                              
    .MBUS_2_N               (MBUS_2_N),                              
                                                                       
    //----------------------------------------------------------       
    //-- L-BUS                                                         
    //----------------------------------------------------------       
    .LBUS_B1_P               (LBUS_B1_P),                            
    .LBUS_B1_N               (LBUS_B1_N),                            
    .LBUS_B2_P               (LBUS_B2_P),                            
    .LBUS_B2_N               (LBUS_B2_N),                            
                                                                       
                                                                       
    //----------------------------------------------------------       
    //-- AI  channel input signal                                      
    //----------------------------------------------------------       
                                                                       
    .Current_IN_1             (w_Current_IN_1 ),                       
    .COM_IN_1                 (w_COM_IN_1     ),                       
    .Voltage_IN_1             (w_Voltage_IN_1 ),                       
    .Current_IN_2             (w_Current_IN_2 ),                       
    .COM_IN_2                 (w_COM_IN_2     ),                       
    .Voltage_IN_2             (w_Voltage_IN_2 ),                       
    .Current_IN_3             (w_Current_IN_3 ),                       
    .COM_IN_3                 (w_COM_IN_3     ),                       
    .Voltage_IN_3             (w_Voltage_IN_3 ),                       
    .Current_IN_4             (w_Current_IN_4 ),                       
    .COM_IN_4                 (w_COM_IN_4     ),                       
    .Voltage_IN_4             (w_Voltage_IN_4 ),                       
    .Current_IN_5             (w_Current_IN_5 ),                       
    .COM_IN_5                 (w_COM_IN_5     ),                       
    .Voltage_IN_5             (w_Voltage_IN_5 ),                       
    .Current_IN_6             (w_Current_IN_6 ),                       
    .COM_IN_6                 (w_COM_IN_6     ),                       
    .Voltage_IN_6             (w_Voltage_IN_6 ),                       
    .Current_IN_7             (w_Current_IN_7 ),                       
    .COM_IN_7                 (w_COM_IN_7     ),                       
    .Voltage_IN_7             (w_Voltage_IN_7 ),                       
    .Current_IN_8             (w_Current_IN_8 ),                       
    .COM_IN_8                 (w_COM_IN_8     ),                       
    .Voltage_IN_8             (w_Voltage_IN_8 ),                       
    .Current_IN_9             (w_Current_IN_9 ),                       
    .COM_IN_9                 (w_COM_IN_9     ),                       
    .Voltage_IN_9             (w_Voltage_IN_9 ),                       
    .Current_IN_10            (w_Current_IN_10),                       
    .COM_IN_10                (w_COM_IN_10    ),                       
    .Voltage_IN_10            (w_Voltage_IN_10),                       
    .Current_IN_11            (w_Current_IN_11),                       
    .COM_IN_11                (w_COM_IN_11    ),                       
    .Voltage_IN_11            (w_Voltage_IN_11),                       
    .Current_IN_12            (w_Current_IN_12),                       
    .COM_IN_12                (w_COM_IN_12    ),                       
    .Voltage_IN_12            (w_Voltage_IN_12)                        
                                                                       
                                                                       
);                                                                   
                                                                     
  //*********************************************************                
  //--  AO811 Board                                                          
  //--  Slot ID =03                                                            
  //*********************************************************                         
     AO811_BOARD_B01 u1_AO811_BOARD_B01(                                                
                                                                                    
     //-------------------------------------------------------                         
     //--  Rack ID, Slot ID                                                            
     //-------------------------------------------------------                         
     .RACK                  (RACK),                                                    
     .SLOT                  (SLOT_03),                                                 
                                                                                       
     //-------------------------------------------------------                          
     //-- M-BUS                                                                        
     //-------------------------------------------------------                          
     .MBUS_1_P               (MBUS_1_P),                                              
     .MBUS_1_N               (MBUS_1_N),                                          
     .MBUS_2_P               (MBUS_2_P),                                          
     .MBUS_2_N               (MBUS_2_N),                                          
                                                                                  
     //-------------------------------------------------------                      
     //-- L-BUS                                                                     
     //-------------------------------------------------------                      
     .LBUS_B1_P               (LBUS_B1_P),                                        
     .LBUS_B1_N               (LBUS_B1_N),                                        
     .LBUS_B2_P               (LBUS_B2_P),                                        
     .LBUS_B2_N               (LBUS_B2_N),                                        
                                                                                    
                                                                                    
     //-------------------------------------------------------               
     //-- AO  channel input signal                                 
     //-------------------------------------------------------        
                                                                      
     .VOUT1            (w_VOUT1),                                     
     .COM1             (w_COM1 ),                                     
     .IOUT1            (w_IOUT1),                                     
     .VOUT2            (w_VOUT2),                                     
     .COM2             (w_COM2 ),                                     
     .IOUT2            (w_IOUT2),                                     
     .VOUT3            (w_VOUT3),                                     
     .COM3             (w_COM3 ),                                     
     .IOUT3            (w_IOUT3),                                     
     .VOUT4            (w_VOUT4),                                     
     .COM4             (w_COM4 ),                                     
     .IOUT4            (w_IOUT4),                                     
     .VOUT5            (w_VOUT5),                                     
     .COM5             (w_COM5 ),                                     
     .IOUT5            (w_IOUT5),                                     
     .VOUT6            (w_VOUT6),                                     
     .COM6             (w_COM6 ),                                     
     .IOUT6            (w_IOUT6),                                     
     .VOUT7            (w_VOUT7),                                     
     .COM7             (w_COM7 ),                                     
     .IOUT7            (w_IOUT7),                                     
     .VOUT8            (w_VOUT8),                                     
     .COM8             (w_COM8 ),                                     
     .IOUT8            (w_IOUT8)                                      
                                                                      
);                                                                 
                                                                              
    /*                                                                              
                                                                                    
   MN811_BOARD_B01 u1_MN811_BOARD_B01(                                              
    //-----------------------------------------------------------                   
    //-- Station ID, Rack ID, Slot ID                                               
    //-----------------------------------------------------------                   
    .STAT                  (STAT),                                                  
    .RACK                  (RACK),                                                  
    .SLOT                  (SLOT_15),                                               
                                                                                    
    //-----------------------------------------------------------                   
    //-- M-BUS                                                                      
    //-----------------------------------------------------------                   
    .MBUS_1_P               (MBUS_1_P),                                                                  
    .MBUS_1_N               (MBUS_1_N),                                                                  
    .MBUS_2_P               (MBUS_2_P),                                                                  
    .MBUS_2_N               (MBUS_2_N),                                                                  
                                                                                                           
    //-----------------------------------------------------------                                          
    //-- Ethernet: RMII interface-2                                                                        
    //-----------------------------------------------------------                                          
    .ETH2_RST_n          (ETH2_RST_n     ),                                                                
    .ETH2_REFCLK         (ETH2_REFCLK    ),                                                                
    .ETH2_RXD_O          (ETH2_RXD_O     ),                                                                
    .ETH2_RXDV_O         (ETH2_RXDV_O    ),                                                                     
    .ETH2_RXER           (ETH2_RXER      ),                                                                     
    .ETH2_TXEN           (ETH2_TXEN      ),                                  
    .ETH2_TXD            (ETH2_TXD       ),                                  
    .ETH2_COM_LED        (ETH2_COM_LED   )                                   
                                                                             
                                                                             
    //inout  tri              ETH2_MDIO,                                     
    //output wire             ETH2_MDC,                                      
    //input  wire             ETH2_LEDG,                                     
    //input  wire             ETH2_LEDY,                                     
    //input  wire             ETH2_INTRP                                     
);                                                                           
                                                                             
*/                                                                           
                                                                             
endmodule                                                                    