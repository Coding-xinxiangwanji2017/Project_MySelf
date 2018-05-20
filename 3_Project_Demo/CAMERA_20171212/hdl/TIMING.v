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


`define SIMULATION


`timescale 1ns/100ps

module TIMING(

    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------
    input  wire         clk          ,  // 100MHz
    input  wire         rst_n        ,

    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------
    //
    input  wire              pps_pulse,

    input  wire              CMD_Cfg_Done,
    input  wire   [31: 0]    Reg_Second ,
    input  wire   [31: 0]    Reg_MicroSecond ,
    input  wire   [15: 0]    Reg_StarImageSend ,
    input  wire   [15: 0]    Reg_SendFreq  ,
    input  wire   [15: 0]    Reg_SpotSend ,
    input  wire   [15: 0]    Reg_TdiLevel ,
    input  wire   [15: 0]    Reg_TdiTime  ,    
    

    input  wire              Frm_Tx_En,

    output reg               Timing_Stardiag,
    output reg               Timing_lightdiag,
    output reg               Timing_Telemetry
);


    //------------------------------------------------------------------------------
    //  Control signals
    //------------------------------------------------------------------------------

    reg      r_wait_cfg;
    reg      r_cfg_ack;
    reg      r_shutdown_ack;

    reg [31: 0]  r_cnt_second;
    reg [23: 0]  r_cnt_microsecond;
    reg          r_microsecond_pulse;

    reg [31: 0]  r_cnt_nanosecond;

    reg          r_done_extend;

    reg           r_starimage_cnt_st;
    reg [15: 0]   r_starimage_cnt;
    reg           r_starimage_cnt_en;


   //-----------------------------------------------------------
   //-- general control signal
   //-----------------------------------------------------------


   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_cnt_second <=  1'b0 ;
      else
          if ( CMD_Cfg_Done == 1'b1 )
              r_cnt_second  <= Reg_Second;
          else if ( pps_pulse == 1'b1 )
              r_cnt_second  <= r_cnt_second + 1;
   end

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_cnt_nanosecond <=  1'b0 ;
      else
          if ( pps_pulse == 1'b1 )
               r_cnt_nanosecond  <= 0;
          else if (r_cnt_nanosecond == 9999 )
               r_cnt_nanosecond  <= 0;
          else
               r_cnt_nanosecond  <= r_cnt_nanosecond + 1;
   end

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_microsecond_pulse <=  1'b0 ;
      else
          if (r_cnt_nanosecond == 9999 )
              r_microsecond_pulse  <= 1;
          else
              r_microsecond_pulse  <= 0 ;
   end

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_cnt_microsecond <=  1'b0 ;
      else
          if ( CMD_Cfg_Done == 1'b1 )
              r_cnt_microsecond  <= Reg_MicroSecond;

          else if ( pps_pulse == 1'b1 )
              r_cnt_microsecond <=  0 ;
          else if  ( r_microsecond_pulse == 1  )
              r_cnt_microsecond  <= r_cnt_microsecond + 1;

   end


   //-----------------------------------------------------------
   //-- general control signal
   //-----------------------------------------------------------

/*
   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_done_extend <=  1'b0 ;
      else
          if ( CMD_Cfg_Done == 1'b1 )
              r_done_extend  <= 1'b1;
          else if ( pps_pulse == 1'b1 )
              r_done_extend <=  0 ;
      end
   end
*/

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_starimage_cnt_st <=  1'b0 ;
      else
          //if ( r_done_extend == 1'b1 && pps_pulse == 1'b1  )
          if (  pps_pulse == 1'b1  )
              r_starimage_cnt_st  <= 1'b1;
          else if ( pps_pulse == 1'b1 )
              r_starimage_cnt_st <=  0 ;
   end


   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_starimage_cnt <=  0 ;
      else
          if ( r_starimage_cnt_st == 1'b1  )
              r_starimage_cnt  <= 1'b0;
          else if ( r_microsecond_pulse == 1'b1 )
              r_starimage_cnt <=  r_starimage_cnt + 1 ;
   end

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          Timing_Telemetry <=  0 ;
      else
          if ( (r_cnt_microsecond[15:0] == Reg_StarImageSend) && (r_microsecond_pulse == 1'b1) && ( Frm_Tx_En==1'b1 )  )
              Timing_Telemetry  <= 1'b1;
          else if ( r_cnt_microsecond[15:0] == Reg_StarImageSend +1 )
              Timing_Telemetry <=  0 ;
   end


   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          Timing_Stardiag <=  0 ;
      else
          if ( (r_cnt_microsecond[15:0] == Reg_StarImageSend +1) && (r_microsecond_pulse == 1'b1) && ( Frm_Tx_En==1'b1 )  )
              Timing_Stardiag  <= 1'b1;
          else if ( r_cnt_microsecond[15:0] == Reg_StarImageSend +2 )
              Timing_Stardiag <=  0 ;
   end







   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          Timing_lightdiag <=  0 ;
      else
          if ( (r_cnt_microsecond[15:0] == Reg_SpotSend) && (r_microsecond_pulse == 1'b1) && ( Frm_Tx_En==1'b1 )  )
              Timing_lightdiag  <= 1'b1;
          else if ( r_cnt_microsecond[15:0] == Reg_SpotSend +1 )
              Timing_lightdiag <=  0 ;
   end





endmodule