-------------------------------------------------------------------------------
--                                                                           --
--   COPYRIGHT (C)                                    IMSYS AB,  2001        --
--                                                                           --
--   The copyright to the document(s) herein is the property of Imsys        --
--   AB, Sweden.                                                             --
--                                                                           --
--   The document(s) may be used and/or copied only with the written         --
--   permission from Imsys AB or in accordance with the terms and            --
--   conditions stipulated in the agreement/contract under which the         --
--   document(s) have been supplied.                                         --
--                                                                           --
-------------------------------------------------------------------------------
-- Title      : Simulation trace file generator
-- Project    : GP2000
-------------------------------------------------------------------------------
-- File       : tracer.vhd
-- Author     : Xing Zhao
-- Company    : Imsys AB
-- Date       : 2001-08-21
-------------------------------------------------------------------------------
-- Description: The 'trace' records D/Y/Address under the simulation. The 
--              "TRACE.TXT" file may be used by Developer to trace the run.
-------------------------------------------------------------------------------
-- TO-DO list :
--              * 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2001-08-21  1.0      XZ	            Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.Image_pkg.all;
use Std.TextIO.all;

entity tracer is
  generic (
    start_trace_addr : std_logic_vector(15 downto 0) := x"0000");
  port (
    clk_e  : in  std_logic;
    dbus   : in  std_logic_vector(7 downto 0);
    ybus   : in  std_logic_vector(7 downto 0);
    mpga   : in  std_logic_vector(13 downto 0)
  );
end tracer;

architecture behav of tracer is
  signal MA : std_logic_vector(15 downto 0);
  signal D_int, Y_int : std_logic_vector(7 downto 0);
  file   DataOut_f  : Text open write_mode is "TRACE.TXT";
begin  -- behav
  
  D_int <= dbus after 1 ns;
  Y_int <= ybus after 1 ns;
  MA <= "00" & mpga after 1 ns;
  
  tracing: process (clk_e)
    variable start_trace : boolean := false;    
    variable OutLine_v  : Line;
    variable written_head : boolean := false;
    variable step       : integer := 0; 
    variable ma_int : std_logic_vector(15 downto 0);
  begin  -- process tracing
    if written_head = false then  
      Write(OutLine_v, string'("       Step  Addr  D  Y"));
      WriteLine(DataOut_f, Outline_v);
      Write(OutLine_v,  string'("       ----  ---- -- --"));
      WriteLine(DataOut_f, Outline_v);
      written_head := true;
    elsif rising_edge(clk_e) then
      if start_trace = false and MA = start_trace_addr then
        start_trace := true;
      end if;
      if start_trace then
        Write(Outline_v, string'("       "));
        Write(OutLine_v, step);
        Write(Outline_v, string'(" "));
        Write(OutLine_v, HexImage(MA));
        Write(Outline_v, string'(" "));
        Write(OutLine_v, HexImage(D_int));
        Write(Outline_v, string'(" "));
        Write(OutLine_v, HexImage(Y_int));
        WriteLine(DataOut_f, Outline_v);
        step := step + 1;                
      end if;
    end if;      
  end process tracing;
  
end behav;
