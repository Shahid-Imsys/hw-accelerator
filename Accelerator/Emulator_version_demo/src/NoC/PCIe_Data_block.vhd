-------------------------------------------------------------------------------
--                                                                           --
--   COPYRIGHT (C)                       Imsys Technologies AB,  2005        --
--                                                                           --
--   The copyright to the document(s) herein is the property of Imsys        --
--   Technologies AB, Sweden.                                                --
--                                                                           --
--   The document(s) may be used and/or copied only with the written         --
--   permission from Imsys Technologies AB or in accordance with the         --
--   terms and conditions stipulated in the agreement/contract under         --
--   which the document(s) have been supplied.                               --
--                                                                           --
-------------------------------------------------------------------------------
-- Title      : PCIe_Data_block
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : PCIe_Data_block.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 02.02.2021
-------------------------------------------------------------------------------
-- Description: PCIe Data block
-------------------------------------------------------------------------------
-- TO-DO list :           
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity PCIe_Data_block is
  Port (
        clk                 : in  std_logic;
        reset               : in  std_logic;
        Load_PCIe_CMD_reg   : in  std_logic;
        MD_PCIe_cmd         : in  std_logic;        
        Data_Input          : in  std_logic_vector(7 downto 0);
        Mux_Demux_data      : in  std_logic_vector(255 downto 0);
        Noc_data            : out std_logic_vector(255 downto 0)
   );
end PCIe_Data_block;

architecture Behavioral of PCIe_Data_block is

    signal PCIe_CMD_reg : std_logic_vector(7 downto 0):= ( others => '0');

 begin
 
    process (clk, reset)
    begin  
        if reset = '1' then
            PCIe_CMD_reg  <= (others => '0');
        elsif rising_edge(clk) then
            if Load_PCIe_CMD_reg = '1' then
               PCIe_CMD_reg   <= Data_Input;
            end if;
        end if;
    end process;
    
    Noc_data       <= x"00000000000000000000000000000000000000000000000000000000000000" & PCIe_CMD_reg when MD_PCIe_cmd = '1' else Mux_Demux_data;
        
end Behavioral;