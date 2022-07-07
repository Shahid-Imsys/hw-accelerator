onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpga_noc_adapter_tb/run
add wave -noupdate /fpga_noc_adapter_tb/reset_n
add wave -noupdate /fpga_noc_adapter_tb/nocclk_period_c
add wave -noupdate /fpga_noc_adapter_tb/nocclk_frequency_c
add wave -noupdate /fpga_noc_adapter_tb/ionoc_status_address
add wave -noupdate /fpga_noc_adapter_tb/ionoc_length_address
add wave -noupdate /fpga_noc_adapter_tb/ionoc_fifo_depth_bits
add wave -noupdate /fpga_noc_adapter_tb/ionoc_datadir_address
add wave -noupdate /fpga_noc_adapter_tb/ionoc_data_address
add wave -noupdate /fpga_noc_adapter_tb/ionoc_cmd_address
add wave -noupdate /fpga_noc_adapter_tb/ionoc_addr_address
add wave -noupdate /fpga_noc_adapter_tb/inext
add wave -noupdate /fpga_noc_adapter_tb/ilioa
add wave -noupdate /fpga_noc_adapter_tb/ildout
add wave -noupdate /fpga_noc_adapter_tb/idreq
add wave -noupdate /fpga_noc_adapter_tb/ido
add wave -noupdate /fpga_noc_adapter_tb/idi
add wave -noupdate /fpga_noc_adapter_tb/iden
add wave -noupdate /fpga_noc_adapter_tb/idack
add wave -noupdate /fpga_noc_adapter_tb/fsm_d
add wave -noupdate /fpga_noc_adapter_tb/fsm_count
add wave -noupdate /fpga_noc_adapter_tb/fsm
add wave -noupdate /fpga_noc_adapter_tb/clock_period_c
add wave -noupdate /fpga_noc_adapter_tb/clock_frequency_c
add wave -noupdate /fpga_noc_adapter_tb/clk_p
add wave -noupdate /fpga_noc_adapter_tb/clk_noc
add wave -noupdate /fpga_noc_adapter_tb/clk_i
add wave -noupdate /fpga_noc_adapter_tb/clk_count
add wave -noupdate /fpga_noc_adapter_tb/NOC_WRITE_REQ
add wave -noupdate /fpga_noc_adapter_tb/NOC_LENGTH
add wave -noupdate /fpga_noc_adapter_tb/NOC_IRQ
add wave -noupdate /fpga_noc_adapter_tb/NOC_IO_DIR
add wave -noupdate /fpga_noc_adapter_tb/NOC_DATA_EN
add wave -noupdate /fpga_noc_adapter_tb/NOC_DATA_DIR
add wave -noupdate /fpga_noc_adapter_tb/NOC_DATA
add wave -noupdate /fpga_noc_adapter_tb/NOC_CMD_Flag
add wave -noupdate /fpga_noc_adapter_tb/NOC_CMD_ACK
add wave -noupdate /fpga_noc_adapter_tb/NOC_CMD
add wave -noupdate /fpga_noc_adapter_tb/NOC_ADDRESS
add wave -noupdate /fpga_noc_adapter_tb/IO_WRITE_ACK
add wave -noupdate /fpga_noc_adapter_tb/IO_DATA
add wave -noupdate /fpga_noc_adapter_tb/GPP_CMD_Flag
add wave -noupdate /fpga_noc_adapter_tb/GPP_CMD_ACK
add wave -noupdate /fpga_noc_adapter_tb/GPP_CMD
add wave -noupdate /fpga_noc_adapter_tb/FIFO_READY
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
