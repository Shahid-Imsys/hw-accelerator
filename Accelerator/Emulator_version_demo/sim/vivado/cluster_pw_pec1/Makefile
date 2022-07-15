

all: work  rtl tb elab

rtl: pec_rtl 

etb: tb elab

tb: cluster_pw_pec1_tb 

elab:
	xelab --debug typical c_tb

sim:
	$(SIM) $(SIM_FLAGS) work.c_tb --autoloadwcfg
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

