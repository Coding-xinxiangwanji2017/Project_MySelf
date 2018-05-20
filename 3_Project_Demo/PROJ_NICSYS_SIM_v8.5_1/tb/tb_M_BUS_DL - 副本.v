/*=======================================================================================*\
--  Copyright (c)2015 CNCS Incorporated
\*=======================================================================================*\
  All Rights Reserved
  THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of CNCS Inc.

  The copyright notice above does not evidence any actual or intended publication of
  such source code. No part of this code may be reproduced, stored in a retrieval
  system, or transmitted, in any form or by any means, electronic, mechanical,
  photocopying, recording, or otherwise, without the prior written permission of CNCS.

/*=======================================================================================*\
--  RTL File Attribute
\*=======================================================================================*\
  -- Project     : NicSys8000N
  -- Simulator   : Modelsim 10.2         Windows-7 64bit
  -- Synthesizer : LiberoSoC v11.5 SP2   Windows-7 64bit
  -- FPGA Type   : Microsemi  M2GL050-FGG484

  -- Module Funcion : M_NET top file
  -- Initial Author : Tan Xingye


  -- Modification Logs:
     --------------------------------------------------------------------------------
       Version      Date            Description(Recorder)
     --------------------------------------------------------------------------------
         1.0     2016/04/12     Initial version(Tan Xingye)




/*=======================================================================================*/


