-makelib ies_lib/xil_defaultlib -sv \
  "D:/M_Tool/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/M_Tool/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/M_Tool/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../M_Dvi.srcs/sources_1/ip/M_Dvi_ila/sim/M_Dvi_ila.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

