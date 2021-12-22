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
-- Title      : Stimuli
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : flash_stim.vhd
-- Author     : Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: 
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2006-02-22		1.00			CB			Created.
-------------------------------------------------------------------------------
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
library work;
use work.io_utils.all;
use work.mti_pkg.all;

entity flash_stim is
  port(
    MX1_CK   : inout std_logic;   
    MXOUT    : in    std_logic;   
    MEXEC    : in    std_logic;   
    MCKOUT0  : in    std_logic;   
    MCKOUT1  : in    std_logic;   
    MSDIN    : out   std_logic;   
    MSDOUT   : in    std_logic;   
    MIRQOUT  : in    std_logic;   
    MBYPASS  : out   std_logic;   
    MRESET   : out   std_logic;   
    MRSTOUT  : in    std_logic;   
    MTEST    : out   std_logic;   
    MWAKE    : out   std_logic;   
    MIRQ0    : out   std_logic;   
    MIRQ1    : out   std_logic;   
    MRXOUT   : in    std_logic;
    PA       : inout std_logic_vector(7 downto 0);        
    PB       : in    std_logic_vector(7 downto 0);        
    XTAL1    : inout std_logic;   
    MPORDIS  : out   std_logic   
    );
end flash_stim;

architecture behav of flash_stim is
  -- SP commands
  constant WCNOP : std_logic_vector(7 downto 0) := x"00";-- No operation.
  constant WCDAP : std_logic_vector(7 downto 0) := x"11";-- Control data paths.
  constant WMDAT : std_logic_vector(7 downto 0) := x"2A";-- Write microprogram data.
  constant WMDAT1: std_logic_vector(7 downto 0) := x"21";-- Write microprogram data, low byte.
  constant WTIMC : std_logic_vector(7 downto 0) := x"31";-- Control timing. 
  constant WDCLC : std_logic_vector(7 downto 0) := x"42";-- Write in CLC- and ALC-reg & gen SPREQ.
  constant WDALC : std_logic_vector(7 downto 0) := x"51";-- Write in ALC-reg & generate SPREQ.
  constant WSTRC : std_logic_vector(7 downto 0) := x"68";-- Set mask and trig word in trace.
  constant WGTRC : std_logic_vector(7 downto 0) := x"71";-- Go trace.
  constant RMMAD : std_logic_vector(7 downto 0) := x"81";-- Read current microprogram address (MSB).
  constant RLMAD : std_logic_vector(7 downto 0) := x"91";-- Read current microprogram address (LSB).
  constant RMDATA: std_logic_vector(7 downto 0) := x"AA";-- Read microprogram data byte 10 (msb).
  constant RPDAT : std_logic_vector(7 downto 0) := x"AF";-- Read pmem data
  constant RDBUS : std_logic_vector(7 downto 0) := x"B1";-- Read contents of microprogram D-bus.
  constant RYBUS : std_logic_vector(7 downto 0) := x"C1";-- Read contents of microprogram Y-bus.
  constant RDREG : std_logic_vector(7 downto 0) := x"D1";-- Read D-bus register, loaded at "CALL SP".
  constant RDST1 : std_logic_vector(7 downto 0) := x"E1";-- Read status 1.
  constant RDTRC : std_logic_vector(7 downto 0) := x"F1";-- Read trace.

  -- SP command parameters
  -- WCDAP
  constant DISALL: std_logic_vector(7 downto 0) := x"46";-- PL holds last instruction.
  constant ENPL  : std_logic_vector(7 downto 0) := x"47";-- PL is loaded from memory.
  constant METOPL: std_logic_vector(7 downto 0) := x"47";-- PL is loaded from memory.
  constant SRTOPL: std_logic_vector(7 downto 0) := x"44";-- PL is loaded from MPLL.   
  constant WRMEM : std_logic_vector(7 downto 0) := x"42";-- PL holds last, WE active 
  -- WTIMC
  constant SSCU  : std_logic_vector(7 downto 0) := x"03";-- Stop mode.
  constant RUCU  : std_logic_vector(7 downto 0) := x"04";-- Run mode.
  constant AKCC  : std_logic_vector(7 downto 0) := x"05";-- SP acknowledge.

  -- RDST1 return bitmasks
  constant SPREQ : std_logic_vector(7 downto 0) := x"20"; -- SP request (active low)

  -- SPREQ indices
  constant S_IMEM		: std_logic_vector(7 downto 0) := x"08";	-- Init memory.
  constant S_LDIR		: std_logic_vector(7 downto 0) := x"0A";	-- Load IR.
  constant S_WRCRB	: std_logic_vector(7 downto 0) := x"0C";	-- Write CRB.
  constant S_RDCRB	: std_logic_vector(7 downto 0) := x"0E";	-- Read CRB.
  constant S_RDGM		: std_logic_vector(7 downto 0) := x"10";	-- Read GMEM register.
  constant S_WRGM		: std_logic_vector(7 downto 0) := x"11";	-- Write GMEM register.
  constant S_RDALU	: std_logic_vector(7 downto 0) := x"22";	-- Read ALU register.
  constant S_WRALU	: std_logic_vector(7 downto 0) := x"23";	-- Write ALU register.
  constant S_STOP		: std_logic_vector(7 downto 0) := x"19";	-- Set stop mode.
  constant S_STEP		: std_logic_vector(7 downto 0) := x"1A";	-- Step one instruction.
  constant S_RUN		: std_logic_vector(7 downto 0) := x"1B";	-- Set run mode.
  constant S_IMMU		: std_logic_vector(7 downto 0) := x"24";	-- Initialize memory.

  -- ALU register indices
  constant ALU_SADP	: std_logic_vector(7 downto 0) := x"0C";	-- Program counter.

  -- Microprogram words
  constant Continue: std_logic_vector(79 downto 0) := x"8804000000133FF00000";
  -- Default       
  constant Reset   : std_logic_vector(79 downto 0) := x"0004000000003FF00000";
  constant Jump00FF: std_logic_vector(79 downto 0) := x"A804003FC0003FF0C000";
  constant Jump0100: std_logic_vector(79 downto 0) := x"A804004000003FF0C000";
  constant Jump07FF: std_logic_vector(79 downto 0) := x"A80401FFC0003FF0C000";
  constant Jump0800: std_logic_vector(79 downto 0) := x"A804020000003FF0C000";
  constant Jump1801: std_logic_vector(79 downto 0) := x"A804020040003FF0D000";
  constant Jump1802: std_logic_vector(79 downto 0) := x"A804020080003FF0D000";

  signal recvWord : std_logic_vector(7 downto 0) := (others => '0');
  signal memSize  : std_logic_vector(15 downto 0);
  signal CPpar    : std_logic_vector(7 downto 0);
  signal memType  : std_logic_vector(7 downto 0);
  signal memMode  : std_logic_vector(7 downto 0);
  signal mx1_ck_int : std_logic := '1';
  signal xtal1_int   : std_logic := '1';
  constant HALF_CLK_C_CYCLE : time := 16000 ps;

  signal Progress	: integer;

