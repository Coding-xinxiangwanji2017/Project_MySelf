// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Tue Dec  4 11:31:07 2018
// Host        : DESKTOP-RG1BP8Q running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/Project_MySelf/1_LcdDis/Vivado/M_Dvi/M_Dvi.srcs/sources_1/ip/M_ClkPll/M_ClkPll_stub.v
// Design      : M_ClkPll
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module M_ClkPll(clk_out1, reset, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,reset,locked,clk_in1" */;
  output clk_out1;
  input reset;
  output locked;
  input clk_in1;
endmodule
