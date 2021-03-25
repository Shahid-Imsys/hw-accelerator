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
-- Title      : Mux_Demux
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Mux_Demux.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 2020.11.17
-------------------------------------------------------------------------------
-- Description: -- NoC Mux/Demux    
-------------------------------------------------------------------------------
-- TO-DO list :           
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-11-17 		     1.0	     AK			Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.ACC_types.all;

entity Mux_Demux is
  Port(
      clk               : in  std_logic;
      PCIe_Switch       : in  std_logic;
      Load_MD_Reg       : in  std_logic;
      Step_MDC          : in  std_logic;
      Reset_MDC         : in  std_logic;
      Switch_data       : in  std_logic_vector(15 downto 0);  
      PCIe_data         : in  std_logic_vector(255 downto 0);  
      Noc_reg_data      : out std_logic_vector(255 downto 0);    
      Noc_data_mux_out  : out std_logic_vector(255 downto 0)
  );
end Mux_Demux;

architecture Behavioral of Mux_Demux is

    signal MD_reg       : std_logic_vector(255 downto 0):= (others => '0'); 
    signal MDC          : integer:= 0;

begin

    process (clk)
    begin  
        if rising_edge(clk) then
            if Load_MD_Reg = '1' then
                if PCIe_Switch = '0' then     
                    MD_reg                    <= PCIe_data;
                else 
                    MD_reg((((MDC+1)*16) -1) downto MDC*16 ) <= Switch_data;
                end if;
            end if; 
        end if;
    end process;
    
    Noc_reg_data(255 downto 16)   <= MD_reg(255 downto 16);
    Noc_reg_data(15 downto 0)     <= MD_reg((((MDC+1)*16) -1) downto MDC*16);
    Noc_data_mux_out              <= MD_reg;

    
    process (clk)
    begin  
        if rising_edge(clk) then
            if Reset_MDC = '1' then
                MDC<= 0;
            elsif Step_MDC = '1' and MDC <15 then
                MDC<= MDC + 1;
            elsif MDC = 15 then
                MDC<= 0;                
            end if;
        end if;
    end process;             

end Behavioral;