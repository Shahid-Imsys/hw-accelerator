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
-- File       : spboot_stim.vhd
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
library work;
--use work.io_utils.all;
use work.mti_pkg.all;

entity spboot_stim is
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
end spboot_stim;

architecture behav of spboot_stim is
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
  constant RMDAT9: std_logic_vector(7 downto 0) := x"A9";-- Read microprogram data byte 9.
  constant RPDAT : std_logic_vector(7 downto 0) := x"AF";-- Read pmem data
  constant RDBUS : std_logic_vector(7 downto 0) := x"B1";-- Read contents of microprogram D-bus.
  constant RYBUS : std_logic_vector(7 downto 0) := x"C1";-- Read contents of microprogram Y-bus.
  constant RDST0 : std_logic_vector(7 downto 0) := x"D1";-- Read status 0.
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
  constant S_WRCRB	: std_logic_vector(7 downto 0) := x"0C";	-- Write CRB.
  constant S_LDIR		: std_logic_vector(7 downto 0) := x"0A";	-- Load IR.
  constant S_WRALU	: std_logic_vector(7 downto 0) := x"23";	-- Write ALU register.
  constant S_RUN		: std_logic_vector(7 downto 0) := x"1B";	-- Set run mode.
  constant S_IMMU		: std_logic_vector(7 downto 0) := x"24";	-- Initialize memory.

  -- ALU register indices
  constant ALU_SADP	: std_logic_vector(7 downto 0) := x"0C";	-- Program counter.

  -- Microprogram words
  constant Continue: std_logic_vector(79 downto 0) := x"0068806b24060aa00242";
  -- Default       
  constant Reset   : std_logic_vector(79 downto 0) := x"0068006220020aa00040";
  constant Jump00FF: std_logic_vector(79 downto 0) := x"00681d622426afa2a458";
  constant Jump0100: std_logic_vector(79 downto 0) := x"0068116224060aa08048";
  constant Jump07FF: std_logic_vector(79 downto 0) := x"00685d622426eba2a450";
  constant Jump0800: std_logic_vector(79 downto 0) := x"0068156224061aa08040";
  constant Jump0FFF: std_logic_vector(79 downto 0) := x"006859622426fba2a450";
  constant Jump1801: std_logic_vector(79 downto 0) := x"0078056224061ba08040";
  constant Jump1802: std_logic_vector(79 downto 0) := x"0068046224069aa0a040";
  constant Jump1FFF: std_logic_vector(79 downto 0) := x"007849622426fba2a450";

  signal recvWord : std_logic_vector(7 downto 0) := (others => '0');
  signal memSize  : std_logic_vector(15 downto 0);
  signal CPpar    : std_logic_vector(7 downto 0);
  signal memType  : std_logic_vector(7 downto 0);
  signal memMode  : std_logic_vector(7 downto 0);
  signal mx1_ck_int : std_logic := '1';
  signal xtal1_int   : std_logic := '1';
  constant HALF_CLK_C_CYCLE : time := 16000 ps;
  signal mpgn_cnt   : std_logic_vector( 1 downto 0):= "00";
  signal Progress	: integer;



