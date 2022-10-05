-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
-- Date        : Wed Oct  5 10:11:30 2022
-- Host        : AliceSim running 64-bit Ubuntu 20.04.5 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/markar/checkouts/ImSys/testMaster/Accelerator/Emulator_version_demo/src/NoC2/IP/boot_memory/boot_memory_stub.vhdl
-- Design      : boot_memory
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcvu9p-flga2104-2L-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity boot_memory is
  Port ( 
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 7 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 27 downto 0 )
  );

end boot_memory;

architecture stub of boot_memory is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,ena,addra[7:0],douta[27:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_5,Vivado 2021.2";
begin
end;
