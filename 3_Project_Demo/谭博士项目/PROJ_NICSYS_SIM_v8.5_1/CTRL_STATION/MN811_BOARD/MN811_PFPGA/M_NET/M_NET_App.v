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

module M_NET_App(

    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input                rst_n            ,

    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input                clk_50m          ,

    //------------------------------------------
    //-- Application
    //------------------------------------------
    input        Tx_Ram_WEN         ,
    input  [7:0] Tx_Ram_WADDR,
    input  [7:0] Tx_Ram_WD,
    input        Tx_Start,
    output       Tx_Busy,

    //-- Rx
    input          Rx_Ram_REN,
    input   [7:0]  Rx_Ram_RADDR,
    output  [7:0]  Rx_Ram_RD,
    output         Rx_Done,
    output         Rx_Err,


    //------------------------------------------
    //-- RMII Module
    //------------------------------------------
    //-- Send: 8bits data and send each 4 clock cycles
    output reg            Tx_Data_En,
    output reg     [7:0]  Tx_Data   ,

    input                Rx_Start,
    input                Rx_end,
    input                Rx_Data_En,
    input       [7:0]    Rx_Data
    );



   //=========================================================
   // Local parameters
   //=========================================================
   parameter DLY       = 1;

   parameter LINK_DATA_LENGTH        = 152 - 1;
   parameter LINK_FRAME_LENGTH       = 156 - 1;     // Data and CRC

   //-- Tx State
   parameter          TxState_IDLE        = 4'b000001;
   parameter          TxState_DATA_SEND   = 4'b000010;
   parameter          TxState_CRC_SEND    = 4'b000100;
   parameter          TxState_WAIT1       = 4'b001000;
   parameter          TxState_WAIT2       = 4'b010000;
   parameter          TxState_WAIT3       = 4'b100000;

   //=========================================================
   // Internal signal definition
   //=========================================================
   wire          rst;
   reg[3  : 0]   curr_state;
   reg[3  : 0]   next_state;

   reg[7  : 0]   Send_Cnt;
   reg           CRC_Rdy;
   reg           Send_end;

   wire[11 : 0]   Tx_Ram_RADDR;
   reg[ 7 : 0]   Tx_Ram_RADDR_L8;
   //reg[11 : 0]   Tx_Ram_WADDR;
   reg[ 7 : 0]   Tx_Ram_WADDR_L8;
   reg[ 7 : 0]   Tx_Ram_RD;
   //reg[ 7 : 0]   Tx_Ram_RD;

   reg           Tx_Ram_REN;
   reg           Tx_Ram_REN_D1;
   reg           Tx_Ram_REN_D2;


   reg[31 : 0]   Tx_CRC_Rlt;
   reg[31 : 0]   CRC_Rlt_Shift;


   //----------------------------
   //-- Rx signal
   //---------------------------
   wire[11 : 0]    Rx_Ram_WADDR;
   reg[ 7 : 0]    Rx_Ram_WADDR_L8;
   //reg[11 : 0]    Rx_Ram_RADDR;
   reg[ 7 : 0]    Rx_Ram_RADDR_L8;
   wire[ 7 : 0]    Rx_Ram_WD;
   //reg[ 7 : 0]    Rx_Ram_RD;
   wire            Rx_Ram_WEN;
   //reg            Rx_Ram_REN;
   

   reg            Rx_end_D1;
   reg            Rx_end_D2;   

   wire           Rx_CRC_Fail;
 
 
   //reg    [7:0]  Tx_Data; 
   //reg           Tx_Data_En;

   //=========================================================
   //
   //=========================================================
   assign rst        = ~rst_n;
   assign ETH_REFCLK = clk_50m;


