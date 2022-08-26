onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib eth_tx_fifo_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {eth_tx_fifo.udo}

run -all

quit -force
