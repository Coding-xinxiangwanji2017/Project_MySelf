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


//`define SIMULATION


`timescale 1ns/100ps
module TIMING_NEW(

    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------
    input  wire              clk               ,  // 100MHz
    input  wire              rst_n             ,

    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------
    //
    input  wire              pps_pulse         ,
                                               
    input  wire              CMD_Cfg_Done      ,  //有效
    input  wire   [31: 0]    Reg_Second        ,  //秒信息
    input  wire   [31: 0]    Reg_MicroSecond   ,  //亚秒信息
    input  wire   [15: 0]    Reg_StarImageSend ,  //发送起始偏移
    input  wire   [15: 0]    Reg_SendFreq      ,  //发送频率
    input  wire   [15: 0]    Reg_SpotSend      ,   
    input  wire   [15: 0]    Reg_TdiLevel      ,  //TDI级数
    input  wire   [15: 0]    Reg_TdiTime       ,  //TDI时间
    

    input  wire              Frm_Tx_En         ,
    output wire   [31: 0]    cnt               ,
    output wire   [15: 0]    reg_Freq          ,
    output wire              send_en           ,
                                               
    input  wire              Transmit_Done     ,
    output reg               Timing_Stardiag   ,
    output reg               Timing_lightdiag  ,
    output reg               Timing_Telemetry
);

`ifdef SIMULATION
    parameter Ms_10Ns    =  500;
    parameter OneSecond  =  499999;
    parameter SECOND_1_6 =  83333;
    parameter SECOND_1_4 =  125000;    
    parameter SECOND_2_6 =  166666;
    parameter SECOND_3_6 =  250000;
    parameter SECOND_4_6 =  333333;
    parameter SECOND_3_4 =  385000;
    parameter SECOND_5_6 =  416666;
`else
    parameter Ms_10Ns    =  100000;
    parameter OneSecond  =  99999999;
    parameter SECOND_1_6 =  16666666;
    parameter SECOND_1_4 =  25000000;    
    parameter SECOND_2_6 =  33333333;
    parameter SECOND_3_6 =  50000000;
    parameter SECOND_4_6 =  66666666;
    parameter SECOND_3_4 =  75000000;
    parameter SECOND_5_6 =  83333333;
`endif


    //------------------------------------------------------------------------------
    //  Control signals
    //------------------------------------------------------------------------------

    reg [31: 0]  r_cnt_second;
    reg [31: 0]  r_cnt_startsend;
    reg [31: 0]  r_send_cnt;
    reg          r_send_en;
    reg          r_startsend_en;
    reg          r_lightdiag_en;
    
    reg [31: 0]  r_Reg_StarImageSend; 
    reg [15: 0]  r_Reg_SendFreq     ;
         
    assign cnt      = r_send_cnt;
    assign reg_Freq = r_Reg_SendFreq;
    assign send_en  = r_send_en; 
        
   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_Reg_SendFreq <= 0;
      else if ( CMD_Cfg_Done == 1'b1 )
          r_Reg_SendFreq <= Reg_SendFreq;
   end

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_Reg_StarImageSend <= 0;
      else if ( CMD_Cfg_Done == 1'b1 )
          r_Reg_StarImageSend <= Reg_StarImageSend*Ms_10Ns;
   end

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
          r_send_en <=  1'b0 ;
      else if ( !Frm_Tx_En)
          r_send_en  <= 1'b0;          
      else if ( r_cnt_startsend == r_Reg_StarImageSend)
          r_send_en  <= 1'b1;
   end

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_cnt_startsend <= 0;         
      else if ( r_startsend_en && r_cnt_startsend == r_Reg_StarImageSend )
          r_cnt_startsend  <= r_cnt_startsend;
      else if ( r_startsend_en )
      	  r_cnt_startsend  <= r_cnt_startsend + 1;
   end

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_startsend_en <= 0;         
      else if ( Frm_Tx_En && pps_pulse )
          r_startsend_en  <= 1;
   end

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_send_cnt <= 0;
      else if ( r_send_en && r_send_cnt != OneSecond)
          r_send_cnt  <= r_send_cnt + 1;          
      else if ( r_send_en )
          r_send_cnt  <= 0;
   end
   
   //Timing_Stardiag   
   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          Timing_Stardiag <= 0;
      else if ( r_Reg_SendFreq == 1 && r_send_cnt == 1 )
          Timing_Stardiag  <= 1; 
      else if ( r_Reg_SendFreq == 2 && (r_send_cnt == 1 || r_send_cnt == SECOND_3_6 ))
          Timing_Stardiag  <= 1;          
      else if ( r_Reg_SendFreq == 3 && (r_send_cnt == 1 || r_send_cnt == SECOND_2_6 || r_send_cnt == SECOND_4_6 ))
          Timing_Stardiag  <= 1; 
      else 
          Timing_Stardiag  <= 0;
   end
   
   //Timing_Telemetry   
   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          Timing_Telemetry <= 0;
      else if ( r_Reg_SendFreq == 1 && r_send_cnt == SECOND_3_6 )
          Timing_Telemetry  <= 1; 
      else if ( r_Reg_SendFreq == 2 && (r_send_cnt == SECOND_1_4 || r_send_cnt == SECOND_3_4 ))
          Timing_Telemetry  <= 1;          
      else if ( r_Reg_SendFreq == 3 && (r_send_cnt == SECOND_1_6 || r_send_cnt == SECOND_3_6 || r_send_cnt == SECOND_5_6 ))
          Timing_Telemetry  <= 1; 
      else 
          Timing_Telemetry  <= 0;
   end
 
   //r_lightdiag_en
   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_lightdiag_en <= 0;
      else if ( Timing_Telemetry == 1 )
          r_lightdiag_en <= 1; 
      else if ( Transmit_Done )
      	  r_lightdiag_en <= 0; 
   end 
   
   //r_lightdiag_en
   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          Timing_lightdiag <= 0;
      else if ( r_lightdiag_en && Transmit_Done)
          Timing_lightdiag <= 1; 
      else
      	  Timing_lightdiag <= 0; 
   end
           
endmodule