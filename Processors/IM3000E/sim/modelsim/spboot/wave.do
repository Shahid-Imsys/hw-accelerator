onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /spboot_tb/top0/HCLK
add wave -noupdate /spboot_tb/top0/MRESET
add wave -noupdate /spboot_tb/top0/vdd_bmem
add wave -noupdate /spboot_tb/top0/VCC18LP
add wave -noupdate /spboot_tb/top0/rxout
add wave -noupdate /spboot_tb/top0/MTEST
add wave -noupdate /spboot_tb/top0/MBYPASS
add wave -noupdate /spboot_tb/top0/MIRQ0
add wave -noupdate /spboot_tb/top0/MIRQ1
add wave -noupdate /spboot_tb/top0/MSDIN
add wave -noupdate /spboot_tb/top0/adc_bits
add wave -noupdate /spboot_tb/top0/MWAKEUP_LP
add wave -noupdate /spboot_tb/top0/MLP_PWR_OK
add wave -noupdate /spboot_tb/top0/pwr_ok
add wave -noupdate /spboot_tb/top0/PD
add wave -noupdate /spboot_tb/top0/PC
add wave -noupdate /spboot_tb/top0/PB
add wave -noupdate /spboot_tb/top0/PA
add wave -noupdate /spboot_tb/top0/PF
add wave -noupdate /spboot_tb/top0/PG
add wave -noupdate /spboot_tb/top0/PH
add wave -noupdate /spboot_tb/top0/D_DQ
add wave -noupdate /spboot_tb/top0/PI
add wave -noupdate /spboot_tb/top0/PJ
add wave -noupdate /spboot_tb/top0/PE
add wave -noupdate /spboot_tb/stim/Progress
add wave -noupdate /spboot_tb/top0/mrstout_o
add wave -noupdate /spboot_tb/MRSTOUT
add wave -noupdate /spboot_tb/top0/MCKOUT0
add wave -noupdate /spboot_tb/top0/rst_cn
add wave -noupdate /spboot_tb/top0/clk_gen0/clk_s
add wave -noupdate /spboot_tb/top0/core1/din_s
add wave -noupdate /spboot_tb/top0/core1/speed_s
add wave -noupdate /spboot_tb/top0/core1/even_c
add wave -noupdate /spboot_tb/top0/core1/tim/gate_s
add wave -noupdate /spboot_tb/top0/core1/tim/even_c
add wave -noupdate /spboot_tb/top0/core1/en_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {405 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 470
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
WaveRestoreZoom {0 ps} {20955 ps}
