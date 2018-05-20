/*-- This model is the property of Cypress Semiconductor Corp.
-- and is protected by the US copyright laws, any unauthorized
-- copying and distribution is proibited.
-- Cypress reserves the right to change any of the functional 
-- specifications without any prior notice.
-- Cypress is not liable for any damages which may result from
-- the use of this functional model.
----------------------------------------------------------------------
-- File name : config.v
----------------------------------------------------------------------
-- Functionality : Timing and Configuration (General)
--               for FM28V102A chip behavioral Verilog model 
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
-- Part:        Timing F-RAM FM28V102A
--
-- Descripton:  Contains Testbench for F-RAM features for  FM28V102A
------------------------------------------------------------------------ */

// uncomment for 2.0V - 2.7V range. Comment for 2.7V - 3.6V range.
//`define   VDD_2V_2p7V   

// uncommented for 2.7V - 3.6V range. Comment for 2.0V - 2.7V range.
`define   VDD_2p7V_3p6V

`ifdef VDD_2V_2p7V

`define tWC      105        // Write Cycle time
`define tWP      22        // Write Enable Pulse Width 
`define tCW      70        // Chip Enable to Write Enable High
`define tDS      20        // Data Input Setup Time
`define tWZ      10        // Write Enable Low to Output High Z
`define tHZ      15        // Chip Enable to Output High-Z   
`define tOHZ     15        // Output Enable High to Output High-Z  
`define tAS       0        // Address Setup Time (to /CE low)
`define tAH      70        // Address Hold Time (/CE-controlled) 
`define tOE      25        // Output Enable Access Time
`define tOH      20        // Output Hold Time 
`define tBHZ     15        // /UB, /LB High to Output High-Z
`define tDH       0        // Data Input Hold Time
`define tWS       0        // Write Enable to /CE Low Setup Time
`define tpwc      40       //Page mode write enable cycle time 

      // COMMON parameters
`define Trc   105 // Address or CE Cycle Time min
`define Tca   70 // CE Low Time min
`define Tpc   35 // CE High Time min (precharge time)
`define Tas    0 // Addr Setup Time min (relative to CE falling edge)
`define Tah   70 // Addr Hold Time min (relative to CE falling edge)
`define Thz   15 // CE High to Q High-Z max

// READ parameters
`define Tce   70    // CE Access Time max
`define Taa   105    // Addr Access Time max
`define Toe   25    // OE Access Time max
`define Tohz  15    // OE High to Q High-Z max
`define Tdummy 0.1  // Should never be used

// WRITE parameters
`define Twp   22    // WE Pulse Width min
`define Tcw   70    // CE Low to WE High min
`define Tds   20    // Data Setup Time to end of Write
`define Tdh    0    // Data Hold Time to end of Write
`define Twz   10    // WE Low to Q High-Z max
`define Twx    8    // WE High to Q Active min
`define Taap  40    // Page Mode Address Access Time

`else

`define tWC      90        // Write Cycle time
`define tWP      18        // Write Enable Pulse Width 
`define tCW      60        // Chip Enable to Write Enable High
`define tDS      15        // Data Input Setup Time
`define tWZ      10        // Write Enable Low to Output High Z
`define tHZ      10        // Chip Enable to Output High-Z   
`define tOHZ     10        // Output Enable High to Output High-Z  
`define tAS       0        // Address Setup Time (to /CE low)
`define tAH      60        // Address Hold Time (/CE-controlled) 
`define tOE      15        // Output Enable Access Time
`define tOH      20        // Output Hold Time 
`define tBHZ     10        // /UB, /LB High to Output High-Z
`define tDH       0        // Data Input Hold Time
`define tWS       0        // Write Enable to /CE Low Setup Time

`define tpwc     30       //Page mode write enable cycle time 

      // COMMON parameters
`define Trc   90 // Address or CE Cycle Time min
`define Tca   60 // CE Low Time min
`define Tpc   30 // CE High Time min (precharge time)
`define Tas    0 // Addr Setup Time min (relative to CE falling edge)
`define Tah   60 // Addr Hold Time min (relative to CE falling edge)
`define Thz   10 // CE High to Q High-Z max

// READ parameters
`define Tce   60    // CE Access Time max
`define Taa   90    // Addr Access Time max
`define Toe   15    // OE Access Time max
`define Tohz  10    // OE High to Q High-Z max
`define Tdummy 0.1  // Should never be used

// WRITE parameters
`define Twp   18    // WE Pulse Width min
`define Tcw   60    // CE Low to WE High min
`define Tds   15    // Data Setup Time to end of Write
`define Tdh    0    // Data Hold Time to end of Write
`define Twz   10    // WE Low to Q High-Z max
`define Twx    5    // WE High to Q Active min
`define Taap  30    // Page Mode Address Access Time

`endif

//_______________________________________________________________________
//  Uncomment only if you want to initialize memory with values from a file
//
//`define       initMemFile     "init.dat"

