

***************************************************************
当前目录中 ，vlog是actel器件描述的原文件
actel是将原文件编译后的库文件

按照下面步骤操作后，modelsim在启动时自动加载actel库，
不需再仿真中再编译。
***************************************************************

安装步骤：
1. 将文件夹actel_lib拷贝到PC本地目录, 例如  D:\SIM_LIB\actel_lib
2. 修改modelsim.ini的只读属性，在文件中添加路径描述
     actel = D:\SIM_LIB\actel_lib

下面是在modelsim.ini中添加的例子：
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
