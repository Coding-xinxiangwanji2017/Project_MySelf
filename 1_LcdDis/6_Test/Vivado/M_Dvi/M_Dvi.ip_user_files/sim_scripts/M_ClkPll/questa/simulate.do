onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib M_ClkPll_opt

do {wave.do}

view wave
view structure
view signals

do {M_ClkPll.udo}

run -all

quit -force
