TB_COMP_DIR=$(PROJECT_PATH)/Processors/IM3000E/tb/tb_components
TB_COMP_DIR_WIN=$(PROJECT_PATH_WIN)/Processors/IM3000E/tb/tb_components

tb_comp_rtl : packet
	$(COMP) $(COMP_TB_FLAGS) $(TB_COMP_DIR_WIN)/uart_tb.vhd \
				 $(TB_COMP_DIR_WIN)/debug_interface_bfm.vhd \
				 $(TB_COMP_DIR_WIN)/octo_memory_bfm.vhd

packet:
	$(COMP) $(COMP_TB_FLAGS) $(TB_COMP_DIR_WIN)/digital_sim_pack.vhd \
				 $(TB_COMP_DIR_WIN)/tb_components_pkg.vhd
