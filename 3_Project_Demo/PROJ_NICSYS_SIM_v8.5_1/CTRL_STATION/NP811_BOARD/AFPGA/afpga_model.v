////////////////////////////////////////////////////////////////////////////
// Copyright (c)2016 CNCS Incorporated                                    //
// All Rights Reserved                                                    //
// THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of CNCS Inc.               //
// The copyright notice above does not evidence any actual or intended    //
// publication of such source code.                                       //
// No part of this code may be reproduced, stored in a retrieval system,  //
// or transmitted, in any form or by any means, electronic, mechanical,   //
// photocopying, recording, or otherwise, without the prior written       //
// permission of CNCS                                                     //
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
// Name of module : afpga_model                                           //
// Project        : NicSys                                                //
// Func           : afpga_model                                           //
// Author         : ***                                                   //
// Simulator      : ModelsimMicrosemi 10.3c / Windows 7 32bit             //
// Synthesizer    : LiberoSoC v11.5 SP2 / Windows 7 32bit                 //
// FPGA/CPLD type : M2GL150-1FG484                                        //
// version 1.0    : made in Date: 2016.03.31                              //
// Update: 1.1    : made in Date£º                                        //
// Purpose        : add the logic of redundancy                           //
////////////////////////////////////////////////////////////////////////////
`define SIM

`timescale 1ns / 100ps

module afpga_model(
                   clk          ,
                   rst_n        ,
                                
                   i_pfpga_rst_n,
                   
                   i_pfpga_clk  ,
                   i_pfpga_wr   ,
                   im_pfpga_addr,
                   im_pfpga_data,
                   om_pfpga_data,
                   
                   o_heart_beat ,
                   
                   test
                  );


parameter DWIDTH    = 8'd8       ;  
parameter AWIDTH    = 5'd23      ;

parameter IWIDTH    = 72         ;
parameter OWIDTH    = 40         ;
parameter VWIDTH    = 8          ;
parameter SYN_WIDTH = 2048       ;

`define I_START_ADDR 0 
`define O_START_ADDR IWIDTH
`define V_START_ADDR (IWIDTH+OWIDTH)
`define S_START_ADDR 0
                               
input               clk          ;
input               rst_n        ;

input               i_pfpga_rst_n;
                                  
input               i_pfpga_clk  ;
input               i_pfpga_wr   ;
input  [AWIDTH-1:0] im_pfpga_addr;
input  [DWIDTH-1:0] im_pfpga_data;
output [DWIDTH-1:0] om_pfpga_data;
                   
output              o_heart_beat ;    

output [31:0]       test         ;


wire                w_rst_n           ;
reg    [7:0]        r_pfpga_status    ;         
reg                 r_keep_pfpga_pulse;

reg    [1:0]        r_load_pfpga_pulse;

wire                w_pfpga_status_rise;
wire                w_pfpga_status_fall;


reg                 r_afpga_keep       ;
reg    [1:0]        r_pfpga_exch       ;

reg    [7:0]        om_pfpga_data      ;

reg    [7:0]        r_afpga_status     ;
//wire   [7:0]        w_afpga_err        ;
                    
reg    [7:0]        r_afpga_staex      ;                    

reg    [2:0]        r_pfpga_addr_sel   ;
                                       
wire   [7:0]        w_init_tmp         ;

wire   [7:0]        w_afpga_staex      ;
wire   [7:0]        w_afpga_var        ;
wire   [7:0]        w_afpga_sync       ;
                                     
    
reg                 r_init_ena         ;
reg    [16:0]       r_init_addr        ; 
wire   [7 :0]       w_init_data        ;
//reg    [31:0]       r_init_crc         ;
//wire   [31:0]       w_init_crc_next    ;
//wire   [31:0]       w_init_crc_final   ;
//reg    [1 :0]       r_init_ena_dly     ;
//reg                 r_init_err         ;
                                       
reg                 r_var_ena          ; 
                                       
reg                 r_var_wr_wren      ; 
reg    [13:0]       r_var_wr_addr      ;  
reg    [7:0]        r_var_wr_data      ;  
                                       
