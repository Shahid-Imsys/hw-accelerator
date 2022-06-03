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
  port (-- Domain clk_p
        ------------------------------------------------------
        clk_p        : in  std_logic;   -- Main clock
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
        NOC_IRQ      : out std_logic;   -- Interrupt on available data from NOC
        ------------------------------------------------------


        -- Domain clk_noc
        ------------------------------------------------------
        clk_noc      : in  std_logic;                      -- NOC Clock
        -- GPP to NOC
        GPP_CMD      : out std_logic_vector(127 downto 0); -- Command word
        GPP_CMD_Flag : out std_logic;                      -- Command word valid
        NOC_CMD_ACK  : in  std_logic;                      -- NOC ready
        -- NOC to GPP
        NOC_CMD_Flag : in  std_logic;                      -- NOC command byte is valid
        NOC_CMD      : in  std_logic_vector(7 downto 0);   -- Command byte
        GPP_CMD_ACK  : out std_logic;                      -- GPP ack of command byte
        --
        TxFIFO_Ready : out std_logic;                      -- Interface can accept a word from the TxIFO
        TxFIFO_Valid : in  std_logic;                      -- TxFIFO has availble data which is presented on bus
        TxFIFO_Data  : in  std_logic_vector(127 downto 0); -- TxFIFO data
        --
        RxFIFO_Ready : in  std_logic;                      -- RxFIFO can accept a word from the IO-bus
        RxFIFO_Valid : out std_logic;                      -- Interface has availble data which is presented on bus
        RxFIFO_Data  : out std_logic_vector(127 downto 0)  -- RxFIFO data
        ------------------------------------------------------
        );
end ionoc;

architecture rtl of ionoc is

  subtype ionoc_cache_index_t is integer range 0 to 15;
  type ionoc_cache_t is array(0 to 15) of std_logic_vector(7 downto 0);

  -- I/O-bus interface (clk_p)
  signal status_wr      : std_logic;    -- Status write strobe
  signal status_rd      : std_logic;    -- Status read strobe
  signal cmd_wr         : std_logic;    -- Cmd write strobe
  signal cmd_rd         : std_logic;    -- Cmd read strobe
  signal data_wr        : std_logic;    -- Data write strobe
  signal data_rd        : std_logic;    -- Data read strobe
  -- Other concurrent signals
  signal ionoc_rdstatus : std_logic_vector(7 downto 0); -- Status word for IO bus read

  ---------------------------------------------------------
  -- iobus_proc (clk_p)
  signal status_sel : std_logic;        -- Status access selected
  signal cmd_sel    : std_logic;        -- Cmd access selected
  signal data_sel   : std_logic;        -- Data access selected

  ---------------------------------------------------------
  -- gpp_proc (clk_p)
  -- From NOC to GPP
  signal ionoc_rdcmd        : std_logic_vector(7 downto 0); -- Incomming command byte from NOC
  -- From GPP to NOC
  signal ionoc_cmdindex     : ionoc_cache_index_t; -- Index of byte in word
  signal ionoc_wrcmd        : ionoc_cache_t;       -- Outgoing command word from GPP
  -- Flags to status byte
  signal ionoc_byte_pending : boolean;  -- NOC has issued byte which is yet to be read by IO bus
  signal ionoc_word_pending : boolean;  -- IO bus has issued word which is yet to be read by NOC
  signal innoc_word_isread  : boolean;  -- NOC has read word presented
  --
  signal ionoc_rdcmd_pending_gpp : std_logic; -- Flag from clk_noc domain
  signal ionoc_wrcmd_pending_gpp : std_logic; -- Flag to clk_noc domain

  ---------------------------------------------------------
  -- noc_proc (clk_noc)
  --
  -- GPP CMD to NOC
  signal GPP_CMD_Flag_int   : std_logic;
  --
  signal ionoc_wrcmd_pending_noc : std_logic;

  -- NOC CMD to GPP
  signal GPP_CMD_ACK_int : std_logic; -- Internal copy for reading
  --
  signal ionoc_rdcmd_noc         : std_logic_vector(7 downto 0);
  signal ionoc_rdcmd_pending_noc : std_logic;

  -- GPP Data to RxFIFO
  signal RxFIFO_Valid_int : std_logic; -- Delay RxFIFO_Valid 1 cc
  --
  signal ionoc_rxfifo_valid_f : std_logic;

  -- TxFIFO Data to GPP
  signal ionoc_txfifo_valid_f : std_logic;
  signal ionoc_rddata_noc     : ionoc_cache_t; -- Local fifo data cache
  --

  ---------------------------------------------------------
  -- noc_data_proc (clk_p)
  signal ionoc_datawrindex    : ionoc_cache_index_t;
  signal ionoc_datardindex    : ionoc_cache_index_t;
  signal ionoc_wrdata         : ionoc_cache_t;
  signal ionoc_rdbyte         : std_logic_vector(7 downto 0);
  --
  signal ionoc_wrdata_pending : boolean;
  signal ionoc_rddata_pending : boolean;

