/*=======================================================================================*\
--  Copyright (c)2015 CNCS Incorporated
\*=======================================================================================*\
  All Rights Reserved
  THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of CNCS Inc.

  The copyright notice above does not evidence any actual or intended publication of
  such source code. No part of this code may be reproduced, stored in a retrieval
  system, or transmitted, in any form or by any means, electronic, mechanical,
  photocopying, recording, or otherwise, without the prior written permission of CNCS.
  
  Beijing Bixing Technology Company Limited is responsible for project development.
  
/*=======================================================================================*\
--  RTL File Attribute
\*=======================================================================================*\
  -- Project     : NicSys8000N
  -- Simulator   : Modelsim 10.2         Windows-7 64bit
  -- Synthesizer : LiberoSoC v11.5 SP2   Windows-7 64bit
  -- FPGA Type   : Microsemi  M2GL050-FGG484

  -- Module Funcion : Ethernet MAC, RMII Interface
  -- Initial Author : Tan Xingye


  -- Modification Logs:
     --------------------------------------------------------------------------------
       Version      Date            Description(Recorder)
     --------------------------------------------------------------------------------
         1.0     2016/04/12     Initial version(Tan Xingye)




/*=======================================================================================*/

module M_NET_RMII ( 
    //------------------------------------------
    //--  clock,  reset(active low)              
    //------------------------------------------
    input               clk       ,
    input               rst_n     ,
    
    //------------------------------------------
    //-- phy side                
    //------------------------------------------    
    input               rx_en     ,
    input        [1:0]  rxd       ,
    output  reg         tx_en     ,
    output  reg  [1:0]  txd       ,
    
    //------------------------------------------
    //-- system side           
    //------------------------------------------    
    //-- Send: 8bits data and send each 4 clock cycles
    input               tx_data_en,
    input        [7:0]  tx_data   ,
    
    output  reg            rx_data_en,
    output  reg  [7:0]  rx_data
    );


   //=========================================================
   // Internal register definition
   //=========================================================
   reg    [5:0]     rx_cnt;
   reg              rx_en_s;
   reg    [1:0]     rxd_s;
   reg              rx_en_d0;
   reg    [1:0]     rxd_d0;
   reg              rx_en_comb_d0;
   reg    [1:0]     rx_bit_cnt;
   //reg              rx_data_en;
   //reg    [7:0]     rx_data;
                  
   reg    [7:0]     tx_data_d0;
   reg    [1:0]     tx_bit_cnt;
   //reg              tx_en;
   //reg    [1:0]     txd;

   //=========================================================
   //rx side
   //filter the first coming all"0"                               
   //=========================================================

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
   
   
   //tx side
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

endmodule
