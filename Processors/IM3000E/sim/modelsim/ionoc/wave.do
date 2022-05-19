onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ionoc_tb/clk
add wave -noupdate /ionoc_tb/reset_n
add wave -noupdate /ionoc_tb/run
add wave -noupdate /ionoc_tb/fsm
add wave -noupdate /ionoc_tb/fsm_count
add wave -noupdate /ionoc_tb/clk_count
add wave -noupdate -divider {IO bus}
add wave -noupdate /ionoc_tb/DUT/clk_p
add wave -noupdate /ionoc_tb/DUT/clk_i_pos
add wave -noupdate -radix hexadecimal /ionoc_tb/DUT/idi
add wave -noupdate -radix hexadecimal -childformat {{/ionoc_tb/DUT/ido(7) -radix hexadecimal} {/ionoc_tb/DUT/ido(6) -radix hexadecimal} {/ionoc_tb/DUT/ido(5) -radix hexadecimal} {/ionoc_tb/DUT/ido(4) -radix hexadecimal} {/ionoc_tb/DUT/ido(3) -radix hexadecimal} {/ionoc_tb/DUT/ido(2) -radix hexadecimal} {/ionoc_tb/DUT/ido(1) -radix hexadecimal} {/ionoc_tb/DUT/ido(0) -radix hexadecimal}} -subitemconfig {/ionoc_tb/DUT/ido(7) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ido(6) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ido(5) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ido(4) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ido(3) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ido(2) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ido(1) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ido(0) {-height 15 -radix hexadecimal}} /ionoc_tb/DUT/ido
add wave -noupdate /ionoc_tb/DUT/iden
add wave -noupdate /ionoc_tb/DUT/ilioa
add wave -noupdate /ionoc_tb/DUT/ildout
add wave -noupdate /ionoc_tb/DUT/inext
add wave -noupdate /ionoc_tb/DUT/idack
add wave -noupdate /ionoc_tb/DUT/idreq
add wave -noupdate /ionoc_tb/DUT/NOC_IRQ
add wave -noupdate -divider {To NOC Interface}
add wave -noupdate /ionoc_tb/DUT/ionoc_word_pending
add wave -noupdate /ionoc_tb/DUT/GPP_CMD_Flag
add wave -noupdate -radix hexadecimal /ionoc_tb/DUT/GPP_CMD
add wave -noupdate /ionoc_tb/DUT/NOC_CMD_ACK
add wave -noupdate -divider {From NOC}
add wave -noupdate /ionoc_tb/DUT/NOC_CMD_Flag
add wave -noupdate /ionoc_tb/DUT/GPP_CMD_ACK
add wave -noupdate /ionoc_tb/DUT/NOC_CMD_EN
add wave -noupdate -radix hexadecimal -childformat {{/ionoc_tb/DUT/NOC_CMD(7) -radix hexadecimal} {/ionoc_tb/DUT/NOC_CMD(6) -radix hexadecimal} {/ionoc_tb/DUT/NOC_CMD(5) -radix hexadecimal} {/ionoc_tb/DUT/NOC_CMD(4) -radix hexadecimal} {/ionoc_tb/DUT/NOC_CMD(3) -radix hexadecimal} {/ionoc_tb/DUT/NOC_CMD(2) -radix hexadecimal} {/ionoc_tb/DUT/NOC_CMD(1) -radix hexadecimal} {/ionoc_tb/DUT/NOC_CMD(0) -radix hexadecimal}} -subitemconfig {/ionoc_tb/DUT/NOC_CMD(7) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/NOC_CMD(6) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/NOC_CMD(5) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/NOC_CMD(4) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/NOC_CMD(3) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/NOC_CMD(2) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/NOC_CMD(1) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/NOC_CMD(0) {-height 15 -radix hexadecimal}} /ionoc_tb/DUT/NOC_CMD
add wave -noupdate /ionoc_tb/DUT/ionoc_byte_pending
add wave -noupdate -divider status
add wave -noupdate /ionoc_tb/DUT/status_sel
add wave -noupdate /ionoc_tb/DUT/status_wr
add wave -noupdate -radix hexadecimal -childformat {{/ionoc_tb/DUT/ionoc_rdstatus(7) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_rdstatus(6) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_rdstatus(5) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_rdstatus(4) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_rdstatus(3) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_rdstatus(2) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_rdstatus(1) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_rdstatus(0) -radix hexadecimal}} -subitemconfig {/ionoc_tb/DUT/ionoc_rdstatus(7) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_rdstatus(6) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_rdstatus(5) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_rdstatus(4) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_rdstatus(3) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_rdstatus(2) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_rdstatus(1) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_rdstatus(0) {-height 15 -radix hexadecimal}} /ionoc_tb/DUT/ionoc_rdstatus
add wave -noupdate -divider data
add wave -noupdate /ionoc_tb/DUT/data_sel
add wave -noupdate /ionoc_tb/DUT/data_wr
add wave -noupdate /ionoc_tb/DUT/ionoc_rddata
add wave -noupdate -radix hexadecimal -childformat {{/ionoc_tb/DUT/ionoc_wrdata(0) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(1) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(2) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(3) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(4) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(5) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(6) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(7) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(8) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(9) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(10) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(11) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(12) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(13) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(14) -radix hexadecimal} {/ionoc_tb/DUT/ionoc_wrdata(15) -radix hexadecimal}} -subitemconfig {/ionoc_tb/DUT/ionoc_wrdata(0) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(1) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(2) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(3) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(4) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(5) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(6) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(7) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(8) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(9) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(10) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(11) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(12) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(13) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(14) {-height 15 -radix hexadecimal} /ionoc_tb/DUT/ionoc_wrdata(15) {-height 15 -radix hexadecimal}} /ionoc_tb/DUT/ionoc_wrdata
add wave -noupdate -divider <NULL>
add wave -noupdate /ionoc_tb/DUT/data_rd
add wave -noupdate /ionoc_tb/DUT/ionoc_wrindex
add wave -noupdate -divider <NULL>
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {388178 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 219
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
WaveRestoreZoom {0 ps} {588 ns}
