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

module MAIN_CTRL(

    //-----------------------------------------------------------
    //-- reset, clocks
    //-----------------------------------------------------------
    input  wire         clk          ,
    input  wire         rst_n        ,

    //-----------------------------------------------------------
    //-- Data download interface
    //-----------------------------------------------------------
    input  wire             TOE_Busy,   
    
    output  reg            Data_Move_En,    
    input  wire             Data_Move_Busy,
    input   wire            Data_Move_Done,
    

    //-- GTX interface
    input   wire            CMD_Cfg_Done,
    input   wire            CMD_ShutDown,

    //-- Command Rx/Tx Interface
    output  reg             CMD_TX,
    output  reg  [1:0]      CMD_Type,
    input                   CMD_Done,
	 output       [5:0]      fsm_curr,
    
    //-- Data send
    output  reg             Frm_Tx_En,
    output  wire            ack


);
    //------------------------------------------------------------------------------
    //  Regisgter Array
    //------------------------------------------------------------------------------

//`ifdef SIMULATION
//   parameter FSM_WAIT_MOVE    = "WAIT_MOVE ";
//   parameter FSM_TOE          = "TOE       ";   
//   parameter FSM_WAIT_CFG     = "WAIT_CFG  ";
//   parameter FSM_CFG_ACK      = "CFG_ACK   ";
//   parameter FSM_SEND_DATA    = "SEND_DATA ";
//   parameter FSM_SHUT_DOWN    = "SHUT_DOWN ";
//
//   parameter state_wid_msb = 80-1;
//
//`else
   parameter FSM_WAIT_MOVE    = 6'b000001   ;
   parameter FSM_TOE          = 6'b000010   ;
   parameter FSM_WAIT_CFG     = 6'b000100   ;
   parameter FSM_CFG_ACK      = 6'b001000   ;
   parameter FSM_SEND_DATA    = 6'b010000   ;  
   parameter FSM_SHUT_DOWN    = 6'b100000   ;
   
   parameter state_wid_msb = 6-1;

//`endif


   reg    [ state_wid_msb: 0]      fsm_curr  ;
//   reg    [ state_wid_msb: 0]      fsm_next  ;

   //------------------------------------------------------------------------------
   //  Control signals
   //------------------------------------------------------------------------------
   reg      r_init_ack;
   reg      r_cfg_ack;
   reg      r_shutdown_ack;

   reg [6:0]  r_cmd_cycle;
   
   reg      r_Data_Move_Busy_d1;
   wire     w_move_done;
   //-----------------------------------------------------------
   //-- general control signal
   //-----------------------------------------------------------
   assign   w_move_done     = Data_Move_Done;
   assign   ack = r_cfg_ack;
   
   //assign   Data_Move_En    = ~ TOE_Busy  ;
   
   
   
   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
          r_Data_Move_Busy_d1 <=   1'b0;

      end
      else
      begin
          r_Data_Move_Busy_d1 <=   Data_Move_Busy;

      end
   end
   
   
   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
		    begin
            fsm_curr <= FSM_WAIT_MOVE;
			      r_init_ack <= 1'b0;
            r_cfg_ack  <= 1'b0;    
            Frm_Tx_En  <= 1'b0;
            Data_Move_En <= 1'b1;
            r_shutdown_ack <= 1'b0;
			  end
      else
        case(fsm_curr)
          FSM_WAIT_MOVE:
            begin
              Data_Move_En <= 1'b1;
              if  (TOE_Busy == 1'b1) 
                  fsm_curr <= FSM_TOE; 
              else if (w_move_done == 1'b1)
                  fsm_curr <= FSM_WAIT_CFG;
              else 
                  fsm_curr <= FSM_WAIT_MOVE;
            end
            
          FSM_TOE:
               begin
                   Data_Move_En <= 1'b0;                
                   
                   if (TOE_Busy == 1'b0)
                       fsm_curr <= FSM_WAIT_MOVE;
               end      
          FSM_WAIT_CFG:                             
               begin                                 
                   r_init_ack <= 1'b1;                
                                                     
                   if  (TOE_Busy == 1'b1)            
                       fsm_curr <= FSM_TOE;           
                   else if ( CMD_Cfg_Done == 1'b1 )  
                       fsm_curr <= FSM_CFG_ACK;       
                end  
                
          FSM_CFG_ACK:
                 begin
                     r_cfg_ack <= 1'b1;
                     r_init_ack <= 1'b0;   
                     if  (TOE_Busy == 1'b1) 
                         fsm_curr <= FSM_TOE; 
                     else if ( CMD_Done == 1'b1 )
                         fsm_curr <= FSM_SEND_DATA;
                         
                 end     
                 
                                      
          FSM_SEND_DATA:
                 begin
                     Frm_Tx_En <= 1'b1;
                     r_cfg_ack <= 1'b0;  
                     if  (TOE_Busy == 1'b1) 
                         fsm_curr <= FSM_TOE; 
                     else if ( CMD_ShutDown == 1'b1 )
                         fsm_curr <= FSM_SHUT_DOWN;
//                     else if( CMD_Cfg_Done == 1'b1 )  
//                         fsm_curr <= FSM_CFG_ACK;
  
                  end
                 
          FSM_SHUT_DOWN:
                 begin
                     r_shutdown_ack <= 1'b1;
  
                     if ( CMD_Cfg_Done == 1'b1 )
                         fsm_curr <= FSM_CFG_ACK;
                  end
                  
           default: fsm_curr <= FSM_TOE;
         endcase
   end

   //------------------------------------------
   //--  "Mode" follow system parameter
   //------------------------------------------
   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
           r_cmd_cycle <= 0;
       else
          r_cmd_cycle  <=  r_cmd_cycle + 1;
   end


   always @(posedge clk or negedge rst_n)
   begin
      if ( rst_n == 1'b0 )
      begin
          CMD_TX <= 1'b0;
          CMD_Type <= 2'b0;
      end
      else
          if    ( r_init_ack == 1'b1 && r_cmd_cycle == 10 )
          begin
              CMD_TX <= 1'b1;
              CMD_Type <= 2'b01;
          end
          else if  ( r_cfg_ack == 1'b1 )
          begin
              CMD_TX <= 1'b1;
              CMD_Type <= 2'b01;
          end
          else  if    ( r_shutdown_ack == 1'b1 && r_cmd_cycle == 10 )
          begin
              CMD_TX <= 1'b1;
              CMD_Type <= 2'b10;
          end
          else
          begin
              CMD_TX <= 1'b0;
          end


   end

 
endmodule