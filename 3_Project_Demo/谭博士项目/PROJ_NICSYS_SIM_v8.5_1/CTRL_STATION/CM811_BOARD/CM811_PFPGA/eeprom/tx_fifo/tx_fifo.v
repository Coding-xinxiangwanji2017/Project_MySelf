//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Wed Mar 30 14:12:20 2016
// Version: v11.5 SP2 11.5.2.6
//////////////////////////////////////////////////////////////////////

`timescale 1 ns/100 ps

// tx_fifo
module tx_fifo(
    // Inputs
    CLK,
    DATA,
    RE,
    RESET,
    WE,
    // Outputs
    EMPTY,
    FULL,
    Q
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input        CLK;
input  [7:0] DATA;
input        RE;
input        RESET;
input        WE;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output       EMPTY;
output       FULL;
output [7:0] Q;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire         CLK;
wire   [7:0] DATA;
wire         EMPTY_net_0;
wire         FULL_net_0;
wire   [7:0] Q_net_0;
wire         RE;
wire         RESET;
wire         WE;
wire         FULL_net_1;
wire         EMPTY_net_1;
wire   [7:0] Q_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire         GND_net;
wire   [7:0] MEMRD_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net           = 1'b0;
assign MEMRD_const_net_0 = 8'h00;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign FULL_net_1  = FULL_net_0;
assign FULL        = FULL_net_1;
assign EMPTY_net_1 = EMPTY_net_0;
assign EMPTY       = EMPTY_net_1;
assign Q_net_1     = Q_net_0;
assign Q[7:0]      = Q_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------tx_fifo_tx_fifo_0_COREFIFO   -   Actel:DirectCore:COREFIFO:2.4.100
tx_fifo_tx_fifo_0_COREFIFO #( 
        .AE_STATIC_EN   ( 0 ),
        .AEVAL          ( 4 ),
        .AF_STATIC_EN   ( 0 ),
        .AFVAL          ( 1020 ),
        .CTRL_TYPE      ( 2 ),
        .ESTOP          ( 1 ),
        .FAMILY         ( 24 ),
        .FSTOP          ( 1 ),
        .FWFT           ( 1 ),
        .OVERFLOW_EN    ( 0 ),
        .PIPE           ( 1 ),
        .PREFETCH       ( 0 ),
        .RCLK_EDGE      ( 1 ),
        .RDCNT_EN       ( 0 ),
        .RDEPTH         ( 4096 ),
        .RE_POLARITY    ( 0 ),
        .READ_DVALID    ( 0 ),
        .RESET_POLARITY ( 1 ),
        .RWIDTH         ( 8 ),
        .SYNC           ( 1 ),
        .UNDERFLOW_EN   ( 0 ),
        .WCLK_EDGE      ( 1 ),
        .WDEPTH         ( 4096 ),
        .WE_POLARITY    ( 0 ),
        .WRCNT_EN       ( 0 ),
        .WRITE_ACK      ( 0 ),
        .WWIDTH         ( 8 ) )
tx_fifo_0(
        // Inputs
        .CLK       ( CLK ),
        .WCLOCK    ( GND_net ), // tied to 1'b0 from definition
        .RCLOCK    ( GND_net ), // tied to 1'b0 from definition
        .RESET     ( RESET ),
        .WE        ( WE ),
        .RE        ( RE ),
        .DATA      ( DATA ),
        .MEMRD     ( MEMRD_const_net_0 ), // tied to 8'h00 from definition
        // Outputs
        .FULL      ( FULL_net_0 ),
        .EMPTY     ( EMPTY_net_0 ),
        .AFULL     (  ),
        .AEMPTY    (  ),
        .OVERFLOW  (  ),
        .UNDERFLOW (  ),
        .WACK      (  ),
        .DVLD      (  ),
        .MEMWE     (  ),
        .MEMRE     (  ),
        .Q         ( Q_net_0 ),
        .WRCNT     (  ),
        .RDCNT     (  ),
        .MEMWADDR  (  ),
        .MEMRADDR  (  ),
        .MEMWD     (  ) 
        );


endmodule
