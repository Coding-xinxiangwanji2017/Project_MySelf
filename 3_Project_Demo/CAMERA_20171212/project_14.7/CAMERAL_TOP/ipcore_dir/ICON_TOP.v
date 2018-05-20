///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2017 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 14.7
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : ICON_TOP.v
// /___/   /\     Timestamp  : Tue Nov 28 15:48:37 中国标准时间 2017
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module ICON_TOP(
    CONTROL0,
    CONTROL1,
    CONTROL2,
    CONTROL3,
    CONTROL4,
    CONTROL5,
    CONTROL6,
    CONTROL7) /* synthesis syn_black_box syn_noprune=1 */;


inout [35 : 0] CONTROL0;
inout [35 : 0] CONTROL1;
inout [35 : 0] CONTROL2;
inout [35 : 0] CONTROL3;
inout [35 : 0] CONTROL4;
inout [35 : 0] CONTROL5;
inout [35 : 0] CONTROL6;
inout [35 : 0] CONTROL7;

endmodule
