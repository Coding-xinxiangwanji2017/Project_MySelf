//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c)2015 CNCS Incorporated                                             //
// All Rights Reserved                                                            //
// THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of CNCS Inc.               //
// The copyright notice above does not evidence any actual or intended                     //
// publication of such source code.                                                  //
// No part of this code may be reproduced, stored in a retrieval system,                     //
// or transmitted, in any form or by any means, electronic, mechanical,                     //
// photocopying, recording, or otherwise, without the prior written                        //
// permission of CNCS                                                           //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name of module :crc16_tb                                                       //
// Project    : NicSys8000N                                                     //
// Func       : crc_tb                                          //
// Author     : ***                                                       //
// Simulator   : ModelsimMicrosemi 10.3c / Windows 7 32bit                          //
// Synthesizer  : LiberoSoC v11.5 SP2 / Windows 7 32bit                              //
// FPGA/CPLD type : M2GL050-1FG484                                           //
// version 1.0  : made in Date: 2015.12.01                                          //
// Update: 1.1  : made in Date£º2015.12.10                                         //
// Purpose      : add the logic of redundancy                                         //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 100ps

module m_net_tb();
wire         o_tx_en              ; 
wire [1:0]   om_tx_data           ; 
wire          i_rxdv               ; 
wire  [1:0]   im_rxdata            ;
assign  i_rxdv    = o_tx_en     ;
assign  im_rxdata = om_tx_data  ;
//////////////////////////////
parameter    CYCLE                  = 20;//50Mhz
parameter    im_source_addr         = 48'hFFFFFFFFFF01;
parameter    im_destin_addr         = 48'hFFFFFFFFFF02;
parameter    rx_destin_addr         = 48'h02FFFFFFFFFF;
parameter    MEM_LENGTH             = 100000;
parameter    BOARD_NUM              = 8;
parameter    ERR_LIMIT              = 10;
///////////////////////////////////// read from file
reg   [23:0] down_message_num[BOARD_NUM-1:0];
reg   [7:0]  down_LA[BOARD_NUM-1:0]      ;
reg   [7:0]  down_data[MEM_LENGTH-1:0]   ;

reg   [7:0]  r_board_type[BOARD_NUM-1:0] ;
reg   [23:0] send_err_cnt                ;      
reg   [23:0] time_out_cnt                ;
////////////////////////////////////  
integer      i                     ;
integer      j                     ;
integer      k                     ;
integer      l                     ;
integer      down_byte_cnt         ;
///////////////////////////////////////
wire [15:0]  im_type_code          ;
wire [15:0]  im_frame_data_length  ;
wire         o_ram_rden            ; 
wire [7:0]   om_ram_raddr          ; 
wire [7:0]   im_ram_rdata          ; 

reg          i_rst_n               ;  
reg          i_sclk50              ;  
 
////////////////////
 
//////////////////////
wire               o_wren          ; 
wire      [10:0]   o_wraddr        ; 
wire      [7:0]    o_wrdata        ; 
wire               o_data_ready    ; 
/////////////////////////
reg  [7:0]   r_tx_LA               ;
reg  [7:0]   r_tx_MODE             ;
reg  [7:0]   r_tx_CMD              ;
reg  [7:0]   r_tx_SN               ;
reg  [23:0]  r_tx_ADDR             ;   
reg  [7:0]   r_tx_TYPE             ; 
reg  [7:0]   data_tx_128B[127:0]   ;  
reg          i_start               ; 
reg          wren                  ;
reg  [7:0]   waddr                 ;
reg  [7:0]   wdata                 ;
////////////////////////////////////
reg  [7:0]   r_rx_LA               ;
reg  [7:0]   r_rx_MODE             ;
reg  [7:0]   r_rx_CMD              ;
reg  [7:0]   r_rx_SN               ;
reg  [23:0]  r_rx_ADDR             ;
reg  [7:0]   r_rx_TYPE             ;
reg  [7:0]   data_rx_128B[127:0]   ;


//////////////////////////////

