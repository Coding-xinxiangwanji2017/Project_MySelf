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
// Name of module : np811_led
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
`define ERROR

module general_led_ctrl (
                          input          clk         ,
                          input          rst_n       ,
                          input [1:0]    i_ctrl      ,
                          input          i_freq      ,
                          output reg     o_led
                          ); 
parameter    LED_ON      = 2'b00        ;
parameter    LED_OFF     = 2'b01        ;
parameter    LED_BLINK   = 2'b10        ;
parameter    ERROR       = 1'b1         ;                          
always @ ( posedge clk or negedge rst_n)     
    begin                                    
        if(!rst_n)                           
            o_led <= 'd1 ;                  
        else                                 
            begin
            if(ERROR == 1'b1) 
                begin   
                    if(i_ctrl == LED_BLINK)     
                        o_led     <= 1'b0        ;          
                    else if(i_ctrl == LED_OFF)                            
                        o_led <= i_freq      ; 
                    else if(i_ctrl == LED_ON)                            
                        o_led <= 1'b0        ;  
                    else
                        o_led <= o_led   ;        
                end 
            else
                begin                               
                    if(i_ctrl == LED_BLINK)     
                        o_led <= i_freq  ;          
                    else if(i_ctrl == LED_OFF)                            
                        o_led <= 1'b1        ; 
                    else if(i_ctrl == LED_ON)                            
                        o_led <= 1'b0        ;  
                    else
                        o_led <= o_led   ;        
                end  
            end       
    end 
endmodule