/* This model is the property of Cypress Semiconductor Corp.
-- and is protected by the US copyright laws, any unauthorized
-- copying and distribution is prohibited.
-- Cypress reserves the right to change any of the functional 
-- specifications without any prior notice.
-- Cypress is not liable for any damages which may result from
-- the use of this functional model
----------------------------------------------------------------------
-- File name : FM28V102A.v
----------------------------------------------------------------------
-- Functionality : Verilog behavourial Model for FM28V102A 
-- Source:  CYPRESS Data Sheet : "FM28V102A 1Mbit F-RAM Memory" 
--                 
-- Version:  1.0 june 16, 2014
-----------------------------------------------------------------------
-- Developed by CYPRESS SEMICONDUCTOR
-- version |     author       | mod date | changes made
--    1.0         GVCH          06/16/14    New Model
--
-- Added a delayed ce_ signal for setup/hold time violation detection.
------------------------------------------------------------------------
-- PART DESCRIPTION :
-- Part:        FM28V102A
--
-- Descripton:  Verilog behavourial Model  for  FM28V102A
------------------------------------------------------------------------ */  

`timescale 1ns / 10ps       // simulator unit/precision

`include "../CTRL_STATION/Common/others/FM28V102A/config.v"

// Verilog model of FM28V102A - 64Kx16 F-RAM

module FM28V102A(dq,addr,ce_,we_,oe_,ub_,lb_);
  inout [15:0] dq;
  input [15:0] addr;
  input ce_, we_, oe_, ub_, lb_;


//******************** Timing section ********************
reg notifier;
wire Enabled =  ~ce_;
reg   addr_change_reg = 1'b1;
wire  addr_change;
reg ce_stop_reg = 1'b1;
reg ce_start_reg = 1'b0;
wire ce_stop, ce_start;
reg [15:0] addr_prev;
reg [15:0] addr_prev1;
reg page_mode;
reg [15:0] data_reg = 'hz;
wire delayed_ce_; 

reg [31:0] i;

wire page_mode_ce = page_mode && Enabled;

assign #0.01 delayed_ce_ = ce_;


always @(addr)
begin
   addr_change_reg <= 1'b1;
    #1;
   addr_change_reg <= 1'b0; 
end

