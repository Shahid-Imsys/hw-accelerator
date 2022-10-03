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
-- Title      : mpgmfield_lib
-- Project    : GP2000
-------------------------------------------------------------------------------
-- File       : mpgmfield_lib.vhd
-- Author     : Christian Blixt
-- Company    : Imsys AB
-- Date       : 2002/04/12
-- Platform   : Windows 2000
-------------------------------------------------------------------------------
-- Description:
-- Microprogram field definitions. 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author                  Description
-- 2002/04/12  1.0      Christian Blixt					Created.
-- 2002/05/27  1.1			CB											Added PC field definitions.
-- 2002/11/11  1.2			CB											Changed SEQC_DOPLS1 to
--																							SEQC_LDOPLS1. Changed encoding
--																							of SEQC field.
-- 2006/05/08  1.3			CB											Changed COND_DBITSET to COND_DSXFC.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package mpgmfield_lib is
--------------------------------------------------------------------------------
	-- Microprogram fields.
--------------------------------------------------------------------------------
	-- MBMOP field
	-- Multiplier and barrel shifter operations. Bit 3 is used directly
	-- and must not be changed.
  constant MBMOP_LANDD0			: std_logic_vector(3 downto 0) :=  "0000";
  constant MBMOP_ROTL1ANDD0	: std_logic_vector(3 downto 0) :=  "0001";
  constant MBMOP_ROTL2ANDD0	: std_logic_vector(3 downto 0) :=  "0010";
  constant MBMOP_ROTL3ANDD0	: std_logic_vector(3 downto 0) :=  "0011";
  constant MBMOP_ROTL4ANDD0	: std_logic_vector(3 downto 0) :=  "0100";
  constant MBMOP_ROTL5ANDD0	: std_logic_vector(3 downto 0) :=  "0101";
  constant MBMOP_ROTL6ANDD0	: std_logic_vector(3 downto 0) :=  "0110";
  constant MBMOP_ROTL7ANDD0	: std_logic_vector(3 downto 0) :=  "0111";
	constant MBMOP_YORD0			: std_logic_vector(3 downto 0) :=  "1000";
  constant MBMOP_ROTLATCH		: std_logic_vector(3 downto 0) :=  "1001";
  constant MBMOP_MASKANDY		: std_logic_vector(3 downto 0) :=  "1010";
  constant MBMOP_FIRSTSHIFT	: std_logic_vector(3 downto 0) :=  "1011";
  constant MBMOP_NEXTSHIFT	: std_logic_vector(3 downto 0) :=  "1100";
  constant MBMOP_MUL2				: std_logic_vector(3 downto 0) :=  "1101";
  constant MBMOP_MUL1				: std_logic_vector(3 downto 0) :=  "1110";
  constant MBMOP_MUL3				: std_logic_vector(3 downto 0) :=  "1111";

	-- PC field
	-- Address register control and GMEM write.
  constant PC_NOP				: std_logic_vector(3 downto 0) :=  "0000";
  constant PC_spare			: std_logic_vector(3 downto 0) :=  "0001";
  constant PC_LOADDIRC	: std_logic_vector(3 downto 0) :=  "0010";
  constant PC_WRITEGMEM	: std_logic_vector(3 downto 0) :=  "0011";
  constant PC_LADLFROMY	: std_logic_vector(3 downto 0) :=  "0100";
  constant PC_LADLFROMD	: std_logic_vector(3 downto 0) :=  "0101";
  constant PC_DECRADL		: std_logic_vector(3 downto 0) :=  "0110";
  constant PC_INCRADL		: std_logic_vector(3 downto 0) :=  "0111";
	constant PC_LOADADHA	: std_logic_vector(3 downto 0) :=  "1000";
  constant PC_LOADADHI	: std_logic_vector(3 downto 0) :=  "1001";
  constant PC_LOADADHD	: std_logic_vector(3 downto 0) :=  "1010";
  constant PC_LOADADHP	: std_logic_vector(3 downto 0) :=  "1011";
  constant PC_LOADADPA	: std_logic_vector(3 downto 0) :=  "1100";
  constant PC_LOADADPI	: std_logic_vector(3 downto 0) :=  "1101";
  constant PC_LOADADPD	: std_logic_vector(3 downto 0) :=  "1110";
  constant PC_LOADADPP	: std_logic_vector(3 downto 0) :=  "1111";

	-- PD field
	-- Load DTM and I/O pulses. All bits used directly and must not be changed.
  constant PD_NOP					: std_logic_vector(2 downto 0) :=  "000";
  constant PD_LDPORT			: std_logic_vector(2 downto 0) :=  "001";
  constant PD_LDTMFRD			: std_logic_vector(2 downto 0) :=  "010";
  constant PD_LDTMFRY			: std_logic_vector(2 downto 0) :=  "011";
  constant PD_LOADIOADDR	: std_logic_vector(2 downto 0) :=  "100";
  constant PD_LDOUTPUT		: std_logic_vector(2 downto 0) :=  "101";
  constant PD_NEXTINPUT		: std_logic_vector(2 downto 0) :=  "110";
  constant PD_SYNC				: std_logic_vector(2 downto 0) :=  "111";

	-- FF_PB field
	-- ALU flag load operations.
  constant FF_NOP				: std_logic_vector(3 downto 0) :=  "0000";
  constant FF_LCZNVFD		: std_logic_vector(3 downto 0) :=  "0001";
  constant FF_LOADPCCY	: std_logic_vector(3 downto 0) :=  "0010";
  constant FF_RESPCCY		: std_logic_vector(3 downto 0) :=  "0011";
  constant FF_LLFD			: std_logic_vector(3 downto 0) :=  "0100";
  constant FF_LLFSHIFT	: std_logic_vector(3 downto 0) :=  "0101";
  constant FF_SETC			: std_logic_vector(3 downto 0) :=  "0110";
  constant FF_LCFSHIFT	: std_logic_vector(3 downto 0) :=  "0111";
	constant FF_LCZARI		: std_logic_vector(3 downto 0) :=  "1000";
  constant FF_LCNVARI		: std_logic_vector(3 downto 0) :=  "1001";
  constant FF_LCZNVARI	: std_logic_vector(3 downto 0) :=  "1010";
  constant FF_LCZNVARI16: std_logic_vector(3 downto 0) :=  "1011";
  constant FF_LZNLOG		: std_logic_vector(3 downto 0) :=  "1100";
  constant FF_LZNVLOG		: std_logic_vector(3 downto 0) :=  "1101";
  constant FF_LCZNVLOG	: std_logic_vector(3 downto 0) :=  "1110";
  constant FF_LZNLOG16	: std_logic_vector(3 downto 0) :=  "1111";

	-- SHIN_PA field
	-- ALU shift input selection.
  constant SHIN_SINP0			: std_logic_vector(2 downto 0) :=  "000";
  constant SHIN_SINPLINK	: std_logic_vector(2 downto 0) :=  "001";
  constant SHIN_SINPC			: std_logic_vector(2 downto 0) :=  "010";
  constant SHIN_ROTDOUBLE	: std_logic_vector(2 downto 0) :=  "011";
  constant SHIN_ROTATE		: std_logic_vector(2 downto 0) :=  "100";
  constant SHIN_ARIDOUBLE	: std_logic_vector(2 downto 0) :=  "101";
  constant SHIN_SINP1			: std_logic_vector(2 downto 0) :=  "110";
  constant SHIN_SHIFTMD		: std_logic_vector(2 downto 0) :=  "111";

	-- SHIN_PA field
	-- Pulse field A.
  constant PA_NOP				: std_logic_vector(3 downto 0) :=  "0000";
  constant PA_LOADNREG	: std_logic_vector(3 downto 0) :=  "0001";
  constant PA_RESSPEC		: std_logic_vector(3 downto 0) :=  "0010";
  constant PA_SETSPEC		: std_logic_vector(3 downto 0) :=  "0011";
  constant PA_spare			: std_logic_vector(3 downto 0) :=  "0100";
  constant PA_LLFRG			: std_logic_vector(3 downto 0) :=  "0101";
  constant PA_LLFRD			: std_logic_vector(3 downto 0) :=  "0110";
  constant PA_LLFRY			: std_logic_vector(3 downto 0) :=  "0111";
  constant PA_LOADIR		: std_logic_vector(3 downto 0) :=  "1000";
  constant PA_CUIRQ			: std_logic_vector(3 downto 0) :=  "1001";
  constant PA_CALLSP		: std_logic_vector(3 downto 0) :=  "1010";
  constant PA_ACKSPREQ	: std_logic_vector(3 downto 0) :=  "1011";
  constant PA_SELBLK0		: std_logic_vector(3 downto 0) :=  "1100";
  constant PA_SELBLK1		: std_logic_vector(3 downto 0) :=  "1101";
  constant PA_SELBLK2		: std_logic_vector(3 downto 0) :=  "1110";
	constant PA_SELBLK3		: std_logic_vector(3 downto 0) :=  "1111";

	-- AADDR field in CUIRQ mode
  constant CUIRQ_RSTFWI		: std_logic_vector(4 downto 0) :=  "00000";
  constant CUIRQ_SETFWI		: std_logic_vector(4 downto 0) :=  "00001";
  constant CUIRQ_RSTTRACE	: std_logic_vector(4 downto 0) :=  "00010";
  constant CUIRQ_SETTRACE	: std_logic_vector(4 downto 0) :=  "00011";
  constant CUIRQ_ACKCLK		: std_logic_vector(4 downto 0) :=  "00100";
  constant CUIRQ_SLEEP		: std_logic_vector(4 downto 0) :=  "00101";
  constant CUIRQ_RSTINVPS	: std_logic_vector(4 downto 0) :=  "00110";
  constant CUIRQ_SETINVPS	: std_logic_vector(4 downto 0) :=  "00111";

	-- ALUD field
	-- ALU destination selection. Bits 2,1 are used directly and must not be changed.
  constant ALUD_NOP				: std_logic_vector(2 downto 0) :=  "000";
  constant ALUD_QREG			: std_logic_vector(2 downto 0) :=  "001";
  constant ALUD_RAMATOY		: std_logic_vector(2 downto 0) :=  "010";
  constant ALUD_RAM				: std_logic_vector(2 downto 0) :=  "011";
  constant ALUD_RAMQRIGHT	: std_logic_vector(2 downto 0) :=  "100";
  constant ALUD_RAMRIGHT	: std_logic_vector(2 downto 0) :=  "101";
  constant ALUD_RAMQLEFT	: std_logic_vector(2 downto 0) :=  "110";
  constant ALUD_RAMLEFT		: std_logic_vector(2 downto 0) :=  "111";

	-- ALUS field
	-- ALU source selection.
  constant ALUS_0D	: std_logic_vector(2 downto 0) :=  "000";
  constant ALUS_QD	: std_logic_vector(2 downto 0) :=  "001";
  constant ALUS_AD	: std_logic_vector(2 downto 0) :=  "010";
  constant ALUS_A0	: std_logic_vector(2 downto 0) :=  "011";
  constant ALUS_B0	: std_logic_vector(2 downto 0) :=  "100";
  constant ALUS_Q0	: std_logic_vector(2 downto 0) :=  "101";
  constant ALUS_BA	: std_logic_vector(2 downto 0) :=  "110";
  constant ALUS_QA	: std_logic_vector(2 downto 0) :=  "111";

	-- ALUF field
	-- ALU function selection.
  constant ALUF_S_PLUS_RE		: std_logic_vector(2 downto 0) :=  "000";
  constant ALUF_S_MINUS_RE	: std_logic_vector(2 downto 0) :=  "001";
  constant ALUF_RE_MINUS_S	: std_logic_vector(2 downto 0) :=  "010";
  constant ALUF_S_OR_RE			: std_logic_vector(2 downto 0) :=  "011";
  constant ALUF_S_AND_RE		: std_logic_vector(2 downto 0) :=  "100";
  constant ALUF_S_ANDNOT_RE	: std_logic_vector(2 downto 0) :=  "101";
  constant ALUF_S_XOR_RE		: std_logic_vector(2 downto 0) :=  "110";
  constant ALUF_S_XNOR_RE		: std_logic_vector(2 downto 0) :=  "111";

	-- CIN field
	-- ALU carry input selection.
  constant CIN_0	: std_logic_vector(1 downto 0) :=  "00";
  constant CIN_1	: std_logic_vector(1 downto 0) :=  "01";
  constant CIN_C	: std_logic_vector(1 downto 0) :=  "10";
  constant CIN_FC	: std_logic_vector(1 downto 0) :=  "11";

	-- SEQC field
	-- Sequence control operations.
