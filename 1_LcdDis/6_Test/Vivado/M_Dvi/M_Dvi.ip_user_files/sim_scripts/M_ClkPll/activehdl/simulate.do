onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+M_ClkPll -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.M_ClkPll xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {M_ClkPll.udo}

run -all

endsim

quit -force
