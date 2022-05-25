`timescale 10ns/1ns
module rom_bin_to_hex_conv;
   
integer i;
reg [79:0] memory [0:4095]; // 80 bit memory with 4096 entries

initial begin
   $readmemb("../../../Processors/IM3000E/src/ext/mprom0.data",memory);
   $writememh("../Embed-it_Integrator/mprom0.hex", memory);
   $readmemb("../../../Processors/IM3000E/src/ext/mprom1.data",memory);
   $writememh("../Embed-it_Integrator/mprom1.hex", memory);
end
endmodule;
   
