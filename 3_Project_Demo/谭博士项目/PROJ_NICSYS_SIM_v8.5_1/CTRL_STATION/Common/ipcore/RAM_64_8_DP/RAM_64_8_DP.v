//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon May 09 18:15:45 2016
// Version: v11.5 SP2 11.5.2.6
//////////////////////////////////////////////////////////////////////

`timescale 1 ns/100 ps

// RAM_64_8_DP
module RAM_64_8_DP(
    // Inputs
    A_ADDR,
    A_CLK,
    B_ADDR,
    B_CLK,
    C_ADDR,
    C_CLK,
    C_DIN,
    C_WEN,
    // Outputs
    A_DOUT,
    B_DOUT
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [5:0] A_ADDR;
input        A_CLK;
input  [5:0] B_ADDR;
input        B_CLK;
input  [5:0] C_ADDR;
input        C_CLK;
input  [7:0] C_DIN;
input        C_WEN;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [7:0] A_DOUT;
output [7:0] B_DOUT;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [5:0] A_ADDR;
wire         A_CLK;
wire   [7:0] A_DOUT_0;
wire   [5:0] B_ADDR;
wire         B_CLK;
wire   [7:0] B_DOUT_0;
wire   [5:0] C_ADDR;
wire         C_CLK;
wire   [7:0] C_DIN;
wire         C_WEN;
wire   [7:0] A_DOUT_0_net_0;
wire   [7:0] B_DOUT_0_net_0;


//--------------------------------------------------------------------
// REG
//--------------------------------------------------------------------
reg [7:0]A_DOUT_1;
reg [7:0]B_DOUT_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire         GND_net;
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
//--------RAM_64_8_DP_RAM_64_8_DP_0_URAM   -   Actel:SgCore:URAM:1.0.101
RAM_64_8_DP_RAM_64_8_DP_0_URAM RAM_64_8_DP_0(
        // Inputs
        .C_DIN  ( C_DIN ),
        .A_ADDR ( A_ADDR ),
        .B_ADDR ( B_ADDR ),
        .C_ADDR ( C_ADDR ),
        .C_WEN  ( C_WEN ),
        .A_CLK  ( A_CLK ),
        .B_CLK  ( B_CLK ),
        .C_CLK  ( C_CLK ),
        // Outputs
        .A_DOUT ( A_DOUT_0 ),
        .B_DOUT ( B_DOUT_0 ) 
        );
always @(posedge A_CLK)
begin
A_DOUT_1<=A_DOUT_0_net_0;
end

always @(posedge B_CLK)
begin
B_DOUT_1<=B_DOUT_0_net_0;
end

endmodule
