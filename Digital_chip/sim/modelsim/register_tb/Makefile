TEST_CASE=c1memtest

all: compileHW

rtl: digital_chip_rtl 

tb: main_tb_tb

sim:
	$(SIM) $(SIM_FLAGS) work.register_test_tb

work:
	$(CREATE_WORK)

compileHW: work  rtl tb

compileSW: 
	cd ../../../../fw-test-im3000e; \
	mkdir -p build && cd build; \
	cmake -DIMSYS_IMTOOLS_DIR=/opt/tool-imtools ..; \
	cmake --build .; \

ls:
	cd ../../../../fw-test-im3000e/build/bin; \
	ls Tmpgm*.lst | cut -d'.' -f2

clean:
	rm -rf $(WORK_LIB)
	rm -rf transcript
	rm -rf *.wlf

include $(PROJECT_PATH)/Digital_chip/tb/register_tb/Makefile
include $(PROJECT_PATH)/Digital_chip/src/Makefile
#include $(BLOCK_DIR)/package/rtl/Makefile
#include $(VER_DIR)/lib_tb/Makefile
#include $(BLOCK_DIR)/vhd_lib/rtl/Makefile

