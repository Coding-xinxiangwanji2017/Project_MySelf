
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name CAMERAL_TOP -dir "C:/Users/Administrator/Desktop/version/CAMERA_TOP6.5_20171205_frame_test_plus/project_14.7/CAMERAL_TOP/planAhead_run_2" -part xc7k325tffg900-2
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "C:/Users/Administrator/Desktop/version/CAMERA_TOP6.5_20171205_frame_test_plus/project_14.7/CAMERAL_TOP/CAMERA_TOP.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Administrator/Desktop/version/CAMERA_TOP6.5_20171205_frame_test_plus/project_14.7/CAMERAL_TOP} {../../hdl/data_move} {../../hdl/data_send} {../../hdl/data_tx} {../../hdl/TOE} {../../ipcore_verilog/RAM_4096_16_SDP} {../../ipcore_verilog/GTX} {ipcore_dir} }
add_files [list {ipcore_dir/flash_fifo_4k_16.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/icon.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/ICON1.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/ICON2.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/icon_i.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/ICON_TOP.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/ila.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/ILA1.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/vio.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "C:/Users/Administrator/Desktop/version/CAMERA_TOP6.5_20171205_frame_test_plus/ucf/CAMERA.ucf" [current_fileset -constrset]
add_files [list {C:/Users/Administrator/Desktop/version/CAMERA_TOP6.5_20171205_frame_test_plus/ucf/CAMERA.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {C:/Users/Administrator/Desktop/version/CAMERA_TOP6.5_20171205_frame_test_plus/ucf/top_test.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "C:/Users/Administrator/Desktop/version/CAMERA_TOP6.5_20171205_frame_test_plus/project_14.7/CAMERAL_TOP/CAMERA_TOP.ncd"
if {[catch {read_twx -name results_1 -file "C:/Users/Administrator/Desktop/version/CAMERA_TOP6.5_20171205_frame_test_plus/project_14.7/CAMERAL_TOP/CAMERA_TOP.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"C:/Users/Administrator/Desktop/version/CAMERA_TOP6.5_20171205_frame_test_plus/project_14.7/CAMERAL_TOP/CAMERA_TOP.twx\": $eInfo"
}
