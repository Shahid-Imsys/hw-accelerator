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
-- Description:  
-------------------------------------------------------------------------------
-- TO-DO list :
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
    rst_en          : in std_logic;
    clk_p           : in std_logic;
    clk_e_pos         : in std_logic;
    -- Microprogram fields
    
    -- Microprogram fields
    pl      : in  std_logic_vector(127 downto 0);  
    
    mp_ds         : in  std_logic_vector(3 downto 0);  
    mp_miform     : in  std_logic;        
    mp_shin_pa    : in  std_logic_vector(3 downto 0);  
    mp_alud       : in  std_logic;        
    -- Data Inputs
    flag_neg      : in  std_logic;        
    flag_carry    : in  std_logic;        
    flag_zero     : in  std_logic;        
    flag_oflow  	: in  std_logic;      
    flag_link     : in  std_logic;        
    flag_pccy     : in  std_logic;        
    inv_psmsb     : in	std_logic;       
    trace     		: in	std_logic;       
    ybus          : in  std_logic_vector(7 downto 0);
    y_reg         : in  std_logic_vector(7 downto 0);
    mbmd          : in  std_logic_vector(7 downto 0);
    gctr          : in  std_logic_vector(7 downto 0);
    crb_out       : in  std_logic_vector(7 downto 0);
    dfm           : in  std_logic_vector(7 downto 0);
    dfio          : in  std_logic_vector(7 downto 0);
    dsi           : in  std_logic_vector(7 downto 0);
    gdata         : in  std_logic_vector(7 downto 0);
    dtal          : in  std_logic_vector(7 downto 0);
    dfp           : in  std_logic_vector(7 downto 0);
    --CJ START ADDED
    VE_OUT_D    :          in std_logic_vector(7 downto 0);  
    --VE_OUT_SING  :          in std_logic_vector(7 downto 0); 
    --ID_NUM      :           in std_logic_vector(7 downto 0); 
    --CJ END

    -- Control Output
    flag_yeqneg   : out std_logic;  
    load_b        : out std_logic;  
    rd_gmem       : out std_logic;  
    rd_crb        : out std_logic;  
    d_sign	  		: out std_logic; 
    -- Data Outputs
    dbus          : out std_logic_vector(7 downto 0); 
    latch         : out std_logic_vector(7 downto 0)); 
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
  signal ve_data_sel : std_logic_vector(7 downto 0); --VE input 0-7 selector, Added by CJ
  
  -- Microprogram fields
  signal pl_sig6    : std_logic_vector(3 downto 0);  
  signal pl_sig5       : std_logic_vector(4 downto 0);  --Added one more bits by CJ
  signal pl_sig4   : std_logic;        
  signal pl_sig18  : std_logic_vector(3 downto 0);  
  signal pl_sig12     : std_logic; 
  
begin
  
  alu_flags <= inv_psmsb & trace & flag_oflow & flag_neg & flag_link &
               flag_zero & flag_pccy & flag_carry;
  pl_sig6  <= (pl(7) xor pl(36))&(pl(8) xor pl(50))&(pl(30) xor pl(62))&(pl(29) xor pl(10));
  pl_sig5     <= pl(108)&pl(50)&pl(22)&pl(14)&pl(44); --Added one more bits by CJ
  pl_sig4 <= pl(45);
  D_source_selector : process (pl_sig4, pl_sig5, pl_sig6, alu_flags,
                               latch_int, y_reg, mbmd, gctr, crb_out, dfm,
                               dfio, dsi, gdata, dtal, dfp, yprio, d_sign_int)
  begin
    if pl_sig4 = '0' then	--CONSTANT
      d_int <= pl_sig5(3 downto 0) & pl_sig6;
    else
      case pl_sig5 is
        when "00000" =>		--DSIGN
          if d_sign_int = '0' then
          	d_int <= x"00";
          else
          	d_int <= x"FF";
          end if;  
        when "00001" =>		--ALL FLAGS
          d_int <= alu_flags;
        when "00010" =>		--LATCH
          d_int <= latch_int;
        when "00011" =>		--YSWAPPED
          d_int <= y_reg(3 downto 0) & y_reg(7 downto 4);
        when "00100" =>		--Y
          d_int <= y_reg;
        when "00101" =>		--MBM
          d_int <= mbmd;
        when "00110" =>		--GCTR
          d_int <= gctr;
        when "00111" =>		--CRB
          d_int <= crb_out;
        when "01000" =>		--MEM
          d_int <= dfm;
        when "01001" =>		--INDATA
          d_int <= dfio;
        when "01010" =>		--CU
          d_int <= dsi;	
        when "01011" =>		--YFLIPPED
          d_int <= y_reg(0) & y_reg(1) & y_reg(2) & y_reg(3) &
                   y_reg(4) & y_reg(5) & y_reg(6) & y_reg(7);
        when "01100" =>		--G
          d_int <= gdata;
        when "01101" =>		--SP
          d_int <= dtal;
        when "01110" =>		--PORT
          d_int <= dfp;
        when "01111" =>		--YPRIO
          d_int <= yprio;
        when "10000" =>
          d_int <= VE_OUT_D; --Overall accumulator from VE; --Added by CJ
        --when "10001" =>
          --d_int <= VE_OUT_SING; --Single accumulator from VE; --Added by CJ
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
  pl_sig18 <= (pl(60) xor pl(68))&pl(56)&(pl(16) xor pl(35))&pl(68);
  pl_sig12    <=  pl(71) xor pl(77);

  flag_yeqneg <= '1' when ((flag_neg = '0' and y_reg = "00000000") or
                           (flag_neg = '1' and y_reg = "11111111"))
                 else '0';

  -- DSL handles PA pulses 4-7.
  dsl_pa <= not pl_sig12 and not pl_sig18(3) and pl_sig18(2);

  -- LOAD B is PA pulse 4.
  load_b <= dsl_pa and not pl_sig18(1) and not pl_sig18(0);
  
  -- LOAD LATCH FROM G is PA pulse 5.
  llfrg <= dsl_pa and not pl_sig18(1) and pl_sig18(0);

  -- Read from GMEM at LOAD LATCH FROM G or DSOURCE G
  mp_dsl_pa <= not mp_alud and not mp_shin_pa(3) and mp_shin_pa(2);
  mp_llfrg <= mp_dsl_pa and not mp_shin_pa(1) and mp_shin_pa(0);
  mp_dsg <= mp_miform and mp_ds(3) and mp_ds(2) and not mp_ds(1)
            and not mp_ds(0);
  rd_gmem <= mp_llfrg or mp_dsg;
  
  -- DSOURCE CRB is MIFORM = 1 and DS = 7.
  rd_crb <= pl_sig4 and not pl_sig5(3) and pl_sig5(2) and pl_sig5(1) and pl_sig5(0);

  process (clk_p)
  begin
    if rising_edge(clk_p) then
        if rst_en = '0' then
            latch_int <= (others => '0');
        elsif clk_e_pos = '0' then
            if llfrg = '1' then
              latch_int <= gdata;
            elsif dsl_pa = '1' and pl_sig18(1) = '1' then
              if pl_sig18(0) = '0' then
                latch_int <= d_int;
              else
                latch_int <= ybus;
              end if;
            end if;
        end if;
    end if;
  end process;
  latch <= latch_int;
  dbus <= d_int;

  process (clk_p)
  begin
    if rising_edge(clk_p) then
        if rst_en = '0' then
            d_sign_int <= '0';
        elsif clk_e_pos = '0' then
			d_sign_int <= d_int(7);
	    end if;
    end if;
  end process;
  d_sign <= d_sign_int;

end;













