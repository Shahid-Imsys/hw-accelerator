
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








connect_debug_port u_ila_0/probe0 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/noc_cmd[0]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/noc_cmd[1]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/noc_cmd[2]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/noc_cmd[3]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/noc_cmd[4]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/sync_collector[0]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/sync_collector[1]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_we[0]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_we[1]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_we[2]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_we[3]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_addr[0]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_addr[1]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_addr[2]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_addr[3]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_addr[4]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_addr[5]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_addr[6]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_addr[7]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_addr[8]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_addr[9]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_addr[10]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_addr[11]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_addr[12]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[0]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[1]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[2]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[3]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[4]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[5]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[6]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[7]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[8]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[9]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[10]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[11]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[12]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[13]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[14]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[15]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[16]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[17]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[18]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[19]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[20]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[21]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[22]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[23]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[24]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[25]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[26]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[27]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[28]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[29]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[30]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[31]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[32]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[33]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[34]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[35]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[36]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[37]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[38]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[39]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[40]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[41]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[42]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[43]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[44]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[45]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[46]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[47]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[48]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[49]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[50]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[51]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[52]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[53]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[54]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[55]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[56]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[57]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[58]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[59]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[60]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[61]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[62]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[63]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[64]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[65]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[66]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[67]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[68]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[69]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[70]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[71]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[72]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[73]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[74]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[75]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[76]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[77]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[78]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[79]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[80]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[81]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[82]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[83]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[84]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[85]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[86]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[87]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[88]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[89]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[90]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[91]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[92]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[93]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[94]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[95]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[96]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[97]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[98]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[99]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[100]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[101]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[102]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[103]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[104]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[105]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[106]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[107]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[108]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[109]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[110]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[111]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[112]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[113]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[114]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[115]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[116]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[117]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[118]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[119]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[120]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[121]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[122]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[123]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[124]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[125]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[126]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/cmem_din[127]}]]
connect_debug_port u_ila_0/probe19 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/sync_collector[0]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/sync_collector[1]}]]
connect_debug_port u_ila_0/probe20 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/noc_cmd[0]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/noc_cmd[1]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/noc_cmd[2]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/noc_cmd[3]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/noc_cmd[4]}]]
connect_debug_port u_ila_0/probe24 [get_nets [list {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[0]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[1]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[2]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[3]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[4]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[5]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[6]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[7]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[8]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[9]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[10]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[11]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[12]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[13]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[14]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[15]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[16]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[17]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[18]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[19]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[20]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[21]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[22]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[23]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[24]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[25]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[26]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[27]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[28]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[29]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[30]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[31]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[32]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[33]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[34]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[35]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[36]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[37]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[38]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[39]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[40]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[41]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[42]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[43]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[44]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[45]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[46]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[47]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[48]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[49]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[50]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[51]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[52]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[53]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[54]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[55]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[56]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[57]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[58]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[59]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[60]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[61]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[62]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[63]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[64]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[65]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[66]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[67]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[68]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[69]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[70]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[71]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[72]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[73]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[74]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[75]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[76]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[77]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[78]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[79]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[80]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[81]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[82]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[83]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[84]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[85]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[86]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[87]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[88]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[89]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[90]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[91]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[92]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[93]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[94]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[95]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[96]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[97]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[98]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[99]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[100]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[101]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[102]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[103]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[104]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[105]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[106]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[107]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[108]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[109]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[110]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[111]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[112]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[113]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[114]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[115]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[116]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[117]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[118]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[119]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[120]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[121]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[122]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[123]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[124]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[125]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[126]} {digital_top_inst/i_digital_core/noc_adapter_inst/TxFIFO_Data[127]}]]
connect_debug_port u_ila_0/probe25 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_we[0]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_we[1]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_we[2]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_we[3]}]]
connect_debug_port u_ila_0/probe26 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[0]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[1]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[2]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[3]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[4]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[5]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[6]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[7]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[8]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[9]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[10]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[11]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[12]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[13]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[14]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[15]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[16]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[17]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[18]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[19]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[20]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[21]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[22]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[23]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[24]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[25]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[26]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[27]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[28]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[29]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[30]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[31]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[32]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[33]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[34]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[35]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[36]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[37]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[38]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[39]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[40]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[41]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[42]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[43]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[44]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[45]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[46]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[47]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[48]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[49]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[50]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[51]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[52]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[53]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[54]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[55]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[56]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[57]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[58]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[59]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[60]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[61]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[62]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[63]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[64]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[65]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[66]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[67]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[68]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[69]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[70]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[71]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[72]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[73]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[74]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[75]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[76]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[77]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[78]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[79]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[80]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[81]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[82]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[83]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[84]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[85]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[86]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[87]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[88]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[89]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[90]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[91]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[92]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[93]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[94]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[95]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[96]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[97]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[98]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[99]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[100]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[101]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[102]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[103]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[104]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[105]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[106]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[107]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[108]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[109]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[110]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[111]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[112]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[113]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[114]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[115]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[116]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[117]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[118]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[119]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[120]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[121]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[122]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[123]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[124]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[125]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[126]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_din[127]}]]
connect_debug_port u_ila_0/probe27 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_addr[0]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_addr[1]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_addr[2]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_addr[3]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_addr[4]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_addr[5]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_addr[6]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_addr[7]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_addr[8]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_addr[9]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_addr[10]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_addr[11]} {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/cmem_addr[12]}]]
connect_debug_port u_ila_0/probe33 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/datain_vld}]]
connect_debug_port u_ila_0/probe34 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/datain_vld}]]
connect_debug_port u_ila_0/probe35 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/dataout_vld}]]
connect_debug_port u_ila_0/probe36 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/dataout_vld}]]
connect_debug_port u_ila_0/probe44 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/noc_reg_rdy}]]
connect_debug_port u_ila_0/probe45 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/noc_reg_rdy}]]
connect_debug_port u_ila_0/probe46 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/noc_write}]]
connect_debug_port u_ila_0/probe47 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/noc_write}]]
connect_debug_port u_ila_0/probe51 [get_nets [list digital_top_inst/i_digital_core/noc_adapter_inst/noc_adapter/RxFIFO_Valid_int]]
connect_debug_port u_ila_0/probe52 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/seq_dec]]
connect_debug_port u_ila_0/probe53 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/seq_dec]]
connect_debug_port u_ila_0/probe67 [get_nets [list digital_top_inst/i_digital_core/noc_adapter_inst/noc_adapter/TxFIFO_Ready_int]]
connect_debug_port u_ila_0/probe68 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/wr_i}]]
connect_debug_port u_ila_0/probe69 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/wr_i}]]
connect_debug_port u_ila_2/probe0 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[0].PEC_top_Inst/cc/rd_i}]]
connect_debug_port u_ila_2/probe1 [get_nets [list {digital_top_inst/i_digital_core/Accelerator_Top_inst/pec_gen[1].PEC_top_Inst/cc/rd_i}]]
connect_debug_port dbg_hub/clk [get_nets clk_100m]





