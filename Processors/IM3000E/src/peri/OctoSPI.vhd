-------------------------------------------------------------------------------
--                                                                           --
--   COPYRIGHT (C)                                    IMSYS AB,  2022        --
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
--
-- Engineer: Markus Karlsson
--
-- Design Name: OctoSPI
-- Project Name: IM4000
-- Description:
--   Interface towards Infineon S27KS0643 (64 MBit DRAM).
--   To be accessed via the IM4000 I/O-bus.
--   DMA support is TBD
--
-- Revision:
-- Revision 0.01 - File Created
--
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use work.gp_pkg.all;

use ieee.numeric_std.all;

entity OctoSPI is
  generic (
    ospi_cmd_address     : std_logic_vector(7 downto 0) := x"40";
    ospi_addr_address    : std_logic_vector(7 downto 0) := x"41";
    ospi_data_address    : std_logic_vector(7 downto 0) := x"42";
    ospi_flags_address   : std_logic_vector(7 downto 0) := x"43";
    ospi_latency_address : std_logic_vector(7 downto 0) := x"44";
    MAX_BURST_LEN        : integer                      := 2  -- Must be even power of 2
    );
  port (clk_p       : in  std_logic;    -- Main clock
        clk_i_pos   : in  std_logic;    --
        rst_n       : in  std_logic;    -- Async reset
        --
        idi         : in  std_logic_vector (7 downto 0); -- I/O bus in
        ido         : out std_logic_vector (7 downto 0); -- I/O bus out
        iden        : out std_logic;                     -- I/O bus enabled (in use)
        ilioa       : in  std_logic;                     -- I/O bus load I/O address
        ildout      : in  std_logic;                     -- I/O bus data output strobe
        inext       : in  std_logic;                     -- I/O bus data input  strobe
        idack       : in  std_logic;                     -- I/O bus DMA Ack
        idreq       : out std_logic;                     -- I/O bus DMA Request
        --
        OSPI_Out    : out OSPI_InterfaceOut_t;          -- OSPI pins out to chip
        OSPI_DQ_i   : in  std_logic_vector(7 downto 0); -- OSPI data bus in
        OSPI_DQ_o   : out std_logic_vector(7 downto 0); -- OSPI data bus out
        OSPI_DQ_e   : out std_logic;                    -- OSPI data bus enable (1=out)
        OSPI_RWDS_i : in  std_logic;                    -- OSPI RWDS in
        OSPI_RWDS_o : out std_logic;                    -- OSPI RWDS out
        OSPI_RWDS_e : out std_logic                     -- OSPI RWDS enable (1=out)
        );
end OctoSPI;

