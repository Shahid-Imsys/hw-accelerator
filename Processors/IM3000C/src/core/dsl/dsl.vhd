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
-- Title      : D-bus source selector and latch
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : dsl.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description:  The DSL block consists a D source selector and a latch. The D
--               source selector is used to select several different sources
--               that can drive the D-bus. The 8-bit latch is used as an input
--               to the MBM block or to delay memory or I/O data for ALU.
--
-------------------------------------------------------------------------------
-- TO-DO list :
--              * Fix dsource selector, shold be just a 16-to-1 mux, not
--                followed by a 2-to-1.
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		2.3 			CB			Created
-- 2006-05-08		2.4				CB			Added the d_sign output and the DSIGN dsource.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity dsl is
  port(
    -- Clock input
    clk_e         : in std_logic;
    -- Microprogram fields
    pl_mbmop      : in  std_logic_vector(3 downto 0);  
    pl_ds         : in  std_logic_vector(3 downto 0);  
    pl_miform     : in  std_logic;        
    pl_shin_pa    : in  std_logic_vector(3 downto 0);  
    pl_alud       : in  std_logic_vector(2 downto 2);        
    mp_ds         : in  std_logic_vector(3 downto 0);  
    mp_miform     : in  std_logic;        
    mp_shin_pa    : in  std_logic_vector(3 downto 0);  
    mp_alud       : in  std_logic_vector(2 downto 2);        
    -- Data Inputs
    flag_neg      : in  std_logic;        --Neg flipflop from ALU
    flag_carry    : in  std_logic;        --Carry flipflop from ALU
    flag_zero     : in  std_logic;        --Zero flipflop from ALU
    flag_oflow  	: in  std_logic;        --Overflow flipflop from ALU
    flag_link     : in  std_logic;        --Link flipflop from ALU
    flag_pccy     : in  std_logic;        --PCCY flipflop from ALU
    inv_psmsb     : in	std_logic;       	--Invert pstack msb from CLC
    trace     		: in	std_logic;        --Trace flag from CLC
    ybus          : in  std_logic_vector(7 downto 0);--Y bus
    y_reg         : in  std_logic_vector(7 downto 0);--Y bus register
    mbmd          : in  std_logic_vector(7 downto 0);--MBM output
    gctr          : in  std_logic_vector(7 downto 0);--GMEM counters
    crb_out       : in  std_logic_vector(7 downto 0);--Data from CRB
    dfm           : in  std_logic_vector(7 downto 0);--Data from memory
    dfio          : in  std_logic_vector(7 downto 0);--Data from I/O subsystem
    dsi           : in  std_logic_vector(7 downto 0);--Data from CLC
    gdata         : in  std_logic_vector(7 downto 0);--GMEM data
    dtal          : in  std_logic_vector(7 downto 0);--ALC reg in the CPC block
    dfp           : in  std_logic_vector(7 downto 0);--Data from ports
    -- Control Output
    flag_yeqneg   : out std_logic;  -- Y equals neg flipflop flag to CLC
    load_b        : out std_logic;  -- Load B pulse to GMEM
    rd_gmem       : out std_logic;  -- Read GMEM pulse to GMEM
    rd_crb        : out std_logic;  -- Read CRB pulse to CRB
    d_sign	  		: out std_logic;  -- Sign reg from D bus, to CLC
    -- Data Outputs
    dbus          : out std_logic_vector(7 downto 0);   --D bus
    latch         : out std_logic_vector(7 downto 0));  --Output from the latch
end;

architecture rtl of dsl is
  signal alu_flags   : std_logic_vector(7 downto 0);
  signal d_int       : std_logic_vector(7 downto 0);
  signal latch_int   : std_logic_vector(7 downto 0);
  signal yprio       : std_logic_vector(7 downto 0);
  signal dsl_pa      : std_logic;
  signal llfrg       : std_logic;
  signal dsg         : std_logic;
  signal mp_dsl_pa   : std_logic;
  signal mp_llfrg    : std_logic;
  signal mp_dsg      : std_logic;
  signal d_sign_int  : std_logic;
  