begin  -- behav
	PA(7 downto 5) <= "LLL";	-- This is read by ROM bootloader
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
    CONSTANT not_digit : integer := -999;
    variable	l					: line;
	--  FUNCTION digit_value(c : character) RETURN integer IS
  --      BEGIN
  --         IF (c >= '0') AND (c <= '9') THEN
  --             RETURN (character'pos(c) - character'pos('0'));
  --          ELSIF (c >= 'a') AND (c <= 'f') THEN
  --              RETURN (character'pos(c) - character'pos('a') + 10);
  --          ELSIF (c >= 'A') AND (c <= 'F') THEN
  --              RETURN (character'pos(c) - character'pos('A') + 10);
  --          ELSE
  --              RETURN not_digit;
  --          END IF;
  --      END;

	--impure function init_from_file (ram_file_name : in string) return mpgm_type is
	--	FILE ram_file : text is in ram_file_name;
	--	variable ram_file_line : line;
	--	variable RAM : mpgm_type;
	--	begin
	--		--for i in rom_type'range loop
	--		for i in 0 to mpgm_size-1 loop
	--			readline(ram_file, ram_file_line);
	--			for j in 0 to ram_file_line'right loop
	--			RAM(i):=digit_value(ram_file_line(j));
	--			end loop;
	--		end loop;
	--	return RAM;
	--end function;
	--procedure load_mpgm_file is
	--begin
	--mpgm_area := init_from_file ("RAM0.HEX");
  --end procedure;

      procedure load_mpgm_file is
        file     mpgm0_file : text open read_mode is "RAM00.HEX";  -- Microprogram data file
        file     mpgm1_file : text open read_mode is "RAM11.HEX";  -- Microprogram data file
        variable mpgm_line  : line;                   -- Microprogram data line
        variable mpgm_bv_int : bit_vector(7 downto 0);
        variable mpgm_byte  : integer;                -- Microprogram data byte
        CONSTANT not_digit : integer := -999;

        -- convert a character to a value from 0 to 15
        FUNCTION digit_value(c : character) RETURN integer IS
        BEGIN
            IF (c >= '0') AND (c <= '9') THEN
                RETURN (character'pos(c) - character'pos('0'));
            ELSIF (c >= 'a') AND (c <= 'f') THEN
                RETURN (character'pos(c) - character'pos('a') + 10);
            ELSIF (c >= 'A') AND (c <= 'F') THEN
                RETURN (character'pos(c) - character'pos('A') + 10);
            ELSE
                RETURN not_digit;
            END IF;
        END;
        variable digit: integer;
      begin  -- load_mpgm_file
        mpgm_ptr := 0;
        for j in 0 to 2047 loop
          readline (mpgm0_file, mpgm_line);
          for i in 0 to mpgm_line'right loop
            digit := digit_value(mpgm_line(i));
          end loop;
          if mpgm_line'length > 0 then
            assert mpgm_ptr < mpgm_size
              report "Microprogram HEX file too big!"
              severity failure;                 -- exit simulation
             mpgm_byte := digit;     --CJ
            mpgm_area(mpgm_ptr) := mpgm_byte;
            mpgm_ptr := mpgm_ptr + 1;
          end if;
        end loop;
        for j in 0 to 2047 loop
          readline (mpgm1_file, mpgm_line);
          for i in 0 to mpgm_line'right loop
            digit := digit_value(mpgm_line(i));
          end loop;
          if mpgm_line'length > 0 then
            assert mpgm_ptr < mpgm_size
              report "Microprogram HEX file too big!"
              severity failure;                 -- exit simulation
            mpgm_byte := digit;
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
      variable s_start : integer:=0;
    begin  -- send
      shift_reg := word & "00";
      MSDIN <= '1';
        if rising_edge(MCKOUT0)then
        wait for 1 ns;
        if s_start /=10 then
            for i in 0 to 8 loop
            shift_reg(i) := shift_reg(i+1);       
            MSDIN <= shift_reg(0);
            end loop;
            s_start := s_start + 1;
        elsif s_start = 10 then
            s_start := 0;
        end if;    
        --wait until rising_edge(MCKOUT0);
        end if;

    end send;
    
    procedure recv (signal word : out std_logic_vector(7 downto 0)) is
      variable shift_reg : std_logic_vector(7 downto 0);
      variable p_start : integer:= 0;
    begin
          if rising_edge(MCKOUT0)then
          if p_start= 0 and MSDOUT = '0' then
                     p_start := 1;
          elsif p_start /= 0 then
              if p_start /= 9 then
                  for i in 0 to 6 loop
                  shift_reg(i) := shift_reg(i+1);
                  end loop;    
                  shift_reg(7) := MSDOUT;
                  p_start := p_start +1;
              elsif p_start = 9 then
                  p_start := 0;
                  word <= shift_reg;
              end if;
          end if;
          end if;
          --wait until rising_edge(MCKOUT0);
    end recv;

    procedure sendMpgmWord is
      variable Byte : std_logic_vector(7 downto 0);
    begin  -- sendMpgmWord
      send(WMDAT);
      for i in 1 to 10 loop
        --to_bitvector (mpgm_area(mpgm_ptr), Byte);
        --Byte := to_stdlogicvector(mpgm_area(mpgm_ptr));
        Byte := std_logic_vector(to_unsigned(mpgm_area(mpgm_ptr),8));
        send(Byte);
        mpgm_ptr := mpgm_ptr + 1;
      end loop;
    end sendMpgmWord;

    procedure sendMpgmByte is
      variable Byte : std_logic_vector(7 downto 0);
    begin  -- sendMpgmByte
      send(WDALC);	-- ???????????
      --to_bitvector (mpgm_area(mpgm_ptr), Byte);
      Byte := std_logic_vector(to_unsigned(mpgm_area(mpgm_ptr),8));
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
			writeSpreq2(index, param(31 downto 24));	
			writeSpreq2(S_WRALU, index+1);	
			writeSpreq2(index, param(23 downto 16));	
			writeSpreq2(S_WRALU, index+2);	
			writeSpreq2(index, param(15 downto 8));	
			writeSpreq2(S_WRALU, index+3);	
			writeSpreq2(index, param(7 downto 0));	
    end WriteALURegWord;    

  begin
    load_mpgm_file;
		Progress <= 0;

    ---------------------------------------------------------------------------
    -- POWER-ON SEQUENCE
    ---------------------------------------------------------------------------
    MSDIN <= '1';

		-- Wait for power-on reset to release
    MTEST <= '1';							-- Test mode enabled, to shorten reset timeout
    MRESET <= '1';
    --wait until MRSTOUT = '1';	-- Wait for reset sequence to complete signal deleted CJ
    MTEST <= '0';							-- Test mode disabled
		Progress <= 1;

		-- Detect processor model
    wrCmd1(WCDAP, DISALL);	-- Disable all data paths. 
    wrCmd1(WTIMC, SSCU);		-- Make sure processor is stopped
    wrCmd1(WTIMC, AKCC);		-- and not requesting SP attention.
    RdStatus1(recvWord);    -- Check that PLCPEN is set
    assert recvWord(1) = '1'    
      report "!!!!!!!!!!!!!!!! Assertion violation !!!!!!!!!!!!!!!!!!!!!!"
      severity failure;     -- exit simulation
    sendWord(Reset);				-- Load MPLL with Reset word
    wrCmd1(WCDAP, SRTOPL);	-- Open data path to PL from MPLL
    wrCmd1(WTIMC, SSCU);		-- Load Reset into PL (and execute all zero word)
    sendWord(Jump0FFF);			-- Load MPLL with Jump0FFF word    
    wrCmd1(WTIMC, SSCU);		-- Load Jump0FFF into PL and execute Reset
    sendWord(Continue);			-- Load MPLL with Continue word
    wrCmd1(WTIMC, SSCU);		-- Load Continue into PL and execute Jump0FFF
    wrCmd1(WTIMC, SSCU);		-- Clock once more on GP2000
    send(RMDAT9);						-- Get the second byte of the first microprogram					
    recv(recvWord);					-- word, and check that it is 0x07
    assert recvWord = x"07"	    
      report "!!!!!!!!!!!!!!!! Assertion violation !!!!!!!!!!!!!!!!!!!!!!"
      severity failure;     -- exit simulation
    wrCmd1(WCDAP, DISALL);	-- Disable all data paths. 
		Progress <= 2;

    ---------------------------------------------------------------------------
    -- LOAD MICROPROGRAM
    ---------------------------------------------------------------------------
		-- Do a reset pulse, then wait for reset to release
    MTEST <= '1';							-- Test mode enabled, to shorten reset timeout
    MRESET <= '0';
    wait for 10*HALF_CLK_C_CYCLE;
    MRESET <= '1';
    --wait until MRSTOUT = '1';	-- Wait for reset sequence to complete  --signal deleted CJ
    MTEST <= '0';							-- Test mode disabled
	Progress <= 3;
    -- Set up for loading microprogram at address 0x0800 (in MPRAM0)
    wrCmd1(WCDAP, DISALL);	-- Disable all data paths. 
    sendWord(Reset);				-- Load MPLL with Reset word
    wrCmd1(WCDAP, SRTOPL);	-- open data path to PL from MPLL
    wrCmd1(WTIMC, SSCU);		-- Load Reset into PL (and execute all zero word)
    sendWord(Jump0FFF);			-- Load MPLL with Jump0FFF word    
    wrCmd1(WTIMC, SSCU);		-- Load Jump0FFF into PL and execute Reset
    sendWord(Continue);			-- Load MPLL with Continue word
    wrCmd1(WTIMC, SSCU);		-- Load Continue into PL and execute Jump0FFF
    wrCmd1(WCDAP, WRMEM);		-- Make PL hold, activate WE to memory
    -- Write the first 2k word block
    mpgm_ptr := 0;
    for i in 1 to 2048 loop	-- Write 2k words
      sendMpgmWord;					-- Send a word to MPLL 
      wrCmd1(WTIMC, SSCU);	-- Write word in memory and execute Continue
    end loop;
		Progress <= 4;
    -- Set up for loading microprogram at address 0x1800 (in MPRAM1)
    sendWord(Reset);				-- Load MPLL with Reset word
    wrCmd1(WCDAP, SRTOPL);	-- open data path to PL from MPLL
    wrCmd1(WTIMC, SSCU);		-- Load Reset into PL (and execute all zero word)
    sendWord(Jump1FFF);			-- Load MPLL with Jump1FFF word    
    wrCmd1(WTIMC, SSCU);		-- Load Jump1FFF into PL and execute Reset
    sendWord(Continue);			-- Load MPLL with Continue word
    wrCmd1(WTIMC, SSCU);		-- Load Continue into PL and execute Jump1FFF
    wrCmd1(WCDAP, WRMEM);		-- Make PL hold, activate WE to memory
    -- Write the second 2k word block
    mpgm_ptr := mpgm_size/2;
    for i in 1 to 2048 loop	-- Write 2k words
      sendMpgmWord;					-- Send a word to MPLL 
      wrCmd1(WTIMC, SSCU);	-- Write word in memory and execute Continue
    end loop;
		Progress <= 5;
    -- Set up for loading patch data at address 0x0100 (in PMEM)
    wrCmd1(WCDAP, SRTOPL); -- open data path to PL from MPLL
    sendWord(Jump00FF);    -- Load MPLL with Jump00FF word    
    wrCmd1(WTIMC, SSCU);   -- Load Jump00FF into PL (and execute Continue)
    sendWord(Continue);    -- Load MPLL with Continue word
    wrCmd1(WTIMC, SSCU);   -- Load Continue into PL and execute Jump00FF
    wrCmd1(WCDAP, WRMEM);  -- Make PL hold, activate WE to memory
    -- Write in the patch memory. Should write 00 at PMEM address
   -- 0x040, 01 at 0x240, 10 at 0x440 and 11 at 0x640. The corresponding
    -- patched logical ROM addresses are 0x0100, 0x1100, 0x2100 and 0x2900.
    -- Finally, the patched-in RAM areas start at N/A, 0x1E80, 0x1F00, 0x1F80.
    wrCmd1(WMDAT1, x"00"); -- Send a byte to MPLL (only two bits used) 
    wrCmd1(WTIMC, SSCU);   -- Write word in memory and execute Continue
    wrCmd1(WMDAT1, x"01"); -- Send a byte to MPLL (only two bits used) 
    wrCmd1(WTIMC, SSCU);   -- Write word in memory and execute Continue
    wrCmd1(WMDAT1, x"02"); -- Send a byte to MPLL (only two bits used) 
    wrCmd1(WTIMC, SSCU);   -- Write word in memory and execute Continue
    wrCmd1(WMDAT1, x"03"); -- Send a byte to MPLL (only two bits used) 
    wrCmd1(WTIMC, SSCU);   -- Write word in memory and execute Continu
    ---------------------------------------------------------------------------
    -- VERIFY MICROPROGRAM
    ---------------------------------------------------------------------------
    -- Set up for reading microprogram at address 0x0800
    wrCmd1(WCDAP, SRTOPL); -- open data path to PL from MPLL
    sendWord(Jump0800);    -- Load MPLL with Jump0800 word    
    wrCmd1(WTIMC, SSCU);   -- Load Jump0800 into PL (and execute Continue)
    sendWord(Continue);    -- Load MPLL with Continue word
    wrCmd1(WTIMC, SSCU);   -- Load Continue into PL and execute Jump0800
    wrCmd1(WCDAP, DISALL); -- Make PL hold
    -- Read and verify the first 2k word block
    mpgm_ptr := 0;
    for i in 1 to 2 loop   -- Verify two words
      verifyMpgmWord;      -- Read and verify a micro program word 
      wrCmd1(WTIMC, SSCU); -- Execute Continue
    end loop;
    -- Set up for reading microprogram at address 0x1802
    wrCmd1(WCDAP, SRTOPL); -- open data path to PL from MPLL
    sendWord(Jump1802);    -- Load MPLL with Jump1802 word    
    wrCmd1(WTIMC, SSCU);   -- Load Jump1802 into PL (and execute Continue)
    sendWord(Continue);    -- Load MPLL with Continue word
    wrCmd1(WTIMC, SSCU);   -- Load Continue into PL and execute Jump1802
    wrCmd1(WCDAP, DISALL); -- Make PL hold
    -- Read and verify the second 2k word block
    mpgm_ptr := mpgm_size/2;
    for i in 1 to 2 loop   -- Verify two words
      verifyMpgmWord;      -- Read and verify a micro program word 
      wrCmd1(WTIMC, SSCU); -- Execute Continue
    end loop;
    -- Set up for reading patch data at address 0x0100
    wrCmd1(WCDAP, SRTOPL); -- open data path to PL from MPLL
    sendWord(Jump0100);    -- Load MPLL with Jump0100 word    
    wrCmd1(WTIMC, SSCU);   -- Load Jump0100 into PL (and execute Continue)
    sendWord(Continue);    -- Load MPLL with Continue word
    wrCmd1(WTIMC, SSCU);   -- Load Continue into PL and execute Jump0100
    wrCmd1(WCDAP, DISALL); -- Make PL hold
    -- Read and verify patch data.
    for i in 0 to 3 loop   -- Verify four two-bit words
      send(RPDAT);         -- Read and verify a patch word
      recv(recvWord);
      assert (recvWord = std_logic_vector(to_unsigned(i, 8)))
        report "Patch data write/read error!"
        severity note;
      wrCmd1(WTIMC, SSCU); -- Execute Continue
    end loop;
    
    ---------------------------------------------------------------------------
    -- START TEST MICROPROGRAM
    ---------------------------------------------------------------------------
    wrCmd1(WCDAP, SRTOPL);  -- open data path to PL from MPLL
    sendWord(Jump0800);     -- Load MPLL with Jump0800 word    
    wrCmd1(WTIMC, SSCU);    -- Load Jump0800 into PL (and execute Continue)
    wrCmd1(WCDAP, ENPL);    -- open data path to PL from memor
    wrCmd1(WDALC, x"00");   -- Issue SP-request
    RdStatus1(recvWord);    -- Check that request is set
    assert recvWord = x"07"
      report "Set SP-request error!"
      severity note;
    wrCmd1(WTIMC, RUCU);    -- Set run mode, will start from address 0x0800
    RdStatus1(recvWord);    -- Check that SP-request has disappeared
    assert recvWord = x"A7"
      report "Reset SP-request error!"
      severity note;
    wrCmd2(WDCLC, x"05", x"40"); -- Issue SP-reques
    ---------------------------------------------------------------------------
    -- GET MEMORY SIZE AND TYPE FROM TEST MICROPROGRAM
    ---------------------------------------------------------------------------
    -- WaitTMpgm No.1
    if MIRQOUT = '0'  then    
    RdDbus(memSize(15 downto 8));
    wrCmd1(WTIMC, AKCC);
    end if;
    
    -- WaitTMpgm No.2
    if MIRQOUT = '0' then
    RdDbus(memSize(7 downto 0));
    wrCmd1(WTIMC, AKCC);
      
    assert false
      report "Check memory size information!"
      severity note;    
    end if;
    -- WaitTMpgm No.3
    if MIRQOUT = '0' then 
    RdDbus(memType);
    wrCmd1(WTIMC, AKCC);      
    
    assert false
      report "Check memory type information!"
      severity note;
    end if;
    -- WaitTMpgm No.4
    if MIRQOUT = '0' then
    RdDbus(memMode);
    wrCmd1(WTIMC, AKCC);
     
    assert false
      report "Check memory mode information!"
      severity note;    
    end if;
  --  ---------------------------------------------------------------------------
  --  -- SEND A FEW MICROPROGRAM WORDS THAT THE TEST PROGRAM CAN LOAD
  --  ---------------------------------------------------------------------------
  --  mpgm_ptr := mpgm_size-40;
  --  for i in 1 to 40 loop   -- Send four words, ten bytes per word
  --    sendMpgmByte;         -- Send a microprogram byte as a SPREQ 
  --  end loop;
  --  ---------------------------------------------------------------------------
  --  -- CONTINUE COMMUNICATE WITH TEST MICROPROGRAM
  --  ---------------------------------------------------------------------------
  --  -- WaitTMpgm No.5
  --  wait until MIRQOUT = '0';
  --  RdDbus(CPpar);
  --  wrCmd1(WTIMC, AKCC);    
  --  if CPpar /= x"00" then
  --    assert false
  --      report "Error: Hardware failure detected -" severity warning;
  --    if CPpar <= x"40" then
  --      assert false report "Error in GPU." severity note;
  --    elsif CPpar >= x"41" and CPpar <= x"4F" then
  --      assert false report "Error in map memory." severity note;
  --    elsif CPpar >= x"81" and CPpar <= x"8F" then
  --      assert false report "Error in primary memory." severity note; 
  --    elsif CPpar >= x"90" and CPpar <= x"9F" then
  --      assert false report "Error in ADL stepping." severity note;
  --    elsif CPpar >= x"A0" and CPpar <= x"AF" then
  --      assert false report "Error in PC FIFO." severity note;
  --    elsif CPpar = x"FF" then
  --      assert false report "uProgram derailed." severity note;
  --    else
  --      assert false report "Unknown GPU error." severity note;      
  --    end if;    
  --  else
  --    assert false report "Test OK!" severity note;
  --  end if;
  --  ---------------------------------------------------------------------------
  --  -- SET UP DEBUG TRACE FUNCTION
  --  ---------------------------------------------------------------------------
  --  
  --  wrCmd8(WSTRC, x"00", x"00", x"00", x"00", x"00", x"0E", x"41", x"41");
  --                           -- trig at "0E00 41 41" 
  --  wrCmd1(WGTRC, x"41");    -- go trace, trig point beginning 
  --  
  --  ---------------------------------------------------------------------------
  --  -- READ TRACE DATA
  --  ---------------------------------------------------------------------------
  --  RdStatus1(recvWord);     -- Check that trace is running
  --  assert recvWord(3) = '1';
  --  wrCmd1(WGTRC, x"40");    -- reset trace
  --  RdStatus1(recvWord);     -- Check that trace is reset
  --  assert recvWord(3) = '0';    
  --  RdTrcData(recvWord);
  --  RdTrcData(recvWord);
  --  RdTrcData(recvWord);
  --  RdTrcData(recvWord);
  -- 
  --  wait for 10*HALF_CLK_C_CYCLE;
  --  assert false
  --    report "Simulation finished!"
  --    severity failure;     -- exit simulation
  end process;

end behav;

	
