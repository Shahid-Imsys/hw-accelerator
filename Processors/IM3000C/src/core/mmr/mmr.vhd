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
-- Title      : SDRAM controller
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : mmr.vhd
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
-- 2005-11-28		1.08			CB			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mpgmfield_lib.all;

--*******************************************************************     
-- MMR - SDRAM interface
--*******************************************************************
entity mmr is
  port (
    -- Clock and reset functions
    rst_en:     in  std_logic;  -- Asynchronous master reset
    clk_c2:     in  std_logic;  -- 
    clk_d:      in  std_logic;  -- SDRAM clock
    clk_e:      in  std_logic;  -- Execution clock
    gate_e:     in  std_logic; -- Copy of execution clock used for gating 
    even_c:     in  std_logic;  -- High on even (first of two) clk_c cycles
    held_e:     in  std_logic;  -- High when clk_e is held, multiple of 2 clk_c
    -- Microprogram control
    pl_memcp:   in  std_logic_vector(1 downto 0); -- MEMCP field of u-instruction
    pl_pc:      in std_logic_vector(3 downto 0);  --from the microprogram word
    pl_pd:      in std_logic_vector(2 downto 0);  --from the microprogram word
    -- Static control inputs
    r_size:     in  std_logic_vector(1 downto 0);
    c_size:     in  std_logic_vector(1 downto 0);
    dqm_size:   in  std_logic_vector(1 downto 0);
    t_ras:      in  std_logic_vector(2 downto 0); -- tRAS timing of SDRAM
    t_rcd:      in  std_logic_vector(1 downto 0); -- tRCD timing of SDRAM
    t_rp:       in  std_logic_vector(1 downto 0); -- tRP timing of SDRAM
    fast_d:     in  std_logic;  -- 1 => clk_d = clk_c, 0 => clk_d = not even_c
    -- Data paths
    dbus:       in  std_logic_vector(7 downto 0);  -- D bus, from DSL
    ybus:       in  std_logic_vector(7 downto 0);  -- Y bus, from ALU
    g_direct:   in  std_logic_vector(7 downto 0); -- Direct data bus from GMEM
    i_direct:   in  std_logic_vector(7 downto 0); -- Direct data bus from IOMEM
    dfm:        out std_logic_vector(7 downto 0); -- Data from memory to DSL
    direct:     out std_logic_vector(7 downto 0); -- Direct bus to GMEM,IOMEM 
    -- Outputs
    use_direct: out std_logic;  -- Set when the direct bus is used
    dbl_direct: out std_logic;  -- Set if direct traffic is double-speed
    sel_direct: out std_logic_vector(1 downto 0); -- Select source of direct bus
    g_double:   out std_logic;
    i_double:   out std_logic;
    lmpen:      out std_logic;
    adl_cy:     out std_logic;
    hold_e:     out std_logic;  -- Set high by this block to delay clk_e
    -- SDRAM signals
    d_cs:       out std_logic;  -- CS to SDRAM
    d_ras:      out std_logic;  -- RAS to SDRAM
    d_cas:      out std_logic;  -- CAS to SDRAM
    d_we:       out std_logic;  -- WE to SDRAM
    d_dqi:      in  std_logic_vector(7 downto 0); -- Data in from SDRAM
    d_dqo:      out std_logic_vector(7 downto 0); -- Data out to SDRAM
    en_dqo:     out std_logic;  -- Output enable to SDRAM data bus
    d_a:        out std_logic_vector(13 downto 0);
    d_ba:       out std_logic_vector(1 downto 0);
    d_dqm:      out std_logic_vector(7 downto 0);
    d_cke:      out std_logic_vector(3 downto 0));
end;          

architecture rtl of mmr is
  signal allras         : std_logic;
  signal use_direct_int : std_logic;
  signal dbl_direct_int : std_logic;
  signal sel_direct_int : std_logic_vector(1 downto 0);
  signal col            : std_logic;
  signal ld_dqi         : std_logic;
  signal m_addr         : std_logic_vector(31 downto 0);
  signal en_dqo_int     : std_logic;
  -- Introducing 'inv_col' to differ clock and combinational usage of 'col',
  -- in order to avoid Synplify ASIC generates a high fan_out on 'col'.
  signal inv_col        : std_logic;
  attribute syn_keep    : boolean;
  attribute syn_keep of inv_col: signal is true;
  attribute syn_keep of col    : signal is true;  
