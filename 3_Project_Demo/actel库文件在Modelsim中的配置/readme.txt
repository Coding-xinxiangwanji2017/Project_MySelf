

***************************************************************
��ǰĿ¼�� ��vlog��actel����������ԭ�ļ�
actel�ǽ�ԭ�ļ������Ŀ��ļ�

�������沽�������modelsim������ʱ�Զ�����actel�⣬
�����ٷ������ٱ��롣
***************************************************************

��װ���裺
1. ���ļ���actel_lib������PC����Ŀ¼, ����  D:\SIM_LIB\actel_lib
2. �޸�modelsim.ini��ֻ�����ԣ����ļ������·������
     actel = D:\SIM_LIB\actel_lib

��������modelsim.ini����ӵ����ӣ�
; packages.
; ieee = $MODEL_TECH/../vital1995
;
; For compatiblity with previous releases, logical library name vital2000 maps
; to library vital2000 (a different library than library ieee, containing the
; same packages).
; A design should not reference VITAL from both the ieee library and the
; vital2000 library because the vital packages are effectively different.
; A design that references both the ieee and vital2000 libraries must have
; both logical names ieee and vital2000 mapped to the same library, either of
; these:
;   $MODEL_TECH/../ieee
;   $MODEL_TECH/../vital2000
;
verilog = $MODEL_TECH/../verilog
std_developerskit = $MODEL_TECH/../std_developerskit
synopsys = $MODEL_TECH/../synopsys
modelsim_lib = $MODEL_TECH/../modelsim_lib
sv_std = $MODEL_TECH/../sv_std
mtiAvm = $MODEL_TECH/../avm
mtiOvm = $MODEL_TECH/../ovm-2.1.2
mtiUvm = $MODEL_TECH/../uvm-1.1c
mtiUPF = $MODEL_TECH/../upf_lib
mtiPA  = $MODEL_TECH/../pa_lib
floatfixlib = $MODEL_TECH/../floatfixlib
mc2_lib = $MODEL_TECH/../mc2_lib
osvvm = $MODEL_TECH/../osvvm



actel = D:\SIM_LIB\actel_lib\actel
