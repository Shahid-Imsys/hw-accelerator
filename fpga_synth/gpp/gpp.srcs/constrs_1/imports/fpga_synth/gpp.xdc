
# create_generated_clock -name ld_bmem -divide_by 2 [get_pins {core1/crb/ld_bmem_reg/Q}] -source [get_ports HCLK]

set_property PACKAGE_PIN AY9 [get_ports {OSPI_Out[CK_p]}]
set_property PACKAGE_PIN BA9 [get_ports {OSPI_Out[CK_n]}]
set_property PACKAGE_PIN BE12 [get_ports {OSPI_Out[CS_n]}]
set_property PACKAGE_PIN BF10 [get_ports {OSPI_Out[RESET_n]}]
set_property PACKAGE_PIN BD12 [get_ports OSPI_RWDS]
set_property PACKAGE_PIN BD13 [get_ports {OSPI_DQ[0]}]
set_property PACKAGE_PIN BE13 [get_ports {OSPI_DQ[1]}]
set_property PACKAGE_PIN BB13 [get_ports {OSPI_DQ[2]}]
set_property PACKAGE_PIN BB12 [get_ports {OSPI_DQ[3]}]
set_property PACKAGE_PIN BE14 [get_ports {OSPI_DQ[4]}]
set_property PACKAGE_PIN BF14 [get_ports {OSPI_DQ[5]}]
set_property PACKAGE_PIN BA14 [get_ports {OSPI_DQ[6]}]
set_property PACKAGE_PIN BB14 [get_ports {OSPI_DQ[7]}]
set_property PACKAGE_PIN BE15 [get_ports MCKOUT0]
set_property PACKAGE_PIN BF9 [get_ports MRESET]
set_property PACKAGE_PIN BF15 [get_ports MSDIN]
set_property PACKAGE_PIN BC14 [get_ports MSDOUT]
set_property PACKAGE_PIN BC15 [get_ports MIRQ0]
set_property PACKAGE_PIN BC13 [get_ports MIRQOUT]
set_property PACKAGE_PIN BA37 [get_ports {LED[7]}]
set_property PACKAGE_PIN AV36 [get_ports {LED[6]}]
set_property PACKAGE_PIN AU37 [get_ports {LED[5]}]
set_property PACKAGE_PIN BF32 [get_ports {LED[4]}]
set_property PACKAGE_PIN BB32 [get_ports {LED[3]}]
set_property PACKAGE_PIN AY30 [get_ports {LED[2]}]
set_property PACKAGE_PIN AV34 [get_ports {LED[1]}]
set_property PACKAGE_PIN AT32 [get_ports {LED[0]}]

set_property PACKAGE_PIN BB16 [get_ports OE_CTR]
set_property PACKAGE_PIN AP13 [get_ports PA6_SCK]
set_property PACKAGE_PIN AR13 [get_ports PA5_CS_N]
set_property PACKAGE_PIN AV10 [get_ports PA0_SIN]
set_property PACKAGE_PIN AW10 [get_ports PA7_SOUT]
set_property PACKAGE_PIN AK13 [get_ports ENET_TXD3]
set_property PACKAGE_PIN AK14 [get_ports ENET_TXD2]
set_property PACKAGE_PIN AM12 [get_ports ENET_TXD1]
set_property PACKAGE_PIN AM13 [get_ports ENET_TXD0]
set_property PACKAGE_PIN AV13 [get_ports ENET_TXCTL]
set_property PACKAGE_PIN AV14 [get_ports ENET_TXCLK]
set_property PACKAGE_PIN AJ12 [get_ports ENET_RXD3]
set_property PACKAGE_PIN AJ13 [get_ports ENET_RXD2]
set_property PACKAGE_PIN AL12 [get_ports ENET_RXD1]
set_property PACKAGE_PIN AK12 [get_ports ENET_RXD0]
set_property PACKAGE_PIN AT14 [get_ports ENET_RXCTL]
set_property PACKAGE_PIN AR14 [get_ports ENET_RXCLK]
set_property PACKAGE_PIN BD15 [get_ports ENET_RST_N]
set_property PACKAGE_PIN BD11 [get_ports ENET_MDIO]
set_property PACKAGE_PIN BC11 [get_ports ENET_MDC]
set_property PACKAGE_PIN AW8 [get_ports {TEST_OUTP[0]}]
set_property PACKAGE_PIN AW7 [get_ports {TEST_OUTP[1]}]
set_property PACKAGE_PIN AP12 [get_ports {TEST_OUTP[2]}]
set_property PACKAGE_PIN AR12 [get_ports {TEST_OUTP[3]}]
set_property PACKAGE_PIN AL14 [get_ports {TEST_OUTP[4]}]
set_property PACKAGE_PIN AM14 [get_ports {TEST_OUTP[5]}]
set_property PACKAGE_PIN AY8 [get_ports {TEST_OUTP[6]}]
set_property PACKAGE_PIN AY7 [get_ports {TEST_OUTP[7]}]
set_property PACKAGE_PIN AN16 [get_ports {TEST_OUTP[8]}]
set_property PACKAGE_PIN AP16 [get_ports {TEST_OUTP[9]}]
set_property PACKAGE_PIN AK15 [get_ports {TEST_OUTP[10]}]
set_property PACKAGE_PIN AL15 [get_ports {TEST_OUTP[11]}]
set_property PACKAGE_PIN AV9 [get_ports {TEST_OUTP[12]}]
set_property PACKAGE_PIN AV8 [get_ports {TEST_OUTP[13]}]
set_property PACKAGE_PIN AW11 [get_ports {TEST_OUTP[14]}]
set_property PACKAGE_PIN AY10 [get_ports {TEST_OUTP[15]}]
set_property PACKAGE_PIN BC9 [get_ports URX]
set_property PACKAGE_PIN BC8 [get_ports UTX]