begin
--*******************************************************************
-- MTL - memory timing logic
--*******************************************************************
  mtl: block
    constant C            : std_logic_vector(1 downto 0) := "00";
    constant M            : std_logic_vector(1 downto 0) := "01";
    constant R            : std_logic_vector(1 downto 0) := "10";
    constant RW           : std_logic_vector(1 downto 0) := "11";
    type state_type is (Idle, RdPending, WrPending, Active);
    type operation_type is (NOP, Act, Rd, Wr);
    signal state          : state_type;
    signal next_state     : state_type;
    signal operation      : operation_type;
    signal pra_operation  : std_logic;
    signal pra_pending    : std_logic;
    signal wait_dqi       : std_logic;
    signal ld_dqi_ffs     : std_logic_vector(1 downto 0);
    signal rp_ctr         : std_logic_vector(2 downto 0);
    signal rc_ctr         : std_logic_vector(1 downto 0);
    signal pr_ctr         : std_logic_vector(1 downto 0);
    signal wait_rp        : std_logic;
    signal wait_rc        : std_logic;
    signal wait_pr        : std_logic;    
  begin  -- block mtl
    -- This is the combinatorial part of the state machine
    -- for the SDRAM timing logic.
    mtl_next: process (state, pl_memcp, held_e, allras)
    begin
      next_state <= state;
      if held_e = '0' then
        if pl_memcp = R then
          if allras = '1' then 
            next_state <= Idle;
          else
            next_state <= RdPending;
          end if;
        elsif pl_memcp = RW then 
          if allras = '1' then 
            next_state <= Idle;
          else
            next_state <= WrPending;
          end if;
        elsif pl_memcp = M then 
          next_state <= Idle;
        elsif pl_memcp = C and state /= Idle then 
          next_state <= Active;
        end if;
      end if;
    end process mtl_next;

    -- This is the sequential part of the state machine
    -- for the SDRAM timing logic.
    mtl_state: process (clk_c2, rst_en)
    begin
      if rst_en = '0' then
        state <= Idle;
      elsif rising_edge(clk_c2) then
        state <= next_state;
      end if;
    end process mtl_state;

    -- This process determines which SDRAM operation to perform
    -- based on current state and memcp. It also schedules some
    -- operations for the next cycle.
    mtl_operation: process (state, pl_memcp, held_e, allras)
    begin
      operation <= NOP;
      pra_pending <= '0';                       
      if held_e = '0' then
        if pl_memcp = M then 
          pra_pending <= '1';
        end if;
        case state is
          when Idle =>
            if pl_memcp = R or pl_memcp = RW then 
              operation <= Act;
            end if;
            if allras = '0' then 
              pra_pending <= '0';
            end if;
          when RdPending =>
            operation <= Rd;
          when WrPending =>
            operation <= Wr;
          when Active =>
            null;
        end case;
      end if;
    end process mtl_operation;

    -- These flipflops hold pending operations. 
    mtl_pending: process (clk_d, rst_en)
    begin
      if rst_en = '0' then
        pra_operation <= '0';
      elsif rising_edge(clk_d) then
        pra_operation <= pra_pending and not pra_operation;
      end if;
    end process mtl_pending;

    -- This process generates the hold_e signal, used to delay execution
    -- due to memory timing. Uses the wait_xx signals from the three
    -- timing counters to keep track of timing.
    mtl_hold: process (state, pl_memcp, wait_rc, wait_rp,
                       wait_pr, wait_dqi)
    begin
      hold_e <= '0';
      if pl_memcp = M and wait_rp = '1' then
        hold_e <= '1';
      end if;
      if (state = RdPending or state = WrPending) and wait_rc = '1' then 
        hold_e <= '1';
      end if;
      if state = WrPending and wait_dqi = '1' then 
        hold_e <= '1';
      end if;
      if (pl_memcp = R or pl_memcp = RW) and wait_pr = '1' then 
        hold_e <= '1';
      end if;
    end process mtl_hold;

    -- The col signal selects between row and column address, it is low
    -- (selects row address) in the Idle state only.
    col <=  '0' when state = Idle else
            '1';
    inv_col <= not col;
    
    -- Decode current SDRAM operation to SDRAM control signals.
    mtl_decode_op: process (even_c, operation, pra_operation, dbl_direct_int,
                            allras, pl_memcp)
    begin
      d_cs <= '1';
      d_ras <= '1';
      d_cas <= '1';
      d_we <= '1';
      en_dqo_int <= '0';
      case operation is
        when Act =>
          if even_c = '1' then
            d_cs <= '0';
            d_ras <= '0';
            if allras = '1' then        -- Refresh or MRS
              d_cas <= '0';
              if pl_memcp = RW then     -- MRS
                d_we <= '0';
              end if;
            end if;
          end if;
        when Rd =>
          if even_c = '1' or dbl_direct_int = '1' then
            d_cs <= '0';
            d_cas <= '0';
          end if;
        when Wr =>
          if even_c = '1' or dbl_direct_int = '1' then
            d_cs <= '0';
            d_cas <= '0';
            d_we <= '0';
            en_dqo_int <= '1';
          end if;
        when others =>
          NULL;
      end case;
      if pra_operation = '1' then
        d_cs <= '0';
        d_ras <= '0';
        d_we <= '0';
      end if;
    end process mtl_decode_op;

    -- This process creates the ld_dqi signal by delaying the (operation = Rd)
    -- signal by three when fast_d is set (CL = 3) or two when not (CL = 2).
    -- The wait_dqi signal is high while from active (operation = Rd) to and
    -- including ld_dqi, and for one more clk_d if fast_d is active. 
    -- When running in fast mode but not using the direct bus, disable ld_dqi
    -- during even clk_c cycles.
    mtl_wait_dqi: process (clk_c2, rst_en)
    begin
      if rst_en = '0' then
        ld_dqi_ffs <= "00";
      elsif rising_edge(clk_c2) then
        ld_dqi_ffs(1) <= ld_dqi_ffs(0);
        if operation = Rd then
          ld_dqi_ffs(0) <= '1';
        else
          ld_dqi_ffs(0) <= '0';
        end if;
      end if;
    end process mtl_wait_dqi;
    wait_dqi <= ld_dqi_ffs(1) or ld_dqi_ffs(0);

    mtl_ld_dqi: process (clk_d, rst_en)
    begin
      if rst_en = '0' then
        ld_dqi <= '0';
      elsif rising_edge(clk_d) then
        ld_dqi <= ld_dqi_ffs(0) and (even_c or use_direct_int);
      end if;
    end process mtl_ld_dqi;

    -- tRAS timer, outputs the wait_rp signal that is high from
    -- an Act operation until tRAS has expired.
    process (clk_c2, rst_en)
    begin
      if rst_en = '0' then
        rp_ctr <= "000";
      elsif rising_edge(clk_c2) then
        if wait_rp = '1' then
          rp_ctr <= rp_ctr - 1;
        end if;
        if operation = Act then
          rp_ctr <= t_ras;
        end if;
      end if;
    end process;
    wait_rp <= '1' when rp_ctr /= "000" else '0';

    -- tRCD timer, outputs the wait_rc signal that is high from
    -- an Act operation until tRCD has expired.
    process (clk_c2, rst_en)
    begin
      if rst_en = '0' then
        rc_ctr <= "00";
      elsif rising_edge(clk_c2) then
        if wait_rc = '1' then
          rc_ctr <= rc_ctr - 1;
        end if;
        if operation = Act then
          rc_ctr <= t_rcd;
        end if;
      end if;
    end process;
    wait_rc <= '1' when rc_ctr /= "00" else '0';

    -- tRP timer, outputs the wait_pr signal that is high from
    -- (and including) a Pra operation until tRP has expired.
    process (clk_c2, rst_en)
    begin
      if rst_en = '0' then
        pr_ctr <= "00";
      elsif rising_edge(clk_c2) then
        if wait_pr = '1' then
          pr_ctr <= pr_ctr - 1;
        end if;
        if pra_pending = '1' then
          pr_ctr <= t_rp;
        end if;
      end if;
    end process;
    wait_pr <= '1' when pr_ctr /= "00" else '0';
    
  end block mtl;