`timescale 1ns / 100ps

module tb_M_BUS_DL(
    //-- reset
    input rst,
    //-- Clocks
    input sys_clk,   //- 50M
    input clk_phy_p0,
    input clk_phy_p90,
    input clk_phy_p180,
    input clk_phy_p270,

    //-- PHY interface
    input lb_rxd,
    output lb_txd,
    output lb_txen
    );



   //=========================================================
   // Local parameters
   //=========================================================
   parameter DLY       = 1;


   //=========================================================
   // Internal signal definition
   //=========================================================
   reg          tx_buf_wren;
   reg   [10:0] tx_buf_waddr;
   reg   [7:0]  tx_buf_wdata;
   reg   [10:0] tx_data_len;
   reg          tx_start;

   wire          rx_buf_rden;
   wire  [10:0]  rx_buf_raddr;
   wire   [7:0]  rx_buf_rdata;
   wire          o_rx_start;
   wire          o_rx_done;
   wire   [1:0]  o_rx_crc_rslt;

   wire          Rclk;

   wire          clk;


   //=========================================================
   //
   //=========================================================
   assign rst_n        = ~rst;
   assign Rclk       = clk_phy_p0;

   assign clk        = sys_clk;



   //=========================================================
   // Component Declarations
   //=========================================================

link u1_link(
//input
  .Rclk            (Rclk        ),  //- PHY 12.5
  .rst             (rst         ),
  .tx_buf_wren     (tx_buf_wren ),
  .tx_buf_waddr    (tx_buf_waddr),
  .tx_buf_wdata    (tx_buf_wdata),
  .tx_data_len     (tx_data_len ),
  .tx_start        (tx_start    ),

  .sys_clk         (sys_clk     ),//- 50M
  .clk_phy_p0      (clk_phy_p0  ),
  .clk_phy_p90     (clk_phy_p90 ),
  .clk_phy_p180    (clk_phy_p180),
  .clk_phy_p270    (clk_phy_p270),

  .rx_buf_rden     (1'b0    ),
  .rx_buf_raddr    (11'd0   ),
  .rx_buf_rdata    (rx_buf_rdata   ),
  .o_rx_start      (o_rx_start     ),
  .o_rx_done       (o_rx_done      ),
  .o_rx_crc_rslt   (o_rx_crc_rslt  ),

   //-- phy interface
  .lb_rxd          (lb_rxd ),
  .lb_txd          (lb_txd ),
  .lb_txen         (lb_txen)


);




















   //********************************************************************************
   //   M-BUS file opertion
   //********************************************************************************


//**************************************************************
//  Task :
//      cmd_a501
//**************************************************************


task FLASH_Data_DL;
  input   integer                  frame_len;
  input   integer                  frame_num;
  integer                   j;
  integer                   k;  

  integer                   file_rd_id0;
  integer                   file_wr_id0;
  integer                   code_1;

  //reg      [20*8-1: 0]      file_data1;
  reg        [7:0]           file_data2;
  integer                   Cond;


  reg      [7: 0]          data_byte;


  begin
       //-- length of frame
       //a501_length    = 128;

//       file_rd_id0    = $fopen("./simulation_mb_data/data/np811_flash_data.txt", "r");
              file_rd_id0    = $fopen("./simulation_mb_data/data/do811_28_e2prom.txt", "r");

       if(file_rd_id0==0)
         begin
           $display(" Open file %s  Error!!!", "np811_flash_data.txt");
         end
       else
         begin
           $display(" Open file %s  Successful!!!", "np811_flash_data.txt");
         end



        tx_buf_wren <= 0;
        tx_buf_waddr <=0;
        tx_buf_wdata <=0;
        tx_data_len <= 138;
//        tx_data_len <= 138+4;
        tx_start  <= 0;



       code_1      = 0;
       Cond        = 1;
       while( Cond == 1 )
       begin : wait_reset
         @( posedge clk );
         if ( rst == 0 )
         begin
           Cond = 0;
         end

       end  //-- end while

       for (j=0;j<frame_num;j=j+1)
       begin
         tx_start  <= 0;
         @( posedge clk );
         @( posedge clk );
         @( posedge clk );

         for (k=0;k<frame_len;k=k+1)
         begin

             @( posedge clk );
             code_1 = $fscanf(file_rd_id0, "%h\n", file_data2);
             data_byte    <=  file_data2;

             tx_buf_wren   <= 1;
             tx_buf_waddr  <= k;
             tx_buf_wdata  <= file_data2;
         end

         @( posedge clk );
             tx_buf_wren   <= 0;
             tx_buf_waddr  <= 0;
             tx_buf_wdata  <= 0;

         @( posedge clk );
         @( posedge clk );
         tx_start  = 1;
         @( posedge clk );
         tx_start  = 0;
                    
         //-- wait, phy tx by serial
         for (k=0;k<frame_len*9*8/2+150;k=k+1)
         begin
             @( posedge clk );
         end

       end  //-- end for
  end // begin
endtask





task FRAM_Data_DL;
  input   integer                  frame_len;
  input   integer                  frame_num;
  integer                   j;

  integer                   file_rd_id0;
  integer                   file_wr_id0;
  integer                   code_1;

  //reg      [20*8-1: 0]      file_data1;
  reg        [7:0]           file_data2;
  integer                   Cond;
  integer                   k;

  reg      [7: 0]          data_byte;


  begin
       //-- length of frame
       //a501_length    = 128;

       file_rd_id0    = $fopen("./simulation_mb_data/data/np811_fram_data.txt", "r");

       if(file_rd_id0==0)
         begin
           $display(" Open file %s  Error!!!", "np811_fram_data.txt");
         end
       else
         begin
           $display(" Open file %s  Successful!!!", "np811_fram_data.txt");
         end



        tx_buf_wren <= 0;
        tx_buf_waddr <=0;
        tx_buf_wdata <=0;
        tx_data_len <= 138;        
//        tx_data_len <= 138+4;
        tx_start  <= 0;



       code_1      = 0;
       Cond        = 1;
       while( Cond == 1 )
       begin : wait_reset
         @( posedge clk );
         if ( rst == 0 )
         begin
           Cond = 0;
         end

       end  //-- end while



       for (j=0;j<frame_num;j=j+1)
       begin

         tx_start  <= 0;
         @( posedge clk );
         @( posedge clk );
         @( posedge clk );

         for (k=0;k<frame_len;k=k+1)
         begin

             @( posedge clk );
             code_1 = $fscanf(file_rd_id0, "%h\n", file_data2);
             data_byte    <=  file_data2;

             tx_buf_wren   <= 1;
             tx_buf_waddr  <= k;
             tx_buf_wdata  <= file_data2;
         end


         @( posedge clk );
             tx_buf_wren   <= 0;
             tx_buf_waddr  <= 0;
             tx_buf_wdata  <= 0;

          
         @( posedge clk );
         @( posedge clk );
         tx_start  = 1;
         @( posedge clk );
         tx_start  = 0;
          
          
          
          
          
         //-- wait, phy tx by serial
         for (k=0;k<frame_len*4*8/2+150;k=k+1)
         begin
             @( posedge clk );
         end

       end  //-- end for
  end // begin
endtask


task Console_Data_Force;
  input   integer                  frame_len;
  input   integer                  frame_num;
  integer                   j;

  integer                   file_rd_id0;
  integer                   file_wr_id0;
  integer                   code_1;

  //reg      [20*8-1: 0]      file_data1;
  reg        [7:0]           file_data2;
  integer                   Cond;
  integer                   k;

  reg      [7: 0]          data_byte;


  begin
       //-- length of frame
       //a501_length    = 128;

//       file_rd_id0    = $fopen("./simulation_mb_data/data/np811_console_data_force.txt", "r");
              file_rd_id0    = $fopen("./simulation_mb_data/data/do811_28_force.txt", "r");

       if(file_rd_id0==0)
         begin
           $display(" Open file %s  Error!!!", "np811_console_data.txt");
         end
       else
         begin
           $display(" Open file %s  Successful!!!", "np811_console_data.txt");
         end

       tx_buf_wren <= 0;
       tx_buf_waddr <=0;
       tx_buf_wdata <=0;
//       tx_data_len <= 138+4;       
       tx_data_len <= 138;
       tx_start  <= 0;


       code_1      = 0;
       Cond        = 1;
       while( Cond == 1 )
       begin : wait_reset
         @( posedge clk );
         if ( rst == 0 )
         begin
           Cond = 0;
         end

       end  //-- end while



       for (j=0;j<frame_num;j=j+1)
       begin

         tx_start  <= 0;
         @( posedge clk );
         @( posedge clk );
         @( posedge clk );

         for (k=0;k<frame_len;k=k+1)
         begin

             @( posedge clk );
             code_1 = $fscanf(file_rd_id0, "%h\n", file_data2);
             data_byte    <=  file_data2;

             tx_buf_wren   <= 1;
             tx_buf_waddr  <= k;
             tx_buf_wdata  <= file_data2;
         end


         @( posedge clk );
             tx_buf_wren   <= 0;
             tx_buf_waddr  <= 0;
             tx_buf_wdata  <= 0;

          
         @( posedge clk );
         @( posedge clk );
         tx_start  = 1;
         @( posedge clk );
         tx_start  = 0;
          
          
          
          
          
         //-- wait, phy tx by serial
         for (k=0;k<frame_len*3*8/2+150;k=k+1)
         begin
             @( posedge clk );
         end

       end  //-- end for
  end // begin
endtask


task Console_Data_Req;
  input   integer                  frame_len;
  input   integer                  frame_num;
  integer                   j;

  integer                   file_rd_id0;
  integer                   file_wr_id0;
  integer                   code_1;

  //reg      [20*8-1: 0]      file_data1;
  reg        [7:0]           file_data2;
  integer                   Cond;
  integer                   k;

  reg      [7: 0]          data_byte;


  begin
       //-- length of frame
       //a501_length    = 128;

       file_rd_id0    = $fopen("./simulation_mb_data/data/np811_console_data_req.txt", "r");

       if(file_rd_id0==0)
         begin
           $display(" Open file %s  Error!!!", "np811_console_data_req.txt");
         end
       else
         begin
           $display(" Open file %s  Successful!!!", "np811_console_data_req.txt");
         end

       tx_buf_wren <= 0;
       tx_buf_waddr <=0;
       tx_buf_wdata <=0;
       tx_data_len <= frame_len;
       tx_start  <= 0;


       code_1      = 0;
       Cond        = 1;
       while( Cond == 1 )
       begin : wait_reset
         @( posedge clk );
         if ( rst == 0 )
         begin
           Cond = 0;
         end

       end  //-- end while



       for (j=0;j<frame_num;j=j+1)
       begin

         tx_start  <= 0;
         @( posedge clk );
         @( posedge clk );
         @( posedge clk );

         for (k=0;k<frame_len;k=k+1)
         begin

             @( posedge clk );
             code_1 = $fscanf(file_rd_id0, "%h\n", file_data2);
             data_byte    <=  file_data2;

             tx_buf_wren   <= 1;
             tx_buf_waddr  <= k;
             tx_buf_wdata  <= file_data2;
         end


         @( posedge clk );
             tx_buf_wren   <= 0;
             tx_buf_waddr  <= 0;
             tx_buf_wdata  <= 0;

          
         @( posedge clk );
         @( posedge clk );
         tx_start  = 1;
         @( posedge clk );
         tx_start  = 0;
          
          
          
          
          
         //-- wait, phy tx by serial
         for (k=0;k<frame_len*3*8/2+150;k=k+1)
         begin
             @( posedge clk );
         end
       end  //-- end for
  end // begin
endtask



task Console_Data_Save;
  input   integer                  frame_len;
  input   integer                  frame_num;
  integer                   j;

  integer                   file_rd_id0;
  integer                   file_wr_id0;
  integer                   code_1;

  //reg      [20*8-1: 0]      file_data1;
  reg        [7:0]           file_data2;
  integer                   Cond;
  integer                   k;

  reg      [7: 0]          data_byte;


  begin
       //-- length of frame
       //a501_length    = 128;

       file_rd_id0    = $fopen("./simulation_mb_data/data/np811_console_data_save.txt", "r");

       if(file_rd_id0==0)
         begin
           $display(" Open file %s  Error!!!", "np811_console_data_save.txt");
         end
       else
         begin
           $display(" Open file %s  Successful!!!", "np811_console_data_save.txt");
         end

       tx_buf_wren <= 0;
       tx_buf_waddr <=0;
       tx_buf_wdata <=0;
       tx_data_len <= 138;       
//       tx_data_len <= 138+4;
       tx_start  <= 0;


       code_1      = 0;
       Cond        = 1;
       while( Cond == 1 )
       begin : wait_reset
         @( posedge clk );
         if ( rst == 0 )
         begin
           Cond = 0;
         end

       end  //-- end while


       for (j=0;j<frame_num;j=j+1)
       begin

         tx_start  <= 0;
         @( posedge clk );
         @( posedge clk );
         @( posedge clk );

         for (k=0;k<frame_len;k=k+1)
         begin

             @( posedge clk );
             code_1 = $fscanf(file_rd_id0, "%h\n", file_data2);
             data_byte    <=  file_data2;

             tx_buf_wren   <= 1;
             tx_buf_waddr  <= k;
             tx_buf_wdata  <= file_data2;
         end


         @( posedge clk );
             tx_buf_wren   <= 0;
             tx_buf_waddr  <= 0;
             tx_buf_wdata  <= 0;

          
         @( posedge clk );
         @( posedge clk );
         tx_start  = 1;
         @( posedge clk );
         tx_start  = 0;
            
         //-- wait, phy tx by serial
         for (k=0;k<frame_len*3*8/2+150;k=k+1)
         begin
             @( posedge clk );
         end

       end  //-- end for
  end // begin
endtask


task Console_Data_Wreonce;
  input   integer                  frame_len;
  input   integer                  frame_num;
  integer                   j;

  integer                   file_rd_id0;
  integer                   file_wr_id0;
  integer                   code_1;

  //reg      [20*8-1: 0]      file_data1;
  reg        [7:0]           file_data2;
  integer                   Cond;
  integer                   k;

  reg      [7: 0]          data_byte;


  begin
       //-- length of frame
       //a501_length    = 128;

       file_rd_id0    = $fopen("./simulation_mb_data/data/np811_console_data_wreonce.txt", "r");

       if(file_rd_id0==0)
         begin
           $display(" Open file %s  Error!!!", "np811_console_data_wreonce.txt");
         end
       else
         begin
           $display(" Open file %s  Successful!!!", "np811_console_data_wreonce.txt");
         end

       tx_buf_wren <= 0;
       tx_buf_waddr <=0;
       tx_buf_wdata <=0;
       tx_data_len <= 138;
//       tx_data_len <= 138+4;
       tx_start  <= 0;


       code_1      = 0;
       Cond        = 1;
       while( Cond == 1 )
       begin : wait_reset
         @( posedge clk );
         if ( rst == 0 )
         begin
           Cond = 0;
         end

       end  //-- end while



       for (j=0;j<frame_num;j=j+1)
       begin

         tx_start  <= 0;
         @( posedge clk );
         @( posedge clk );
         @( posedge clk );

         for (k=0;k<frame_len;k=k+1)
         begin

             @( posedge clk );
             code_1 = $fscanf(file_rd_id0, "%h\n", file_data2);
             data_byte    <=  file_data2;

             tx_buf_wren   <= 1;
             tx_buf_waddr  <= k;
             tx_buf_wdata  <= file_data2;
         end


         @( posedge clk );
             tx_buf_wren   <= 0;
             tx_buf_waddr  <= 0;
             tx_buf_wdata  <= 0;

          
         @( posedge clk );
         @( posedge clk );
         tx_start  = 1;
         @( posedge clk );
         tx_start  = 0;
            
         //-- wait, phy tx by serial
         for (k=0;k<frame_len*3*8/2+150;k=k+1)
         begin
             @( posedge clk );
         end

       end  //-- end for
  end // begin
endtask






//**************************************************************
//  Main process
//
//**************************************************************






initial
  begin

   //--  initial  interface singals
        tx_buf_wren   = 0;
        tx_buf_waddr  =0;
        tx_buf_wdata  =0;
        tx_data_len   = 138;        
//        tx_data_len   = 138+4;
        tx_start      = 0;

   
   # 45000;

   //-----------------------------------------------
   //--  A501 simulation£º
   //-----------------------------------------------
   FLASH_Data_DL(138,1); 
//   FRAM_Data_DL(138,1);
//   Console_Data_Req(138,2);
  Console_Data_Force(138,2);   
//   Console_Data_Wreonce(138,1);   



   



  end  // initial


















endmodule
