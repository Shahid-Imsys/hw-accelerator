DIG_CORE_DIR_WIN=$(PROJECT_PATH_WIN)/Digital_core/src

digital_core_rtl: mem_comp gpp_rtl noc2_rtl pec_rtl
	$(COMP) $(COMP_RTL_FLAGS) $(DIG_CORE_DIR_WIN)/digital_core.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(DIG_CORE_DIR_WIN)/noc_adapter.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(DIG_CORE_DIR_WIN)/ionoc.vhd
	$(COMP) $(COMP_RTL_FLAGS) $(DIG_CORE_DIR_WIN)/sync_fifo.vhd

include $(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/NoC2/Makefile
include $(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC/Makefile
include $(PROJECT_PATH)/Processors/IM3000E/src/Makefile
include $(PROJECT_PATH)/IP/Synopsys/Makefile
