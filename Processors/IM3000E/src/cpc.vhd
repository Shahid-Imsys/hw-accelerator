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
-- Title      : cpc
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : cpc.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: CPC is the serial control interface used for booting/debugging
--              the processor. 
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		2.12				CB			Created
-- 2014-08-08 		3.0				HYX			Trace memory added
-------------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned.all;

entity cpc is   
  port (
    -- Clock and reset inputs
    rst_cn      : in std_logic;      -- system reset
    clk_p       : in std_logic;                 
    clk_s_pos   : in std_logic;      -- SP clock                      
    clk_e_pos   : in std_logic;      -- exe clock
    -- Control inputs
    runmode     : in std_logic;      -- TIM in run mode     
    spreq_n     : in std_logic;      -- SP request from TIM               
    spack_n     : in std_logic;      -- SP acknowledge from TIM           
    ld_mar      : in std_logic;      -- Catch bus (CALL SP) from TIM           
    -- Data inputs
    mp_q        : in std_logic_vector(79 downto 0); -- Microprogram data
    pmem_q      : in std_logic_vector(1 downto 0);  -- Patch memory data
    curr_mpga   : in std_logic_vector(13 downto 0); -- Current mpgm address
    mar         : in std_logic_vector(13 downto 0); -- MAR register, from CLC
    dbus        : in std_logic_vector(7 downto 0); -- D bus
    ybus        : in std_logic_vector(7 downto 0); -- Y bus
    -- Control outputs
    mpram_we_n  : out std_logic;        -- uWord write enable
    rsc_n       : out std_logic;        -- Reset TIM
    stop_step   : out std_logic;        -- Stop/single step TIM
    run         : out std_logic;        -- Set TIM in run mode
    plsel_n     : out std_logic;        -- MPGM OE control      
    plcpe_n     : out std_logic;        -- Pipeline register clock enable
    spack_cmd   : out std_logic;        -- SP acknowledge, to TIM 
    gen_spreq   : out std_logic;        -- To TIM to generate SPREQ     
    byte_sel    : out std_logic_vector(3 downto 0); -- uWord byte select, to MPLL 
    wmlat       : out std_logic;        -- Load uWord latch ctrl, to MPLL
    -- Data outputs
    dtal        : out std_logic_vector(7 downto 0);  -- data to 'DSL'
    dtcl        : out std_logic_vector(7 downto 0);  -- data to 'CLC'
    dfsr        : out std_logic_vector(7 downto 0);  -- data to 'MPLL'
    -- External pins
    msdin       : in  std_logic;         -- Serial data input
    msdout      : out std_logic;         -- Serial data out
--    -- TRCMEM signals
    trcmem_q    : in  std_logic_vector(31 downto 0); -- Data in from trace memory
    trcmem_d    : out std_logic_vector(31 downto 0); -- Data out to trace memory
    trcmem_a    : out std_logic_vector(7 downto 0);  -- Trace memory address
    trcmem_ce_n : out std_logic;        -- Trace memory chip select(active low)
    trcmem_we_n : out std_logic);       -- Trace memory write enable(active low)
end cpc;

architecture rtl of cpc is
  signal tx_load        : std_logic;
  signal byte_rec       : std_logic;
  signal dtsr           : std_logic_vector(7 downto 0);
  signal wcdap          : std_logic;
  signal wtimc          : std_logic;
  signal wdclc          : std_logic;
  signal wdalc          : std_logic;
  signal tx_sel         : std_logic_vector(2 downto 0);
  signal byte_cnt       : std_logic_vector(3 downto 0);
  signal byte_cnt_zero  : std_logic;
  signal dbreg          : std_logic_vector(7 downto 0);
  -- TRC signals
  constant mem_addr_sz  : positive := 8;
  signal rdata          : std_logic_vector(7 downto 0);
  signal go             : std_logic;
  -- Internal copies
  signal dfsr_int       : std_logic_vector(7 downto 0);
  signal plsel_nint     : std_logic;
  signal plcpe_nint     : std_logic;
  signal mpram_we_nint  : std_logic;

  attribute mark_debug : string; 
  attribute mark_debug of dfsr: signal is "true";  
  attribute mark_debug of ld_mar: signal is "true";  
  attribute mark_debug of clk_e_pos: signal is "true";
  attribute mark_debug of mar: signal is "true";  


