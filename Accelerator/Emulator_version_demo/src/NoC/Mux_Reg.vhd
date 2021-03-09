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
-- Date       : 2020.11.30
-------------------------------------------------------------------------------
-- Description: -- Mux Register  
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
--              
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-11-30 		     1.0	     AK			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity Mux_Reg is
    port(
        clk                 : in  std_logic;
        Control_Data        : in  std_logic_vector(7 downto 0);
        NoC_Reg_Mux         : out std_logic_vector(1 downto 0);
        EM_PCIecmd_as       : out std_logic;
        MD32B_PCIeCmdReg    : out std_logic;
        NocData_Switch      : out std_logic;
        Unicast_Broadcast   : out std_logic;
        Noc_Bus_Dir         : out std_logic
        );
end Mux_Reg;

architecture Behavioral of Mux_Reg is

    signal Mux_Register     : std_logic_vector(7 downto 0);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            Mux_Register <= Control_Data;
        end if;
    end process;

    NoC_Reg_Mux         <= Mux_Register(1 downto 0);
    EM_PCIecmd_as       <= Mux_Register(2);
    MD32B_PCIeCmdReg    <= Mux_Register(3);
    NocData_Switch      <= Mux_Register(4);
    Unicast_Broadcast   <= Mux_Register(5);
    Noc_Bus_Dir         <= Mux_Register(6);

end Behavioral;


