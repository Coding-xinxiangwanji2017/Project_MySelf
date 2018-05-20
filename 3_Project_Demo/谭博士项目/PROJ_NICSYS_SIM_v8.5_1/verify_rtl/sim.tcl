#===================================================================
#  Compile  library
#===================================================================

# Create the work library
 vlib work

#===================================================================
#  Compile NicSys rlt file
#===================================================================


#==============================================
#  Common modules
#==============================================

 vlog -work work -novopt ../CTRL_STATION/Common/others/LVD206D.v
 vlog -work work -novopt ../CTRL_STATION/Common/others/SN74AUP1G.v 
 vlog -work work -novopt ../CTRL_STATION/Common/others/LVD207D.v
 
# vcom -work work -novopt ../CTRL_STATION/Common/others/M_Crc32De8.vhd
# vcom -work work -novopt ../CTRL_STATION/Common/others/M_Crc32En8.vhd
 
 # Async SRAM
 vcom -work work -novopt ../CTRL_STATION/Common/others/CY7C1061GE30_10/package_timing.vhd
 vcom -work work -novopt ../CTRL_STATION/Common/others/CY7C1061GE30_10/package_utility.vhd
 vcom -work work -novopt ../CTRL_STATION/Common/others/CY7C1061GE30_10/CY7C1061GE30_10.vhd
 
 # F-RAM
 vlog -work work -novopt ../CTRL_STATION/Common/others/FM28V102A/config.v 
 vlog -work work -novopt ../CTRL_STATION/Common/others/FM28V102A/FM28V102A.v
 



