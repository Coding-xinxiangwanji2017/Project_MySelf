`timescale 1ns / 1ps

/* This model is the property of Cypress Semiconductor Corp.
-- and is protected by the US copyright laws, any unauthorized
-- copying and distribution is prohibited.
-- Cypress reserves the right to change any of the functional 
-- specifications without any prior notice.
-- Cypress is not liable for any damages which may result from
-- the use of this functional model
----------------------------------------------------------------------
-- File name : FM28V102A_tb.v
----------------------------------------------------------------------
-- Functionality : Test Bench for Verilog behavourial Model of FM28V102A 
-- Source:  CYPRESS Data Sheet : "FM28V102A 1Mbit F-RAM Memory" 
--                 
-- Version:  1.0 June 16, 2014
-----------------------------------------------------------------------
-- Developed by CYPRESS SEMICONDUCTOR
--
-- version |     author       | mod date | changes made
--    1.0         GVCH          06/16/14    New Model
------------------------------------------------------------------------
-- PART DESCRIPTION :
-- Part:        FM28V102A
--
-- Descripton:  Verilog behavourial Model Test Bench for  FM28V102A
------------------------------------------------------------------------
-- NOTE:
-- The test bench checks design rules and throws error messages at certain instances. 
-- Ignore the first WARNING (WARNING: /CE LOW violation during WRITE!!). 
-- Test Bench starts after the message "Test Bench Simulation Starting...".
-- Test Bench should be run for 80us to cover all test cases.
------------------------------------------------------------------------*/  
`include "config.v"


module FM28V102A_tb_v;

    // Inputs
    reg [15:0] addr;
    reg ce_ = 1'b1;
    reg we_ = 1'b1;
    reg oe_ = 1'b1;
    reg ub_ = 1'b1;
    reg lb_ = 1'b1;
    
    reg [7:0] d_00;
    reg [7:0] d_01;
    reg [7:0] d_02;
    reg [7:0] d_03;
    reg [7:0] d_04;
    reg [7:0] d_05;
    reg [7:0] d_06;
    reg [7:0] d_07;
    reg [7:0] d_08;    

    // Bidirs
    wire [15:0] dq;
    reg  [15:0] dq_reg;
    reg  [15:0] dq_data;

    // Instantiate the Unit Under Test (UUT)
    FM28V102A uut (
        .dq(dq), 
        .addr(addr), 
        .ce_(ce_), 
        .we_(we_), 
        .oe_(oe_), 
        .ub_(ub_), 
        .lb_(lb_)
    );

   assign dq = dq_reg;

    initial begin
        // Initialize Inputs
        addr = 0;
        ce_ = 1'b1;
        we_ = 1'b1;
        oe_ = 1'b1;
        ub_ = 1'b1;
        lb_ = 1'b1;
        dq_reg[15:0] <= 'hz;            

        // Wait 100 ns for global reset to finish
        #200;

        $display("\n\n*********************************");        
        $display("Test Bench Simulation Starting...");
        $display("*********************************\n");                

//**********************************
//      /WE Controlled Write
//**********************************        
        $display("\n\n*********************************");                        
        $display("Test case 1: /WE write Addr = 'hFF00  Data = 'h1234");
        $display("*********************************\n");                        
        addr = 'hFF00;
        dq_reg[15:0] = 'h1234;
        #`tAS;
        ce_ = 1'b0;
        ub_ = 1'b0;
        lb_ = 1'b0;     
        #`Tce;
        we_ = 1'b0;
        #`tWZ;
        #`tWZ;
        #(`tDS+`tDH);
        we_ = 1'b1;
        #100;
        ce_ = 1'b1;
        ub_ = 1'b1;
        lb_ = 1'b1;             
        
        #500;

//**********************************
//      /CE Controlled Write
//**********************************   
        $display("\n\n*********************************");                        
        $display("Test case 2: /CE write Addr = 'h0000  Data = 'haa55");
        $display("*********************************\n");                                
        addr = 'h0000;
        dq_reg[15:0] = 'haa55;      
        #`tAS;
        we_ = 1'b0;
        ub_ = 1'b0;
        lb_ = 1'b0;     
        ce_ = 1'b0;
        #100;
        #(`tDS+`tDH);
        ce_ = 1'b1;
        #100;
        we_ = 1'b1;
        ub_ = 1'b1;
        lb_ = 1'b1;             
        
        #500;

//**********************************
//      PAGE MODE WRITE
//**********************************
        $display("\n\n*********************************");                        
        $display("Test case 3: PAGE MODE Write Addr = 'hFF02  Data = 'h9999 \n Addr = 'hFF03  Data = 'h5678");
        $display("*********************************\n");                                        
        addr = 'hFF02;
        dq_reg[15:0] <= 'h9999;     
        #`tAS;
        ce_ = 1'b0;
        ub_ = 1'b0;
        lb_ = 1'b0;             
        #`Tce;
        we_ = 1'b0;
        #`tWZ;
        #`tWZ;
        #(`tDS+`tDH);
        we_ = 1'b1;
        #100;
        ub_ = 1'b1;
        lb_ = 1'b1;        
        
        addr = 'hFF03;
        dq_reg[15:0] <= 'h5678;     
        #`tAS;
        ce_ = 1'b0;
        ub_ = 1'b0;
        lb_ = 1'b0;             
        #`Tce;
        we_ = 1'b0;
        #`tWZ;
        #`tWZ;
        #(`tDS+`tDH);
        we_ = 1'b1;
        #100;
        ce_ = 1'b1;
        ub_ = 1'b1;
        lb_ = 1'b1;             

        #500;

