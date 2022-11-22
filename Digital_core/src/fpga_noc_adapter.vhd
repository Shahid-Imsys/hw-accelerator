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
-- Design Name: fpga_noc_adapter
-- Project Name: IM4000
-- Description:
--   Interface/bridge between IO-bus and NOC adapter
--   To be accessed via the IM4000 I/O-bus.
--
-- Revision:
-- Revision 0.01 - File Created
--
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use work.gp_pkg.all;

use ieee.numeric_std.all;

entity fpga_noc_adapter is
  generic (
    ionoc_fifo_depth_bits : integer                      := 4;  -- Each FIFO is 2^x = 16 words deep
    ionoc_status_address  : std_logic_vector(7 downto 0) := x"45";
    ionoc_cmd_address     : std_logic_vector(7 downto 0) := x"46";
    ionoc_data_address    : std_logic_vector(7 downto 0) := x"47";
    ionoc_addr_address    : std_logic_vector(7 downto 0) := x"48";
    ionoc_length_address  : std_logic_vector(7 downto 0) := x"49";
    ionoc_datadir_address : std_logic_vector(7 downto 0) := x"4A");
  port (
    -- Domain clk_p
    ------------------------------------------------------
    clk_p     : in  std_logic;                          -- Main clock
    clk_i_pos : in  std_logic;                          --
    rst_n     : in  std_logic;                          -- Async reset
    -- I/O bus
    idi       : in  std_logic_vector (7 downto 0);      -- I/O bus in
    ido       : out std_logic_vector (7 downto 0);      -- I/O bus out
    iden      : out std_logic;                          -- I/O bus enabled (in use)
    ilioa     : in  std_logic;                          -- I/O bus load I/O address
    ildout    : in  std_logic;                          -- I/O bus data output strobe
    inext     : in  std_logic;                          -- I/O bus data input  strobe
    idack     : in  std_logic;                          -- I/O bus DMA Ack
    idreq     : out std_logic;                          -- I/O bus DMA Request
    NOC_IRQ   : out std_logic;                          -- Interrupt on available data from NOC
    ------------------------------------------------------


    -- Domain clk_noc
    ------------------------------------------------------
    clk_noc : in std_logic;                             -- NOC Clock

    ------ CMD interface -------
    -- GPP CMD to NOC
    GPP_CMD      : out std_logic_vector(127 downto 0);  -- Command word
    GPP_CMD_Flag : out std_logic;                       -- Command word valid
    NOC_CMD_ACK  : in  std_logic;                       -- NOC ready
    -- NOC CMD to GPP
    NOC_CMD_Flag : in  std_logic;                       -- NOC command byte is valid
    NOC_CMD      : in  std_logic_vector(7 downto 0);    -- Command byte
    GPP_CMD_ACK  : out std_logic;                       -- GPP ack of command byte

    ------ DATA interface -------
    NOC_DATA_EN  : in  std_logic;                       -- Enable traffic to (IO_DATA) or from (NOC_DATA) the NOC, dep on NOC_DATA_DIR
    NOC_DATA_DIR : in  std_logic;                       -- Direction of NOC data transfer to/from FIFOs
    NOC_DATA     : in  std_logic_vector(127 downto 0);  -- Data to the TxFIFO
    IO_DATA      : out std_logic_vector(127 downto 0);  -- Data from the RxFIFO
    --
    FIFO_READY   : out std_logic_vector(ionoc_fifo_depth_bits downto 0); -- FIFO level, filled or remaining dep on NOC_DATA_DIR

    ------ IO interface --------
    NOC_ADDRESS   : in  std_logic_vector(31 downto 0);  -- Memory address of NOC data request
    NOC_LENGTH    : in  std_logic_vector(15 downto 0);  -- Length of NOC data request
    NOC_IO_DIR    : in  std_logic;                      -- Direction of NOC data request
    NOC_WRITE_REQ : in  std_logic;                      -- NOC address, length and data direction is valid
    IO_WRITE_ACK  : out std_logic                       -- NOC data parameters have been read and can now be updated
   -------------------------------------------------------
    );
end fpga_noc_adapter;

