#---------------------------------------
#   Compile library
#---------------------------------------

# Create and map a work directory
vlib work
vmap work work


#---------------------------------------
#compile the "glbl.v" 
#---------------------------------------
vlog -work work -novopt D:/My_tool/Xilinx/14.7/ISE_DS/ISE/verilog/src/glbl.v

#---------------------------------------
#DDR3 SDRAM Part
#---------------------------------------
##SSvcom  ../rtl/*.vhd
##vlog  -incr ../rtl/traffic_gen/*.v
##vcom  ../rtl/*.vhd
vcom  -work work ../ipcore_dir/M_DdrCtrl/user_design/rtl/*.vhd
vlog  -work work -incr ../ipcore_dir/M_DdrCtrl/user_design/rtl/clocking/*.v
vlog  -work work -incr ../ipcore_dir/M_DdrCtrl/user_design/rtl/controller/*.v
vlog  -work work -incr ../ipcore_dir/M_DdrCtrl/user_design/rtl/ecc/*.v
vlog  -work work -incr ../ipcore_dir/M_DdrCtrl/user_design/rtl/ip_top/*.v
vlog  -work work -incr ../ipcore_dir/M_DdrCtrl/user_design/rtl/phy/*.v
vlog  -work work -incr ../ipcore_dir/M_DdrCtrl/user_design/rtl/ui/*.v
vcom  -work work ../ipcore_dir/M_DdrCtrl/user_design/rtl/phy/*.vhd
vlog  -work work -incr ../ipcore_dir/M_DdrCtrl/example_design/sim/wiredly.v

#Pass the parameters for memory model parameter file#
vlog -incr +incdir+. +define+x4Gb +define+sg125 +define+x16 ddr3_model.v


#---------------------------------------
# Compile files in the work directory
#vcom 表示编译VHDL代码；
#vlog 表示编译Verilog代码
#user designed part 
#---------------------------------------
vcom -work work ../ipcore_dir/*.vhd    
vcom -work work ../src/*.vhd    

# Compile testbench source
vcom -work work ./tb/*.vhd

# Begin the test
##vsim -t ps -novopt +notimingchecks -L xilinxcorelib_ver -L unisim_ver -L simprim work.M_Sim glbl
vsim -t ps -novopt +notimingchecks -L unisims_ver -L secureip work.M_Sim glbl


#look wave form
do wave.do

log -r /*
run 5 ms
