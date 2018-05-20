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
// Name of module : AO811_UT5_B01
// Project        : NicSys8000
// Func           : AO811 DFPGA Top
// Author         : Zhang Xueyan
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FGG484
// version 1.0    : made in Date: 2015.12.01
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/04/12   Initial version(Tan Xingye) 
//
//
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/10ps

module AO811_UT5_B01( 

     //----------------------------------------------------------- 
     //-- Global reset, clocks                                     
     //----------------------------------------------------------- 
     input  wire    	     FD_RSTB          , //negedge rst  
     	                                            
     input  wire    	     CLK_25MD1        ,               
     input  wire    	     CLK50MP2         ,         
     
     //----------------------------------------------------------- 
     //-- Power Detector                                           
     //------------------------------------------------------       	                                                    
     input  wire             FPWR_PG1         , //0 is valid   
     input  wire             FPWR_PG2         , //0 is valid   
     input  wire             FPWR_PG3         , //0 is valid   
     input  wire             FPWR_OV          , //0 is valid   
     input  wire             FPWR_UV          , //0 is valid   
     
     //----------------------------------------------------------- 
     //-- Watchdog                                                 
     //----------------------------------------------------------- 
     output wire             FD_WDIB          ,  
     input  wire    		 FD_WDOB          ,  
     //input  wire    		 FP_WDOA          ,  
     
     //----------------------------------------------------------- 
     //--  Rack ID, Slot ID                                        
     //----------------------------------------------------------- 
     input  wire     [04:00] FDP_SLOT         ,            
     input  wire     [03:00] FDP_RACK         ,        
     
     //-----------------------------------------------------------  
     //-- Plug monitor, active low                                  
     //-----------------------------------------------------------      
     input  wire             PLUG_MON         ,                
     
     //-----------------------------------------------------------   
     //-- LED indicator                                              
     //-----------------------------------------------------------                                                    
     output wire             FD_LED4          , //WARNING	 
     
     //-----------------------------------------------------------
     //-- CHannel Read-backward                                   
     //-----------------------------------------------------------
     input  wire    		 F_A_SDO_A        ,  
     input  wire    		 F_A_SDIN_A       ,  
     input  wire    		 F_A_SCLK_A       ,  
     input  wire    		 F_A_CS_A         ,  
                             
     input  wire    		 F_A_SDO_B        ,  
     input  wire    		 F_A_SDIN_B       ,  
     input  wire    		 F_A_SCLK_B       ,  
     input  wire    		 F_A_CS_B         ,  
                             
     input  wire    		 F_A_SDO_C        ,    
     input  wire    		 F_A_SDIN_C       ,    
     input  wire    		 F_A_SCLK_C       ,    
     input  wire    		 F_A_CS_C         ,    
                             
     input  wire    		 F_A_SDO_D        ,  
     input  wire    		 F_A_SDIN_D       ,  
     input  wire    		 F_A_SCLK_D       ,  
     input  wire    		 F_A_CS_D         ,  
                             
     input  wire    		 F_A_SDO_E        , 
     input  wire    		 F_A_SDIN_E       , 
     input  wire    		 F_A_SCLK_E       , 
     input  wire    		 F_A_CS_E         , 
                                  
     input  wire             F_A_CS_F         , 
     input  wire    		 F_A_SCLK_F       , 
     input  wire    		 F_A_SDIN_F       , 
     input  wire    		 F_A_SDO_F        ,      
                             
     input  wire    		 F_A_CS_G         , 
     input  wire    		 F_A_SCLK_G       , 
     input  wire    		 F_A_SDIN_G       , 
     input  wire    		 F_A_SDO_G        , 
     		                            
     input  wire    		 F_A_CS_H         , 
     input  wire    		 F_A_SCLK_H       , 
     input  wire    		 F_A_SDIN_H       , 
     input  wire    		 F_A_SDO_H        , 
     
     //----------------------------------------------------------- 
     //-- M-BUS                                                    
     //----------------------------------------------------------- 
                                        	
     input  wire    		 TICL_MB_TXEN2    , 
     input  wire    		 TICL_MB_RX2      , 
     input  wire    		 TICL_MB_TX2      , 
     output wire		     TICL_MB_PREM     , 
     input  wire    		 TICL_MB_TXEN1    , 
     input  wire    		 TICL_MB_RX1      , 
     input  wire    		 TICL_MB_TX1      , 
     
     //----------------------------------------------------------- 
     //-- L-BUS                                                    
     //----------------------------------------------------------- 
     		                  
     input  wire    		 TICL_LB_TXEN2    , 
     input  wire    		 TICL_LB_RX2      , 
     input  wire    		 TICL_LB_TX2      , 
     output wire			 TICL_LB_PREM     , 
     input  wire    		 TICL_LB_TXEN1    , 
     input  wire    		 TICL_LB_RX1      , 
     input  wire    	     TICL_LB_TX1      , 
     
     //-----------------------------------------------------------      
     //-- Interface with PFPGA                                          
     //-----------------------------------------------------------  	   
     
     	                           
     input  wire    		 FIO_RSTO         ,//reset dfpga
     input  wire             FIO_CLK          ,//clk
     input  wire             FIO_TICK         ,//heartbeat in
     output wire             FIO_RSTIN        ,//heartbeat out
     input  wire             FIO_WE           ,//Wren
                                    
     input  wire   [20:00]   FIO_DAT          ,//[12:0] addr; [20:13] output wire data
                                    
     output wire             FIO_DAT21        ,//==[7:0] input       data 
     output wire             FIO_DAT22        ,//==[7:0] input       data
     output wire             FIO_DAT23        ,//==[7:0] input       data 
     output wire    [02:00]  FIO_CS           ,//==[7:0] input       data   FIO_CS0 FIO_CS1 FIO_CS2
     output wire             FIO_RE           ,//==[7:0] input       data   FIO_RE
     output wire             FIO_ALE          ,//==[7:0] input       data   FIO_ALE
     
    //-----------------------------------------------------------      		                              		                       		              
    //-- SPI interface ,EEPROM AT25512                                 		                              		                       		              
    //-----------------------------------------------------------      		                              		                       		              
     		                              		                       		                  		                              		                       		                   		                              		                       		                   		                              		                       		                   		                              		                       		                   		                              		                       		                   		                              		                       		                  		                              		                       		             		                              		                       		            		                              		                       		                       
     output wire		     FD_E2P_SI        ,
     output wire             FD_E2P_CS        ,
     output wire             FD_E2P_SCK       ,
     input  wire             FD_E2P_SO        ,
     
     //------------------------------------------------------------  
     //-- Test pins                                                  
     //------------------------------------------------------------  
                   
     output wire [15:00]	 FD_TEST               
      );
     
     
    assign   TICL_MB_PREM = 1'b0;
    assign   TICL_LB_PREM = 1'b0;                                                                                                          
