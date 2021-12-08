onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /dac_tb/clk
add wave -noupdate -format Logic /dac_tb/rst_n
add wave -noupdate -format Literal /dac_tb/data1
add wave -noupdate -format Literal /dac_tb/data2
add wave -noupdate -format Logic /dac_tb/bits1
add wave -noupdate -format Logic /dac_tb/bits2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
WaveRestoreZoom {0 ns} {10500 ns}
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
