IONOC_TB_DIR=$(PROJECT_PATH)/Processors/IM3000E/tb/ionoc_tb
IONOC_TB_DIR_WIN=$(PROJECT_PATH_WIN)/Processors/IM3000E/tb/ionoc_tb

ionoc_tb : package
	$(COMP) $(COMP_TB_FLAGS) $(IONOC_TB_DIR_WIN)/ionoc_tb.vhd

package:
	$(COMP) $(COMP_TB_FLAGS) $(IONOC_TB_DIR_WIN)/../../src/gp_pkg.vhd
