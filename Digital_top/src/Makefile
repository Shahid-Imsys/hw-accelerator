DIG_TOP_DIR=$(PROJECT_PATH)/Digital_top/src
DIG_TOP_DIR_WIN=$(PROJECT_PATH_WIN)/Digital_top/src

digital_top_rtl: digital_core_rtl
	$(COMP) $(COMP_RTL_FLAGS) $(DIG_TOP_DIR_WIN)/clock_gate.vhd \
				  $(DIG_TOP_DIR_WIN)/clock_reset.vhd \
				  $(DIG_TOP_DIR_WIN)/digital_top.vhd

include $(PROJECT_PATH)/Digital_core/src/Makefile
