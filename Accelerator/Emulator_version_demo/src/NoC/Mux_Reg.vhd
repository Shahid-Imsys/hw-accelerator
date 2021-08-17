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
-- Title      : Mux Register
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Mux_Reg.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 28.01.2021
-------------------------------------------------------------------------------
-- Description: -- Mux Register  
-------------------------------------------------------------------------------
-- TO-DO list :           
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Mux_Reg is
  Port (
        clk                 : in  std_logic;
        reset               : in  std_logic;
        Load_Mux_Reg        : in  std_logic;
        Control_Data        : in  std_logic_vector(7 downto 0);
        NoC_Reg_Mux         : out std_logic_vector(1 downto 0);
        MD_PCIe_cmd         : out std_logic;
        --NocData_Switch      : out std_logic;
        PCIedata_Switch     : out std_logic;
        Noc_Bus_Dir         : out std_logic
   );
end Mux_Reg;


architecture Behavioral of Mux_Reg is

    signal Mux_register :   std_logic_vector(7 downto 0):= (others => '0');
    
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                Mux_register    <= (others => '0');
            elsif (Load_Mux_Reg = '1') then 
                Mux_register    <=  Control_Data;
            end if;    
        end if;
    end process;
    
    NoC_Reg_Mux         <=  Mux_register(1 downto 0);  
    MD_PCIe_cmd         <=  Mux_register(3);
    PCIedata_Switch     <=  Mux_register(4);
    Noc_Bus_Dir         <=  Mux_register(6);  
    
end Behavioral;
