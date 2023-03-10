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
-- Title      : Root_Memory
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Root_Memory.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 2020.11.16
-------------------------------------------------------------------------------
-- Description: Root Memory  
-------------------------------------------------------------------------------
-- TO-DO list :       
-------------------------------------------------------------------------------
-- Revisions  : 0
-- Date					Version		Author	Description
-- 2020-11-16 		     1.0	     AK			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity Root_Memory is
    Port(
        clk                 : in    std_logic;
        reset               : in    std_logic;
        Write_Read_Mode     : in    std_logic;
        Enable              : in    std_logic;
        Load_Add_Gen        : in    std_logic;
        Add_Gen_Value       : in    std_logic_vector(12 downto 0);
        DataIn              : in    std_logic_vector(15 downto 0);
        DataOut             : out   std_logic_vector(15 downto 0)
     );
end Root_Memory;

architecture Behavioral of Root_Memory is

    signal we           : std_logic_vector(0 downto 0);
    signal Address      : std_logic_vector(12 downto 0);
    signal Enable_p     : std_logic;
    signal mem_enable   : std_logic:= '0'; 

    component blk_mem_gen_0
      port (
        clka    : in std_logic;
        ena     : in std_logic;
        wea     : in std_logic_vector(0 downto 0);
        addra   : in std_logic_vector(12 downto 0);
        dina    : in std_logic_vector(15 downto 0);
        douta   : out std_logic_vector(15 downto 0)
      );
    end component;
  
begin

    we(0)       <= Write_Read_Mode;

    process (clk)
    begin 
        if rising_edge(clk) then
            if reset = '1' then
                Address     <= (others => '0'); 
                Enable_p    <= '0';      
            else
                if Load_Add_Gen = '1' then
                    Address   <= Add_Gen_Value;
                elsif Enable = '1' then 
                    Address   <= Address + 1;
                end if;
                Enable_p      <= Enable;
            end if;
        end if;
    end process;
    
    mem_enable <= (Enable or Enable_p) when Write_Read_Mode = '0' else Enable;

    Root_Memory_Inst : blk_mem_gen_0
    port map (
        clka    => clk,
        ena     => mem_enable,
        wea     => we,
        addra   => Address,
        dina    => DataIn,
        douta   => DataOut
    );

end Behavioral;