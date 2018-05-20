onerror {resume}
quietly virtual signal -install /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_NP811_BOARD_B01/u1_NP811_U1_B01/l_bus_top { /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_NP811_BOARD_B01/u1_NP811_U1_B01/l_bus_top/card_id[3:0]} slot_id
quietly virtual signal -install /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_NP811_BOARD_B01/u1_NP811_U1_B01/l_bus_top { /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_NP811_BOARD_B01/u1_NP811_U1_B01/l_bus_top/card_id[6:4]} rack_id
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/clk
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/rst
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/im_mode_byte
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/i_rst_req
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/om_mode_reg
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/o_ini_start
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/i_ini_done
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/i_ini_fail
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/o_tb_txen
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/o_mb_txen
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/o_down_en
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/state
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/cnt
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/r_ini_done
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/flag_all_done
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/main_ctrl_IO/cnt_rst
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/main_ctrl_console_IO/clk
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/main_ctrl_console_IO/rst
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/main_ctrl_console_IO/i_down_en
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/main_ctrl_console_IO/i_ini_ok
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/main_ctrl_console_IO/o_start_scan
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/main_ctrl_console_IO/om_base_addr
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/main_ctrl_console_IO/i_done_scan
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/main_ctrl_console_IO/state
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/main_ctrl_console_IO/addr_rst
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/main_ctrl_console_IO/addr_add
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/clk
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/rst
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/i_start_con
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/im_base_addr
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/o_done_con
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/o_error_con
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/type_area
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/o_start1
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/i_done1
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/o_start2
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/i_done2
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/i_error2
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/o_start3
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/i_done3
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/i_error3
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/o_start4
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/i_done4
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/i_error4
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/om_base_addr
add wave -noupdate /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/datas_scan_I/con_ctrl_IO/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {32043359 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 234
configure wave -valuecolwidth 105
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {290602077 ps} {313204859 ps}
