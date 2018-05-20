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
// Name of module : tb_SYSTEM
// Project        : NicSys8000
// Func           : testbench for control station
// Author         : Tan Xingye
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FGG484
// version 1.0    : made in Date: 2016.4.21
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/04/21   Initial version(Tan Xingye)
//
//
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps


module tb_SYSTEM(

);

//------------------------------------------------------------------------------
//参数声明  开始
//------------------------------------------------------------------------------
  parameter GND = 1'd0;




//------------------------------------------------------------------------------
//参数声明  结束
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
//内部变量声明  开始
//------------------------------------------------------------------------------


   wire       STAT1_Channel_1_TX_P;
   wire       STAT1_Channel_1_TX_N;
   wire       STAT1_Channel_1_RX_P;
   wire       STAT1_Channel_1_RX_N;
                                  
   wire       STAT1_Channel_2_TX_P;
   wire       STAT1_Channel_2_TX_N;
   wire       STAT1_Channel_2_RX_P;
   wire       STAT1_Channel_2_RX_N;
                                  
   wire       STAT1_Channel_3_TX_P;
   wire       STAT1_Channel_3_TX_N;
   wire       STAT1_Channel_3_RX_P;
   wire       STAT1_Channel_3_RX_N;
                                  
   wire       STAT1_Channel_4_TX_P;
   wire       STAT1_Channel_4_TX_N;
   wire       STAT1_Channel_4_RX_P;
   wire       STAT1_Channel_4_RX_N;
                                  
   wire       STAT1_Channel_5_TX_P;
   wire       STAT1_Channel_5_TX_N;
   wire       STAT1_Channel_5_RX_P;
   wire       STAT1_Channel_5_RX_N;
                                  
   wire       STAT1_Channel_6_TX_P;
   wire       STAT1_Channel_6_TX_N;
   wire       STAT1_Channel_6_RX_P;
   wire       STAT1_Channel_6_RX_N;
                                  
                                  
   wire       STAT2_Channel_1_TX_P;
   wire       STAT2_Channel_1_TX_N;
   wire       STAT2_Channel_1_RX_P;
   wire       STAT2_Channel_1_RX_N;
                                  
   wire       STAT2_Channel_2_TX_P;
   wire       STAT2_Channel_2_TX_N;
   wire       STAT2_Channel_2_RX_P;
   wire       STAT2_Channel_2_RX_N;
                                  
   wire       STAT2_Channel_3_TX_P;
   wire       STAT2_Channel_3_TX_N;
   wire       STAT2_Channel_3_RX_P;
   wire       STAT2_Channel_3_RX_N;
                                  
   wire       STAT2_Channel_4_TX_P;
   wire       STAT2_Channel_4_TX_N;
   wire       STAT2_Channel_4_RX_P;
   wire       STAT2_Channel_4_RX_N;
                                  
   wire       STAT2_Channel_5_TX_P;
   wire       STAT2_Channel_5_TX_N;
   wire       STAT2_Channel_5_RX_P;
   wire       STAT2_Channel_5_RX_N;
                                  
   wire       STAT2_Channel_6_TX_P;
   wire       STAT2_Channel_6_TX_N;
   wire       STAT2_Channel_6_RX_P;
   wire       STAT2_Channel_6_RX_N;

