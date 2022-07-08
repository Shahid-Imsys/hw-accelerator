onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpga_noc_adapter_tb/run
add wave -noupdate /fpga_noc_adapter_tb/reset_n
add wave -noupdate /fpga_noc_adapter_tb/fsm_count
add wave -noupdate /fpga_noc_adapter_tb/fsm
add wave -noupdate /fpga_noc_adapter_tb/clk_p
add wave -noupdate /fpga_noc_adapter_tb/clk_i
add wave -noupdate -divider <NULL>
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 309
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
WaveRestoreZoom {1499050 ps} {1499952 ps}