begin
  --All the flags from CLC and ALU to DSL are put into one vector.
  alu_flags <= inv_psmsb & trace & flag_oflow & flag_neg & flag_link &
               flag_zero & flag_pccy & flag_carry;

  D_source_selector : process (pl_miform, pl_ds, pl_mbmop, alu_flags,
                               latch_int, y_reg, mbmd, gctr, crb_out, dfm,
                               dfio, dsi, gdata, dtal, dfp, yprio, d_sign_int)
  begin
    if pl_miform = '0' then	--CONSTANT
      d_int <= pl_ds & pl_mbmop;
    else
      case pl_ds is
        when "0000" =>		--DSIGN
          if d_sign_int = '0' then
          	d_int <= x"00";
          else
          	d_int <= x"FF";
          end if;  
        when "0001" =>		--ALL FLAGS
          d_int <= alu_flags;
        when "0010" =>		--LATCH
          d_int <= latch_int;
        when "0011" =>		--YSWAPPED
          d_int <= y_reg(3 downto 0) & y_reg(7 downto 4);
        when "0100" =>		--Y
          d_int <= y_reg;
        when "0101" =>		--MBM
          d_int <= mbmd;
        when "0110" =>		--GCTR
          d_int <= gctr;
        when "0111" =>		--CRB
          d_int <= crb_out;
        when "1000" =>		--MEM
          d_int <= dfm;
        when "1001" =>		--INDATA
          d_int <= dfio;
        when "1010" =>		--CU
          d_int <= dsi;	
        when "1011" =>		--YFLIPPED
          d_int <= y_reg(0) & y_reg(1) & y_reg(2) & y_reg(3) &
                   y_reg(4) & y_reg(5) & y_reg(6) & y_reg(7);
        when "1100" =>		--G
          d_int <= gdata;
        when "1101" =>		--SP
          d_int <= dtal;
        when "1110" =>		--PORT
          d_int <= dfp;
        when "1111" =>		--YPRIO
          d_int <= yprio;
        when others => null;
      end case;
    end if;
  end process;

  -- Priority encoding of Y bus.
  D_source_yprio: process (y_reg, flag_neg)
  begin  -- process D_source_yprio
    if flag_neg = '0' then
      if y_reg(7) = '1' then
        yprio(2 downto 0) <= "000";
      elsif y_reg(6) = '1' then
        yprio(2 downto 0) <= "001";
      elsif y_reg(5) = '1' then
        yprio(2 downto 0) <= "010";
      elsif y_reg(4) = '1' then
        yprio(2 downto 0) <= "011";
      elsif y_reg(3) = '1' then
        yprio(2 downto 0) <= "100";
      elsif y_reg(2) = '1' then
        yprio(2 downto 0) <= "101";
      elsif y_reg(1) = '1' then
        yprio(2 downto 0) <= "110";
      else
        yprio(2 downto 0) <= "111";
      end if;

    else                                -- flag_neg = '1'
      if y_reg(7) = '0' then
        yprio(2 downto 0) <= "000";
      elsif y_reg(6) = '0' then
        yprio(2 downto 0) <= "001";
      elsif y_reg(5) = '0' then
        yprio(2 downto 0) <= "010";
      elsif y_reg(4) = '0' then
        yprio(2 downto 0) <= "011";
      elsif y_reg(3) = '0' then
        yprio(2 downto 0) <= "100";
      elsif y_reg(2) = '0' then
        yprio(2 downto 0) <= "101";
      elsif y_reg(1) = '0' then
        yprio(2 downto 0) <= "110";
      else
        yprio(2 downto 0) <= "111";
      end if;
    end if;
  end process D_source_yprio;
  yprio(7 downto 3) <= (others => '0');

  flag_yeqneg <= '1' when ((flag_neg = '0' and y_reg = "00000000") or
                           (flag_neg = '1' and y_reg = "11111111"))
                 else '0';

  -- DSL handles PA pulses 4-7.
  dsl_pa <= not pl_alud(2) and not pl_shin_pa(3) and pl_shin_pa(2);

  -- LOAD B is PA pulse 4.
  load_b <= dsl_pa and not pl_shin_pa(1) and not pl_shin_pa(0);
  
  -- LOAD LATCH FROM G is PA pulse 5.
  llfrg <= dsl_pa and not pl_shin_pa(1) and pl_shin_pa(0);

  -- Read from GMEM at LOAD LATCH FROM G or DSOURCE G
  mp_dsl_pa <= not mp_alud(2) and not mp_shin_pa(3) and mp_shin_pa(2);
  mp_llfrg <= mp_dsl_pa and not mp_shin_pa(1) and mp_shin_pa(0);
  mp_dsg <= mp_miform and mp_ds(3) and mp_ds(2) and not mp_ds(1)
            and not mp_ds(0);
  rd_gmem <= mp_llfrg or mp_dsg;
  
  -- DSOURCE CRB is MIFORM = 1 and DS = 7.
  rd_crb <= pl_miform and not pl_ds(3) and pl_ds(2) and pl_ds(1) and pl_ds(0);

  process (clk_e)
  begin
    if rising_edge(clk_e) then
      if llfrg = '1' then
        latch_int <= gdata;
      elsif dsl_pa = '1' and pl_shin_pa(1) = '1' then
        if pl_shin_pa(0) = '0' then
          latch_int <= d_int;
        else
          latch_int <= ybus;
        end if;
      end if;
    end if;
  end process;
  latch <= latch_int;
  dbus <= d_int;

  process (clk_e)
  begin
    if rising_edge(clk_e) then
			d_sign_int <= d_int(7);
    end if;
  end process;
  d_sign <= d_sign_int;

end;