architecture rtl of fpga_noc_adapter is

  component ionoc is
    generic (
      ionoc_status_address  : std_logic_vector(7 downto 0) := x"45";
      ionoc_cmd_address     : std_logic_vector(7 downto 0) := x"46";
      ionoc_data_address    : std_logic_vector(7 downto 0) := x"47";
      ionoc_addr_address    : std_logic_vector(7 downto 0) := x"48";
      ionoc_length_address  : std_logic_vector(7 downto 0) := x"49";
      ionoc_datadir_address : std_logic_vector(7 downto 0) := x"4A");
    port (
      -- Domain clk_p
      ------------------------------------------------------
      clk_p     : in  std_logic;        -- Main clock
      clk_i_pos : in  std_logic;        --
      rst_n     : in  std_logic;        -- Async reset
      -- I/O bus
      idi       : in  std_logic_vector (7 downto 0);  -- I/O bus in
      ido       : out std_logic_vector (7 downto 0);  -- I/O bus out
      iden      : out std_logic;                      -- I/O bus enabled (in use)
      ilioa     : in  std_logic;                      -- I/O bus load I/O address
      ildout    : in  std_logic;                      -- I/O bus data output strobe
      inext     : in  std_logic;                      -- I/O bus data input strobe
      idack     : in  std_logic;                      -- I/O bus DMA Ack
      idreq     : out std_logic;                      -- I/O bus DMA Request
      NOC_IRQ   : out std_logic;                      -- Interrupt on available data from NOC
      --------------------------------------------------


      -- Domain clk_noc (NOC)
      ------------------------------------------------------
      clk_noc       : in  std_logic;                      -- NOC Clock
      -- GPP CMD to NOC
      GPP_CMD       : out std_logic_vector(127 downto 0); -- Command word
      GPP_CMD_Flag  : out std_logic;                      -- Command word valid
      NOC_CMD_ACK   : in  std_logic;                      -- NOC ready
      -- NOC CMD to GPP
      NOC_CMD_Flag  : in  std_logic;                      -- NOC command byte is valid
      NOC_CMD       : in  std_logic_vector(7 downto 0);   -- Command byte
      GPP_CMD_ACK   : out std_logic;                      -- GPP ack of command byte
      -- NOC Data interface - for NOC request of data trx
      NOC_ADDRESS   : in  std_logic_vector(31 downto 0);  -- Memory address of NOC data request
      NOC_LENGTH    : in  std_logic_vector(15 downto 0);  -- Length of NOC data request
      NOC_DATA_DIR  : in  std_logic;                      -- Direction of NOC data request
      NOC_WRITE_REQ : in  std_logic;                      -- NOC address, length and data direction is valid
      IO_WRITE_ACK  : out std_logic;                      -- NOC data parameters have been read and can now be updated

      -- Domain clk_noc (FIFOS)
      ------------------------------------------------------
      -- NOC TxFIFO, read by IONOC
      TxFIFO_Ready  : out std_logic;                      -- Interface can accept a word from the TxFIFO
      TxFIFO_Valid  : in  std_logic;                      -- TxFIFO has availble data which is presented on bus
      TxFIFO_Data   : in  std_logic_vector(127 downto 0); -- TxFIFO data
      -- NOC RxFIFO, written to by IONOC
      RxFIFO_Ready  : in  std_logic;                      -- RxFIFO can accept a word from the IO-bus
      RxFIFO_Valid  : out std_logic;                      -- Interface has availble data which is presented on bus
      RxFIFO_Data   : out std_logic_vector(127 downto 0)  -- RxFIFO data
      ------------------------------------------------------
      );
  end component;

  component sync_fifo is
    generic (
      WIDTH : integer := 128;           -- Data width in bits
      BITS  : integer := ionoc_fifo_depth_bits);
    port (
      areset_n  : in  std_logic;
      clk       : in  std_logic;
      in_ready  : out std_logic;
      in_valid  : in  std_logic;
      in_data   : in  std_logic_vector(WIDTH-1 downto 0);
      out_ready : in  std_logic;
      out_valid : out std_logic                          := '0';
      out_data  : out std_logic_vector(WIDTH-1 downto 0) := (others => '0');
      level     : out std_logic_vector(BITS downto 0)
      );
  end component;

  -- Valid of FIFO data flow to/from NOC - Defined by NOC_DATA_DIR
  constant NOC_DATA_DIR_RX : std_logic := '0';  -- NOC reads from RxFIFO
  constant NOC_DATA_DIR_TX : std_logic := '1';  -- NOC writes to TxFIFO

  -- Valid of FIFO data flow to/from data FIFOs (on GPP side) - Defined by NOC_IO_DIR
  constant NOC_IO_DIR_RX : std_logic := '0'; -- Data is written to RxFIFO
  constant NOC_IO_DIR_TX : std_logic := '1'; -- Data is read from TxFIFO

  -- Level constants
  constant FIFO_FULL : integer := 2**ionoc_fifo_depth_bits;

  -- NOC TxFIFO, read by IONOC
  signal TxFIFO_Ready     : std_logic;
  signal TxFIFO_Valid     : std_logic;
  signal TxFIFO_Data      : std_logic_vector(127 downto 0);
  signal TxFIFO_Level     : std_logic_vector(ionoc_fifo_depth_bits downto 0);
  signal TxFIFO_Level_int : integer range 0 to 2**ionoc_fifo_depth_bits := 0;

  -- NOC RxFIFO, written to by IONOC
  signal RxFIFO_Ready : std_logic;
  signal RxFIFO_Valid : std_logic;
  signal RxFIFO_Data  : std_logic_vector(127 downto 0);
  signal RxFIFO_Level : std_logic_vector(ionoc_fifo_depth_bits downto 0);

  -- TxFIFO logic
  signal NOC_DATA_Valid : std_logic;

  -- RxFIFO logic
  -- signal IO_DATA_Valid : std_logic;
  signal IO_DATA_Ready : std_logic;

  attribute mark_debug : string;
  attribute mark_debug of TxFIFO_Data: signal is "true"; 
  attribute mark_debug of RxFIFO_Data: signal is "true";

  
