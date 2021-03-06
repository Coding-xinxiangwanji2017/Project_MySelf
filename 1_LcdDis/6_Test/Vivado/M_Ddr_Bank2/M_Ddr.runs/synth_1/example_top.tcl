# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7k325tffg900-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.cache/wt [current_project]
set_property parent.project_path D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo d:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_afifo.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_cmd_gen.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_cmd_prbs_gen.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_data_prbs_gen.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_init_mem_pattern_ctr.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_memc_flow_vcontrol.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_memc_traffic_gen.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_rd_data_gen.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_read_data_path.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_read_posted_fifo.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_s7ven_data_gen.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_tg_prbs_gen.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_tg_status.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_traffic_gen_top.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_vio_init_pattern_bram.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_wr_data_gen.v
  D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/traffic_gen/mig_7series_v4_0_write_data_path.v
}
read_vhdl -library xil_defaultlib D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/example_design/rtl/example_top.vhd
read_ip -quiet d:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl.xci
set_property used_in_implementation false [get_files -all d:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/user_design/constraints/M_DdrCtrl.xdc]
set_property used_in_implementation false [get_files -all d:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/user_design/constraints/M_DdrCtrl_ooc.xdc]

read_ip -quiet d:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/ila_0/ila_0.xci
set_property used_in_synthesis false [get_files -all d:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/ila_0/ila_v6_2/constraints/ila_impl.xdc]
set_property used_in_implementation false [get_files -all d:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/ila_0/ila_v6_2/constraints/ila_impl.xdc]
set_property used_in_implementation false [get_files -all d:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/ila_0/ila_v6_2/constraints/ila.xdc]
set_property used_in_implementation false [get_files -all d:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/ila_0/ila_0_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/user_design/constraints/M_DdrCtrl.xdc
set_property used_in_implementation false [get_files D:/Project_MySelf/1_LcdDis/Vivado/M_Ddr/M_Ddr.srcs/sources_1/ip/M_DdrCtrl/M_DdrCtrl/user_design/constraints/M_DdrCtrl.xdc]


synth_design -top example_top -part xc7k325tffg900-2


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef example_top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file example_top_utilization_synth.rpt -pb example_top_utilization_synth.pb"
