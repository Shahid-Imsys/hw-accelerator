

all: work  rtl tb

rtl: pec_rtl 

tb: cluster_tb

sim:
	$(SIM) $(SIM_FLAGS) work.c_tb
work:
	$(CREATE_WORK)

clean:
	rm -rf $(WORK_LIB)
	rm -rf transcript
	rm -rf *.wlf

include $(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC/testbench/Makefile
include $(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC/Makefile
#include $(BLOCK_DIR)/package/rtl/Makefile
#include $(VER_DIR)/lib_tb/Makefile
#include $(BLOCK_DIR)/vhd_lib/rtl/Makefile

