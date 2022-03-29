

all: work  rtl tb elab

rtl: gpp_rtl 

tb: gpp_tb

elab:
	xelab --debug typical spboot_tb
sim:
	$(SIM) $(SIM_FLAGS) work.spboot_tb

work:
	$(CREATE_WORK)

clean:
	rm -rf $(WORK_LIB)
	rm -rf transcript
	rm -rf *.wlf

include $(PROJECT_PATH)/Processors/IM3000E/tb/sp_boot_preload/Makefile
include $(PROJECT_PATH)/Processors/IM3000E/src/Makefile
#include $(BLOCK_DIR)/package/rtl/Makefile
#include $(VER_DIR)/lib_tb/Makefile
#include $(BLOCK_DIR)/vhd_lib/rtl/Makefile

