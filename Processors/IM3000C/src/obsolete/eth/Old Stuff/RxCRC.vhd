-------------------------------------------------------------------------------
--                                                                           --
--   COPYRIGHT (C)                                    IMSYS AB,  2000        --
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
-- Title      : Ethernet Rx CRC checker
-- Project    : Ethernet MAC
-------------------------------------------------------------------------------
-- File       : RxCRC.vhd
-- Author     : Xing Zhao
-- Company    : Imsys AB
-- Date       : 2000/09/14
-- Platform   : Windows 98
-------------------------------------------------------------------------------
-- Description:  This module does an 4-bit parallel CRC checker.
-- The polynomial is that specified for IEEE 802.3 (ethernet) LANs and other
-- standards. The polynomial computed is:
-- P(x)=X**32+X**26+X**23+X**22+X**16+X**12+X**11 +X**10+X**8+X**7+X**5+X**4+
--      X**2+X+1.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author       Description
-- 2000/09/14  1.0      Xing Zhao	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity RxCRC is
  
  port (
    clk_rx   : in  std_logic;
    start_rx_logic : in  std_logic;
    clear_rx_logic  : in  std_logic;
    rxd     : in  std_logic_vector(3 downto 0);
    crc_ok : out std_logic);

end RxCRC;

architecture rtl of RxCRC is
	signal rxc : std_logic_vector(31 downto 0);  -- 32 bits CRC registers
	signal rxx : std_logic_vector(3 downto 0);
	constant CRC_REMAINDER : std_logic_vector(31 DOWNTO 0) := x"C704DD7B";

begin  -- rtl
	-- XOR the input data with the top nibble of the current CRC.
	rxx <= (rxc(28) xor rxd(3)) & (rxc(29) xor rxd(2)) & (rxc(30) xor rxd(1)) & (rxc(31) xor rxd(0));

	-- Generate CRC.
	process (clk_rx, clear_rx_logic)
	begin
		if clear_rx_logic = '1' then  
			rxc <= (others => '1');
		elsif rising_edge(clk_rx) then
			if start_rx_logic = '1' then
				rxc <=	rxc(27) &
								rxc(26) &
								(rxc(25) xor rxx(0)) &
								(rxc(24) xor rxx(1)) &
								(rxc(23) xor rxx(2)) &
								(rxc(22) xor rxx(3) xor rxx(0)) &
								(rxc(21) xor rxx(1) xor rxx(0)) &
								(rxc(20) xor rxx(2) xor rxx(1)) &
								(rxc(19) xor rxx(3) xor rxx(2)) &
								(rxc(18) xor rxx(3)) &
								rxc(17) &
								rxc(16) &
								(rxc(15) xor rxx(0)) &             
								(rxc(14) xor rxx(1)) &
								(rxc(13) xor rxx(2)) &
								(rxc(12) xor rxx(3)) &
								(rxc(11) xor rxx(0)) &
								(rxc(10) xor rxx(1) xor rxx(0)) &
								(rxc(9) xor rxx(2) xor rxx(1) xor rxx(0)) &
								(rxc(8) xor rxx(3) xor rxx(2) xor rxx(1)) &
								(rxc(7) xor rxx(3) xor rxx(2) xor rxx(0)) &
								(rxc(6) xor rxx(3) xor rxx(1) xor rxx(0)) &
								(rxc(5) xor rxx(2) xor rxx(1)) &
								(rxc(4) xor rxx(3) xor rxx(2) xor rxx(0)) &
								(rxc(3) xor rxx(3) xor rxx(1) xor rxx(0)) &
								(rxc(2) xor rxx(2) xor rxx(1)) &
								(rxc(1) xor rxx(3) xor rxx(2) xor rxx(0)) &
								(rxc(0) xor rxx(3) xor rxx(1) xor rxx(0)) &
								(rxx(2) xor rxx(1) xor rxx(0)) &
								(rxx(3) xor rxx(2) xor rxx(1)) &
								(rxx(3) xor rxx(2)) &
								rxx(3);
			end if;
		end if;
	end process;

	-- Check generated CRC, should be OK when incoming CRC processed.
	crc_ok <= '1' when rxc = CRC_REMAINDER else '0';
  
end rtl;