begin

------------------------------------------------------
-- clk_p concurrent statements
------------------------------------------------------


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
                       '0';             -- There is written data not read by RxFIFO
  ionoc_rdstatus(7) <= '1' when ionoc_rddata_pending else
                       '0';             -- There is data read from TxFIFO available

-- DMA
  idreq <= '1';                         -- Active low

-- I/O bus concurrent statements
  ido <= ionoc_rdcmd when cmd_sel = '1' else
         ionoc_rdbyte when data_sel = '1' else
         ionoc_rdstatus;                -- when status_sel = '1' else
  iden <= not inext and (status_sel or cmd_sel or data_sel);  -- inext is active low
--
  status_wr <= '1' when status_sel = '1' and ildout = '0' else '0';
  cmd_wr    <= '1' when cmd_sel    = '1' and ildout = '0' else '0';
  data_wr   <= '1' when data_sel   = '1' and ildout = '0' else '0';
--
  status_rd <= '1' when status_sel = '1' and inext = '0' else '0';
  cmd_rd    <= '1' when cmd_sel    = '1' and inext = '0' else '0';
  data_rd   <= '1' when data_sel   = '1' and inext = '0' else '0';

------------------------------------------------------
-- clk_noc concurrent statements
------------------------------------------------------
  GPP_CMD_ACK  <= GPP_CMD_ACK_int;
