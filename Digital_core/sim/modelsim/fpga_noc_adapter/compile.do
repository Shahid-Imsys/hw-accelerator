
vcom -reportprogress 300 -work work ../../../../Processors/IM3000E/src/gp_pkg.vhd

vcom -reportprogress 300 -work work -2008 ../../../../Digital_core/src/sync_fifo.vhd
vcom -reportprogress 300 -work work ../../../../Digital_core/src/ionoc.vhd
vcom -reportprogress 300 -work work ../../../../Digital_core/src/fpga_noc_adapter.vhd

vcom -reportprogress 300 -work work ../../../../Digital_core/tb/fpga_noc_adapter_tb/fpga_noc_adapter_tb.vhd
