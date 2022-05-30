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
-- Design Name: ionoc
-- Project Name: IM4000
-- Description:
--   Interface/bridge between IO-bus and NOC adapter
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

entity ionoc is
  generic (
    ionoc_status_address : std_logic_vector(7 downto 0) := x"45";
    ionoc_cmd_address    : std_logic_vector(7 downto 0) := x"46";
    ionoc_data_address   : std_logic_vector(7 downto 0) := x"47";
    MAX_BURST_LEN        : integer                      := 2  -- Must be even power of 2
    );
  port (clk_p        : in  std_logic;   -- Main clock
        clk_i_pos    : in  std_logic;   --
        rst_n        : in  std_logic;   -- Async reset
        -- I/O bus
        idi          : in  std_logic_vector (7 downto 0);     -- I/O bus in
        ido          : out std_logic_vector (7 downto 0);     -- I/O bus out
        iden         : out std_logic;   -- I/O bus enabled (in use)
        ilioa        : in  std_logic;   -- I/O bus load I/O address
        ildout       : in  std_logic;   -- I/O bus data output strobe
        inext        : in  std_logic;   -- I/O bus data input  strobe
        idack        : in  std_logic;   -- I/O bus DMA Ack
        idreq        : out std_logic;   -- I/O bus DMA Request
        -- GPP to NOC
        GPP_CMD      : out std_logic_vector(127 downto 0); -- Command word
        GPP_CMD_Flag : out std_logic;                      -- Command word valid
        NOC_CMD_ACK  : in  std_logic;                      -- NOC ready
        -- NOC to GPP
        NOC_CMD_Flag : in  std_logic;   -- NOC command byte is valid
        NOC_CMD      : in  std_logic_vector(7 downto 0);      -- Command byte
        GPP_CMD_ACK  : out std_logic;   -- GPP ack of command byte
        --
        TxFIFO_Ready : out std_logic;  -- Interface can accept a word from the TxIFO
        TxFIFO_Valid : in  std_logic;  -- TxFIFO has availble data which is presented on bus
        TxFIFO_Data  : in  std_logic_vector(127 downto 0);    -- TxFIFO data
        --
        RxFIFO_Ready : in  std_logic;  -- RxFIFO can accept a word from the IO-bus
        RxFIFO_Valid : out std_logic;  -- Interface has availble data which is presented on bus
        RxFIFO_Data  : out std_logic_vector(127 downto 0);    -- RxFIFO data
        --
        NOC_IRQ      : out std_logic    -- Interrupt on available data from NOC
        );
end ionoc;

architecture rtl of ionoc is

  subtype ionoc_cache_index_t is integer range 0 to 15;
  type ionoc_cache_t is array(0 to 15) of std_logic_vector(7 downto 0);

  -- I/O-bus interface
  signal status_wr      : std_logic;    -- Status write strobe
  signal status_rd      : std_logic;    -- Status read strobe
  signal cmd_wr         : std_logic;    -- Cmd write strobe
  signal cmd_rd         : std_logic;    -- Cmd read strobe
  signal data_wr        : std_logic;    -- Data write strobe
  signal data_rd        : std_logic;    -- Data read strobe
  -- Other concurrent signals
  signal ionoc_rdstatus : std_logic_vector(7 downto 0);

  ---------------------------------------------------------
  -- iobus_proc
  signal status_sel : std_logic;        -- Status access selected
  signal cmd_sel    : std_logic;        -- Cmd access selected
  signal data_sel   : std_logic;        -- Data access selected

  ---------------------------------------------------------
  -- noc_cmd_proc
  signal GPP_CMD_Flag_int   : std_logic;
  signal GPP_CMD_ACK_int    : std_logic;
  --
  signal ionoc_rdcmd        : std_logic_vector(7 downto 0);
  --
  signal ionoc_cmdindex     : ionoc_cache_index_t;
  signal ionoc_wrcmd        : ionoc_cache_t;
  --
  signal ionoc_word_pending : boolean;  -- IO bus has issued word which is yet to be read by NOC
  signal ionoc_byte_pending : boolean;  -- NOC has issued byte which is yet to be read by IO bus
  signal innoc_word_isread  : boolean;  -- NOC has read word presented

  ---------------------------------------------------------
  -- noc_data_proc
  signal ionoc_datawrindex    : ionoc_cache_index_t;
  signal ionoc_datardindex    : ionoc_cache_index_t;
  signal ionoc_wrdata         : ionoc_cache_t;
  signal ionoc_rddata         : ionoc_cache_t;
  signal ionoc_rdbyte         : std_logic_vector(7 downto 0);
  --
  signal ionoc_wrdata_pending : boolean;
  signal ionoc_rddata_pending : boolean;