--  constant SEQC_RESET			: std_logic_vector(4 downto 0) :=  "00000";
--  constant SEQC_CONTINUE	: std_logic_vector(4 downto 0) :=  "00001";
--  constant SEQC_SKIP			: std_logic_vector(4 downto 0) :=  "00010";
--  constant SEQC_UGOTO			: std_logic_vector(4 downto 0) :=  "00011";
--  constant SEQC_LGOTOPLS1	: std_logic_vector(4 downto 0) :=  "00100";
--  constant SEQC_ULGOTO		: std_logic_vector(4 downto 0) :=  "00101";
--  constant SEQC_GOTO			: std_logic_vector(4 downto 0) :=  "00110";
--  constant SEQC_EGOTOSTD	: std_logic_vector(4 downto 0) :=  "00111";
--  constant SEQC_LGOTO			: std_logic_vector(4 downto 0) :=  "01000";
--  constant SEQC_UDO				: std_logic_vector(4 downto 0) :=  "01001";
--  constant SEQC_LDOPLS1		: std_logic_vector(4 downto 0) :=  "01010";
--  constant SEQC_ULDO			: std_logic_vector(4 downto 0) :=  "01011";
--  constant SEQC_DO				: std_logic_vector(4 downto 0) :=  "01100";
--  constant SEQC_EDOSTD		: std_logic_vector(4 downto 0) :=  "01101";
--  constant SEQC_LDO				: std_logic_vector(4 downto 0) :=  "01110";
--	constant SEQC_URETURN		: std_logic_vector(4 downto 0) :=  "01111";
--  constant SEQC_RETSKIP		: std_logic_vector(4 downto 0) :=  "10000";
--  constant SEQC_RETURN		: std_logic_vector(4 downto 0) :=  "10001";
--  constant SEQC_POPJUMP		: std_logic_vector(4 downto 0) :=  "10010";
--  constant SEQC_UDECODE		: std_logic_vector(4 downto 0) :=  "10011";
--  constant SEQC_DECODE		: std_logic_vector(4 downto 0) :=  "10100";
--  constant SEQC_VECTOR		: std_logic_vector(4 downto 0) :=  "10101";
--  constant SEQC_STLC_PUSH	: std_logic_vector(4 downto 0) :=  "10110";
--  constant SEQC_STLC			: std_logic_vector(4 downto 0) :=  "10111";
--  constant SEQC_LDCTR			: std_logic_vector(4 downto 0) :=  "11000";
--  constant SEQC_RCUC0			: std_logic_vector(4 downto 0) :=  "11001";
--  constant SEQC_RCP1UC0		: std_logic_vector(4 downto 0) :=  "11010";
--  constant SEQC_CCERC			: std_logic_vector(4 downto 0) :=  "11011";
--  constant SEQC_RDUC0			: std_logic_vector(4 downto 0) :=  "11100";
--  constant SEQC_RDP1UC0		: std_logic_vector(4 downto 0) :=  "11101";
--  constant SEQC_CCC0DERC	: std_logic_vector(4 downto 0) :=  "11110";
--	constant SEQC_C0CCDERC	: std_logic_vector(4 downto 0) :=  "11111";

  constant SEQC_RESET			: std_logic_vector(4 downto 0) :=  "00000";
  constant SEQC_VECTOR		: std_logic_vector(4 downto 0) :=  "00001";
  constant SEQC_CCERC			: std_logic_vector(4 downto 0) :=  "00010";
  constant SEQC_RETURN		: std_logic_vector(4 downto 0) :=  "00011";
  constant SEQC_GOTO			: std_logic_vector(4 downto 0) :=  "00100";
  --constant SEQC_LGOTO			: std_logic_vector(4 downto 0) :=  "00101";
  constant SEQC_MPL 			: std_logic_vector(4 downto 0) :=  "00101"; --Added by CJ
  constant SEQC_DO				: std_logic_vector(4 downto 0) :=  "00110";
  constant SEQC_LDO				: std_logic_vector(4 downto 0) :=  "00111";
  constant SEQC_EGOTOSTD	: std_logic_vector(4 downto 0) :=  "01000";
  constant SEQC_POPJUMP		: std_logic_vector(4 downto 0) :=  "01001";
  constant SEQC_EDOSTD		: std_logic_vector(4 downto 0) :=  "01010";
  constant SEQC_LDCTR			: std_logic_vector(4 downto 0) :=  "01011";
  constant SEQC_STLC_PUSH	: std_logic_vector(4 downto 0) :=  "01100";
  constant SEQC_CCC0DERC	: std_logic_vector(4 downto 0) :=  "01101";
  constant SEQC_DECODE		: std_logic_vector(4 downto 0) :=  "01110";
	constant SEQC_C0CCDERC	: std_logic_vector(4 downto 0) :=  "01111";
  constant SEQC_RDUC0			: std_logic_vector(4 downto 0) :=  "10000";
  constant SEQC_CONTINUE	: std_logic_vector(4 downto 0) :=  "10001";
  constant SEQC_RCUC0			: std_logic_vector(4 downto 0) :=  "10010";
	constant SEQC_URETURN		: std_logic_vector(4 downto 0) :=  "10011";
  constant SEQC_UGOTO			: std_logic_vector(4 downto 0) :=  "10100";
  constant SEQC_ULGOTO		: std_logic_vector(4 downto 0) :=  "10101";
  constant SEQC_UDO				: std_logic_vector(4 downto 0) :=  "10110";
  constant SEQC_ULDO			: std_logic_vector(4 downto 0) :=  "10111";
  constant SEQC_RDP1UC0		: std_logic_vector(4 downto 0) :=  "11000";
  constant SEQC_SKIP			: std_logic_vector(4 downto 0) :=  "11001";
  constant SEQC_RCP1UC0		: std_logic_vector(4 downto 0) :=  "11010";
  constant SEQC_RETSKIP		: std_logic_vector(4 downto 0) :=  "11011";
  constant SEQC_STLC			: std_logic_vector(4 downto 0) :=  "11100";
  constant SEQC_LGOTOPLS1	: std_logic_vector(4 downto 0) :=  "11101";
  constant SEQC_UDECODE		: std_logic_vector(4 downto 0) :=  "11110";
  constant SEQC_LDOPLS1		: std_logic_vector(4 downto 0) :=  "11111";


