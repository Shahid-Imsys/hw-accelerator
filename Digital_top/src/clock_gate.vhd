-------------------------------------------------------------------------------
-- Title      : Clock Gate with scan clock bypass in scan mode
-- Project    : 
-------------------------------------------------------------------------------
-- File       : clock_gate_lfoundry.vhd
-- Author     :   <haro@ARIEN>
-- Company    : Shortlink AB
-- Created    : 2013-03-25
-- Last update: 2022-05-02
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Thisis an clock gate for lfoundry process, the FPGA model is
--              model to look like the clock gate in the librarie lf15adhvt9s.
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Shortlink AB
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2016-09-14  1.0      bsv	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity clock_gate is
  generic (
    fpga_g : boolean := false);
  port (
    clk      : in  std_ulogic;  -- Input clock (not gated)
    en       : in  std_ulogic;  -- Clock enable signal
    scan_mode : in  std_ulogic;  -- scan_mode
    clk_out  : out std_logic   -- gated clock
    );
end clock_gate;

architecture rtl of clock_gate is

  signal sync_en  : std_ulogic; 
  signal iq : std_ulogic;
  signal nextstate : std_ulogic;
  
begin  -- rtl

  fpga_clockgate: if fpga_g generate    
    nextstate <= en or scan_mode;
    clk_out <= iq and clk;

    -----------------------------------------------------------------------------
    -- Latch
    -----------------------------------------------------------------------------
    p_sync_en: process (clk, nextstate)
    begin
      if (clk = '0') then         -- asynchronous reset (active low)
        iq <= nextstate;
      end if;
    end process p_sync_en;
  end generate fpga_clockgate;


  -- Thsi shall be chnaged later with a proper clockgate cell.
  asic_clockgate: if not fpga_g generate
    nextstate <= en or scan_mode;
    clk_out <= iq and clk;

    -----------------------------------------------------------------------------
    -- Latch
    -----------------------------------------------------------------------------
    p_sync_en: process (clk, nextstate)
    begin
      if (clk = '0') then         -- asynchronous reset (active low)
        iq <= nextstate;
      end if;
    end process p_sync_en;
  end generate asic_clockgate;

end rtl;