/*                                                                                                              
                                                                                                                
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
wire         w_sys_clk ;                                                                                        
wire         w_sys_rst ;                                                                                        
wire [15:00] w_ad_data ;                                                                                        
reg  [07:00] r_a_addr  ;                                                                                        
                                                                                                                
reg  [01:00] fsm_curr  ;                                                                                        
reg  [01:00] fsm_next  ;                                                                                        
//------------------------------------------------------------------------------                                
//内部变量声明  开始                                                                                            
//------------------------------------------------------------------------------                                
                                                                                                                
                                                                                                                
                                                                                                                
                                                                                                                
//------------------------------------------------------------------------------                                
//模块调用参考  开始                                                                                            
//------------------------------------------------------------------------------                                
clock u_clock(                                                                                                  
    .sys_clk_50m   (sys_clk_50m   ),                                                                            
    .sys_clk       (w_sys_clk     ),                                                                            
    .sys_rst       (w_sys_rst     )                                                                             
    );                                                                                                          
                                                                                                                
adc_din u_adc_din(                                                                                              
    .sys_clk       (w_sys_clk     ),                                                                            
    .sys_rst       (w_sys_rst     ),                                                                            
    .im_adc_data   (im_adc_data   ),                                                                            
    .om_ad_data    (w_ad_data     )                                                                             
    );                                                                                                          
                                                                                                                
emif_ctrl u_emif_ctrl(                                                                                          
    .sys_clk       (w_sys_clk     ),                                                                            
    .sys_rst       (w_sys_rst     ),                                                                            
    .o_arm_inte    (o_arm_inte    ),                                                                            
    .o_gain_chl_en (o_gain_chl_en ),                                                                            
    .om_gain_chl   (om_gain_chl   ),                                                                            
    .om_band_high  (om_band_high  ),                                                                            
    .om_band_low   (om_band_low   ),                                                                            
    .im_ad_data    (w_ad_data     ),                                                                            
    .io_emif_data  (io_emif_data  ),                                                                            
    .im_emif_addr  (im_emif_addr  ),                                                                            
    .i_emif_cen    (i_emif_cen    ),                                                                            
    .i_emif_oen    (i_emif_oen    ),                                                                            
    .i_emif_wen    (i_emif_wen    )                                                                             
    );                                                                                                          
                                                                                                                
led u_led(                                                                                                      
    .sys_clk       (w_sys_clk     ),                                                                            
    .sys_rst       (w_sys_rst     ),                                                                            
    .o_led_out     (o_led_out     )                                                                             
    );                                                                                                          
                                                                                                                
led u1_led(                                                                                                     
    .sys_clk       (w_sys_clk     ),                                                                            
    .sys_rst       (w_sys_rst     ),                                                                            
    .o_led_out     (o_led_out     )                                                                             
    );                                                                                                          
                                                                                                                
led u2_led(                                                                                                     
    .sys_clk       (w_sys_clk     ),                                                                            
    .sys_rst       (w_sys_rst     ),                                                                            
    .o_led_out     (o_led_out     )                                                                             
    );                                                                                                          
//------------------------------------------------------------------------------                                
//模块调用参考  结束                                                                                            
//------------------------------------------------------------------------------                                
                                                                                                                
                                                                                                                
//------------------------------------------------------------------------------                                
//逻辑参考  开始                                                                                                
//------------------------------------------------------------------------------                                
//输入数据缓存一级                                                                                              
always @ (posedge sys_clk)                                                                                      
begin                                                                                                           
    if(sys_rst)                                                                                                 
        begin                                                                                                   
            r_tcfifo_we <= 'b0;                                                                                 
            r_tcfifo_wdata <= 'd0;                                                                              
        end                                                                                                     
    else                                                                                                        
        begin                                                                                                   
            r_tcfifo_we <= tcfifo_we;                                                                           
            r_tcfifo_wdata <= tcfifo_wdata;                                                                     
        end                                                                                                     
end                                                                                                             
                                                                                                                
assign io_emif_data = (r_dpram_a_ren == 1'b1) ? im_dpram_a_rdata : 16'hzzzz;                                    
                                                                                                                
//------------------------------------------------------------------------------                                
//逻辑参考  结束                                                                                                
//------------------------------------------------------------------------------                                
                                                                                                                
                                                                                                                
                                                                                                                
//------------------------------------------------------------------------------                                
//状态机格式参考  开始                                                                                          
//------------------------------------------------------------------------------                                
always @ (posedge sys_clk)                                                                                      
begin                                                                                                           
    if(sys_rst)                                                                                                 
        fsm_curr <= FSM_IDLE;                                                                                   
    else                                                                                                        
        fsm_curr <= fsm_next;                                                                                   
end                                                                                                             
                                                                                                                
always @ ( * )                                                                                                  
begin                                                                                                           
    case(fsm_curr)                                                                                              
        FSM_IDLE:                                                                                               
            fsm_next = FSM_CMD;                                                                                 
        FSM_CMD:                                                                                                
            begin                                                                                               
                if((rx_cmd == 8'h10) && (rx_cnt > 16'd8))                                                       
                    fsm_next = FSM_DATA;                                                                        
                else if(rx_cnt > 16'd8)                                                                         
                    fsm_next = FSM_IDLE;                                                                        
                else                                                                                            
                    fsm_next = FSM_CMD;                                                                         
            end                                                                                                 
        FSM_DATA:                                                                                               
            begin                                                                                               
                if(r_a_addr == 8'd137)                                                                          
                    fsm_next = FSM_IDLE;                                                                        
                else                                                                                            
                    fsm_next = FSM_DATA;                                                                        
            end                                                                                                 
        default:                                                                                                
            fsm_next = FSM_IDLE;                                                                                
    endcase                                                                                                     
end                                                                                                             
                                                                                                           		
always @ (posedge sys_clk)                                                                                      
begin                                                                                                           
    if(sys_rst)                                                                                                 
        r_a_addr <= 8'd0;                                                                                       
    else                                                                                                        
        begin                                                                                                   
            case(fsm_curr)                                                                                      
                FSM_IDLE:                                                                                       
                    r_a_addr <= 8'd0;                                                                           
                FSM_CMD:                                                                                        
                    r_a_addr <= rx_cnt[7:0];                                                                    
                FSM_DATA:                                                                                       
                    begin                                                                                       
                        if(rxfifo_en)                                                                           
                            r_a_addr <= r_a_addr + 1'b1;                                                        
                        else                                                                                    
                            r_a_addr <= r_a_addr;                                                               
                    end                                                                                         
                default:                                                                                        
                    r_a_addr <= 8'd0;                                                                           
            endcase                                                                                             
        end                                                                                                     
end                                                                                                             
//------------------------------------------------------------------------------                                
//状态机格式参考  结束                                                                                          
//------------------------------------------------------------------------------                                
                                                                                                                
                                                                                                                
*/                                                                                                              
                                                                                                                
                                                                                                                
endmodule                                                                                                       