reg    [13:0]       r_var_rd_addr      ;  
wire   [7:0]        w_var_rd_data      ;  
                                       
                                       
//reg    [31:0]       r_algo1_in         ;
//reg    [15:0]       r_algo1_para1      ;
//reg    [15:0]       r_algo1_para2      ;
//                                       
//reg    [7:0]        r_algo2_var1       ;
//reg    [7:0]        r_algo2_var2       ; 
//       
//       
//reg    [15:0]       r_algo1_out1       ;
//reg    [7 :0]       r_algo1_out2       ;
//reg    [7 :0]       r_algo1_out3       ;
//
//reg    [7 :0]       r_algo2_out1       ;
reg [31:0] r_ai_data1 ;
reg [31:0] r_ai_data2 ;
reg [31:0] r_ai_data3 ;
reg [31:0] r_ai_data4 ;
reg [31:0] r_ai_data5 ;
reg [31:0] r_ai_data6 ;
reg [31:0] r_ai_data7 ;
reg [31:0] r_ai_data8 ;
reg [15:0] r_di_data1 ;
reg [15:0] r_di_data2 ;
reg [15:0] r_di_data3 ;
reg [15:0] r_di_data4 ;
reg [15:0] r_di_data5 ;
reg [15:0] r_di_data6 ;
reg [15:0] r_di_data7 ;
reg [15:0] r_di_data8 ;
reg [15:0] r_di_data9 ;
reg [15:0] r_di_data10;
reg [15:0] r_di_data11;
reg [15:0] r_di_data12;
reg [15:0] r_di_data13;
reg [15:0] r_di_data14;
reg [15:0] r_di_data15;
reg [15:0] r_di_data16;
reg [15:0] r_di_data17; 

reg [7 :0] r_cm_data1 ;
reg [7 :0] r_cm_data2 ;

reg [7 :0] r_cm_init1 ;
reg [7 :0] r_cm_init2 ;

reg [7 :0] r_cm_cnt1  ;
reg [7 :0] r_cm_cnt2  ;

                                       
reg                 r_calc_finish      ;


reg                 r_sync_ena         ; 
                                       
reg                 r_sync_wr_wren     ;    
reg    [10:0]       r_sync_wr_addr     ;    
reg    [7:0]        r_sync_wr_data     ;    
                                       
reg    [10:0]       r_sync_rd_addr     ;    
wire   [7:0]        w_sync_rd_data     ;   
reg    [7:0]        r_sync1_in         ;      

reg                 o_heart_beat       ;

assign w_rst_n = rst_n && i_pfpga_rst_n;