--  constant SEQC_RESET			: std_logic_vector(4 downto 0) :=  "00000";
--  constant SEQC_VECTOR		: std_logic_vector(4 downto 0) :=  "00001";
--  constant SEQC_UGOTO			: std_logic_vector(4 downto 0) :=  "00010";
--  constant SEQC_LGOTOPLS1	: std_logic_vector(4 downto 0) :=  "00011";
--  constant SEQC_ULGOTO		: std_logic_vector(4 downto 0) :=  "00100";
--  constant SEQC_GOTO			: std_logic_vector(4 downto 0) :=  "00101";
--  constant SEQC_EGOTOSTD	: std_logic_vector(4 downto 0) :=  "00110";
--  constant SEQC_LGOTO			: std_logic_vector(4 downto 0) :=  "00111";
--  constant SEQC_CONTINUE	: std_logic_vector(4 downto 0) :=  "01000";
--  constant SEQC_SKIP			: std_logic_vector(4 downto 0) :=  "01001";
--  constant SEQC_UDO				: std_logic_vector(4 downto 0) :=  "01010";
--  constant SEQC_LDOPLS1		: std_logic_vector(4 downto 0) :=  "01011";
--  constant SEQC_ULDO			: std_logic_vector(4 downto 0) :=  "01100";
--  constant SEQC_DO				: std_logic_vector(4 downto 0) :=  "01101";
--  constant SEQC_EDOSTD		: std_logic_vector(4 downto 0) :=  "01110";
--  constant SEQC_LDO				: std_logic_vector(4 downto 0) :=  "01111";
--	constant SEQC_URETURN		: std_logic_vector(4 downto 0) :=  "10000";
--  constant SEQC_RETSKIP		: std_logic_vector(4 downto 0) :=  "10001";
--  constant SEQC_RETURN		: std_logic_vector(4 downto 0) :=  "10010";
--  constant SEQC_POPJUMP		: std_logic_vector(4 downto 0) :=  "10011";
--  constant SEQC_UDECODE		: std_logic_vector(4 downto 0) :=  "10100";
--  constant SEQC_DECODE		: std_logic_vector(4 downto 0) :=  "10101";
--  constant SEQC_STLC_PUSH	: std_logic_vector(4 downto 0) :=  "10110";
--  constant SEQC_STLC			: std_logic_vector(4 downto 0) :=  "10111";
--  constant SEQC_LDCTR			: std_logic_vector(4 downto 0) :=  "11000";
--  constant SEQC_RCUC0			: std_logic_vector(4 downto 0) :=  "11001";
--  constant SEQC_RCP1UC0		: std_logic_vector(4 downto 0) :=  "11010";
--  constant SEQC_CCERC			: std_logic_vector(4 downto 0) :=  "11011";
--  constant SEQC_RDUC0			: std_logic_vector(4 downto 0) :=  "11100";
--  constant SEQC_RDP1UC0		: std_logic_vector(4 downto 0) :=  "11101";
--  constant SEQC_CCC0DERC	: std_logic_vector(4 downto 0) :=  "11110";
--	constant SEQC_C0CCDERC	: std_logic_vector(4 downto 0) :=  "11111";

	-- COND field
	-- Condition selection.
  constant COND_ZERO			: std_logic_vector(5 downto 0) :=  "000000"; --Added one additional bit, CJ
  constant COND_CARRY			: std_logic_vector(5 downto 0) :=  "000001";
  constant COND_FH				: std_logic_vector(5 downto 0) :=  "000010";
  constant COND_NEG				: std_logic_vector(5 downto 0) :=  "000011";
  constant COND_FZ				: std_logic_vector(5 downto 0) :=  "000100";
  constant COND_FC				: std_logic_vector(5 downto 0) :=  "000101";
  constant COND_FN				: std_logic_vector(5 downto 0) :=  "000110";
  constant COND_FV				: std_logic_vector(5 downto 0) :=  "000111";
  constant COND_OVERFLOW	: std_logic_vector(5 downto 0) :=  "001000";
  constant COND_LESS			: std_logic_vector(5 downto 0) :=  "001001";
  constant COND_PCCY			: std_logic_vector(5 downto 0) :=  "001010";
  constant COND_LINK			: std_logic_vector(5 downto 0) :=  "001011";
  constant COND_ODD				: std_logic_vector(5 downto 0) :=  "001100";
  constant COND_FL				: std_logic_vector(5 downto 0) :=  "001101";
  constant COND_QLSB			: std_logic_vector(5 downto 0) :=  "001110";
	constant COND_CNDFALSE	: std_logic_vector(5 downto 0) :=  "001111";
  constant COND_DSXFC			: std_logic_vector(5 downto 0) :=  "010000";
  constant COND_YBITSET		: std_logic_vector(5 downto 0) :=  "010001";
  constant COND_PSCAFU		: std_logic_vector(5 downto 0) :=  "010010";
  constant COND_PSCFULL		: std_logic_vector(5 downto 0) :=  "010011";
  constant COND_PSCAEM		: std_logic_vector(5 downto 0) :=  "010100";
  constant COND_PSCEM			: std_logic_vector(5 downto 0) :=  "010101";
  constant COND_CTREQ0		: std_logic_vector(5 downto 0) :=  "010110";
  constant COND_GREATER		: std_logic_vector(5 downto 0) :=  "010111";
  constant COND_NSPREQ		: std_logic_vector(5 downto 0) :=  "011000";
  constant COND_NSPACK		: std_logic_vector(5 downto 0) :=  "011001";
  constant COND_FG				: std_logic_vector(5 downto 0) :=  "011010";
  constant COND_ABOVE			: std_logic_vector(5 downto 0) :=  "011011";
  constant COND_SPECIAL		: std_logic_vector(5 downto 0) :=  "011100";
  constant COND_YEQNEG		: std_logic_vector(5 downto 0) :=  "011101";
  constant COND_FA				: std_logic_vector(5 downto 0) :=  "011110";
	constant COND_ADLCY			: std_logic_vector(5 downto 0) :=  "011111";
  constant COND_VE_RDY    : std_logic_vector(5 downto 0) :=  "100000"; --Added by CJ
  constant COND_RE_RDY    : std_logic_vector(5 downto 0) :=  "100001"; --Added by CJ
  constant COND_DFM_RDY   : std_logic_vector(5 downto 0) :=  "100010"; --Added by CJ
  constant COND_FIFO_RDY  : std_logic_vector(5 downto 0) :=  "100011"; --Added by CJ
  constant COND_CONT      : std_logic_vector(5 downto 0) :=  "100100"; --Added by CJ --0823

