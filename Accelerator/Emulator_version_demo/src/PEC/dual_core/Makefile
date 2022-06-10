DUAL_CORE_DIR=$(PROJECT_PATH)/Accelerator/Emulator_version_demo/src/PEC/dual_core/
DUAL_CORE_DIR_WIN=$(PROJECT_PATH_WIN)/Accelerator/Emulator_version_demo/src/PEC/dual_core/

dual_core_rtl:
	$(COMP) $(COMP_RTL_FLAGS) $(DUAL_CORE_DIR_WIN)/mpgmfield_lib.vhd \
				  $(DUAL_CORE_DIR_WIN)/fgenpart.vhd \
				  $(DUAL_CORE_DIR_WIN)/fgenhalf.vhd \
				  $(DUAL_CORE_DIR_WIN)/fgendec.vhd \
				  $(DUAL_CORE_DIR_WIN)/fgen.vhd\
				  $(DUAL_CORE_DIR_WIN)/ram64x8.vhd \
				  $(DUAL_CORE_DIR_WIN)/sct.vhd \
				  $(DUAL_CORE_DIR_WIN)/stack9x14.vhd \
				  $(DUAL_CORE_DIR_WIN)/mpgm.vhd \
				  $(DUAL_CORE_DIR_WIN)/debug_trace.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/mem.vhdl \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/re.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/accumulatoreven.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/accumulatorodd.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/addmul.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/ctrlmap_acc.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/ctrlmap_alu.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/instructiontypes \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/lzod.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/memreg.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/ppadd.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/ppmap1.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/ppshift.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/ve_wctrlpipe.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/vearith.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/vecore.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/vetypes.vhdl \
					$(DUAL_CORE_DIR_WIN)/VE_Ver2/writebuff.vhdl 
	$(COMP) $(COMP_RTL_FLAGS) $(DUAL_CORE_DIR_WIN)/alu.vhd \
			 	  $(DUAL_CORE_DIR_WIN)/clc.vhd \
			 	  $(DUAL_CORE_DIR_WIN)/clk_gen.vhd \
			 	  $(DUAL_CORE_DIR_WIN)/clk_mux.vhd \
			 	  $(DUAL_CORE_DIR_WIN)/cmdr.vhd \
			 	  $(DUAL_CORE_DIR_WIN)/cpc.vhd \
			 	  $(DUAL_CORE_DIR_WIN)/crb.vhd \
				  $(DUAL_CORE_DIR_WIN)/dsl.vhd \
				  $(DUAL_CORE_DIR_WIN)/fgen.vhd \
				  $(DUAL_CORE_DIR_WIN)/gmem.vhd \
				  $(DUAL_CORE_DIR_WIN)/gp_pkg.vhd \
				  $(DUAL_CORE_DIR_WIN)/ios_dackgen.vhd \
				  $(DUAL_CORE_DIR_WIN)/ios_dmap.vhd \
				  $(DUAL_CORE_DIR_WIN)/ios_dma.vhd \
				  $(DUAL_CORE_DIR_WIN)/mbm.vhd \
				  $(DUAL_CORE_DIR_WIN)/mmr.vhd \
				  $(DUAL_CORE_DIR_WIN)/mpll.vhd \
				  $(DUAL_CORE_DIR_WIN)/mpmem_inf.vhd \
				  $(DUAL_CORE_DIR_WIN)/rtc.vhd \
				  $(DUAL_CORE_DIR_WIN)/rtc_iso.vhd \
				  $(DUAL_CORE_DIR_WIN)/sdram_inf.vhd \
				  $(DUAL_CORE_DIR_WIN)/single_top.vhd \
				  $(DUAL_CORE_DIR_WIN)/tim.vhd \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/vetypes.vhdl \
				  $(DUAL_CORE_DIR_WIN)/VE_Ver2/instructiontypes.vhdl \
				  $(DUAL_CORE_DIR_WIN)/ve.vhd \
				  $(DUAL_CORE_DIR_WIN)/core2/acmdr.vhd \
				  $(DUAL_CORE_DIR_WIN)/core2/ampgm.vhd \
				  $(DUAL_CORE_DIR_WIN)/core2/atim.vhd \
				  $(DUAL_CORE_DIR_WIN)/core2/acore.vhd \
				  $(DUAL_CORE_DIR_WIN)/ext/SU180_2048X80X1BM1A.vhd \
				  $(DUAL_CORE_DIR_WIN)/ext/SU180_16384X8X1BM8.vhd \
				  $(DUAL_CORE_DIR_WIN)/ext/SY180_256X32X1CM4.vhd \
				  $(DUAL_CORE_DIR_WIN)/ext/SY180_512X8X1CM8.vhd \
				  $(DUAL_CORE_DIR_WIN)/ext/SY180_1024X8X1CM8.vhd \
				  $(DUAL_CORE_DIR_WIN)/flash_inf.vhd \
				  $(DUAL_CORE_DIR_WIN)/ios.vhd \
			 	  $(DUAL_CORE_DIR_WIN)/core.vhd \
				  $(DUAL_CORE_DIR_WIN)/PE_pair_top.vhd

