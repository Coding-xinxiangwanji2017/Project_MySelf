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
// Name of module : watchdog
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

`timescale 1ns/10ps
module watchdog(
                  input     clk     ,
                  input     rst_n   ,
                  input     i_dog_en,//1'b1: enable; 1'b0:disable;
                  output    o_wdi   
);

parameter    FULL_VALUE = 25'd24900 ;
reg    [24:0]            r_freq_cnt ;
reg                      r_freq     ;

always @ ( posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            r_freq_cnt <= 'd0 ;
        else
            begin
            if(r_freq_cnt == FULL_VALUE)
                r_freq_cnt <= 'd0 ;
            else
                r_freq_cnt <= r_freq_cnt + 'd1 ;
            end
    end
    
always @ ( posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            r_freq <= 'b0 ;
        else
            begin
            if(r_freq_cnt == FULL_VALUE)
                r_freq <= !r_freq ;
            else
                r_freq <= r_freq  ;
            end
    end
    
assign o_led = (!i_dog_en)|r_freq ;


endmodule