assign addr_change = (page_mode == 1'b1) ? 1'b0 : addr_change_reg;

specify
$period(negedge ce_,`Trc,notifier);               // CE cycle time check
$width(negedge ce_,`Tca,0,notifier);              // CE min low time check
$width(posedge ce_,`Tpc,0,notifier);              // CE min high time check
$period(negedge addr_change &&& Enabled,`Trc,notifier);       // Addr cycle time check
$period(negedge we_ &&& page_mode_ce,`tpwc,notifier);      // page mode address cycle time
$setuphold(negedge delayed_ce_,addr,`Tas,`Tah,notifier);  // Addr setup/hold check
$width(negedge we_  &&& Enabled,`Twp,0,notifier);             // WE min low time check
$setuphold(posedge we_ &&& Enabled,dq,`Tds,`Tdh,notifier);    // Data setup/hold time check
$setuphold(posedge ce_ &&& ~we_,dq,`Tds,`Tdh,notifier);       // Data setup/hold time check
$recovery(negedge ce_,posedge we_,`Tcw,notifier);        // Write access time check

(addr[15:2] *> dq) =  (`Tce,`Tce,         // 0 -> 1 and 1 -> 0 transition
            `Thz,            // 0 -> z transition
            `Tce,            // z -> 1 transition
            `Thz,            // 1 -> z transition
            `Tce);           // z -> 0 transition
            
(addr[1:0] *> dq) =  (`Taap,`Taap,         // 0 -> 1 and 1 -> 0 transition
            `Thz,            // 0 -> z transition
            `Taap,            // z -> 1 transition
            `Thz,            // 1 -> z transition
            `Taap);           // z -> 0 transition            

(ce_ *> dq) =  (`Tdummy,`Tdummy,  // 0 -> 1 and 1 -> 0 transition
            `Thz,            // 0 -> z transition
            `Tce,            // z -> 1 transition
            `Thz,            // 1 -> z transition
            `Tce);           // z -> 0 transition

(we_ *> dq) =  (`Tdummy,`Tdummy,  // 0 -> 1 and 1 -> 0 transition
            `Twz,            // 0 -> z transition
            `Twx,            // z -> 1 transition
            `Twz,            // 1 -> z transition
            `Twx);           // z -> 0 transition

(oe_ *> dq) =  (`Tdummy,`Tdummy,  // 0 -> 1 and 1 -> 0 transition
            `Tohz,           // 0 -> z transition
            `Toe,            // z -> 1 transition
            `Tohz,           // 1 -> z transition
            `Toe);           // z -> 0 transition

endspecify

//******************** End of Timing section ********************


//     Declare the RAM array and some signals

reg [15:0]  Mem [0:'hffff];            // F-RAM array, 64Kx16

wire      READ  = (!ce_ && we_);
wire      WRITE = (!ce_ && !we_);
wire      OE_UB = (!oe_ && !ub_);
wire      OE_LB = (!oe_ && !lb_);

wire [15:0] data  = (READ? ((page_mode == 1'b1)) ? Mem[addr] : data_reg : 16'bz);

initial
    begin
    `ifdef initMemFile
        //
        // memory initialization with data from file
        //
        $readmemh(`initMemFile,Mem);
        $display("Simulated memory array initialization with data from %s...",`initMemFile);
    `else
        //
        // memory initialization with ffff
        //
        for(i=0; i<'h20000; i=i+1)
            begin
               Mem[i] = 16'hffff;
            end
        $display("Simulated memory array initialization with 16'hffff...");
    `endif
end 


always @(negedge WRITE)
begin
   if(ce_start == 1'b1 || page_mode == 1'b1)
   begin
       if (!ub_) 
          begin
              Mem[addr][15:8]  = dq[15:8];
              $display("write upper - %h, to Addr %h", dq[15:8], addr);
           end
           
       if (!lb_)
       begin
              Mem[addr][7:0]  = dq[7:0];
              $display("write lower - %h  to Addr %h", dq[7:0], addr);
           end
           ce_start_reg  <= 1'b0;                   
       end
  else
      $display("WARNING: /CE LOW violation during WRITE !!");
end

always @(ce_)
begin
   if(ce_)
   begin
     ce_start_reg <= 1'b0;
     ce_stop_reg  <= 1'b1;
   end
   else
   begin
     ce_start_reg <= 1'b1;
     ce_stop_reg  <= 1'b0;     
   end
end

assign ce_start = ce_start_reg;
assign ce_stop  = ce_stop_reg;

always @(addr)
begin

   if(addr[15:2] == addr_prev[15:2] && ce_stop == 1'b0)
   begin
      page_mode = 1'b1;
   end
   else
   begin
      page_mode = 1'b0;   
   end
      
   addr_prev = addr;
   
   if(READ & !oe_)
   begin   
      
         #`Taa data_reg = Mem[addr];
   end
   else
      data_reg = 'hz;
end

always @(negedge oe_)
begin
   if(READ)
   begin
      #`Toe data_reg = Mem[addr];
   end
end

always @(negedge ce_)
begin
   if(we_ && !oe_)
   begin
      
         #`Tce data_reg = Mem[addr];
      
   end
end
bufif1 b15 (dq[15],data[15],OE_UB);
bufif1 b14 (dq[14],data[14],OE_UB);
bufif1 b13 (dq[13],data[13],OE_UB);
bufif1 b12 (dq[12],data[12],OE_UB);
bufif1 b11 (dq[11],data[11],OE_UB);
bufif1 b10 (dq[10],data[10],OE_UB);
bufif1 b09 (dq[09],data[09],OE_UB);
bufif1 b08 (dq[08],data[08],OE_UB);
bufif1 b07 (dq[07],data[07],OE_LB);
bufif1 b06 (dq[06],data[06],OE_LB);
bufif1 b05 (dq[05],data[05],OE_LB);
bufif1 b04 (dq[04],data[04],OE_LB);
bufif1 b03 (dq[03],data[03],OE_LB);
bufif1 b02 (dq[02],data[02],OE_LB);
bufif1 b01 (dq[01],data[01],OE_LB);
bufif1 b00 (dq[00],data[00],OE_LB);

endmodule