//   wire       STAT1_CH1_TXD_EN;
//   wire       STAT1_CH1_TXD;
//   wire       STAT1_CH1_RXD;
//   wire       STAT1_CH2_TXD_EN;
//   wire       STAT1_CH2_TXD;
//   wire       STAT1_CH2_RXD;
//   wire       STAT1_CH3_TXD_EN;
//   wire       STAT1_CH3_TXD;
//   wire       STAT1_CH3_RXD;
//   wire       STAT1_CH4_TXD_EN;
//   wire       STAT1_CH4_TXD;
//   wire       STAT1_CH4_RXD;
//   wire       STAT1_CH5_TXD_EN;
//   wire       STAT1_CH5_TXD;
//   wire       STAT1_CH5_RXD;
//   wire       STAT1_CH6_TXD_EN;
//   wire       STAT1_CH6_TXD;
//   wire       STAT1_CH6_RXD;
//
//   wire       STAT2_CH1_TXD_EN;
//   wire       STAT2_CH1_TXD;
//   wire       STAT2_CH1_RXD;
//   wire       STAT2_CH2_TXD_EN;
//   wire       STAT2_CH2_TXD;
//   wire       STAT2_CH2_RXD;
//   wire       STAT2_CH3_TXD_EN;
//   wire       STAT2_CH3_TXD;
//   wire       STAT2_CH3_RXD;
//   wire       STAT2_CH4_TXD_EN;
//   wire       STAT2_CH4_TXD;
//   wire       STAT2_CH4_RXD;
//   wire       STAT2_CH5_TXD_EN;
//   wire       STAT2_CH5_TXD;
//   wire       STAT2_CH5_RXD;
//   wire       STAT2_CH6_TXD_EN;
//   wire       STAT2_CH6_TXD;
//   wire       STAT2_CH6_RXD;


   wire             STAT1_ETH_RST_n;
   wire             STAT1_ETH_REFCLK;
   wire [ 1: 0]     STAT1_ETH_RXD_O;
   wire             STAT1_ETH_RXDV_O;
   wire             STAT1_ETH_RXER;
   wire             STAT1_ETH_TXEN;
   wire [ 1: 0]     STAT1_ETH_TXD;
   wire             STAT1_ETH_COM_LED;

   wire             STAT2_ETH_RST_n;
   wire             STAT2_ETH_REFCLK;
   wire [ 1: 0]     STAT2_ETH_RXD_O;
   wire             STAT2_ETH_RXDV_O;
   wire             STAT2_ETH_RXER;
   wire             STAT2_ETH_TXEN;
   wire [ 1: 0]     STAT2_ETH_TXD;
   wire             STAT2_ETH_COM_LED;


   wire [ 1: 0]     ETH_RXD;
   wire             ETH_RXDV;
   wire             ETH_TXEN;
   wire [ 1: 0]     ETH_TXD;



//------------------------------------------------------------------------------
//模块调用参考 开始
//------------------------------------------------------------------------------


  //************************************************************
  //--  Control Station #1
  //************************************************************

  defparam u1_tb_STATION.STAT   =  8'b0000_0001;
  tb_STATION u1_tb_STATION(
    //-----------------------------------------------------------
    //-- C-LINK
    //-----------------------------------------------------------
 
    .Channel_1_TX_P    (STAT1_Channel_1_TX_P         ),
    .Channel_1_TX_N    (STAT1_Channel_1_TX_N         ),
    .Channel_1_RX_P    (STAT1_Channel_1_RX_P         ),
    .Channel_1_RX_N    (STAT1_Channel_1_RX_N         ),

                                       
    .Channel_2_TX_P    (STAT1_Channel_2_TX_P         ),
    .Channel_2_TX_N    (STAT1_Channel_2_TX_N         ),
    .Channel_2_RX_P    (STAT1_Channel_2_RX_P         ),
    .Channel_2_RX_N    (STAT1_Channel_2_RX_N         ),
                                       
    .Channel_3_TX_P    (STAT1_Channel_3_TX_P         ),
    .Channel_3_TX_N    (STAT1_Channel_3_TX_N         ),
    .Channel_3_RX_P    (STAT1_Channel_3_RX_P         ),
    .Channel_3_RX_N    (STAT1_Channel_3_RX_N         ),
                                       
    .Channel_4_TX_P    (STAT1_Channel_4_TX_P         ),
    .Channel_4_TX_N    (STAT1_Channel_4_TX_N         ),
    .Channel_4_RX_P    (STAT1_Channel_4_RX_P         ),
    .Channel_4_RX_N    (STAT1_Channel_4_RX_N         ),
                                       
    .Channel_5_TX_P    (STAT1_Channel_5_TX_P         ),
    .Channel_5_TX_N    (STAT1_Channel_5_TX_N         ),
    .Channel_5_RX_P    (STAT1_Channel_5_RX_P         ),
    .Channel_5_RX_N    (STAT1_Channel_5_RX_N         ),
                                       
    .Channel_6_TX_P    (STAT1_Channel_6_TX_P         ),
    .Channel_6_TX_N    (STAT1_Channel_6_TX_N         ),
    .Channel_6_RX_P    (STAT1_Channel_6_RX_P         ),
    .Channel_6_RX_N    (STAT1_Channel_6_RX_N         ),
 
 
 //   .DFPGA_CHANNEL_1_TXPART_TXD_EN    (STAT1_CH1_TXD_EN      ),
 //   .CHANNEL_1_TXPART_TXD             (STAT1_CH1_TXD         ),
 //   .CHANNEL_1_TXPART_RXD             (                      ),
 //   .CHANNEL_1_RXPART_RXD             (STAT1_CH1_RXD         ),
 //
 //   .DFPGA_CHANNEL_2_TXPART_TXD_EN    (STAT1_CH2_TXD_EN      ),
 //   .CHANNEL_2_TXPART_TXD             (STAT1_CH2_TXD         ),
 //   .CHANNEL_2_TXPART_RXD             (                      ),
 //   .CHANNEL_2_RXPART_RXD             (STAT1_CH2_RXD         ),
 //
 //   .DFPGA_CHANNEL_3_TXPART_TXD_EN    (STAT1_CH3_TXD_EN      ),
 //   .CHANNEL_3_TXPART_TXD             (STAT1_CH3_TXD         ),
 //   .CHANNEL_3_TXPART_RXD             (                      ),
 //   .CHANNEL_3_RXPART_RXD             (STAT1_CH3_RXD         ),
 //
 //   .DFPGA_CHANNEL_4_TXPART_TXD_EN    (STAT1_CH4_TXD_EN      ),
 //   .CHANNEL_4_TXPART_TXD             (STAT1_CH4_TXD         ),
 //   .CHANNEL_4_TXPART_RXD             (                      ),
 //   .CHANNEL_4_RXPART_RXD             (STAT1_CH4_RXD         ),
 //
 //   .DFPGA_CHANNEL_5_TXPART_TXD_EN    (STAT1_CH5_TXD_EN      ),
 //   .CHANNEL_5_TXPART_TXD             (STAT1_CH5_TXD         ),
 //   .CHANNEL_5_TXPART_RXD             (                      ),
 //   .CHANNEL_5_RXPART_RXD             (STAT1_CH5_RXD         ),
 //
 //   .DFPGA_CHANNEL_6_TXPART_TXD_EN    (STAT1_CH6_TXD_EN      ),
 //   .CHANNEL_6_TXPART_TXD             (STAT1_CH6_TXD         ),
 //   .CHANNEL_6_TXPART_RXD             (                      ),
 //   .CHANNEL_6_RXPART_RXD             (STAT1_CH6_RXD         ),

    //-----------------------------------------------------------
    //-- Ethernet: RMII interface-2
    //-----------------------------------------------------------
    .ETH2_RST_n          (STAT1_ETH_RST_n     ), 
    .ETH2_REFCLK         (STAT1_ETH_REFCLK    ), 
    .ETH2_RXD_O          (STAT1_ETH_RXD_O     ), 
    .ETH2_RXDV_O         (STAT1_ETH_RXDV_O    ), 
    .ETH2_RXER           (STAT1_ETH_RXER      ), 
    .ETH2_TXEN           (STAT1_ETH_TXEN      ), 
    .ETH2_TXD            (STAT1_ETH_TXD       ), 
    .ETH2_COM_LED        (STAT1_ETH_COM_LED   )  

);


  //************************************************************
  //--  Control Station #2
  //************************************************************

