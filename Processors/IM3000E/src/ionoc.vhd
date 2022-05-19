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
    ionoc_data_address   : std_logic_vector(7 downto 0) := x"46";
    MAX_BURST_LEN        : integer                      := 2  -- Must be even power of 2
    );
  port (clk_p        : in  std_logic;   -- Main clock
        clk_i_pos    : in  std_logic;   --
        rst_n        : in  std_logic;   -- Async reset
        -- I/O bus
        idi          : in  std_logic_vector (7 downto 0);   -- I/O bus in
        ido          : out std_logic_vector (7 downto 0);   -- I/O bus out
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
        NOC_CMD      : in  std_logic_vector(7 downto 0);   -- Command byte
        GPP_CMD_ACK  : out std_logic;                      -- GPP ready
        NOC_CMD_Flag : in  std_logic;                      -- NOC asks to send byte
        NOC_CMD_EN   : in  std_logic;                      -- Command byte valid
        --
        TxFIFO_Ready : out std_logic;                      -- Interface can accept a word from the TxIFO
        TxFIFO_Valid : in  std_logic;                      -- TxFIFO has availble data which is presented on bus
        TxFIFO_Data  : in  std_logic_vector(127 downto 0); -- TxFIFO data
        --
        RxFIFO_Ready : in  std_logic;                      -- RxFIFO can accept a word from the IO-bus
        RxFIFO_Valid : out std_logic;                      -- Interface has availble data which is presented on bus
        RxFIFO_Data  : out std_logic_vector(127 downto 0); -- RxFIFO data
        --
        NOC_IRQ      : out std_logic                       -- Interrupt on available data from NOC
        );
end ionoc;

architecture rtl of ionoc is

  subtype ionoc_cache_index_t is integer range 0 to 15;
  type ionoc_cache_t is array(0 to 15) of std_logic_vector(7 downto 0);

  -- I/O-bus interface
  signal status_wr : std_logic;           -- Status write strobe
  signal status_rd : std_logic;           -- Status read strobe
  signal data_wr   : std_logic;           -- Data write strobe
  signal data_rd   : std_logic;           -- Data read strobe
  -- Other concurrent signals
  signal ionoc_rdstatus : std_logic_vector(7 downto 0);

  ---------------------------------------------------------
  -- iobus_proc
  signal status_sel         : std_logic;  -- Status access selected
  signal data_sel           : std_logic;  -- Data access selected
  --
  signal ionoc_wrindex      : ionoc_cache_index_t;
  signal ionoc_wrdata       : ionoc_cache_t;
  --
  signal ionoc_word_pending : boolean;  -- IO bus has issued word which is yet to be read by NOC
  signal ionoc_byte_pending : boolean;  -- NOC has issued byte which is yet to be read by IO bus
  signal innoc_word_isread  : boolean;  -- NOC has read word presented

  ---------------------------------------------------------
  -- noc_proc
  signal GPP_CMD_Flag_int : std_logic;
  --
  signal ionoc_rddata   : std_logic_vector(7 downto 0);

begin

-- Concurrent statements
  GPP_CMD_Flag <= GPP_CMD_Flag_int;

-- Interrupt in data available
  NOC_IRQ <= ionoc_rdstatus(1);

-- Status output
  ionoc_rdstatus(0)          <= '1' when ionoc_word_pending else
      '0'; -- Word is presented to but not yet read by NOC
  ionoc_rdstatus(1)          <= '1' when ionoc_byte_pending else
      '0'; -- Byte is recieved from NOC, but not read by IO-bus
  ionoc_rdstatus(2)          <= '1' when innoc_word_isread else
      '0'; -- Word is read by NOC
  ionoc_rdstatus(7 downto 3) <= (others => '0');

-- DMA
  idreq <= '1'; -- Active low

-- I/O bus concurrent statements
  ido  <= ionoc_rdstatus when status_sel = '1' else ionoc_rddata;
  iden <= not inext and (status_sel or data_sel); -- inext is active low
