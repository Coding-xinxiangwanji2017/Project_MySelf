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
// Name of module : mn811_led                                                   
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


module M_NET_RMII (
    //------------------------------------------
    //--  clock,  reset(active low)
    //------------------------------------------
    input               clk       ,
    input               rst_n     ,

    //------------------------------------------
    //-- phy side
    //------------------------------------------
    input               rx_en_p     ,
    input        [1:0]  rxd_p       ,
    output  reg         tx_en_p     ,
    output  reg  [1:0]  txd_p       ,

    //------------------------------------------
    //-- system side
    //------------------------------------------
    //-- Send: 8bits data and send each 4 clock cycles
    input               tx_data_en,
    input        [7:0]  tx_data   ,

    output  wire     rx_start,
    output            rx_end,
    output  reg            rx_data_en_p,
    output  reg  [7:0]  rx_data_p
    );


   //=========================================================
   // Internal register definition
   //=========================================================
   reg    [5:0]     rx_cnt;
   reg              rx_en_s;
   reg    [1:0]     rxd_s;
   reg              rx_en_d0;
   reg    [1:0]     rxd_d0;
   reg              rx_en_comb_d0,rx_en_comb_d1;
   reg    [1:0]     rx_bit_cnt;
   reg              rx_data_en;
   reg    [7:0]     rx_data;

   reg    [7:0]     tx_data_d0;
   reg    [1:0]     tx_bit_cnt;
   //reg              tx_en;
   //reg    [1:0]     txd;


   reg               rx_en;
   reg        [1:0]  rxd;

   reg               rx_en_p_d1,rx_en_p_d2,rx_en_p_d3;
   reg        [1:0]  rxd_p_d1,rxd_p_d2,rxd_p_d3;

   wire     rxd_p_d1_or_d2;
   reg      rxd_p_d1_or_d2_d1;
   wire     rxd_p_d1_or_d2_pulse;
   
   reg               tx_en;
   reg        [1:0]  txd;    
   reg               tx_en_d1;
   reg        [1:0]  txd_d1;   
   //=========================================================
   // port latch
   //=========================================================

   assign rxd_p_d1_or_d2       = rx_en_p_d1 | rx_en_p_d2 ;
   assign rxd_p_d1_or_d2_pulse = rxd_p_d1_or_d2 & (~rxd_p_d1_or_d2_d1) ;
   always @ (negedge rst_n or posedge clk)
     if(rst_n == 1'b0) begin
       rx_en_p_d1    <= 1'b0;
       rxd_p_d1      <= 2'b0;

       rx_en_p_d2    <= 1'b0;
       rxd_p_d2      <= 2'b0;

       rx_en_p_d3    <= 1'b0;
       rxd_p_d3      <= 2'b0;

     end
     else begin

       rxd_p_d1      <= rxd_p  ;
       rxd_p_d2      <= rxd_p_d1  ;
       rxd_p_d3      <= rxd_p_d2  ;
       
       rx_en_p_d1    <= rx_en_p;
       
       rx_en_p_d2         <=  rx_en_p_d1;
       rxd_p_d1_or_d2_d1  <= rxd_p_d1_or_d2;

       rx_en         <= rxd_p_d1_or_d2_d1 & rxd_p_d1_or_d2;
       rxd           <= rxd_p_d2 ;

     end


   //=========================================================
   //rx side
   //filter the first coming all"0"
   //=========================================================

   assign  rx_start =  rx_en_s && (~rx_en_d0);
   assign  rx_end   = rx_en_comb_d1 && (~rx_en_comb_d0);

   always @ (negedge rst_n or posedge clk)
     if(rst_n == 1'b0) begin
       rx_en_s <= 1'b0;
       rxd_s <= 2'b0;
       rx_cnt <= 6'b0;
     end
     else begin
       rxd_s <= rxd;
       if(rx_en_comb_d0 == 1'b1) begin
         if(rx_cnt < 60) begin
           rx_cnt <= rx_cnt + 1;
         end
       end
       else begin
         rx_cnt <= 6'b0;
       end
       if(rx_cnt < 20) begin
         //SFD
         if(rx_en == 1'b1 && rxd == 2'b11) begin
           rx_en_s <= 1'b1;
         end
       end
       else begin
         rx_en_s <= rx_en;
       end
       if(rx_en == 1'b0) begin
         rx_en_s <= 1'b0;
       end
     end
   always @ (negedge rst_n or posedge clk)
     if(rst_n == 1'b0) begin
       rx_en_d0 <= 1'b0;
       rx_en_comb_d0 <= 1'b0;
       rx_en_comb_d1 <= 1'b0;

       rxd_d0 <= 2'b0;
       rx_bit_cnt <= 2'b0;
     end
     else begin
       rx_en_d0 <= rx_en_s;
       rx_en_comb_d0 <= rx_en_d0 | rx_en_s;
       rxd_d0 <= rxd_s;
       if(rx_en_comb_d0 == 1'b1) begin
         rx_bit_cnt <= rx_bit_cnt + 1;
       end
       else begin
         rx_bit_cnt <= 2'b0;
       end

       rx_en_comb_d1 <= rx_en_comb_d0;

     end

   always @ (negedge rst_n or posedge clk)
     if(rst_n == 1'b0) begin
       rx_data_en <= 1'b0;
       rx_data <= 8'b0;
     end
     else begin
       rx_data_en <= 1'b0;
       if(rx_en_comb_d0 == 1'b1) begin
         if(rx_bit_cnt == 2'd3) begin
           rx_data_en <= 1'b1;
         end
         case (rx_bit_cnt)
         6'd0  : begin
                   rx_data[1:0] <= rxd_s;
                 end
         6'd1  : begin
                   rx_data[3:2] <= rxd_s;
                 end
         6'd2  : begin
                   rx_data[5:4] <= rxd_s;
                 end
         6'd3  : begin
                   rx_data[7:6] <= rxd_s;
                 end
         default  : begin
                     rx_data <= 8'b0;
                   end
         endcase
       end
     end

   always @ (negedge rst_n or posedge clk)
     if(rst_n == 1'b0) begin
       rx_data_p <= 1'b0;
       rx_data_en_p <= 8'b0;
     end
     else begin

       rx_data_en_p <= rx_data_en;

       if(rx_data_en == 1'b1) begin
         rx_data_p <= rx_data;
       end
       else begin
         rx_data_p <= 8'b0;
       end
     end



   //=========================================================
   //tx side
   //=========================================================


/*
   //tx side, negedge
   always @ (negedge rst_n or negedge clk)
     if(rst_n == 1'b0) begin
       tx_en <= 1'b0;
       tx_bit_cnt <= 2'b0;
       tx_data_d0 <= 8'b0;
     end
     else begin
       tx_data_d0 <= tx_data;
       if(tx_data_en == 1'b1) begin
         tx_en <= 1'b1;
       end
       else begin
         if(tx_bit_cnt == 2'd3) begin
           tx_en <= 1'b0;
         end
       end
       if(tx_en == 1'b1) begin
         tx_bit_cnt <= tx_bit_cnt + 1;
       end
       else begin
         tx_bit_cnt <= 2'b0;
       end
     end
   always @ (*)
     begin
       case (tx_bit_cnt)
         2'd0  : begin
                   txd <= tx_data_d0[1:0];
                 end
         2'd1  : begin
                   txd <= tx_data_d0[3:2];
                 end
         2'd2  : begin
                   txd <= tx_data_d0[5:4];
                 end
         2'd3  : begin
                   txd <= tx_data_d0[7:6];
                 end
         default  : begin
                     txd <= 2'b0;
                   end
       endcase
    end


   always @ (negedge rst_n or negedge clk)
     if(rst_n == 1'b0) begin
       tx_en_d1 <= 1'b0;
       txd_d1   <= 2'b0;
     end
     else begin
       tx_en_d1 <= tx_en;
       txd_d1   <= txd;
     end

*/

   //tx side, negedge
   always @ (negedge rst_n or posedge clk)
     if(rst_n == 1'b0) begin
       tx_en <= 1'b0;
       tx_bit_cnt <= 2'b0;
       tx_data_d0 <= 8'b0;
     end
     else begin
       tx_data_d0 <= tx_data;
       if(tx_data_en == 1'b1) begin
         tx_en <= 1'b1;
       end
       else begin
         if(tx_bit_cnt == 2'd3) begin
           tx_en <= 1'b0;
         end
       end
       if(tx_en == 1'b1) begin
         tx_bit_cnt <= tx_bit_cnt + 1;
       end
       else begin
         tx_bit_cnt <= 2'b0;
       end
     end
   always @ (*)
     begin
       case (tx_bit_cnt)
         2'd0  : begin
                   txd <= tx_data_d0[1:0];
                 end
         2'd1  : begin
                   txd <= tx_data_d0[3:2];
                 end
         2'd2  : begin
                   txd <= tx_data_d0[5:4];
                 end
         2'd3  : begin
                   txd <= tx_data_d0[7:6];
                 end
         default  : begin
                     txd <= 2'b0;
                   end
       endcase
    end


   always @ (negedge rst_n or posedge clk)
     if(rst_n == 1'b0) begin
       tx_en_d1 <= 1'b0;
       txd_d1   <= 2'b0;
     end
     else begin
       tx_en_d1 <= tx_en;
       txd_d1   <= txd;
     end     
     
   always @ (negedge rst_n or negedge clk)
     if(rst_n == 1'b0) begin
       tx_en_p <= 1'b0;
       txd_p   <= 2'b0;
     end
     else begin
       tx_en_p <= tx_en_d1  ;
       txd_p   <= txd_d1;  

     end





endmodule