/*
  defparam u2_tb_STATION.STAT   =  8'b0000_0010;
  tb_STATION u2_tb_STATION(
    //-----------------------------------------------------------
    //-- C-LINK
    //-----------------------------------------------------------
    .DFPGA_CHANNEL_1_TXPART_TXD_EN    (STAT2_CH1_TXD_EN      ),
    .CHANNEL_1_TXPART_TXD             (STAT2_CH1_TXD         ),
    .CHANNEL_1_TXPART_RXD             (                      ),
    .CHANNEL_1_RXPART_RXD             (STAT2_CH1_RXD         ),

    .DFPGA_CHANNEL_2_TXPART_TXD_EN    (STAT2_CH2_TXD_EN      ),
    .CHANNEL_2_TXPART_TXD             (STAT2_CH2_TXD         ),
    .CHANNEL_2_TXPART_RXD             (                      ),
    .CHANNEL_2_RXPART_RXD             (STAT2_CH2_RXD         ),

    .DFPGA_CHANNEL_3_TXPART_TXD_EN    (STAT2_CH3_TXD_EN      ),
    .CHANNEL_3_TXPART_TXD             (STAT2_CH3_TXD         ),
    .CHANNEL_3_TXPART_RXD             (                      ),
    .CHANNEL_3_RXPART_RXD             (STAT2_CH3_RXD         ),

    .DFPGA_CHANNEL_4_TXPART_TXD_EN    (STAT2_CH4_TXD_EN      ),
    .CHANNEL_4_TXPART_TXD             (STAT2_CH4_TXD         ),
    .CHANNEL_4_TXPART_RXD             (                      ),
    .CHANNEL_4_RXPART_RXD             (STAT2_CH4_RXD         ),

    .DFPGA_CHANNEL_5_TXPART_TXD_EN    (STAT2_CH5_TXD_EN      ),
    .CHANNEL_5_TXPART_TXD             (STAT2_CH5_TXD         ),
    .CHANNEL_5_TXPART_RXD             (                      ),
    .CHANNEL_5_RXPART_RXD             (STAT2_CH5_RXD         ),

    .DFPGA_CHANNEL_6_TXPART_TXD_EN    (STAT2_CH6_TXD_EN      ),
    .CHANNEL_6_TXPART_TXD             (STAT2_CH6_TXD         ),
    .CHANNEL_6_TXPART_RXD             (                      ),
    .CHANNEL_6_RXPART_RXD             (STAT2_CH6_RXD         ),

    //-----------------------------------------------------------
    //-- Ethernet: RMII interface-2
    //-----------------------------------------------------------
    .ETH2_RST_n          (STAT2_ETH_RST_n     ),
    .ETH2_REFCLK         (STAT2_ETH_REFCLK    ),
    .ETH2_RXD_O          (STAT2_ETH_RXD_O     ),
    .ETH2_RXDV_O         (STAT2_ETH_RXDV_O    ),
    .ETH2_RXER           (STAT2_ETH_RXER      ),
    .ETH2_TXEN           (STAT2_ETH_TXEN      ),
    .ETH2_TXD            (STAT2_ETH_TXD       ),
    .ETH2_COM_LED        (STAT2_ETH_COM_LED   )

);

*/

   //************************************************************
  //--  Engineer station
  //************************************************************

   tb_engineer_station u1_tb_engineer_station(
    .o_tx_en            (ETH_TXEN     ),
    .om_tx_data         (ETH_TXD      ),
    .i_rxdv             (ETH_RXDV     ),
    .im_rxdata          (ETH_RXD      )
);

  
 
         
 
  
//------------------------------------------------------------------------------
//模块调用参考 结束
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//逻辑参考  开始
//------------------------------------------------------------------------------

  //-------------------------------------------------
  // C-LINK Connection
  //-------------------------------------------------

  //-- Station#1 <----> Station#2
