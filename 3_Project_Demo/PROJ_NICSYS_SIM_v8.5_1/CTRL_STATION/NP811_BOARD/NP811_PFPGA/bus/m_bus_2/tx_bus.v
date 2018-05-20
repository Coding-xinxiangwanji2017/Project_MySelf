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



module tx_bus(

    //------------------------------------------
    //--  Global Reset, active low
    //------------------------------------------
    input reset                           ,
    //------------------------------------------
    //--  Global clocks
    //------------------------------------------
    input clk                             ,
    //------------------------------------------
    //--  input
    //-------------------------------------------
    input [7:0]lcudb_rdata                ,
    input [7:0]lcucb_rdata                ,
    input [7:0]ldub_rdata                 ,
    input [2:0]rack_id                    ,
    input [3:0]slot_id                    ,
    input rx_flag                         ,
    input [7:0]rx_mode                    ,
    input [23:0]rx_addr                    ,
    input ini_done                        ,
    //------------------------------------------
    //--  output
    //-------------------------------------------
    output reg lcudb_rden                 ,
    output reg [23:0]lcudb_raddr          ,
    output reg lcucb_rden                 ,
    output reg [23:0]lcucb_raddr          ,
    output reg ldub_rden                  ,
    output reg [23:0]ldub_raddr           ,
    output reg tx_buf_wren                ,
    output reg [10:0]tx_buf_waddr         ,
    output reg [7:0]tx_buf_wdata          ,
    output reg [10:0]tx_data_len          ,
    output reg tx_start                                
);
   //=========================================================
   // Local parameters
   //=========================================================
   parameter idle=4'd0;
   parameter wrda =4'd1;
   parameter wrsa =4'd2;
   parameter wrfc =4'd3;
   parameter wrmo =4'd4;
   parameter wrcmd=4'd5;
   parameter wrdata=4'd7;
   parameter wrtype=4'd6;
   parameter delay =4'd8;
   parameter delay1=4'd9;
   
   //=========================================================
   // Internal signal definition
   //=========================================================
   reg [3:0]state;
   reg [3:0]next_state;
   reg [23:0]F_addr;
   reg [7:0]SA;
   reg [7:0]DA;
   reg [7:0]FC;
   reg [7:0]TYPE;                      //card type,variable
   reg [7:0]MODE;
   reg [23:0]C_addr;
   reg [3:0]count;
   reg [7:0]count1;
   reg [1:0]count2;
   reg [1:0]i;
   reg [1:0]ini_done_edge;
   reg [1:0]rx_flag_edge;
   reg BEGIN;
   reg symbol;
   reg flag;
   reg [7:0]slot;
   reg [7:0]rack;
   //=========================================================
   //  count
   //=========================================================
   always@(posedge clk)
   begin
     if(BEGIN && count<4'd5)
       count<=count+1'b1;
     else
       count<=4'd0;
   end
   always@(posedge clk)
   begin
     if(symbol && count1<8'd128) 
       count1<=count1+1'b1;
     else
       count1<=8'd0;
   end
   always@(posedge clk)
   begin
     if(flag && count2<2'd2)
     count2<=count2+1'b1;
     else
     count2<=2'd0;
   end 
   //=========================================================
   //  edge detector
   //=========================================================
   always @(posedge clk or posedge reset)
   begin
     if(reset)
       begin
         ini_done_edge<=2'b00;
         rx_flag_edge<=2'b00;
       end
     else begin
       ini_done_edge<={ini_done_edge[0],ini_done};
       rx_flag_edge<={rx_flag_edge[0],rx_flag};
     end
   end
   //=========================================================
   //  get SA and DA
   //=========================================================
   always @(posedge clk or posedge reset)
   begin
     if(reset)
       begin
         slot<=4'd0;
         rack<=3'd0;
         DA<=8'd0;
       end
     else if(ini_done_edge==2'b01)
       begin
         slot<={4'd0,slot_id};
         rack<={5'd0,rack_id};
         DA<=8'hFE;
       end
    end
   //=========================================================
   //  get mode and address
   //=========================================================
   always @(posedge clk or posedge reset)
   begin
     if(reset)
       begin
         MODE<=8'd0;
         F_addr<=24'd0;
       end
     else if(rx_flag_edge==2'b01)
       begin
         MODE<=rx_mode;
         F_addr<=rx_addr;
       end
   end
   //=========================================================
   //  current state
   //=========================================================
   always @(posedge clk or posedge  reset)
   begin
     if(reset)
       begin
         /*lcudb_rden<=1'b0;
         lcudb_raddr<=23'd0;
         lcucb_rden<=1'b0;
         lcucb_raddr<=23'd0;
         ldub_rden<=1'b0;
         ldub_raddr<=23'd0;
         tx_buf_wren<=1'b0;
         tx_buf_waddr<=11'd0;
         tx_buf_wdata<=8'd0;
         tx_data_len<=11'd0;
         tx_start<=1'b0;
         state<=4'd0;
         next_state<=4'd0;
         i<=2'd0;
         C_addr<=23'd0;
         count<=4'd0;
         count1<=8'd0;
         count2<=2'd0;
         FC<=8'd0;
         TYPE<=8'd0;
         BEGIN<=1'b0;
         symbol<=1'b0;
         flag<=1'b0;*/
			state<=4'd0;
       end
     else
       state<=next_state;
  end
  
   //=========================================================
   //  next state
   //=========================================================
   always @(*)
   begin
   case(state)
        
        idle:
        begin
        lcudb_rden=1'b0;
        lcudb_raddr=23'd0;
        lcucb_rden=1'b0;
        lcucb_raddr=23'd0;
        ldub_rden=1'b0;
        ldub_raddr=23'd0;
        tx_buf_wren=1'b0;
        tx_buf_waddr=11'd0;
        tx_buf_wdata=8'd0;
        tx_data_len=11'd0;
        tx_start=1'b0;
        next_state=4'd0;
        i=2'd0;
        C_addr=23'd0;
        FC=8'd0;
        TYPE=8'd0;
        BEGIN=1'b0;
        symbol=1'b0;
        flag=1'b0;
        if(ini_done_edge==2'b01)
          begin
            next_state=wrda;
          end
        end
        
        wrda:
        begin
          tx_buf_wren=1'b1;
          tx_buf_waddr=11'd0;
          tx_buf_wdata=DA;
          SA=(rack<<3)+(rack<<2)+(rack<<1)+8'd14-slot;           
          next_state=wrsa;
        end                                                                //write DA
        
        wrsa:
        begin
          tx_buf_wren=1'b1;
          tx_buf_waddr=11'd1;
          tx_buf_wdata=SA;
          FC=8'h20;
          next_state=wrfc;
        end                                                               //write SA
        
        wrfc:
        begin
          tx_buf_wren=1'b1;
          tx_buf_waddr=11'd2;
          tx_buf_wdata=FC;
          next_state=delay;
        end                                                              //write FC
        
        wrmo:
        begin
          if(MODE==8'h02)
            begin
            tx_buf_wren=1'b1;
            tx_buf_waddr=11'd3;
            tx_buf_wdata=MODE;
            i=2'b01;
            flag=1'b1;
            next_state=delay1;
            ldub_rden=1'b1;
            ldub_raddr=F_addr;
            end                                                          //download mode
          else begin
            tx_buf_wren=1'b1;
            tx_buf_waddr=11'd3;
            tx_buf_wdata=MODE;
            i=2'b10;
            lcucb_rden=1'b1;
            lcucb_raddr=F_addr>>4;
            next_state=delay1;
            flag=1'b1;
          end        
        end                                                              //console and run mode 
        
        wrcmd:
        begin
          case(i)
            2'b01:
            begin
              flag=1'b0;
              if(count<4'd5)
                begin
                tx_buf_waddr=tx_buf_waddr+1'b1;
                ldub_raddr=ldub_raddr+1'b1;
                tx_buf_wdata=ldub_rdata;
                next_state=wrcmd;
                end
              else begin
                next_state=wrtype;
                BEGIN=1'b0;
                ldub_rden=1'b0;
              end
            end                                                                  //write download cmd
            
            2'b10:
            begin
              flag=1'b0;
              if(count<4'd5)
                begin
                  tx_buf_waddr=tx_buf_waddr+1'b1;
                  lcucb_raddr=lcucb_raddr+1'b1;
                  tx_buf_wdata=lcucb_rdata;
                  next_state=wrcmd;
                end
              else begin
                next_state=wrtype;
                BEGIN=1'b0;
                lcucb_rden=1'b0;
              end
            end                                                                    //write console and run cmd
            
            default:;
          endcase
        end
        
        wrtype:
        begin
          tx_buf_wren=1'b1;
          tx_buf_waddr=11'd9;
          tx_buf_wdata=8'h60;                                                    //write type
          case(i)
          
          2'b01:
          begin
          ldub_rden=1'b1;
          ldub_raddr=F_addr+4'd8;
          next_state=delay1;
          i=2'b11;
          flag=1'b1;
          end
          
          2'b10:
          begin
           lcudb_rden=1'b1;
           lcudb_raddr=F_addr;
           next_state=delay1;
           i=2'b00;
           flag=1'b1;
          end
          default:;
          endcase
        end                                                                       
        
        wrdata:
        begin
          case(i)
            2'b00:
            begin
            flag=1'b0;
            if(count1<8'd128)
              begin
              lcudb_raddr=lcudb_raddr+1'b1;
              tx_buf_waddr=tx_buf_waddr+1'b1;
              tx_buf_wdata=lcucb_rdata;
              end
            else begin
            lcudb_rden=1'b0;
            lcudb_raddr=23'd0;
            tx_buf_wren=1'b0;
            tx_buf_waddr=11'd0;
            tx_buf_wdata=8'd0;
            symbol=1'b0;
            next_state=delay;
            end
            end                                                                      //write console and run data
            
            2'b11:
            begin
              flag=1'b0;
              if(count1<8'd128)
              begin
              ldub_raddr=ldub_raddr+1'b1;
              tx_buf_waddr=tx_buf_waddr+1'b1;
              tx_buf_wdata=ldub_rdata;
              end
            else begin
            ldub_rden=1'b0;
            ldub_raddr=23'd0;
            tx_buf_wren=1'b0;
            tx_buf_waddr=11'd0;
            tx_buf_wdata=8'd0;
            symbol=1'b0;
            next_state=delay;
            end
            end                                                                        //write download data
            
            default:;
          endcase
        end
        
        delay:
        begin
          tx_buf_wren=1'b0;
          i=2'b00;
          if(rx_flag_edge==2'b01)
            begin
            next_state=wrmo;
            tx_start=1'b1;
            tx_data_len=11'd138;
            end
        end
        
        delay1:
        begin
        case(i)
          
        2'b01:
        begin
        if(count2<4'd2)
        begin
        ldub_raddr=ldub_raddr+1'b1;
        next_state=delay1;
        end
        else begin
        ldub_raddr=ldub_raddr+1'b1;  
        tx_buf_wren=1'b1;
        tx_buf_wdata=ldub_rdata;
        tx_buf_waddr=11'd4;
        next_state=wrcmd;
        BEGIN=1'b1;
        end
        end    
        
        2'b10:
        begin
        if(count2<4'd2)
        begin
        lcucb_raddr=lcucb_raddr+1'b1;
        next_state=delay1;
        end
        else begin
        lcucb_raddr=lcucb_raddr+1'b1;
        tx_buf_wren=1'b1;
        tx_buf_wdata=lcucb_rdata;
        tx_buf_waddr=11'd4;
        next_state=wrcmd;
        BEGIN=1'b1;
        end
        end  
        
        2'b11:
        begin
          if(count2<4'd2)
            begin
              ldub_raddr=ldub_raddr+1'b1;
              next_state=delay1;
            end
          else begin
            ldub_raddr=ldub_raddr+1'b1;
            tx_buf_wren=1'b1;
            tx_buf_waddr=11'd10;
            tx_buf_wdata=ldub_rdata;
            next_state=wrdata;
            symbol=1'b1;
          end
        end
        
        2'b00:
        begin
          if(count2<4'd2)
            begin
              lcudb_raddr=lcudb_raddr+1'b1;
              next_state=delay1;
            end
          else begin
            lcudb_raddr=lcudb_raddr+1'b1;
            tx_buf_wren=1'b1;
            tx_buf_waddr=11'd10;
            tx_buf_wdata=ldub_rdata;
            next_state=wrdata;
            symbol=1'b1;
          end
        end
        endcase
        end
      endcase
    end
  endmodule
          

