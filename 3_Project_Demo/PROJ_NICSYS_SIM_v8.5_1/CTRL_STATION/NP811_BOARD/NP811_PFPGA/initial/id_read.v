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
// Name of module : MN811_UT4_B01
// Project        : id_read
// Func           : read the id (station, rack, slot)
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

`timescale 1ns/100ps

module id_read  
( 
input              rst_n          ,//negedge rst
input              clk            ,
                                  
input       [7:0]  im_station     ,
input       [3:0]  im_rack        ,
input       [4:0]  im_slot        ,

output reg        o_idread_finish,
output reg        rd_id_done,
output reg        rd_id_error,

output reg        o_station_err  ,
output reg [6:0]  station_id  ,
                                  
output reg        o_rack_err     ,
output reg [2:0]  rack_id     ,
                             
output reg        o_slot_err     ,
output reg [3:0]  slot_id     
);  

parameter   DELAY_1MS    = 16'd50;//16'd50000
parameter   FILTER_DALAY = 10'd10   ;//10'd10   //100ms~1000ms
parameter   DETECT_TIME  = 4'd3     ;//4'd3     //1~8 times
parameter   TIMEOUT      = 10'd100  ;//10'd100  //over 100 times the id read is err
                                    
parameter   CHK_ENABLE   = 1'b0     ;

reg [6:0]  om_station_id;
reg [2:0]  om_rack_id   ;
reg [3:0]  om_slot_id   ; 

reg [15:0]    r_cnt_clk      ;
reg [9 :0]    r_cnt_1ms      ; 
wire          w_detect_enable;

reg [18:0]    r_id           ;
reg [9 :0]    r_cnt_detect   ;

                         
reg [3 :0]    r_cnt_detectok ;

wire          w_detect_finish;       

always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
		      begin		
				    rd_id_done <= 'd0;
				    rd_id_error <= 'd0;
				    station_id <= 'd0;
				    rack_id <= 'd0;
				    slot_id <= 'd0;
				end
        else
		      begin
				    if(o_idread_finish == 1 && o_station_err == 0 && o_rack_err == 0 && o_slot_err == 0)
					     begin
						      rd_id_done <= 1;
								station_id <= om_station_id;
								rack_id <= om_rack_id;   
								slot_id <= om_slot_id;   
						  end
					 else
					     rd_id_done <= 0;
					 if(o_idread_finish == 1 && (o_station_err == 1 || o_rack_err == 1 || o_slot_err == 1))
					     rd_id_error <= 'd1;
					 else
					     rd_id_error <= 'd0;  
				end
	 end

always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            r_cnt_clk <= 'd0;
        else 
            if(r_cnt_clk == (DELAY_1MS - 1'b1))
                r_cnt_clk <= 'd0;
            else
                r_cnt_clk <= r_cnt_clk + 1'b1;   
    end

always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            r_cnt_1ms <= 'd0;
        else if(r_cnt_clk == (DELAY_1MS - 1'b1))
            if(r_cnt_1ms >= (FILTER_DALAY - 1'b1))  
                r_cnt_1ms <= 'd0;
            else
                r_cnt_1ms <= r_cnt_1ms + 1'b1;   
    end
    
assign w_detect_enable = (r_cnt_clk == (DELAY_1MS - 1'b1)) && (r_cnt_1ms >= (FILTER_DALAY - 1'b1));

always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            r_id <= 'd0;
        else if(w_detect_enable)
            r_id <= {im_station,im_rack,im_slot};
    end 
                                               
always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            r_cnt_detect <= 'd0;
        else if(w_detect_enable && (r_cnt_detectok < DETECT_TIME)) 
            if(r_cnt_detect <= TIMEOUT - 1'b1)
                r_cnt_detect <= r_cnt_detect + 1'b1;
    end 

always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            r_cnt_detectok <= 'd0;
        else
            if(r_cnt_detectok >= DETECT_TIME)
                r_cnt_detectok <= r_cnt_detectok;           
            else if(w_detect_enable && (|r_cnt_detect))           
                if(r_id == {im_station,im_rack,im_slot})
                    r_cnt_detectok <= r_cnt_detectok + 1'b1;
                else
                    r_cnt_detectok <= 'd0;  
    end 

assign w_detect_finish = (r_cnt_detect >= TIMEOUT) || (r_cnt_detectok >= DETECT_TIME);

always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            o_idread_finish <= 'd0;
        else
            o_idread_finish <= w_detect_finish;
    end
    
always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            begin
            o_station_err <= 'd0;
            o_rack_err    <= 'd0;
            o_slot_err    <= 'd0;
            end
        else if(w_detect_finish)
            begin
            o_station_err <= (r_cnt_detect >= TIMEOUT) || ((CHK_ENABLE)? (^im_station == 1'b1) : 1'b0);
            o_rack_err    <= (r_cnt_detect >= TIMEOUT) || ((CHK_ENABLE)? (^im_rack    == 1'b1) : 1'b0);
            o_slot_err    <= (r_cnt_detect >= TIMEOUT) || ((CHK_ENABLE)? (^im_slot    == 1'b1) : 1'b0);
            end
    end
 
always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            begin
            om_station_id <= 'd0;
            om_rack_id    <= 'd0;
            om_slot_id    <= 'd0;
            end
        else if(w_detect_finish && (~o_idread_finish))
            begin
            om_station_id <= (r_cnt_detectok >= DETECT_TIME)? im_station[6:0] : 'd0;
            om_rack_id    <= (r_cnt_detectok >= DETECT_TIME)? im_rack[2:0]    : 'd0;
            om_slot_id    <= (r_cnt_detectok >= DETECT_TIME)? im_slot[3:0]    : 'd0;
            end
    end    
                        
endmodule