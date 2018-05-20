//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Wed Apr 20 16:32:05 2016
// Version: v11.5 SP3 11.5.3.10
//////////////////////////////////////////////////////////////////////

`timescale 1 ns/100 ps

// RAM_26624_8_DP
module RAM_26624_8_DP(
    // Inputs
    A_ADDR,
    A_CLK,
    A_DIN,
    A_WEN,
    B_ADDR,
    B_CLK,
    B_DIN,
    B_WEN,
    // Outputs
    A_DOUT,
    B_DOUT
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [14:0] A_ADDR;
input         A_CLK;
input  [7:0]  A_DIN;
input         A_WEN;
input  [14:0] B_ADDR;
input         B_CLK;
input  [7:0]  B_DIN;
input         B_WEN;
//--------------------------------------------------------------------
// reg
//--------------------------------------------------------------------
reg [7:0]A_DOUT_1;
reg [7:0]B_DOUT_1;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [7:0]  A_DOUT;
output [7:0]  B_DOUT;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [14:0] A_ADDR;
wire          A_CLK;
wire   [7:0]  A_DIN;
wire   [7:0]  A_DOUT_0;
wire          A_WEN;
wire   [14:0] B_ADDR;
wire          B_CLK;
wire   [7:0]  B_DIN;
wire   [7:0]  B_DOUT_0;
wire          B_WEN;
wire   [7:0]  A_DOUT_0_net_0;
wire   [7:0]  B_DOUT_0_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net = 1'b0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign A_DOUT_0_net_0 = A_DOUT_0;
assign A_DOUT[7:0]    = A_DOUT_1;
assign B_DOUT_0_net_0 = B_DOUT_0;
assign B_DOUT[7:0]    = B_DOUT_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------RAM_26624_8_DP_RAM_26624_8_DP_0_DPSRAM   -   Actel:SgCore:DPSRAM:1.0.101
RAM_26624_8_DP_RAM_26624_8_DP_0_DPSRAM RAM_26624_8_DP_0(
        // Inputs
        .A_DIN  ( A_DIN ),
        .A_ADDR ( A_ADDR ),
        .B_DIN  ( B_DIN ),
        .B_ADDR ( B_ADDR ),
        .A_WEN  ( A_WEN ),
        .B_WEN  ( B_WEN ),
        .A_CLK  ( A_CLK ),
        .B_CLK  ( B_CLK ),
        // Outputs
        .A_DOUT ( A_DOUT_0 ),
        .B_DOUT ( B_DOUT_0 ) 
        );
always@(posedge A_CLK)
begin
A_DOUT_1<=A_DOUT_0_net_0;
end
always@(posedge B_CLK)
begin
B_DOUT_1<=B_DOUT_0_net_0;
end

endmodule
