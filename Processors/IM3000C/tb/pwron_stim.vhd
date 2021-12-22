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
-- Title      : Stimuli
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : pwron_stim.vhd
-- Author     : Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: 
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2006-02-22		1.00			CB			Created.
-------------------------------------------------------------------------------
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
library work;
use work.io_utils.all;
use work.mti_pkg.all;

entity pwron_stim is
  port(
    MX1_CK   : inout std_logic;   
    MXOUT    : in    std_logic;   
    MEXEC    : in    std_logic;   
    MCKOUT0  : in    std_logic;   
    MCKOUT1  : in    std_logic;   
    MSDIN    : out   std_logic;   
    MSDOUT   : in    std_logic;   
    MIRQOUT  : in    std_logic;   
    MBYPASS  : out   std_logic;   
    MRESET   : out   std_logic;   
    MRSTOUT  : in    std_logic;   
    MTEST    : out   std_logic;   
    MWAKE    : out   std_logic;   
    MIRQ0    : out   std_logic;   
    MIRQ1    : out   std_logic;   
    MRXOUT   : in    std_logic;
    PA       : inout std_logic_vector(7 downto 0);        
    PB       : in    std_logic_vector(7 downto 0);        
    XTAL1    : inout std_logic;   
    MPORDIS  : out   std_logic   
    );
end pwron_stim;

architecture behav of pwron_stim is
  constant WTIMC : std_logic_vector(7 downto 0) := x"31";-- Control timing. 
  constant SSCU  : std_logic_vector(7 downto 0) := x"03";-- Stop mode.
  signal mx1_ck_int : std_logic := '1';
  constant HALF_CLK_C_CYCLE : time := 15000 ps;

begin  -- behav
	PA(4 downto 3) <= "LH";	-- Set SP communication at /2 speed
	PA(2 downto 1) <= "LH";	-- Set PLL multiplier to 4
	PA(0) <= 'H';						-- Set PLL divider to 1
	  
  -- This emulates a 33.3 MHz crystal
  mx1_ck_int <= not mx1_ck_int after HALF_CLK_C_CYCLE; 
  MX1_CK <= mx1_ck_int;

  -- Power-on reset enabled
  MPORDIS <= '0';

  -- Bypass disabled
  MBYPASS <= '0';

  -- Wake-up signal inactive
  MWAKE <= '0';

  XTAL1 <= '0';
	MIRQ0 <= '1';
	MIRQ1 <= '1';

  process
    procedure send (constant word : in  std_logic_vector(7 downto 0)) is
      variable shift_reg : std_logic_vector(9 downto 0);
    begin  -- send
      shift_reg := word & "00";
      MSDIN <= '1';
      for i in 0 to 10 loop
        wait until rising_edge(MCKOUT0);
        wait for 1 ns;
        shift_reg := '1' & shift_reg(9 downto 1);       
        MSDIN <= shift_reg(0);
      end loop;  -- i
    end send;

    procedure wrCmd1 (
      constant cmd  : in  std_logic_vector(7 downto 0);
      constant data : in  std_logic_vector(7 downto 0)) is
    begin  -- wrCmd1
      send(cmd);
      send(data);
    end wrCmd1;

  begin
    ---------------------------------------------------------------------------
    -- POWER-ON SEQUENCE
    ---------------------------------------------------------------------------
    MSDIN <= '1';
    MRESET <= '1';

    -- Test mode enabled, to shorten power-on timeout
    MTEST <= '1';

    -- Wait for power-on sequence to complete
    wait until MRSTOUT = '1';
    wait for 10002 ns;        -- Avoid unnecessary timing errors during
                              -- timing simulation 

    -- Restart with a short pulse on MRESET
    MRESET <= '0';
    wait for 10 ns;
    MRESET <= '1';

    -- Stop the machine
    wrCmd1(WTIMC, SSCU);    -- stop/step

    -- Test mode disabled
    MTEST <= '0';

    wait for 10*HALF_CLK_C_CYCLE;
    assert false
      report "Simulation finished!"
      severity failure;     -- exit simulation
  end process;

end behav;

	
