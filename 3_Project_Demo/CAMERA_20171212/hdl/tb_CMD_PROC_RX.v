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

module tb_CMD_PROC_RX(

    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------
    input  wire         clk       ,
    input  wire         rst_n        ,

    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------
    input wire [15:0]   RX_DATA          ,
    input wire [1:0]    RXCTRL           ,    // data: 00, ox02bc: 01

    output reg          CMD,
    output reg [1:0]    CMD_Type
);
    //------------------------------------------------------------------------------
    //  Regisgter Array
    //------------------------------------------------------------------------------
    reg  [15: 0]    Reg_OpCode_1;
    reg  [15: 0]    RespData_1 ;


    //------------------------------------------------------------------------------
    //  Control signals
    //------------------------------------------------------------------------------

    reg  [ 5: 0]    r_rx_count;
    reg             r_frm_start;
    reg             r_data_valid;
    reg             r_frm_end,r_frm_end_d1,r_frm_end_d2,r_frm_end_d3;

    reg  [ 1: 0]    r_RXCTRL_d1,r_RXCTRL_d2;
    reg  [15: 0]    r_RX_DATA_d1, r_RX_DATA_d2, r_RX_DATA_d3 ;
    reg  [16: 0]    r_check_sum;
    reg             r_cmd_cfg;

    reg             r_check_en;

   //-----------------------------------------------------------
   //-- general control signal
   //-----------------------------------------------------------
   //-- tx process flag
   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
          r_RX_DATA_d1 <=   16'b0;
          r_RX_DATA_d2 <=   16'b0;
          r_RX_DATA_d3 <=   16'b0;
          r_frm_end_d1 <=   1'b0;
          r_frm_end_d2 <=   1'b0;
          r_frm_end_d3 <=   1'b0;

          r_RXCTRL_d1  <=    2'b00;
          r_RXCTRL_d2  <=    2'b00;

      end
      else
      begin
          r_RX_DATA_d1 <=   RX_DATA;
          r_RX_DATA_d2 <=   r_RX_DATA_d1;
          r_RX_DATA_d3 <=   r_RX_DATA_d2;

          r_frm_end_d1 <=   r_frm_end;
          r_frm_end_d2 <=   r_frm_end_d1;
          r_frm_end_d3 <=   r_frm_end_d2;

          r_RXCTRL_d1  <=   RXCTRL;
          r_RXCTRL_d2  <=   r_RXCTRL_d1;

      end
   end

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_frm_start <=  1'b0 ;
      else
          if ( (r_RXCTRL_d1 == 2'b00) && (r_RXCTRL_d2 == 2'b01) && (RX_DATA == 16'h1984) && (r_RX_DATA_d1 == 16'h2410) )
              r_frm_start  <= 1'b1;
          else
              r_frm_start  <= 1'b0;
   end

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_frm_end <=  1'b0 ;
      else
          if ( ( r_RXCTRL_d1  == 2'b01) && (r_RXCTRL_d2 == 2'b00) && (r_RX_DATA_d2 == 16'hE67B) && (r_RX_DATA_d3 == 16'hDBEF) )
              r_frm_end  <= 1'b1;
          else
              r_frm_end  <= 1'b0;
   end

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_data_valid <=  1'b0 ;
      else
          if (r_frm_start == 1'b1 )
              r_data_valid  <= 1'b1;
          else if (r_frm_end == 1'b1 )
              r_data_valid  <= 1'b0;
   end

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_rx_count <=  6'b0 ;
      else
          if (r_frm_start == 1'b1 )
              r_rx_count  <= 6'b0;
          else if (r_data_valid == 1'b1 )
              r_rx_count  <= r_rx_count + 1;
   end

   //-----------------------------------------------------------
   //-- Latch parameter
   //-----------------------------------------------------------
   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
          Reg_OpCode_1        <= 16'b0 ;
          RespData_1          <= 16'b0 ;

      end
      else
      begin
          if (r_data_valid == 1'b1 && r_rx_count == 3  )
              Reg_OpCode_1  <=  r_RX_DATA_d3;

          if (r_data_valid == 1'b1 && r_rx_count == 5  )
              RespData_1    <=  r_RX_DATA_d3;

      end
   end

   //-----------------------------------------------------------
   //--  
   //-----------------------------------------------------------
   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          CMD <= 1'b0;
      else
          if ( r_frm_end_d3 == 1'b1 && Reg_OpCode_1 == 16'h0000  )
                CMD <= 1'b1;
          else
                CMD <= 1'b0;
   end

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          CMD_Type <= 2'b0;
      else
          if ( r_frm_end_d3 == 1'b1 && Reg_OpCode_1 == 16'h0000  )
               
               if (  RespData_1 == 16'h0000  )
                   CMD_Type <= 2'b00;
               else if (  RespData_1 == 16'h0001  )
                   CMD_Type <= 2'b01;
               else if (  RespData_1 == 16'hAAAA  )
                   CMD_Type <= 2'b10;
          else
                CMD_Type <= 2'b11;
   end








endmodule