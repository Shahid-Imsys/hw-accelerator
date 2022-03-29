MAIN_TB_DIR=$(PROJECT_PATH)/Processors/IM3000E/tb/main_tb
MAIN_TB_DIR_WIN=$(PROJECT_PATH_WIN)/Processors/IM3000E/tb/main_tb

main_tb_tb: tb_comp_rtl
	$(COMP) $(COMP_TB_FLAGS) $(MAIN_TB_DIR_WIN)/main_tb.vhd

include $(PROJECT_PATH)/Processors/IM3000E/tb/tb_components/Makefile
