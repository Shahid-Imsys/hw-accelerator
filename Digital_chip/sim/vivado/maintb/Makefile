TEST_CASE=c1memtest

all: compileSW compileHW

rtl: digital_chip_rtl 

tb: main_tb_tb

elab:
	xelab --relax --debug typical main_tb
sim:
	cp ../../../../fw-test-im3000e/build/bin/Tmpgm.${TEST_CASE}/* .
	$(SIM) $(SIM_FLAGS) work.main_tb

work:
	$(CREATE_WORK)

compileHW: work  rtl tb elab

compileSW: 
	cd ../../../../fw-test-im3000e; \
	mkdir -p build && cd build; \
	cmake -DIMSYS_IMTOOLS_DIR=/opt/tool-imtools ..; \
	cmake --build .; \

ls:
	cd ../../../../fw-test-im3000e/build/bin; \
	ls Tmpgm*.lst | cut -d'.' -f2

clean:
	rm -rf $(WORK_LIB).*
	rm -rf xelab*
	rm -rf xsim*
	rm -rf xvhdl*
	rm -rf xvlog*
	rm -rf vivado*
	rm mpram*

include $(PROJECT_PATH)/Digital_chip/tb/main_tb/Makefile
include $(PROJECT_PATH)/Digital_chip/src/Makefile
#include $(BLOCK_DIR)/package/rtl/Makefile
#include $(VER_DIR)/lib_tb/Makefile
#include $(BLOCK_DIR)/vhd_lib/rtl/Makefile