begin
  dfsr <= dfsr_int;
  mpram_we_n <= mpram_we_nint;
  plsel_n <= plsel_nint;
  plcpe_n <= plcpe_nint;
  byte_sel <= byte_cnt;

  -----------------------------------------------------------------------------
  -- Bit-serial input from SP is received, parallelized and output to other
  -- internal parts as 'byte' format (serial-in, parallel-out).
  -----------------------------------------------------------------------------
  sdr: block
    signal rx_en      : std_logic;  -- Receive enable (active high)
    signal sipo_reg   : std_logic_vector(7 downto 0); -- Receive shift register
    signal cnt        : std_logic_vector(2 downto 0); -- Bit counter
    signal cnt_tc     : std_logic;  -- Bit counter terminal count (active high)
    signal rx_stop    : std_logic;  -- Stop bit (active high)
    
  begin
    -- The rx_en signal is set by an incoming start bit
    -- (msdin low) and cleared when the bit counter reaches
    -- its terminal count. The signal is therefore high
    -- during the eight data bits of an incoming byte.  
    rx_en_gen: process (clk_p)
    begin 
        if rising_edge(clk_p) then--rising_edge(clk_s)       
            if rst_cn = '0' then 
                rx_en <= '0';           
            elsif clk_s_pos = '0' then
                rx_en <= (not msdin or rx_en) and not rx_stop and not cnt_tc;  
        end if;
      end if;
    end process rx_en_gen;

    -- This is the receive shift register. Data is shifted
    -- into it lsb-first when rx_en is high.
    sipo: process(clk_p)
    begin        
      if rising_edge(clk_p) then--rising_edge(clk_s)
        if rst_cn = '0' then
            sipo_reg <= (others => '0');
        elsif rx_en = '1' and clk_s_pos = '0' then
          sipo_reg <= msdin & sipo_reg(7 downto 1);
        end if;
      end if;
    end process sipo;

    -- Bit counter. Synchronously reset to zero when rx_en
    -- is inactive. Its terminal count output cnt_tc is high
    -- during the last bit (msb) of an incoming data byte.
    sdr_cnt: process (clk_p)
    begin
        if rising_edge(clk_p) then--rising_edge(clk_s)       
            if rst_cn = '0' then 
                cnt <= (others => '0');
            elsif clk_s_pos = '0' then
                if rx_en = '1' then
                    cnt <= cnt + 1;
                else
                    cnt <= (others => '0');
                end if;
            end if;
        end if;
    end process sdr_cnt;
    cnt_tc <= '1' when cnt = "111" else '0';               

    -- Stop bit flip-flop. High during an incoming stop bit.
    -- Activation of rx_en is inhibited during the stop bit.
    rx_stop_gen: process (clk_p)
    begin 
        if rising_edge(clk_p) then--rising_edge(clk_s)      
            if rst_cn = '0' then 
                rx_stop <= '0';
            elsif clk_s_pos = '0' then
                rx_stop <= cnt_tc;
            end if;
        end if;
    end process rx_stop_gen;

    dfsr_int <= sipo_reg;
    byte_rec <= rx_stop;
  end block;

  -----------------------------------------------------------------------------
  -- Internal data byte is output to SP as bit-serial format (parallel-in,
  -- serial-out).
  -----------------------------------------------------------------------------
  sdt: block
    signal tx_en      : std_logic;   -- Transmit enable (active high)
    signal piso_reg   : std_logic_vector(7 downto 0); -- Transmit shift register
    signal cnt        : std_logic_vector(2 downto 0); -- Bit counter
    signal cnt_tc     : std_logic;   -- Bit counter terminal count (active high)
    signal msdout_int : std_logic;
  
  begin  
    msdout_gen: process (clk_p)
    begin
        if rising_edge(clk_p) then--rising_edge(clk_s)       
            if rst_cn = '0' then 
                msdout_int <= '1';
            elsif clk_s_pos = '0' then
                if tx_load = '1' then
                    msdout_int <= '0';
                elsif msdout_int = '0' or tx_en = '1' then 
                    msdout_int <= piso_reg(0);
                end if;
            end if;
        end if;
    end process msdout_gen;
    msdout <= msdout_int;

    -- The tx_en signal is set by an outgoing start bit
    -- (msdout low) and cleared when the bit counter reaches
    -- its terminal count. The signal is therefore high
    -- during the eight data bits of an outgoing byte.  
    tx_en_gen: process (clk_p)
    begin
        if rising_edge(clk_p) then--rising_edge(clk_s)       
            if rst_cn = '0' then
                tx_en <= '0';
            elsif clk_s_pos = '0' then
                tx_en <= not msdout_int or (tx_en and not cnt_tc);  
            end if;
        end if;
    end process tx_en_gen;
    
    -- This is the transmit shift register. Data is shifted
    -- out from it lsb-first when tx_en is high or the start
    -- bit is active (msdout low). Loaded from dtsr when
    -- tx_load is high.
    piso: process (clk_p)
    begin
      if rising_edge(clk_p) then--rising_edge(clk_s)
        if rst_cn = '0' then
            piso_reg <= (others => '0');
        elsif clk_s_pos = '0' then
            if tx_load = '1' then
              piso_reg <= dtsr;
            elsif msdout_int = '0' or tx_en = '1' then
              piso_reg <= '1' & piso_reg(7 downto 1);
            end if;
        end if;                                  
      end if;
    end process piso;            
    
    -- Bit counter. Synchronously reset to zero when tx_en
    -- is inactive. Its terminal count output cnt_tc is high
    -- during the last bit (msb) of an outgoing data byte.
    sdt_cnt: process (clk_p)
    begin
        if rising_edge(clk_p) then--rising_edge(clk_s)       
            if rst_cn = '0' then 
                cnt <= (others => '0');
            elsif clk_s_pos = '0' then
                if tx_en = '1' then
                    cnt <= cnt + 1;
                else
                    cnt <= (others => '0');
                end if;
            end if;
        end if;
    end process sdt_cnt;
    cnt_tc <= '1' when cnt = "111" else '0';               
  end block;

  -----------------------------------------------------------------------------
  -- CDD decodes the SP send serial interface commands.
  -----------------------------------------------------------------------------
  cdd: block
    signal cmd_reg      : std_logic_vector(3 downto 0);
    signal parm_rec     : std_logic;
    signal byte_rec_dly : std_logic;

  --attribute mark_debug : string;
  attribute mark_debug of cmd_reg: signal is "true";  

  begin
    -- When the byte counter (byte_cnt) is zero, the command register
    -- (cmd_reg) and the counter are loaded when a byte is received,
    -- the command register from the high nibble and the counter from
    -- the low. If the counter is not zer, it is decremented when new
    -- bytes arrive and the command register is not loaded.  
    byte_counter: process (clk_p)
    begin
        if rising_edge(clk_p) then--rising_edge(clk_s)        
            if rst_cn = '0' then     
                cmd_reg <= (others => '0');                      
                byte_cnt <= (others => '0');                      
            elsif clk_s_pos = '0' then
                if tx_load = '1' then
                    cmd_reg <= (others => '0');
                    byte_cnt <= (others => '0');
                elsif byte_rec = '1' then
                    if byte_cnt_zero = '1' then
                        cmd_reg <= dfsr_int(7 downto 4);
                        byte_cnt <= dfsr_int(3 downto 0);
                    else
                        byte_cnt <= byte_cnt - 1;
                    end if;
                end if;
            end if;
        end if;
    end process byte_counter;
    byte_cnt_zero <= '1' when byte_cnt = "0000" else '0';
    parm_rec <= byte_rec and not byte_cnt_zero;
    
    -- Write CDAP register
    wcdap <= '1' when parm_rec = '1' and cmd_reg = x"1" else '0';
    -- Write microprogram load latch
    wmlat <= '1' when parm_rec = '1' and cmd_reg = x"2" else '0';          
    -- Write TIMC register
    wtimc <= '1' when parm_rec = '1' and cmd_reg = x"3" else '0';
    -- Write CLC register
    wdclc <= '1' when parm_rec = '1' and cmd_reg = x"4" and
             byte_cnt(1) = '1' else '0';
    -- Write ALC register
    wdalc <= '1' when parm_rec = '1' and (cmd_reg = x"4" or cmd_reg = x"5") and
             byte_cnt(0) = '1' else '0';

    -- Load transmit shift register
    byte_rec_dly_gen: process (clk_p)
    begin
        if rising_edge(clk_p) then--rising_edge(clk_s)        
            if rst_cn = '0' then     
                byte_rec_dly <= '0';                      
            elsif clk_s_pos = '0' then
                byte_rec_dly <= byte_rec;
            end if;
        end if;
    end process byte_rec_dly_gen;
    tx_load <= byte_rec_dly and cmd_reg(3);
    
    -- Source select for transmit shift register
    tx_sel <= cmd_reg(2 downto 0);

    -- Generate SPREQ when ALC has been read or written.
    gen_spreq <= '1' when wdalc = '1' else
                 '1' when tx_load = '1' and cmd_reg(2 downto 0) = "101" else
                 '0';
  end block;

  -----------------------------------------------------------------------------
  -- 'cmdWr' describes the serial interface 'write' command execution,
  -- including timing control decoding (TCD), data to CLC register, data
  -- to ALC register and control data path register (CDAP).
  -----------------------------------------------------------------------------
  cmdWr: block
  begin 
    -- Control data path register (CDAP).
    cdap_register: process (clk_p)
    begin
        if rising_edge(clk_p) then     --rising_edge(clk_s)       
            if rst_cn = '0' then 
                plsel_nint      <= '1';
                plcpe_nint      <= '1';
                mpram_we_nint   <= '1';
            elsif wcdap = '1' and clk_s_pos = '0' then
                plsel_nint    <= dfsr_int(0);
                plcpe_nint    <= dfsr_int(1);
                mpram_we_nint <= dfsr_int(2);
            end if;
        end if;
    end process cdap_register;

    -- Data to CLC register (CLC).
    clc_register: process (clk_p)
    begin        
      if rising_edge(clk_p) then--rising_edge(clk_s)
        if rst_cn = '0' then
            dtcl <= (others => '0');
        elsif wdclc = '1' and clk_s_pos = '0' then
            dtcl <= dfsr_int;
        end if;
      end if;
    end process clc_register;

    -- Data to ALC register (ALC).
    alc_register: process (clk_p)
    begin        
      if rising_edge(clk_p) then--rising_edge(clk_s) 
        if rst_cn = '0' then
            dtal <= (others => '0');
        elsif wdalc = '1' and clk_s_pos = '0' then
            dtal <= dfsr_int;
        end if;
      end if;
    end process alc_register;

    -- Data bus hold register, catches dbus on 'CALL SP'
    dbreg_register: process (clk_p)
    begin        
      if rising_edge(clk_p) then --rising_edge(clk_e)
        if rst_cn = '0' then
            dbreg <= (others => '0');
        elsif ld_mar = '1' and clk_e_pos = '0' then
            dbreg <= dbus;
        end if;
      end if;
    end process dbreg_register;

    -- Timing control decode (TCD).
    rsc_n      <= '0' when (wtimc = '1' and dfsr_int = x"00") else '1';
    stop_step  <= '1' when (wtimc = '1' and dfsr_int = x"03") else '0';
    run        <= '1' when (wtimc = '1' and dfsr_int = x"04") else '0';
    spack_cmd  <= '1' when (wtimc = '1' and dfsr_int = x"05") else '0';
  end block;            

  -----------------------------------------------------------------------------
  -- 'cmdRd' describes the serial interface 'read' command execution. It
  -- multiplexes the microprogram data, microprogram address, D-bus, Y-bus
  -- and the status to Tx shift register.
  -----------------------------------------------------------------------------
  cmdRd: block
    signal mpd_muxout : std_logic_vector(7 downto 0);
  begin  

    -- Mux for microprogram data. Feeds into the dtsr mux below.
    mpd_mux: process(byte_cnt, mp_q, pmem_q)
    begin        
      case byte_cnt is
        when "0001" =>
          mpd_muxout <= mp_q(7 downto  0);
        when "0010" =>
          mpd_muxout <= mp_q(15 downto 8);
        when "0011" =>
          mpd_muxout <= mp_q(23 downto 16);
        when "0100" =>
          mpd_muxout <= mp_q(31 downto 24);
        when "0101" =>
          mpd_muxout <= mp_q(39 downto 32);
        when "0110" =>
          mpd_muxout <= mp_q(47 downto 40);
        when "0111" =>
          mpd_muxout <= mp_q(55 downto 48);
        when "1000" =>
          mpd_muxout <= mp_q(63 downto 56);
        when "1001" =>
          mpd_muxout <= mp_q(71 downto 64);
        when "1010" =>
          mpd_muxout <= mp_q(79 downto 72);
        when "1111" =>
          mpd_muxout <= "000000" & pmem_q;
        when others =>
          mpd_muxout <= (others => '-');
      end case;
    end process mpd_mux;

    -- Mux for data to transmit shift register (dtsr).
    dtsr_mux: process(tx_sel, dbus, ybus, mar, mpd_muxout, mpram_we_nint,
                      plcpe_nint, plsel_nint, runmode, spreq_n, spack_n,
                      rdata, go, dbreg)
    begin        
      case tx_sel is
        when "000" =>
          dtsr <= "00" & mar(13 downto 8);
        when "001" =>
          dtsr <= mar(7 downto 0);
        when "010" =>
          dtsr <= mpd_muxout;
        when "011" =>
          dtsr <= dbus;
        when "100" =>
          dtsr <= ybus;
        when "101" =>
          dtsr <= dbreg;
        when "110" =>
          dtsr <= runmode & '0' & spreq_n & spack_n & go &
                  mpram_we_nint & plcpe_nint & plsel_nint;
        when "111" =>
          dtsr <= rdata;
        when others => null;
      end case;
    end process dtsr_mux;
  end block;     
  
  -----------------------------------------------------------------------------
  -- Microprogram trace adapter instantiation.
  -----------------------------------------------------------------------------
  trc: block
    signal cmdstrt : std_logic;
    signal cmdend  : std_logic;  
    signal rd      : std_logic;
    signal wdata   : std_logic_vector(7 downto 0);

  begin
    cmdstrt <= byte_cnt_zero;   
    cmdend  <= '1' when byte_cnt = 1 else '0';
    rd      <= tx_load when tx_sel(2 downto 0) = "111" else '0';

    -- The command for trace is swapped
    process (cmdstrt, dfsr_int)
    begin       
      if cmdstrt = '1' then
        wdata <= "0000" & dfsr_int(7 downto 4);
      else
        wdata <= dfsr_int;
      end if;
    end process;                                                        

--    -- Instance of trace
    trace : entity work.debug_trace
      generic map(
        mem_addr_sz     => mem_addr_sz,
        set_trace_cmd   => x"6",
        go_trace_cmd    => x"7",
        read_trace_cmd  => x"F")
      port map(
--        clk_e   => clk_e,
        clk_p   => clk_p,
        clk_e_pos => clk_e_pos,
        clk_s_pos   => clk_s_pos,
        rst_cn     => rst_cn,
        go      => go,
        wdata   => wdata,
        wr      => byte_rec,
        cmdstrt => cmdstrt,
        cmdend  => cmdend,
        rdata   => rdata,
        rd      => rd,
        rsel    => open,
        mpg_a   => curr_mpga,
        d       => dbus,
        y       => ybus,
        i       => trcmem_q,
        o       => trcmem_d,
        a       => trcmem_a,
        adsc_n  => trcmem_ce_n,       
        gw_n    => trcmem_we_n,
        oe_n    => open);
--    go <= '0';
--    rdata <= (others => '0');
    

  end block;
end rtl;