architecture rtl of OctoSPI is

  type OSPI_FSM_t is (
    wr_cmd,       -- Write cmd bytes
    wr_addr,      -- Write addr bytes
    wait_latency, -- Wait for latency time
    wr_data,      -- Write data bytes
    rd_data,      -- Read data bytes
    wait_idle,    -- Waiting for even clock out before going idle
    idle);        -- Idle, no access

  -- subtype OSPI_Cmd_t is std_logic_vector(7 downto 0);

  subtype ospi_cache_index_t is integer range 0 to 127;
  type ospi_cache_t is array(0 to 127) of std_logic_vector(7 downto 0);

  constant OSPI_CNT_BITS : integer                              := 9;
  constant OSPI_CNT_MIN  : unsigned(OSPI_CNT_BITS - 1 downto 0) := (others => '0');
  constant OSPI_CNT_MAX  : unsigned(OSPI_CNT_BITS - 1 downto 0) := (others => '1');

  constant OSPI_FLAG_RW_BIT : integer := 5;

  constant OSPI_CNTPOS_CLK : integer := 2;  -- Dictates OSPI clock in relation to system clock

  -- I/O bis interface
  signal cmd_wr     : std_logic;                     -- Command write strobe
  signal addr_wr    : std_logic;                     -- Address write strobe
  signal data_wr    : std_logic;                     -- Data    write strobe
  signal flags_wr   : std_logic;                     -- Flags   write strobe
  signal latency_wr : std_logic;                     -- Latency write strobe
  --
  -- signal cmd_rd     : std_logic;                  -- Command read strobe
  -- signal addr_rd    : std_logic;                  -- Address read strobe
  signal data_rd    : std_logic;                     -- Data read strobe
  -- signal flags_rd   : std_logic;                  -- Flags   read strobe
  -- signal latency_rd : std_logic;                  -- Latency read strobe
  --
  signal flags_out  : std_logic_vector(7 downto 0);  -- Data out register

  signal clk_out_int : std_logic;       -- Chip clock

  ---------------------------------------------------------
  -- iobus_addr_dec_proc
  signal cmd_sel       : std_logic;     -- Command access selected
  signal addr_sel      : std_logic;     -- Address access selected
  signal data_sel      : std_logic;     -- Data    access selected
  signal flags_sel     : std_logic;     -- Flags   access selected
  signal latency_sel   : std_logic;     -- Latency access selected
  --
  signal iobus_rdindex : ospi_cache_index_t;
  signal iobus_rddata  : std_logic_vector(7 downto 0);

  ---------------------------------------------------------
  -- bus_input_proc
  signal cmd_reg     : std_logic_vector(7 downto 0);   -- Command register
  signal addr_reg    : std_logic_vector(31 downto 0);  -- Address register
  signal flags_reg   : std_logic_vector(7 downto 0);   -- Flags   register
  signal latency_reg : std_logic_vector(7 downto 0);   -- Latency register
--
  signal ospi_wrdata : ospi_cache_t;
