onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /dac_tb/clk_p
add wave -noupdate -format Logic /dac_tb/rst_n
add wave -noupdate -format Logic /dac_tb/clk_a
add wave -noupdate -format Logic /dac_tb/pulse
add wave -noupdate -format Literal /dac_tb/ain
add wave -noupdate -format Logic /dac_tb/input
add wave -noupdate -format Logic /dac_tb/fb
add wave -noupdate -format Logic /dac_tb/clk_en
add wave -noupdate -format Literal -radix hexadecimal /dac_tb/output
add wave -noupdate -format Literal -radix hexadecimal /dac_tb/sample
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31365 ns} 0}
WaveRestoreZoom {0 ns} {105 us}
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
