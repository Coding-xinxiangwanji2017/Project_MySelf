/*=======================================================================================*\
--  Copyright (c)2015 CNCS Incorporated
\*=======================================================================================*\
  All Rights Reserved
  THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of CNCS Inc.

  The copyright notice above does not evidence any actual or intended publication of
  such source code. No part of this code may be reproduced, stored in a retrieval
  system, or transmitted, in any form or by any means, electronic, mechanical,
  photocopying, recording, or otherwise, without the prior written permission of CNCS.

/*=======================================================================================*\
--  RTL File Attribute
\*=======================================================================================*\
  -- Project     : NicSys8000N
  -- Simulator   : Modelsim 10.2         Windows-7 64bit
  -- Synthesizer : LiberoSoC v11.5 SP2   Windows-7 64bit
  -- FPGA Type   : Microsemi  M2GL050-FGG484

  -- Module Funcion : M_NET top file
  -- Initial Author : Tan Xingye


  -- Modification Logs:
     --------------------------------------------------------------------------------
       Version      Date            Description(Recorder)
     --------------------------------------------------------------------------------
         1.0     2016/04/12     Initial version(Tan Xingye)




/*=======================================================================================*/


`timescale 1ns / 100ps

module M_NET(

    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input                rst_n            ,

    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input                clk_50m          ,

    //------------------------------------------
    //-- Ethernet, RMII interface
    //------------------------------------------
    input                ETH_RXD[1:0]    ,
    input                ETH_RXDV        ,
    input                ETH_RXER        ,
    input                ETH_INTRP       ,
    inout                ETH_MDIO        ,
    output               ETH_TXEN        ,
    output               ETH_TXD[1:0]    ,
    output               ETH_RST_n       ,
    //-- REFCLK, Output for PFPGA, input for 
    output               ETH_REFCLK      ,
    input                ETH_LEDG        ,
    input                ETH_LEDY        ,
    input                ETH_COM_LED     ,
    
    //------------------------------------------
    //-- application interface:  
    //------------------------------------------
    //-- TX
    input             Tx_Ram_Wr         ,
    input  [7:0]      Tx_Ram_Addr,
    input  [7:0]      Tx_Ram_Data,
    input   Tx_Start,
    
    //-- Rx
    input Rx_Ram_Rd,
    input   [7:0]  Rx_Ram_Addr,
    output  [7:0]  Rx_Ram_Data,
    output         Rx_Done
    );



   //=========================================================
   // Local parameters
   //=========================================================
   parameter DLY       = 1;
   parameter IDLE      = 4'b0001,
             WAIT_CMP  = 4'b0010,
             CALCULATE = 4'b0100,
             WAIT_OUT  = 4'b1000;

   //=========================================================
   // Internal signal definition
   //=========================================================
   wire      [1:0]      RMII_Tx_D   ;
   wire                 RMII_Tx_DV  ;
   wire      [1:0]      RMII_Rx_D   ;
   wire                 RMII_Rx_DV  ;



   reg[3  : 0]   curr_state;
   reg[3  : 0]   next_state;
   reg           tmp_input_ena;
   reg[31 : 0]   tmp_input_real;
   reg[31 : 0]   tmp_input_imag;
   reg           tmp_real_type;
   reg           tmp_imag_type;
   reg[1:0]      tmp_quadrant_type; // 0, 1, 2, 3

   wire          tmp_output_ena;
   wire[15 : 0]  tmp_output_data;




   assign ETH_REFCLK = clk_50m;


   //=========================================================
   // 
   //=========================================================
   RMII RMII_inst(
    //------------------------------------------
    //--  clock,  reset(active low)
    //------------------------------------------
    .clk       (ETH_REFCLK),
    .rst_n     (rst_n),
    //------------------------------------------
    //-- phy side
    //------------------------------------------
    .rx_en     (ETH_RXDV),
    .rxd       (ETH_RXD),
    .tx_en     (ETH_TXEN),
    .txd       (ETH_TXD),
    //------------------------------------------
    //-- system side
    //------------------------------------------
    //-- Send: 8bits data and send each 4 clock cycles
    .tx_data_en  (RMII_Tx_DV),
    .tx_data     (RMII_Tx_D ),
    .rx_data_en  (RMII_Rx_DV),
    .rx_data     (RMII_Rx_D )
    );

    
    
    
    
    
   RAM_2048_8_SDP Rx_Ram_inst(
    .WD      (Tx_Ram_Wr),
    .RD      (RD),
    .WEN     (Tx_Ram_Wr),
    .REN     (REN),
    .WADDR   (Tx_Ram_Wr),
    .RADDR   (RADDR),
    .WCLK    (wclk),
    .RCLK    (Rclk)
    );





endmodule



/*



   //=========================================================
   // Current state
   //=========================================================
   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         curr_state <= IDLE;
      else
         curr_state <= #DLY next_state;
   end

   //=========================================================
   // Next state
   //=========================================================
   always @(input_ena or curr_state or tmp_output_ena)
   begin
      case ( curr_state )
         IDLE :
            if ( input_ena == 1'b1 )
               next_state = WAIT_CMP;
            else
               next_state = IDLE;
         WAIT_CMP :
            next_state = CALCULATE;
         CALCULATE :
            next_state = WAIT_OUT;
         WAIT_OUT :
            if ( tmp_output_ena == 1'b1 )
               next_state = IDLE;
            else
               next_state = WAIT_OUT;
         default:
            next_state = IDLE;
      endcase
   end

   //=========================================================
   // tmp_input_ena : Using D Flip-flop to buffer
   //=========================================================
   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         tmp_input_ena <= 1'b0;
      else
         if ( curr_state == IDLE)
            tmp_input_ena <= #DLY input_ena;
         else
            tmp_input_ena <= #DLY 1'b0;
   end

   //=========================================================
   // tmp_input_real : the input_real is change to value larger than 0
   //=========================================================
   always @(posedge clk_50m or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         tmp_input_real <= 0;
      else
         if ( curr_state == IDLE && input_ena == 1'b1 )
            if ( input_real > 0 )
               tmp_input_real <= #DLY input_real;
            else
               tmp_input_real <= #DLY (~input_real) + 1;
         else
            tmp_input_real <= #DLY tmp_input_real;
   end




   arctan_cal arctan_cal_inst(
              .rst_n      (rst_n),
              .clk_50m    (clk_50m),
              .input_ena  (tmp_input_ena),
              .input_real (tmp_input_real),
              .input_imag (tmp_input_imag),
              .output_ena (tmp_output_ena),
              .output_data(tmp_output_data)
              );





*/