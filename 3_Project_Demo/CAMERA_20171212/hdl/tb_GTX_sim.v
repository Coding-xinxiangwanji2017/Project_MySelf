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

module tb_GTX_sim(
    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------
    input  wire         clk          ,
    input  wire         rst_n             ,

    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------
    output  reg  [15:0]  TX_DATA          ,
    output  reg  [1:0]   TXCTRL           ,    // data: 00, ox02bc: 01

    input wire [15:0]     RX_DATA          ,
    input wire [1:0]      RXCTRL                // data: 00, ox02bc: 01

);

    //------------------------------------------------------------------------------
    //  Control signals
    //------------------------------------------------------------------------------
    wire             w_rx_CMD;
    wire     [1:0]   w_rx_CMD_Type;


   parameter FSM_IDLE         = "IDLE      ";
   parameter FSM_CFG          = "CFG  ";
   parameter FSM_CFG_ACK      = "CFG_ACK   ";
   parameter FSM_RX_DATA      = "RX_DATA ";
   parameter FSM_SHUT_DOWN    = "SHUT_DOWN ";

   parameter state_wid_msb = 80-1;



   reg    [ state_wid_msb: 0]      fsm_curr  ;
   reg    [ state_wid_msb: 0]      fsm_next  ;
   
   reg    r_cfg;


   //-----------------------------------------------------------
   //-- general control signal
   //-----------------------------------------------------------
 

//**************************************************************
//  Task :
//      downlink configuration frame
//**************************************************************

task TASK_DL_CFG;
  input  [15: 0]     Seq_Num;
  input  [31: 0]     Second;
  input  [31: 0]     Micro_second;
  input  [15: 0]     Star_time;
  input  [15: 0]     Frequency;
  input  [15: 0]     Spot_time;

  integer   k;

  reg    [31: 0]     SCUM;
  reg    [15: 0]     FRAME_CFG[0:32-1];


  begin

       //------------------------------
       //--- Frame Header
       //------------------------------
       FRAME_CFG[   0]  = 16'h2410 ;
       FRAME_CFG[   1]  = 16'h1984 ;
       FRAME_CFG[   2]  = Seq_Num ;
       FRAME_CFG[   3]  = 16'h0001 ;   // Configuration frame
       FRAME_CFG[   4]  = 16'h0018 ;   // length = 24
       FRAME_CFG[   5]  = 16'h0021 ;
       FRAME_CFG[   6]  = Second[31:16] ;
       FRAME_CFG[   7]  = Second[15: 0] ;
       FRAME_CFG[   8]  = Micro_second[31:16] ;
       FRAME_CFG[   9]  = Micro_second[15: 0] ;
       FRAME_CFG[  10]  = Star_time ;
       FRAME_CFG[  11]  = Frequency ;
       FRAME_CFG[  12]  = 16'h0000  ;
       FRAME_CFG[  13]  = 16'h0000 ;
       FRAME_CFG[  14]  = Spot_time;
       FRAME_CFG[  15]  = 16'h0000 ;
       FRAME_CFG[  16]  = 16'h0000 ;
       FRAME_CFG[  17]  = 16'h0000 ;
       FRAME_CFG[  18]  = 16'h0000 ;
       FRAME_CFG[  19]  = 16'h0000 ;
       FRAME_CFG[  20]  = 16'h0000 ;
       FRAME_CFG[  21]  = 16'h0000 ;
       FRAME_CFG[  22]  = 16'h0000 ;
       FRAME_CFG[  23]  = 16'h0000 ;
       FRAME_CFG[  24]  = 16'h0000 ;
       FRAME_CFG[  25]  = 16'h0000 ;
       FRAME_CFG[  26]  = 16'h0000 ;
       FRAME_CFG[  27]  = 16'h0000 ;
       FRAME_CFG[  28]  = 16'h0000 ;
       FRAME_CFG[  29]  = 16'h0000 ;
       FRAME_CFG[  30]  = 16'hDBEF ;
       FRAME_CFG[  31]  = 16'hE67B ;


       SCUM = 0;

       for(k=2;k<29;k=k+1)
       begin
          SCUM  = FRAME_CFG[k] + SCUM;
       end

       FRAME_CFG[  29]  = SCUM;



       //-----------------------------
       //-- Send opertion
       //-----------------------------
       TX_DATA    = 16'h02bc;
       TXCTRL     =  2'b01;

       @( posedge clk );
       @( posedge clk );

       for(k=0;k<32;k=k+1)
       begin
            TX_DATA    = FRAME_CFG[  k];
            TXCTRL     = 2'b00;

            @( posedge clk );

       end

       TX_DATA    = 16'h02bc;
       TXCTRL     =  2'b01;

       @( posedge clk );
       @( posedge clk );
       @( posedge clk );
       @( posedge clk );


  end

endtask


tb_CMD_PROC_RX u1_tb_CMD_PROC_RX(

    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------
    .clk       (clk  )   ,
    .rst_n     (rst_n)   ,

    //-----------------------------------------------------------
    //-- GTX interface
    //-----------------------------------------------------------
    .RX_DATA          (RX_DATA),
    .RXCTRL           (RXCTRL ),    // data: 00, ox02bc: 01

    .CMD              (w_rx_CMD     ),
    .CMD_Type         (w_rx_CMD_Type)
);


   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
        fsm_curr <= FSM_IDLE;
      else
        fsm_curr <= fsm_next;
   end

   always @ ( * )
   begin
       
       r_cfg = 1'b0;
       
       case(fsm_curr)
           FSM_IDLE:
               begin
                   if (w_rx_CMD == 1'b1 && w_rx_CMD_Type ==2'b01)
                       fsm_next = FSM_CFG;

               end

           FSM_CFG:
               begin
                   r_cfg = 1'b1;

                   fsm_next = FSM_CFG_ACK;
                       
                end

           FSM_CFG_ACK:
               begin                   
                   if (w_rx_CMD == 1'b1 && w_rx_CMD_Type ==2'b01)
                       fsm_next = FSM_RX_DATA;                      
                   else if (w_rx_CMD == 1'b1 && w_rx_CMD_Type ==2'b00)
                       fsm_next = FSM_CFG;
                   else
                       fsm_next = FSM_CFG_ACK;            
               end
               
           FSM_RX_DATA:
               begin
        

                end

           FSM_SHUT_DOWN:
               begin


                end

           default:
               fsm_next = FSM_IDLE;
       endcase
   end








    integer end_cond;


initial
  begin

       @( posedge clk );
       @( posedge clk );
       TX_DATA    = 16'h02bc;
       TXCTRL     =  2'b01;

       @( posedge clk );
       @( posedge clk );



    end_cond = 1;

    
    while( end_cond == 1 ) 
      begin

        @( posedge clk );    
        
        if ( r_cfg == 1'b1 )
          begin       
            end_cond = 0;
          end        
      end

     //-- task send star image
     TASK_DL_CFG(16'h0,  32'h10,  32'h12, 16'h10, 16'h1, 16'h18 );
/*
  input  [15: 0]     Seq_Num;
  input  [31: 0]     Second;
  input  [31: 0]     Micro_second;
  input  [15: 0]     Star_time;
  input  [15: 0]     Frequency;
  input  [15: 0]     Spot_time;
*/










  end  // initial


























endmodule