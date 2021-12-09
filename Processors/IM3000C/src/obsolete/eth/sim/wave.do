onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/rst_en
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/iclk
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/ilioa
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/ildout
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/inext
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/id
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/ido_eth
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/iden_eth
add wave -noupdate -format Logic -height 15 -radix hexadecimal /eth_tb/idreq(1)
add wave -noupdate -format Logic -height 15 -radix hexadecimal /eth_tb/idack(1)
add wave -noupdate -format Logic -height 15 -radix hexadecimal /eth_tb/idreq(3)
add wave -noupdate -format Logic -height 15 -radix hexadecimal /eth_tb/idack(3)
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/rxclk
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/txclk
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/rxdv
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/rxer
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/rxd
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/txen
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/txer
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/col
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/crs
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/txd
add wave -noupdate -divider eth_rx
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_reg_sel
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_reg_wr
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_reg_rd
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_da_sel
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_da_wr
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_sts_sel
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_sts_rd
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/rx_reg
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_go
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_reset
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/xreset
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/promiscuous
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/multicast
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/early_er_rst
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/early_er
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/rx_state
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/ifg_count
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/ifg_ok
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/wait_7
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/crc_ok_delay
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/adr_ok
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_empty_sync
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_full_sync
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/sts_full_sync
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/store_sts
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/add_byte
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/align_er
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/crc_er
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/overrun
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/mii_er
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/clear_rx_logic
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/start_rx_logic
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_find_adr
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/req_en
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rxd_reg
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/eq_sfd
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/tip
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/early_er_i
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/adr_wctr
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/adr_rctr
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/adr_mem
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/adr_data
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/eqff_all
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/eqmc_1st
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/eqda_all
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/eqff_this
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/eqmc_this
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/eqda_this
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/eq_ff
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/eq_mc
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/eq_da
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/rx_fifo
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/rx_dout
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/rx_wctr
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/rx_rctr
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/rx_count
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_wctr1_i
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_wctr1_i2
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_full
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_empty
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/rx_aempty
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/sts_fifo
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/sts_dout
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/sts_wctr
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/sts_rctr
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/sts_count
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/sts_wctr0_i
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/sts_wctr0_i2
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/sts_full
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/sts_empty
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/frame_sts
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/nibb_count
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/legal
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/odd_nibb
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/odd_byte
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_rx1/crc
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_rx1/crc_ok
add wave -noupdate -divider eth_tx
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/tx_reg_sel
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/tx_reg_wr
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_tx1/tx_reg
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/syn_reset
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/set_go
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/full_dpx
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/dma_en
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/go_i
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/go_tx
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/go_tx2
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/rst_tx
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/rst_tx2
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/collision
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_tx1/tx_state
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/valid_col
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/valid_crs
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_tx1/gctr
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/tx_done
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/preamble_5
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/preamble_8
add wave -noupdate -format Logic /eth_tb/eth/eth_tx1/tx_read
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/crc_gen
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_tx1/tx_fifo
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/fifo_reset
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_tx1/tx_dout
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_tx1/tx_wctr
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_tx1/tx_rctr
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_tx1/tx_count_i
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/tx_rctr1_i
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/tx_rctr1_i2
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/tx_full
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/tx_afull
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_tx1/tx_length
add wave -noupdate -format Logic -radix hexadecimal /eth_tb/eth/eth_tx1/tx_aempty
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_tx1/crcx
add wave -noupdate -format Literal -radix hexadecimal /eth_tb/eth/eth_tx1/crc_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
WaveRestoreZoom {0 ns} {2633 ns}
configure wave -namecolwidth 211
configure wave -valuecolwidth 40
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
