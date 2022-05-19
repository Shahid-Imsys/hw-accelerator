OSPI_TB_DIR=$(PROJECT_PATH)/Processors/IM3000E/tb/ospi_tb
OSPI_TB_DIR_WIN=$(PROJECT_PATH_WIN)/Processors/IM3000E/tb/ospi_tb

ospi_tb : package
	$(COMP) $(COMP_TB_FLAGS) $(OSPI_TB_DIR_WIN)/ospi_tb.vhd

package:
	$(COMP) $(COMP_TB_FLAGS) $(OSPI_TB_DIR_WIN)/../../src/gp_pkg.vhd