------------------------------------------------------


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

        if idi = ionoc_cmd_address and
           not ionoc_word_pending then -- Stall new write until the NOC has read the previous command
          cmd_sel <= '1';
        end if;

        if idi = ionoc_data_address and
           not ionoc_wrdata_pending then -- Stall new write until FIFO has read the previous
          data_sel <= '1';
        end if;
      --
      end if;  -- ilioa

    end if;  -- clk_p
  end process;

  -------------------------------------------------
  -- This process interfaces the GPP command interface
  gpp_proc : process (clk_p, rst_n)
  begin
    if rst_n = '0' then
      ionoc_rdcmd        <= (others => '0');
      --
      ionoc_cmdindex     <= 0;
      ionoc_wrcmd        <= (others => (others => '0'));
      --
      ionoc_byte_pending <= false;
      ionoc_word_pending <= false;
      innoc_word_isread  <= false;
      --
      ionoc_rdcmd_pending_gpp <= '0';
      ionoc_wrcmd_pending_gpp <= '0';

    elsif rising_edge(clk_p) then

      ------------------------------------------------------------


      ------------------------------------------------------------
      -- Handle outgoing GPP CMD word and
      -- its write index
      --
      if cmd_wr = '0' then
        ionoc_cmdindex <= 0;            -- Reset write index on new cmd access

      elsif cmd_wr = '1' and clk_i_pos = '0' then
        -- IO bus writes to word cache
        ionoc_wrcmd(ionoc_cmdindex) <= idi;
        innoc_word_isread           <= false;
        --
        if ionoc_cmdindex /= (ionoc_wrcmd'length - 1) then
          ionoc_cmdindex <= ionoc_cmdindex + 1;
        else
          ionoc_word_pending <= true;   -- Done!
        end if;
      end if;
      --
      -- Flags to clk_noc domain
      if ionoc_word_pending then
        if ionoc_wrcmd_pending_noc = '1' then
          innoc_word_isread       <= true;
          ionoc_word_pending      <= false;
          ionoc_wrcmd_pending_gpp <= '0';
        else
          ionoc_wrcmd_pending_gpp <= '1';
        end if;
      end if;

      ------------------------------------------------------------
      --  Handle incomming NOC CMD byte
      --
      -- IO-bus has read byte
      if cmd_rd = '1' and clk_i_pos = '0' then
        ionoc_byte_pending <= false;
      end if;
      -- NOC has sent a byte
      if ionoc_rdcmd_pending_noc = '1' and
         ionoc_rdcmd_pending_gpp = '0' then
        -- Copy the byte
        ionoc_rdcmd             <= ionoc_rdcmd_noc;
        ionoc_rdcmd_pending_gpp <= '1';
        ionoc_byte_pending      <= true;
      end if;
      -- NOC interface is done
      -- Accept new data when GPP is also done
      if ionoc_rdcmd_pending_noc = '0' and
         ionoc_rdcmd_pending_gpp = '1' and
         not ionoc_byte_pending then
        ionoc_rdcmd_pending_gpp <= '0';
      end if;

    end if;  -- clk_p
  end process;  -- gpp_proc

  -------------------------------------------------
  -- This process interfaces the NOC
  noc_proc : process (clk_noc, rst_n)
  begin
    -- reuse clk_p reset as async reset
    if rst_n = '0' then
      -- Outputs
      GPP_CMD      <= (others => '0');
      GPP_CMD_Flag <= '0';
      --
      RxFIFO_Data  <= (others => '0');
      RxFIFO_Valid <= '0';
      TxFIFO_Ready <= '0';

      -- Process signals
      GPP_CMD_Flag_int        <= '0';
      ionoc_wrcmd_pending_noc <= '0';
      --
      GPP_CMD_ACK_int         <= '0';
      ionoc_rdcmd_noc         <= (others => '0');
      ionoc_rdcmd_pending_noc <= '0';
      --
      RxFIFO_Valid_int     <= '0';
      ionoc_rxfifo_valid_f <= '0';
      --
      ionoc_txfifo_valid_f <= '0';
      ionoc_rddata_noc     <= (others => (others => '0'));

    elsif rising_edge(clk_noc) then

      ------------------------------------------------------------
      --  Handle outgoing command word
      --

      -- GPP has sent comand, copy data to output
      if ionoc_wrcmd_pending_gpp = '1' then
        GPP_CMD_Flag_int <= '1';
        --
        for b in ionoc_wrcmd'range loop
          GPP_CMD(8*b+7 downto 8*b) <= ionoc_wrcmd(b);
        end loop;
      end if;
      --
      if ionoc_wrcmd_pending_gpp = '1' and
         ionoc_wrcmd_pending_noc = '0' and
         GPP_CMD_Flag_int = '1' then
        GPP_CMD_Flag <= '1';
      end if;

      -- NOC has read the word, lower the flag
      if NOC_CMD_ACK = '1' and
         GPP_CMD_Flag_int = '1' then
        GPP_CMD_Flag            <= '0';
        GPP_CMD_Flag_int        <= '0';
        ionoc_wrcmd_pending_noc <= '1';
      end if;

      -- GPP is done
      if ionoc_wrcmd_pending_noc = '1' and
         ionoc_wrcmd_pending_gpp = '0' then
        ionoc_wrcmd_pending_noc <= '0';
      end if;


      ------------------------------------------------------------
      --  Handle incomming command byte
      --

      -- NOC has sent cmd
      if NOC_CMD_Flag = '1' and
         ionoc_rdcmd_pending_noc = '0' then
        -- Store incomming byte
        GPP_CMD_ACK_int    <= '1';
        --
        ionoc_rdcmd_noc        <= NOC_CMD;
        ionoc_rdcmd_pending_noc <= '1';
      end if;

      if ionoc_rdcmd_pending_gpp = '1' and
         ionoc_rdcmd_pending_noc = '1' then
        ionoc_rdcmd_pending_noc <= '0';
      end if;

      -- NOC has seen the ACK (no check, 1 cc is required to be enough)
      if GPP_CMD_ACK_int = '1' then
        GPP_CMD_ACK_int <= '0';
      end if;

      ------------------------------------------------------------
      -- RxFIFO Interface
      --

      -- GPP has data collected from IO-bus, copy to output
      if ionoc_rxfifo_valid_f = '0' and
         ionoc_wrdata_pending then
        RxFIFO_Valid_int     <= '1';
        --
        for b in ionoc_wrdata'range loop
          RxFIFO_Data(8*b + 7 downto 8*b) <= ionoc_wrdata(b);
        end loop;
      end if;
      --
      if RxFIFO_Valid_int = '1' then
        RxFIFO_Valid <= '1';
      end if;
      --
      if ionoc_rxfifo_valid_f = '1' and
         not ionoc_wrdata_pending then
        ionoc_rxfifo_valid_f <= '0';
      end if;
      --
      if RxFIFO_Ready = '1' and
         RxFIFO_Valid_int = '1' then
        RxFIFO_Valid_int     <= '0';
        RxFIFO_Valid         <= '0';
        ionoc_rxfifo_valid_f <= '1';
      end if;

      ------------------------------------------------------------
      -- TxFIFO Interface
      --

      -- TxFIFO is offering data, make copy
      if TxFIFO_Valid = '1' and
         ionoc_txfifo_valid_f = '0' then
        ionoc_txfifo_valid_f <= '1';
        TxFIFO_Ready         <= '0'; -- Do not allow more data from TxFIFO
        --
        for b in ionoc_rddata_noc'range loop
          ionoc_rddata_noc(b) <= TxFIFO_Data(8*b + 7 downto 8*b);
        end loop;
      end if;
      --
      if ionoc_txfifo_valid_f = '1' and
         ionoc_rddata_pending then
        -- Data presented to IO-bus interface
        ionoc_txfifo_valid_f <= '0';
      end if;
      --
      if ionoc_txfifo_valid_f = '0' and
         not ionoc_rddata_pending then
        -- Data is cumsumed, prepare for next word
        TxFIFO_Ready <= '1';
      end if;

    end if;  -- clk_noc
  end process;  -- noc_proc

  -------------------------------------------------
  -- This process interfaces the NOC data (FIFO) interface
  noc_data_proc : process (clk_p, rst_n)
  begin
    if rst_n = '0' then
      -- Outputs
      ionoc_datardindex    <= 0;
      ionoc_datawrindex    <= 0;
      ionoc_wrdata         <= (others => (others => '0'));
      ionoc_rdbyte         <= (others => '0');
      --
      ionoc_wrdata_pending <= false;
      ionoc_rddata_pending <= false;

    elsif rising_edge(clk_p) then

      ------------------------------------------------------------
      -- Handle write index and wrdata pending flag
      --
      if data_wr = '0' or ionoc_rxfifo_valid_f = '1' then
        ionoc_datawrindex <= 0; -- Reset write index on new data access

      elsif data_wr = '1' and clk_i_pos = '0' then
        -- IO bus writes to word cache
        ionoc_wrdata(ionoc_datawrindex) <= idi;
         -- Reset pending flag when word is updated
        ionoc_wrdata_pending            <= false;
        --
        if ionoc_datawrindex /= (ionoc_wrdata'length - 1) then
          ionoc_datawrindex    <= ionoc_datawrindex + 1;
        else
          ionoc_datawrindex    <= 0;
          ionoc_wrdata_pending <= true;   -- Done!
        end if;
      end if;

      -- FIFO Interface
      if ionoc_rxfifo_valid_f = '1' and
         ionoc_wrdata_pending then
        ionoc_wrdata_pending <= false;
      end if;

      ------------------------------------------------------------
      -- Handle read index and rddata pending flag
      --
      ionoc_rdbyte <= ionoc_rddata_noc(ionoc_datardindex);
      ---
      if data_rd = '1' and clk_i_pos = '0' then
        if ionoc_datardindex /= (ionoc_rddata_noc'length - 1) then
          ionoc_datardindex <= ionoc_datardindex + 1;
        else
          ionoc_datardindex    <= 0;
          ionoc_rddata_pending <= false;
        end if;
      end if;

      -- FIFO Interface
      if ionoc_txfifo_valid_f = '1' and
         not ionoc_rddata_pending then
        ionoc_datardindex    <= 0;
        ionoc_rddata_pending <= true;
        --
      end if;

    end if;  -- clk_p
  end process;  -- noc_data_proc


end rtl;
