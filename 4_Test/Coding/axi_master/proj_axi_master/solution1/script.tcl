############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
############################################################
open_project proj_axi_master
set_top example
add_files example.cpp
add_files -tb example_test.cpp
open_solution "solution1"
set_part {xc7z020clg484-2}
create_clock -period 75MHz -name default
#source "./proj_axi_master/solution1/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -format ip_catalog
