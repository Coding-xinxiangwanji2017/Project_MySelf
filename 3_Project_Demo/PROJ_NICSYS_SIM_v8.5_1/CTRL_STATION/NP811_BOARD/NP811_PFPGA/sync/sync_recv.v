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


module sync_recv(
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
    input [7:0]slink_rx_data,                                     //BUFFER DOUT
    input sync_recv_en,
    input [1:0]sync_Btoa_en,                                      //DATA READY
    
    
    //------------------------------------------
    //--  output
    //------------------------------------------
    output reg slink_rx_rden,                                     //BUFfER en
    output reg [10:0]slink_rx_address,                            //BUFFER address
    output reg slink_wen,                                         //AFPGA Write en
    output reg [22:0]slink_waddr,                                 //AFPGA write addr
    output reg [7:0]slink_data                                    //AFPGA write data
    );
   
//=========================================================
// Local parameters
//=========================================================   
parameter doneaddress =  23'd2050;
parameter donedata    =  8'd34;
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
reg sync_en;
reg [1:0]sync_en_edge;
reg [1:0]sync_bota_en;
//=========================================================
// enable signal get
//=========================================================
always@(posedge clk or posedge reset)
begin
if(reset)
begin
sync_en_edge<=2'b00;
sync_bota_en<=2'b00;
end
else begin
sync_en_edge<={sync_en_edge[0],sync_recv_en};
sync_bota_en<=sync_Btoa_en;
end
end
always@(posedge clk or posedge reset)
begin
if(reset)
sync_en<=1'b0;
else
sync_en<= (sync_en_edge==2'b01)&&(sync_bota_en==2'b10);
end  
//=========================================================
// fsm
//=========================================================  
always @(posedge clk or posedge reset)
begin
 if(reset)
    begin
    state<=idle;
    slink_rx_rden<=1'b0;
    slink_rx_address<=11'd0;
    slink_wen<=1'b0;
    slink_waddr<=23'd0;
    slink_data<=8'd0;
    end
 else
  case(state)
    
    idle:
    begin
      slink_wen<=1'b0;
      if(sync_en)
        begin
        state<=delay;
        slink_rx_rden<=1'b1;
        slink_rx_address<=11'd0;
        end
      else
        state<=idle;                                                           //initial state
    end
    
    shift:
    begin
      if(sync_en)
      begin
      if(slink_rx_address>11'd0 && slink_rx_address<11'd2047)
        begin
          slink_data<=slink_rx_data;
          slink_waddr<=slink_waddr+1'b1;
          slink_rx_address<=slink_rx_address+1'b1;
          state<=shift;                                                          //transmit data
        end
      else begin
        state<=delay1;
        slink_data<=slink_rx_data;
        slink_waddr<=slink_waddr+'b1;
        slink_rx_rden<=1'b0;
        slink_rx_address<=11'h0;                                                        //end read and wait data
      end
      end
      else
        state<=idle;
    end
          
    delay:
    begin
    if(!sync_en)
      state<=idle;
    else begin
      if(count<2'd2)
        begin
        count<=count+1'b1;
        state<=delay;
        slink_rx_address<=slink_rx_address+1'b1;
        end
      else begin
        slink_wen<=1'b1;
        slink_data<=slink_rx_data;
        slink_waddr<=23'h300002;
        slink_rx_address<=slink_rx_address+1'b1;
        state<=shift;
        count<=2'd0;
      end                                                                              //delay two clock to wait data appearing
    end
    end
    
    delay1:
    begin
      if(!sync_en)
        state<=idle;
      else begin
      if(count<2'd1)
        begin
        count<=count+1'b1;
        slink_data<=slink_rx_data;
        slink_waddr<=slink_waddr+1'b1;
        end                                                                             //delay 1 clock to wait data write
      else begin
        slink_wen<=1'b0;
        slink_data<=8'd0;
        slink_waddr<=23'd0;
        state<=done;
       end
     end
    end
    
    done:
    begin
      slink_wen<=1'b1;
      slink_data<=donedata;
      slink_waddr<=doneaddress;
      state<=idle;                                                                    //write done and return to idle
    end
  endcase
end
endmodule
        




























