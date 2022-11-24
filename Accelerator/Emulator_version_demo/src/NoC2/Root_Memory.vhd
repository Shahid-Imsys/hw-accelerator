----------------------------------------------------------------------------------
-- Company: Imsys Technologies AB
-- Engineer: Azadeh Kaffash
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
  Generic(
        USE_ASIC_MEMORIES   : boolean := false
  );
  Port(
      clk                 : in  std_logic;
      Reset               : in  std_logic;
      Write_Read_Mode     : in  std_logic;    -- '0': read memory
      Enable              : in  std_logic;
      RM_Address          : in  std_logic_vector(14 downto 0);
      DataIn              : in  std_logic_vector(127 downto 0);
      DataOut             : out std_logic_vector(127 downto 0)
   );
end Root_Memory;

architecture Behavioral of Root_Memory is

  component SNPS_SP_HD_8Kx128 is
    port (
      Q        : out std_logic_vector(127 downto 0);
      ADR      : in  std_logic_vector(12 downto 0);
      D        : in  std_logic_vector(127 downto 0);
      WE       : in  std_logic;
      ME       : in  std_logic;
      CLK      : in  std_logic;
      TEST1    : in  std_logic;
      TEST_RNM : in  std_logic;
      RME      : in  std_logic;
      RM       : in  std_logic_vector(3 downto 0);
      WA       : in  std_logic_vector(1 downto 0);
      WPULSE   : in  std_logic_vector(2 downto 0);
      LS       : in  std_logic;
      BC0      : in  std_logic;
      BC1      : in  std_logic;
      BC2      : in  std_logic);
  end component;


  component RMEM_32KX16 is
    port(
		      clk     : in std_logic;
          ena     : in std_logic;
          wea     : in std_logic;
          addra   : in std_logic_vector(14 downto 0);
          dina    : in std_logic_vector(127 downto 0);
          douta   : out std_logic_vector(127 downto 0)
	    );	
	end component;

--  signal we           : std_logic_vector(0 downto 0);
  signal Address      : unsigned(14 downto 0);
  signal RM_FF        : std_logic;
  signal Enable_p     : std_logic;
  signal Enable_p2    : std_logic;
  signal mem_enable   : std_logic;

  type DataOut_RM_type is array(natural range <>) of std_logic_vector(127 downto 0);
  signal Active_RM    : integer range 0 to 3;
  signal DataOut_RM   : DataOut_RM_type(3 downto 0);
  signal WE_RM        : std_logic_vector(3 downto 0);

begin

mem_enable <= Enable;

rm_asic_gen : if USE_ASIC_MEMORIES generate

  DataOut   <= DataOut_RM(Active_RM);
  Active_RM <= to_integer(Address(14 downto 13));

  rm_gen : for i in 0 to 3 generate
      WE_RM(i) <= Write_Read_Mode when Active_RM = i else '0';

      Root_Memory_Inst : SNPS_SP_HD_8Kx128
          port map (
            Q        => DataOut_RM(i),
            ADR      => std_logic_vector(Address(12 downto 0)),
            D        => DataIn,
            WE       => WE_RM(i),
            ME       => '1',
            CLK      => clk,
            TEST1    => '0',
            TEST_RNM => '0',
            RME      => '0',
            RM       => (others => '0'),
            WA       => (others => '0'),
            WPULSE   => (others => '0'),
            LS       => '0',
            BC0      => '0',
            BC1      => '0',
            BC2      => '0');
    end generate;
end generate;

rm_sim_gen : if not USE_ASIC_MEMORIES generate

  Root_Memory_Inst : RMEM_32KX16
  port map (
      clk       => clk,
      ena       => mem_enable,
      wea       => Write_Read_Mode,
      addra     => std_logic_vector(RM_Address),
      dina      => DataIn,
      douta     => DataOut
  );
end generate;

end Behavioral;