//  assign  STAT2_CH1_RXD  =  STAT1_CH1_TXD;
//  assign  STAT1_CH1_RXD  =  STAT2_CH1_TXD;
  //assign  STAT2_CH2_RXD  =  STAT1_CH2_TXD;
  //assign  STAT1_CH2_RXD  =  STAT2_CH2_TXD;

  //-------------------------------------------------
  // Ehernet Connection                               
  //-------------------------------------------------
  
  
  
          
          
          
          
                  
          
 

//------------------------------------------------------------------------------
//逻辑参考  结束
//------------------------------------------------------------------------------




//**************************************************************
//  main control process
//**************************************************************

/*
  initial
    begin
    	file_re_id0    = $fopen("Step10_out.txt", "r");

      if(file_re_id0==0)
        begin
          $display(" Open file %s  error!!!", "Step10_out.txt");
        end
      else
        begin
          $display(" Open file %s  successful!!!", "Step10_out.txt");
        end

      code_1      <= 0;

      Proc_St         <= 0;
      NewFrm_Done     <= 0;

      Reg_Frm_Num        <= 10;
      Reg_ImageRect      <= 128;
      Reg_Charge2Volt_r  <= 1365;
      Reg_FrmNum_Incr_r  <= 372;

      Reg_NoisebyCurr    <= 0;

      Reg_PixelOneNum    <= 400 ;
      Reg_MinGray        <= 33 ;

      WindowScale       <=  4;


      S8_m_leftdown   <= 0 ;
      S8_m_leftup     <= 0  ;
      S8_m_rightdown  <= 0 ;
      S8_m_rightup    <= 1  ;

      Len_Ticket      <= 4;

      S10_pixel_x     <= 0;
      S10_pixel_y     <= 0;
      S10_pixel_amp   <= 0;
      S10_pixel_valid <= 0;
      S10_pixel_st    <= 0;

      # 400;


      Cond = 1;
      while( Cond == 1 )
      begin : write_data

        @( posedge clk_sys );

        code_1 = $fscanf(file_re_id0, "%b   %b   %h   %h   %h\n", file_data1, file_data2, file_data3, file_data4,file_data5);


        S10_pixel_st      <= file_data1;
        S10_pixel_valid   <= file_data2;
        S10_pixel_x       <= file_data3;
        S10_pixel_y       <= file_data4;
        S10_pixel_amp     <= file_data5;


        if ( code_1 == -1 )
        begin
          Cond = 0;
        end

      end  //-- end while


      //# 425
      @( posedge clk_sys );
      Proc_St     <= #1 1;
      @( posedge clk_sys );
      Proc_St     <= #1 0;


      // First frm done
      # 10500
      @( posedge clk_sys );
      NewFrm_Done     <= #1 1;
      @( posedge clk_sys );
      NewFrm_Done     <= #1 0;




    end       //-- initial end


*/


endmodule