always #(CYCLE/2)   i_sclk50               = ~i_sclk50        ;
assign              im_type_code           = {8'd138,8'd0}    ;
assign              im_frame_data_length   = {r_tx_LA,8'd0}   ;
integer fid_data;                         
initial                                   
begin                                     
    fid_data = $fopen("receive_data.txt","w");  
end                                       

initial begin
	i_rst_n          = 0;
	i_sclk50         = 0;
	#(100*CYCLE+CYCLE/2) 
	i_rst_n          = 1;
end
initial begin
   r_tx_LA      = 0;           
   r_tx_MODE    = 0;           
   r_tx_CMD     = 0;           
   r_tx_SN      = 0;           
   r_tx_ADDR    = 0;           
   r_tx_TYPE    = 0;
   i_start      = 0;           
   wren         = 0;           
   waddr        = 0;           
   wdata        = 0;
   down_byte_cnt= 0;
   send_err_cnt = 0; 
   time_out_cnt = 0;
 for (j=0;j<128;j=j+1)begin          
   data_tx_128B[j] = 0; 
 end
   #(1000*CYCLE)
  for(i=0;i<BOARD_NUM-1;i=i+1)begin
  	for(j=0;j<down_message_num[i];j=j+1)begin
  //	for(i=0;i<5-1;i=i+1)begin
  	//for(j=0;j<3;j=j+1)begin
  		r_tx_LA      = down_LA[i];           
      r_tx_MODE    = 'h02;           
      r_tx_CMD     = 'h01;           
      r_tx_SN      = r_tx_SN + 'h01;           
      r_tx_ADDR    = 128*j;           
      r_tx_TYPE    = r_board_type[i];
  		//for(k=0;k<128;k=k+1)begin
  			
  	 //    data_tx_128B[k] = $random;
  	//	end  
  		$readmemh("sen_data.txt",data_tx_128B,down_byte_cnt,down_byte_cnt+127);
  		    while(send_err_cnt <= ERR_LIMIT)begin
  		         package_m_net_data;
  		         while(!((o_data_ready)|(time_out_cnt >= 10000)))begin
  		         	@(posedge i_sclk50)
  		         	 time_out_cnt = time_out_cnt + 1;
  		         end
  		         if(time_out_cnt >= 10000)begin
  		            time_out_cnt = 0;
  		            send_err_cnt = send_err_cnt + 1;
  		          end
  		         else begin
  		           if((r_tx_LA == r_rx_LA)&(r_tx_SN == r_rx_SN)&(r_tx_ADDR == r_rx_ADDR)
  		            &(r_tx_ADDR == r_rx_ADDR)&(r_tx_TYPE == r_rx_TYPE))begin
  		            $fwrite(fid_data,"%p\n",data_rx_128B);
  		            send_err_cnt = ERR_LIMIT + 1;
		            end
  		           else
  		            send_err_cnt = send_err_cnt + 1;
  		          end
  		    end
  		send_err_cnt = 0;   
  		time_out_cnt = 0;
  		down_byte_cnt= down_byte_cnt + 128 ;
  end
 end                
end

mii_mac_tx       U1 (
                   .i_rst_n               (i_rst_n             ),    //systerm reset  
                   .i_sclk50              (i_sclk50            ),    //systerm clk 80M         
		               .i_start               (i_start             ),			
                   .im_source_addr        (im_source_addr      ),		//Source Address
                   .im_destin_addr        (im_destin_addr      ),		//Destination Address
                   .im_type_code          (im_type_code        ),
                   .im_frame_data_length  (im_frame_data_length),
                   .o_ram_rden            (o_ram_rden          ),
                   .om_ram_raddr          (om_ram_raddr        ),
                   .im_ram_rdata          (im_ram_rdata        ),                       
                   .o_tx_en               (o_tx_en             ),        
                   .om_tx_data            (om_tx_data          )
		               );
swsr_128x8_dpram U2(
                    .clk                  (i_sclk50            ),
                    .wren                 (wren                ),
                    .waddr                (waddr               ),
                    .wdata                (wdata               ),
                    .rden                 (o_ram_rden          ),
                    .raddr                (om_ram_raddr        ),
                    .rdata                (im_ram_rdata        )
                    );           
mii_mac_rx     U3(
                    .i_clk         (i_sclk50      ),
                    .i_rstn        (i_rst_n       ),  
                    .i_rxdv        (i_rxdv        ),
                    .im_rxdata     (im_rxdata     ),   
                    .w_dmac_addr   (rx_destin_addr),
                    .o_wren        (o_wren        ),      
                    .o_wraddr      (o_wraddr      ),
                    .o_wrdata      (o_wrdata      ),
                    .o_data_ready  (o_data_ready  )    
                 );                    
task  package_m_net_data;
  begin
   wren    = 0;
   i_start = 0;
   # CYCLE
  for(l =0; l <= 137; l = l + 1)begin
	 @(posedge i_sclk50)begin
		wren <= 1;
		waddr<= l;
		if(l==0)
		 wdata<=r_tx_LA;
		else if(l==1)
		wdata <= 8'h00;   
		else if(l==2) 
		wdata <= 8'h00;
		else if(l==3)
		wdata <= r_tx_MODE;
		else if(l==4)  
		wdata <= r_tx_CMD;
		else if(l==5)
		wdata <= r_tx_SN;
		else if(l==6)
		wdata <= r_tx_ADDR[23:16];
		else if(l==7)
		wdata <= r_tx_ADDR[15:8];
		else if(l==8)
		wdata <= r_tx_ADDR[7:0];
		else if(l==9) 
		wdata <= r_tx_TYPE;
		else 
		wdata <= data_tx_128B[l-10];	
 end
end	   
     # CYCLE
     wren    = 0;
     i_start = 1; 
     # CYCLE
     i_start = 0;
   end
endtask 

always @ (posedge i_sclk50)begin
	if(o_wren)begin
		case(o_wraddr)
		'h00:r_rx_LA         <=o_wrdata;
		'h01:;
		'h02:;
		'h03:r_rx_MODE       <=o_wrdata;
		'h04:r_rx_CMD        <=o_wrdata;
		'h05:r_rx_SN         <=o_wrdata;
		'h06:r_rx_ADDR[23:16]<=o_wrdata;
		'h07:r_rx_ADDR[15:8] <=o_wrdata;
		'h08:r_rx_ADDR[7:0]  <=o_wrdata;
		'h09:r_rx_TYPE       <=o_wrdata;
		default: data_rx_128B [o_wraddr - 'hA]<=o_wrdata;
	endcase
end
end   
endmodule
