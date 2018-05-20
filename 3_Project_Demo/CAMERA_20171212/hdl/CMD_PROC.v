//////////////////////////////////////////////////////////////////////////////////
// Company: Bixing-tech
// Engineer: Zhang xueyan
//
// Create Date:    2016/7/12
// Design Name:
// Module Name:
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

module CMD_PROC(

    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------
    input  wire         CLK_100M          ,
    input  wire         rst_n        ,

    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------
    input  wire             GT_USRCLK    ,

    output  wire  [15:0]    TX_DATA          ,
    output  wire  [1:0]     TXCTRL           ,    // data: 00, ox02bc: 01

    input wire [15:0]       RX_DATA          ,
    input wire [1:0]        RXCTRL           ,    // data: 00, ox02bc: 01

    output reg [31: 0]    Reg_Second_p ,
    output reg [31: 0]    Reg_MicroSecond_p,
    output reg [15: 0]    Reg_StarImageSend_p ,
    output reg [15: 0]    Reg_SendFreq_p  ,
    output reg [15: 0]    Reg_SpotSend_p ,

    output reg    CMD_Cfg_Done,
    output reg    CMD_ShutDown
);
    //------------------------------------------------------------------------------
    //  Regisgter Array
    //------------------------------------------------------------------------------
    reg  [15: 0]    Reg_OpCode_1;
    reg  [31: 0]    Reg_Second_1 ;
    reg  [31: 0]    Reg_MicroSecond_1;
    reg  [15: 0]    Reg_StarImageSend_1 ;
    reg  [15: 0]    Reg_SendFreq_1  ;
    reg  [15: 0]    Reg_SpotSend_1 ;
    reg  [15: 0]    Reg_ChechSum_1 ;

    //------------------------------------------------------------------------------
    //  Control signals
    //------------------------------------------------------------------------------
    reg  [ 5: 0]    r_rx_count;
    reg             r_frm_start, r_frm_end, r_data_valid;
    reg             r_frm_end,r_frm_end_d1,r_frm_end_d2,r_frm_end_d3;

    reg  [15: 0]    r_RX_DATA_d1, r_RX_DATA_d2, r_RX_DATA_d3 ;
    reg  [31: 0]    r_check_sum;
    reg             r_cmd_cfg;
   //-----------------------------------------------------------
   //-- general control signal
   //-----------------------------------------------------------
   //-- tx process flag
   always @(posedge GT_USRCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
          r_RX_DATA_d1 <=   16'b0;
          r_RX_DATA_d2 <=   16'b0;
          r_RX_DATA_d3 <=   16'b0;
          r_frm_end_d1 <=   1'b0;
          r_frm_end_d2 <=   1'b0;
          r_frm_end_d3 <=   1'b0;
      end
      else
      begin
          r_RX_DATA_d1 <=   RX_DATA;
          r_RX_DATA_d2 <=   r_RX_DATA_d1;
          r_RX_DATA_d3 <=   r_RX_DATA_d2;

          r_frm_end_d1 <=   r_frm_end;
          r_frm_end_d2 <=   r_frm_end_d1;
          r_frm_end_d3 <=   r_frm_end_d2;
      end
   end

   always @(posedge GT_USRCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_frm_start <=  1'b0 ;
      else
          if (RXCTRL == 2'b00 && r_RXCTRL_d1 == 2'b01 && RX_DATA == 16'h24101984)
              r_frm_start  <= 1'b1;
          else
              r_frm_start  <= 1'b0;
//      end
   end

   always @(posedge GT_USRCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_frm_end <=  1'b0 ;
      else
          if (RXCTRL == 2'b10 && r_RXCTRL_d1 == 2'b00 && RX_DATA == 16'h24101984)
              r_frm_end  <= 1'b1;
          else
              r_frm_end  <= 1'b0;
//     end
   end

   always @(posedge GT_USRCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_data_valid <=  1'b0 ;
      else
          if (r_frm_start == 1'b1 )
              r_data_valid  <= 1'b1;
          else if (r_frm_end == 1'b1 )
              r_data_valid  <= 1'b0;
//      end
   end

   always @(posedge GT_USRCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_rx_count <=  6'b0 ;
      else
          if (r_frm_start == 1'b1 )
              r_rx_count  <= 6'b0;
          else if (r_data_valid == 1'b1 )
              r_rx_count  <= r_rx_count + 1;
//      end
   end

   //-----------------------------------------------------------
   //-- Latch parameter
   //-----------------------------------------------------------
   always @(posedge GT_USRCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
          Reg_Second_1        <= 16'b0 ;
          Reg_MicroSecond_1   <= 16'b0   ;
          Reg_StarImageSend_1 <= 16'b0  ;
          Reg_SendFreq_1      <= 16'b0   ;
          Reg_SpotSend_1      <= 16'b0 ;
      end
      else
          if (r_data_valid == 1'b1 && r_rx_count == 3  )
              Reg_OpCode_1  <=  r_RX_DATA_d2;

          if (r_data_valid == 1'b1 && r_rx_count == 5+1  )
              Reg_OpCode_1  <=  { r_RX_DATA_d2, r_RX_DATA_d1 };

          if (r_data_valid == 1'b1 && r_rx_count == 5+3  )
              Reg_MicroSecond_1  <=  { r_RX_DATA_d2, r_RX_DATA_d1 };

          if (r_data_valid == 1'b1 && r_rx_count == 5+5  )
              Reg_StarImageSend_1  <=  r_RX_DATA_d2;

          if (r_data_valid == 1'b1 && r_rx_count == 5+6  )
              Reg_SendFreq_1  <=  r_RX_DATA_d2;

          if (r_data_valid == 1'b1 && r_rx_count == 5+9  )
              Reg_SpotSend_1  <=  r_RX_DATA_d2;

          if (r_data_valid == 1'b1 && r_rx_count == 6'h1d  )
              Reg_ChechSum_1  <=  r_RX_DATA_d2;
//      end
   end

   //-----------------------------------------------------------
   //-- Check sum
   //-----------------------------------------------------------
   always @(posedge GT_USRCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_check_en <=  1'b0 ;
      else
          if (r_data_valid == 1'b1 && r_rx_count == 2  )
              r_check_en  <= 1'b1;
          else if (r_data_valid == 1'b1 && r_rx_count == 6'h1d  )
              r_check_en  <= 1'b0;
//      end
   end

   always @(posedge GT_USRCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_check_sum <=  6'b0 ;
      else
          if (r_frm_start == 1'b1 )
              r_check_sum  <= 6'b0;
          else if (r_check_en == 1'b1 )
              r_check_sum  <= { 16'h00,  r_RX_DATA_d3 } + r_check_sum;
  //    end
   end
   //-----------------------------------------------------------
   //--
   //-----------------------------------------------------------
   always @(posedge GT_USRCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
          Reg_Second_p        <= 32'b0 ;
          Reg_MicroSecond_p   <= 32'b0   ;
          Reg_StarImageSend_p <= 16'b0  ;
          Reg_SendFreq_p      <= 16'b0   ;
          Reg_SpotSend_p      <= 16'b0 ;
      end
      else
          if ( r_frm_end_d3 == 1'b1 &&  r_check_sum == Reg_ChechSum_1 && ( Reg_OpCode_1 == 16'h0001 || Reg_OpCode_1 == 16'hA5A5  )   )
          begin
              Reg_Second_p        <=   Reg_Second_1 ;
              Reg_MicroSecond_p   <=   Reg_MicroSecond_1  ;
          end
          if ( r_frm_end_d3 == 1'b1 &&  r_check_sum == Reg_ChechSum_1 && Reg_OpCode_1 == 16'h0001  )
          begin
              Reg_StarImageSend_p <=   Reg_StarImageSend_1 ;
              Reg_SendFreq_p      <=   Reg_SendFreq_1  ;
              Reg_SpotSend_p      <=   Reg_SpotSend_1  ;
          end
    //  end
   end

   always @(posedge GT_USRCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          CMD_Cfg_Done <= 1'b0;
      else
          if ( r_frm_end_d3 == 1'b1 &&  r_check_sum == Reg_ChechSum_1 && Reg_OpCode_1 == 16'h0001  )
                CMD_Cfg_Done <= 1'b1;
          else
                CMD_Cfg_Done <= 1'b0;
      //end
   end

   always @(posedge GT_USRCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          CMD_ShutDown <= 1'b0;
      else
          if ( r_frm_end_d3 == 1'b1 &&  r_check_sum == Reg_ChechSum_1 && Reg_OpCode_1 == 16'hA5A5 )
                CMD_ShutDown <= 1'b1;
          else
                CMD_ShutDown <= 1'b0;
 //     end
   end


endmodule