/*


   //********************************************************************************
   //   Tx control
   //********************************************************************************
   //=========================================================
   // Current state
   //=========================================================
   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         Send_Cnt <= 8'b0;
      else
      if ( rst_n == 1'b0 )
         Send_Cnt     <= 8'b0;
      else
         if ( Tx_Start == 1'b1)
             Send_Cnt     <= 8'b0;
         else if ( curr_state == TxState_DATA_SEND || curr_state == TxState_CRC_SEND )
            Send_Cnt <= Send_Cnt + 1 ;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         Send_end <= 1'b0;
      else
         if ( curr_state == TxState_CRC_SEND || Send_Cnt == LINK_FRAME_LENGTH )
             Send_end     <= 1'b1;
         else
             Send_end <= 1'b0;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         CRC_Rdy <= 1'b0;
      else
         if ( curr_state == TxState_DATA_SEND || Send_Cnt == LINK_DATA_LENGTH )
             CRC_Rdy     <= 1'b1;
         else
             CRC_Rdy <= 1'b0;
   end


   //=========================================================
   // Next state
   //=========================================================
   always @(*)
   begin
      case ( curr_state )
         TxState_IDLE :
            if ( Tx_Start == 1'b1 )
               next_state = TxState_DATA_SEND;
            else
               next_state = TxState_IDLE;
         TxState_DATA_SEND :
            next_state = TxState_WAIT1;
         TxState_WAIT1 :
            next_state = TxState_WAIT2;
         TxState_WAIT2 :
            next_state = TxState_WAIT3;
         TxState_WAIT3 :
            if ( CRC_Rdy == 1'b1 )
               next_state = TxState_CRC_SEND;
            else if ( Send_end == 1'b1 )
               next_state = TxState_IDLE;
            else
                next_state = TxState_DATA_SEND;
         TxState_CRC_SEND :
               next_state = TxState_WAIT1;
         default:
            next_state = TxState_IDLE;
      endcase
   end



   //=========================================================
   // Send control
   //=========================================================

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         Send_Cnt     <= 8'b0;
      else
         if ( Tx_Start == 1'b1)
             Send_Cnt <=  8'b0;
         else if( curr_state == TxState_DATA_SEND || curr_state == TxState_CRC_SEND  )
            Send_Cnt <= Send_Cnt + 1 ;
         else
            Tx_Ram_REN <= 1'b0 ;
   end


   //=========================================================
   // Tx Ram
   //=========================================================

   //assign Tx_Data_En =  Tx_Ram_REN_D2;

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         Tx_Ram_REN     <= 1'b0;
      else
         if ( curr_state == TxState_DATA_SEND  )
            Tx_Ram_REN <= 1'b1 ;
         else
            Tx_Ram_REN <= 1'b0 ;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
         Tx_Ram_REN_D1     <= 1'b0;
         Tx_Ram_REN_D2     <= 1'b0;
      end
      else
      begin
         Tx_Ram_REN_D1     <= Tx_Ram_REN;
         Tx_Ram_REN_D2     <= Tx_Ram_REN_D1;
      end
   end

   assign Tx_Ram_RADDR[11:8] = 4'b0;
   assign Tx_Ram_RADDR[ 7:0] = Tx_Ram_RADDR_L8;

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         Tx_Ram_RADDR_L8     <= 8'b0;
      else
         if ( Tx_Start == 1'b1)
             Tx_Ram_RADDR_L8     <= 8'b0;
         else if ( curr_state == TxState_DATA_SEND  )
            Tx_Ram_RADDR_L8 <= Tx_Ram_RADDR_L8 + 1 ;
   end


   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         Tx_Data     <= 8'b0;
      else
         if ( Tx_Ram_REN_D2 == 1'b1)
             Tx_Data     <= Tx_Ram_RD;
         else if ( curr_state == TxState_DATA_SEND  )
             Tx_Data     <= CRC_Rlt_Shift[7:0] ;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         Tx_Data_En     <= 1'b0;
      else
         if ( Tx_Ram_REN_D2 == 1'b1)
             Tx_Data_En     <= 1'b1;
         else if ( curr_state == TxState_CRC_SEND  )
             Tx_Data_En     <= 1'b1 ;
         else
             Tx_Data_En     <= 1'b0;
   end



   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         CRC_Rlt_Shift     <= 8'b0;
      else
         if ( Tx_Ram_REN_D2 == 1'b1)
             CRC_Rlt_Shift     <= Tx_Ram_RD;
         else if ( curr_state == TxState_CRC_SEND )
             CRC_Rlt_Shift[23:0]     <= CRC_Rlt_Shift[31:8] ;
   end



   //********************************************************************************
   //   Rx control
   //********************************************************************************
   
   assign Rx_Ram_WEN =  Rx_Data_En ;
   assign Rx_Ram_WD  =  Rx_Data ;
   assign Rx_Done    =  Rx_end_D2;
   assign Rx_Err     =  1'b0;
   
   assign Rx_Ram_WADDR = {4'b0, Rx_Ram_WADDR_L8};

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         Rx_Ram_WADDR_L8     <= 8'b0;
      else
         if ( Rx_Start == 1'b1  )
             Rx_Ram_WADDR_L8 <= 1'b1 ;
         else if ( Rx_Data_En == 1'b1 )
             Rx_Ram_WADDR_L8 <= 1'b0 ;
   end

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
         Rx_end_D1     <= 1'b0;
         Rx_end_D2     <= 1'b0;
      end
      else
      begin
         Rx_end_D1     <= Rx_end;
         Rx_end_D2     <= Rx_end_D1;
      end
   end
     

   assign Tx_Ram_RADDR[11:8] = 4'b0;
   assign Tx_Ram_RADDR[ 7:0] = Tx_Ram_RADDR_L8;

   always @(posedge ETH_REFCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
         Rx_Ram_WADDR_L8     <= 8'b0;
      else
         if ( Rx_Start == 1'b1)
             Rx_Ram_WADDR_L8     <= 8'b0;
         else if ( Rx_Data_En == 1'b1  )
            Rx_Ram_WADDR_L8 <= Rx_Ram_WADDR_L8 + 1 ;
   end


   //=========================================================
   //
   //=========================================================

   M_Crc32En8 M_Crc32En8_inst(
    .CpSv_Data_i      (Tx_Data      ),
    .CpSl_Rst_i       (rst          ),
    .CpSl_CrcEn_i     (Tx_Data_En   ),
    .CpSv_CrcResult_o (Tx_CRC_Rlt  ),
    .CpSl_Clk_i       (ETH_REFCLK   ),
    .CpSl_Init_i      (Tx_Start     )
    );

   M_Crc32De8 M_Crc32De8_inst(
    .CpSl_Rst_i       (rst     ),
    .CpSl_Clk_i       (ETH_REFCLK     ),
    .CpSl_Init_i      (Rx_Start     ),
    .CpSv_Data_i      (Rx_Data     ),
    .CpSl_CrcEn_i     (Rx_Data_En     ),
    .CpSl_CrcEnd_i    (Rx_end_D1     ),
    .CpSl_CrcErr_o    (Rx_CRC_Fail     )
    );


   //=========================================================
   // Component Declarations
   //=========================================================
   //-- Tx Buffer
   RAM_2048_8_SDP Tx_Ram_inst(
    .WD      (Tx_Ram_WD),
    .RD      (Tx_Ram_RD),
    .WEN     (Tx_Ram_WEN),
    .REN     (Tx_Ram_REN),
    .WADDR   (Tx_Ram_WADDR),
    .RADDR   (Tx_Ram_RADDR),
    .WCLK    (clk_50m),
    .RCLK    (ETH_REFCLK)
    );

   //-- Rx Buffer
   RAM_2048_8_SDP Rx_Ram_inst(
    .WD      (Rx_Ram_WD),
    .RD      (Rx_Ram_RD),
    .WEN     (Rx_Ram_WEN),
    .REN     (Rx_Ram_REN),
    .WADDR   (Rx_Ram_WADDR),
    .RADDR   (Rx_Ram_RADDR),
    .WCLK    (ETH_REFCLK),
    .RCLK    (clk_50m)
    );

*/


endmodule