connect_debug_port u_ila_0/probe24 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/state[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/state[1]}]]
connect_debug_port u_ila_0/probe27 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/tim/pl_shin_pa_sig[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/tim/pl_shin_pa_sig[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/tim/pl_shin_pa_sig[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/tim/pl_shin_pa_sig[3]}]]
connect_debug_port u_ila_0/probe30 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/state[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/state[1]}]]
connect_debug_port u_ila_0/probe43 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/pl_sig15[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/pl_sig15[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/pl_sig15[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/pl_sig15[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/pl_sig15[4]}]]
connect_debug_port u_ila_0/probe46 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/ack_clkreq]]
connect_debug_port u_ila_0/probe47 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/ack_clkreq]]
connect_debug_port u_ila_0/probe54 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/clkreq]]
connect_debug_port u_ila_0/probe62 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/tim/held_e_int]]
connect_debug_port u_ila_0/probe69 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/ios/next_pend]]
connect_debug_port u_ila_0/probe71 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/tim/p_0_in7_in]]
connect_debug_port u_ila_0/probe73 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/tim/runmode_int]]
connect_debug_port u_ila_0/probe82 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/set_ackclk]]
connect_debug_port u_ila_0/probe83 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/set_ackclk]]
connect_debug_port u_ila_0/probe96 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/ios/sync_pend]]
connect_debug_port u_ila_0/probe98 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/wait_dqi]]
connect_debug_port u_ila_0/probe99 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/wait_dqi]]
connect_debug_port u_ila_0/probe100 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/wait_pr]]
connect_debug_port u_ila_0/probe101 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/wait_pr]]
connect_debug_port u_ila_0/probe102 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/wait_rc]]
connect_debug_port u_ila_0/probe103 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/wait_rc]]
connect_debug_port u_ila_0/probe104 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/mmr/wait_rp]]
connect_debug_port u_ila_0/probe105 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/mmr/wait_rp]]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 2 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list fpga_pll_inst/inst/clk_50M]]
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe0]
set_property port_width 128 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {digital_top_inst/i_digital_core/GPP_CMD[0]} {digital_top_inst/i_digital_core/GPP_CMD[1]} {digital_top_inst/i_digital_core/GPP_CMD[2]} {digital_top_inst/i_digital_core/GPP_CMD[3]} {digital_top_inst/i_digital_core/GPP_CMD[4]} {digital_top_inst/i_digital_core/GPP_CMD[5]} {digital_top_inst/i_digital_core/GPP_CMD[6]} {digital_top_inst/i_digital_core/GPP_CMD[7]} {digital_top_inst/i_digital_core/GPP_CMD[8]} {digital_top_inst/i_digital_core/GPP_CMD[9]} {digital_top_inst/i_digital_core/GPP_CMD[10]} {digital_top_inst/i_digital_core/GPP_CMD[11]} {digital_top_inst/i_digital_core/GPP_CMD[12]} {digital_top_inst/i_digital_core/GPP_CMD[13]} {digital_top_inst/i_digital_core/GPP_CMD[14]} {digital_top_inst/i_digital_core/GPP_CMD[15]} {digital_top_inst/i_digital_core/GPP_CMD[16]} {digital_top_inst/i_digital_core/GPP_CMD[17]} {digital_top_inst/i_digital_core/GPP_CMD[18]} {digital_top_inst/i_digital_core/GPP_CMD[19]} {digital_top_inst/i_digital_core/GPP_CMD[20]} {digital_top_inst/i_digital_core/GPP_CMD[21]} {digital_top_inst/i_digital_core/GPP_CMD[22]} {digital_top_inst/i_digital_core/GPP_CMD[23]} {digital_top_inst/i_digital_core/GPP_CMD[24]} {digital_top_inst/i_digital_core/GPP_CMD[25]} {digital_top_inst/i_digital_core/GPP_CMD[26]} {digital_top_inst/i_digital_core/GPP_CMD[27]} {digital_top_inst/i_digital_core/GPP_CMD[28]} {digital_top_inst/i_digital_core/GPP_CMD[29]} {digital_top_inst/i_digital_core/GPP_CMD[30]} {digital_top_inst/i_digital_core/GPP_CMD[31]} {digital_top_inst/i_digital_core/GPP_CMD[32]} {digital_top_inst/i_digital_core/GPP_CMD[33]} {digital_top_inst/i_digital_core/GPP_CMD[34]} {digital_top_inst/i_digital_core/GPP_CMD[35]} {digital_top_inst/i_digital_core/GPP_CMD[36]} {digital_top_inst/i_digital_core/GPP_CMD[37]} {digital_top_inst/i_digital_core/GPP_CMD[38]} {digital_top_inst/i_digital_core/GPP_CMD[39]} {digital_top_inst/i_digital_core/GPP_CMD[40]} {digital_top_inst/i_digital_core/GPP_CMD[41]} {digital_top_inst/i_digital_core/GPP_CMD[42]} {digital_top_inst/i_digital_core/GPP_CMD[43]} {digital_top_inst/i_digital_core/GPP_CMD[44]} {digital_top_inst/i_digital_core/GPP_CMD[45]} {digital_top_inst/i_digital_core/GPP_CMD[46]} {digital_top_inst/i_digital_core/GPP_CMD[47]} {digital_top_inst/i_digital_core/GPP_CMD[48]} {digital_top_inst/i_digital_core/GPP_CMD[49]} {digital_top_inst/i_digital_core/GPP_CMD[50]} {digital_top_inst/i_digital_core/GPP_CMD[51]} {digital_top_inst/i_digital_core/GPP_CMD[52]} {digital_top_inst/i_digital_core/GPP_CMD[53]} {digital_top_inst/i_digital_core/GPP_CMD[54]} {digital_top_inst/i_digital_core/GPP_CMD[55]} {digital_top_inst/i_digital_core/GPP_CMD[56]} {digital_top_inst/i_digital_core/GPP_CMD[57]} {digital_top_inst/i_digital_core/GPP_CMD[58]} {digital_top_inst/i_digital_core/GPP_CMD[59]} {digital_top_inst/i_digital_core/GPP_CMD[60]} {digital_top_inst/i_digital_core/GPP_CMD[61]} {digital_top_inst/i_digital_core/GPP_CMD[62]} {digital_top_inst/i_digital_core/GPP_CMD[63]} {digital_top_inst/i_digital_core/GPP_CMD[64]} {digital_top_inst/i_digital_core/GPP_CMD[65]} {digital_top_inst/i_digital_core/GPP_CMD[66]} {digital_top_inst/i_digital_core/GPP_CMD[67]} {digital_top_inst/i_digital_core/GPP_CMD[68]} {digital_top_inst/i_digital_core/GPP_CMD[69]} {digital_top_inst/i_digital_core/GPP_CMD[70]} {digital_top_inst/i_digital_core/GPP_CMD[71]} {digital_top_inst/i_digital_core/GPP_CMD[72]} {digital_top_inst/i_digital_core/GPP_CMD[73]} {digital_top_inst/i_digital_core/GPP_CMD[74]} {digital_top_inst/i_digital_core/GPP_CMD[75]} {digital_top_inst/i_digital_core/GPP_CMD[76]} {digital_top_inst/i_digital_core/GPP_CMD[77]} {digital_top_inst/i_digital_core/GPP_CMD[78]} {digital_top_inst/i_digital_core/GPP_CMD[79]} {digital_top_inst/i_digital_core/GPP_CMD[80]} {digital_top_inst/i_digital_core/GPP_CMD[81]} {digital_top_inst/i_digital_core/GPP_CMD[82]} {digital_top_inst/i_digital_core/GPP_CMD[83]} {digital_top_inst/i_digital_core/GPP_CMD[84]} {digital_top_inst/i_digital_core/GPP_CMD[85]} {digital_top_inst/i_digital_core/GPP_CMD[86]} {digital_top_inst/i_digital_core/GPP_CMD[87]} {digital_top_inst/i_digital_core/GPP_CMD[88]} {digital_top_inst/i_digital_core/GPP_CMD[89]} {digital_top_inst/i_digital_core/GPP_CMD[90]} {digital_top_inst/i_digital_core/GPP_CMD[91]} {digital_top_inst/i_digital_core/GPP_CMD[92]} {digital_top_inst/i_digital_core/GPP_CMD[93]} {digital_top_inst/i_digital_core/GPP_CMD[94]} {digital_top_inst/i_digital_core/GPP_CMD[95]} {digital_top_inst/i_digital_core/GPP_CMD[96]} {digital_top_inst/i_digital_core/GPP_CMD[97]} {digital_top_inst/i_digital_core/GPP_CMD[98]} {digital_top_inst/i_digital_core/GPP_CMD[99]} {digital_top_inst/i_digital_core/GPP_CMD[100]} {digital_top_inst/i_digital_core/GPP_CMD[101]} {digital_top_inst/i_digital_core/GPP_CMD[102]} {digital_top_inst/i_digital_core/GPP_CMD[103]} {digital_top_inst/i_digital_core/GPP_CMD[104]} {digital_top_inst/i_digital_core/GPP_CMD[105]} {digital_top_inst/i_digital_core/GPP_CMD[106]} {digital_top_inst/i_digital_core/GPP_CMD[107]} {digital_top_inst/i_digital_core/GPP_CMD[108]} {digital_top_inst/i_digital_core/GPP_CMD[109]} {digital_top_inst/i_digital_core/GPP_CMD[110]} {digital_top_inst/i_digital_core/GPP_CMD[111]} {digital_top_inst/i_digital_core/GPP_CMD[112]} {digital_top_inst/i_digital_core/GPP_CMD[113]} {digital_top_inst/i_digital_core/GPP_CMD[114]} {digital_top_inst/i_digital_core/GPP_CMD[115]} {digital_top_inst/i_digital_core/GPP_CMD[116]} {digital_top_inst/i_digital_core/GPP_CMD[117]} {digital_top_inst/i_digital_core/GPP_CMD[118]} {digital_top_inst/i_digital_core/GPP_CMD[119]} {digital_top_inst/i_digital_core/GPP_CMD[120]} {digital_top_inst/i_digital_core/GPP_CMD[121]} {digital_top_inst/i_digital_core/GPP_CMD[122]} {digital_top_inst/i_digital_core/GPP_CMD[123]} {digital_top_inst/i_digital_core/GPP_CMD[124]} {digital_top_inst/i_digital_core/GPP_CMD[125]} {digital_top_inst/i_digital_core/GPP_CMD[126]} {digital_top_inst/i_digital_core/GPP_CMD[127]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe1]
set_property port_width 128 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {digital_top_inst/i_digital_core/IO_DATA[0]} {digital_top_inst/i_digital_core/IO_DATA[1]} {digital_top_inst/i_digital_core/IO_DATA[2]} {digital_top_inst/i_digital_core/IO_DATA[3]} {digital_top_inst/i_digital_core/IO_DATA[4]} {digital_top_inst/i_digital_core/IO_DATA[5]} {digital_top_inst/i_digital_core/IO_DATA[6]} {digital_top_inst/i_digital_core/IO_DATA[7]} {digital_top_inst/i_digital_core/IO_DATA[8]} {digital_top_inst/i_digital_core/IO_DATA[9]} {digital_top_inst/i_digital_core/IO_DATA[10]} {digital_top_inst/i_digital_core/IO_DATA[11]} {digital_top_inst/i_digital_core/IO_DATA[12]} {digital_top_inst/i_digital_core/IO_DATA[13]} {digital_top_inst/i_digital_core/IO_DATA[14]} {digital_top_inst/i_digital_core/IO_DATA[15]} {digital_top_inst/i_digital_core/IO_DATA[16]} {digital_top_inst/i_digital_core/IO_DATA[17]} {digital_top_inst/i_digital_core/IO_DATA[18]} {digital_top_inst/i_digital_core/IO_DATA[19]} {digital_top_inst/i_digital_core/IO_DATA[20]} {digital_top_inst/i_digital_core/IO_DATA[21]} {digital_top_inst/i_digital_core/IO_DATA[22]} {digital_top_inst/i_digital_core/IO_DATA[23]} {digital_top_inst/i_digital_core/IO_DATA[24]} {digital_top_inst/i_digital_core/IO_DATA[25]} {digital_top_inst/i_digital_core/IO_DATA[26]} {digital_top_inst/i_digital_core/IO_DATA[27]} {digital_top_inst/i_digital_core/IO_DATA[28]} {digital_top_inst/i_digital_core/IO_DATA[29]} {digital_top_inst/i_digital_core/IO_DATA[30]} {digital_top_inst/i_digital_core/IO_DATA[31]} {digital_top_inst/i_digital_core/IO_DATA[32]} {digital_top_inst/i_digital_core/IO_DATA[33]} {digital_top_inst/i_digital_core/IO_DATA[34]} {digital_top_inst/i_digital_core/IO_DATA[35]} {digital_top_inst/i_digital_core/IO_DATA[36]} {digital_top_inst/i_digital_core/IO_DATA[37]} {digital_top_inst/i_digital_core/IO_DATA[38]} {digital_top_inst/i_digital_core/IO_DATA[39]} {digital_top_inst/i_digital_core/IO_DATA[40]} {digital_top_inst/i_digital_core/IO_DATA[41]} {digital_top_inst/i_digital_core/IO_DATA[42]} {digital_top_inst/i_digital_core/IO_DATA[43]} {digital_top_inst/i_digital_core/IO_DATA[44]} {digital_top_inst/i_digital_core/IO_DATA[45]} {digital_top_inst/i_digital_core/IO_DATA[46]} {digital_top_inst/i_digital_core/IO_DATA[47]} {digital_top_inst/i_digital_core/IO_DATA[48]} {digital_top_inst/i_digital_core/IO_DATA[49]} {digital_top_inst/i_digital_core/IO_DATA[50]} {digital_top_inst/i_digital_core/IO_DATA[51]} {digital_top_inst/i_digital_core/IO_DATA[52]} {digital_top_inst/i_digital_core/IO_DATA[53]} {digital_top_inst/i_digital_core/IO_DATA[54]} {digital_top_inst/i_digital_core/IO_DATA[55]} {digital_top_inst/i_digital_core/IO_DATA[56]} {digital_top_inst/i_digital_core/IO_DATA[57]} {digital_top_inst/i_digital_core/IO_DATA[58]} {digital_top_inst/i_digital_core/IO_DATA[59]} {digital_top_inst/i_digital_core/IO_DATA[60]} {digital_top_inst/i_digital_core/IO_DATA[61]} {digital_top_inst/i_digital_core/IO_DATA[62]} {digital_top_inst/i_digital_core/IO_DATA[63]} {digital_top_inst/i_digital_core/IO_DATA[64]} {digital_top_inst/i_digital_core/IO_DATA[65]} {digital_top_inst/i_digital_core/IO_DATA[66]} {digital_top_inst/i_digital_core/IO_DATA[67]} {digital_top_inst/i_digital_core/IO_DATA[68]} {digital_top_inst/i_digital_core/IO_DATA[69]} {digital_top_inst/i_digital_core/IO_DATA[70]} {digital_top_inst/i_digital_core/IO_DATA[71]} {digital_top_inst/i_digital_core/IO_DATA[72]} {digital_top_inst/i_digital_core/IO_DATA[73]} {digital_top_inst/i_digital_core/IO_DATA[74]} {digital_top_inst/i_digital_core/IO_DATA[75]} {digital_top_inst/i_digital_core/IO_DATA[76]} {digital_top_inst/i_digital_core/IO_DATA[77]} {digital_top_inst/i_digital_core/IO_DATA[78]} {digital_top_inst/i_digital_core/IO_DATA[79]} {digital_top_inst/i_digital_core/IO_DATA[80]} {digital_top_inst/i_digital_core/IO_DATA[81]} {digital_top_inst/i_digital_core/IO_DATA[82]} {digital_top_inst/i_digital_core/IO_DATA[83]} {digital_top_inst/i_digital_core/IO_DATA[84]} {digital_top_inst/i_digital_core/IO_DATA[85]} {digital_top_inst/i_digital_core/IO_DATA[86]} {digital_top_inst/i_digital_core/IO_DATA[87]} {digital_top_inst/i_digital_core/IO_DATA[88]} {digital_top_inst/i_digital_core/IO_DATA[89]} {digital_top_inst/i_digital_core/IO_DATA[90]} {digital_top_inst/i_digital_core/IO_DATA[91]} {digital_top_inst/i_digital_core/IO_DATA[92]} {digital_top_inst/i_digital_core/IO_DATA[93]} {digital_top_inst/i_digital_core/IO_DATA[94]} {digital_top_inst/i_digital_core/IO_DATA[95]} {digital_top_inst/i_digital_core/IO_DATA[96]} {digital_top_inst/i_digital_core/IO_DATA[97]} {digital_top_inst/i_digital_core/IO_DATA[98]} {digital_top_inst/i_digital_core/IO_DATA[99]} {digital_top_inst/i_digital_core/IO_DATA[100]} {digital_top_inst/i_digital_core/IO_DATA[101]} {digital_top_inst/i_digital_core/IO_DATA[102]} {digital_top_inst/i_digital_core/IO_DATA[103]} {digital_top_inst/i_digital_core/IO_DATA[104]} {digital_top_inst/i_digital_core/IO_DATA[105]} {digital_top_inst/i_digital_core/IO_DATA[106]} {digital_top_inst/i_digital_core/IO_DATA[107]} {digital_top_inst/i_digital_core/IO_DATA[108]} {digital_top_inst/i_digital_core/IO_DATA[109]} {digital_top_inst/i_digital_core/IO_DATA[110]} {digital_top_inst/i_digital_core/IO_DATA[111]} {digital_top_inst/i_digital_core/IO_DATA[112]} {digital_top_inst/i_digital_core/IO_DATA[113]} {digital_top_inst/i_digital_core/IO_DATA[114]} {digital_top_inst/i_digital_core/IO_DATA[115]} {digital_top_inst/i_digital_core/IO_DATA[116]} {digital_top_inst/i_digital_core/IO_DATA[117]} {digital_top_inst/i_digital_core/IO_DATA[118]} {digital_top_inst/i_digital_core/IO_DATA[119]} {digital_top_inst/i_digital_core/IO_DATA[120]} {digital_top_inst/i_digital_core/IO_DATA[121]} {digital_top_inst/i_digital_core/IO_DATA[122]} {digital_top_inst/i_digital_core/IO_DATA[123]} {digital_top_inst/i_digital_core/IO_DATA[124]} {digital_top_inst/i_digital_core/IO_DATA[125]} {digital_top_inst/i_digital_core/IO_DATA[126]} {digital_top_inst/i_digital_core/IO_DATA[127]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe2]
set_property port_width 128 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {digital_top_inst/i_digital_core/NOC_DATA[0]} {digital_top_inst/i_digital_core/NOC_DATA[1]} {digital_top_inst/i_digital_core/NOC_DATA[2]} {digital_top_inst/i_digital_core/NOC_DATA[3]} {digital_top_inst/i_digital_core/NOC_DATA[4]} {digital_top_inst/i_digital_core/NOC_DATA[5]} {digital_top_inst/i_digital_core/NOC_DATA[6]} {digital_top_inst/i_digital_core/NOC_DATA[7]} {digital_top_inst/i_digital_core/NOC_DATA[8]} {digital_top_inst/i_digital_core/NOC_DATA[9]} {digital_top_inst/i_digital_core/NOC_DATA[10]} {digital_top_inst/i_digital_core/NOC_DATA[11]} {digital_top_inst/i_digital_core/NOC_DATA[12]} {digital_top_inst/i_digital_core/NOC_DATA[13]} {digital_top_inst/i_digital_core/NOC_DATA[14]} {digital_top_inst/i_digital_core/NOC_DATA[15]} {digital_top_inst/i_digital_core/NOC_DATA[16]} {digital_top_inst/i_digital_core/NOC_DATA[17]} {digital_top_inst/i_digital_core/NOC_DATA[18]} {digital_top_inst/i_digital_core/NOC_DATA[19]} {digital_top_inst/i_digital_core/NOC_DATA[20]} {digital_top_inst/i_digital_core/NOC_DATA[21]} {digital_top_inst/i_digital_core/NOC_DATA[22]} {digital_top_inst/i_digital_core/NOC_DATA[23]} {digital_top_inst/i_digital_core/NOC_DATA[24]} {digital_top_inst/i_digital_core/NOC_DATA[25]} {digital_top_inst/i_digital_core/NOC_DATA[26]} {digital_top_inst/i_digital_core/NOC_DATA[27]} {digital_top_inst/i_digital_core/NOC_DATA[28]} {digital_top_inst/i_digital_core/NOC_DATA[29]} {digital_top_inst/i_digital_core/NOC_DATA[30]} {digital_top_inst/i_digital_core/NOC_DATA[31]} {digital_top_inst/i_digital_core/NOC_DATA[32]} {digital_top_inst/i_digital_core/NOC_DATA[33]} {digital_top_inst/i_digital_core/NOC_DATA[34]} {digital_top_inst/i_digital_core/NOC_DATA[35]} {digital_top_inst/i_digital_core/NOC_DATA[36]} {digital_top_inst/i_digital_core/NOC_DATA[37]} {digital_top_inst/i_digital_core/NOC_DATA[38]} {digital_top_inst/i_digital_core/NOC_DATA[39]} {digital_top_inst/i_digital_core/NOC_DATA[40]} {digital_top_inst/i_digital_core/NOC_DATA[41]} {digital_top_inst/i_digital_core/NOC_DATA[42]} {digital_top_inst/i_digital_core/NOC_DATA[43]} {digital_top_inst/i_digital_core/NOC_DATA[44]} {digital_top_inst/i_digital_core/NOC_DATA[45]} {digital_top_inst/i_digital_core/NOC_DATA[46]} {digital_top_inst/i_digital_core/NOC_DATA[47]} {digital_top_inst/i_digital_core/NOC_DATA[48]} {digital_top_inst/i_digital_core/NOC_DATA[49]} {digital_top_inst/i_digital_core/NOC_DATA[50]} {digital_top_inst/i_digital_core/NOC_DATA[51]} {digital_top_inst/i_digital_core/NOC_DATA[52]} {digital_top_inst/i_digital_core/NOC_DATA[53]} {digital_top_inst/i_digital_core/NOC_DATA[54]} {digital_top_inst/i_digital_core/NOC_DATA[55]} {digital_top_inst/i_digital_core/NOC_DATA[56]} {digital_top_inst/i_digital_core/NOC_DATA[57]} {digital_top_inst/i_digital_core/NOC_DATA[58]} {digital_top_inst/i_digital_core/NOC_DATA[59]} {digital_top_inst/i_digital_core/NOC_DATA[60]} {digital_top_inst/i_digital_core/NOC_DATA[61]} {digital_top_inst/i_digital_core/NOC_DATA[62]} {digital_top_inst/i_digital_core/NOC_DATA[63]} {digital_top_inst/i_digital_core/NOC_DATA[64]} {digital_top_inst/i_digital_core/NOC_DATA[65]} {digital_top_inst/i_digital_core/NOC_DATA[66]} {digital_top_inst/i_digital_core/NOC_DATA[67]} {digital_top_inst/i_digital_core/NOC_DATA[68]} {digital_top_inst/i_digital_core/NOC_DATA[69]} {digital_top_inst/i_digital_core/NOC_DATA[70]} {digital_top_inst/i_digital_core/NOC_DATA[71]} {digital_top_inst/i_digital_core/NOC_DATA[72]} {digital_top_inst/i_digital_core/NOC_DATA[73]} {digital_top_inst/i_digital_core/NOC_DATA[74]} {digital_top_inst/i_digital_core/NOC_DATA[75]} {digital_top_inst/i_digital_core/NOC_DATA[76]} {digital_top_inst/i_digital_core/NOC_DATA[77]} {digital_top_inst/i_digital_core/NOC_DATA[78]} {digital_top_inst/i_digital_core/NOC_DATA[79]} {digital_top_inst/i_digital_core/NOC_DATA[80]} {digital_top_inst/i_digital_core/NOC_DATA[81]} {digital_top_inst/i_digital_core/NOC_DATA[82]} {digital_top_inst/i_digital_core/NOC_DATA[83]} {digital_top_inst/i_digital_core/NOC_DATA[84]} {digital_top_inst/i_digital_core/NOC_DATA[85]} {digital_top_inst/i_digital_core/NOC_DATA[86]} {digital_top_inst/i_digital_core/NOC_DATA[87]} {digital_top_inst/i_digital_core/NOC_DATA[88]} {digital_top_inst/i_digital_core/NOC_DATA[89]} {digital_top_inst/i_digital_core/NOC_DATA[90]} {digital_top_inst/i_digital_core/NOC_DATA[91]} {digital_top_inst/i_digital_core/NOC_DATA[92]} {digital_top_inst/i_digital_core/NOC_DATA[93]} {digital_top_inst/i_digital_core/NOC_DATA[94]} {digital_top_inst/i_digital_core/NOC_DATA[95]} {digital_top_inst/i_digital_core/NOC_DATA[96]} {digital_top_inst/i_digital_core/NOC_DATA[97]} {digital_top_inst/i_digital_core/NOC_DATA[98]} {digital_top_inst/i_digital_core/NOC_DATA[99]} {digital_top_inst/i_digital_core/NOC_DATA[100]} {digital_top_inst/i_digital_core/NOC_DATA[101]} {digital_top_inst/i_digital_core/NOC_DATA[102]} {digital_top_inst/i_digital_core/NOC_DATA[103]} {digital_top_inst/i_digital_core/NOC_DATA[104]} {digital_top_inst/i_digital_core/NOC_DATA[105]} {digital_top_inst/i_digital_core/NOC_DATA[106]} {digital_top_inst/i_digital_core/NOC_DATA[107]} {digital_top_inst/i_digital_core/NOC_DATA[108]} {digital_top_inst/i_digital_core/NOC_DATA[109]} {digital_top_inst/i_digital_core/NOC_DATA[110]} {digital_top_inst/i_digital_core/NOC_DATA[111]} {digital_top_inst/i_digital_core/NOC_DATA[112]} {digital_top_inst/i_digital_core/NOC_DATA[113]} {digital_top_inst/i_digital_core/NOC_DATA[114]} {digital_top_inst/i_digital_core/NOC_DATA[115]} {digital_top_inst/i_digital_core/NOC_DATA[116]} {digital_top_inst/i_digital_core/NOC_DATA[117]} {digital_top_inst/i_digital_core/NOC_DATA[118]} {digital_top_inst/i_digital_core/NOC_DATA[119]} {digital_top_inst/i_digital_core/NOC_DATA[120]} {digital_top_inst/i_digital_core/NOC_DATA[121]} {digital_top_inst/i_digital_core/NOC_DATA[122]} {digital_top_inst/i_digital_core/NOC_DATA[123]} {digital_top_inst/i_digital_core/NOC_DATA[124]} {digital_top_inst/i_digital_core/NOC_DATA[125]} {digital_top_inst/i_digital_core/NOC_DATA[126]} {digital_top_inst/i_digital_core/NOC_DATA[127]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/sipo_reg[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/sipo_reg[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/sipo_reg[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/sipo_reg[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/sipo_reg[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/sipo_reg[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/sipo_reg[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/sipo_reg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 8 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/piso_reg[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/piso_reg[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/piso_reg[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/piso_reg[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/piso_reg[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/piso_reg[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/piso_reg[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/piso_reg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 14 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[9]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[10]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[11]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[12]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/mar[13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/dfsr[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/dfsr[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/dfsr[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/dfsr[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/dfsr[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/dfsr[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/dfsr[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/dfsr[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 3 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/cnt[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/cnt[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/cnt[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 4 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/cmd_reg[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/cmd_reg[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/cmd_reg[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/cmd_reg[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 5 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/st_ctr[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/st_ctr[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/st_ctr[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/st_ctr[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/st_ctr[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 14 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][9]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][10]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][11]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][12]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[8][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 14 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][9]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][10]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][11]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][12]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[7][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 14 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][9]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][10]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][11]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][12]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[6][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 14 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][9]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][10]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][11]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][12]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[5][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 14 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][9]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][10]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][11]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][12]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[3][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 14 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][9]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][10]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][11]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][12]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[2][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 14 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][9]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][10]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][11]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][12]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[4][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 14 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][9]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][10]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][11]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][12]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[1][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 14 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][9]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][10]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][11]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][12]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/stack9x141/stack_reg[0][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 5 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/pl_seqc[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/pl_seqc[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/pl_seqc[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/pl_seqc[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/pl_seqc[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 8 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/hold_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 8 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_q[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 8 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_d[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 10 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[7]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[8]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gmem_a[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 8 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 8 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/gctr[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 8 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/direct[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 5 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/st_ctr[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/st_ctr[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/st_ctr[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/st_ctr[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/st_ctr[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 14 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][7]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][8]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][9]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][10]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][11]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][12]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[8][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 14 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][7]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][8]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][9]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][10]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][11]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][12]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[7][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 14 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][7]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][8]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][9]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][10]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][11]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][12]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[6][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 14 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][7]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][8]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][9]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][10]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][11]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][12]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[5][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 14 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][7]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][8]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][9]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][10]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][11]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][12]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[3][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 14 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][7]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][8]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][9]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][10]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][11]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][12]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[2][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 14 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][7]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][8]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][9]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][10]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][11]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][12]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[4][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 14 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][7]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][8]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][9]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][10]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][11]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][12]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[1][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 14 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][4]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][5]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][6]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][7]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][8]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][9]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][10]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][11]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][12]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/stack9x141/stack_reg[0][13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 5 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/pl_seqc[0]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/pl_seqc[1]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/pl_seqc[2]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/pl_seqc[3]} {digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/pl_seqc[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 8 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/direct[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 8 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gctr[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 8 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 10 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_a[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 8 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_d[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 8 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/gmem_q[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 8 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/hold_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 1 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/ios/pl_pd_sig[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 8 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/dbus_int[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe47]
set_property port_width 80 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[7]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[8]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[9]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[10]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[11]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[12]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[13]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[14]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[15]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[16]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[17]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[18]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[19]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[20]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[21]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[22]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[23]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[24]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[25]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[26]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[27]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[28]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[29]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[30]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[31]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[32]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[33]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[34]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[35]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[36]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[37]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[38]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[39]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[40]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[41]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[42]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[43]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[44]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[45]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[46]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[47]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[48]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[49]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[50]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[51]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[52]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[53]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[54]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[55]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[56]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[57]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[58]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[59]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[60]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[61]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[62]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[63]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[64]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[65]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[66]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[67]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[68]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[69]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[70]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[71]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[72]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[73]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[74]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[75]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[76]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[77]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[78]} {digital_top_inst/i_digital_core/i_im4000_top/core1/pl[79]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe48]
set_property port_width 8 [get_debug_ports u_ila_0/probe48]
connect_debug_port u_ila_0/probe48 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[0]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[1]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[2]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[3]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[4]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[5]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[6]} {digital_top_inst/i_digital_core/i_im4000_top/core1/ybus[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe49]
set_property port_width 8 [get_debug_ports u_ila_0/probe49]
connect_debug_port u_ila_0/probe49 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b1[0]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b1[1]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b1[2]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b1[3]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b1[4]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b1[5]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b1[6]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b1[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe50]
set_property port_width 8 [get_debug_ports u_ila_0/probe50]
connect_debug_port u_ila_0/probe50 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b2[0]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b2[1]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b2[2]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b2[3]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b2[4]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b2[5]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b2[6]} {digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/c1_data_b2[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe51]
set_property port_width 8 [get_debug_ports u_ila_0/probe51]
connect_debug_port u_ila_0/probe51 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[0]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[1]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[2]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[3]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[4]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[5]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[6]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqi[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe52]
set_property port_width 32 [get_debug_ports u_ila_0/probe52]
connect_debug_port u_ila_0/probe52 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[0]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[1]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[2]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[3]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[4]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[5]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[6]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[7]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[8]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[9]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[10]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[11]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[12]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[13]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[14]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[15]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[16]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[17]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[18]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[19]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[20]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[21]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[22]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[23]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[24]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[25]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[26]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[27]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[28]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[29]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[30]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe53]
set_property port_width 8 [get_debug_ports u_ila_0/probe53]
connect_debug_port u_ila_0/probe53 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[0]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[1]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[2]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[3]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[4]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[5]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[6]} {digital_top_inst/i_digital_core/i_im4000_top/c1_d_dqo[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe54]
set_property port_width 2 [get_debug_ports u_ila_0/probe54]
connect_debug_port u_ila_0/probe54 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/c1_mpram_ce[0]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mpram_ce[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe55]
set_property port_width 14 [get_debug_ports u_ila_0/probe55]
connect_debug_port u_ila_0/probe55 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[0]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[1]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[2]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[3]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[4]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[5]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[6]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[7]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[8]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[9]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[10]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[11]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[12]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_a[13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe56]
set_property port_width 2 [get_debug_ports u_ila_0/probe56]
connect_debug_port u_ila_0/probe56 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_ce[0]} {digital_top_inst/i_digital_core/i_im4000_top/c1_mprom_ce[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe57]
set_property port_width 8 [get_debug_ports u_ila_0/probe57]
connect_debug_port u_ila_0/probe57 [get_nets [list {digital_top_inst/i_digital_core/i_im4000_top/idi[0]} {digital_top_inst/i_digital_core/i_im4000_top/idi[1]} {digital_top_inst/i_digital_core/i_im4000_top/idi[2]} {digital_top_inst/i_digital_core/i_im4000_top/idi[3]} {digital_top_inst/i_digital_core/i_im4000_top/idi[4]} {digital_top_inst/i_digital_core/i_im4000_top/idi[5]} {digital_top_inst/i_digital_core/i_im4000_top/idi[6]} {digital_top_inst/i_digital_core/i_im4000_top/idi[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe58]
set_property port_width 1 [get_debug_ports u_ila_0/probe58]
connect_debug_port u_ila_0/probe58 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/tim/ack_spreq]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe59]
set_property port_width 1 [get_debug_ports u_ila_0/probe59]
connect_debug_port u_ila_0/probe59 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/c1_d_cs]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe60]
set_property port_width 1 [get_debug_ports u_ila_0/probe60]
connect_debug_port u_ila_0/probe60 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/c1_d_we]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe61]
set_property port_width 1 [get_debug_ports u_ila_0/probe61]
connect_debug_port u_ila_0/probe61 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/tim/call_sp]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe62]
set_property port_width 1 [get_debug_ports u_ila_0/probe62]
connect_debug_port u_ila_0/probe62 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/clk_e_pos]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe63]
set_property port_width 1 [get_debug_ports u_ila_0/probe63]
connect_debug_port u_ila_0/probe63 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/clk_gen0/clk_s_pos_int]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe64]
set_property port_width 1 [get_debug_ports u_ila_0/probe64]
connect_debug_port u_ila_0/probe64 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/clkreq]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe65]
set_property port_width 1 [get_debug_ports u_ila_0/probe65]
connect_debug_port u_ila_0/probe65 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/dbl_direct]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe66]
set_property port_width 1 [get_debug_ports u_ila_0/probe66]
connect_debug_port u_ila_0/probe66 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/dbl_direct]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe67]
set_property port_width 1 [get_debug_ports u_ila_0/probe67]
connect_debug_port u_ila_0/probe67 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/even_c]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe68]
set_property port_width 1 [get_debug_ports u_ila_0/probe68]
connect_debug_port u_ila_0/probe68 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/sdram_inf_inst/fast_d]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe69]
set_property port_width 1 [get_debug_ports u_ila_0/probe69]
connect_debug_port u_ila_0/probe69 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/alu/flag_yan]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe70]
set_property port_width 1 [get_debug_ports u_ila_0/probe70]
connect_debug_port u_ila_0/probe70 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/alu/flag_yan]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe71]
set_property port_width 1 [get_debug_ports u_ila_0/probe71]
connect_debug_port u_ila_0/probe71 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/alu/flag_yz]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe72]
set_property port_width 1 [get_debug_ports u_ila_0/probe72]
connect_debug_port u_ila_0/probe72 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/alu/flag_yz]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe73]
set_property port_width 1 [get_debug_ports u_ila_0/probe73]
connect_debug_port u_ila_0/probe73 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/gmem/g_double]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe74]
set_property port_width 1 [get_debug_ports u_ila_0/probe74]
connect_debug_port u_ila_0/probe74 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/gmem/g_double]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe75]
set_property port_width 1 [get_debug_ports u_ila_0/probe75]
connect_debug_port u_ila_0/probe75 [get_nets [list digital_top_inst/i_digital_core/GPP_CMD_Flag]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe76]
set_property port_width 1 [get_debug_ports u_ila_0/probe76]
connect_debug_port u_ila_0/probe76 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/hold_e_int]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe77]
set_property port_width 1 [get_debug_ports u_ila_0/probe77]
connect_debug_port u_ila_0/probe77 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/ios_hold_e]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe78]
set_property port_width 1 [get_debug_ports u_ila_0/probe78]
connect_debug_port u_ila_0/probe78 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/ld_mar]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe79]
set_property port_width 1 [get_debug_ports u_ila_0/probe79]
connect_debug_port u_ila_0/probe79 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/ios/ldout_pend]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe80]
set_property port_width 1 [get_debug_ports u_ila_0/probe80]
connect_debug_port u_ila_0/probe80 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/ios/lioa_pend]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe81]
set_property port_width 1 [get_debug_ports u_ila_0/probe81]
connect_debug_port u_ila_0/probe81 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/mmr_hold_e]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe82]
set_property port_width 1 [get_debug_ports u_ila_0/probe82]
connect_debug_port u_ila_0/probe82 [get_nets [list digital_top_inst/i_digital_core/NOC_IRQ]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe83]
set_property port_width 1 [get_debug_ports u_ila_0/probe83]
connect_debug_port u_ila_0/probe83 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/plsel_n]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe84]
set_property port_width 1 [get_debug_ports u_ila_0/probe84]
connect_debug_port u_ila_0/probe84 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/rx_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe85]
set_property port_width 1 [get_debug_ports u_ila_0/probe85]
connect_debug_port u_ila_0/probe85 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/rx_stop]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe86]
set_property port_width 1 [get_debug_ports u_ila_0/probe86]
connect_debug_port u_ila_0/probe86 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/seq_des]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe87]
set_property port_width 1 [get_debug_ports u_ila_0/probe87]
connect_debug_port u_ila_0/probe87 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/seq_des]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe88]
set_property port_width 1 [get_debug_ports u_ila_0/probe88]
connect_debug_port u_ila_0/probe88 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/seq_pop_des]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe89]
set_property port_width 1 [get_debug_ports u_ila_0/probe89]
connect_debug_port u_ila_0/probe89 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/seq_pop_des]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe90]
set_property port_width 1 [get_debug_ports u_ila_0/probe90]
connect_debug_port u_ila_0/probe90 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/seq_psh]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe91]
set_property port_width 1 [get_debug_ports u_ila_0/probe91]
connect_debug_port u_ila_0/probe91 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/seq_psh]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe92]
set_property port_width 1 [get_debug_ports u_ila_0/probe92]
connect_debug_port u_ila_0/probe92 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/tim/single_step]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe93]
set_property port_width 1 [get_debug_ports u_ila_0/probe93]
connect_debug_port u_ila_0/probe93 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/tim/sleep]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe94]
set_property port_width 1 [get_debug_ports u_ila_0/probe94]
connect_debug_port u_ila_0/probe94 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/st_empty]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe95]
set_property port_width 1 [get_debug_ports u_ila_0/probe95]
connect_debug_port u_ila_0/probe95 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/st_empty]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe96]
set_property port_width 1 [get_debug_ports u_ila_0/probe96]
connect_debug_port u_ila_0/probe96 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/st_full]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe97]
set_property port_width 1 [get_debug_ports u_ila_0/probe97]
connect_debug_port u_ila_0/probe97 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/st_full]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe98]
set_property port_width 1 [get_debug_ports u_ila_0/probe98]
connect_debug_port u_ila_0/probe98 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/st_pop]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe99]
set_property port_width 1 [get_debug_ports u_ila_0/probe99]
connect_debug_port u_ila_0/probe99 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/st_pop]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe100]
set_property port_width 1 [get_debug_ports u_ila_0/probe100]
connect_debug_port u_ila_0/probe100 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/clc/sct1/st_push]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe101]
set_property port_width 1 [get_debug_ports u_ila_0/probe101]
connect_debug_port u_ila_0/probe101 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core2/clc/sct1/st_push]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe102]
set_property port_width 1 [get_debug_ports u_ila_0/probe102]
connect_debug_port u_ila_0/probe102 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/stop_step]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe103]
set_property port_width 1 [get_debug_ports u_ila_0/probe103]
connect_debug_port u_ila_0/probe103 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/tim/stop_step_c2]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe104]
set_property port_width 1 [get_debug_ports u_ila_0/probe104]
connect_debug_port u_ila_0/probe104 [get_nets [list digital_top_inst/i_digital_core/i_im4000_top/core1/cpc/tx_en]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_50m]
