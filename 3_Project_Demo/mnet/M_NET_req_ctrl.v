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
// Name of module : M_NET_req_ctrl
// Project        : MN811_UT4_B01
// Func           : M_NET_req_ctrl
// Author         : Zhang xueyan
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FGG484
// version 1.0    : made in Date: 2016.11.12
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/06/12   Initial version(Zhang xueyan)
//
//
//
////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

module M_NET_req_ctrl(
   //-----------------------------------------------------------
   //--clock reset
   //-----------------------------------------------------------
    input  wire            sys_clk                ,//system clock ,50m
    input  wire            rst_n                  ,//reset ,active low
   //-----------------------------------------------------------
   //-- req
   //-----------------------------------------------------------
    input  wire            i_req_1                ,//front board request to send
    input  wire            i_req_2                ,//back  board request to send
    input  wire  [02:00]   im_mode_reg            ,//system mode: mode_run = 3'b001,mode_cons = 3'b010,mode_download = 3'b100

   //-----------------------------------------------------------
   //-- rx  data
   //-----------------------------------------------------------
    output reg   [07:00]   om_rd_addr_1           ,//read address of front board
    input  wire  [07:00]   im_rd_data_1           ,//read data of front board
    output reg   [07:00]   om_rd_addr_2           ,//read address of back board
    input  wire  [07:00]   im_rd_data_2           ,//read data of back board

    output wire            o_rx_start             ,// start to recive data
    output wire  [07:00]   om_rx_data_p           ,// receive data
    output wire            o_rx_data_en_p         ,// receive data enable
    output wire            o_rx_end               ,// stop receiving data

   //-----------------------------------------------------------
   //-- tx  data
   //-----------------------------------------------------------
    input  wire  [07:00]   im_tx_data             ,//send data
    input  wire            i_tx_data_en           ,//send data enable
    input  wire            i_tx_busy              ,//send data busy

    output reg             o_tx_data_en_1         ,//send data enable of front board
    output reg   [07:00]   om_tx_data_1           ,//send data to front board
    output reg             o_tx_data_en_2         ,//send data enable of back board
    output reg   [07:00]   om_tx_data_2            //send data to back board
    );
    //=======================================================
    // Local parameters
    //=======================================================

    parameter   NUM                 = 8'd156;// frame length ,except frame board and lead code
    parameter   IDLE                = 4'd0;  // idle
    parameter   FRONT_BOARD         = 4'd1;  // switch to front board
    parameter   BACK_BOARD          = 4'd2;  // switch to back board

    //=======================================================
    // Internal signal definition
    //=======================================================
    reg           r_req_1            ;
    reg           r_req_2            ;
    reg  [15:00]  r_count_1          ;
    reg  [15:00]  r_count_2          ;
    reg           r_rd_en_1          ;
    reg           r_rd_en_1_dly      ;
    reg           r_rd_en_1_dly1     ;
    reg           r_rd_en_2          ;
    reg           r_rd_en_2_dly      ;
    reg           r_rd_en_2_dly1     ;
    reg           r_rx_data_en_dly   ;
    reg  [03:00]  r_current_state    ;
    reg  [03:00]  r_next_state       ;
    wire          w_rx_start_1       ;
    wire          w_rx_start_2       ;
    reg           r_tx_busy          ;
    wire          w_tx_data_down     ;
    reg           r_tx_data_down_dly ;
    reg           r_tx_data_down_dly1;
    reg           r_tx_data_down_dly2;
    reg           r_tx_data_down_dly3;
    reg           r_tx_data_down_dly4;
   //=======================================================
   //  FSM
   //=======================================================

   // choose to receive  or send which board's data data . choose front board when two board data come at the same time ,
   // besides,send data to two board when system mode is 3'd2.

   // current state
    always @ (posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        r_current_state <= IDLE;
      else
        r_current_state <= r_next_state;
    end

   //next state
    always @ ( *)
    begin
      case(r_current_state)
        IDLE:
          begin
            if(r_req_1)
              r_next_state = FRONT_BOARD;
            else if(r_req_2)
              r_next_state = BACK_BOARD;
            else
              r_next_state = IDLE;
          end

        FRONT_BOARD:
          begin
            if((r_req_2 == 1  ) && (r_tx_data_down_dly4))
              r_next_state = BACK_BOARD;
            else if((r_tx_data_down_dly4) || (r_count_1 == 16'd1500))
              r_next_state = IDLE;
            else
              r_next_state = FRONT_BOARD;
          end

        BACK_BOARD:
          begin
            if((r_req_1 == 1  ) && (r_tx_data_down_dly4))
              r_next_state = FRONT_BOARD;
            else if((r_tx_data_down_dly4) || (r_count_2 == 16'd1500))
              r_next_state = IDLE;
            else
              r_next_state = BACK_BOARD;
          end
        default:
          begin
            r_next_state = IDLE;
          end

      endcase
    end

    //=======================================================
    //  Req
    //=======================================================

   //latch front board request
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        r_req_1 <= 1'b0;
      else if(i_req_1 )
        r_req_1 <= 1'b1;
      else if(r_current_state == FRONT_BOARD )
        r_req_1 <= 1'b0;
      else
        r_req_1 <= r_req_1;
    end

   //latch back board request
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        r_req_2 <= 1'b0;
      else if(i_req_2 )
        r_req_2 <= 1'b1;
      else if(r_current_state == BACK_BOARD )
        r_req_2 <= 1'b0;
      else
        r_req_2 <= r_req_2;
    end

   //delay a beat to tx busy
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        r_tx_busy <= 1'b0;
      else
        r_tx_busy <= i_tx_busy;
    end

   // get negedge of tx data down
    assign w_tx_data_down = ~i_tx_busy & r_tx_busy;

   //delay five beat to tx data down
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        begin
          r_tx_data_down_dly  <= 1'b0;
          r_tx_data_down_dly1 <= 1'b0;
          r_tx_data_down_dly2 <= 1'b0;
          r_tx_data_down_dly3 <= 1'b0;
          r_tx_data_down_dly4 <= 1'b0;
        end
      else
        begin
          r_tx_data_down_dly  <= w_tx_data_down;
          r_tx_data_down_dly1 <= r_tx_data_down_dly;
          r_tx_data_down_dly2 <= r_tx_data_down_dly1;
          r_tx_data_down_dly3 <= r_tx_data_down_dly2;
          r_tx_data_down_dly4 <= r_tx_data_down_dly3;
        end
    end

   //counter when state is in FRONT_BOARD
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        r_count_1 <= 16'b0;
      else if(r_current_state == FRONT_BOARD)
        r_count_1 <= r_count_1 + 1;
      else
        r_count_1 <= 16'b0;
    end

   //read address
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        om_rd_addr_1 <= 8'b0;
      else if((r_count_1 > 0) && (r_count_1 < NUM ) )
        om_rd_addr_1 <= om_rd_addr_1 + 1;
      else
        om_rd_addr_1 <= 8'b0;
    end

   //read enable
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        r_rd_en_1 <= 1'b0;
      else if((r_count_1 >= 0) &&(r_count_1 < NUM ) && (r_current_state == FRONT_BOARD))
        r_rd_en_1 <= 1'b1;
      else
        r_rd_en_1 <= 1'b0;
    end

   //read data valid
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        begin
          r_rd_en_1_dly   <= 1'b0;
          r_rd_en_1_dly1  <= 1'b0;
        end
      else
        begin
          r_rd_en_1_dly   <= r_rd_en_1;
          r_rd_en_1_dly1  <= r_rd_en_1_dly;
        end
    end

   //counter when state is in BACK_BOARD
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        r_count_2 <= 16'b0;
      else if(r_current_state == BACK_BOARD)
        r_count_2 <= r_count_2 + 1;
      else
        r_count_2 <= 16'b0;
    end

   //read address
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        om_rd_addr_2 <= 8'b0;
      else if((r_count_2 > 0) && (r_count_2 < NUM ) )
        om_rd_addr_2 <= om_rd_addr_2 + 1;
      else
        om_rd_addr_2 <= 8'b0;
    end

   //read enable
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        r_rd_en_2 <= 1'b0;
      else if((r_count_2 >= 0) &&(r_count_2 < NUM) && (r_current_state == BACK_BOARD))
        r_rd_en_2 <= 1'b1;
      else
        r_rd_en_2 <= 1'b0;
    end

   //read data valid
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        begin
          r_rd_en_2_dly  <= 1'b0;
          r_rd_en_2_dly1 <= 1'b0;
        end
      else
        begin
          r_rd_en_2_dly  <= r_rd_en_2;
          r_rd_en_2_dly1 <= r_rd_en_2_dly;
        end
    end

   //delay a beat to rx data enable
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        r_rx_data_en_dly  <= 1'b0;
      else
        r_rx_data_en_dly  <= o_rx_data_en_p;
    end

    assign  o_rx_end        = ~o_rx_data_en_p & r_rx_data_en_dly ;               //rx data end
    assign  om_rx_data_p    = (r_rd_en_1_dly1 )? im_rd_data_1 : im_rd_data_2;    //rx data
    assign  o_rx_data_en_p  = (r_rd_en_1_dly1 )? r_rd_en_1_dly1 : r_rd_en_2_dly1; //rx_data enable
    assign  w_rx_start_1    = r_rd_en_1 & ~r_rd_en_1_dly;
    assign  w_rx_start_2    = r_rd_en_2 & ~r_rd_en_2_dly;
    assign  o_rx_start      = w_rx_start_1 | w_rx_start_2;


   //send data
    always @(posedge sys_clk or negedge rst_n)
    begin
      if(!rst_n)
        begin
          o_tx_data_en_1 <= 1'd0;
          om_tx_data_1   <= 8'd0;
          o_tx_data_en_2 <= 1'd0;
          om_tx_data_2   <= 8'd0;
        end
      else if(im_mode_reg == 3'd2)
        begin
          o_tx_data_en_1 <= i_tx_data_en;
          om_tx_data_1   <= im_tx_data;
          o_tx_data_en_2 <= i_tx_data_en;
          om_tx_data_2   <= im_tx_data;
        end
      else if(r_current_state == FRONT_BOARD)
        begin
          o_tx_data_en_1 <= i_tx_data_en;
          om_tx_data_1   <= im_tx_data;
          o_tx_data_en_2 <= 1'b0;
          om_tx_data_2   <= 8'd0;
        end
      else if(r_current_state == BACK_BOARD)
        begin
          o_tx_data_en_1 <= 1'b0;
          om_tx_data_1   <= 8'd0;
          o_tx_data_en_2 <= i_tx_data_en;
          om_tx_data_2   <= im_tx_data;
        end
      else
        begin
          o_tx_data_en_1 <= 1'b0;
          om_tx_data_1   <= 8'd0;
          o_tx_data_en_2 <= 1'b0;
          om_tx_data_2   <= 8'd0;
        end
    end

    endmodule