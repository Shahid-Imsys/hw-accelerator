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
-- Title      : I/O signals multiplexer
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : io_mux.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: This block multiplexes the 'idi', 'ido' buses from 'UARTs' and
--              'Ethernet' to 'IOS'. It also selects the external 'idreq'
--              and 'Eth' 'idreq' to 'IOS' as well as 'IOS's 'idack' to 'Eth'.
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		1.4 			CB			Created
-- 2005-12-15		1.5 			CB			Changed xxx_iden signals to active high
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity io_mux is
  port (
    en_eth        : in  std_logic_vector(1 downto 0);
    en_pdi        : in  std_logic;
    -- I/O bus
    ios_iden      : in  std_logic;
    ios_ido       : in  std_logic_vector(7 downto 0);
    uart1_iden    : in  std_logic;
    uart1_ido     : in  std_logic_vector(7 downto 0);
    uart2_iden    : in  std_logic;
    uart2_ido     : in  std_logic_vector(7 downto 0);
    uart3_iden    : in  std_logic;
    uart3_ido     : in  std_logic_vector(7 downto 0);
    eth_iden      : in  std_logic;
    eth_ido       : in  std_logic_vector(7 downto 0);
    pdi_iden      : in  std_logic;
    pdi_ido       : in  std_logic_vector(7 downto 0);
    iden          : out std_logic;
    ido           : out std_logic_vector(7 downto 0);
    -- IDREQ
    idreq         : in  std_logic_vector(7 downto 0);  -- external 'idreq' 
    rx1_idreq     : in  std_logic;                     -- ETH 'idreq'
    rx2_idreq     : in  std_logic;                     -- ETH 'idreq'
    tx_idreq      : in  std_logic;                     -- ETH 'idreq'
    pdi_idreq     : in  std_logic;                     -- PDI 'idreq'
    ios_idreq     : out std_logic_vector(7 downto 0);  -- 'idreq' to 'IOS'
    -- IDACK
    idack         : in  std_logic_vector(7 downto 0);  -- from IOS
    rx1_idack     : out std_logic;                     -- idack to ETH
    rx2_idack     : out std_logic;                     -- idack to ETH
    tx_idack      : out std_logic;                     -- idack to ETH
    pdi_idack     : out std_logic
    );
end io_mux;

architecture rtl of io_mux is
  signal test_vector : std_logic_vector(4 downto 0);
begin  -- rtl
  -- Gate together all iden signals.
  iden <= ios_iden or uart1_iden or uart2_iden or uart3_iden or
  				eth_iden or pdi_iden;
         
  -- Mux out ido, IOS drives when none else does.
  test_vector <= pdi_iden & eth_iden & uart3_iden & uart2_iden & uart1_iden;
  --with std_logic_vector'(pdi_iden, eth_iden, uart3_iden, uart2_iden, uart1_iden)
  with test_vector 
  select ido <= uart1_ido when "00001",
                uart2_ido when "00010",
                uart3_ido when "00100",
                eth_ido   when "01000",
                pdi_ido   when "10000",
                ios_ido   when others;

  -- Mux out 'idreq' to IOS, priority is eth > pdi > external.(?)
  ios_idreq(0) <= idreq(0);
  ios_idreq(1) <= rx1_idreq when en_eth /= "00" else idreq(1);
  ios_idreq(2) <= rx2_idreq when en_eth = "11" else idreq(2);
  ios_idreq(3) <= tx_idreq when en_eth /= "00" else idreq(3);
  ios_idreq(4) <= pdi_idreq when en_pdi = '1' else idreq(4);
  ios_idreq(7 downto 5) <= idreq(7 downto 5);
  -- Mux out 'idack' to ETH and PDI
  rx1_idack <= idack(1) when en_eth /= "00" else '1';
  rx2_idack <= idack(2) when en_eth = "11" else '1';
  tx_idack  <= idack(3) when en_eth /= "00" else '1';
  pdi_idack <= idack(4) when en_pdi = '1' else '1';
  
end rtl;