begin

  -- NOC interface
  FIFO_READY       <= RxFIFO_Level when NOC_DATA_DIR = NOC_DATA_DIR_RX else
                      std_logic_vector(to_unsigned(TxFIFO_Level_int, FIFO_READY'length));
  TxFIFO_Level_int <= (FIFO_FULL - to_integer(unsigned(TxFIFO_Level))) ;

  -- Tx FIFO ( NOC --> FIFO --> GPP )
  NOC_DATA_Valid <= NOC_DATA_EN when NOC_DATA_DIR = NOC_DATA_DIR_TX else '0';

  tx_fifo_inst : sync_fifo
    port map(
      areset_n  => rst_n,
      clk       => clk_noc,
      in_ready  => open,
      in_valid  => NOC_DATA_Valid,
      in_data   => NOC_DATA,
      out_ready => TxFIFO_Ready,
      out_valid => TxFIFO_Valid,
      out_data  => TxFIFO_Data,
      level     => TxFIFO_Level
      );

  -- Rx FIFO ( GPP --> FIFO --> NOC )
  IO_DATA_Ready <= NOC_DATA_EN when NOC_DATA_DIR = NOC_DATA_DIR_RX else '0';

  rx_fifo_inst : sync_fifo
    port map(
      areset_n  => rst_n,
      clk       => clk_noc,
      in_ready  => RxFIFO_Ready,
      in_valid  => RxFIFO_Valid,
      in_data   => RxFIFO_Data,
      out_ready => IO_DATA_Ready,
      out_valid => open, -- IO_DATA_Valid, NOC does not read this. If level > 0, data is valid
      out_data  => IO_DATA,
      level     => RxFIFO_Level
      );

  -- Adapter logic
  noc_adapter : ionoc
    generic map (
      ionoc_status_address  => ionoc_status_address,
      ionoc_cmd_address     => ionoc_cmd_address,
      ionoc_data_address    => ionoc_data_address,
      ionoc_addr_address    => ionoc_addr_address,
      ionoc_length_address  => ionoc_length_address,
      ionoc_datadir_address => ionoc_datadir_address)
    port map (
      clk_p         => clk_p,
      clk_i_pos     => clk_i_pos,
      rst_n         => rst_n,
      idi           => idi,
      ido           => ido,
      iden          => iden,
      ilioa         => ilioa,
      ildout        => ildout,
      inext         => inext,
      idack         => idack,
      idreq         => idreq,
      NOC_IRQ       => NOC_IRQ,
      --
      clk_noc       => clk_noc,
      GPP_CMD       => GPP_CMD,
      GPP_CMD_Flag  => GPP_CMD_Flag,
      NOC_CMD_ACK   => NOC_CMD_ACK,
      NOC_CMD       => NOC_CMD,
      GPP_CMD_ACK   => GPP_CMD_ACK,
      NOC_CMD_Flag  => NOC_CMD_Flag,
      TxFIFO_Ready  => TxFIFO_Ready,
      TxFIFO_Valid  => TxFIFO_Valid,
      TxFIFO_Data   => TxFIFO_Data,
      RxFIFO_Ready  => RxFIFO_Ready,
      RxFIFO_Valid  => RxFIFO_Valid,
      RxFIFO_Data   => RxFIFO_Data,
      NOC_ADDRESS   => NOC_ADDRESS,
      NOC_LENGTH    => NOC_LENGTH,
      NOC_DATA_DIR  => NOC_DATA_DIR,
      NOC_WRITE_REQ => NOC_WRITE_REQ,
      IO_WRITE_ACK  => IO_WRITE_ACK
      );


end rtl;