--------------------------------------------------------------------------------
	-- Constants for CLC.
--------------------------------------------------------------------------------
	-- Counter/register input selections.
  constant RIN_Z			: std_logic_vector(2 downto 0) :=  "000";
  constant RIN_Y			: std_logic_vector(2 downto 0) :=  "001";
  constant RIN_AD			: std_logic_vector(2 downto 0) :=  "010";
  constant RIN_DI			: std_logic_vector(2 downto 0) :=  "011";
  constant RIN_spare	: std_logic_vector(2 downto 0) :=  "100";
  constant RIN_YM			: std_logic_vector(2 downto 0) :=  "101";
  constant RIN_IRA		: std_logic_vector(2 downto 0) :=  "110";
  constant RIN_DIM		: std_logic_vector(2 downto 0) :=  "111";

	-- Auxiliary stack/counter functions.
  constant AUX1_NOP					: std_logic_vector(2 downto 0) :=  "000";
  constant AUX1_POPCSTACK		: std_logic_vector(2 downto 0) :=  "001";
  constant AUX1_DECTR				: std_logic_vector(2 downto 0) :=  "010";
  constant AUX1_POPDECTR		: std_logic_vector(2 downto 0) :=  "011";
  constant AUX1_INST				: std_logic_vector(2 downto 0) :=  "100";
  constant AUX1_PUSHCSTACK	: std_logic_vector(2 downto 0) :=  "101";
  constant AUX1_WHENSPREQ		: std_logic_vector(2 downto 0) :=  "110";
  constant AUX1_PUSHDECTR		: std_logic_vector(2 downto 0) :=  "111";

	-- Stack/counter D-bus readout selections.
  constant DS_CSTACKL	: std_logic_vector(1 downto 0) :=  "00";
  constant DS_CTRL		: std_logic_vector(1 downto 0) :=  "01";
  constant DS_CSTACKH	: std_logic_vector(1 downto 0) :=  "10";
  constant DS_CTRH		: std_logic_vector(1 downto 0) :=  "11";

  --------------------------------
  --Register set selection fields
  --------------------------------
  constant CONS_NON_ACT          : std_logic_vector(5 downto 0) := "00"&x"0";
  constant CONS_RE_START_ADDR_L  : std_logic_vector(5 downto 0) := "00"&x"1"; --write left starting address of receive engine
  constant CONS_RE_START_ADDR_R  : std_logic_vector(5 downto 0) := "00"&x"2"; --write right starting address of recieve engine
  constant CONS_RE_LC            : std_logic_vector(5 downto 0) := "00"&x"3"; --write receive engine's loop counter
  constant CONS_DFY_ADDR_A       : std_logic_vector(5 downto 0) := "00"&x"4"; --push back address from DFY
  constant CONS_DFY_ADDR_B       : std_logic_vector(5 downto 0) := "00"&x"5"; --push back address from DFY, B mode
  constant CONS_VE_START_ADDR_L  : std_logic_vector(5 downto 0) := "00"&x"6"; --vector engine's left starting address
  constant CONS_VE_START_ADDR_R  : std_logic_vector(5 downto 0) := "00"&x"7"; --vector engine's right starting address
  constant CONS_VE_LC            : std_logic_vector(5 downto 0) := "00"&x"8"; --vector engine's INNER loop counter
  constant CONS_VE_OFFSET_L      : std_logic_vector(5 downto 0) := "00"&x"9"; --left offset
  constant CONS_VE_OFFSET_R      : std_logic_vector(5 downto 0) := "00"&x"a"; --right offset
  constant CONS_VE_DEPTH_L       : std_logic_vector(5 downto 0) := "00"&x"b"; --left depth
  constant CONS_VE_JUMP_L        : std_logic_vector(5 downto 0) := "00"&x"c"; --left jump
  constant CONS_DFY_REG_SHIFT_IN : std_logic_vector(5 downto 0) := "00"&x"d"; --write DFY
  constant CONS_DFY_REG_PARALLEL : std_logic_vector(5 downto 0) := "00"&x"e"; --write DFY in parallel from mac registers
  constant CONS_DTM_REG_SHIFT_IN : std_logic_vector(5 downto 0) := "00"&x"f"; --Write DTM --?
  constant CONS_VE_OLC           : std_logic_vector(5 downto 0) := "01"&x"0"; --write vector engine's OUTER loop counter
  constant CONS_CONFIG           : std_logic_vector(5 downto 0) := "01"&x"1"; --write config register for both ring mode and inner-outer loop mode
  constant CONS_RING_END         : std_logic_vector(5 downto 0) := "01"&x"2"; --Ring mode end address
  constant CONS_RING_START       : std_logic_vector(5 downto 0) := "01"&x"3"; --Ring mode start address.  
  constant CONS_ZP_DATA          : std_logic_vector(5 downto 0) := "01"&x"4"; --Zero point value for data register, signed
  constant CONS_ZP_WEIGHT        : std_logic_vector(5 downto 0) := "01"&x"5"; --Zero point value for weight register, signed
  constant CONS_SCALE            : std_logic_vector(5 downto 0) := "01"&x"6"; --Scale factor for shifter
  constant CONS_PP_CTL           : std_logic_vector(5 downto 0) := "01"&x"7"; --Controls the bypass of different logics inside post processors
  constant CONS_BIAS_INDEX_END   : std_logic_vector(5 downto 0) := "01"&x"8"; --End indexing of the bias 
  constant CONS_BIAS_INDEX_START : std_logic_vector(5 downto 0) := "01"&x"9"; --Start indexing of the bias
