-makelib ies_lib/xil_defaultlib -sv \
  "D:/M_Tool/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/M_Tool/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../M_Dvi.srcs/sources_1/ip/M_ClkPll/M_ClkPll_clk_wiz.v" \
  "../../../../M_Dvi.srcs/sources_1/ip/M_ClkPll/M_ClkPll.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