set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TEST_OUTP[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_DQ[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports MSDOUT]
set_property IOSTANDARD LVCMOS18 [get_ports OE_CTR]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_Out[CK_n]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_Out[CK_p]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_Out[CS_n]}]
set_property IOSTANDARD LVCMOS18 [get_ports {OSPI_Out[RESET_n]}]
set_property IOSTANDARD LVCMOS18 [get_ports OSPI_RWDS]
set_property IOSTANDARD LVCMOS18 [get_ports PA0_SIN]
set_property IOSTANDARD LVCMOS18 [get_ports PA5_CS_N]
set_property IOSTANDARD LVCMOS18 [get_ports PA6_SCK]
set_property IOSTANDARD LVCMOS18 [get_ports PA7_SOUT]
set_property IOSTANDARD LVCMOS18 [get_ports URX]
set_property IOSTANDARD LVCMOS18 [get_ports UTX]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_TXCTL]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_TXD0]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_TXD1]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_TXD2]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_TXD3]
set_property IOSTANDARD LVCMOS18 [get_ports MCKOUT0]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_MDC]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_MDIO]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RST_N]
set_property IOSTANDARD LVCMOS18 [get_ports MIRQOUT]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RXCLK]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RXCTL]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RXD0]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RXD1]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RXD2]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_RXD3]
set_property IOSTANDARD LVCMOS18 [get_ports ENET_TXCLK]
set_property IOSTANDARD LVCMOS18 [get_ports MIRQ0]
set_property IOSTANDARD LVCMOS18 [get_ports MRESET]
set_property IOSTANDARD LVCMOS18 [get_ports MSDIN]

set_property PACKAGE_PIN AY14 [get_ports {pmod0_in[0]}]
set_property PACKAGE_PIN AY15 [get_ports {pmod0_in[1]}]
set_property PACKAGE_PIN AW15 [get_ports {pmod0_in[2]}]
set_property PACKAGE_PIN AV15 [get_ports {pmod0_out[3]}]
set_property PACKAGE_PIN AV16 [get_ports {pmod0_out[4]}]

set_property IOSTANDARD LVCMOS18 [get_ports {pmod0_in[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {pmod0_in[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {pmod0_in[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {pmod0_out[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {pmod0_out[4]}]

# No PMOD is clock capable, so override this requirement. Should be ok, the SPI clock is slow.
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {pmod0_in_IBUF[0]_inst/O}]

create_clock -period 20.000 -name ENET_TXCLK -waveform {0.000 10.000} [get_ports ENET_TXCLK]
set_clock_groups -name ENET_TXCLK -asynchronous -group [get_clocks ENET_TXCLK]

create_clock -period 20.000 -name ENET_RXCLK -waveform {0.000 10.000} [get_ports ENET_RXCLK]
set_clock_groups -name ENET_RXCLK -asynchronous -group [get_clocks ENET_RXCLK]

create_clock -period 100.000 -name SPI_SCK -waveform {0.000 50.000} [get_ports {pmod0_in[0]}]
set_clock_groups -name SPI_CLK -asynchronous -group [get_clocks SPI_SCK]


set_input_delay -clock [get_clocks ENET_RXCLK] -min -add_delay 3.000 [get_ports ENET_RXCTL]
set_input_delay -clock [get_clocks ENET_RXCLK] -min -add_delay 3.000 [get_ports ENET_RXD0]
set_input_delay -clock [get_clocks ENET_RXCLK] -min -add_delay 3.000 [get_ports ENET_RXD1]
set_input_delay -clock [get_clocks ENET_RXCLK] -min -add_delay 3.000 [get_ports ENET_RXD3]

set_input_delay -clock [get_clocks ENET_RXCLK] -max -add_delay 5.000 [get_ports ENET_RXCTL]
set_input_delay -clock [get_clocks ENET_RXCLK] -max -add_delay 5.000 [get_ports ENET_RXD0]
set_input_delay -clock [get_clocks ENET_RXCLK] -max -add_delay 5.000 [get_ports ENET_RXD1]
set_input_delay -clock [get_clocks ENET_RXCLK] -max -add_delay 5.000 [get_ports ENET_RXD3]

set_output_delay -clock [get_clocks ENET_TXCLK] -min -add_delay -2.000 [get_ports ENET_TXCTL]
set_output_delay -clock [get_clocks ENET_TXCLK] -min -add_delay -2.000 [get_ports ENET_TXD0]
set_output_delay -clock [get_clocks ENET_TXCLK] -min -add_delay -2.000 [get_ports ENET_TXD1]
set_output_delay -clock [get_clocks ENET_TXCLK] -min -add_delay -2.000 [get_ports ENET_TXD3]

set_output_delay -clock [get_clocks ENET_TXCLK] -max -add_delay 5.000 [get_ports ENET_TXCTL]
set_output_delay -clock [get_clocks ENET_TXCLK] -max -add_delay 5.000 [get_ports ENET_TXD0]
set_output_delay -clock [get_clocks ENET_TXCLK] -max -add_delay 5.000 [get_ports ENET_TXD1]
set_output_delay -clock [get_clocks ENET_TXCLK] -max -add_delay 5.000 [get_ports ENET_TXD3]

# CS
#set_input_delay -clock [get_clocks SPI_SCK] -min -add_delay 48.000 [get_ports {pmod0_in[1]}]
#set_input_delay -clock [get_clocks SPI_SCK] -max -add_delay 52.000 [get_ports {pmod0_in[1]}]

# MOSI
#set_input_delay -clock [get_clocks SPI_SCK] -min -add_delay 48.000 [get_ports {pmod0_in[2]}]
#set_input_delay -clock [get_clocks SPI_SCK] -max -add_delay 52.000 [get_ports {pmod0_in[2]}]




#set_output_delay -clock [get_clocks SPI_SCK] 1.000 [get_ports {pmod0_out[*]}]

# set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay 1.000 [get_ports {OSPI_DQ[*]}]
#set_input_delay -clock [get_clocks -of_objects [get_pins fpga_pll_inst/inst/mmcme4_adv_inst/CLKOUT1]] -min -add_delay 1.000 [get_ports OSPI_RWDS]
set_input_delay -clock [get_clocks clk_100M_clk_wiz_0] -max 2.000 [get_ports {OSPI_DQ[*]}]
set_input_delay -clock [get_clocks clk_100M_clk_wiz_0] -max 2.000 [get_ports OSPI_RWDS]


set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] 1.000 [get_ports {OSPI_DQ[*]}]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] 1.000 [get_ports OSPI_RWDS]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] 1.000 [get_ports {OSPI_Out[*]}]
#set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports {OSPI_DQ[*]}]
#set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports OSPI_RWDS]
#set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports {OSPI_Out[*]}]
#set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay -0.250 [get_ports {OSPI_DQ[*]}]
#set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay -0.250 [get_ports OSPI_RWDS]
#set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay -0.250 [get_ports {OSPI_Out[*]}]


set_input_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay 2.000 [get_ports ENET_MDIO]
set_input_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 5.000 [get_ports ENET_MDIO]

set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports ENET_MDIO]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay -0.100 [get_ports ENET_MDIO]

set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports ENET_MDC]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay -0.100 [get_ports ENET_MDC]

#set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports ENET_RST_N]
#set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 0.500 [get_ports ENET_RST_N]

set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports PA0_SIN]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 0.100 [get_ports PA0_SIN]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports PA5_CS_N]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 0.100 [get_ports PA5_CS_N]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports PA6_SCK]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 0.100 [get_ports PA6_SCK]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports PA7_SOUT]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 0.100 [get_ports PA7_SOUT]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -min -add_delay -1.000 [get_ports URX]
set_output_delay -clock [get_clocks clk_100M_clk_wiz_0] -max -add_delay 0.100 [get_ports URX]