--*******************************************************************   
-- MAPC - address registers
--*******************************************************************
  mapc: block
    signal ld_adp       : std_logic;
    signal ld_adh       : std_logic;
    signal change_adl   : std_logic;
    signal stp_ld_adl   : std_logic;
    signal y_d_adl      : std_logic;
    signal dec_inc_adl  : std_logic;
    signal ld_sadp      : std_logic;
    signal sel_adp      : std_logic_vector(1 downto 0);
    signal use_adp      : std_logic_vector(1 downto 0);
    signal sadp_a       : std_logic_vector(7 downto 0);
    signal sadp_i       : std_logic_vector(7 downto 0);
    signal sadp_d       : std_logic_vector(7 downto 0);
    signal sadp_p       : std_logic_vector(7 downto 0);
    signal adp_a        : std_logic_vector(7 downto 0);
    signal adp_i        : std_logic_vector(7 downto 0);
    signal adp_d        : std_logic_vector(7 downto 0);
    signal adp_p        : std_logic_vector(7 downto 0);
    signal adh          : std_logic_vector(7 downto 0);
    signal adl          : std_logic_vector(7 downto 0);
    signal adl_inc      : std_logic_vector(7 downto 0);
    signal ld_dirc      : std_logic;
    signal dirc         : std_logic_vector(7 downto 0);
    signal ma2          : std_logic;
    signal ma1          : std_logic;
    signal m_double     : std_logic;    
  begin  -- block mapc
    -- Decode of the PC field from the microprogram word, used to
    -- control the address registers.
    -- ld_adp if high when an adp register is loaded from ybus.
    -- ld_adh if high when the adh register is loaded from ybus.
    -- change_adl is high when adl is loaded or stepped. If so,
    -- stp_ld_adl selects between step and load, high means step,
    -- low means load. If adl is loaded, y_d_adl selects the source,
    -- high means ybus, low means dbus. If adl is stepped, dec_inc_adl
    -- selects direction, high means down, low means up.
    mapc_decode_pc: process(pl_pc, ma1, ma2)
    begin
      ld_adp <= '0';
      ld_adh <= '0';
      change_adl <= '0';
      stp_ld_adl <= '-';
      y_d_adl <= '-';
      dec_inc_adl <= '-';
      ld_dirc <= '0';
      case pl_pc is
        when PC_LOADADHA|PC_LOADADHI|PC_LOADADHD|PC_LOADADHP => -- LOAD ADH
          ld_adh <= '1';
        when PC_LOADADPA|PC_LOADADPI|PC_LOADADPD|PC_LOADADPP => -- LOAD ADP
          ld_adp <= '1';
        when PC_LADLFROMY =>         -- LOAD ADL FROM Y
          change_adl <= '1';
          stp_ld_adl <= '0';
          y_d_adl <= '1';
        when PC_LADLFROMD =>         -- LOAD ADL FROM D
          change_adl <= '1';
          stp_ld_adl <= '0';
          y_d_adl <= '0';
        when PC_DECRADL =>           -- DECREMENT ADL
          change_adl <= '1';
          stp_ld_adl <= '1';
          dec_inc_adl <= not ma1;
        when PC_INCRADL =>           -- INCREMENT ADL
          change_adl <= '1';
          stp_ld_adl <= '1';
          dec_inc_adl <= ma1;
        when PC_LOADDIRC =>          -- LOAD DIRC
          ld_dirc <= '1';
        when PC_WRITEGMEM =>         -- WRITE GMEM (steps adl if ma2 is set)
          change_adl <= ma2;
          stp_ld_adl <= '1';
          dec_inc_adl <= ma1;
        when others =>
          NULL;
      end case;
    end process;
    sel_adp <= pl_pc(1 downto 0);

    ---------------------------------------------------------------------
    -- DIRC register
    ---------------------------------------------------------------------
    -- DIRC register. Loaded from dbus.
    mapc_dirc: process(clk_e, rst_en)
    begin
      if rst_en = '0' then
        dirc <= x"00";
      elsif rising_edge(clk_e) then
        if ld_dirc = '1' then
          dirc <= dbus;
        end if;
      end if;
    end process;
    ma2 <= dirc(7);
    ma1 <= dirc(6);
    sel_direct_int(1) <= dirc(5);
    sel_direct_int(0) <= dirc(3);
    m_double <= fast_d when dirc(1) = '1' else
                dirc(5);
    g_double <= fast_d when dirc(1) = '1' else
                dirc(4);
    i_double <= fast_d when dirc(1) = '1' else
                dirc(3);
    lmpen <= dirc(2);
    use_direct_int <= dirc(1);
    dbl_direct_int <= dirc(1) and fast_d;
    allras <= dirc(0);

    ---------------------------------------------------------------------
    -- ADL
    ---------------------------------------------------------------------
    -- Incrementor/decrementor for the adl register. Outputs adl+1,
    -- adl+2, adl-1 or adl-2 depending on control inputs. Also outputs
    -- a carry signal to be used to detect adl wraps.
    mapc_adl_inc: process(dec_inc_adl, m_double, adl)
    begin
      adl_cy <= '0';
      if dec_inc_adl = '1' then
        if m_double = '1' then
          adl_inc <= adl - 2;
          if adl = x"03" or adl = x"02" then adl_cy <= '1'; end if;
        else
          adl_inc <= adl - 1;
          if adl = x"01" then adl_cy <= '1'; end if;
        end if;
      else
        if m_double = '1' then
          adl_inc <= adl + 2;
          if adl = x"FC" or adl = x"FD" then adl_cy <= '1'; end if;
        else
          adl_inc <= adl + 1;
          if adl = x"FE" then adl_cy <= '1'; end if;
        end if;
      end if;
    end process;

    -- ADL register. Can be loaded from adl_inc, dbus or ybus.
    mapc_adl: process(clk_e, rst_en)
    begin
      if rst_en = '0' then
        adl <= x"00";
      elsif rising_edge(clk_e) then
        if change_adl = '1' then
          if stp_ld_adl = '1' then
            adl <= adl_inc;
          else
            if y_d_adl = '1' then
              adl <= ybus;
            else
              adl <= dbus;
            end if;
          end if;
        end if;
      end if;
    end process;

    ---------------------------------------------------------------------
    -- ADH
    ---------------------------------------------------------------------
    -- ADH register. Can be loaded from ybus. When adh is loaded,
    -- use_adp is also loaded to select which sadp/adp registers
    -- to use for address generation.
    mapc_adh: process(clk_e, rst_en)
    begin
      if rst_en = '0' then
        adh <= x"00";
        use_adp <= "00";
      elsif rising_edge(clk_e) then
        if ld_adh = '1' then
          adh <= ybus;
          use_adp <= sel_adp;
        end if;
      end if;
    end process;

    ---------------------------------------------------------------------
    -- ADP, SADP
    ---------------------------------------------------------------------
    -- SADP/ADP registers. Can be loaded from ybus. When adp is loaded,
    -- ld_sadp is also set, for one cycle, to allow loading of sadp in the
    -- cycle immediately following the one where adp was loaded. sel_adp
    -- is used to select which adp/sadp register to load.
    mapc_adp: process(clk_e, rst_en)
    begin
      if rst_en = '0' then
        ld_sadp <= '0';
        adp_a <= x"00";
        adp_i <= x"00";
        adp_d <= x"00";
        adp_p <= x"00";
        sadp_a <= x"00";
        sadp_i <= x"00";
        sadp_d <= x"00";
        sadp_p <= x"00";
      elsif rising_edge(clk_e) then
        ld_sadp <= '0';
        if ld_adp = '1' then
          if ld_sadp = '0' then
            ld_sadp <= '1';
            case sel_adp is
              when "00" =>
                adp_a <= ybus;
              when "01" =>
                adp_i <= ybus;
              when "10" =>
                adp_d <= ybus;
              when "11" =>
                adp_p <= ybus;
              when others => null;
            end case;
          else
            case sel_adp is
              when "00" =>
                sadp_a <= ybus;
              when "01" =>
                sadp_i <= ybus;
              when "10" =>
                sadp_d <= ybus;
              when "11" =>
                sadp_p <= ybus;
              when others => null;  
            end case;
          end if;
        end if;
      end if;
    end process;

    -- Address generation. The two high bytes are taken from the
    -- sadp/adp register pair selected by use_adp, the two low
    -- bytes are always taken from adh/adl.
    m_addr(31 downto 24)  <=  sadp_a when use_adp = "00" else
                              sadp_i when use_adp = "01" else
                              sadp_d when use_adp = "10" else
                              sadp_p;
    m_addr(23 downto 16)  <=  adp_a when use_adp = "00" else
                              adp_i when use_adp = "01" else
                              adp_d when use_adp = "10" else
                              adp_p;
    m_addr(15 downto 8)   <=  adh;
    m_addr(7 downto 0)    <=  adl;
    
  end block mapc;

  use_direct <= use_direct_int;
  dbl_direct <= dbl_direct_int;
  sel_direct <= sel_direct_int;