#==============================================
#  IP cores
#==============================================

 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_2048_8_SDP/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_2048_8_SDP/RAM_2048_8_SDP_0/*.v
 
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/FIFO_4096_8_FWFT/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/FIFO_4096_8_FWFT/FIFO_4096_8_FWFT_0/rtl/vlog/core/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/PLL_12P5_input/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/PLL_12P5_input/PLL_12P5_input_0/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/PLL_50M_input/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/PLL_50M_input/PLL_50M_input_0/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/PLL_100M_input/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/PLL_100M_input/PLL_100M_input_0/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_32K_8_DP/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_32K_8_DP/RAM_32K_8_DP_0/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_2048_8_DP/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_2048_8_DP/RAM_2048_8_DP_0/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_4096_8_DP/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_4096_8_DP/RAM_4096_8_DP_0/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_26624_8_DP/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_26624_8_DP/RAM_26624_8_DP_0/*.v   
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_64_8_DP/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_64_8_DP/RAM_64_8_DP_0/*.v  
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_8K_8_DP/*.v
 vlog -work work -novopt ../CTRL_STATION/Common/ipcore/RAM_8K_8_DP/RAM_8K_8_DP_0/*.v 



#==============================================
#  Bus module
#==============================================

vlog -work work -novopt ../CTRL_STATION/Common/bus/dal_phy/*.v
vlog -work work -novopt ../CTRL_STATION/Common/bus/dal_phy/rx/*.v
vcom -work work -novopt ../CTRL_STATION/Common/bus/dal_phy/rx/*.vhd
vlog -work work -novopt ../CTRL_STATION/Common/bus/dal_phy/tx/*.v
vcom -work work -novopt ../CTRL_STATION/Common/bus/dal_phy/tx/*.vhd
vlog -work work -novopt ../CTRL_STATION/Common/bus/m_bus/*.v
vlog -work work -novopt ../CTRL_STATION/Common/bus/s_link/*.v
vlog -work work -novopt ../CTRL_STATION/Common/bus/t_bus/*.v

#==============================================
#  mem interface
#==============================================

vlog -work work -novopt ../CTRL_STATION/Common/mem_interface/*.v
vlog -work work -novopt ../CTRL_STATION/Common/mem_interface/fram/*.v
vlog -work work -novopt ../CTRL_STATION/Common/mem_interface/spi_flash/*.v
vlog -work work -novopt ../CTRL_STATION/Common/mem_interface/watch_dog/*.v
vlog -work work -novopt ../CTRL_STATION/Common/mem_interface/e2prom/*.v

#==============================================
#  chs_top
#==============================================
vlog -work work -novopt ../CTRL_STATION/Common/ch_top/*.v

vlog -work work -novopt ../CTRL_STATION/Common/sim_ch/*.v

#==============================================
#  MN811   Management Module
#==============================================

 vlog -work work -novopt ../CTRL_STATION/MN811_BOARD/MN811_BOARD_B01.v
 #------------------------------
 #  PFPGA
 #------------------------------
 vlog -work work -novopt ../CTRL_STATION/MN811_BOARD/MN811_PFPGA/MN811_UT4_B01.v
 vlog -work work -novopt ../CTRL_STATION/MN811_BOARD/MN811_PFPGA/M_NET/M_NET.v
 #vlog -work work -novopt ../CTRL_STATION/MN811_BOARD/MN811_PFPGA/M_NET/M_NET_App.v 
 vlog -work work -novopt ../CTRL_STATION/MN811_BOARD/MN811_PFPGA/M_NET/M_NET_Link.v 
 vlog -work work -novopt ../CTRL_STATION/MN811_BOARD/MN811_PFPGA/M_NET/M_NET_RMII.v 
 
 
 vlog -work work -novopt ../tb/tb_M_BUS_DL.v
 
 
 

 #------------------------------
 #  DFPGA
 #------------------------------ 
 vlog -work work -novopt ../CTRL_STATION/MN811_BOARD/MN811_DFPGA/MN811_UT5_B01.v


#==============================================
#  NP811   Control Module
#==============================================


 vlog -work work -novopt ../CTRL_STATION/NP811_BOARD/NP811_BOARD_B01.v
 #------------------------------
 #  PFPGA
 #------------------------------
 vlog -work work -novopt ../CTRL_STATION/NP811_BOARD/NP811_PFPGA/NP811_U1_B01.v
 
 vlog -work work -novopt ../CTRL_STATION/NP811_BOARD/NP811_PFPGA/Communication/*.v
 vlog -work work -novopt ../CTRL_STATION/NP811_BOARD/NP811_PFPGA/console/*.v
 vlog -work work -novopt ../CTRL_STATION/NP811_BOARD/NP811_PFPGA/initial/*.v
 vlog -work work -novopt ../CTRL_STATION/NP811_BOARD/NP811_PFPGA/process/*.v
 vlog -work work -novopt ../CTRL_STATION/NP811_BOARD/NP811_PFPGA/sync/*.v
 vlog -work work -novopt ../CTRL_STATION/NP811_BOARD/NP811_PFPGA/token/*.v
 vlog -work work -novopt ../CTRL_STATION/NP811_BOARD/NP811_PFPGA/pll/*.v

 vlog -work work -novopt ../CTRL_STATION/NP811_BOARD/NP811_PFPGA/led/*.v


 #------------------------------
 #  DFPGA
 #------------------------------ 
 vlog -work work -novopt ../CTRL_STATION/NP811_BOARD/NP811_DFPGA/NP811_U3_B01.v
 
 
 #------------------------------
 #  AFPGA
 #------------------------------
 vlog -work work -novopt ../CTRL_STATION/NP811_BOARD/AFPGA/*.v 
 

#==============================================
#  CM811   Point to Point communcation Module
#==============================================

vlog -work work -novopt ../CTRL_STATION/CM811_BOARD/CM811_BOARD_B01.v               
#------------------------------                                                     
#  PFPGA                                                                            
#------------------------------                                                     
vlog -work work -novopt ../CTRL_STATION/CM811_BOARD/CM811_PFPGA/CM811_UT4_B01.v  
vlog -work work -novopt ../CTRL_STATION/CM811_BOARD/CM811_PFPGA/bus/c_link/*.v   
vlog -work work -novopt ../CTRL_STATION/CM811_BOARD/CM811_PFPGA/cm811_clink_para/*.v 
vlog -work work -novopt ../CTRL_STATION/CM811_BOARD/CM811_PFPGA/cm811_init_rtl/*.v  
vlog -work work -novopt ../CTRL_STATION/CM811_BOARD/CM811_PFPGA/eeprom/*.v   
vlog -work work -novopt ../CTRL_STATION/CM811_BOARD/CM811_PFPGA/main_ctrl_cm/*.v   
vlog -work work -novopt ../CTRL_STATION/CM811_BOARD/CM811_PFPGA/console_cm811/*.v                                                                                     
#------------------------------                                                     
#  DFPGA                                                                            
#------------------------------                                                     
vlog -work work -novopt ../CTRL_STATION/CM811_BOARD/CM811_DFPGA/CM811_UT5_B01.v     



#==============================================
#  AI812   Analog Input module
#==============================================
vlog -work work -novopt ../CTRL_STATION/AI812_BOARD/AI812_BOARD_B01.v             
#------------------------------                                                   
#  PFPGA                                                                          
#------------------------------                                                   
vlog -work work -novopt ../CTRL_STATION/AI812_BOARD/AI812_PFPGA/AI812_UT4_B01.v 
vlog -work work -novopt ../CTRL_STATION/AI812_BOARD/AI812_PFPGA/console/*.v 
vlog -work work -novopt ../CTRL_STATION/AI812_BOARD/AI812_PFPGA/init/*.v 
vlog -work work -novopt ../CTRL_STATION/AI812_BOARD/AI812_PFPGA/main_ctrl/*.v 

                                                                                   
#------------------------------                                                   
#  DFPGA                                                                          
#------------------------------                                                   
vlog -work work -novopt ../CTRL_STATION/AI812_BOARD/AI812_DFPGA/AI812_UT5_B01.v   
#==============================================
#  AO811   Analog Output module
#==============================================

vlog -work work -novopt ../CTRL_STATION/AO811_BOARD/AO811_BOARD_B01.v            
#------------------------------                                                  
#  PFPGA                                                                         
#------------------------------                                                  
vlog -work work -novopt ../CTRL_STATION/AO811_BOARD/AO811_PFPGA/AO811_UT4_B01.v 
vlog -work work -novopt ../CTRL_STATION/AO811_BOARD/AO811_PFPGA/console/*.v 
 
                                                                                 
#------------------------------                                                  
#  DFPGA                                                                         
#------------------------------                                                  
vlog -work work -novopt ../CTRL_STATION/AO811_BOARD/AO811_DFPGA/AO811_UT5_B01.v  


#==============================================
#  DI812   Digtal Input module
#==============================================

vlog -work work -novopt ../CTRL_STATION/DI812_BOARD/DI812_BOARD_B01.v                  
#------------------------------                                                        
#  PFPGA                                                                               
#------------------------------                                                        
vlog -work work -novopt ../CTRL_STATION/DI812_BOARD/DI812_PFPGA/DI812_UT4_B01.v 

       
                                                                                       
#------------------------------                                                        
#  DFPGA                                                                               
#------------------------------                                                        
vlog -work work -novopt ../CTRL_STATION/DI812_BOARD/DI812_DFPGA/DI812_UT5_B01.v        
 

#==============================================
#  DO811   Digtal Output module
#==============================================

vlog -work work -novopt ../CTRL_STATION/DO811_BOARD/DO811_BOARD_B01.v              
#------------------------------                                                    
#  PFPGA                                                                           
#------------------------------                                                    
vlog -work work -novopt ../CTRL_STATION/DO811_BOARD/DO811_PFPGA/DO811_UT4_B01.v 
vlog -work work -novopt ../CTRL_STATION/DO811_BOARD/DO811_PFPGA/console/*.v    
                                                                                   
#------------------------------                                                    
#  DFPGA                                                                           
#------------------------------                                                    
vlog -work work -novopt ../CTRL_STATION/DO811_BOARD/DO811_DFPGA/DO811_UT5_B01.v    
                                                                                   






#===================================================================
#  Testbench
#===================================================================

#==============================================
#  Global test module
#==============================================

 vlog -work work -novopt ../tb/rstgen.v
 vlog -work work -novopt ../tb/sysclkgen.v

 vlog -work work -novopt ../tb/tb_IO_RACK.v
 vlog -work work -novopt ../tb/tb_MAIN_RACK.v
 vlog -work work -novopt ../tb/tb_STATION.v
 vlog -work work -novopt ../tb/tb_SYSTEM.v


#==============================================
#  Engineer station
#==============================================

 vlog -work work -novopt ../tb/tb_engineer_station/*v








#===================================================================
#= Simulate
#===================================================================

#write format wave -window .main_pane.wave.interior.cs.body.pw.wf E:/SDR/RTL_SIM/HDR_SYNC_CODING/verify_rtl/wave.do


#vsim -novopt -t 100ps   -L xilinxcorelib -L xilinxcorelib_ver tb_top
vsim -novopt -L actel -t ps work.tb_SYSTEM 

set NumericStdNoWarnings 1
set StdArithNoWarnings 1
onbreak { resume }

#log -r tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_NP811_BOARD_B01/u1_NP811_U1_B01/process/*
#log -r tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_NP811_BOARD_B01/u1_NP811_U1_B01/console/*
#
#log -r /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_CM811_BOARD_B01/u_CM811_UT4_B01/console_CM/*
#
#log -r /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u2_CM811_BOARD_B01/u_CM811_UT4_B01/console_CM/*
#
#log -r /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DI812_BOARD_B01/u_DI812_UT4_B01/console_I/*
#
#log -r /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_DO811_BOARD_B01/u_DO811_UT4_B01/console_DO/*
#
#log -r /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_AI812_BOARD_B01/u_AI812_UT4_B01/console_I/*
#
##log -r /tb_SYSTEM/u1_tb_STATION/u1_tb_MAIN_RACK/u1_AO811_BOARD_B01/u_AO811_UT4_B01/console_AO/*


#log -r /*
#add log -r /*

do wave.do
#do mem.do


run 30ms


#quit -sim
#del vsim.wlf