//**********************************
//      /OE READ
//**********************************
        $display("\n\n*********************************");                        
        $display("Test case 4: /OE Read Addr = 'hFF02  Expected Data = 'h9999");
        $display("*********************************\n");                                        
        
        dq_reg[15:0] <= 'hz;        
        addr = 'hFF02;
        #`tAS;
        ce_ = 1'b0;
        #100;
        ub_ = 1'b0;
        lb_ = 1'b0;
        #10;
        oe_ = 1'b0;
        #`Toe;
        #2;
        $display("F-RAM Read: Addr - %h, Data - %h", addr, dq[15:0]);
        #200;
        oe_ = 1'b1;
        ce_ = 1'b1;
        
        #500;
//**********************************
//      /CE READ
//**********************************
        $display("\n\n*********************************");                        
        $display("Test case 5: /CE Read Addr = 'h0000  Expected Data = 'haa55");
        $display("*********************************\n");                                        
        dq_reg[15:0] <= 'hz;        
        addr = 'h0000;
        #`tAS;
        oe_ = 1'b0;
        #100;
        ub_ = 1'b0;
        lb_ = 1'b0;
        #10;
        ce_ = 1'b0;
        #`Tce;
        #2;        
        $display("F-RAM Read: Addr - %h, Data - %h", addr, dq[15:0]);        
        #200;      
        oe_ = 1'b1;
        ce_ = 1'b1;
        
        #500

//**********************************
//      PAGE MODE READ CYCLE
//**********************************
        $display("\n\n*********************************");                        
        $display("Test case 6: PAGE Mode Read Addr = 'hFF00  Expected Data = 'h1234 \n Addr = 'hFF02  Expected Data = 'h9999 \n Addr = 'hFF03  Expected Data = 'h5678");
        $display("*********************************\n");                                        
        dq_reg[15:0] <= 'hz;        
        addr = 'hFF00;
        #`tAS;
        ce_ = 1'b0;
        #100;
        ub_ = 1'b0;
        lb_ = 1'b0;
        #10;
        oe_ = 1'b0;
        #`Toe;
        #2;        
        $display("F-RAM Read: Addr - %h, Data - %h", addr, dq[15:0]);                
        #200;
        addr = 'hFF02;
        #`Taap;
        #2;
        $display("F-RAM Read: Addr - %h, Data - %h", addr, dq[15:0]);        
        #200;        
        addr = 'hFF03;        
        #`Taap;
        #2;        
        $display("F-RAM Read: Addr - %h, Data - %h", addr, dq[15:0]);                
        #200;        
        addr = 'h0000;        
        #200;                
        oe_ = 1'b1;
        ce_ = 1'b1;

        #200;
//**********************************
//      RANDOM MODE READ CYCLE
//**********************************
        $display("\n\n*********************************");                        
        $display("Test case 7: Random Mode Read Addr = 'hFF00  Expected Data = 'h1234 \n Addr = 'h0000  Expected Data = 'haa55 \n Addr = 'hFF03  Expected Data = 'h5678");
        $display("*********************************\n");                                
        dq_reg[15:0] <= 'hz;        
        addr = 'hFF00;
        #`tAS;
        ce_ = 1'b0;
        #100;
        ub_ = 1'b0;
        lb_ = 1'b0;
        #10;
        oe_ = 1'b0;
        #`Toe;
        #2;        
        $display("F-RAM Read: Addr - %h, Data - %h", addr, dq[15:0]);                
        #200;
        addr = 'h0000;
        #`Trc;
        #2;        
        $display("F-RAM Read: Addr - %h, Data - %h", addr, dq[15:0]);        
        #200;        
        addr = 'hFF03;        
        #`Trc;
        #2;        
        $display("F-RAM Read: Addr - %h, Data - %h", addr, dq[15:0]);                
        #200;                
        oe_ = 1'b1;
        ce_ = 1'b1;    
        
        #200;
//*******************************************
//   Write data to 9 continuous locations
//*******************************************
    FRAM_write_we('h0000, 'h01);
    FRAM_write_we('h0001, 'h02);
    FRAM_write_we('h0002, 'h03);
    FRAM_write_we('h0003, 'h04);
    FRAM_write_we('h0004, 'h05);
    FRAM_write_we('h0005, 'h06);
    FRAM_write_we('h0006, 'h07);
    FRAM_write_we('h0007, 'h08);
    FRAM_write_we('h0008, 'h09);

