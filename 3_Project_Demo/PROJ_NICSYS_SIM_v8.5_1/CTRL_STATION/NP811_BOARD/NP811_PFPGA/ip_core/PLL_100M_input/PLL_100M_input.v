//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Tue Apr 26 15:52:40 2016
// Version: v11.5 SP2 11.5.2.6
//////////////////////////////////////////////////////////////////////

`timescale 1 ns/100 ps

// PLL_100M_input
module PLL_100M_input(
    // Inputs
    CLK0,
    // Outputs
    GL0,
    GL1,
    GL2,
    GL3,
    LOCK
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  CLK0;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output GL0;
output GL1;
output GL2;
output GL3;
output LOCK;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   CLK0;
wire   GL0_net_0;
wire   GL1_net_0;
wire   GL2_net_0;
wire   GL3_net_0;
wire   LOCK_net_0;
wire   GL0_net_1;
wire   LOCK_net_1;
wire   GL1_net_1;
wire   GL2_net_1;
wire   GL3_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   GND_net;
wire   [7:2]PADDR_const_net_0;
wire   [7:0]PWDATA_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net            = 1'b0;
assign PADDR_const_net_0  = 6'h00;
assign PWDATA_const_net_0 = 8'h00;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign GL0_net_1  = GL0_net_0;
assign GL0        = GL0_net_1;
assign LOCK_net_1 = LOCK_net_0;
assign LOCK       = LOCK_net_1;
assign GL1_net_1  = GL1_net_0;
assign GL1        = GL1_net_1;
assign GL2_net_1  = GL2_net_0;
assign GL2        = GL2_net_1;
assign GL3_net_1  = GL3_net_0;
assign GL3        = GL3_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------PLL_100M_input_PLL_100M_input_0_FCCC   -   Actel:SgCore:FCCC:2.0.200
PLL_100M_input_PLL_100M_input_0_FCCC PLL_100M_input_0(
        // Inputs
        .CLK0 ( CLK0 ),
        // Outputs
        .GL0  ( GL0_net_0 ),
        .GL1  ( GL1_net_0 ),
        .GL2  ( GL2_net_0 ),
        .GL3  ( GL3_net_0 ),
        .LOCK ( LOCK_net_0 ) 
        );


endmodule
