vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv "+incdir+../../../../M_Dvi.srcs/sources_1/ip/M_Dvi_ila/hdl/verilog" "+incdir+../../../../M_Dvi.srcs/sources_1/ip/M_Dvi_ila/hdl/verilog" \
"D:/M_Tool/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/M_Tool/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/M_Tool/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../M_Dvi.srcs/sources_1/ip/M_Dvi_ila/sim/M_Dvi_ila.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

