onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ospi_tb/DUT/clk_p
add wave -noupdate /ospi_tb/DUT/clk_i_pos
add wave -noupdate /ospi_tb/DUT/rst_n
add wave -noupdate -radix hexadecimal /ospi_tb/DUT/idi
add wave -noupdate -radix hexadecimal /ospi_tb/DUT/ido
add wave -noupdate /ospi_tb/DUT/iden
add wave -noupdate /ospi_tb/DUT/ilioa
add wave -noupdate /ospi_tb/DUT/ildout
add wave -noupdate /ospi_tb/DUT/inext
add wave -noupdate /ospi_tb/DUT/idack
add wave -noupdate /ospi_tb/DUT/idreq
add wave -noupdate -expand /ospi_tb/DUT/OSPI_Out
add wave -noupdate -radix hexadecimal /ospi_tb/DUT/OSPI_DQ
add wave -noupdate /ospi_tb/DUT/OSPI_RWDS
add wave -noupdate /ospi_tb/DUT/cmd_wr
add wave -noupdate /ospi_tb/DUT/addr_wr
add wave -noupdate /ospi_tb/DUT/data_wr
add wave -noupdate /ospi_tb/DUT/flags_wr
add wave -noupdate /ospi_tb/DUT/latency_wr
add wave -noupdate /ospi_tb/DUT/cmd_rd
add wave -noupdate /ospi_tb/DUT/addr_rd
add wave -noupdate /ospi_tb/DUT/data_rd
add wave -noupdate /ospi_tb/DUT/flags_rd
add wave -noupdate /ospi_tb/DUT/latency_rd
add wave -noupdate /ospi_tb/DUT/flags_out
add wave -noupdate /ospi_tb/DUT/cmd_sel
add wave -noupdate /ospi_tb/DUT/addr_sel
add wave -noupdate /ospi_tb/DUT/data_sel
add wave -noupdate /ospi_tb/DUT/flags_sel
add wave -noupdate /ospi_tb/DUT/latency_sel
add wave -noupdate /ospi_tb/DUT/iobus_rdindex
add wave -noupdate /ospi_tb/DUT/cmd_reg
add wave -noupdate /ospi_tb/DUT/addr_reg
add wave -noupdate /ospi_tb/DUT/flags_reg
add wave -noupdate /ospi_tb/DUT/latency_reg
add wave -noupdate /ospi_tb/DUT/ospi_wrdata
add wave -noupdate /ospi_tb/DUT/new_cmd
add wave -noupdate /ospi_tb/DUT/ospi_fsm
add wave -noupdate /ospi_tb/DUT/ospi_counter
add wave -noupdate /ospi_tb/DUT/ospi_latency
add wave -noupdate /ospi_tb/DUT/ospi_length
add wave -noupdate /ospi_tb/DUT/ospi_cmd
add wave -noupdate /ospi_tb/DUT/ospi_addr
add wave -noupdate /ospi_tb/DUT/ospi_flags
add wave -noupdate /ospi_tb/DUT/flag_done
add wave -noupdate /ospi_tb/DUT/ospi_rddata
add wave -noupdate /ospi_tb/DUT/ospi_rdindex
add wave -noupdate /ospi_tb/DUT/ospi_wrindex
add wave -noupdate /ospi_tb/DUT/ospi_rwds_p
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {274890 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 212
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
configure wave -timelineunits ns
update
WaveRestoreZoom {212390 ps} {305132 ps}
