///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2016 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 14.7
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : ILA1.v
// /___/   /\     Timestamp  : Tue Sep 06 10:48:07 中国标准时间 2016
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module ILA1(
    CONTROL,
    CLK,
    TRIG0,
    TRIG1,
    TRIG2,
    TRIG3) /* synthesis syn_black_box syn_noprune=1 */;


inout [35 : 0] CONTROL;
input CLK;
input [255 : 0] TRIG0;
input [255 : 0] TRIG1;
input [255 : 0] TRIG2;
input [255 : 0] TRIG3;

endmodule
