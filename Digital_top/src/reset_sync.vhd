library ieee;
use ieee.std_logic_1164.all;

entity reset_sync is
  
  port (
    clk : in std_logic;     -- Input clock that reset shall be
                                      -- synchronized against.
    scan_mode   : in  std_logic;     -- Scan mode
    a_rst_n     : in  std_logic;     -- Reset to be synchronized
    rst_n       : out std_logic);

end entity reset_sync;

architecture rtl of reset_sync is

  signal pre_sync_n   : std_logic_vector(1 downto 0);    -- System reset after one sync reg
  signal s_rst_n      : std_logic;    -- System reset after one sync reg
  
begin  -- rtl
  
  syncProc: process (clk, a_rst_n)
  begin  -- process rstLoNProc
    if (a_rst_n = '0') then      -- asynchronous reset (active low)
      pre_sync_n <= (others => '0');
      s_rst_n <= '0';
    elsif falling_edge(clk) then
      pre_sync_n(0) <= '1';
      pre_sync_n(1) <= pre_sync_n(0);
      s_rst_n    <= pre_sync_n(1);
    end if;
  end process syncProc;

  -- by-pass in scan mode
  rst_n <= a_rst_n when (scan_mode = '1') else s_rst_n;
  

end architecture rtl;
