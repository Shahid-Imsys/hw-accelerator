-------------------------------------------------------------------------------
--                                                                           --
--   COPYRIGHT (C)                                    IMSYS AB,  2001        --
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
-- Title      : GP processor package
-- Project    : GP2000
-------------------------------------------------------------------------------
-- File       : gp_pkg.vhd
-- Author     : Xing Zhao
-- Company    : Imsys AB
-- Date       : 2001-06-19
-- Platform   : Windows 98
-------------------------------------------------------------------------------
-- Description: This package defines the parameters, constants and types used
--              by GP processor models.
-------------------------------------------------------------------------------
-- TO-DO list :
--              * 
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version   Author   Description
-- 2001-06-19   1.0       XZ       Created
-- 2002-08-28   1.1       CB       Removed constants DBUS_WIDTH, IO_BUS_WIDTH
--                                 and IOMEM_DATA_WIDTH. These were unused and
--                                 are unnecessary since they will never
--                                 change. Added the DMA_CHBITS constant.
-- 2013-01-08   2.0       MN       Added parameters for dual core processor 
-- 2015-06-12   3.0       MN       Memory including 64 kB + 16 kB + 128 kB (flash)          
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package gp_pkg is

  -----------------------------------------------------------------------------
  -- Memory switch types
  -----------------------------------------------------------------------------

  type memory_type_t is (asic, fpga, referens);
  
-----------------------------------------------------------------------------
-- RTC controller commands
-----------------------------------------------------------------------------
  constant RD_RTC_CNT      : std_logic_vector(7 downto 0) := x"10";
                                        -- Read RTC counter
  constant WR_RTC_CNT      : std_logic_vector(7 downto 0) := x"11";
                                        -- Write RTC counter  
  constant STOP_RTC_CMD    : std_logic_vector(7 downto 0) := x"12";
                                        -- Stop a RTC rd/wr command
  constant START_RTC_CLOCK : std_logic_vector(7 downto 0) := x"13";
                                        -- Start/resume RTC clock

  -----------------------------------------------------------------------------
  -- DMA controller commands
  -----------------------------------------------------------------------------
  -- DMA commands have the following formats:
  -------------------------------------------------------------------------
  -- Command        Code    Parameter bytes
  -------------------------------------------------------------------------
  -- SET BASE       0x00    2 (channel, priority + address)
  -- TERMINATE      0x01    0
  -- RESET          0x03    0
  -- SET MODE       0x04    2 (channel, mode) 
  -- GET PTR        0x05    3 (channel, Ptr_hi, Ptr_lo)
  -- RD/WR BUF      0x06    1 (channel)
  -------------------------------------------------------------------------  
  constant SET_DMA_BASE : std_logic_vector(7 downto 0) := x"00";
                                        -- Set address space for DMA buffers
  constant TERMINATE    : std_logic_vector(7 downto 0) := x"01";
                                        -- Terminate a DMA command
  constant RESET_DMA    : std_logic_vector(7 downto 0) := x"03";
                                        -- Reset DMA channels
  constant SET_DMA_MODE : std_logic_vector(7 downto 0) := x"04";
                                        -- Set DMA mode
  constant GET_DMA_DMAP : std_logic_vector(7 downto 0) := x"05";
                                        -- Get channels DMA pointer 
  constant GET_DMA_PIOP : std_logic_vector(7 downto 0) := x"02";
                                        -- Get channels PIO pointer 
  constant RD_WR_BUF    : std_logic_vector(7 downto 0) := x"06";
                                        -- Read/write DMA buffer

  -- DMA parameters
  constant DMA_CHANNELS     : integer := 8;  -- Number of DMA channels
  constant DMA_CHBITS       : integer := 3;  -- Bits needed to enumerate the DMA
                                             -- channels
  constant IOMEM_ADDR_WIDTH : integer := 11;  -- I/O memory address width (5-11)

  --Ethernet registers reserved up to 0x27
  constant Rx_ctl_addr         : std_logic_vector(7 downto 0) := x"20";
  constant Rx_sts_addr         : std_logic_vector(7 downto 0) := x"20";
  constant Rx_da_addr          : std_logic_vector(7 downto 0) := x"21";
  constant Rx_frame_sts_addr   : std_logic_vector(7 downto 0) := x"22";
  constant Tx_ctl_addr         : std_logic_vector(7 downto 0) := x"23";
  constant Tx_sts_addr         : std_logic_vector(7 downto 0) := x"23";
  constant Rx_ctl_addr_2       : std_logic_vector(7 downto 0) := x"24";
  constant Rx_sts_addr_2       : std_logic_vector(7 downto 0) := x"24";
  constant Rx_da_addr_2        : std_logic_vector(7 downto 0) := x"25";
  constant Rx_frame_sts_addr_2 : std_logic_vector(7 downto 0) := x"26";

  --UART 1 (RS232)
  constant com1_reg_address       : std_logic_vector(7 downto 0) := x"28";
  constant com1_prescaler_address : std_logic_vector(7 downto 0) := x"29";
  constant com1_flag_address      : std_logic_vector(7 downto 0) := x"2A";
  constant com1_fx_address        : std_logic_vector(7 downto 0) := x"2B";

  --UART 2 (RS232)
  constant com2_reg_address       : std_logic_vector(7 downto 0) := x"2C";
  constant com2_prescaler_address : std_logic_vector(7 downto 0) := x"2D";
  constant com2_flag_address      : std_logic_vector(7 downto 0) := x"2E";
  constant com2_fx_address        : std_logic_vector(7 downto 0) := x"2F";

  --UART 3 (RS232)
  constant com3_reg_address       : std_logic_vector(7 downto 0) := x"30";
  constant com3_prescaler_address : std_logic_vector(7 downto 0) := x"31";
  constant com3_flag_address      : std_logic_vector(7 downto 0) := x"32";
  constant com3_fx_address        : std_logic_vector(7 downto 0) := x"33";

  --DAC
  constant DAC_CHANNELS : integer := 2;
  constant DAC_HBITS    : integer := 8;
  constant DAC_LBITS    : integer := 8;
  constant DAC_BITS     : integer := DAC_HBITS + DAC_LBITS;
  type dac_data_type is array (0 to DAC_CHANNELS-1) of std_logic_vector(DAC_BITS-1 downto 0);

  --application ram or rom
  --added by maning for dual core processor
  constant MEMNUM     : integer                       := 6;