--*******************************************************************
-- ADRC - address and control mux
--*******************************************************************
  adrc: block
    signal row_addr   : std_logic_vector(13 downto 0);
    signal col_addr   : std_logic_vector(13 downto 0);
    signal mux_c      : std_logic_vector(29 downto 20);
    signal mux_r      : std_logic_vector(24 downto 20);
    signal mux_dqm    : std_logic_vector(21 downto 20);
    signal dqm_2      : std_logic;
    signal dqm_4      : std_logic;
    signal dqm_8      : std_logic;
    signal lm_addr    : std_logic_vector(32 downto 0);    
  begin  -- block adrc
    -- Some of the address bits have latches to prevent
    -- ADH/ADP/SADP changes during the active time to affect
    -- the memory address.
    process (inv_col, m_addr)
    begin
      if inv_col = '1' then
        lm_addr(11 downto 8) <= m_addr(11 downto 8);
        lm_addr(31 downto 20) <= m_addr(31 downto 20);
      end if;
    end process;
    lm_addr(7 downto 0) <= m_addr(7 downto 0);
    lm_addr(19 downto 12) <= m_addr(19 downto 12);
--     lm_addr(32) <= m_addr(32);
    lm_addr(32) <= '0';
    
    -- Column address, flip lsb during second half of cycle when
    -- doing double-byte transfers. 
    -- 3-4 gates
    col_addr(13) <= '0';
    col_addr(12 downto 11) <= lm_addr(11 downto 10);
    col_addr(10) <= '0';
    col_addr(9 downto 1) <= lm_addr(9 downto 1);
    col_addr(0) <= lm_addr(0) xor (dbl_direct_int and not gate_e);

    -- Row address
    -- 10 x 2to1, 1 x NOR3, 1 x NAND3, 3 x NOR2, 1 x AND2, 1 x OR2 =
    -- 10x3 + 1.5 + 1.5 + 3x1 + 1.5 + 1.5 = 39 gates
    row_addr(7 downto 0) <= lm_addr(19 downto 12);
    row_addr(8) <= lm_addr(8) when r_size(1) = '0' and c_size = "00" else
                   lm_addr(20) when r_size = "00" else
                   lm_addr(22);
    row_addr(9) <= lm_addr(9) when c_size(1) = '0' and
                   (r_size(1) = '0' or c_size(0) = '0') else
                   lm_addr(24) when r_size(1) = '1' else
                   lm_addr(21) when r_size(0) = '0' else
                   lm_addr(23);
    row_addr(10) <= lm_addr(10) when c_size(1) = '0' or
                    (r_size(1) = '0' and c_size(0) = '0') else
                    lm_addr(24) when r_size(1) = '0' else
                    lm_addr(25) when r_size(0) = '0' else
                    lm_addr(26);
    row_addr(11) <= lm_addr(11) when not(r_size(1) = '1' and c_size = "11") else
                    lm_addr(26) when r_size(0) = '0' else
                    lm_addr(27);
    row_addr(12) <= lm_addr(23);
    row_addr(13) <= lm_addr(25);

    -- Row/column address selector
    -- 12 x 2to1, 2 x AND2, 1 x INV = 12x3 + 2x1.5 + 0.5 = 39.5 gates
    d_a(13 downto 0) <=
      col_addr(13 downto 0) when col = '1' else
      row_addr(13 downto 0);

    -- Bank address
    -- 1 x 2to1 = 3 gates
    d_ba(0) <=
      lm_addr(11) when r_size = "00" else
      lm_addr(20);
    d_ba(1) <=
      lm_addr(21);

    -- 10-bit address shifter controlled by c_size
    -- 10 x 4to1 = 10x7.5 = 75 gates
    process (c_size, lm_addr)
    begin
      for i in 20 to 29 loop
        case c_size is
          when "00"   =>  mux_c(i) <= lm_addr(i+0);
          when "01"   =>  mux_c(i) <= lm_addr(i+1);
          when "10"   =>  mux_c(i) <= lm_addr(i+2);
          when others =>  mux_c(i) <= lm_addr(i+3);
        end case; 
      end loop;
    end process;

    -- 5-bit address shifter controlled by r_size
    -- 5 x 4to1 = 5x7.5 = 37.5 gates
    process (r_size, mux_c)
    begin
      for i in 20 to 24 loop
        case r_size is
          when "00"   =>  mux_r(i) <= mux_c(i+0);
          when "01"   =>  mux_r(i) <= mux_c(i+2);
          when "10"   =>  mux_r(i) <= mux_c(i+4);
          when others =>  mux_r(i) <= mux_c(i+5);
        end case; 
      end loop;
    end process;

    -- 2-bit address shifter controlled by dqm_size
    -- 2 x 4to1 = 2x7.5 = 15 gates
    process (dqm_size, mux_r)
    begin
      for i in 20 to 21 loop
        case dqm_size is
          when "00"   =>  mux_dqm(i) <= mux_r(i+0);
          when "01"   =>  mux_dqm(i) <= mux_r(i+1);
          when "10"   =>  mux_dqm(i) <= mux_r(i+2);
          when others =>  mux_dqm(i) <= mux_r(i+3);
        end case; 
      end loop;
    end process;

    -- DQM line demultiplexer
    -- 1 x NOR2, 1 x NAND2, 3 x INV, 2 x OR2, 8 x NAND4 = 1 + 1 + 3x0.5 + 2x1.5
    -- + 8x2 = 22.5 gates
    dqm_2 <= dqm_size(1) or dqm_size(0);
    dqm_4 <= dqm_size(1);
    dqm_8 <= dqm_size(1) and dqm_size(0);
    d_dqm(0) <= not dqm_2 or mux_r(20) or (dqm_4 and mux_r(21)) or
                (dqm_8 and mux_r(22));
    d_dqm(1) <= not dqm_2 or not mux_r(20) or (dqm_4 and mux_r(21)) or
                (dqm_8 and mux_r(22));
    d_dqm(2) <= not dqm_4 or mux_r(20) or not mux_r(21) or (dqm_8 and mux_r(22));
    d_dqm(3) <= not dqm_4 or not mux_r(20) or not mux_r(21) or
                (dqm_8 and mux_r(22));
    d_dqm(4) <= not dqm_8 or mux_r(20) or mux_r(21) or not mux_r(22);
    d_dqm(5) <= not dqm_8 or not mux_r(20) or mux_r(21) or not mux_r(22);
    d_dqm(6) <= not dqm_8 or mux_r(20) or not mux_r(21) or not mux_r(22);
    d_dqm(7) <= not dqm_8 or not mux_r(20) or not mux_r(21) or not mux_r(22);

    -- CKE line demultiplexer
    -- 2 x INV, 4 x NOR2 = 2x0.5 + 4x1 = 5 gates
    process (mux_dqm, allras)
    begin
      for i in 0 to 3 loop
        if mux_dqm(21 downto 20) = i then
          d_cke(i) <= '1';
        else
          d_cke(i) <= '0';
        end if;
      end loop;
      if allras = '1' then
        d_cke <= "1111";
      end if;
    end process;    
  end block adrc;
  
