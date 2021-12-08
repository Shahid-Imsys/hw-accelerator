# Synplicity, Inc. constraint file
# G:\gp3000\src\peri\eth\New Folder\eth.sdc
# Written on Tue Jan 10 16:23:12 2006
# by Synplify ASIC,      Synplify ASIC 2.4.1         Scope Editor

#
# New Clocks
#
define_clock            -name {clk_i}  -period 12.000 -clockgroup default_clkgroup -uncertainty 0.100
define_clock            -name {clk_rx}  -period 40.000 -clockgroup rx_clkgroup -uncertainty 0.100
define_clock            -name {clk_tx}  -period 40.000 -clockgroup tx_clkgroup -uncertainty 0.100

#
# Clock to Clock
#

#
# Inputs/Outputs
#
define_input_delay -disable  -default 
define_output_delay -disable  -default 
define_input_delay -disable  {crc_ok} 
define_output_delay -disable  {early_er_i} 
define_input_delay -disable  {idack_rx} 
define_input_delay -disable  {idi[7:0]} 
define_output_delay -disable  {idreq_rx} 
define_input_delay -disable  {ilioa} 
define_input_delay -disable  {multicast} 
define_input_delay -disable  {promiscuous} 
define_input_delay -disable  {reset} 
define_input_delay -disable  {rx_da_wr} 
define_output_delay -disable  {rx_dout[7:0]} 
define_input_delay -disable  {rx_go} 
define_input_delay -disable  {rx_sts_rd} 
define_input_delay -disable  {rxd[3:0]} 
define_input_delay -disable  {rxdv} 
define_input_delay -disable  {rxer} 
define_output_delay -disable  {sts_dout[7:0]} 
define_output_delay -disable  {sts_empty} 
define_output_delay -disable  {tip} 
define_input_delay -disable  {xreset} 

#
# Drivers
#

#
# Loads
#
define_load -disable  -input_default 
define_load -disable  -output_default 
define_load -disable  {crc_ok} 
define_load -disable  {early_er_i} 
define_load -disable  {idack_rx} 
define_load -disable  {idi[7:0]} 
define_load -disable  {idreq_rx} 
define_load -disable  {ilioa} 
define_load -disable  {multicast} 
define_load -disable  {promiscuous} 
define_load -disable  {reset} 
define_load -disable  {rx_da_wr} 
define_load -disable  {rx_dout[7:0]} 
define_load -disable  {rx_go} 
define_load -disable  {rx_sts_rd} 
define_load -disable  {rxd[3:0]} 
define_load -disable  {rxdv} 
define_load -disable  {rxer} 
define_load -disable  {sts_dout[7:0]} 
define_load -disable  {sts_empty} 
define_load -disable  {tip} 
define_load -disable  {xreset} 

#
# Multicycle Path
#

#
# False Path
#

#
# Delay Path
#

#
# Attributes
#

#
# Compile Points
#

#
# Other Constraints
#
