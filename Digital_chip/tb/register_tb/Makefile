MAIN_TB_DIR=$(PROJECT_PATH)/Digital_chip/tb/register_tb
MAIN_TB_DIR_WIN=$(PROJECT_PATH_WIN)/Digital_chip/tb/register_tb

main_tb_tb: tb_comp_rtl
	$(COMP) $(COMP_TB_FLAGS) $(MAIN_TB_DIR_WIN)/register_test_tb.vhd

include $(PROJECT_PATH)/Digital_chip/tb/tb_components/Makefile
