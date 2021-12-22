# Synplicity, Inc. constraint file
# G:\gp3000\syn\make_scf.sdc
# Written on Fri Apr 21 11:55:59 2006
# by Synplify ASIC,      Synplify ASIC 2.4.1         Scope Editor

#
# New Clocks
#
define_clock            -name {n:clk_p}  -period 6.000 -clockgroup default_clkgroup -uncertainty 0.100
define_clock            -name {n:clk_c}  -period 6.000 -clockgroup default_clkgroup -uncertainty 0.100
define_clock            -name {n:clk_d}  -period 6.000 -clockgroup default_clkgroup -uncertainty 0.100
define_clock            -name {n:clk_c2}  -period 12.000 -clockgroup default_clkgroup -uncertainty 0.100
define_clock            -name {n:clk_e}  -period 12.000 -clockgroup default_clkgroup -uncertainty 0.100
define_clock            -name {n:clk_i}  -period 12.000 -clockgroup default_clkgroup -uncertainty 0.100
define_clock            -name {n:clk_s}  -period 12.000 -clockgroup default_clkgroup -uncertainty 0.100
define_clock            -name {n:clk_a}  -period 108.000 -clockgroup default_clkgroup -uncertainty 0.100
define_clock            -name {n:clk_u}  -period 540.000 -clockgroup default_clkgroup -uncertainty 0.100
define_clock            -name {p:PG1_ERXCLK}  -period 20.000 -clockgroup rx_clkgroup -uncertainty 0.100
define_clock           -virtual -name {clk_ERXCLK}  -period 20.000 -clockgroup rx_clkgroup -uncertainty 0.100
define_clock            -name {p:PF1_ETXCLK}  -period 20.000 -clockgroup tx_clkgroup -uncertainty 0.100
define_clock           -virtual -name {clk_ETXCLK}  -period 20.000 -clockgroup tx_clkgroup -uncertainty 0.100
define_clock           -virtual -name {clk_DCLK}  -period 6.000 -clockgroup default_clkgroup -uncertainty 0.100
define_clock           -virtual -name {clk_ICLK}  -period 12.000 -clockgroup default_clkgroup -uncertainty 0.100

#
# Clock to Clock
#

