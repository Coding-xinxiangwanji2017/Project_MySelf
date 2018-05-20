///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2016 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 14.2
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : ila.v
// /___/   /\     Timestamp  : Mon Aug 22 19:59:18 中国标准时间 2016
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module ila(
    CONTROL,
    CLK,
    TRIG0,
    TRIG1,
    TRIG2,
    TRIG3);


inout [35 : 0] CONTROL;
input CLK;
input [255 : 0] TRIG0;
input [255 : 0] TRIG1;
input [255 : 0] TRIG2;
input [255 : 0] TRIG3;

endmodule
