
`timescale 1 ns / 1 ps 

module load_mpram;

   parameter   initFile    	= "mpram0.data";
      
   integer file;
   integer error;
   
   initial begin

      //------------------------------------------
      // MPRAM00
      // Check if the file exists in the directory.
      
      //file = $fopen(initFile, "r");
      //$ferror(file, error);
      //$fclose(file);
      
      //if (error == 0) begin
	 //$readmemb(initFile, XNVR._NV_MEMORY, 0, 63);	// bin format
	 #50 $readmemb(initFile, mpram_asic.uut.mem_core_array, 0, 2047);
	 $display("%.1fns nvram_controller_tb.dut.i_nvram_top.i_XNVR_64X16P48_VD01.XNVR %m : INFO : Loading Initial File ... %s \n", $realtime, initFile);
      //end

      
   end
endmodule
   
