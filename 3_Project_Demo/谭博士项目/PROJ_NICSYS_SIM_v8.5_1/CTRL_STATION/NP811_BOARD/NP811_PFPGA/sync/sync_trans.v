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
// Name of module : NP811_U1_C01_TOP
// Project        : NicSys8000
// Func           : Project TOP
// Author         : Liu zhikai
// Simulator      : Modelsim Microsemi 10.3c / Windows 7 32bit
// Synthesizer    : Libero SoC v11.5 SP2 / Windows 7 32bit
// FPGA/CPLD type : M2GL050-FG484
// version 1.0    : made in Date: 2015.12.01
// Modification Logs:
// -----------------------------------------------------------------------------
//   Version   Date         Description(Recorder)
// -----------------------------------------------------------------------------
//     1.0   2016/04/25   Initial version(xu peidong)
//
//
//
////////////////////////////////////////////////////////////////////////////////

module sync_trans(
    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input reset,
    
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input clk,
   
    //------------------------------------------
    //--  input
    //------------------------------------------    
    input [7:0]slink_data,                                              //AFPGA DATA OUT
    input sync_trans_en,
    
    
    //------------------------------------------
    //--  output
    //------------------------------------------
    output reg slink_rden,                                              //AFPGA DATA en
    output reg [23:0]slink_raddr,                                       //AFPGA DATA address
    output reg slink_tx_wren,                                           //BUFFER en
    output reg [10:0]slink_tx_waddr,                                    //BUFFER address
    output reg [7:0]slink_tx_data                                       //BUFFER data
    );
   
//=========================================================
// Local parameters
//=========================================================   
//parameter doneaddress =  23'd2050;
//parameter donedata    =  8'd34;
parameter idle        =  3'd0;
parameter shift       =  3'd1;
parameter delay       =  3'd2;
parameter delay1      =  3'd3;
parameter done        =  3'd4;
//=========================================================
// reg or wire net
//=========================================================    

reg [2:0]state;
reg [1:0]count;
reg [1:0]sync_trans_en_edge;
//=========================================================
// fsm
//=========================================================  
always @(posedge clk or posedge reset)
begin
if(reset)
sync_trans_en_edge<=2'd0;
else
sync_trans_en_edge<={sync_trans_en_edge[0],sync_trans_en};
end
//=========================================================
// fsm
//=========================================================  
always @(posedge clk or posedge reset)
begin
if(reset)
 begin
    state<=idle;
    slink_tx_wren<=1'b0;
    slink_tx_waddr<=11'd0;
    slink_rden<=1'b0;
    slink_raddr<=24'd0;
    slink_tx_data<=8'd0;
  end
  else
  case(state)
    
    idle:
    begin
      if(sync_trans_en_edge==2'b01)
        begin
        state<=delay;
        slink_rden<=1'b1;
        slink_raddr<=23'h300002;
        end
      else
        state<=idle;                                                   //initial state
    end
    
    shift:
    begin
      if(sync_trans_en)
      begin
      if(slink_raddr>24'h300002 && slink_raddr<24'h300800)
        begin
          slink_tx_data<=slink_data;
          slink_tx_waddr<=slink_tx_waddr+1'b1;
          slink_raddr<=slink_raddr+1'b1;
          state<=shift;                                                  //transmit data
        end
      else begin
        state<=delay1;
        slink_tx_data<=slink_data;
        slink_tx_waddr<=slink_tx_waddr+'b1;
        slink_rden<=1'b0;
        slink_raddr<=23'h0;                                                   //read done and wait data 
      end
      end
      else
        state<=idle;
    end
          
    delay:
    begin
    if(!sync_trans_en)
      state<=idle;
    else begin
      if(count<2'd2)
        begin
        count<=count+1'b1;
        state<=delay;
        slink_raddr<=slink_raddr+1'b1;
        end
      else begin
        slink_tx_wren<=1'b1;
        slink_tx_data<=slink_data;
        slink_tx_waddr<=11'b0;
        slink_raddr<=slink_raddr+1'b1;
        state<=shift;
        count<=2'd0;
      end                                                                            //dealy two clock to wait data appearing
    end
    end
    
    delay1:
    begin
      if(!sync_trans_en)
        state<=idle;
      else begin
      if(count<2'd1)
        begin
        count<=count+1'b1;
        slink_tx_data<=slink_data;
        slink_tx_waddr<=slink_tx_waddr+1'b1;
        end
      else begin
        slink_tx_wren<=1'b0;
        slink_tx_data<=8'd0;
        slink_tx_waddr<=23'd0;
        state<=done;
        count<=2'd0;
       end
     end
    end                                                                               //delay 1 clock to wait data write  
    
    done:
    begin
      slink_tx_wren<=1'b0;
      state<=idle;                                                               //write done and return to idle
    end
  endcase
end
endmodule