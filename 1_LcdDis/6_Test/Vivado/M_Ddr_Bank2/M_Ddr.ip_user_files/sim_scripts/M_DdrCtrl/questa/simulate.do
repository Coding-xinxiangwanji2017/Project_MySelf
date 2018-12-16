onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib M_DdrCtrl_opt

do {wave.do}

view wave
view structure
view signals

do {M_DdrCtrl.udo}

run -all

quit -force