--    constant ROM0_ADDR0     : std_logic_vector(17 downto 0) :=  "000000000000000000";--16KB
--    constant ROM0_ADDR1     : std_logic_vector(17 downto 0) :=  "000000000000000001";--16KB
--    constant ROM0_ADDR2     : std_logic_vector(17 downto 0) :=  "000000000000000010";--16KB
--    constant ROM0_ADDR3     : std_logic_vector(17 downto 0) :=  "000000000000000011";--16KB     ROM0 total 64 KB
--    constant ROM1_ADDR0     : std_logic_vector(17 downto 0) :=  "000000000000000100";--16KB
--    constant ROM1_ADDR1     : std_logic_vector(17 downto 0) :=  "000000000000000101";--16KB
--    constant ROM1_ADDR2     : std_logic_vector(17 downto 0) :=  "000000000000000110";--16KB
--    constant ROM1_ADDR3     : std_logic_vector(17 downto 0) :=  "000000000000000111";--16KB     ROM1 total 64 KB
--    constant ROM2_ADDR0     : std_logic_vector(17 downto 0) :=  "000000000000001000";--16KB
--    constant ROM2_ADDR1     : std_logic_vector(17 downto 0) :=  "000000000000001001";--16KB
--    constant ROM2_ADDR2     : std_logic_vector(17 downto 0) :=  "000000000000001010";--16KB
--    constant ROM2_ADDR3     : std_logic_vector(17 downto 0) :=  "000000000000001011";--16KB     ROM2 total 64 KB
--    constant ROM3_ADDR0     : std_logic_vector(17 downto 0) :=  "000000000000001100";--16KB
--    constant ROM3_ADDR1     : std_logic_vector(17 downto 0) :=  "000000000000001101";--16KB
--    constant ROM3_ADDR2     : std_logic_vector(17 downto 0) :=  "000000000000001110";--16KB
--    constant ROM3_ADDR3     : std_logic_vector(17 downto 0) :=  "000000000000001111";--16KB     ROM3 total 64 KB
  constant FLSH_ADDR0 : std_logic_vector(17 downto 0) := "000000100000000000";  --16KB     
  constant FLSH_ADDR1 : std_logic_vector(17 downto 0) := "000000100000000001";  --16KB     
  constant FLSH_ADDR2 : std_logic_vector(17 downto 0) := "000000100000000010";  --16KB     
  constant FLSH_ADDR3 : std_logic_vector(17 downto 0) := "000000100000000011";  --16KB     
  constant FLSH_ADDR4 : std_logic_vector(17 downto 0) := "000000100000000100";  --16KB     
  constant FLSH_ADDR5 : std_logic_vector(17 downto 0) := "000000100000000101";  --16KB
  constant FLSH_ADDR6 : std_logic_vector(17 downto 0) := "000000100000000110";  --16KB
  constant FLSH_ADDR7 : std_logic_vector(17 downto 0) := "000000100000000111";  --16KB    Flash total 128 KB 
  constant RAM0_ADDR  : std_logic_vector(17 downto 0) := "000000000000000000";  --16KB    RAM0 16 KB
  constant RAM1_ADDR  : std_logic_vector(17 downto 0) := "000000000000000001";  --16KB    RAM1 16 KB
  constant RAM2_ADDR  : std_logic_vector(17 downto 0) := "000000000000000010";  --16KB    RAM2 16 KB
  constant RAM3_ADDR  : std_logic_vector(17 downto 0) := "000000000000000011";  --16KB    RAM3 16 KB 
  constant RAM4_ADDR  : std_logic_vector(17 downto 0) := "000000000000000100";  --16KB    RAM4 16 KB  

--    constant RAM2_ADDR      : std_logic_vector(17 downto 0) :=  "000000000000000101";--16KB     RAM5 16 KB
--    constant RAM1_ADDR      : std_logic_vector(17 downto 0) :=  "000000000000000110";--16KB     RAM6 16 KB
--    constant RAM0_ADDR      : std_logic_vector(17 downto 0) :=  "000000000000000111";--16KB     RAM7 16 KB
--      constant RAM8_ADDR      : std_logic_vector(17 downto 0) :=  "000000000000011000";--16KB     RAM8 16 KB
--    constant RAM9_ADDR      : std_logic_vector(17 downto 0) :=  "000000000000011001";--16KB     RAM9 16 KB

  type OSPI_InterfaceOut_t is record
    RESET_n : std_logic;
    CK_p    : std_logic;
    CK_n    : std_logic;
    CS_n    : std_logic;
  end record;

--  type OSPI_InterfaceBidir_t is record
--    DQ   : std_logic_vector(7 downto 0);
--    RWDS : std_logic;
--  end record;
  
end gp_pkg;

package body gp_pkg is

end gp_pkg;
