TEST_CASE=c1mem

all: compileSW compileHW

rtl: gpp_rtl 

tb: main_tb_tb

elab:
	xelab --debug typical main_tb
sim:
	$(SIM) $(SIM_FLAGS) work.main_tb

work:
	$(CREATE_WORK)

compileHW: work  rtl tb elab

compileSW: 
	cd ../../../../../fw-test-im3000e; \
	mkdir -p build && cd build; \
	cmake -DIMSYS_IMTOOLS_DIR=/opt/tool-imtools ..; \
	cmake --build .; \
	pwd ; \
	cp bin/Tmpgm.${TEST_CASE}test/* ../../Processors/IM3000E/sim/vivado/maintb/
ls:
	cd ../../../../../fw-test-im3000e/build/bin; \
	ls Tmpgm*.lst

clean:
	rm -rf $(WORK_LIB)
	rm -rf transcript
	rm -rf *.wlf

include $(PROJECT_PATH)/Processors/IM3000E/tb/main_tb/Makefile
include $(PROJECT_PATH)/Processors/IM3000E/src/Makefile
#include $(BLOCK_DIR)/package/rtl/Makefile
#include $(VER_DIR)/lib_tb/Makefile
#include $(BLOCK_DIR)/vhd_lib/rtl/Makefile

