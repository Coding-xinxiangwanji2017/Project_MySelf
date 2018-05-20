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

module CMD_PROC_TX(

    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------
    input  wire         clk          ,
    input  wire         rst_n        ,

    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------
    
    output  reg  [15:0]     TX_DATA         ,
    output  reg  [1:0]      TXCTRL          ,    // data: 00, ox02bc: 01

    input   wire             CMD_TX         ,
    input   wire  [1:0]      CMD_Type       ,
    output  reg              CMD_Done       
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

    reg         r_CMD_TX_d1;
    wire        tx_start;

    reg [3:0]   tx_state;
    reg         r_frm_start;
    reg [1:0]   r_tx_type;



   //-----------------------------------------------------------
   //-- general control signal
   //-----------------------------------------------------------
   assign tx_start = CMD_TX | r_CMD_TX_d1;

   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_CMD_TX_d1 <=  1'b0 ;
      else
          r_CMD_TX_d1 <= CMD_TX;
   end
   
   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_tx_type <=  2'b0 ;
      else
          if (CMD_TX == 1'b1)
              r_tx_type <= CMD_Type;
   end

/*
   always @(posedge GT_USRCLK or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
          r_frm_start <=  1'b0 ;
      else
          if (RXCTRL == 2'b00 && r_RXCTRL_d1 == 2'b01 && RX_DATA = 16'h24101984)
              r_frm_start  <= 1'b1;
          else
              r_frm_start  <= 1'b0;
   end
*/


   always @(posedge clk or negedge rst_n)
   begin
       if ( rst_n == 1'b0 )
         begin
            TX_DATA  <= 16'h02bc;
            TXCTRL   <= 2'b01;

            tx_state <= 4'b0;
         end
       else
       begin
        
         CMD_Done <= 1'b0;
        
         case(tx_state)
           0  :     // idle
               begin
                   TX_DATA  <= 16'h02bc;
                   TXCTRL   <= 2'b01;

                   if(tx_start)
                      tx_state <= 1;

               end
           1  :    // SOP
               begin
                   TX_DATA  <= 16'h2410;
                   TXCTRL   <= 2'b00;

                   tx_state <= 2;

               end

           2  :   //SOP
               begin
                   TX_DATA  <= 16'h1984;
                   TXCTRL   <= 2'b00;

                   tx_state <= 3;

               end

           3  :   // seq num
               begin
                   TX_DATA  <= 16'h0000;
                   TXCTRL   <= 2'b00;

                   tx_state <= 4;

               end
           4  :   // operation code
               begin
                   TX_DATA  <= 16'h0000;
                   TXCTRL   <= 2'b00;

                   tx_state <= 5;

               end
           5  :   //  data length      
               begin
                   TX_DATA  <= 16'h0001;
                   TXCTRL   <= 2'b00;

                   tx_state <= 6;
               end
           6  :   // resp data
               begin
                   if ( r_tx_type == 2'b00 )
                      TX_DATA  <= 16'h0000;
                   else if ( r_tx_type == 2'b01 )
                      TX_DATA  <= 16'h0001;
                   else if ( r_tx_type == 2'b10)
                      TX_DATA  <= 16'hAAAA;

                   TXCTRL   <= 2'b00;

                   tx_state <= 7;
               end
           7  :    // check sum
               begin
                   TX_DATA  <= 16'h0000;
                   TXCTRL   <= 2'b00;

                   tx_state <= 8;
               end
           8  :    //  EOP
               begin
                   TX_DATA  <= 16'hDBEF;
                   TXCTRL   <= 2'b00;

                   tx_state <= 9;
               end
           9  :    //  EOP
               begin
                   TX_DATA  <= 16'hE67B;
                   TXCTRL   <= 2'b00;

                   tx_state <= 0;
                   
                   CMD_Done <= 1'b1;
                   
               end
           default  :
               begin
                   TX_DATA  <= 16'h02bc;
                   TXCTRL   <= 2'b01;

                   tx_state <= 1;
               end
         endcase
      end
    end      // always



endmodule