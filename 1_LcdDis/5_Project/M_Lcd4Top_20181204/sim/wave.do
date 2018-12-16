onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider DVI0
add wave -noupdate /m_sim/U_M_Lcd4Top_0/CpSl_Dvi0Clk_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/CpSl_Dvi0Vsync_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/CpSl_Dvi0Hsync_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/CpSl_Dvi0Scdt_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/CpSl_Dvi0De_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/CpSv_Dvi0R_i
add wave -noupdate -divider DVI1
add wave -noupdate /m_sim/U_M_Lcd4Top_0/CpSl_Dvi1Scdt_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/CpSv_Dvi1R_i
add wave -noupdate -divider {DVI IN FIFO}
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/U_M_DviRxFifo_0/wr_clk
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/U_M_DviRxFifo_0/wr_en
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/U_M_DviRxFifo_0/din
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/U_M_DviRxFifo_0/rd_clk
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/U_M_DviRxFifo_0/rd_en
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/U_M_DviRxFifo_0/dout
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/U_M_DviRxFifo_0/empty
add wave -noupdate -divider DDR
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSl_DdrClk_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSl_DdrRdy_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSl_AppRdy_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSl_AppEn_o
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSv_AppCmd_o
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSv_AppAddr_o
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSl_AppWdfWren_o
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSv_AppWdfData_o
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSl_AppWdfRdy_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSl_AppWdfEnd_o
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSl_AppRdDataVld_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSv_AppRdData_i
add wave -noupdate -divider Counter
add wave -noupdate -radix unsigned /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/PrSv_HCnt_s
add wave -noupdate -radix unsigned /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/PrSv_VCnt_s
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/PrSl_Hsync_s
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/PrSl_Vsync_s
add wave -noupdate -divider Read
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/PrSl_Hsync_s
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/PrSl_Hsync_Ddr_s
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/PrSl_RowRdTrig_s
add wave -noupdate -divider LCD
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSl_LcdClk_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSl_LCD_Double_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSv_Refresh_Rate_Sel_i
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSl_LcdVsync_o
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSl_LcdHsync_o
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSv_LcdR0_o
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSv_LcdR1_o
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSv_LcdR2_o
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_DdrIf_0/CpSv_LcdR3_o
add wave -noupdate -divider M_Test
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_M_Test_0/CpSv_FreChoice_i
add wave -noupdate -format Literal /m_sim/U_M_Lcd4Top_0/U_M_M_Test_0/CpSl_Test_o
add wave -noupdate -format Literal /m_sim/U_M_Lcd4Top_0/U_M_M_Test_0/PrSl_1msTrig_s
add wave -noupdate -format Literal /m_sim/U_M_Lcd4Top_0/U_M_M_Test_0/PrSl_2msTrig_s
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_M_Test_0/PrSv_Cnt_s
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_M_Test_0/PrSv_TestCnt_s
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_M_Test_0/PrSv_FreChoiceDly1_s
add wave -noupdate /m_sim/U_M_Lcd4Top_0/U_M_M_Test_0/PrSv_FreChoiceDly2_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 8} {910483563750 ps} 0} {{Cursor 9} {1008045098 ps} 0} {{Cursor 3} {106913874 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 379
configure wave -valuecolwidth 65
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {7461462996 ps}