//*******************************************
//   /OE Read from 9 continuous locations
//*******************************************
    FRAM_read_oe('h0000, d_00);
    $display("F-RAM /OE Read: 'h0000, Data - %h", d_00);
    
    FRAM_read_oe('h0001, d_01);
    $display("F-RAM /OE Read: 'h0001, Data - %h", d_01);
    
    FRAM_read_oe('h0002, d_02);
    $display("F-RAM /OE Read: 'h0002, Data - %h", d_02);
    
    FRAM_read_oe('h0003, d_03);
    $display("F-RAM /OE Read: 'h0003, Data - %h", d_03);
    
    FRAM_read_oe('h0004, d_04);
    $display("F-RAM /OE Read: 'h0004, Data - %h", d_04);
    
    FRAM_read_oe('h0005, d_05);
    $display("F-RAM /OE Read: 'h0005, Data - %h", d_05);
    
    FRAM_read_oe('h0006, d_06);
    $display("F-RAM /OE Read: 'h0006, Data - %h", d_06);
    
    FRAM_read_oe('h0007, d_07);
    $display("F-RAM /OE Read: 'h0007, Data - %h", d_07);
    
    FRAM_read_oe('h0008, d_08);
    $display("F-RAM /OE Read: 'h0008, Data - %h", d_08);
    
//*******************************************
//   PAGE MODE Read of 9 bytes 
//   First access is /OE controlled  - Toe
//   Next 3 access is page mode  - Taap
//   Next byte is random read  - Trc
//   Next 3 access is page mode  - Taap
//   Next byte is random read  - Trc
//*******************************************    
    $display("\n\n*********************************");                        
    $display("Test case 15: Page mode and random read timings. First Read is /OE controlled");
    $display("*********************************\n");                            
    FRAM_read_oe_addr('h0000, 'h09);

//*******************************************
//   PAGE MODE Read of 9 bytes 
//   First access is /CE controlled  - Toe
//   Next 3 access is page mode  - Taap
//   Next byte is random read  - Trc
//   Next 3 access is page mode  - Taap
//   Next byte is random read  - Trc
//*******************************************   
    $display("\n\n*********************************");                        
    $display("Test case 16: Page mode and random read timings. First Read is /CE controlled");
    $display("*********************************\n");                        
    
    FRAM_read_ce_addr('h0001, 'h08);
    
    end

task FRAM_read_oe;
input [15:0] t_addr;
output [15:0] t_dq;
begin
   dq_reg[15:0] <= 'hz;        
   addr = t_addr;
   #`tAS;
   ce_ = 1'b0;
   #100;
   ub_ = 1'b0;
   lb_ = 1'b0;
   #10;
   oe_ = 1'b0;
   #`Toe;
   #2;
   t_dq = dq;
   #200;
   oe_ = 1'b1;
   ce_ = 1'b1;
       
   #500;
end	
endtask

task FRAM_write_we;
input [15:0] t_addr;
input [15:0] t_dq;
begin
   addr = t_addr;
   dq_reg[15:0] = t_dq;
   #`tAS;
   ce_ = 1'b0;
   ub_ = 1'b0;
   lb_ = 1'b0;     
   #`Tce;
   we_ = 1'b0;
   #`tWZ;
   #`tWZ;
   #(`tDS+`tDH);
   we_ = 1'b1;
   #100;
   ce_ = 1'b1;
   ub_ = 1'b1;
   lb_ = 1'b1;             
        
   #500;
end
endtask


task FRAM_read_oe_addr;
input [15:0] t_addr;
input [7:0] t_len;
reg   [7:0] i;
begin
   dq_reg[15:0] <= 'hz;        
   addr = t_addr;
   #`tAS;
   ce_ = 1'b0;
   #100;
   ub_ = 1'b0;
   lb_ = 1'b0;
   #10;
   oe_ = 1'b0;
   #`Toe;
   #2;
   $display("F-RAM Read: Addr - %h, Data - %h", addr, dq[15:0]);
   #200;
   for(i=1; i<t_len; i= i+1)
   begin
      addr = t_addr + i;
      if(addr % 4 == 0)
         #`Trc;
      else
         #`Taap;
      #2;
      $display("F-RAM Read: Addr - %h, Data - %h", addr, dq[15:0]);
      #200;        
   end

   oe_ = 1'b1;
   ce_ = 1'b1;
end
endtask

task FRAM_read_ce_addr;
input [15:0] t_addr;
input [7:0] t_len;
reg   [7:0] i;
begin
   dq_reg[15:0] <= 'hz;        
   addr = t_addr;
   #`tAS;
   oe_ = 1'b0;
   #100;
   ub_ = 1'b0;
   lb_ = 1'b0;
   #10;
   ce_ = 1'b0;
   #`Tce;
   #2;        
   $display("F-RAM Read: Addr - %h, Data - %h", addr, dq[15:0]);  
   #200;
   for(i=1; i<t_len; i= i+1)
   begin
      addr = t_addr + i;
      if(addr % 4 == 0)
         #`Trc;
      else
         #`Taap;
      #2;
      $display("F-RAM Read: Addr - %h, Data - %h", addr, dq[15:0]);
      #200;        
   end

   ce_ = 1'b1;
   oe_ = 1'b1;
end
endtask

        
endmodule

