DIG_TOP_DIR=$(PROJECT_PATH)/Digital_top/src
DIG_TOP_DIR_WIN=$(PROJECT_PATH_WIN)/Digital_top/src

digital_top_rtl: digital_core_rtl test_spi_interface
	$(COMP) $(COMP_RTL_FLAGS) $(DIG_TOP_DIR_WIN)/clock_gate.vhd \
				  $(DIG_TOP_DIR_WIN)/reset_sync.vhd \
				  $(DIG_TOP_DIR_WIN)/clk_mux_top.vhd \
				  $(DIG_TOP_DIR_WIN)/fpga_clock_reset.vhd \
				  $(DIG_TOP_DIR_WIN)/clock_reset.vhd \
				  $(DIG_TOP_DIR_WIN)/digital_top.vhd

test_spi_interface:
	$(COMP) $(COMP_RTL_FLAGS) $(DIG_TOP_DIR_WIN)/test_spi_interface/project_settings.vhd \
				  $(DIG_TOP_DIR_WIN)/test_spi_interface/register_pack_spi_test.vhd \
				  $(DIG_TOP_DIR_WIN)/test_spi_interface/data_types_pack.vhd \
				  $(DIG_TOP_DIR_WIN)/test_spi_interface/register_block_spi_test.vhd \
				  $(DIG_TOP_DIR_WIN)/test_spi_interface/spi_interface.vhd \
				  $(DIG_TOP_DIR_WIN)/test_spi_interface/test_spi_interface.vhd

include $(PROJECT_PATH)/Digital_core/src/Makefile