#
# Inputs/Outputs
#
define_input_delay -disable  -default 
define_output_delay -disable  -default 
define_output_delay           -comment {Setup/hold = 1.5/1.0 ns from data sheet. Setup time increased by 0.44 ns, due to clock output delay uncertainty}  {DA0}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DA1}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DA10}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DA11}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DA12}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DA13}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DA2}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DA3}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DA4}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DA5}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DA6}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DA7}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DA8}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DA9}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DBA0}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DBA1}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DCAS}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DCKE0}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DCKE1}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DCKE2}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DCKE3}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DCS}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DDQ0}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DDQ1}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DDQ2}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DDQ3}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DDQ4}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DDQ5}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DDQ6}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DDQ7}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DRAS}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {DWE}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_input_delay           -comment {Access/hold = 5.0/2.5 ns from data sheet. Hold time decreased by 0.44 ns, due to clock output delay uncertainty}  {DDQ0}  -rise 5.000 -fall 5.000 -min_rise 2.060 -min_fall 2.060 -ref {clk_DCLK:r}
define_input_delay           -comment {"}  {DDQ1}  -rise 5.000 -fall 5.000 -min_rise 2.060 -min_fall 2.060 -ref {clk_DCLK:r}
define_input_delay           -comment {"}  {DDQ2}  -rise 5.000 -fall 5.000 -min_rise 2.060 -min_fall 2.060 -ref {clk_DCLK:r}
define_input_delay           -comment {"}  {DDQ3}  -rise 5.000 -fall 5.000 -min_rise 2.060 -min_fall 2.060 -ref {clk_DCLK:r}
define_input_delay           -comment {"}  {DDQ4}  -rise 5.000 -fall 5.000 -min_rise 2.060 -min_fall 2.060 -ref {clk_DCLK:r}
define_input_delay           -comment {"}  {DDQ5}  -rise 5.000 -fall 5.000 -min_rise 2.060 -min_fall 2.060 -ref {clk_DCLK:r}
define_input_delay           -comment {"}  {DDQ6}  -rise 5.000 -fall 5.000 -min_rise 2.060 -min_fall 2.060 -ref {clk_DCLK:r}
define_input_delay           -comment {"}  {DDQ7}  -rise 5.000 -fall 5.000 -min_rise 2.060 -min_fall 2.060 -ref {clk_DCLK:r}
define_output_delay           -comment {Setup/hold = 1.5/1.0 ns from data sheet. Setup time increased by 0.44 ns, due to clock output delay uncertainty}  {PD0_DDQM0}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {PD1_DDQM1}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {PD2_DDQM2}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {PD3_DDQM3}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {PD4_DDQM4}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {PD5_DDQM5}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {PD6_DDQM6}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay           -comment {"}  {PD7_DDQM7}  -rise 1.940 -fall 1.940 -min_rise 1.000 -min_fall 1.000 -ref {clk_DCLK:r}
define_output_delay -disable  -comment {Timing not important for GPIO, allow one full cycle}  {PD0_DDQM0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PD1_DDQM1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PD2_DDQM2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PD3_DDQM3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PD4_DDQM4}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PD5_DDQM5}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PD6_DDQM6}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PD7_DDQM7}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PD0_DDQM0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PD1_DDQM1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PD2_DDQM2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PD3_DDQM3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PD4_DDQM4}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PD5_DDQM5}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PD6_DDQM6}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PD7_DDQM7}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {Timing not important for these signals, allow one full cycle of whatever clock}  {MBYPASS}  -rise 0.100 -fall 0.100
define_output_delay -disable  -comment {"}  {MCKOUT0}  -rise 0.100 -fall 0.100
define_output_delay -disable  -comment {"}  {MCKOUT1}  -rise 0.100 -fall 0.100
define_output_delay -disable  -comment {"}  {MEXEC}  -rise 0.100 -fall 0.100
define_input_delay -disable  -comment {"}  {MIRQ0}  -rise 0.100 -fall 0.100
define_input_delay -disable  -comment {"}  {MIRQ1}  -rise 0.100 -fall 0.100
define_output_delay -disable  -comment {"}  {MIRQOUT}  -rise 0.100 -fall 0.100
define_input_delay -disable  -comment {"}  {MPLL_TSTO}  -rise 0.100 -fall 0.100
define_output_delay -disable  -comment {"}  {MPLL_TSTO}  -rise 0.100 -fall 0.100
define_input_delay -disable  -comment {"}  {MPORDIS}  -rise 0.100 -fall 0.100
define_input_delay -disable  -comment {"}  {MRESET}  -rise 0.100 -fall 0.100
define_output_delay -disable  -comment {"}  {MRSTOUT}  -rise 0.100 -fall 0.100
define_output_delay -disable  -comment {"}  {MRXOUT}  -rise 0.100 -fall 0.100
define_input_delay -disable  -comment {"}  {MSDIN}  -rise 0.100 -fall 0.100
define_output_delay -disable  -comment {"}  {MSDOUT}  -rise 0.100 -fall 0.100
define_input_delay -disable  -comment {"}  {MTEST}  -rise 0.100 -fall 0.100
define_input_delay -disable  -comment {"}  {MWAKE}  -rise 0.100 -fall 0.100
define_input_delay -disable  -comment {"}  {MX1_CK}  -rise 0.100 -fall 0.100
define_input_delay -disable  -comment {"}  {MX2}  -rise 0.100 -fall 0.100
define_output_delay -disable  -comment {"}  {MX2}  -rise 0.100 -fall 0.100
define_input_delay -disable  -comment {"}  {MXOSC_FEB}  -rise 0.100 -fall 0.100
define_input_delay -disable  -comment {"}  {MXOSC_S0}  -rise 0.100 -fall 0.100
define_input_delay -disable  -comment {"}  {MXOSC_S1}  -rise 0.100 -fall 0.100
define_output_delay -disable  -comment {"}  {MXOUT}  -rise 0.100 -fall 0.100
define_input_delay           -comment {Timing not important for GPIO, allow one full cycle}  {PA0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PA0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PA1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PA1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PA2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PA2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PA3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PA3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PA4}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PA4}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PA5}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PA5}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PA6}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PA6}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PA7}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PA7}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PB0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PB0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PB1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PB1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PB2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PB2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PB3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PB3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PB4}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PB4}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PB5}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PB5}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PB6}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PB6}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PB7}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PB7}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {Require 8 ns setup/0 ns hold for DREQ signals on the I/O bus}  {PC0_IDREQ4}  -rise 4.000 -fall 4.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PC1_IDREQ5}  -rise 4.000 -fall 4.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PC2_IDREQ6}  -rise 4.000 -fall 4.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PC3_IDREQ7}  -rise 4.000 -fall 4.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_output_delay           -comment {Offer 5.5 ns setup/1 ns hold for control signals on the I/O bus}  {PC4_IDACK4}  -rise 5.500 -fall 5.500 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PC5_IDACK5}  -rise 5.500 -fall 5.500 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PC6_IDACK6}  -rise 5.500 -fall 5.500 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PC7_IDACK7}  -rise 5.500 -fall 5.500 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {Timing not important for GPIO, allow one full cycle}  {PC0_IDREQ4}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PC1_IDREQ5}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PC2_IDREQ6}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PC3_IDREQ7}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PC4_IDACK4}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PC5_IDACK5}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PC6_IDACK6}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PC7_IDACK7}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {Timing not important for GPIO, allow one full cycle}  {PC0_IDREQ4}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PC1_IDREQ5}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PC2_IDREQ6}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PC3_IDREQ7}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PC4_IDACK4}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PC5_IDACK5}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PC6_IDACK6}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PC7_IDACK7}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PE0_UTX2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PE0_UTX2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PE1_URX2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PE1_URX2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PE2_URTS2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PE2_URTS2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PE3_UCTS2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PE3_UCTS2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PE4_UTX3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PE4_UTX3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PE5_URX3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PE5_URX3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PE6_URTS3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PE6_URTS3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PE7_UCTS3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PE7_UCTS3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {4 ns setup/2 ns hold specified in RMII spec}  {PF0_ETXEN}  -rise 4.000 -fall 4.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ETXCLK:r}
define_output_delay           -comment {"}  {PF2_ETXD0}  -rise 4.000 -fall 4.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ETXCLK:r}
define_output_delay           -comment {"}  {PF3_ETXD1}  -rise 4.000 -fall 4.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ETXCLK:r}
define_output_delay           -comment {"}  {PG0_ETXER}  -rise 4.000 -fall 4.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ETXCLK:r}
define_output_delay           -comment {"}  {PG2_ETXD2}  -rise 4.000 -fall 4.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ETXCLK:r}
define_output_delay           -comment {"}  {PG3_ETXD3}  -rise 4.000 -fall 4.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ETXCLK:r}
define_input_delay           -comment {4 ns setup/2 ns hold specified in RMII spec}  {PF4_ERXDV}  -rise 16.000 -fall 16.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ERXCLK:r}
define_input_delay           -comment {"}  {PF5_ERXER}  -rise 16.000 -fall 16.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ERXCLK:r}
define_input_delay           -comment {"}  {PF6_ERXD0}  -rise 16.000 -fall 16.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ERXCLK:r}
define_input_delay           -comment {"}  {PF7_ERXD1}  -rise 16.000 -fall 16.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ERXCLK:r}
define_input_delay           -comment {"}  {PG4_ECOL}  -rise 16.000 -fall 16.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ERXCLK:r}
define_input_delay           -comment {"}  {PG5_ECRS}  -rise 16.000 -fall 16.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ERXCLK:r}
define_input_delay           -comment {"}  {PG6_ERXD2}  -rise 16.000 -fall 16.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ERXCLK:r}
define_input_delay           -comment {"}  {PG7_ERXD3}  -rise 16.000 -fall 16.000 -min_rise 2.000 -min_fall 2.000 -ref {clk_ERXCLK:r}
define_output_delay -disable  -comment {Timing not important for GPIO, allow one full cycle}  {PF0_ETXEN}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PF2_ETXD0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PF3_ETXD1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PG0_ETXER}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PG2_ETXD2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PG3_ETXD3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PF4_ERXDV}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PF5_ERXER}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PF6_ERXD0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PF7_ERXD1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PG4_ECOL}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PG5_ECRS}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PG6_ERXD2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PG7_ERXD3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {Timing not important for GPIO, allow one full cycle}  {PF0_ETXEN}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PF1_ETXCLK}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PF1_ETXCLK}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PF2_ETXD0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PF3_ETXD1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PF4_ERXDV}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PF5_ERXER}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PF6_ERXD0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PF7_ERXD1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PG0_ETXER}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PG1_ERXCLK}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PG1_ERXCLK}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PG2_ETXD2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PG3_ETXD3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PG4_ECOL}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PG5_ECRS}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PG6_ERXD2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PG7_ERXD3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {Require 8 ns setup/0 ns hold for DREQ signals on the I/O bus}  {PH0_IDREQ0}  -rise 4.000 -fall 4.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PH1_IDREQ1}  -rise 4.000 -fall 4.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PH2_IDREQ2}  -rise 4.000 -fall 4.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PH3_IDREQ3}  -rise 4.000 -fall 4.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_output_delay           -comment {Offer 5.5 ns setup/1 ns hold for DACK signals on the I/O bus}  {PH4_IDACK0}  -rise 5.500 -fall 5.500 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PH5_IDACK1}  -rise 5.500 -fall 5.500 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PH6_IDACK2}  -rise 5.500 -fall 5.500 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PH7_IDACK3}  -rise 5.500 -fall 5.500 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {Timing not important for GPIO, allow one full cycle}  {PH0_IDREQ0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PH1_IDREQ1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PH2_IDREQ2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay -disable  -comment {"}  {PH3_IDREQ3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PH4_IDACK0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PH5_IDACK1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PH6_IDACK2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PH7_IDACK3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {Timing not important for GPIO, allow one full cycle}  {PH0_IDREQ0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PH1_IDREQ1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PH2_IDREQ2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PH3_IDREQ3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PH4_IDACK0}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PH5_IDACK1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PH6_IDACK2}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PH7_IDACK3}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {Require 4 ns setup/0 ns hold for data on the I/O bus}  {PI0_ID0}  -rise 8.000 -fall 8.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PI1_ID1}  -rise 8.000 -fall 8.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PI2_ID2}  -rise 8.000 -fall 8.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PI3_ID3}  -rise 8.000 -fall 8.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PI4_ID4}  -rise 8.000 -fall 8.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PI5_ID5}  -rise 8.000 -fall 8.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PI6_ID6}  -rise 8.000 -fall 8.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PI7_ID7}  -rise 8.000 -fall 8.000 -min_rise 0.000 -min_fall 0.000 -ref {clk_ICLK:r}
define_output_delay           -comment {Offer 4 ns setup/1 ns hold for data on the I/O bus}  {PI0_ID0}  -rise 4.000 -fall 4.000 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PI1_ID1}  -rise 4.000 -fall 4.000 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PI2_ID2}  -rise 4.000 -fall 4.000 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PI3_ID3}  -rise 4.000 -fall 4.000 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PI4_ID4}  -rise 4.000 -fall 4.000 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PI5_ID5}  -rise 4.000 -fall 4.000 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PI6_ID6}  -rise 4.000 -fall 4.000 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PI7_ID7}  -rise 4.000 -fall 4.000 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {Offer 8 ns setup/1 ns hold forcontrol signals on the I/O bus}  {PJ4_INEXT}  -rise 8.000 -fall 8.000 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PJ5_ILDOUT}  -rise 8.000 -fall 8.000 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PJ6_ILIOA}  -rise 8.000 -fall 8.000 -min_rise 1.000 -min_fall 1.000 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {Timing not important for GPIO, allow one full cycle}  {PJ4_INEXT}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PJ5_ILDOUT}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay -disable  -comment {"}  {PJ6_ILIOA}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {Timing not important for GPIO, allow one full cycle}  {PJ0_UTX1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PJ0_UTX1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PJ1_URX1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PJ1_URX1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PJ2_URTS1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PJ2_URTS1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PJ3_UCTS1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PJ3_UCTS1}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PJ4_INEXT}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PJ5_ILDOUT}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PJ6_ILIOA}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_input_delay           -comment {"}  {PJ7_ICLK}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}
define_output_delay           -comment {"}  {PJ7_ICLK}  -rise 0.100 -fall 0.100 -ref {clk_ICLK:r}

#
# Drivers
#

#
# Loads
#
define_load -disable  -input_default 
define_load -disable  -output_default 
define_load           -comment {Max for two chips, min for one chip}  {DA0}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DA1}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DA10}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DA11}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DA12}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DA13}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DA2}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DA3}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DA4}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DA5}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DA6}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DA7}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DA8}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DA9}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DBA0}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DBA1}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DCAS}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DCKE0}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DCKE1}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DCKE2}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DCKE3}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DCLK}  -load 8.000 -min_load 2.500
define_load           -comment {"}  {DCS}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DDQ0}  -load 13.000 -min_load 4.000
define_load           -comment {"}  {DDQ1}  -load 13.000 -min_load 4.000
define_load           -comment {"}  {DDQ2}  -load 13.000 -min_load 4.000
define_load           -comment {"}  {DDQ3}  -load 13.000 -min_load 4.000
define_load           -comment {"}  {DDQ4}  -load 13.000 -min_load 4.000
define_load           -comment {"}  {DDQ5}  -load 13.000 -min_load 4.000
define_load           -comment {"}  {DDQ6}  -load 13.000 -min_load 4.000
define_load           -comment {"}  {DDQ7}  -load 13.000 -min_load 4.000
define_load           -comment {"}  {DRAS}  -load 10.000 -min_load 2.500
define_load           -comment {"}  {DWE}  -load 10.000 -min_load 2.500
define_load           {MBYPASS}  -load 10.000 -min_load 5.000
define_load           {MCKOUT0}  -load 10.000 -min_load 5.000
define_load           {MCKOUT1}  -load 10.000 -min_load 5.000
define_load           {MEXEC}  -load 10.000 -min_load 5.000
define_load           {MI_MEASURE}  -load 10.000 -min_load 5.000
define_load           {MIRQ0}  -load 10.000 -min_load 5.000
define_load           {MIRQ1}  -load 10.000 -min_load 5.000
define_load           {MIRQOUT}  -load 10.000 -min_load 5.000
define_load           {MPLL_TSTE}  -load 10.000 -min_load 5.000
define_load           {MPLL_TSTO}  -load 10.000 -min_load 5.000
define_load           {MPOR_TSTO}  -load 10.000 -min_load 5.000
define_load           {MPORDIS}  -load 10.000 -min_load 5.000
define_load           {MRESET}  -load 10.000 -min_load 5.000
define_load           {MRSTOUT}  -load 10.000 -min_load 5.000
define_load           {MRTC_TSTE}  -load 10.000 -min_load 5.000
define_load           {MRTC_TSTO}  -load 10.000 -min_load 5.000
define_load           {MRX1}  -load 10.000 -min_load 5.000
define_load           {MRX2}  -load 10.000 -min_load 5.000
define_load           {MRXOUT}  -load 10.000 -min_load 5.000
define_load           {MSDIN}  -load 10.000 -min_load 5.000
define_load           {MSDOUT}  -load 10.000 -min_load 5.000
define_load           {MTEST}  -load 10.000 -min_load 5.000
define_load           {MWAKE}  -load 10.000 -min_load 5.000
define_load           {MVRIN}  -load 10.000 -min_load 5.000
define_load           {MVROUT}  -load 10.000 -min_load 5.000
define_load           {MX1_CK}  -load 10.000 -min_load 5.000
define_load           {MX2}  -load 10.000 -min_load 5.000
define_load           {MXOSC_TSTE}  -load 10.000 -min_load 5.000
define_load           {MXOSC_TSTO}  -load 10.000 -min_load 5.000
define_load           {MXOUT}  -load 10.000 -min_load 5.000
define_load           {PA0}  -load 10.000 -min_load 5.000
define_load           {PA1}  -load 10.000 -min_load 5.000
define_load           {PA2}  -load 10.000 -min_load 5.000
define_load           {PA3}  -load 10.000 -min_load 5.000
define_load           {PA4}  -load 10.000 -min_load 5.000
define_load           {PA5}  -load 10.000 -min_load 5.000
define_load           {PA6}  -load 10.000 -min_load 5.000
define_load           {PA7}  -load 10.000 -min_load 5.000
define_load           {PB0}  -load 10.000 -min_load 5.000
define_load           {PB1}  -load 10.000 -min_load 5.000
define_load           {PB2}  -load 10.000 -min_load 5.000
define_load           {PB3}  -load 10.000 -min_load 5.000
define_load           {PB4}  -load 10.000 -min_load 5.000
define_load           {PB5}  -load 10.000 -min_load 5.000
define_load           {PB6}  -load 10.000 -min_load 5.000
define_load           {PB7}  -load 10.000 -min_load 5.000
define_load           {PC0_IDREQ4}  -load 10.000 -min_load 5.000
define_load           {PC1_IDREQ5}  -load 10.000 -min_load 5.000
define_load           {PC2_IDREQ6}  -load 10.000 -min_load 5.000
define_load           {PC3_IDREQ7}  -load 10.000 -min_load 5.000
define_load           {PC4_IDACK4}  -load 10.000 -min_load 5.000
define_load           {PC5_IDACK5}  -load 10.000 -min_load 5.000
define_load           {PC6_IDACK6}  -load 10.000 -min_load 5.000
define_load           {PC7_IDACK7}  -load 10.000 -min_load 5.000
define_load           -comment {Max/min for one chip}  {PD0_DDQM0}  -load 5.000 -min_load 2.500
define_load           -comment {"}  {PD1_DDQM1}  -load 5.000 -min_load 2.500
define_load           -comment {"}  {PD2_DDQM2}  -load 5.000 -min_load 2.500
define_load           -comment {"}  {PD3_DDQM3}  -load 5.000 -min_load 2.500
define_load           -comment {"}  {PD4_DDQM4}  -load 5.000 -min_load 2.500
define_load           -comment {"}  {PD5_DDQM5}  -load 5.000 -min_load 2.500
define_load           -comment {"}  {PD6_DDQM6}  -load 5.000 -min_load 2.500
define_load           -comment {"}  {PD7_DDQM7}  -load 5.000 -min_load 2.500
define_load           {PE0_UTX2}  -load 10.000 -min_load 5.000
define_load           {PE1_URX2}  -load 10.000 -min_load 5.000
define_load           {PE2_URTS2}  -load 10.000 -min_load 5.000
define_load           {PE3_UCTS2}  -load 10.000 -min_load 5.000
define_load           {PE4_UTX3}  -load 10.000 -min_load 5.000
define_load           {PE5_URX3}  -load 10.000 -min_load 5.000
define_load           {PE6_URTS3}  -load 10.000 -min_load 5.000
define_load           {PE7_UCTS3}  -load 10.000 -min_load 5.000
define_load           {PF0_ETXEN}  -load 10.000 -min_load 2.500
define_load           {PF1_ETXCLK}  -load 10.000 -min_load 2.500
define_load           {PF2_ETXD0}  -load 10.000 -min_load 2.500
define_load           {PF3_ETXD1}  -load 10.000 -min_load 2.500
define_load           {PF4_ERXDV}  -load 10.000 -min_load 2.500
define_load           {PF5_ERXER}  -load 10.000 -min_load 2.500
define_load           {PF6_ERXD0}  -load 10.000 -min_load 2.500
define_load           {PF7_ERXD1}  -load 10.000 -min_load 2.500
define_load           {PG0_ETXER}  -load 10.000 -min_load 2.500
define_load           {PG1_ERXCLK}  -load 10.000 -min_load 2.500
define_load           {PG2_ETXD2}  -load 10.000 -min_load 2.500
define_load           {PG3_ETXD3}  -load 10.000 -min_load 2.500
define_load           {PG4_ECOL}  -load 10.000 -min_load 2.500
define_load           {PG5_ECRS}  -load 10.000 -min_load 2.500
define_load           {PG6_ERXD2}  -load 10.000 -min_load 2.500
define_load           {PG7_ERXD3}  -load 10.000 -min_load 2.500
define_load           {PH0_IDREQ0}  -load 10.000 -min_load 5.000
define_load           {PH1_IDREQ1}  -load 10.000 -min_load 5.000
define_load           {PH2_IDREQ2}  -load 10.000 -min_load 5.000
define_load           {PH3_IDREQ3}  -load 10.000 -min_load 5.000
define_load           {PH4_IDACK0}  -load 10.000 -min_load 5.000
define_load           {PH5_IDACK1}  -load 10.000 -min_load 5.000
define_load           {PH6_IDACK2}  -load 10.000 -min_load 5.000
define_load           {PH7_IDACK3}  -load 10.000 -min_load 5.000
define_load           {PI0_ID0}  -load 10.000 -min_load 5.000
define_load           {PI1_ID1}  -load 10.000 -min_load 5.000
define_load           {PI2_ID2}  -load 10.000 -min_load 5.000
define_load           {PI3_ID3}  -load 10.000 -min_load 5.000
define_load           {PI4_ID4}  -load 10.000 -min_load 5.000
define_load           {PI5_ID5}  -load 10.000 -min_load 5.000
define_load           {PI6_ID6}  -load 10.000 -min_load 5.000
define_load           {PI7_ID7}  -load 10.000 -min_load 5.000
define_load           {PJ0_UTX1}  -load 10.000 -min_load 5.000
define_load           {PJ1_URX1}  -load 10.000 -min_load 5.000
define_load           {PJ2_URTS1}  -load 10.000 -min_load 5.000
define_load           {PJ3_UCTS1}  -load 10.000 -min_load 5.000
define_load           {PJ4_INEXT}  -load 10.000 -min_load 5.000
define_load           {PJ5_ILDOUT}  -load 10.000 -min_load 5.000
define_load           {PJ6_ILIOA}  -load 10.000 -min_load 5.000
define_load           {PJ7_ICLK}  -load 10.000 -min_load 5.000

#
# Multicycle Path
#
define_multicycle_path           -comment {dbus has a path to the gmem address on single-byte read operations, but these are only performed on rising clk_e edges.}  -through {n:dbus[7:0]}  -to {gmem}  2
define_multicycle_path           -comment {ybus has a path to the gmem address on single-byte read operations, but these are only performed on rising clk_e edges.}  -through {n:core0.ybus[7:0]}  -to {gmem}  2
define_multicycle_path           -comment {Pipeline register fields pl_gapp, pl_gacs, pl_gacd affect gmem address directly, but only on rising clk_e edges.}  -from {i:core0.pl[7:3]}  -to {gmem}  2
define_multicycle_path           -comment {DMA data is written only at the end of clk_i, but IOMEM is clocked by clk_c}  -from {p:PI0_ID0}  -to {iomem?}  2
define_multicycle_path           -comment {"}  -from {p:PI1_ID1}  -to {iomem?}  2
define_multicycle_path           -comment {"}  -from {p:PI2_ID2}  -to {iomem?}  2
define_multicycle_path           -comment {"}  -from {p:PI3_ID3}  -to {iomem?}  2
define_multicycle_path           -comment {"}  -from {p:PI4_ID4}  -to {iomem?}  2
define_multicycle_path           -comment {"}  -from {p:PI5_ID5}  -to {iomem?}  2
define_multicycle_path           -comment {"}  -from {p:PI6_ID6}  -to {iomem?}  2
define_multicycle_path           -comment {"}  -from {p:PI7_ID7}  -to {iomem?}  2
define_multicycle_path           -comment {DREQ is valid only at the end of clk_i, but IOMEM is clocked by clk_c}  -through {n:idreq[7:0]}  -to {i:core0.ios.ios_dma0.ido_le}  2
define_multicycle_path           -comment {"}  -through {n:idreq[7:0]}  -to {iomem?}  2

#
# False Path
#
define_false_path           -comment {Reading bmem is non-critical, extra cycles can be inserted between read access and capture of output data.}  -from {i:bmem} 
define_false_path           -comment {The prescaler is the only crb_out source that is clocked by clk_p, must false-path it to avoid having ALU operations constained to one clk_p cycle. User must read it twice and compare to be sure the reading is correct.}  -from {i:core0.tim.prescale3[4]}  -through {n:core0.crb_out[4]} 
define_false_path           -comment {"}  -from {i:core0.tim.prescale3[3]}  -through {n:core0.crb_out[3]} 
define_false_path           -comment {"}  -from {i:core0.tim.prescale3[2]}  -through {n:core0.crb_out[2]} 
define_false_path           -comment {"}  -from {i:core0.tim.prescale3[1]}  -through {n:core0.crb_out[1]} 
define_false_path           -comment {"}  -from {i:core0.tim.prescale3[0]}  -through {n:core0.crb_out[0]} 
define_false_path           -comment {Enables for ports with hold time requirements are static when the hold requirement applies}  -from {i:peri0.ports.pen_int_3[0]}  -to {p:PD0_DDQM0} 
define_false_path           -comment {"}  -from {i:peri0.ports.pen_int_3[1]}  -to {p:PD1_DDQM1} 
define_false_path           -comment {"}  -from {i:peri0.ports.pen_int_3[2]}  -to {p:PD2_DDQM2} 
define_false_path           -comment {"}  -from {i:peri0.ports.pen_int_3[3]}  -to {p:PD3_DDQM3} 
define_false_path           -comment {"}  -from {i:peri0.ports.pen_int_3[4]}  -to {p:PD4_DDQM4} 
define_false_path           -comment {"}  -from {i:peri0.ports.pen_int_3[5]}  -to {p:PD5_DDQM5} 
define_false_path           -comment {"}  -from {i:peri0.ports.pen_int_3[6]}  -to {p:PD6_DDQM6} 
define_false_path           -comment {"}  -from {i:peri0.ports.pen_int_3[7]}  -to {p:PD7_DDQM7} 
define_false_path           -comment {"}  -from {i:peri0.ports.pjen[4]}  -to {p:PJ4_INEXT} 
define_false_path           -comment {"}  -from {i:peri0.ports.pjen[5]}  -to {p:PJ5_ILDOUT} 
define_false_path           -comment {"}  -from {i:peri0.ports.pjen[6]}  -to {p:PJ6_ILIOA} 
define_false_path           -comment {"}  -from {i:peri0.ports.pcen[4]}  -to {p:PC4_IDACK4} 
define_false_path           -comment {"}  -from {i:peri0.ports.pcen[5]}  -to {p:PC5_IDACK5} 
define_false_path           -comment {"}  -from {i:peri0.ports.pcen[6]}  -to {p:PC6_IDACK6} 
define_false_path           -comment {"}  -from {i:peri0.ports.pcen[7]}  -to {p:PC7_IDACK7} 
define_false_path           -comment {"}  -from {i:peri0.ports.phen[4]}  -to {p:PH4_IDACK0} 
define_false_path           -comment {"}  -from {i:peri0.ports.phen[5]}  -to {p:PH5_IDACK1} 
define_false_path           -comment {"}  -from {i:peri0.ports.phen[6]}  -to {p:PH6_IDACK2} 
define_false_path           -comment {"}  -from {i:peri0.ports.phen[7]}  -to {p:PH7_IDACK3} 
define_false_path           -comment {D-bit test not allowed when DSOURCE is GMEM}  -from {i:gmem}  -through {n:core0.d_bittst} 
define_false_path           -comment {D-bit test not allowed when DSOURCE is CU}  -through {n:core0.dsi[7:0]}  -through {n:core0.d_bittst} 
define_false_path           -comment {These are paths from the timer block to ports.}  -through {n:peri0.pulseout[7:0]}  -to {p:PD7_DDQM7} 
define_false_path           -comment {"}  -through {n:peri0.pulseout[7:0]}  -to {p:PC7_IDACK7} 
define_false_path           -comment {"}  -through {n:peri0.pulseout[7:0]}  -to {p:PC6_IDACK6} 
define_false_path           -comment {"}  -through {n:peri0.pulseout[7:0]}  -to {p:PC5_IDACK5} 
define_false_path           -comment {"}  -through {n:peri0.pulseout[7:0]}  -to {p:PC4_IDACK4} 
define_false_path           -comment {"}  -through {n:peri0.pulseout[7:0]}  -to {p:PC3_IDREQ7} 
define_false_path           -comment {"}  -through {n:peri0.pulseout[7:0]}  -to {p:PC2_IDREQ6} 
define_false_path           -comment {"}  -through {n:peri0.pulseout[7:0]}  -to {p:PC1_IDREQ5} 
define_false_path           -comment {"}  -through {n:peri0.pulseout[7:0]}  -to {p:PC0_IDREQ4} 
define_false_path           -comment {These are paths from ports to the timer block.}  -from {p:PC7_IDACK7}  -through {n:peri0.cpt_trig[7:0]} 
define_false_path           -comment {"}  -from {p:PC6_IDACK6}  -through {n:peri0.cpt_trig[7:0]} 
define_false_path           -comment {"}  -from {p:PC5_IDACK5}  -through {n:peri0.cpt_trig[7:0]} 
define_false_path           -comment {"}  -from {p:PC4_IDACK4}  -through {n:peri0.cpt_trig[7:0]} 
define_false_path           -comment {"}  -from {p:PC3_IDREQ7}  -through {n:peri0.cpt_trig[7:0]} 
define_false_path           -comment {"}  -from {p:PC2_IDREQ6}  -through {n:peri0.cpt_trig[7:0]} 
define_false_path           -comment {"}  -from {p:PC1_IDREQ5}  -through {n:peri0.cpt_trig[7:0]} 
define_false_path           -comment {"}  -from {p:PC0_IDREQ4}  -through {n:peri0.cpt_trig[7:0]} 
define_false_path -disable  -comment {byte_cnt is a part of the logic expression for held_e, but it is masked by another signal that is never active in the cycle following a change in byte_cnt.}  -from {i:core0.cpc.byte_cnt[3]}  -through {n:core0.held_e} 
define_false_path -disable  -comment {"}  -from {i:core0.cpc.byte_cnt[2]}  -through {n:core0.held_e} 
define_false_path -disable  -comment {"}  -from {i:core0.cpc.byte_cnt[1]}  -through {n:core0.held_e} 
define_false_path -disable  -comment {"}  -from {i:core0.cpc.byte_cnt[0]}  -through {n:core0.held_e} 
define_false_path           -comment {These are settings flipflops in the CRB block. They are only changed at times when their state does not matter.}  -from {i:core0.crb.r_size_int[1]} 
define_false_path           -comment {"}  -from {i:core0.crb.r_size_int[0]} 
define_false_path           -comment {"}  -from {i:core0.crb.c_size_int[1]} 
define_false_path           -comment {"}  -from {i:core0.crb.c_size_int[0]} 
define_false_path           -comment {"}  -from {i:core0.crb.dqm_size_int[1]} 
define_false_path           -comment {"}  -from {i:core0.crb.dqm_size_int[0]} 
define_false_path           -comment {"}  -from {i:core0.crb.fast_d_int} 
define_false_path           -comment {"}  -from {i:core0.crb.t_ras_int[2]} 
define_false_path           -comment {"}  -from {i:core0.crb.t_ras_int[1]} 
define_false_path           -comment {"}  -from {i:core0.crb.t_ras_int[0]} 
define_false_path           -comment {"}  -from {i:core0.crb.t_rcd_int[1]} 
define_false_path           -comment {"}  -from {i:core0.crb.t_rcd_int[0]} 
define_false_path           -comment {"}  -from {i:core0.crb.t_rp_int[1]} 
define_false_path           -comment {"}  -from {i:core0.crb.t_rp_int[0]} 
define_false_path           -comment {"}  -from {i:core0.crb.en_uart1_int} 
define_false_path           -comment {"}  -from {i:core0.crb.en_uart2_int} 
define_false_path           -comment {"}  -from {i:core0.crb.en_uart3_int} 
define_false_path           -comment {"}  -from {i:core0.crb.en_eth_int[1]} 
define_false_path           -comment {"}  -from {i:core0.crb.en_eth_int[0]} 
define_false_path           -comment {"}  -from {i:core0.crb.en_iobus_int[1]} 
define_false_path           -comment {"}  -from {i:core0.crb.en_iobus_int[0]} 
define_false_path           -comment {I/O's with irrelevant timing}  -from {p:MBYPASS} 
define_false_path           -comment {"}  -to {p:MCKOUT0} 
define_false_path           -comment {"}  -to {p:MCKOUT1} 
define_false_path           -comment {"}  -to {p:MEXEC} 
define_false_path           -comment {"}  -from {p:MIRQ0} 
define_false_path           -comment {"}  -from {p:MIRQ1} 
define_false_path           -comment {"}  -to {p:MIRQOUT} 
define_false_path           -comment {"}  -from {p:MPLL_TSTO} 
define_false_path           -comment {"}  -to {p:MPLL_TSTO} 
define_false_path           -comment {"}  -from {p:MPORDIS} 
define_false_path           -comment {"}  -from {p:MRESET} 
define_false_path           -comment {"}  -to {p:MRSTOUT} 
define_false_path           -comment {"}  -to {p:MRXOUT} 
define_false_path           -comment {"}  -from {p:MSDIN} 
define_false_path           -comment {"}  -to {p:MSDOUT} 
define_false_path           -comment {"}  -from {p:MTEST} 
define_false_path           -comment {"}  -from {p:MWAKE} 
define_false_path           -comment {"}  -from {p:MX1_CK} 
define_false_path           -comment {"}  -from {p:MX2} 
define_false_path           -comment {"}  -to {p:MX2} 
define_false_path           -comment {"}  -from {p:MXOSC_FEB} 
define_false_path           -comment {"}  -from {p:MXOSC_S0} 
define_false_path           -comment {"}  -from {p:MXOSC_S1} 
define_false_path           -comment {"}  -to {p:MXOUT} 

#
# Delay Path
#

#
# Attributes
#
define_attribute          {v:work.clk_gen} syn_hier {hard}
define_attribute -disable {v:work.core} syn_hier {hard, flatten}
define_attribute          {v:work.core} syn_hier {hard}
define_attribute -disable {v:work.peri} syn_hier {hard, flatten}
define_attribute          {v:work.peri} syn_hier {hard}
define_attribute -disable {v:work.rtc} syn_hier {hard, flatten}
define_attribute          {v:work.rtc} syn_hier {hard}
define_attribute          {v:work.pads} syn_hier {hard}
define_attribute          {v:work.adc} syn_hier {hard}
define_attribute          {v:work.alu} syn_hier {hard}
define_attribute          {v:work.clc} syn_hier {hard}
define_attribute          {v:work.clk_gen} syn_hier {hard}
define_attribute          {v:work.cpc} syn_hier {hard}
define_attribute          {v:work.crb} syn_hier {hard}
define_attribute          {v:work.dac} syn_hier {hard}
define_attribute          {v:work.debug_trace} syn_hier {hard}
define_attribute          {v:work.dsl} syn_hier {hard}
define_attribute          {v:work.eth} syn_hier {hard}
define_attribute          {v:work.eth_crc} syn_hier {hard}
define_attribute          {v:work.eth_rxZ0} syn_hier {hard}
define_attribute          {v:work.eth_rxZ1} syn_hier {hard}
define_attribute          {v:work.eth_tx} syn_hier {hard}
define_attribute          {v:work.fgen} syn_hier {hard}
define_attribute          {v:work.fgendec} syn_hier {hard}
define_attribute          {v:work.fgenhalf} syn_hier {hard}
define_attribute          {v:work.fgenpart} syn_hier {hard}
define_attribute          {v:work.gmem} syn_hier {hard}
define_attribute          {v:work.io_mux} syn_hier {hard}
define_attribute          {v:work.ios} syn_hier {hard}
define_attribute          {v:work.ios_dackgen} syn_hier {hard}
define_attribute          {v:work.ios_dma} syn_hier {hard}
define_attribute          {v:work.ios_dmap} syn_hier {hard}
define_attribute          {v:work.mbm} syn_hier {hard}
define_attribute          {v:work.mmr} syn_hier {hard}
define_attribute          {v:work.mpgm} syn_hier {hard}
define_attribute          {v:work.mpll} syn_hier {hard}
define_attribute          {v:work.pdi} syn_hier {hard}
define_attribute          {v:work.port_mux} syn_hier {hard}
define_attribute          {v:work.ports} syn_hier {hard}
define_attribute          {v:work.ram32x8} syn_hier {hard}
define_attribute          {v:work.sct} syn_hier {hard}
define_attribute          {v:work.stack9x14} syn_hier {hard}
define_attribute          {v:work.tiu} syn_hier {hard}
define_attribute          {v:work.uartZ0} syn_hier {hard}
define_attribute          {v:work.uartZ1} syn_hier {hard}
define_attribute          {v:work.uartZ2} syn_hier {hard}
define_attribute          {v:work.tim} syn_hier {hard}

#
# Compile Points
#

#
# Other Constraints
#