begin

-- Concurrent statements
  GPP_CMD_ACK  <= GPP_CMD_ACK_int;
  TxFIFO_Ready <= '0' when ionoc_rddata_pending else '1';

-- Interrupt in cmd available
  NOC_IRQ <= ionoc_rdstatus(1);

-- Status output
  ionoc_rdstatus(0) <= '1' when ionoc_word_pending else
                       '0';  -- Word is presented to but not yet read by NOC
  ionoc_rdstatus(1) <= '1' when ionoc_byte_pending else
                       '0';  -- Byte is recieved from NOC, but not read by IO-bus
  ionoc_rdstatus(2) <= '1' when innoc_word_isread else
                       '0';  -- Word is read by NOC

  ionoc_rdstatus(5 downto 3) <= (others => '0');

  ionoc_rdstatus(6) <= '1' when ionoc_wrdata_pending else
                       '0';             -- Data write will be accepted
  ionoc_rdstatus(7) <= '1' when ionoc_rddata_pending else
                       '0';             -- There is data available for reading



-- DMA
  idreq <= '1';                         -- Active low

-- I/O bus concurrent statements
  ido <= ionoc_rdcmd when cmd_sel = '1' else
         ionoc_rdbyte when data_sel = '1' else
         ionoc_rdstatus;                -- when status_sel = '1' else
  iden      <= not inext and (status_sel or cmd_sel or data_sel);  -- inext is active low
--
  status_wr <= '1' when status_sel = '1' and ildout = '0' else '0';
  cmd_wr    <= '1' when cmd_sel = '1' and ildout = '0'    else '0';
  data_wr   <= '1' when data_sel = '1' and ildout = '0'   else '0';
