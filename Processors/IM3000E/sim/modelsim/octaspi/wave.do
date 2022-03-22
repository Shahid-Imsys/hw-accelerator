onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /main_tb/top0/peri01/ospi/clk_p
add wave -noupdate /main_tb/top0/peri01/ospi/clk_i_pos
add wave -noupdate -radix hexadecimal -childformat {{/main_tb/top0/peri01/ospi/idi(7) -radix hexadecimal} {/main_tb/top0/peri01/ospi/idi(6) -radix hexadecimal} {/main_tb/top0/peri01/ospi/idi(5) -radix hexadecimal} {/main_tb/top0/peri01/ospi/idi(4) -radix hexadecimal} {/main_tb/top0/peri01/ospi/idi(3) -radix hexadecimal} {/main_tb/top0/peri01/ospi/idi(2) -radix hexadecimal} {/main_tb/top0/peri01/ospi/idi(1) -radix hexadecimal} {/main_tb/top0/peri01/ospi/idi(0) -radix hexadecimal}} -subitemconfig {/main_tb/top0/peri01/ospi/idi(7) {-radix hexadecimal} /main_tb/top0/peri01/ospi/idi(6) {-radix hexadecimal} /main_tb/top0/peri01/ospi/idi(5) {-radix hexadecimal} /main_tb/top0/peri01/ospi/idi(4) {-radix hexadecimal} /main_tb/top0/peri01/ospi/idi(3) {-radix hexadecimal} /main_tb/top0/peri01/ospi/idi(2) {-radix hexadecimal} /main_tb/top0/peri01/ospi/idi(1) {-radix hexadecimal} /main_tb/top0/peri01/ospi/idi(0) {-radix hexadecimal}} /main_tb/top0/peri01/ospi/idi
add wave -noupdate -radix hexadecimal /main_tb/top0/peri01/ospi/ido
add wave -noupdate /main_tb/top0/peri01/ospi/rst_n
add wave -noupdate /main_tb/top0/peri01/ospi/ilioa
add wave -noupdate /main_tb/top0/peri01/ospi/ildout
add wave -noupdate /main_tb/top0/peri01/ospi/iden
add wave -noupdate /main_tb/top0/peri01/ospi/inext
add wave -noupdate /main_tb/top0/peri01/ospi/idack
add wave -noupdate /main_tb/top0/peri01/ospi/idreq
add wave -noupdate -divider {OSPI Interface}
add wave -noupdate /main_tb/top0/peri01/ospi/OSPI_Out
add wave -noupdate /main_tb/top0/peri01/ospi/OSPI_Out.CS_n
add wave -noupdate /main_tb/top0/peri01/ospi/OSPI_Out.CK_p
add wave -noupdate -radix hexadecimal /main_tb/top0/peri01/ospi/OSPI_DQ
add wave -noupdate /main_tb/top0/peri01/ospi/OSPI_RWDS
add wave -noupdate -divider {OSPI Cache}
add wave -noupdate -radix unsigned /main_tb/top0/peri01/ospi/iobus_rdindex
add wave -noupdate /main_tb/top0/peri01/ospi/ospi_rddata
add wave -noupdate /main_tb/top0/peri01/ospi/ospi_rdindex
add wave -noupdate /main_tb/top0/peri01/ospi/ospi_wrindex
add wave -noupdate -divider {OSPI Latency}
add wave -noupdate /main_tb/top0/peri01/ospi/latency_wr
add wave -noupdate /main_tb/top0/peri01/ospi/latency_sel
add wave -noupdate -radix hexadecimal /main_tb/top0/peri01/ospi/latency_reg
add wave -noupdate -divider {OSPI Flags}
add wave -noupdate /main_tb/top0/peri01/ospi/flags_wr
add wave -noupdate /main_tb/top0/peri01/ospi/flags_sel
add wave -noupdate -radix hexadecimal -childformat {{/main_tb/top0/peri01/ospi/flags_reg(7) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_reg(6) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_reg(5) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_reg(4) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_reg(3) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_reg(2) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_reg(1) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_reg(0) -radix hexadecimal}} -subitemconfig {/main_tb/top0/peri01/ospi/flags_reg(7) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_reg(6) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_reg(5) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_reg(4) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_reg(3) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_reg(2) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_reg(1) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_reg(0) {-radix hexadecimal}} /main_tb/top0/peri01/ospi/flags_reg
add wave -noupdate /main_tb/top0/peri01/ospi/flag_done
add wave -noupdate -radix hexadecimal -childformat {{/main_tb/top0/peri01/ospi/flags_out(7) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_out(6) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_out(5) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_out(4) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_out(3) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_out(2) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_out(1) -radix hexadecimal} {/main_tb/top0/peri01/ospi/flags_out(0) -radix hexadecimal}} -subitemconfig {/main_tb/top0/peri01/ospi/flags_out(7) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_out(6) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_out(5) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_out(4) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_out(3) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_out(2) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_out(1) {-radix hexadecimal} /main_tb/top0/peri01/ospi/flags_out(0) {-radix hexadecimal}} /main_tb/top0/peri01/ospi/flags_out
add wave -noupdate -divider {OSPI Cmd}
add wave -noupdate /main_tb/top0/peri01/ospi/cmd_wr
add wave -noupdate /main_tb/top0/peri01/ospi/cmd_sel
add wave -noupdate -radix hexadecimal /main_tb/top0/peri01/ospi/cmd_reg
add wave -noupdate /main_tb/top0/peri01/ospi/new_cmd
add wave -noupdate -divider {OSPI Internal signalling}
add wave -noupdate /main_tb/top0/peri01/ospi/addr_wr
add wave -noupdate /main_tb/top0/peri01/ospi/data_wr
add wave -noupdate /main_tb/top0/peri01/ospi/data_rd
add wave -noupdate /main_tb/top0/peri01/ospi/addr_sel
add wave -noupdate /main_tb/top0/peri01/ospi/data_sel
add wave -noupdate -radix hexadecimal /main_tb/top0/peri01/ospi/addr_reg
add wave -noupdate /main_tb/top0/peri01/ospi/ospi_wrdata
add wave -noupdate -divider {OSPI Logic}
add wave -noupdate /main_tb/top0/peri01/ospi/ospi_fsm
add wave -noupdate -radix unsigned /main_tb/top0/peri01/ospi/ospi_counter
add wave -noupdate -radix unsigned /main_tb/top0/peri01/ospi/ospi_latency
add wave -noupdate -radix unsigned /main_tb/top0/peri01/ospi/ospi_length
add wave -noupdate -radix hexadecimal /main_tb/top0/peri01/ospi/ospi_cmd
add wave -noupdate -radix hexadecimal /main_tb/top0/peri01/ospi/ospi_addr
add wave -noupdate -radix hexadecimal /main_tb/top0/peri01/ospi/ospi_flags
add wave -noupdate /main_tb/top0/peri01/ospi/ospi_rwds_p
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6326472852 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 375
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
WaveRestoreZoom {6325183065 ps} {6329292831 ps}
