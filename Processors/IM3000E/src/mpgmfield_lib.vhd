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
  constant SEQC_LGOTO			: std_logic_vector(4 downto 0) :=  "00101";
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
  constant COND_ZERO			: std_logic_vector(4 downto 0) :=  "00000";
  constant COND_CARRY			: std_logic_vector(4 downto 0) :=  "00001";
  constant COND_FH				: std_logic_vector(4 downto 0) :=  "00010";
  constant COND_NEG				: std_logic_vector(4 downto 0) :=  "00011";
  constant COND_FZ				: std_logic_vector(4 downto 0) :=  "00100";
  constant COND_FC				: std_logic_vector(4 downto 0) :=  "00101";
  constant COND_FN				: std_logic_vector(4 downto 0) :=  "00110";
  constant COND_FV				: std_logic_vector(4 downto 0) :=  "00111";
  constant COND_OVERFLOW	: std_logic_vector(4 downto 0) :=  "01000";
  constant COND_LESS			: std_logic_vector(4 downto 0) :=  "01001";
  constant COND_PCCY			: std_logic_vector(4 downto 0) :=  "01010";
  constant COND_LINK			: std_logic_vector(4 downto 0) :=  "01011";
  constant COND_ODD				: std_logic_vector(4 downto 0) :=  "01100";
  constant COND_FL				: std_logic_vector(4 downto 0) :=  "01101";
  constant COND_QLSB			: std_logic_vector(4 downto 0) :=  "01110";
	constant COND_CNDFALSE	: std_logic_vector(4 downto 0) :=  "01111";
  constant COND_DSXFC			: std_logic_vector(4 downto 0) :=  "10000";
  constant COND_YBITSET		: std_logic_vector(4 downto 0) :=  "10001";
  constant COND_PSCAFU		: std_logic_vector(4 downto 0) :=  "10010";
  constant COND_PSCFULL		: std_logic_vector(4 downto 0) :=  "10011";
  constant COND_PSCAEM		: std_logic_vector(4 downto 0) :=  "10100";
  constant COND_PSCEM			: std_logic_vector(4 downto 0) :=  "10101";
  constant COND_CTREQ0		: std_logic_vector(4 downto 0) :=  "10110";
  constant COND_GREATER		: std_logic_vector(4 downto 0) :=  "10111";
  constant COND_NSPREQ		: std_logic_vector(4 downto 0) :=  "11000";
  constant COND_NSPACK		: std_logic_vector(4 downto 0) :=  "11001";
  constant COND_FG				: std_logic_vector(4 downto 0) :=  "11010";
  constant COND_ABOVE			: std_logic_vector(4 downto 0) :=  "11011";
  constant COND_SPECIAL		: std_logic_vector(4 downto 0) :=  "11100";
  constant COND_YEQNEG		: std_logic_vector(4 downto 0) :=  "11101";
  constant COND_FA				: std_logic_vector(4 downto 0) :=  "11110";
	constant COND_ADLCY			: std_logic_vector(4 downto 0) :=  "11111";

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

end mpgmfield_lib;