always @(posedge i_pfpga_clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    begin
      r_keep_pfpga_pulse <= 1'b0         ;
      r_pfpga_status <= 'h0              ;
    end    
  else
    if((im_pfpga_addr[AWIDTH-1:AWIDTH-3] == 3'd0) && (~|im_pfpga_addr[16:0]) && i_pfpga_wr)
    begin
      r_keep_pfpga_pulse <= 1'b1         ;	
      r_pfpga_status     <= im_pfpga_data;
    end
    else if((~r_pfpga_exch[1]) && r_pfpga_exch[0])
    begin
      r_keep_pfpga_pulse <= 1'b0         ;
      r_pfpga_status <= 'h0              ;
    end  
end

always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_load_pfpga_pulse <= 1'b0; 
  else
    r_load_pfpga_pulse <= {r_load_pfpga_pulse[0],r_keep_pfpga_pulse};
end  
  
  
assign w_pfpga_status_rise = (~r_load_pfpga_pulse[1]) && r_load_pfpga_pulse[0];
assign w_pfpga_status_fall = r_load_pfpga_pulse[1] && (~r_load_pfpga_pulse[0]);

always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_afpga_keep <= 1'b0;	  
  else
    if(w_pfpga_status_rise)
      r_afpga_keep <= 1'b1;	
    else if(w_pfpga_status_fall)
      r_afpga_keep <= 1'b0;	
end

always @(posedge i_pfpga_clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_pfpga_exch <= 1'b0;
  else 
    r_pfpga_exch <= {r_pfpga_exch[0],r_afpga_keep};
end

always @(posedge i_pfpga_clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_afpga_staex <= 8'b0;	  
  else
    if(im_pfpga_addr[16:0] == 17'd4)
      r_afpga_staex <= r_afpga_status;
    if(im_pfpga_addr[16:0] == 17'd7)
      r_afpga_staex <= 8'b0;//w_afpga_err   ;
end      


assign w_afpga_staex = r_afpga_staex; 

always @(posedge i_pfpga_clk or negedge w_rst_n)
begin
	if(~w_rst_n)
	    r_pfpga_addr_sel <= 3'd0;
	else
        r_pfpga_addr_sel <= im_pfpga_addr[AWIDTH-1:AWIDTH-3];
end 

always @( * )
begin
  case(r_pfpga_addr_sel)
    3'd0: om_pfpga_data = w_afpga_staex;
    3'd1: om_pfpga_data = w_afpga_var  ;
    3'd3: om_pfpga_data = w_afpga_sync ;
    default:;
  endcase
end

`ifdef SIM
dpram   
  #(
    .DEPTH     (131072),
    .DATA_WIDTH(8     ),
    .ADDR_WIDTH(17    )
    )
inst_code_dpram   
    (
    .clk_a   (i_pfpga_clk                                             ),
    .wren_a  ((im_pfpga_addr[AWIDTH-1:AWIDTH-3] == 3'd4) && i_pfpga_wr),
    .addr_a (im_pfpga_addr[16:0]                                      ),            
    .wdata_a (im_pfpga_data                                           ),

    .rdata_a (w_init_tmp   ),                 
              
    .clk_b   (clk          ),
    .wren_b  (1'h0         ),
    .addr_b  (r_init_addr  ),
    .wdata_b (8'h0         ),
           
    .rdata_b (w_init_data  )       
    );    

`else
dpram131072_8   
//  #(
//    .DEPTH     (131072),
//    .DATA_WIDTH(8     ),
//    .ADDR_WIDTH(17    )
//    )

inst_code_dpram
(
    .A_ADDR (im_pfpga_addr[16:0] ),
    .A_CLK  (i_pfpga_clk  ),
    .A_DIN  (im_pfpga_data),
    .A_WEN  ((im_pfpga_addr[AWIDTH-1:AWIDTH-3] == 3'd4) && i_pfpga_wr),
    .B_ADDR (r_init_addr ),
    .B_CLK  (clk         ),
    .B_DIN  (8'h0        ),
    .B_WEN  (1'h0        ),
    .A_DOUT (w_init_tmp  ),
    .B_DOUT (w_init_data )
);
`endif

always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_init_ena <= 1'b0; 
  else
    if(w_pfpga_status_rise && (r_pfpga_status[7:6] == 2'b10))
      r_init_ena <= 1'b1;
    else if(r_init_addr >= 17'd131071)
      r_init_ena <= 1'b0;      
end

always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_init_addr <= 17'b0; 
  else
    if(r_init_ena)
      if(r_init_addr <= 17'd131071)      
        r_init_addr <= r_init_addr + 1'b1;   
      else
        r_init_addr <= 17'b0;   
end

always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_afpga_status <= 8'b0;
  else  
    begin
    r_afpga_status[5:4] <= (r_init_ena)? 2'b01   : 2'b10  ;
    r_afpga_status[3:0] <= (r_var_ena )? 4'b0001 : 4'b0010;
    end
end   

//initial

reg [13:0]  r_init_cnt       ;
wire        w_init_en        ;
wire        w_var_real_wren  ;
wire [13:0] w_var_real_wraddr;
wire [7:0]  w_var_real_wrdata;

always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_init_cnt <= 'd0;
  else 
    if(r_init_cnt < 'd16383) 
       r_init_cnt <= r_init_cnt + 1'b1; 
end

assign w_init_en = (r_init_cnt < 'd16383);

assign w_var_real_wren   = w_init_en || r_var_wr_wren;
assign w_var_real_wraddr = (w_init_en)? r_init_cnt      : r_var_wr_addr;
assign w_var_real_wrdata = (w_init_en)? r_init_cnt[7:0] : r_var_wr_data;

wire [13:0] r_var_addr = w_var_real_wren? w_var_real_wraddr : r_var_rd_addr;
`ifdef SIM
dpram   
  #(
    .DEPTH     (16384 ),
    .DATA_WIDTH(8     ),
    .ADDR_WIDTH(14    )
    )        
inst_var_dpram   
    (
    .clk_a   (i_pfpga_clk                                             ),
    .wren_a  ((im_pfpga_addr[AWIDTH-1:AWIDTH-3] == 3'd1) && i_pfpga_wr),
    .addr_a  (im_pfpga_addr[13:0]                                     ),            
    .wdata_a (im_pfpga_data                                           ),
    .rdata_a (w_afpga_var        ),                 
             
    .clk_b   (clk                ),
    .wren_b  (w_var_real_wren    ),
    .addr_b  (r_var_addr         ),
    .wdata_b (w_var_real_wrdata  ),                                
    .rdata_b (w_var_rd_data      )       
    );  
`else
dpram16384_8   
//  #(
//    .DEPTH     (16384 ),
//    .DATA_WIDTH(8     ),
//    .ADDR_WIDTH(14    )
//    ) 
inst_var_dpram
(
    .A_ADDR (im_pfpga_addr[13:0]),
    .A_CLK  (i_pfpga_clk        ),
    .A_DIN  (im_pfpga_data      ),
    .A_WEN  ((im_pfpga_addr[AWIDTH-1:AWIDTH-3] == 3'd1) && i_pfpga_wr),
    .B_ADDR (r_var_addr         ),
    .B_CLK  (clk                ),
    .B_DIN  (w_var_real_wrdata  ),
    .B_WEN  (w_var_real_wren    ),

    .A_DOUT (w_afpga_var        ),
    .B_DOUT (w_var_rd_data      )
);
`endif
 
always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_var_ena <= 1'b0; 
  else
    if(w_pfpga_status_rise && (r_pfpga_status[2:0] == 3'b011))
      r_var_ena <= 1'b1;
    else if(r_calc_finish)
      r_var_ena <= 1'b0;      
end    
 
always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_var_rd_addr <= 'h0; 
  else
    if(w_pfpga_status_rise && (r_pfpga_status[2:0] == 3'b011))
      r_var_rd_addr <= 1'b1;
    else 
      if(r_var_rd_addr >= 16383)
        r_var_rd_addr <= 'h0;   
      else if(|r_var_rd_addr)
        r_var_rd_addr <= r_var_rd_addr + 1'b1;   
end  

//ai

always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    begin
    r_ai_data1  <= 'h0; 
    r_ai_data2  <= 'h0; 
    r_ai_data3  <= 'h0; 
    r_ai_data4  <= 'h0; 
    r_ai_data5  <= 'h0; 
    r_ai_data6  <= 'h0; 
    r_ai_data7  <= 'h0; 
    r_ai_data8  <= 'h0; 
    r_di_data1  <= 'h0; 
    r_di_data2  <= 'h0; 
    r_di_data3  <= 'h0; 
    r_di_data4  <= 'h0; 
    r_di_data5  <= 'h0; 
    r_di_data6  <= 'h0; 
    r_di_data7  <= 'h0; 
    r_di_data8  <= 'h0; 
    r_ai_data8  <= 'h0; 
    r_di_data10 <= 'h0;
    r_di_data11 <= 'h0;
    r_di_data12 <= 'h0;
    r_di_data13 <= 'h0;
    r_di_data14 <= 'h0;
    r_di_data15 <= 'h0;
    r_di_data16 <= 'h0;
    r_di_data17 <= 'h0;
    
    r_cm_data1  <= 'h0;
    r_cm_data2  <= 'h0;
    end
  else
    case(r_var_rd_addr)
      `I_START_ADDR + 3 :r_ai_data1[7 : 0] <= w_var_rd_data;
      `I_START_ADDR + 4 :r_ai_data1[15: 8] <= w_var_rd_data;
      `I_START_ADDR + 5 :r_ai_data1[23:16] <= w_var_rd_data; 
      `I_START_ADDR + 6 :r_ai_data1[31:24] <= w_var_rd_data;  
      `I_START_ADDR + 7 :r_ai_data2[7 : 0] <= w_var_rd_data;        
      `I_START_ADDR + 8 :r_ai_data2[15: 8] <= w_var_rd_data;        
      `I_START_ADDR + 9 :r_ai_data2[23:16] <= w_var_rd_data;        
      `I_START_ADDR + 10:r_ai_data2[31:24] <= w_var_rd_data;        
      `I_START_ADDR + 11:r_ai_data3[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 12:r_ai_data3[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 13:r_ai_data3[23:16] <= w_var_rd_data;         
      `I_START_ADDR + 14:r_ai_data3[31:24] <= w_var_rd_data;         
      `I_START_ADDR + 15:r_ai_data4[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 16:r_ai_data4[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 17:r_ai_data4[23:16] <= w_var_rd_data;         
      `I_START_ADDR + 18:r_ai_data4[31:24] <= w_var_rd_data;         
      `I_START_ADDR + 19:r_ai_data5[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 20:r_ai_data5[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 21:r_ai_data5[23:16] <= w_var_rd_data;         
      `I_START_ADDR + 22:r_ai_data5[31:24] <= w_var_rd_data;         
      `I_START_ADDR + 23:r_ai_data6[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 24:r_ai_data6[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 25:r_ai_data6[23:16] <= w_var_rd_data;         
      `I_START_ADDR + 26:r_ai_data6[31:24] <= w_var_rd_data;         
      `I_START_ADDR + 27:r_ai_data7[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 28:r_ai_data7[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 29:r_ai_data7[23:16] <= w_var_rd_data;       
      `I_START_ADDR + 30:r_ai_data7[31:24] <= w_var_rd_data;       
      `I_START_ADDR + 31:r_ai_data8[7 : 0] <= w_var_rd_data;       
      `I_START_ADDR + 32:r_ai_data8[15: 8] <= w_var_rd_data;       
      `I_START_ADDR + 33:r_ai_data8[23:16] <= w_var_rd_data;       
      `I_START_ADDR + 34:r_ai_data8[31:24] <= w_var_rd_data;   

      `I_START_ADDR + 35:r_di_data1[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 36:r_di_data1[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 37:r_di_data2[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 38:r_di_data2[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 39:r_di_data3[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 40:r_di_data3[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 41:r_di_data4[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 42:r_di_data4[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 43:r_di_data5[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 44:r_di_data5[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 45:r_di_data6[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 46:r_di_data6[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 47:r_di_data7[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 48:r_di_data7[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 49:r_di_data8[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 50:r_di_data8[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 51:r_di_data9[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 52:r_di_data9[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 53:r_di_data10[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 54:r_di_data10[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 55:r_di_data11[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 56:r_di_data11[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 57:r_di_data12[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 58:r_di_data12[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 59:r_di_data13[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 60:r_di_data13[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 61:r_di_data14[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 62:r_di_data14[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 63:r_di_data15[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 64:r_di_data15[15: 8] <= w_var_rd_data;         
      `I_START_ADDR + 65:r_di_data16[7 : 0] <= w_var_rd_data;         
      `I_START_ADDR + 66:r_di_data16[15: 8] <= w_var_rd_data;         

      `I_START_ADDR + 67:r_cm_data1[7 : 0] <= w_var_rd_data ;  
      `I_START_ADDR + 68:r_cm_data2[7 : 0] <= w_var_rd_data ;  
    default:;
    endcase
end



always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    begin   
    r_cm_init1 <= 'h0; 
    r_cm_init2 <= 'h0; 
    end
  else
    case(r_var_rd_addr)
      `V_START_ADDR + 3: r_cm_init1[7 : 0] <= w_var_rd_data;
      `V_START_ADDR + 4: r_cm_init2[7 : 0] <= w_var_rd_data;
      default:;
    endcase
end
    	

always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_cm_cnt1 <= 'b0;
  else
    //if(r_sync_ena) 
    //  if(r_sync_rd_addr == 'd10)
    //    r_algo2_out1 <= r_sync1_in  ;      
    //else if(r_algo2_var1)        
      if(r_var_rd_addr >= 'd16383)
          r_cm_cnt1 <= r_cm_init1 + 1'b1;       
end


always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_cm_cnt2 <= 'b0;
  else
    //if(r_sync_ena) 
    //  if(r_sync_rd_addr == 'd10)
    //    r_algo2_out1 <= r_sync1_in  ;      
    //else if(r_algo2_var1)        
      if(r_var_rd_addr >= 'd16383)
          r_cm_cnt2 <= r_cm_init2 + 1'b1;       
end

wire [10:0] r_sync_addr = r_sync_wr_wren? r_sync_wr_addr : r_sync_rd_addr;

`ifdef SIM
dpram   
  #(
    .DEPTH     (2048  ),
    .DATA_WIDTH(8     ),
    .ADDR_WIDTH(11    )
    )    
inst_sync_dpram   
    (
    .clk_a   (i_pfpga_clk                                             ),
    .wren_a  ((im_pfpga_addr[AWIDTH-1:AWIDTH-3] == 3'd3) && i_pfpga_wr),
    .addr_a (im_pfpga_addr[10:0]                                      ),            
    .wdata_a (im_pfpga_data                                           ),
    .rdata_a (w_afpga_sync       ),                 
             
    .clk_b   (clk                ),
    .wren_b  (r_sync_wr_wren     ),
    .addr_b (r_sync_addr         ),
    .wdata_b (r_sync_wr_data     ),
    .rdata_b (w_sync_rd_data     )       
    ); 

`else
dpram2048_8   
//  #(
//    .DEPTH     (2048  ),
//    .DATA_WIDTH(8     ),
//    .ADDR_WIDTH(11    )
//    ) 
inst_sync_dpram
    (
    .A_ADDR (im_pfpga_addr[10:0]),
    .A_CLK  (i_pfpga_clk   ),
    .A_DIN  (im_pfpga_data ),
    .A_WEN  ((im_pfpga_addr[AWIDTH-1:AWIDTH-3] == 3'd3) && i_pfpga_wr),
    .B_ADDR (r_sync_addr   ),
    .B_CLK  (clk           ),
    .B_DIN  (r_sync_wr_data),
    .B_WEN  (r_sync_wr_wren),
    .A_DOUT (w_afpga_sync  ),
    .B_DOUT (w_sync_rd_data)
    );
`endif
   
always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_sync_ena <= 1'b0; 
  else
    if(w_pfpga_status_rise && (r_pfpga_status[5:3] == 3'b011))
      r_sync_ena <= 1'b1;
    else if(r_calc_finish)
      r_sync_ena <= 1'b0;      
end    
 
always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_sync_rd_addr <= 'h0; 
  else
    if(w_pfpga_status_rise && (r_pfpga_status[2:0] == 3'b011))
      r_sync_rd_addr <= 1'b1;
    else 
      if(r_sync_rd_addr >= 2047)
        r_sync_rd_addr <= 'h0;   
      else if(|r_sync_rd_addr)
        r_sync_rd_addr <= r_sync_rd_addr + 1'b1;   
end  

always @(posedge clk or negedge w_rst_n)
begin
  if(~w_rst_n)
    r_sync1_in <= 'h0; 
  else
    case(r_sync_rd_addr)
      `I_START_ADDR + 3:r_sync1_in <= w_sync_rd_data;
    default:;
    endcase
end
    
//=========================================================
parameter FSM_IDLE   = 10'd00;
parameter FSM_ST01   = 10'd01;
parameter FSM_ST02   = 10'd02;
parameter FSM_ST03   = 10'd03; 
parameter FSM_ST04   = 10'd04; 
parameter FSM_ST05   = 10'd05; 
parameter FSM_ST06   = 10'd06; 
parameter FSM_ST07   = 10'd07; 
parameter FSM_ST08   = 10'd08; 
parameter FSM_ST09   = 10'd09; 
parameter FSM_ST10   = 10'd10; 
parameter FSM_ST11   = 10'd11; 
parameter FSM_ST12   = 10'd12; 
parameter FSM_ST13   = 10'd13; 
parameter FSM_ST14   = 10'd14; 
parameter FSM_ST15   = 10'd15; 
parameter FSM_ST16   = 10'd16; 
parameter FSM_ST17   = 10'd17; 
parameter FSM_ST18   = 10'd18; 
parameter FSM_ST19   = 10'd19; 
parameter FSM_ST20   = 10'd20; 
parameter FSM_ST21   = 10'd21; 
parameter FSM_ST22   = 10'd22; 
parameter FSM_ST23   = 10'd23; 
parameter FSM_ST24   = 10'd24; 
parameter FSM_ST25   = 10'd25; 
parameter FSM_ST26   = 10'd26; 
parameter FSM_ST27   = 10'd27; 
parameter FSM_ST28   = 10'd28; 
parameter FSM_ST29   = 10'd29; 
parameter FSM_ST30   = 10'd30; 
parameter FSM_ST31   = 10'd31; 
parameter FSM_ST32   = 10'd32; 
parameter FSM_ST33   = 10'd33; 
parameter FSM_ST34   = 10'd34; 
parameter FSM_ST35   = 10'd35; 
parameter FSM_ST36   = 10'd36; 
parameter FSM_ST37   = 10'd37; 
parameter FSM_ST38   = 10'd38; 
parameter FSM_ST39   = 10'd39; 
parameter FSM_ST40   = 10'd40; 

reg [9:0] current_state ;
reg [9:0] next_state   ;

always @(posedge clk or negedge w_rst_n)
begin
    if (~w_rst_n)
        current_state <= FSM_IDLE  ;
    else
        current_state <= next_state;
end

always @ ( * ) 
begin
    case (current_state)
        FSM_IDLE:
            if(r_var_rd_addr >= 16383)
                next_state = FSM_ST01;
        FSM_ST01:
            next_state = FSM_ST02 ;    
        FSM_ST02:                 
            next_state = FSM_ST03 ;          
        FSM_ST03:                 
            next_state = FSM_ST04 ;          
        FSM_ST04:                 
            next_state = FSM_ST05 ;   
        FSM_ST05:                 
            next_state = FSM_ST06 ; 
        FSM_ST06:                 
            next_state = FSM_ST07 ; 
        FSM_ST07:                 
            next_state = FSM_ST08 ; 
        FSM_ST08:                 
            next_state = FSM_ST09 ; 
        FSM_ST09:            
            next_state = FSM_ST10 ; 
        FSM_ST10:                               
            next_state = FSM_ST11 ;                     
        FSM_ST11:                           
            next_state = FSM_ST12 ;         
        FSM_ST12:                           
            next_state = FSM_ST13 ;         
        FSM_ST13:                           
            next_state = FSM_ST14 ;         
        FSM_ST14:                           
            next_state = FSM_ST15 ;         
        FSM_ST15:                           
            next_state = FSM_ST16 ;         
        FSM_ST16:                           
            next_state = FSM_ST17 ;         
        FSM_ST17:                           
            next_state = FSM_ST18 ;         
        FSM_ST18:                           
            next_state = FSM_ST19 ;         
        FSM_ST19:                           
            next_state = FSM_ST20 ;         
        FSM_ST20:                   
            next_state = FSM_ST21 ; 
        FSM_ST21:                   
            next_state = FSM_ST22 ; 
        FSM_ST22:                   
            next_state = FSM_ST23 ; 
        FSM_ST23:                   
            next_state = FSM_ST24 ; 
        FSM_ST24:                   
            next_state = FSM_ST25 ; 
        FSM_ST25:                   
            next_state = FSM_ST26 ; 
        FSM_ST26:                   
            next_state = FSM_ST27 ; 
        FSM_ST27:                   
            next_state = FSM_ST28 ; 
        FSM_ST28:                   
            next_state = FSM_ST29 ; 
        FSM_ST29:                   
            next_state = FSM_ST30 ; 
        FSM_ST30:                             
            next_state = FSM_ST31 ;           
        FSM_ST31:                             
            next_state = FSM_ST32 ;           
        FSM_ST32:                             
            next_state = FSM_ST33 ;           
        FSM_ST33:                             
            next_state = FSM_ST34 ;           
        FSM_ST34:               
            next_state = FSM_ST35 ;
        FSM_ST35:                          
            next_state = FSM_ST36 ;  
        FSM_ST36:                 
            next_state = FSM_ST37 ;          
        FSM_ST37:                 
            next_state = FSM_ST38 ;            
        FSM_ST38:                 
            next_state = FSM_ST39 ;            
        FSM_ST39:         
            next_state = FSM_ST40 ;            
        FSM_ST40:                                                            
            next_state = FSM_IDLE;                         
        default:
            next_state = FSM_IDLE;
    endcase
end

always @ (posedge clk or negedge w_rst_n)
begin
if(~w_rst_n)
    begin
    r_var_wr_wren <= 1'b0         ; 
    r_var_wr_addr <= `O_START_ADDR;   
    r_var_wr_data <= 8'h55        ;    
    r_calc_finish <= 1'b0         ;   
    end
else
    begin
    case(current_state)
        FSM_IDLE:
            begin
            r_var_wr_wren <= 1'b0         ;
            r_var_wr_addr <= `O_START_ADDR;
            r_var_wr_data <= 8'h55        ;
            r_calc_finish <= 1'b0         ;                  
            end     
        FSM_ST01:                  
            begin
            r_var_wr_wren <= 1'b1;
            r_var_wr_addr <= `O_START_ADDR + 2;
            r_var_wr_data <= r_ai_data1[7:0];//ao output
            end
        FSM_ST02:                  
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 3;         
            r_var_wr_data <= r_ai_data1[15:8];//ao output
            end
        FSM_ST03:                 
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 4;         
            r_var_wr_data <= r_ai_data2[7:0];//ao output
            end         
        FSM_ST04:                 
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 5;         
            r_var_wr_data <= r_ai_data2[15:8];//ao output
            end 
        FSM_ST05:                 
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 6;         
            r_var_wr_data <= r_ai_data3[7:0];//ao output
            end   
        FSM_ST06:                 
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 7;         
            r_var_wr_data <= r_ai_data3[15:8];//ao output
            end 
        FSM_ST07:                 
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 8;         
            r_var_wr_data <= r_ai_data4[7:0];//ao output
            end  
        FSM_ST08:                 
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 9;         
            r_var_wr_data <= r_ai_data4[15:8];//ao output
            end 
        FSM_ST09:            
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 10;         
            r_var_wr_data <= r_ai_data5[7:0];//ao output
            end  
        FSM_ST10:                               
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 11;         
            r_var_wr_data <= r_ai_data5[15:8];//ao output
            end                    
        FSM_ST11:                           
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 12;         
            r_var_wr_data <= r_ai_data6[7:0];//ao output
            end        
        FSM_ST12:                           
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 13;         
            r_var_wr_data <= r_ai_data6[15:8];//ao output
            end         
        FSM_ST13:                           
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 14;         
            r_var_wr_data <= r_ai_data7[7:0];//ao output
            end          
        FSM_ST14:                           
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 15;         
            r_var_wr_data <= r_ai_data7[15:8];//ao output
            end        
        FSM_ST15: 
            begin                          
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 16;         
            r_var_wr_data <= r_ai_data8[7:0];//ao output
            end         
        FSM_ST16:                           
            begin
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 17;         
            r_var_wr_data <= r_ai_data8[15:8];//ao output
            end             
        FSM_ST17:     
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 18;         
            r_var_wr_data <= r_di_data1[7:0];//do output
            end        
        FSM_ST18:                           
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 19;         
            r_var_wr_data <= r_di_data2[7:0];//do output
            end         
        FSM_ST19:                           
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 20;         
            r_var_wr_data <= r_di_data3[7:0];//do output
            end      
        FSM_ST20:                   
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 21;         
            r_var_wr_data <= r_di_data4[7:0];//do output
            end  
        FSM_ST21:                   
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 22;         
            r_var_wr_data <= r_di_data5[7:0];//do output
            end  
        FSM_ST22:                   
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 23;         
            r_var_wr_data <= r_di_data6[7:0];//do output
            end  
        FSM_ST23:                   
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 24;         
            r_var_wr_data <= r_di_data7[7:0];//do output
            end  
        FSM_ST24:                   
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 25;         
            r_var_wr_data <= r_di_data8[7:0];//do output
            end  
        FSM_ST25:                   
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 26;         
            r_var_wr_data <= r_di_data9[7:0];//do output
            end  
        FSM_ST26:                   
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 27;         
            r_var_wr_data <= r_di_data10[7:0];//do output
            end  
        FSM_ST27:                   
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 28;         
            r_var_wr_data <= r_di_data11[7:0];//do output
            end  
        FSM_ST28:                   
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 29;         
            r_var_wr_data <= r_di_data12[7:0];//do output
            end  
        FSM_ST29:                   
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 30;         
            r_var_wr_data <= r_di_data13[7:0];//do output
            end  
        FSM_ST30:                             
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 31;         
            r_var_wr_data <= r_di_data14[7:0];//do output
            end            
        FSM_ST31:                             
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 32;         
            r_var_wr_data <= r_di_data15[7:0];//do output
            end           
        FSM_ST32:                             
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 33;         
            r_var_wr_data <= r_di_data16[7:0];//do output
            end            
        FSM_ST33:                             
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 34;         
            r_var_wr_data <= r_cm_cnt1[7:0];//do output
            end   
        FSM_ST34:                             
            begin                      
            r_var_wr_wren <= 1'b1;                      
            r_var_wr_addr <= `O_START_ADDR + 35;         
            r_var_wr_data <= r_cm_cnt2[7:0];//do output
            end                 
        FSM_ST35:                  
            begin
            r_var_wr_wren <= 1'b1;
            r_var_wr_addr <= `V_START_ADDR + 2 ;//timer value
            r_var_wr_data <= r_cm_cnt1         ;
            end
        FSM_ST36:                  
            begin
            r_var_wr_wren <= 1'b1;
            r_var_wr_addr <= `V_START_ADDR + 3 ;//timer value
            r_var_wr_data <= r_cm_cnt2         ;
            end              
        FSM_ST37:                  
            begin 
            r_var_wr_wren  <= 1'b0;	           
            r_sync_wr_wren <= 1'b1;                
            r_sync_wr_addr <= `S_START_ADDR + 2;//sync timer value  
            r_sync_wr_data <= r_cm_cnt1        ;  
            end
        FSM_ST38:                  
            begin
            r_sync_wr_wren <= 1'b0;
            end
        FSM_ST39:       
            begin
            r_calc_finish  <= 1'b1;
            end   
        FSM_ST40:   
            begin
            r_calc_finish  <= 1'b0;
            end           
    endcase
    end
end

always @ (posedge clk or negedge w_rst_n)
begin
    if(~w_rst_n)
        o_heart_beat <= 1'b0;
    else
        if(r_calc_finish)
          o_heart_beat <= ~o_heart_beat;
end   

assign test = 32'b0;

endmodule