# SPI CS to OE
set_false_path -from [get_ports {pmod0_in[1]}] -to [get_ports {pmod0_out[4]}]


# Ports
set_false_path -to [get_ports *LED*]

set_false_path -from [get_ports URX]
set_false_path -from [get_ports UTX]
set_false_path -from [get_ports MRESET]
set_false_path -from [get_ports MIRQ0]
set_false_path -from [get_ports MSDIN]

set_false_path -to [get_ports URX]
set_false_path -to [get_ports UTX]
set_false_path -to [get_ports MCKOUT0]
set_false_path -to [get_ports MSDOUT]
set_false_path -to [get_ports MIRQOUT]

set_false_path -to [get_ports ENET_RST_N]




create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 16384 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 1 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list fpga_pll_inst/inst/clk_50M]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/dbus[0]} {digital_top_inst/i_digital_core/i_im4000_top/dbus[1]} {digital_top_inst/i_digital_core/i_im4000_top/dbus[2]} {digital_top_inst/i_digital_core/i_im4000_top/dbus[3]} {digital_top_inst/i_digital_core/i_im4000_top/dbus[4]} {digital_top_inst/i_digital_core/i_im4000_top/dbus[5]} {digital_top_inst/i_digital_core/i_im4000_top/dbus[6]} {digital_top_inst/i_digital_core/i_im4000_top/dbus[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/idi[0]} {digital_top_inst/i_digital_core/i_im4000_top/idi[1]} {digital_top_inst/i_digital_core/i_im4000_top/idi[2]} {digital_top_inst/i_digital_core/i_im4000_top/idi[3]} {digital_top_inst/i_digital_core/i_im4000_top/idi[4]} {digital_top_inst/i_digital_core/i_im4000_top/idi[5]} {digital_top_inst/i_digital_core/i_im4000_top/idi[6]} {digital_top_inst/i_digital_core/i_im4000_top/idi[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[0]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[1]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[2]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[3]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[4]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[5]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[6]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[0]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[1]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[2]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[3]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[4]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[5]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[6]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[0]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[1]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[2]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[3]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[4]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[5]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[6]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[7]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[8]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[9]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[10]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[11]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[12]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[13]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[14]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[15]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[16]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[17]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[18]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[19]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[20]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[21]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[22]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[23]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[24]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[25]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[26]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[27]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[28]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[29]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[30]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 2 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_ce[0]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_ce[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 14 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[0]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[1]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[2]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[3]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[4]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[5]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[6]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[7]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[8]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[9]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[10]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[11]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[12]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 2 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/c1_mpram_ce[0]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mpram_ce[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/dirc[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/dirc[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/dirc[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/dirc[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/dirc[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/dirc[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/dirc[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/dirc[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 5 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/st_ctr[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/st_ctr[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/st_ctr[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/st_ctr[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/st_ctr[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 5 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/pl_seqc[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/pl_seqc[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/pl_seqc[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/pl_seqc[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/pl_seqc[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 5 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/st_ctr[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/st_ctr[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/st_ctr[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/st_ctr[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/st_ctr[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 128 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {digital_top_inst/i_digital_core/NOC_DATA[0]} {digital_top_inst/i_digital_core/NOC_DATA[1]} {digital_top_inst/i_digital_core/NOC_DATA[2]} {digital_top_inst/i_digital_core/NOC_DATA[3]} {digital_top_inst/i_digital_core/NOC_DATA[4]} {digital_top_inst/i_digital_core/NOC_DATA[5]} {digital_top_inst/i_digital_core/NOC_DATA[6]} {digital_top_inst/i_digital_core/NOC_DATA[7]} {digital_top_inst/i_digital_core/NOC_DATA[8]} {digital_top_inst/i_digital_core/NOC_DATA[9]} {digital_top_inst/i_digital_core/NOC_DATA[10]} {digital_top_inst/i_digital_core/NOC_DATA[11]} {digital_top_inst/i_digital_core/NOC_DATA[12]} {digital_top_inst/i_digital_core/NOC_DATA[13]} {digital_top_inst/i_digital_core/NOC_DATA[14]} {digital_top_inst/i_digital_core/NOC_DATA[15]} {digital_top_inst/i_digital_core/NOC_DATA[16]} {digital_top_inst/i_digital_core/NOC_DATA[17]} {digital_top_inst/i_digital_core/NOC_DATA[18]} {digital_top_inst/i_digital_core/NOC_DATA[19]} {digital_top_inst/i_digital_core/NOC_DATA[20]} {digital_top_inst/i_digital_core/NOC_DATA[21]} {digital_top_inst/i_digital_core/NOC_DATA[22]} {digital_top_inst/i_digital_core/NOC_DATA[23]} {digital_top_inst/i_digital_core/NOC_DATA[24]} {digital_top_inst/i_digital_core/NOC_DATA[25]} {digital_top_inst/i_digital_core/NOC_DATA[26]} {digital_top_inst/i_digital_core/NOC_DATA[27]} {digital_top_inst/i_digital_core/NOC_DATA[28]} {digital_top_inst/i_digital_core/NOC_DATA[29]} {digital_top_inst/i_digital_core/NOC_DATA[30]} {digital_top_inst/i_digital_core/NOC_DATA[31]} {digital_top_inst/i_digital_core/NOC_DATA[32]} {digital_top_inst/i_digital_core/NOC_DATA[33]} {digital_top_inst/i_digital_core/NOC_DATA[34]} {digital_top_inst/i_digital_core/NOC_DATA[35]} {digital_top_inst/i_digital_core/NOC_DATA[36]} {digital_top_inst/i_digital_core/NOC_DATA[37]} {digital_top_inst/i_digital_core/NOC_DATA[38]} {digital_top_inst/i_digital_core/NOC_DATA[39]} {digital_top_inst/i_digital_core/NOC_DATA[40]} {digital_top_inst/i_digital_core/NOC_DATA[41]} {digital_top_inst/i_digital_core/NOC_DATA[42]} {digital_top_inst/i_digital_core/NOC_DATA[43]} {digital_top_inst/i_digital_core/NOC_DATA[44]} {digital_top_inst/i_digital_core/NOC_DATA[45]} {digital_top_inst/i_digital_core/NOC_DATA[46]} {digital_top_inst/i_digital_core/NOC_DATA[47]} {digital_top_inst/i_digital_core/NOC_DATA[48]} {digital_top_inst/i_digital_core/NOC_DATA[49]} {digital_top_inst/i_digital_core/NOC_DATA[50]} {digital_top_inst/i_digital_core/NOC_DATA[51]} {digital_top_inst/i_digital_core/NOC_DATA[52]} {digital_top_inst/i_digital_core/NOC_DATA[53]} {digital_top_inst/i_digital_core/NOC_DATA[54]} {digital_top_inst/i_digital_core/NOC_DATA[55]} {digital_top_inst/i_digital_core/NOC_DATA[56]} {digital_top_inst/i_digital_core/NOC_DATA[57]} {digital_top_inst/i_digital_core/NOC_DATA[58]} {digital_top_inst/i_digital_core/NOC_DATA[59]} {digital_top_inst/i_digital_core/NOC_DATA[60]} {digital_top_inst/i_digital_core/NOC_DATA[61]} {digital_top_inst/i_digital_core/NOC_DATA[62]} {digital_top_inst/i_digital_core/NOC_DATA[63]} {digital_top_inst/i_digital_core/NOC_DATA[64]} {digital_top_inst/i_digital_core/NOC_DATA[65]} {digital_top_inst/i_digital_core/NOC_DATA[66]} {digital_top_inst/i_digital_core/NOC_DATA[67]} {digital_top_inst/i_digital_core/NOC_DATA[68]} {digital_top_inst/i_digital_core/NOC_DATA[69]} {digital_top_inst/i_digital_core/NOC_DATA[70]} {digital_top_inst/i_digital_core/NOC_DATA[71]} {digital_top_inst/i_digital_core/NOC_DATA[72]} {digital_top_inst/i_digital_core/NOC_DATA[73]} {digital_top_inst/i_digital_core/NOC_DATA[74]} {digital_top_inst/i_digital_core/NOC_DATA[75]} {digital_top_inst/i_digital_core/NOC_DATA[76]} {digital_top_inst/i_digital_core/NOC_DATA[77]} {digital_top_inst/i_digital_core/NOC_DATA[78]} {digital_top_inst/i_digital_core/NOC_DATA[79]} {digital_top_inst/i_digital_core/NOC_DATA[80]} {digital_top_inst/i_digital_core/NOC_DATA[81]} {digital_top_inst/i_digital_core/NOC_DATA[82]} {digital_top_inst/i_digital_core/NOC_DATA[83]} {digital_top_inst/i_digital_core/NOC_DATA[84]} {digital_top_inst/i_digital_core/NOC_DATA[85]} {digital_top_inst/i_digital_core/NOC_DATA[86]} {digital_top_inst/i_digital_core/NOC_DATA[87]} {digital_top_inst/i_digital_core/NOC_DATA[88]} {digital_top_inst/i_digital_core/NOC_DATA[89]} {digital_top_inst/i_digital_core/NOC_DATA[90]} {digital_top_inst/i_digital_core/NOC_DATA[91]} {digital_top_inst/i_digital_core/NOC_DATA[92]} {digital_top_inst/i_digital_core/NOC_DATA[93]} {digital_top_inst/i_digital_core/NOC_DATA[94]} {digital_top_inst/i_digital_core/NOC_DATA[95]} {digital_top_inst/i_digital_core/NOC_DATA[96]} {digital_top_inst/i_digital_core/NOC_DATA[97]} {digital_top_inst/i_digital_core/NOC_DATA[98]} {digital_top_inst/i_digital_core/NOC_DATA[99]} {digital_top_inst/i_digital_core/NOC_DATA[100]} {digital_top_inst/i_digital_core/NOC_DATA[101]} {digital_top_inst/i_digital_core/NOC_DATA[102]} {digital_top_inst/i_digital_core/NOC_DATA[103]} {digital_top_inst/i_digital_core/NOC_DATA[104]} {digital_top_inst/i_digital_core/NOC_DATA[105]} {digital_top_inst/i_digital_core/NOC_DATA[106]} {digital_top_inst/i_digital_core/NOC_DATA[107]} {digital_top_inst/i_digital_core/NOC_DATA[108]} {digital_top_inst/i_digital_core/NOC_DATA[109]} {digital_top_inst/i_digital_core/NOC_DATA[110]} {digital_top_inst/i_digital_core/NOC_DATA[111]} {digital_top_inst/i_digital_core/NOC_DATA[112]} {digital_top_inst/i_digital_core/NOC_DATA[113]} {digital_top_inst/i_digital_core/NOC_DATA[114]} {digital_top_inst/i_digital_core/NOC_DATA[115]} {digital_top_inst/i_digital_core/NOC_DATA[116]} {digital_top_inst/i_digital_core/NOC_DATA[117]} {digital_top_inst/i_digital_core/NOC_DATA[118]} {digital_top_inst/i_digital_core/NOC_DATA[119]} {digital_top_inst/i_digital_core/NOC_DATA[120]} {digital_top_inst/i_digital_core/NOC_DATA[121]} {digital_top_inst/i_digital_core/NOC_DATA[122]} {digital_top_inst/i_digital_core/NOC_DATA[123]} {digital_top_inst/i_digital_core/NOC_DATA[124]} {digital_top_inst/i_digital_core/NOC_DATA[125]} {digital_top_inst/i_digital_core/NOC_DATA[126]} {digital_top_inst/i_digital_core/NOC_DATA[127]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 128 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {digital_top_inst/i_digital_core/GPP_CMD[0]} {digital_top_inst/i_digital_core/GPP_CMD[1]} {digital_top_inst/i_digital_core/GPP_CMD[2]} {digital_top_inst/i_digital_core/GPP_CMD[3]} {digital_top_inst/i_digital_core/GPP_CMD[4]} {digital_top_inst/i_digital_core/GPP_CMD[5]} {digital_top_inst/i_digital_core/GPP_CMD[6]} {digital_top_inst/i_digital_core/GPP_CMD[7]} {digital_top_inst/i_digital_core/GPP_CMD[8]} {digital_top_inst/i_digital_core/GPP_CMD[9]} {digital_top_inst/i_digital_core/GPP_CMD[10]} {digital_top_inst/i_digital_core/GPP_CMD[11]} {digital_top_inst/i_digital_core/GPP_CMD[12]} {digital_top_inst/i_digital_core/GPP_CMD[13]} {digital_top_inst/i_digital_core/GPP_CMD[14]} {digital_top_inst/i_digital_core/GPP_CMD[15]} {digital_top_inst/i_digital_core/GPP_CMD[16]} {digital_top_inst/i_digital_core/GPP_CMD[17]} {digital_top_inst/i_digital_core/GPP_CMD[18]} {digital_top_inst/i_digital_core/GPP_CMD[19]} {digital_top_inst/i_digital_core/GPP_CMD[20]} {digital_top_inst/i_digital_core/GPP_CMD[21]} {digital_top_inst/i_digital_core/GPP_CMD[22]} {digital_top_inst/i_digital_core/GPP_CMD[23]} {digital_top_inst/i_digital_core/GPP_CMD[24]} {digital_top_inst/i_digital_core/GPP_CMD[25]} {digital_top_inst/i_digital_core/GPP_CMD[26]} {digital_top_inst/i_digital_core/GPP_CMD[27]} {digital_top_inst/i_digital_core/GPP_CMD[28]} {digital_top_inst/i_digital_core/GPP_CMD[29]} {digital_top_inst/i_digital_core/GPP_CMD[30]} {digital_top_inst/i_digital_core/GPP_CMD[31]} {digital_top_inst/i_digital_core/GPP_CMD[32]} {digital_top_inst/i_digital_core/GPP_CMD[33]} {digital_top_inst/i_digital_core/GPP_CMD[34]} {digital_top_inst/i_digital_core/GPP_CMD[35]} {digital_top_inst/i_digital_core/GPP_CMD[36]} {digital_top_inst/i_digital_core/GPP_CMD[37]} {digital_top_inst/i_digital_core/GPP_CMD[38]} {digital_top_inst/i_digital_core/GPP_CMD[39]} {digital_top_inst/i_digital_core/GPP_CMD[40]} {digital_top_inst/i_digital_core/GPP_CMD[41]} {digital_top_inst/i_digital_core/GPP_CMD[42]} {digital_top_inst/i_digital_core/GPP_CMD[43]} {digital_top_inst/i_digital_core/GPP_CMD[44]} {digital_top_inst/i_digital_core/GPP_CMD[45]} {digital_top_inst/i_digital_core/GPP_CMD[46]} {digital_top_inst/i_digital_core/GPP_CMD[47]} {digital_top_inst/i_digital_core/GPP_CMD[48]} {digital_top_inst/i_digital_core/GPP_CMD[49]} {digital_top_inst/i_digital_core/GPP_CMD[50]} {digital_top_inst/i_digital_core/GPP_CMD[51]} {digital_top_inst/i_digital_core/GPP_CMD[52]} {digital_top_inst/i_digital_core/GPP_CMD[53]} {digital_top_inst/i_digital_core/GPP_CMD[54]} {digital_top_inst/i_digital_core/GPP_CMD[55]} {digital_top_inst/i_digital_core/GPP_CMD[56]} {digital_top_inst/i_digital_core/GPP_CMD[57]} {digital_top_inst/i_digital_core/GPP_CMD[58]} {digital_top_inst/i_digital_core/GPP_CMD[59]} {digital_top_inst/i_digital_core/GPP_CMD[60]} {digital_top_inst/i_digital_core/GPP_CMD[61]} {digital_top_inst/i_digital_core/GPP_CMD[62]} {digital_top_inst/i_digital_core/GPP_CMD[63]} {digital_top_inst/i_digital_core/GPP_CMD[64]} {digital_top_inst/i_digital_core/GPP_CMD[65]} {digital_top_inst/i_digital_core/GPP_CMD[66]} {digital_top_inst/i_digital_core/GPP_CMD[67]} {digital_top_inst/i_digital_core/GPP_CMD[68]} {digital_top_inst/i_digital_core/GPP_CMD[69]} {digital_top_inst/i_digital_core/GPP_CMD[70]} {digital_top_inst/i_digital_core/GPP_CMD[71]} {digital_top_inst/i_digital_core/GPP_CMD[72]} {digital_top_inst/i_digital_core/GPP_CMD[73]} {digital_top_inst/i_digital_core/GPP_CMD[74]} {digital_top_inst/i_digital_core/GPP_CMD[75]} {digital_top_inst/i_digital_core/GPP_CMD[76]} {digital_top_inst/i_digital_core/GPP_CMD[77]} {digital_top_inst/i_digital_core/GPP_CMD[78]} {digital_top_inst/i_digital_core/GPP_CMD[79]} {digital_top_inst/i_digital_core/GPP_CMD[80]} {digital_top_inst/i_digital_core/GPP_CMD[81]} {digital_top_inst/i_digital_core/GPP_CMD[82]} {digital_top_inst/i_digital_core/GPP_CMD[83]} {digital_top_inst/i_digital_core/GPP_CMD[84]} {digital_top_inst/i_digital_core/GPP_CMD[85]} {digital_top_inst/i_digital_core/GPP_CMD[86]} {digital_top_inst/i_digital_core/GPP_CMD[87]} {digital_top_inst/i_digital_core/GPP_CMD[88]} {digital_top_inst/i_digital_core/GPP_CMD[89]} {digital_top_inst/i_digital_core/GPP_CMD[90]} {digital_top_inst/i_digital_core/GPP_CMD[91]} {digital_top_inst/i_digital_core/GPP_CMD[92]} {digital_top_inst/i_digital_core/GPP_CMD[93]} {digital_top_inst/i_digital_core/GPP_CMD[94]} {digital_top_inst/i_digital_core/GPP_CMD[95]} {digital_top_inst/i_digital_core/GPP_CMD[96]} {digital_top_inst/i_digital_core/GPP_CMD[97]} {digital_top_inst/i_digital_core/GPP_CMD[98]} {digital_top_inst/i_digital_core/GPP_CMD[99]} {digital_top_inst/i_digital_core/GPP_CMD[100]} {digital_top_inst/i_digital_core/GPP_CMD[101]} {digital_top_inst/i_digital_core/GPP_CMD[102]} {digital_top_inst/i_digital_core/GPP_CMD[103]} {digital_top_inst/i_digital_core/GPP_CMD[104]} {digital_top_inst/i_digital_core/GPP_CMD[105]} {digital_top_inst/i_digital_core/GPP_CMD[106]} {digital_top_inst/i_digital_core/GPP_CMD[107]} {digital_top_inst/i_digital_core/GPP_CMD[108]} {digital_top_inst/i_digital_core/GPP_CMD[109]} {digital_top_inst/i_digital_core/GPP_CMD[110]} {digital_top_inst/i_digital_core/GPP_CMD[111]} {digital_top_inst/i_digital_core/GPP_CMD[112]} {digital_top_inst/i_digital_core/GPP_CMD[113]} {digital_top_inst/i_digital_core/GPP_CMD[114]} {digital_top_inst/i_digital_core/GPP_CMD[115]} {digital_top_inst/i_digital_core/GPP_CMD[116]} {digital_top_inst/i_digital_core/GPP_CMD[117]} {digital_top_inst/i_digital_core/GPP_CMD[118]} {digital_top_inst/i_digital_core/GPP_CMD[119]} {digital_top_inst/i_digital_core/GPP_CMD[120]} {digital_top_inst/i_digital_core/GPP_CMD[121]} {digital_top_inst/i_digital_core/GPP_CMD[122]} {digital_top_inst/i_digital_core/GPP_CMD[123]} {digital_top_inst/i_digital_core/GPP_CMD[124]} {digital_top_inst/i_digital_core/GPP_CMD[125]} {digital_top_inst/i_digital_core/GPP_CMD[126]} {digital_top_inst/i_digital_core/GPP_CMD[127]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 128 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {digital_top_inst/i_digital_core/IO_DATA[0]} {digital_top_inst/i_digital_core/IO_DATA[1]} {digital_top_inst/i_digital_core/IO_DATA[2]} {digital_top_inst/i_digital_core/IO_DATA[3]} {digital_top_inst/i_digital_core/IO_DATA[4]} {digital_top_inst/i_digital_core/IO_DATA[5]} {digital_top_inst/i_digital_core/IO_DATA[6]} {digital_top_inst/i_digital_core/IO_DATA[7]} {digital_top_inst/i_digital_core/IO_DATA[8]} {digital_top_inst/i_digital_core/IO_DATA[9]} {digital_top_inst/i_digital_core/IO_DATA[10]} {digital_top_inst/i_digital_core/IO_DATA[11]} {digital_top_inst/i_digital_core/IO_DATA[12]} {digital_top_inst/i_digital_core/IO_DATA[13]} {digital_top_inst/i_digital_core/IO_DATA[14]} {digital_top_inst/i_digital_core/IO_DATA[15]} {digital_top_inst/i_digital_core/IO_DATA[16]} {digital_top_inst/i_digital_core/IO_DATA[17]} {digital_top_inst/i_digital_core/IO_DATA[18]} {digital_top_inst/i_digital_core/IO_DATA[19]} {digital_top_inst/i_digital_core/IO_DATA[20]} {digital_top_inst/i_digital_core/IO_DATA[21]} {digital_top_inst/i_digital_core/IO_DATA[22]} {digital_top_inst/i_digital_core/IO_DATA[23]} {digital_top_inst/i_digital_core/IO_DATA[24]} {digital_top_inst/i_digital_core/IO_DATA[25]} {digital_top_inst/i_digital_core/IO_DATA[26]} {digital_top_inst/i_digital_core/IO_DATA[27]} {digital_top_inst/i_digital_core/IO_DATA[28]} {digital_top_inst/i_digital_core/IO_DATA[29]} {digital_top_inst/i_digital_core/IO_DATA[30]} {digital_top_inst/i_digital_core/IO_DATA[31]} {digital_top_inst/i_digital_core/IO_DATA[32]} {digital_top_inst/i_digital_core/IO_DATA[33]} {digital_top_inst/i_digital_core/IO_DATA[34]} {digital_top_inst/i_digital_core/IO_DATA[35]} {digital_top_inst/i_digital_core/IO_DATA[36]} {digital_top_inst/i_digital_core/IO_DATA[37]} {digital_top_inst/i_digital_core/IO_DATA[38]} {digital_top_inst/i_digital_core/IO_DATA[39]} {digital_top_inst/i_digital_core/IO_DATA[40]} {digital_top_inst/i_digital_core/IO_DATA[41]} {digital_top_inst/i_digital_core/IO_DATA[42]} {digital_top_inst/i_digital_core/IO_DATA[43]} {digital_top_inst/i_digital_core/IO_DATA[44]} {digital_top_inst/i_digital_core/IO_DATA[45]} {digital_top_inst/i_digital_core/IO_DATA[46]} {digital_top_inst/i_digital_core/IO_DATA[47]} {digital_top_inst/i_digital_core/IO_DATA[48]} {digital_top_inst/i_digital_core/IO_DATA[49]} {digital_top_inst/i_digital_core/IO_DATA[50]} {digital_top_inst/i_digital_core/IO_DATA[51]} {digital_top_inst/i_digital_core/IO_DATA[52]} {digital_top_inst/i_digital_core/IO_DATA[53]} {digital_top_inst/i_digital_core/IO_DATA[54]} {digital_top_inst/i_digital_core/IO_DATA[55]} {digital_top_inst/i_digital_core/IO_DATA[56]} {digital_top_inst/i_digital_core/IO_DATA[57]} {digital_top_inst/i_digital_core/IO_DATA[58]} {digital_top_inst/i_digital_core/IO_DATA[59]} {digital_top_inst/i_digital_core/IO_DATA[60]} {digital_top_inst/i_digital_core/IO_DATA[61]} {digital_top_inst/i_digital_core/IO_DATA[62]} {digital_top_inst/i_digital_core/IO_DATA[63]} {digital_top_inst/i_digital_core/IO_DATA[64]} {digital_top_inst/i_digital_core/IO_DATA[65]} {digital_top_inst/i_digital_core/IO_DATA[66]} {digital_top_inst/i_digital_core/IO_DATA[67]} {digital_top_inst/i_digital_core/IO_DATA[68]} {digital_top_inst/i_digital_core/IO_DATA[69]} {digital_top_inst/i_digital_core/IO_DATA[70]} {digital_top_inst/i_digital_core/IO_DATA[71]} {digital_top_inst/i_digital_core/IO_DATA[72]} {digital_top_inst/i_digital_core/IO_DATA[73]} {digital_top_inst/i_digital_core/IO_DATA[74]} {digital_top_inst/i_digital_core/IO_DATA[75]} {digital_top_inst/i_digital_core/IO_DATA[76]} {digital_top_inst/i_digital_core/IO_DATA[77]} {digital_top_inst/i_digital_core/IO_DATA[78]} {digital_top_inst/i_digital_core/IO_DATA[79]} {digital_top_inst/i_digital_core/IO_DATA[80]} {digital_top_inst/i_digital_core/IO_DATA[81]} {digital_top_inst/i_digital_core/IO_DATA[82]} {digital_top_inst/i_digital_core/IO_DATA[83]} {digital_top_inst/i_digital_core/IO_DATA[84]} {digital_top_inst/i_digital_core/IO_DATA[85]} {digital_top_inst/i_digital_core/IO_DATA[86]} {digital_top_inst/i_digital_core/IO_DATA[87]} {digital_top_inst/i_digital_core/IO_DATA[88]} {digital_top_inst/i_digital_core/IO_DATA[89]} {digital_top_inst/i_digital_core/IO_DATA[90]} {digital_top_inst/i_digital_core/IO_DATA[91]} {digital_top_inst/i_digital_core/IO_DATA[92]} {digital_top_inst/i_digital_core/IO_DATA[93]} {digital_top_inst/i_digital_core/IO_DATA[94]} {digital_top_inst/i_digital_core/IO_DATA[95]} {digital_top_inst/i_digital_core/IO_DATA[96]} {digital_top_inst/i_digital_core/IO_DATA[97]} {digital_top_inst/i_digital_core/IO_DATA[98]} {digital_top_inst/i_digital_core/IO_DATA[99]} {digital_top_inst/i_digital_core/IO_DATA[100]} {digital_top_inst/i_digital_core/IO_DATA[101]} {digital_top_inst/i_digital_core/IO_DATA[102]} {digital_top_inst/i_digital_core/IO_DATA[103]} {digital_top_inst/i_digital_core/IO_DATA[104]} {digital_top_inst/i_digital_core/IO_DATA[105]} {digital_top_inst/i_digital_core/IO_DATA[106]} {digital_top_inst/i_digital_core/IO_DATA[107]} {digital_top_inst/i_digital_core/IO_DATA[108]} {digital_top_inst/i_digital_core/IO_DATA[109]} {digital_top_inst/i_digital_core/IO_DATA[110]} {digital_top_inst/i_digital_core/IO_DATA[111]} {digital_top_inst/i_digital_core/IO_DATA[112]} {digital_top_inst/i_digital_core/IO_DATA[113]} {digital_top_inst/i_digital_core/IO_DATA[114]} {digital_top_inst/i_digital_core/IO_DATA[115]} {digital_top_inst/i_digital_core/IO_DATA[116]} {digital_top_inst/i_digital_core/IO_DATA[117]} {digital_top_inst/i_digital_core/IO_DATA[118]} {digital_top_inst/i_digital_core/IO_DATA[119]} {digital_top_inst/i_digital_core/IO_DATA[120]} {digital_top_inst/i_digital_core/IO_DATA[121]} {digital_top_inst/i_digital_core/IO_DATA[122]} {digital_top_inst/i_digital_core/IO_DATA[123]} {digital_top_inst/i_digital_core/IO_DATA[124]} {digital_top_inst/i_digital_core/IO_DATA[125]} {digital_top_inst/i_digital_core/IO_DATA[126]} {digital_top_inst/i_digital_core/IO_DATA[127]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 8 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 8 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 80 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[9]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[10]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[11]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[12]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[13]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[14]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[15]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[16]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[17]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[18]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[19]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[20]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[21]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[22]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[23]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[24]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[25]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[26]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[27]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[28]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[29]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[30]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[31]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[32]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[33]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[34]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[35]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[36]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[37]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[38]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[39]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[40]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[41]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[42]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[43]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[44]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[45]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[46]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[47]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[48]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[49]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[50]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[51]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[52]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[53]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[54]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[55]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[56]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[57]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[58]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[59]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[60]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[61]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[62]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[63]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[64]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[65]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[66]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[67]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[68]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[69]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[70]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[71]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[72]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[73]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[74]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[75]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[76]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[77]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[78]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[79]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 5 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/pl_seqc[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/pl_seqc[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/pl_seqc[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/pl_seqc[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/pl_seqc[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 8 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/adl[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/adl[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/adl[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/adl[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/adl[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/adl[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/adl[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/adl[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 8 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/dirc[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/dirc[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/dirc[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/dirc[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/dirc[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/dirc[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/dirc[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/dirc[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 8 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/adl[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/adl[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/adl[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/adl[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/adl[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/adl[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/adl[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/adl[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 8 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 8 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 8 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 10 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 8 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 8 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 8 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 8 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 8 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 10 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[7]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[8]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 8 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 8 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 8 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 8 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/c1_d_cs]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/c1_d_we]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/dbl_direct]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/dbl_direct]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/dec_inc_adl]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/dec_inc_adl]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 1 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/alu/flag_yan]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 1 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/alu/flag_yan]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 1 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/alu/flag_yz]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 1 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/alu/flag_yz]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 1 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/g_double]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
set_property port_width 1 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/g_double]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe48]
set_property port_width 1 [get_debug_ports u_ila_0/probe48]
connect_debug_port u_ila_0/probe48 [get_nets [list digital_top_inst/i_digital_core/GPP_CMD_Flag]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe49]
set_property port_width 1 [get_debug_ports u_ila_0/probe49]
connect_debug_port u_ila_0/probe49 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/m_double]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe50]
set_property port_width 1 [get_debug_ports u_ila_0/probe50]
connect_debug_port u_ila_0/probe50 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/m_double]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe51]
set_property port_width 1 [get_debug_ports u_ila_0/probe51]
connect_debug_port u_ila_0/probe51 [get_nets [list digital_top_inst/i_digital_core/NOC_IRQ]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe52]
set_property port_width 1 [get_debug_ports u_ila_0/probe52]
connect_debug_port u_ila_0/probe52 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/seq_des]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe53]
set_property port_width 1 [get_debug_ports u_ila_0/probe53]
connect_debug_port u_ila_0/probe53 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/seq_des]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe54]
set_property port_width 1 [get_debug_ports u_ila_0/probe54]
connect_debug_port u_ila_0/probe54 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/seq_pop_des]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe55]
set_property port_width 1 [get_debug_ports u_ila_0/probe55]
connect_debug_port u_ila_0/probe55 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/seq_pop_des]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe56]
set_property port_width 1 [get_debug_ports u_ila_0/probe56]
connect_debug_port u_ila_0/probe56 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/seq_psh]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe57]
set_property port_width 1 [get_debug_ports u_ila_0/probe57]
connect_debug_port u_ila_0/probe57 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/seq_psh]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe58]
set_property port_width 1 [get_debug_ports u_ila_0/probe58]
connect_debug_port u_ila_0/probe58 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/st_empty]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe59]
set_property port_width 1 [get_debug_ports u_ila_0/probe59]
connect_debug_port u_ila_0/probe59 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/st_empty]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe60]
set_property port_width 1 [get_debug_ports u_ila_0/probe60]
connect_debug_port u_ila_0/probe60 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/st_full]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe61]
set_property port_width 1 [get_debug_ports u_ila_0/probe61]
connect_debug_port u_ila_0/probe61 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/st_full]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe62]
set_property port_width 1 [get_debug_ports u_ila_0/probe62]
connect_debug_port u_ila_0/probe62 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/st_pop]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe63]
set_property port_width 1 [get_debug_ports u_ila_0/probe63]
connect_debug_port u_ila_0/probe63 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/st_pop]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe64]
set_property port_width 1 [get_debug_ports u_ila_0/probe64]
connect_debug_port u_ila_0/probe64 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/st_push]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe65]
set_property port_width 1 [get_debug_ports u_ila_0/probe65]
connect_debug_port u_ila_0/probe65 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/st_push]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_50m]
