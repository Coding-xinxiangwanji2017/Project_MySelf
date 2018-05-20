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

`timescale 1ns/10ps
module np811_led(
                     input           rst_n       ,
                     input           clk         ,
                     input  [17:0]   i_led_en    ,
                                                 //single led needs 2 bit:( 2'b00:on; 2'b01:off; 2'b10:blink; 2'b11:rev)
                                                 //i_led_en[17:0]->run,err_y,err_r,com,syn,st1,st2,st3,st4
                     output wire     o_run_led   ,
                     output wire     o_err_y_led ,//warning
                     output wire     o_err_r_led ,//err 
                     output wire     o_com_led   ,
                     output wire     o_syn_led   ,
                     output wire     o_st1_led   ,
                     output wire     o_st2_led   ,  
                     output wire     o_st3_led   ,
                     output wire     o_st4_led   
);
parameter    VALUE_2HZ   = 25'd12499999 ;
parameter    VALUE_10KHZ = 13'd2499     ;


reg    [24:0]              r_freq_cnt2hz  ; 
reg    [12:0]              r_freq_cnt10khz;
reg                        r_freq_2hz     ;
reg                        r_freq_10khz   ;
 
always @ ( posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            r_freq_cnt2hz <= 'd0 ;
        else
            begin
            if(r_freq_cnt2hz == VALUE_2HZ)
                r_freq_cnt2hz <= 'd0 ;
            else
                r_freq_cnt2hz <= r_freq_cnt2hz + 'd1 ;
            end
    end
    
always @ ( posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            r_freq_2hz <= 'd0 ;
        else
            begin
            if(r_freq_cnt2hz == VALUE_2HZ)
                r_freq_2hz <= !r_freq_2hz ;
            else
                r_freq_2hz <= r_freq_2hz  ;
            end
    end
 
always @ ( posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            r_freq_cnt10khz <= 'd0 ;
        else
            begin
            if(r_freq_cnt10khz == VALUE_10KHZ)
                r_freq_cnt10khz <= 'd0 ;
            else
                r_freq_cnt10khz <= r_freq_cnt10khz + 'd1 ;
            end
    end
    
always @ ( posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            r_freq_10khz <= 'd0 ;
        else
            begin
            if(r_freq_cnt10khz == VALUE_10KHZ)
                r_freq_10khz <= !r_freq_10khz ;
            else
                r_freq_10khz <= r_freq_10khz  ;
            end
    end
    
//run led ctrl                                            
general_led_ctrl #(.ERROR(1'b0)) 
u1_general_led_ctrl(        
                          .clk       (clk            )      ,
                          .rst_n     (rst_n          )      ,
                          .i_ctrl    (i_led_en[17:16])      ,
                          .i_freq    (r_freq_2hz     )      ,
                          .o_led     (o_run_led      )
                    ); 
//err led ctrl
general_led_ctrl #(.ERROR(1'b1)) 
u2_general_led_ctrl(        
                          .clk       (clk            )      ,
                          .rst_n     (rst_n          )      ,
                          .i_ctrl    (i_led_en[15:14])      ,
                          .i_freq    (r_freq_10khz   )      ,
                          .o_led     (o_err_r_led    )
                    ); 
general_led_ctrl #(.ERROR(1'b0)) 
u3_general_led_ctrl(        
                          .clk       (clk            )      ,
                          .rst_n     (rst_n          )      ,
                          .i_ctrl    (i_led_en[13:12])      ,
                          .i_freq    (1'b1           )      ,
                          .o_led     (o_err_y_led    )
                    );

//com led ctrl
general_led_ctrl #(.ERROR(1'b0)) 
u4_general_led_ctrl(        
                          .clk       (clk            )      ,
                          .rst_n     (rst_n          )      ,
                          .i_ctrl    (i_led_en[11:10])      ,
                          .i_freq    (r_freq_2hz     )      ,
                          .o_led     (o_com_led      )
                    );
//syn led ctrl
general_led_ctrl #(.ERROR(1'b0)) 
u5_general_led_ctrl(        
                          .clk       (clk            )      ,
                          .rst_n     (rst_n          )      ,
                          .i_ctrl    (i_led_en[9:8]  )      ,
                          .i_freq    (r_freq_2hz     )      ,
                          .o_led     (o_syn_led      )
                    );
//st led ctrl
general_led_ctrl #(.ERROR(1'b0)) 
u6_general_led_ctrl(        
                          .clk       (clk            )      ,
                          .rst_n     (rst_n          )      ,
                          .i_ctrl    (i_led_en[7:6]  )      ,
                          .i_freq    (1'b1           )      ,
                          .o_led     (o_st1_led      )
                    );
general_led_ctrl #(.ERROR(1'b0)) 
u7_general_led_ctrl(        
                          .clk       (clk            )      ,
                          .rst_n     (rst_n          )      ,
                          .i_ctrl    (i_led_en[5:4]  )      ,
                          .i_freq    (1'b1           )      ,
                          .o_led     (o_st2_led      )
                    );
                                        
general_led_ctrl #(.ERROR(1'b0)) 
u8_general_led_ctrl(        
                          .clk       (clk            )      ,
                          .rst_n     (rst_n          )      ,
                          .i_ctrl    (i_led_en[3:2]  )      ,
                          .i_freq    (1'b1           )      ,
                          .o_led     (o_st3_led      )
                    );
general_led_ctrl #(.ERROR(1'b0)) 
u9_general_led_ctrl(        
                          .clk       (clk            )      ,
                          .rst_n     (rst_n          )      ,
                          .i_ctrl    (i_led_en[1:0]  )      ,
                          .i_freq    (1'b1           )      ,
                          .o_led     (o_st4_led      )
                    );
    
endmodule                                      