--
  status_wr <= '1' when status_sel = '1' and ildout = '0' else '0';
  data_wr   <= '1' when data_sel   = '1' and ildout = '0' else '0';
--
  status_rd <= '1' when status_sel = '1' and inext = '0' else '0';
  data_rd   <= '1' when data_sel   = '1' and inext = '0' else '0';

  -------------------------------------------------
  -- This process decodes I/O addresses and interfaces the IO-bus
  iobus_proc : process (clk_p, rst_n)
  begin
    if rst_n = '0' then
      status_sel         <= '0';
      data_sel           <= '0';
      --
      ionoc_wrindex      <= 0;
      ionoc_wrdata       <= (others => (others => '0'));
      --
      ionoc_word_pending <= false;
      ionoc_byte_pending <= false;
      innoc_word_isread  <= false;

    elsif rising_edge(clk_p) then

      if NOC_CMD_ACK = '1' then
        ionoc_word_pending <= false;    -- Reset flag when word is processed
        innoc_word_isread  <= true;
      end if;
      --

      -- IO bus writes to word cache
      if data_wr = '1' and clk_i_pos = '0' then
        ionoc_wrdata(ionoc_wrindex) <= idi;
        innoc_word_isread           <= false;
        --
        if ionoc_wrindex /= (ionoc_wrdata'length - 1) then
          ionoc_wrindex <= ionoc_wrindex + 1;
        else
          ionoc_word_pending <= true;
        end if;
      end if;

      -- NOC has sent byte
      if NOC_CMD_EN = '1' and not ionoc_byte_pending then
        ionoc_byte_pending <= true;
      end if;

      -- IO-bus has read byte
      if data_rd = '1' and clk_i_pos = '0' then
        ionoc_byte_pending <= false;
      end if;

      ---------------------------------------
      -- Set bus flags
      if ilioa = '0' and clk_i_pos = '0' then
        status_sel  <= '0';
        data_sel    <= '0';

        if idi = ionoc_status_address then
          status_sel <= '1';
        end if;

        if idi = ionoc_data_address then
          data_sel           <= '1';
          --
          ionoc_wrindex      <= 0;     -- Reset write address on new data access
          ionoc_word_pending <= false; -- Reset word present flag
        end if;
      --
      end if;  -- ilioa

    end if;  -- clk_p
  end process;

  -------------------------------------------------
  -- This process interfaces the NOC
  noc_proc : process (clk_p, rst_n)
  begin
    if rst_n = '0' then
      -- Outputs
      GPP_CMD          <= (others => '0');
      GPP_CMD_ACK      <= '0';

      -- Process signals
      GPP_CMD_Flag_int <= '0';
      ionoc_rddata     <= (others => '0');

    elsif rising_edge(clk_p) then

      -- Defaults
      GPP_CMD_ACK <= '0';

      -- New complete word from IO bus
      if ionoc_word_pending then
        GPP_CMD_Flag_int <= '1';
        for b in ionoc_wrdata'range loop
          GPP_CMD(8*b+7 downto 8*b) <= ionoc_wrdata(b);
        end loop;
      end if;

      -- NOC has read the word
      if GPP_CMD_Flag_int = '1' and NOC_CMD_ACK = '1' then
        -- GPP_CMD_Flag_int = '1' a bit redundant but more resistant against stray ACKs
        GPP_CMD_Flag_int <= '0';
      end if;

      -- NOC has command byte available
      if NOC_CMD_Flag = '1' and not ionoc_byte_pending then
        GPP_CMD_ACK <= '1';
      end if;

      -- NOC has sent data
      if NOC_CMD_EN = '1' and not ionoc_byte_pending then
        -- Store incomming byte
        ionoc_rddata <= NOC_CMD;
      end if;

    end if;  -- clk_p
  end process;


end rtl;
