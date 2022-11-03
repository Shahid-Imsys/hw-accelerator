
`timescale 1 ns / 1 ps 

module load_ram;

   parameter   initFile    	= "main_mem.mif";
      
   integer file;
   integer error;
   
   initial begin

	 #50 $readmemb(initFile, ram0_asic.uut.mem_core_array, 0, 16383);
	 $display("%.1fns ram0 %m : INFO : Loading Initial File ... %s \n", $realtime, initFile);
      
   end
endmodule
   