--
  signal new_cmd     : boolean;

  ---------------------------------------------------------
  -- ospi_fsm_proc
  signal ospi_fsm     : OSPI_FSM_t;
  signal ospi_counter : unsigned(OSPI_CNT_MAX'range);
  signal ospi_latency : unsigned(3 downto 0);
  signal ospi_length  : unsigned(6 downto 0);
  signal ospi_cmd     : std_logic_vector(7 downto 0);
  signal ospi_addr    : std_logic_vector(31 downto 0);
  signal ospi_flags   : std_logic_vector(7 downto 0);
  signal flag_done    : std_logic;
  --
  signal ospi_rddata  : ospi_cache_t;
  signal ospi_rdindex : ospi_cache_index_t;
  signal ospi_wrindex : ospi_cache_index_t;
  --
  signal ospi_rwds_p  : std_logic;

begin

-- DMA
  idreq <= '1'; -- Active low

-- I/O bus concurrent statements
  ido <= flags_out when flags_sel = '1' else
         addr_reg(7 downto 0) when addr_sel = '1' else
         cmd_reg              when cmd_sel = '1' else
         latency_reg          when latency_sel = '1' else
         iobus_rddata;

  iden <= not inext and (               -- inext is active low
    cmd_sel or addr_sel or data_sel or flags_sel or latency_sel);

--
  flags_out  <= flags_reg(7 downto 1) & flag_done;
--
  cmd_wr     <= '1' when cmd_sel = '1' and ildout = '0'     else '0';
  addr_wr    <= '1' when addr_sel = '1' and ildout = '0'    else '0';
  data_wr    <= '1' when data_sel = '1' and ildout = '0'    else '0';
  flags_wr   <= '1' when flags_sel = '1' and ildout = '0'   else '0';
  latency_wr <= '1' when latency_sel = '1' and ildout = '0' else '0';
--
-- cmd_rd     <= '1' when cmd_sel = '1' and inext = '0'      else '0';
-- addr_rd    <= '1' when addr_sel = '1' and inext = '0'     else '0';
  data_rd    <= '1' when data_sel = '1' and inext = '0'     else '0';
-- flags_rd   <= '1' when flags_sel = '1' and inext = '0'    else '0';
-- latency_rd <= '1' when latency_sel = '1' and inext = '0'  else '0';

  -------------------------------------------------
  -- This process decodes I/O addresses
  iobus_addr_dec_proc : process (clk_p, rst_n)
  begin
    if rst_n = '0' then
      cmd_sel       <= '0';
      addr_sel      <= '0';
      data_sel      <= '0';
      flags_sel     <= '0';
      latency_sel   <= '0';
      --
      iobus_rdindex <= 0;
      iobus_rddata  <= (others => '0');

    elsif rising_edge(clk_p) then

      if data_rd = '1' and clk_i_pos = '0' then
        if iobus_rdindex /= (ospi_rddata'length - 1) then
            iobus_rdindex <= iobus_rdindex + 1;
        else
            iobus_rdindex <= 0;
        end if;
      end if;

      iobus_rddata <= ospi_rddata(iobus_rdindex);

      if ilioa = '0' and clk_i_pos = '0' then
        cmd_sel     <= '0';
        addr_sel    <= '0';
        data_sel    <= '0';
        flags_sel   <= '0';
        latency_sel <= '0';

        if idi = ospi_cmd_address then
          cmd_sel <= '1';
        end if;
        --
        if idi = ospi_addr_address then
          addr_sel <= '1';
        end if;
        --
        if idi = ospi_data_address then
          data_sel      <= '1';
          iobus_rdindex <= 0;  -- Reset read address on new data access
        end if;
        --
        if idi = ospi_flags_address then
          flags_sel <= '1';
        end if;
        --
        if idi = ospi_latency_address then
          latency_sel <= '1';
        end if;
      --
      end if;  -- ilioa

    end if;  -- clk_p
  end process;


  -------------------------------------------------
  -- This process collect data from the I/O bus interface
  --
  bus_input_proc : process(clk_p, rst_n)
    variable addr_index : integer range 0 to 3;
    variable data_index : ospi_cache_index_t;
  begin
    if rst_n = '0' then

      cmd_reg     <= (others => '0');
      addr_reg    <= (others => '0');
      flags_reg   <= (others => '0');
      latency_reg <= x"07";

      ospi_wrdata <= (others => (others => '-'));

      new_cmd <= false;

      addr_index := 0;
      data_index := 0;

    elsif rising_edge(clk_p) then

      -- Defaults
      new_cmd <= false;

      -- Command
      if cmd_wr = '1' and clk_i_pos = '0' then
        cmd_reg <= idi;
        new_cmd <= true;

        addr_index := 0;
        data_index := 0;
      end if;

      -- Address
      if addr_wr = '1' and clk_i_pos = '0' then
        addr_reg(addr_index * 8 + 7 downto addr_index * 8) <= idi;
        addr_index                                         := (addr_index + 1) mod 4;

        data_index := 0;
      end if;

      -- Data
      if data_wr = '1' and clk_i_pos = '0' then
        ospi_wrdata(data_index) <= idi;
        if data_index /= (ospi_wrdata'length - 1) then
          data_index := data_index + 1;
        end if;

        addr_index := 0;
      end if;

      -- Flags
      if flags_wr = '1' and clk_i_pos = '0' then
        flags_reg(7 downto 6) <= (others => '0');  -- FFU
        flags_reg(5)          <= idi(5);           -- ACC, 0 = read, 1 = write
        flags_reg(4 downto 2) <= idi(4 downto 2);  -- LEN
        flags_reg(1)          <= idi(1);           -- Auto increment enable
        -- flags_reg(0) is read only

        addr_index := 0;
        data_index := 0;
      end if;

      -- Latency
      if latency_wr = '1' and clk_i_pos = '0' then
        latency_reg <= idi;

        addr_index := 0;
        data_index := 0;
      end if;

    end if;  -- clk_p
  end process;

  -------------------------------------------------
  -- This process drives the OSPI HW interface
  --
  -- Process related consurrent statements
  OSPI_Out.CK_p <= clk_out_int;
  OSPI_Out.CK_n <= not clk_out_int;
  --
  ospi_fsm_proc : process(clk_p, rst_n)
    variable rd_trig     : boolean;
    variable wr_trig     : boolean;
    variable latency_int : integer range 0 to 15;
  begin
    if rst_n = '0' then
      OSPI_Out.RESET_n <= '0';
      OSPI_Out.CS_n    <= '1';

      OSPI_DQ_o   <= x"00";
      OSPI_DQ_e   <= '0';
      OSPI_RWDS_o <= '0';
      OSPI_RWDS_e <= '0';

      clk_out_int <= '0';

      ospi_fsm     <= idle;
      ospi_counter <= (others => '0');
      ospi_latency <= (others => '0');
      ospi_length  <= (others => '0');

      ospi_cmd   <= (others => '0');
      ospi_addr  <= (others => '0');
      ospi_flags <= (others => '0');
      flag_done  <= '0';

      ospi_rddata  <= (others => (others => '-'));
      ospi_rdindex <= 0;
      ospi_wrindex <= 0;

      ospi_rwds_p <= '0';

      rd_trig := false;
      wr_trig := false;

    elsif rising_edge(clk_p) then

      OSPI_Out.RESET_n <= '1';
      OSPI_Out.CS_n    <= '0';
      OSPI_DQ_o        <= (others => '-');
      OSPI_DQ_e        <= '0';
      OSPI_RWDS_o      <= '-';
      OSPI_RWDS_e      <= '0';

      clk_out_int <= std_logic(ospi_counter(OSPI_CNTPOS_CLK));

      ospi_rwds_p <= OSPI_RWDS_i;

      ospi_counter <= ospi_counter + 1;

      case ospi_fsm is
        when idle =>
          ospi_counter <= (others => '0');
          -- Make "copy" of current parameters, so they cannot change during operation
          ospi_cmd   <= cmd_reg;
          ospi_addr  <= addr_reg;
          ospi_flags <= flags_reg;

          flag_done <= '1';

          case flags_reg(4 downto 2) is
            when "100"  => ospi_length <= "1111111";  -- 128 B burst
            when "101"  => ospi_length <= "0111111";  --  64 B burst
            when "111"  => ospi_length <= "0011111";  --  32 B burst
            when "110"  => ospi_length <= "0001111";  --  16 B burst
            when "000"  => ospi_length <= "0000000";  --   0 B burst
            when "010"  => ospi_length <= "0000001";  --   2 B single read
            when others => ospi_length <= "0000001";  --   2 B default
          end case;

          if new_cmd then
            ospi_fsm  <= wr_cmd;
            flag_done <= '0';
          else
            OSPI_Out.CS_n <= '1';
          end if;

        when wr_cmd =>
          OSPI_DQ_o <= ospi_cmd;
          OSPI_DQ_e <= '1';

          if ospi_counter(OSPI_CNTPOS_CLK + 2 downto OSPI_CNTPOS_CLK - 2) = 9 then
            if ospi_length = 0 then
              --if ospi_counter(OSPI_CNTPOS_CLK downto 0) = 0 then -- (2**OSPI_CNTPOS_CLK) - 1
              ospi_fsm  <= idle;
              flag_done <= '1';
            --end if;
            else
              ospi_fsm <= wr_addr;
            end if;

            if latency_reg(2 downto 0) = "000" then
              latency_int := 0;
            
            else
              latency_int := to_integer(unsigned(latency_reg(2 downto 0)));
              
              -- High RWDS is double the latency
              if OSPI_RWDS_i = '1' then
                  latency_int := 2 * latency_int;
              end if;  

              -- Writes require one extra cc
              if ospi_flags(OSPI_FLAG_RW_BIT) = '1' then
                latency_int := latency_int + 1;
              end if;
            end if;
            
            ospi_latency <= to_unsigned(latency_int, ospi_latency'length);
          end if;

        when wr_addr =>
          OSPI_DQ_e <= '1';
          if ospi_counter(OSPI_CNTPOS_CLK + 2 downto OSPI_CNTPOS_CLK - 2) < 14 then
            OSPI_DQ_o <= ospi_addr(31 downto 24);

          elsif ospi_counter(OSPI_CNTPOS_CLK + 2 downto OSPI_CNTPOS_CLK - 2) < 18 then
            OSPI_DQ_o <= ospi_addr(23 downto 16);

          elsif ospi_counter(OSPI_CNTPOS_CLK + 2 downto OSPI_CNTPOS_CLK - 2) < 22 then
            OSPI_DQ_o <= ospi_addr(15 downto 8);

          else
            OSPI_DQ_o <= ospi_addr(7 downto 0);
            if ospi_counter(OSPI_CNTPOS_CLK + 2 downto OSPI_CNTPOS_CLK - 2) = 25 then
              ospi_counter(OSPI_CNT_BITS - 1 downto OSPI_CNTPOS_CLK + 1) <= (others => '0');
              if ospi_latency /= 0 then
                ospi_fsm <= wait_latency;
              elsif ospi_flags(OSPI_FLAG_RW_BIT) = '0' then
                ospi_fsm     <= rd_data;
                ospi_rdindex <= 0;
                rd_trig      := false;
              else
                ospi_fsm                                                   <= wr_data;
                ospi_wrindex                                               <= 0;
                ospi_counter(OSPI_CNT_BITS - 1 downto OSPI_CNTPOS_CLK + 1) <= (others => '0');
                wr_trig                                                    := false;
              end if;
            end if;
          end if;

        when wait_latency =>
          -- Max latency 14cc => 4 bit comparitor
          if ospi_counter(OSPI_CNTPOS_CLK + 4 downto OSPI_CNTPOS_CLK + 1) = ospi_latency then
            if ospi_flags(OSPI_FLAG_RW_BIT) = '0' then
              ospi_fsm     <= rd_data;
              ospi_rdindex <= 0;
              -- ospi_counter(OSPI_CNT_BITS - 1 downto OSPI_CNTPOS_CLK + 1) <= (others => '0');
              rd_trig      := false;
            else
              ospi_fsm                                                   <= wr_data;
              ospi_wrindex                                               <= 0;
              ospi_counter(OSPI_CNT_BITS - 1 downto OSPI_CNTPOS_CLK + 1) <= (others => '0');
              wr_trig                                                    := false;
            end if;
          end if;

        when rd_data =>
          -- Max burst len 127 => 7 bit comparitor
          if ospi_counter(OSPI_CNTPOS_CLK - 1 downto 0) = (2 ** OSPI_CNTPOS_CLK) - 1 then  -- Timing adjustment possible here

            if ospi_rdindex = to_integer(ospi_length) then
              ospi_fsm     <= idle;
              ospi_counter <= (others => '0');
            end if;

            if rd_trig then
              rd_trig                   := false;
              ospi_rddata(ospi_rdindex) <= OSPI_DQ_i;
              ospi_rdindex              <= ospi_rdindex + 1;
            end if;
          end if;

          if OSPI_RWDS_i /= ospi_rwds_p then
            rd_trig := true;
          end if;

          if new_cmd then
            -- Safeguard, to prevent hanging
            ospi_fsm <= wr_cmd;
          end if;

        when wr_data =>
          if ospi_counter(OSPI_CNTPOS_CLK - 1 downto 0) = 2**(OSPI_CNTPOS_CLK - 1) then
            wr_trig := true;
          end if;

          if wr_trig then
            OSPI_DQ_e <= '1';
            OSPI_DQ_o <= ospi_wrdata(ospi_wrindex);
            if ospi_latency /= 0 then
              -- If reg access, do not drive RWDS
              OSPI_RWDS_o <= '0';
              OSPI_RWDS_e <= '1';
            end if;

            if ospi_counter(OSPI_CNTPOS_CLK - 1 downto 0) = 2**(OSPI_CNTPOS_CLK - 1) - 1 then  -- Timing adjustment possible here
              ospi_wrindex <= ospi_wrindex + 1;

              if ospi_wrindex = to_integer(ospi_length) then
                ospi_fsm <= idle;
              -- flag_done <= '1'; -- Save a cc?
              end if;

            end if;

          end if;

          if new_cmd then
            -- Safeguard, to prevent hanging
            ospi_fsm <= wr_cmd;
          end if;

        when wait_idle =>
          if ospi_counter(OSPI_CNTPOS_CLK downto 0) = 0 then
            ospi_fsm  <= idle;
            flag_done <= '1';
          end if;

      end case;

    end if;  -- clk_p
  end process;

end rtl;

