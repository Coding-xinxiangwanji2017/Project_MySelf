onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+M_DdrCtrl -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.M_DdrCtrl xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {M_DdrCtrl.udo}

run -all

endsim

quit -force