begin  -- behav
--	PA(7 downto 5) <= "HLH";	-- This is read by ROM bootloader (old sflash)
--	PA(7 downto 5) <= "LLH";	-- This is read by ROM bootloader (new sflash)
--	PA(7 downto 5) <= "LHH";	-- This is read by ROM bootloader (peprom)
--	PA(7 downto 5) <= "HHH";	-- This is read by ROM bootloader (old MMC)
	PA(7 downto 5) <= "HHL";	-- This is read by ROM bootloader (new MMC/SD)
	PA(4 downto 3) <= "LH";		-- Set SP communication at /2 speed
	PA(2 downto 1) <= "LH";		-- Set PLL multiplier to 4
	PA(0) <= 'H';							-- Set PLL divider to 1
	  
  -- This emulates a 31.25 MHz crystal
  mx1_ck_int <= not mx1_ck_int after HALF_CLK_C_CYCLE; 
  MX1_CK <= mx1_ck_int;

  -- This emulates a 32768 Hz crystal connected to RXOSC
  xtal1_int <= not xtal1_int after 15259 ns;
  XTAL1 <= xtal1_int;

  -- Power-on reset enabled
  MPORDIS <= '0';

  -- Bypass disabled
  MBYPASS <= '0';

  -- Wake-up signal inactive
  MWAKE <= '0';

	MIRQ0 <= '1';
	MIRQ1 <= '1';

  process
    constant  mpgm_size : integer := 2*2048*10; -- Microprogram size in bytes
    type      mpgm_type is array (mpgm_size - 1 downto 0) of integer;
    variable  mpgm_area : mpgm_type; -- Microprogram data area
    variable  mpgm_ptr  : integer;   -- Microprogram data pointer
		variable	l					: line;

    procedure load_mpgm_file is
      file     mpgm0_file : text is in "RAM0.HEX";  -- Microprogram data file
      file     mpgm1_file : text is in "RAM1.HEX";  -- Microprogram data file
      variable mpgm_line  : line;                   -- Microprogram data line
      variable mpgm_byte  : integer;                -- Microprogram data byte
    begin  -- load_mpgm_file
      mpgm_ptr := 0;
      while not endfile (mpgm0_file) loop
        readline (mpgm0_file, mpgm_line);
        if mpgm_line'length > 0 then
          assert mpgm_ptr < mpgm_size
            report "Microprogram HEX file too big!"
            severity failure;                 -- exit simulation
          read(mpgm_line, mpgm_byte, 16);
          mpgm_area(mpgm_ptr) := mpgm_byte;
          mpgm_ptr := mpgm_ptr + 1;
        end if;
      end loop;
      while not endfile (mpgm1_file) loop
        readline (mpgm1_file, mpgm_line);
        if mpgm_line'length > 0 then
          assert mpgm_ptr < mpgm_size
            report "Microprogram HEX file too big!"
            severity failure;                 -- exit simulation
          read(mpgm_line, mpgm_byte, 16);
          mpgm_area(mpgm_ptr) := mpgm_byte;
          mpgm_ptr := mpgm_ptr + 1;
        end if;
      end loop;
      while mpgm_ptr < mpgm_size loop
        mpgm_area(mpgm_ptr) := 0;
        mpgm_ptr := mpgm_ptr + 1;
      end loop;
    end load_mpgm_file;

    procedure send (constant word : in  std_logic_vector(7 downto 0)) is
      variable shift_reg : std_logic_vector(9 downto 0);
    begin  -- send
      shift_reg := word & "00";
      MSDIN <= '1';
      for i in 0 to 10 loop
        wait until rising_edge(MCKOUT0);
        wait for 1 ns;
        shift_reg := '1' & shift_reg(9 downto 1);       
        MSDIN <= shift_reg(0);
      end loop;  -- i
    end send;
    
    procedure recv (signal word : out std_logic_vector(7 downto 0)) is
      variable shift_reg : std_logic_vector(7 downto 0);
    begin  -- recv
      wait until rising_edge(MCKOUT0) and MSDOUT = '0';
      for i in 0 to 7 loop
        wait until rising_edge(MCKOUT0);
        shift_reg := MSDOUT & shift_reg(7 downto 1);
      end loop;  -- i
      word <= shift_reg;
      wait until rising_edge(MCKOUT0);
    end recv;

    procedure sendMpgmWord is
      variable Byte : std_logic_vector(7 downto 0);
    begin  -- sendMpgmWord
      send(WMDAT);
      for i in 1 to 10 loop
        to_bitvector (mpgm_area(mpgm_ptr), Byte);
        send(Byte);
        mpgm_ptr := mpgm_ptr + 1;
      end loop;
    end sendMpgmWord;

    procedure sendMpgmByte is
      variable Byte : std_logic_vector(7 downto 0);
    begin  -- sendMpgmByte
      send(WDALC);	-- ???????????
      to_bitvector (mpgm_area(mpgm_ptr), Byte);
      send(Byte);
      mpgm_ptr := mpgm_ptr + 1;
    end sendMpgmByte;

    procedure verifyMpgmWord is
      variable Command : std_logic_vector(7 downto 0);
    begin  -- verifyMpgmWord
      Command := RMDATA;
      for i in 9 downto 0 loop
        send(Command);
        recv(recvWord);
        assert to_integer (recvWord) = mpgm_area(mpgm_ptr);
        Command := Command - 1;
        mpgm_ptr := mpgm_ptr + 1;
      end loop;
    end verifyMpgmWord;

    procedure sendWord (constant word : in  std_logic_vector(79 downto 0)) is
    begin  -- sendWord
      send(WMDAT);
      send(word(79 downto 72));
      send(word(71 downto 64));
      send(word(63 downto 56));
      send(word(55 downto 48));
      send(word(47 downto 40));
      send(word(39 downto 32));
      send(word(31 downto 24));
      send(word(23 downto 16));
      send(word(15 downto 8));
      send(word(7 downto 0));
    end sendWord;

    procedure wrCmd1 (
      constant cmd  : in  std_logic_vector(7 downto 0);
      constant data : in  std_logic_vector(7 downto 0)) is
    begin  -- wrCmd1
      send(cmd);
      send(data);
    end wrCmd1;

    procedure wrCmd2 (
      constant cmd   : in  std_logic_vector(7 downto 0);
      constant data1 : in  std_logic_vector(7 downto 0);
      constant data2 : in  std_logic_vector(7 downto 0)) is
    begin  -- wrCmd2
      send(cmd);
      send(data1);
      send(data2);    
    end wrCmd2;
    
    procedure wrCmd8 (
      constant cmd    : in  std_logic_vector(7 downto 0);
      constant data1  : in  std_logic_vector(7 downto 0);
      constant data2  : in  std_logic_vector(7 downto 0); 
      constant data3  : in  std_logic_vector(7 downto 0);
      constant data4  : in  std_logic_vector(7 downto 0); 
      constant data5  : in  std_logic_vector(7 downto 0);
      constant data6  : in  std_logic_vector(7 downto 0); 
      constant data7  : in  std_logic_vector(7 downto 0);
      constant data8  : in  std_logic_vector(7 downto 0)) is
    begin  -- wrCmd8
      send(cmd);
      send(data1);
      send(data2); 
      send(data3);
      send(data4); 
      send(data5);
      send(data6); 
      send(data7);
      send(data8);  
    end wrCmd8;

    procedure sendToPl (constant data : in std_logic_vector(79 downto 0)) is
    begin  -- sendToPl
      wrCmd1(WCDAP, SRTOPL);
      sendWord(data);
      wrCmd1(WTIMC, SSCU);
    end sendToPl;
    
    procedure RdStatus1 (signal data : out std_logic_vector(7 downto 0)) is
    begin  -- RdStatus1
      send(RDST1);
      recv(data);
    end RdStatus1;

    procedure RdDbus (signal data : out std_logic_vector(7 downto 0)) is
    begin  -- RdDbus
      send(RDBUS);
      recv(data);
    end RdDbus;

    procedure RdTrcData (signal data : out std_logic_vector(7 downto 0)) is
    begin  
      send(RDTRC);
      recv(data);
    end RdTrcData;

    procedure WaitAccSpreq is
    begin  -- WaitAccSpreq
			loop
		    RdStatus1(recvWord);    -- Check that SP-request has disappeared
				exit when (recvWord and SPREQ) /= x"00";
			end loop;
    end WaitAccSpreq;

    procedure writeSpreq1 (
      constant param : in  std_logic_vector(7 downto 0)) is
    begin  -- writeSpreq1
      wrCmd1(WDALC, param);
      WaitAccSpreq;
    end writeSpreq1;    
    
    procedure writeSpreq2 (
      constant index : in  std_logic_vector(7 downto 0);
      constant param : in  std_logic_vector(7 downto 0)) is
    begin  -- writeSpreq2
      wrCmd2(WDCLC, index, param);
      WaitAccSpreq;
    end writeSpreq2;    

    procedure readSpreq (signal data : out std_logic_vector(7 downto 0)) is
    begin  -- readSpreq
      send(RDREG);
      recv(data);
    	wrCmd1(WTIMC, AKCC);		-- Ack the CALL SP
    end readSpreq;

    procedure WriteCRB (
      constant index : in  std_logic_vector(7 downto 0);
      constant param : in  std_logic_vector(7 downto 0)) is
    begin  -- WriteCRB
			writeSpreq2(S_WRCRB, index);	
			writeSpreq1(param);	
    end WriteCRB;    

    procedure WriteALURegWord (
      constant index : in  std_logic_vector(7 downto 0);
      constant param : in  std_logic_vector(31 downto 0)) is
    begin  -- WriteALURegWord
			writeSpreq2(S_WRALU, index);	
			writeSpreq1(param(31 downto 24));	
			writeSpreq2(S_WRALU, index+1);	
			writeSpreq1(param(23 downto 16));	
			writeSpreq2(S_WRALU, index+2);	
			writeSpreq1(param(15 downto 8));	
			writeSpreq2(S_WRALU, index+3);	
			writeSpreq1(param(7 downto 0));	
    end WriteALURegWord;    

  begin
    load_mpgm_file;
		Progress <= 0;

    ---------------------------------------------------------------------------
    -- POWER-ON SEQUENCE
    ---------------------------------------------------------------------------
    MSDIN <= '1';
    MRESET <= '1';
    -- Test mode enabled, to shorten power-on timeout
    MTEST <= '1';

    -- Wait for power-on sequence to complete
    wait until MRSTOUT = '1';

    -- Test mode disabled
    MTEST <= '0';


    wait until MRSTOUT = '0';

   
    wait for 10*HALF_CLK_C_CYCLE;
    assert false
      report "Simulation finished!"
      severity failure;     -- exit simulation
  end process;

end behav;

	