--*******************************************************************     
-- DTMC - dtm and dfm registers
--*******************************************************************
  dtmc: block
    -- Signals to control DFM
    signal held_ff      : std_logic;
    signal dfm_kept     : std_logic;
    signal odd_kept     : std_logic;
    -- DFM registers
    signal dfm_keep     : std_logic_vector(7 downto 0);
    signal odd_keep     : std_logic_vector(7 downto 0);
    signal dfm_odd      : std_logic_vector(7 downto 0);
    signal m_direct     : std_logic_vector(7 downto 0);
    -- Signals to control DTM
    signal ld_dtm       : std_logic;
    signal sely_d       : std_logic;
    -- DTM registers
    signal dtm          : std_logic_vector(7 downto 0);
    signal dtm_even     : std_logic_vector(7 downto 0);

    -- Signals needed just because VHDL is stupid
    signal dfm_int      : std_logic_vector(7 downto 0);
    signal direct_int   : std_logic_vector(7 downto 0);    
  begin  -- block dtmc
    -- This process output signals held_ff, which is just the held_e
    -- input signal clocked by clk_d, and dfm_kept, which is set after
    -- ld_dqi and held_ff are both high and reset after held_ff goes
    -- low. This means that it is set when data is put in dfm_keep and
    -- cleared when that data is copied to dfm. A similar signal, odd_kept
    -- is also output for the odd_keep register. It is dfm_kept delayed
    -- one clk_d if two-stepping is on, low otherwise.  
    process (clk_d, rst_en)
    begin
      if rst_en = '0' then
        odd_kept <= '0';
        dfm_kept <= '0';
        held_ff <= '0';
      elsif rising_edge(clk_d) then
        odd_kept <= (ld_dqi or odd_kept) and dfm_kept;
        dfm_kept <= (ld_dqi or dfm_kept) and held_ff;
        held_ff <= held_e;
      end if;
    end process;

    -- dfm_keep is an eight-bit register used to hold memory data
    -- that can't be put in dfm yet.
    process (clk_d, rst_en)
    begin
      if rst_en = '0' then
        dfm_keep <= x"00";
      elsif rising_edge(clk_d) then
        if ld_dqi = '1' and held_ff = '1' then
          dfm_keep <= d_dqi;
        end if;
      end if;
    end process;

    -- odd_keep is always loaded from memory if ld_dqi is set in the
    -- cycle after dfm_keep is loaded. It is used to hold odd address
    -- memory data that can't be put in dfm_odd yet when two-stepping.
    process (clk_d, rst_en)
    begin
      if rst_en = '0' then
        odd_keep <= x"00";
      elsif rising_edge(clk_d) then
        if ld_dqi = '1' and dfm_kept = '1' then
          odd_keep <= d_dqi;
        end if;
      end if;
    end process;

    -- This is the DFM register. It is loaded with memory data when
    -- ld_dqi is set, or with stored data when dfm_kept is set.
    process (clk_e, rst_en)
    begin
      if rst_en = '0' then
        dfm_int <= x"00";
      elsif rising_edge(clk_e) then
        if ld_dqi = '1' then
          dfm_int <= d_dqi;
        elsif dfm_kept = '1' then
          dfm_int <= dfm_keep;
        end if;
      end if;
    end process;

    -- This is the dfm_odd register, the odd address part of the data
    -- bus when double-speed is used. It is always loaded if ld_dqi is set
    -- in the cycle after dfm is loaded, from memory or from odd_keep.
    process (clk_d, rst_en)
    begin
      if rst_en = '0' then
        dfm_odd <= x"00";
      elsif rising_edge(clk_d) then
        if ld_dqi = '1' and even_c = '1' and held_ff = '0' then
          dfm_odd <= d_dqi;
        elsif odd_kept = '1' then
          dfm_odd <= odd_keep;
        end if;
      end if;
    end process;

    -- m_direct is the direct data bus from memory. It will always be driven
    -- from the dfm register except when we are transferring two bytes per
    -- clk_e cycle over the direct bus and this is the second one. Then it
    -- will be driven from dfm_odd instead.
    m_direct <= dfm_odd when dbl_direct_int = '1' and gate_e = '0' else
                dfm_int;

    -- The direct data bus is driven from m_direct if sel_direct is 10 or 11,
    -- from i_direct (the direct data bus from IOMEM) if sel_direct is 01,
    -- or from g_direct (the direct data bus from GMEM) if sel_direct is 00.
    direct_int <= m_direct when sel_direct_int(1) = '1' else
                  i_direct when sel_direct_int(0) = '1' else
                  g_direct;

    -- Decoding of the PD field from the microprogram word. ld_dtm is high
    -- when DTM should be loaded, sely_d selects the source when the direct
    -- bus is not used, high selects Y bus, low selects D bus.
    ld_dtm <= pl_pd(1);
    sely_d <= not pl_pd(2) and pl_pd(0);

    -- This is the DTM register. It is loaded from direct, dbus or ybus
    -- when ld_dtm is set.
    process (clk_e, rst_en)
    begin
      if rst_en = '0' then
        dtm <= x"00";
      elsif rising_edge(clk_e) then
        if ld_dtm = '1' then
          if use_direct_int = '1' then
            dtm <= direct_int;
          elsif sely_d = '1' then
            dtm <= ybus;
          else
            dtm <= dbus;
          end if;
        end if;
      end if;
    end process;

    -- This is the dtm_even register, the even address part of the data
    -- bus when double-speed is used. It is loaded if ld_dtm is set and
    -- double-speed is selected.
    process (clk_e, rst_en)
    begin
      if rst_en = '0' then
        dtm_even <= x"00";
      elsif falling_edge(clk_e) then
        if ld_dtm = '1' and dbl_direct_int = '1' then
          dtm_even <= direct_int;
        end if;
      end if;
    end process;

    -- This is the data output bus to the SDRAM, it always outputs the dtm
    -- register, except when we are transferring two bytes per
    -- clk_e cycle over the direct bus and this is the first one. Then it
    -- will be driven from dtm_even instead.
    d_dqo <=  dtm_even when (dbl_direct_int = '1' and en_dqo_int = '1'
                             and gate_e = '1') else
              dtm;
    
    -- Assignments needed just because VHDL is stupid
    dfm <= dfm_int;
    direct <= direct_int;  
  end block dtmc;
  en_dqo <= en_dqo_int;
  
end;   
