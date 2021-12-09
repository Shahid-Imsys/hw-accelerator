GPP_TB_DIR=$(PROJECT_PATH)/Processors/IM3000E/tb/sp_boot
GPP_TB_DIR_WIN=$(PROJECT_PATH_WIN)/Processors/IM3000E/tb/sp_boot

gpp_tb:  
	$(COMP) $(COMP_TB_FLAGS) $(GPP_TB_DIR_WIN)/io_utils.vhd
	$(COMP) $(COMP_TB_FLAGS) $(GPP_TB_DIR_WIN)/mti_pkg.vhd
	$(COMP) $(COMP_TB_FLAGS) $(GPP_TB_DIR_WIN)/mt48lc4m16a2.vhd
	$(COMP) $(COMP_TB_FLAGS) $(GPP_TB_DIR_WIN)/spboot_stim.vhd \
				 $(GPP_TB_DIR_WIN)/spboot_tb.vhd
