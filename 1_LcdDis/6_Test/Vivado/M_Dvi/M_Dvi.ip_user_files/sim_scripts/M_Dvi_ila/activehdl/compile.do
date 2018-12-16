vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../M_Dvi.srcs/sources_1/ip/M_Dvi_ila/hdl/verilog" "+incdir+../../../../M_Dvi.srcs/sources_1/ip/M_Dvi_ila/hdl/verilog" \
"D:/M_Tool/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/M_Tool/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/M_Tool/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../M_Dvi.srcs/sources_1/ip/M_Dvi_ila/sim/M_Dvi_ila.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