--AU parameters
  constant CONS_AU_PBOFFSET0 : std_logic_vector(5 downto 0) := "01"&x"A"; --add pushback mode_b offset0 of addressing unit
  constant CONS_AU_PBOFFSET1 : std_logic_vector(5 downto 0) := "01"&x"B"; --add pushback mode_b of addressing unit
  constant CONS_AU_PBOFFSET2 : std_logic_vector(5 downto 0) := "01"&x"C"; --add pushback mode_b of addressing unit
  --constant CONS_AU_PBOFFSET3 : std_logic_vector(5 downto 0) := "01"&x"D"; --add pushback mode_b of addressing unit
  constant CONS_AU_PBCMP0    : std_logic_vector(5 downto 0) := "01"&x"D"; --pushback mode_b comparator0 of addressing unit
  constant CONS_AU_PBCMP1    : std_logic_vector(5 downto 0) := "01"&x"E"; --pushback mode_b comparator1 of addressing unit
  constant CONS_AU_PBCMP2    : std_logic_vector(5 downto 0) := "01"&x"F"; --pushback mode_b comparator2 of addressing unit
  --constant CONS_AU_PBCMP3    : std_logic_vector(5 downto 0) := "01"&x"F"; --pushback mode_b comparator3 of addressing unit
  constant CONS_AU_LOFFSET0  : std_logic_vector(5 downto 0) := "10"&x"0"; --add left offset0 of addressing unit
  constant CONS_AU_LOFFSET1  : std_logic_vector(5 downto 0) := "10"&x"1"; --add left offset1 of addressing unit
  constant CONS_AU_LOFFSET2  : std_logic_vector(5 downto 0) := "10"&x"2"; --add left offset2 of addressing unit
  constant CONS_AU_LOFFSET3  : std_logic_vector(5 downto 0) := "10"&x"3"; --add left offset4 of addressing unit
  constant CONS_AU_LCMP0     : std_logic_vector(5 downto 0) := "10"&x"4"; --left comparator0 of addressing unit
  constant CONS_AU_LCMP1     : std_logic_vector(5 downto 0) := "10"&x"5"; --left comparator1 of addressing unit
  constant CONS_AU_LCMP2     : std_logic_vector(5 downto 0) := "10"&x"6"; --left comparator2 of addressing unit
  constant CONS_AU_LCMP3     : std_logic_vector(5 downto 0) := "10"&x"7"; --left comparator3 of addressing unit
  constant CONS_AU_ROFFSET0  : std_logic_vector(5 downto 0) := "10"&x"8"; --add right offset0 of addressing unit
  constant CONS_AU_ROFFSET1  : std_logic_vector(5 downto 0) := "10"&x"9"; --add right offset1 of addressing unit
  constant CONS_AU_ROFFSET2  : std_logic_vector(5 downto 0) := "10"&x"A"; --add right offset2 of addressing unit
  constant CONS_AU_ROFFSET3  : std_logic_vector(5 downto 0) := "10"&x"B"; --add right offset4 of addressing unit
  constant CONS_AU_RCMP0     : std_logic_vector(5 downto 0) := "10"&x"C"; --right comparator0 of addressing unit
  constant CONS_AU_RCMP1     : std_logic_vector(5 downto 0) := "10"&x"D"; --right comparator1 of addressing unit
  constant CONS_AU_RCMP2     : std_logic_vector(5 downto 0) := "10"&x"E"; --right comparator2 of addressing unit
  constant CONS_AU_RCMP3     : std_logic_vector(5 downto 0) := "10"&x"F"; --right comparator3 of addressing unit
  constant CONS_AU_BOFFSET0  : std_logic_vector(5 downto 0) := "11"&x"0"; --add bias offset0 of addressing unit
  constant CONS_AU_BOFFSET1  : std_logic_vector(5 downto 0) := "11"&x"1"; --add bias offset1 of addressing unit
  constant CONS_AU_BOFFSET2  : std_logic_vector(5 downto 0) := "11"&x"2"; --add bias offset2 of addressing unit
  constant CONS_AU_BOFFSET3  : std_logic_vector(5 downto 0) := "11"&x"3"; --add bias offset4 of addressing unit
  constant CONS_AU_BCMP0     : std_logic_vector(5 downto 0) := "11"&x"4"; --bias comparator0 of addressing unit
  constant CONS_AU_BCMP1     : std_logic_vector(5 downto 0) := "11"&x"5"; --bias comparator1 of addressing unit
  constant CONS_AU_BCMP2     : std_logic_vector(5 downto 0) := "11"&x"6"; --bias comparator2 of addressing unit
  constant CONS_AU_BCMP3     : std_logic_vector(5 downto 0) := "11"&x"7"; --bias comparator3 of addressing unit
  constant CONS_AU_PAOFFSET0 : std_logic_vector(5 downto 0) := "11"&x"8"; --add pushback mode_a offset0 of addressing unit
  constant CONS_AU_PAOFFSET1 : std_logic_vector(5 downto 0) := "11"&x"9"; --add pushback mode_a of addressing unit
  constant CONS_AU_PAOFFSET2 : std_logic_vector(5 downto 0) := "11"&x"A"; --add pushback mode_a of addressing unit
  constant CONS_AU_PAOFFSET3 : std_logic_vector(5 downto 0) := "11"&x"B"; --add pushback mode_a of addressing unit
  constant CONS_AU_PACMP0    : std_logic_vector(5 downto 0) := "11"&x"C"; --pushback mode_a comparator0 of addressing unit
  constant CONS_AU_PACMP1    : std_logic_vector(5 downto 0) := "11"&x"D"; --pushback mode_a comparator1 of addressing unit
  constant CONS_AU_PACMP2    : std_logic_vector(5 downto 0) := "11"&x"E"; --pushback mode_a comparator2 of addressing unit
  constant CONS_AU_PACMP3    : std_logic_vector(5 downto 0) := "11"&x"F"; --pushback mode_a comparator3 of addressing unit

end mpgmfield_lib;