--
  status_rd <= '1' when status_sel = '1' and inext = '0'  else '0';
  cmd_rd    <= '1' when cmd_sel = '1' and inext = '0'     else '0';
  data_rd   <= '1' when data_sel = '1' and inext = '0' else '0';

  -------------------------------------------------
  -- This process decodes I/O addresses and interfaces the IO-bus
  iobus_proc : process (clk_p, rst_n)
  begin
    if rst_n = '0' then
      status_sel <= '0';
      cmd_sel    <= '0';
      data_sel   <= '0';

    elsif rising_edge(clk_p) then

      ---------------------------------------
      -- Set bus flags
      if ilioa = '0' and clk_i_pos = '0' then
        status_sel <= '0';
        cmd_sel    <= '0';
        data_sel   <= '0';

        if idi = ionoc_status_address then
          status_sel <= '1';
        end if;

        if idi = ionoc_cmd_address then
          cmd_sel <= '1';
        end if;

        if idi = ionoc_data_address then
          data_sel <= '1';
        end if;
      --
      end if;  -- ilioa

    end if;  -- clk_p
  end process;

  -------------------------------------------------
  -- This process interfaces the NOC command interface
  noc_cmd_proc : process (clk_p, rst_n)
  begin
    if rst_n = '0' then
      -- Outputs
      GPP_CMD      <= (others => '0');
      GPP_CMD_Flag <= '0';

      -- Process signals
      GPP_CMD_Flag_int <= '0';
      GPP_CMD_ACK_int  <= '0';

      ionoc_rdcmd        <= (others => '0');
      --
      ionoc_cmdindex     <= 0;
      ionoc_wrcmd        <= (others => (others => '0'));
      --
      ionoc_word_pending <= false;
      ionoc_byte_pending <= false;
      innoc_word_isread  <= false;

    elsif rising_edge(clk_p) then

      ------------------------------------------------------------
      -- Handle write index and word pending flag
      if cmd_wr = '0' then
        ionoc_cmdindex <= 0;            -- Reset write index on new cmd access

      elsif cmd_wr = '1' and clk_i_pos = '0' then
        -- IO bus writes to word cache
        ionoc_wrcmd(ionoc_cmdindex) <= idi;
        innoc_word_isread           <= false;
        --
        if ionoc_cmdindex /= (ionoc_wrcmd'length - 1) then
          ionoc_cmdindex     <= ionoc_cmdindex + 1;
          ionoc_word_pending <= false;  -- Reset word present flag when word is updated
        else
          ionoc_word_pending <= true;   -- Done!
        end if;
      end if;

      -- New complete word from IO bus
      if ionoc_word_pending then
        GPP_CMD_Flag_int <= '1';
        GPP_CMD_Flag     <= GPP_CMD_Flag_int;
        for b in ionoc_wrcmd'range loop
          GPP_CMD(8*b+7 downto 8*b) <= ionoc_wrcmd(b);
        end loop;
      end if;

      -- NOC has read the word
      if NOC_CMD_ACK = '1' and ionoc_word_pending then
        -- GPP_CMD_Flag_int = '1' a bit redundant but more resistant against stray ACKs
        GPP_CMD_Flag_int <= '0';
        GPP_CMD_Flag     <= '0';
        --
        ionoc_word_pending <= false;    -- Reset flag when word is processed
        innoc_word_isread  <= true;
      end if;

      ------------------------------------------------------------
      --  Handle incomming command and byte pending flag

      -- IO-bus has read byte
      if cmd_rd = '1' and clk_i_pos = '0' then
        ionoc_byte_pending <= false;
      end if;

      -- NOC has sent cmd
      if NOC_CMD_Flag = '1' and not ionoc_byte_pending then
        -- Store incomming byte
        GPP_CMD_ACK_int    <= '1';
        --
        ionoc_rdcmd        <= NOC_CMD;
        ionoc_byte_pending <= true;
      end if;

      -- NOC has seen the ACK
      if NOC_CMD_Flag = '0' and ionoc_byte_pending then
        GPP_CMD_ACK_int <= '0';
      end if;


    end if;  -- clk_p
  end process;  -- noc_cmd_proc

  -------------------------------------------------
  -- This process interfaces the NOC data interface
  noc_data_proc : process (clk_p, rst_n)
  begin
    if rst_n = '0' then
      -- Outputs
      RxFIFO_Valid         <= '0';
      RxFIFO_Data          <= (others => '0');
      --
      ionoc_datardindex    <= 0;
      ionoc_datawrindex    <= 0;
      ionoc_wrdata         <= (others => (others => '0'));
      ionoc_rddata         <= (others => (others => '0'));
      ionoc_rdbyte         <= (others => '0');
      --
      ionoc_wrdata_pending <= false;
      ionoc_rddata_pending <= false;

    elsif rising_edge(clk_p) then

      ------------------------------------------------------------
      -- Handle write index and wrdata pending flag
      if data_wr = '0' then
        ionoc_datawrindex <= 0;         -- Reset write index on new data access

      elsif data_wr = '1' and clk_i_pos = '0' then
        -- IO bus writes to word cache
        ionoc_wrdata(ionoc_datawrindex) <= idi;
        ionoc_wrdata_pending            <= false;  -- Reset pending flag when word is updated
        --
        if ionoc_datawrindex /= (ionoc_wrdata'length - 1) then
          ionoc_datawrindex    <= ionoc_datawrindex + 1;
        else
          ionoc_datawrindex    <= 0;
          ionoc_wrdata_pending <= true;   -- Done!
        end if;
      end if;

      -- FIFO Interface
      if ionoc_wrdata_pending and RxFIFO_Ready = '0' then
        RxFIFO_Valid <= '1';
        for b in ionoc_wrdata'range loop
          RxFIFO_Data(8*b + 7 downto 8*b) <= ionoc_wrdata(b);
        end loop;
      else
        RxFIFO_Valid <= '0';
      end if;
      --
      if RxFIFO_Ready = '1' and ionoc_wrdata_pending then
        ionoc_wrdata_pending <= false;
      end if;

      ------------------------------------------------------------
      -- Handle read index and rddata pending flag
      --
      ionoc_rdbyte <= ionoc_rddata(ionoc_datardindex);
      ---
      if data_rd = '1' and clk_i_pos = '0' then
        if ionoc_datardindex /= (ionoc_rddata'length - 1) then
          ionoc_datardindex <= ionoc_datardindex + 1;
        else
          ionoc_datardindex    <= 0;
          ionoc_rddata_pending <= false;
        end if;
      end if;

      -- FIFO Interface
      if TxFIFO_Valid = '1' and not ionoc_rddata_pending then
        for b in ionoc_rddata'range loop
          ionoc_rddata(b) <= TxFIFO_Data(8*b + 7 downto 8*b);
        end loop;
        --
        ionoc_datardindex    <= 0;
        ionoc_rddata_pending <= true;
      end if;

    end if;  -- clk_p
  end process;  -- noc_data_proc


end rtl;
