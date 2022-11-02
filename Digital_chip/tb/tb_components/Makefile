TB_COMP_DIR=$(PROJECT_PATH)/Digital_chip/tb/tb_components
TB_COMP_DIR_WIN=$(PROJECT_PATH_WIN)/Digital_chip/tb/tb_components

tb_comp_rtl : packet
	$(COMP) $(COMP_TB_FLAGS) $(TB_COMP_DIR_WIN)/uart_tb.vhd \
				 $(TB_COMP_DIR_WIN)/debug_interface_bfm.vhd \
				 $(TB_COMP_DIR_WIN)/octo_memory_bfm.vhd \
				 $(TB_COMP_DIR_WIN)/spiflash_bfm.vhd

packet: test_spi_interface
	$(COMP) $(COMP_TB_FLAGS) $(TB_COMP_DIR_WIN)/digital_sim_pack.vhd \
				 $(TB_COMP_DIR_WIN)/tb_components_pkg.vhd \
				 $(TB_COMP_DIR_WIN)/register_tb_definitions.vhd \
				 $(TB_COMP_DIR_WIN)/register_tb_package.vhd \
				 $(TB_COMP_DIR_WIN)/spi_tb_pack.vhd

include $(PROJECT_PATH)/Digital_top/src/Makefile