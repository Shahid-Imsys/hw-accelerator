----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2022 17:39:04
-- Design Name: 
-- Module Name: Root_Memory - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Root_Memory is
  Port(
        clk                 : in  std_logic;
        Reset               : in  std_logic;
        Write_Read_Mode     : in  std_logic;
        Enable              : in  std_logic;
        Load_RM_Address     : in  std_logic;
        RM_Address          : in  std_logic_vector(12 downto 0);
        DataIn              : in  std_logic_vector(127 downto 0);
        DataOut             : out std_logic_vector(127 downto 0)  
   );
end Root_Memory;

architecture Behavioral of Root_Memory is

    signal we           : std_logic_vector(0 downto 0);
    signal Address      : unsigned(12 downto 0);
    signal RM_FF        : std_logic;
    signal Enable_p     : std_logic;
    signal Enable_p2    : std_logic;
    signal mem_enable   : std_logic; 

    component blk_mem_gen_0
      port (
        clka    : in std_logic;
        ena     : in std_logic;
        wea     : in std_logic_vector(0 downto 0);
        addra   : in std_logic_vector(12 downto 0);
        dina    : in std_logic_vector(127 downto 0);
        douta   : out std_logic_vector(127 downto 0)
      );
    end component;
  
begin

    we(0)       <= Write_Read_Mode;
    process (clk, Reset)
    begin
        if Reset = '1' then
            Address     <= (others => '0');
            Enable_p    <= '0';
            Enable_p2   <= '0';
        elsif rising_edge(clk) then
            if Load_RM_Address = '1' then
                Address   <= unsigned(RM_Address);
            elsif Enable = '1' then  --(Enable = '1' and Write_Read_Mode = '1') then --or ((Enable = '1' or Enable_p ='1')and Write_Read_Mode = '0') then
                Address   <= Address + 1;
            end if;
            Enable_p      <= Enable;
            Enable_p2     <= Enable_p;
        end if;
    end process;
    
    mem_enable <= (Enable or Enable_p or Enable_p2) when Write_Read_Mode = '0' else Enable;

    Root_Memory_Inst : blk_mem_gen_0
    port map (
        clka    => clk,
        ena     => mem_enable,
        wea     => we,
        addra   => std_logic_vector(Address),
        dina    => DataIn,
        douta   => DataOut
    );

end Behavioral;
