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
-- Title      : Ethernet Tx CRC generator
-- Project    : Ethernet MAC
-------------------------------------------------------------------------------
-- File       : TxCRC.vhd
-- Author     : Xing Zhao
-- Company    : Imsys AB
-- Date       : 2000/09/19
-- Platform   : Windows 98
-------------------------------------------------------------------------------
-- Description:  This module does an 4-bit parallel CRC generator.
-- The polynomial is that specified for IEEE 802.3 (ethernet) LANs and other
-- standards. The polynomial computed is:
-- P(x)=X**32+X**26+X**23+X**22+X**16+X**12+X**11 +X**10+X**8+X**7+X**5+X**4+
--      X**2+X+1.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author       Description
-- 2000/09/19  1.0      Xing Zhao	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TxCRC is
  
  port (
    clk_tx        : in  std_logic;
    crc_gen    : in  std_logic;
    preamble_8 : in  std_logic;
    preamble_5 : in  std_logic;
    crc_data          : in  std_logic_vector(3 downto 0);
    crc_out     : out std_logic_vector(31 downto 28));

end TxCRC;

architecture rtl of TxCRC is
  signal txc : std_logic_vector(31 downto 0) := (others => '1'); -- 32 bits CRC
                                                               -- registers 
  signal txx : std_logic_vector(3 downto 0);
  signal xd012, xd123, xd013, xd023 : std_logic;

begin  -- rtl

	-- XOR the input data with the top nibble of the current CRC.
	txx <= (txc(28) xor crc_data(3)) & (txc(29) xor crc_data(2)) & (txc(30) xor crc_data(1)) & (txc(31) xor crc_data(0));

	-- Often used XOR subexpressions.
	xd012 <= txx(0) xor txx(1) xor txx(2);
	xd123 <= txx(1) xor txx(2) xor txx(3);
	xd013 <= txx(0) xor txx(1) xor txx(3);
	xd023 <= txx(0) xor txx(2) xor txx(3);
  
	process (clk_tx)
	begin
		if rising_edge(clk_tx) then
			if crc_gen = '0' then       -- After 8 clocks initialized to x"FFFFFFFF"
				txc(3 downto 0) <= (others => '1');
				txc(7 downto 4) <= txc(3 downto 0);
				txc(11 downto 8) <= txc(7 downto 4);
				txc(15 downto 12) <= txc(11 downto 8);
				txc(19 downto 16) <= txc(15 downto 12);
				txc(23 downto 20) <= txc(19 downto 16);
				txc(27 downto 24) <= txc(23 downto 20);
				txc(31 downto 28) <= txc(27 downto 24);
			else  
				txc <=	txc(27) &
								txc(26) &
								(txc(25) xor txx(0)) &
								(txc(24) xor txx(1)) &
								(txc(23) xor txx(2)) &
								(txc(22) xor txx(3) xor txx(0)) &
								(txc(21) xor txx(1) xor txx(0)) &
								(txc(20) xor txx(2) xor txx(1)) &
								(txc(19) xor txx(3) xor txx(2)) &
								(txc(18) xor txx(3)) &
								txc(17) &
								txc(16) &
								(txc(15) xor txx(0)) &             
								(txc(14) xor txx(1)) &
								(txc(13) xor txx(2)) &
								(txc(12) xor txx(3)) &
								(txc(11) xor txx(0)) &
								(txc(10) xor txx(1) xor txx(0)) &
								(txc(9) xor xd012) &
								(txc(8) xor xd123) &
								(txc(7) xor xd023) &
								(txc(6) xor xd013) &
								(txc(5) xor txx(2) xor txx(1)) &
								(txc(4) xor xd023) &
								(txc(3) xor xd013) &
								(txc(2) xor txx(2) xor txx(1)) &
								(txc(1) xor xd023) &
								(txc(0) xor xd013) &
								xd012 &
								xd123 &
								(txx(3) xor txx(2)) &
								txx(3);
			end if;
		end if;
	end process;

	-- CRC output.
	crc_out <= (preamble_5 xnor txc(31)) & ('0' xnor txc(30)) & (preamble_5 xnor txc(29)) & (preamble_8 xnor txc(28)); 
end rtl;
