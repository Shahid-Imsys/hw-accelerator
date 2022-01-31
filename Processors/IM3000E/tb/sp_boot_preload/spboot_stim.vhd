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
-- Date                                 Version         Author  Description
-- 2006-02-22           1.00                    CB                      Created.
-------------------------------------------------------------------------------
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity spboot_stim is
  port(
    MX1_CK  : inout std_logic;
    MXOUT   : in    std_logic;
    MEXEC   : in    std_logic;
    MCKOUT0 : in    std_logic;
    MCKOUT1 : in    std_logic;
    MSDIN   : out   std_logic;
    MSDOUT  : in    std_logic;
    MIRQOUT : in    std_logic;
    MBYPASS : out   std_logic;
    MRESET  : out   std_logic;
    MRSTOUT : in    std_logic;
    MTEST   : out   std_logic;
    MWAKE   : out   std_logic;
    MIRQ0   : out   std_logic;
    MIRQ1   : out   std_logic;
    MRXOUT  : in    std_logic;
    PA      : inout std_logic_vector(7 downto 0);
    PB      : in    std_logic_vector(7 downto 0);
    XTAL1   : inout std_logic;
    MPORDIS : out   std_logic
    );
end spboot_stim;

architecture behav of spboot_stim is

  -- SP commands
  constant WCNOP  : std_logic_vector(7 downto 0) := x"00";  -- No operation.
  constant WCDAP  : std_logic_vector(7 downto 0) := x"11";  -- Control data paths.
  constant WMDAT  : std_logic_vector(7 downto 0) := x"2A";  -- Write microprogram data.
  constant WMDAT1 : std_logic_vector(7 downto 0) := x"21";  -- Write microprogram data, low byte.
  constant WTIMC  : std_logic_vector(7 downto 0) := x"31";  -- Control timing. 
  constant WDCLC  : std_logic_vector(7 downto 0) := x"42";  -- Write in CLC- and ALC-reg & gen SPREQ.
  constant WDALC  : std_logic_vector(7 downto 0) := x"51";  -- Write in ALC-reg & generate SPREQ.
  constant WSTRC  : std_logic_vector(7 downto 0) := x"68";  -- Set mask and trig word in trace.
  constant WGTRC  : std_logic_vector(7 downto 0) := x"71";  -- Go trace.
  constant RMMAD  : std_logic_vector(7 downto 0) := x"81";  -- Read current microprogram address (MSB).
  constant RLMAD  : std_logic_vector(7 downto 0) := x"91";  -- Read current microprogram address (LSB).
  constant RMDATA : std_logic_vector(7 downto 0) := x"AA";  -- Read microprogram data byte 10 (msb).
  constant RMDAT9 : std_logic_vector(7 downto 0) := x"A9";  -- Read microprogram data byte 9.
  constant RPDAT  : std_logic_vector(7 downto 0) := x"AF";  -- Read pmem data
  constant RDBUS  : std_logic_vector(7 downto 0) := x"B1";  -- Read contents of microprogram D-bus.
  constant RYBUS  : std_logic_vector(7 downto 0) := x"C1";  -- Read contents of microprogram Y-bus.
  constant RDST0  : std_logic_vector(7 downto 0) := x"D1";  -- Read status 0.
  constant RDST1  : std_logic_vector(7 downto 0) := x"E1";  -- Read status 1.
  constant RDTRC  : std_logic_vector(7 downto 0) := x"F1";  -- Read trace.

  -- SP command parameters
  -- WCDAP
  constant DISALL : std_logic_vector(7 downto 0) := x"46";  -- PL holds last instruction.
  constant ENPL   : std_logic_vector(7 downto 0) := x"47";  -- PL is loaded from memory.
  constant METOPL : std_logic_vector(7 downto 0) := x"47";  -- PL is loaded from memory.
  constant SRTOPL : std_logic_vector(7 downto 0) := x"44";  -- PL is loaded from MPLL.   
  constant WRMEM  : std_logic_vector(7 downto 0) := x"42";  -- PL holds last, WE active 
  -- WTIMC
  constant SSCU   : std_logic_vector(7 downto 0) := x"03";  -- Stop mode.
  constant RUCU   : std_logic_vector(7 downto 0) := x"04";  -- Run mode.
  constant AKCC   : std_logic_vector(7 downto 0) := x"05";  -- SP acknowledge.

  -- RDST1 return bitmasks
  constant SPREQ : std_logic_vector(7 downto 0) := x"20";  -- SP request (active low)

  -- SPREQ indices
  constant S_WRCRB : std_logic_vector(7 downto 0) := x"0C";  -- Write CRB.
  constant S_LDIR  : std_logic_vector(7 downto 0) := x"0A";  -- Load IR.
  constant S_WRALU : std_logic_vector(7 downto 0) := x"23";  -- Write ALU register.
  constant S_RUN   : std_logic_vector(7 downto 0) := x"1B";  -- Set run mode.
  constant S_STEP  : std_logic_vector(7 downto 0) := x"1A";
  constant S_IMMU  : std_logic_vector(7 downto 0) := x"24";  -- Initialize memory.
  constant S_RDGM  : std_logic_vector(7 downto 0) := x"10";  -- Read GMEM
  constant S_WRGM  : std_logic_vector(7 downto 0) := x"11";  -- Write GMEM

  -- ALU register indices
  constant ALU_SADP : std_logic_vector(7 downto 0) := x"0C";  -- Program counter.

  -- Microprogram words
  constant Continue : std_logic_vector(79 downto 0) := x"0068806b24060aa00242";
  -- Default       
  constant Reset    : std_logic_vector(79 downto 0) := x"0068006220020aa00040";
  constant Jump00FF : std_logic_vector(79 downto 0) := x"00681d622426afa2a458";
  constant Jump0100 : std_logic_vector(79 downto 0) := x"0068116224060aa08048";
  constant Jump07FF : std_logic_vector(79 downto 0) := x"00685d622426eba2a450";
  constant Jump0800 : std_logic_vector(79 downto 0) := x"0068156224061aa08040";
  constant Jump0FFF : std_logic_vector(79 downto 0) := x"006859622426fba2a450";
  constant Jump17FF : std_logic_vector(79 downto 0) := x"00784d622426eba2a450";
  constant Jump1800 : std_logic_vector(79 downto 0) := x"0078056224061AA08040";
  constant Jump1801 : std_logic_vector(79 downto 0) := x"0078056224061ba08040";
  constant Jump1802 : std_logic_vector(79 downto 0) := x"0068046224069aa0a040";
  constant Jump1FFF : std_logic_vector(79 downto 0) := x"007849622426fba2a450";

  signal recvWord           : std_logic_vector(7 downto 0) := (others => '0');
  signal memSize            : std_logic_vector(15 downto 0);
  signal CPpar              : std_logic_vector(7 downto 0);
  signal memType            : std_logic_vector(7 downto 0);
  signal memMode            : std_logic_vector(7 downto 0);
  signal mx1_ck_int         : std_logic                    := '1';
  signal xtal1_int          : std_logic                    := '1';
  constant HALF_CLK_C_CYCLE : time                         := 16000 ps;

  signal Progress : integer := -1;

begin  -- behav
  PA(7 downto 5) <= "000";              -- This is read by ROM bootloader
  PA(4 downto 3) <= "01";               -- Set SP communication at /2 speed
  PA(2 downto 1) <= "01";               -- Set PLL multiplier to 4
  PA(0)          <= '1';                -- Set PLL divider to 1

  -- This emulates a 31.25 MHz crystal
  mx1_ck_int <= not mx1_ck_int after HALF_CLK_C_CYCLE;
  MX1_CK     <= mx1_ck_int;

  -- This emulates a 32768 Hz crystal connected to RXOSC
  --xtal1_int <= not xtal1_int after 15259 ns;
  xtal1_int <= not xtal1_int after 1 us;
  XTAL1     <= xtal1_int;

  -- Power-on reset enabled
  MPORDIS <= '0';

  -- Bypass disabled
  MBYPASS <= '0';

  -- Wake-up signal inactive
  MWAKE <= '0';

  MIRQ0 <= '1';
  MIRQ1 <= '1';

  process
    constant mpgm_size : integer := 2*2048*10;  -- Microprogram size in bytes
    type mpgm_type is array (mpgm_size - 1 downto 0) of integer;
    variable mpgm_area : mpgm_type;             -- Microprogram data area
    variable mpgm_ptr  : integer;               -- Microprogram data pointer
    variable l         : line;
    variable gmem_data : std_logic_vector(31 downto 0) := (others => '0');

    procedure send (constant word : in std_logic_vector(7 downto 0)) is
      variable shift_reg : std_logic_vector(9 downto 0);
    begin  -- send
      shift_reg := word & "00";
      MSDIN     <= '1';
      for i in 0 to 10 loop
        wait until rising_edge(MCKOUT0);
        wait for 1 ns;
        shift_reg := '1' & shift_reg(9 downto 1);
        MSDIN     <= shift_reg(0);
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

    procedure sendWord (constant word : in std_logic_vector(79 downto 0)) is
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
      constant cmd  : in std_logic_vector(7 downto 0);
      constant data : in std_logic_vector(7 downto 0)) is
    begin  -- wrCmd1
      send(cmd);
      send(data);
    end wrCmd1;

    procedure wrCmd2 (
      constant cmd   : in std_logic_vector(7 downto 0);
      constant data1 : in std_logic_vector(7 downto 0);
      constant data2 : in std_logic_vector(7 downto 0)) is
    begin  -- wrCmd2
      send(cmd);
      send(data1);
      send(data2);
    end wrCmd2;

    procedure wrCmd8 (
      constant cmd   : in std_logic_vector(7 downto 0);
      constant data1 : in std_logic_vector(7 downto 0);
      constant data2 : in std_logic_vector(7 downto 0);
      constant data3 : in std_logic_vector(7 downto 0);
      constant data4 : in std_logic_vector(7 downto 0);
      constant data5 : in std_logic_vector(7 downto 0);
      constant data6 : in std_logic_vector(7 downto 0);
      constant data7 : in std_logic_vector(7 downto 0);
      constant data8 : in std_logic_vector(7 downto 0)) is
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
        RdStatus1(recvWord);  -- Check that SP-request has disappeared
        exit when (recvWord and SPREQ) /= x"00";
      end loop;
    end WaitAccSpreq;

    procedure writeSpreq1 (
      constant param : in std_logic_vector(7 downto 0)) is
    begin  -- writeSpreq1
      wrCmd1(WDALC, param);
      WaitAccSpreq;
    end writeSpreq1;

    procedure writeSpreq2 (
      constant index : in std_logic_vector(7 downto 0);
      constant param : in std_logic_vector(7 downto 0)) is
    begin  -- writeSpreq2
      wrCmd2(WDCLC, std_logic_vector(index), param);
      WaitAccSpreq;
    end writeSpreq2;

    procedure readSpreq (
      variable result : out std_logic_vector(7 downto 0)) is
    begin  -- procedure readSpreq
      result := x"00";
    end procedure readSpreq;

    procedure WriteCRB (
      constant index : in std_logic_vector(7 downto 0);
      constant param : in std_logic_vector(7 downto 0)) is
    begin  -- WriteCRB
      writeSpreq2(S_WRCRB, index);
      writeSpreq1(param);
    end WriteCRB;

    procedure WriteGMEM (
      constant index : in std_logic_vector(7 downto 0);
      constant param : in std_logic_vector(7 downto 0)) is
    begin  -- WriteGMEM
      -- writeSpreq2(S_WRGM, index); -- Write 0x89 to GM register #23 
      -- writeSpreq1(param); 

      wrCmd2(WDCLC, S_WRGM, index);
      --WaitAccSpreq;
      RdStatus1(recvWord);
      while (recvWord and SPREQ) /= x"00" loop
        RdStatus1(recvWord);
      end loop;
      wrCmd1(WDALC, param);
    end WriteGMEM;

    procedure readGMEMWord (
      constant index  : in  std_logic_vector(7 downto 0);
      variable result : out std_logic_vector(31 downto 0)) is      
    begin  -- procedure readGMEMWord
      for i in 0 to 3 loop
        writeSpreq2(S_RDGM, std_logic_vector(unsigned(index) + i));
        readSpreq(result(7+i*8 downto i*8));
      end loop;  -- i
    end procedure readGMEMWord;

    procedure WriteALURegWord (
      constant index : in unsigned(7 downto 0);
      constant param : in std_logic_vector(31 downto 0)) is

    begin  -- WriteALURegWord
      writeSpreq2(S_WRALU, std_logic_vector(index));
      writeSpreq2(std_logic_vector(index), param(31 downto 24));
      writeSpreq2(S_WRALU, std_logic_vector(index+1));
      writeSpreq2(std_logic_vector(index), param(23 downto 16));
      writeSpreq2(S_WRALU, std_logic_vector(index+2));
      writeSpreq2(std_logic_vector(index), param(15 downto 8));
      writeSpreq2(S_WRALU, std_logic_vector(index+3));
      writeSpreq2(std_logic_vector(index), param(7 downto 0));
    end WriteALURegWord;

  begin
    MRESET <= '0';
    wait for 10 ns;

    Progress <= 0;

    ---------------------------------------------------------------------------
    -- POWER-ON SEQUENCE
    ---------------------------------------------------------------------------
    MSDIN <= '1';

    -- Wait for power-on reset to release
    MTEST  <= '1';             -- Test mode enabled, to shorten reset timeout
    MRESET <= '1';
    wait until MRSTOUT = '1';           -- Wait for reset sequence to complete
    MTEST  <= '0';                      -- Test mode disabled

    ---------------------------------------------------------------------------
    -- START TEST MICROPROGRAM
    ---------------------------------------------------------------------------
    wrCmd1(WCDAP, SRTOPL);              -- open data path to PL from MPLL
    --sendWord(Jump0800);     -- Load MPLL with Jump0800 word    
    sendWord(Jump1800);                 -- Load MPLL with Jump0800 word    
    wrCmd1(WTIMC, SSCU);    -- Load Jump0800 into PL (and execute Continue)
    wrCmd1(WCDAP, ENPL);                -- open data path to PL from memory

    wrCmd1(WDALC, x"00");               -- Issue SP-request
    RdStatus1(recvWord);                -- Check that request is set
    assert recvWord = x"07"
      report "Set SP-request error!"
      severity note;
    wrCmd1(WTIMC, RUCU);  -- Set run mode, will start from address 0x0800
    RdStatus1(recvWord);  -- Check that SP-request has disappeared
    assert recvWord = x"A7"
      report "Reset SP-request error!"
      severity note;
    wrCmd2(WDCLC, x"05", x"40");        -- Issue SP-request
    Progress <= 9;
    ---------------------------------------------------------------------------
    -- GET MEMORY SIZE AND TYPE FROM TEST MICROPROGRAM
    ---------------------------------------------------------------------------
    -- WaitTMpgm No.1
    wait until MIRQOUT = '0';
    RdDbus(memSize(15 downto 8));
    wrCmd1(WTIMC, AKCC);

    -- WaitTMpgm No.2
    wait until MIRQOUT = '0';
    RdDbus(memSize(7 downto 0));
    wrCmd1(WTIMC, AKCC);
    assert false
      report "Check memory size information!"
      severity note;

    -- WaitTMpgm No.3
    wait until MIRQOUT = '0';
    RdDbus(memType);
    wrCmd1(WTIMC, AKCC);
    assert false
      report "Check memory type information!"
      severity note;

    -- WaitTMpgm No.4
    wait until MIRQOUT = '0';
    RdDbus(memMode);
    wrCmd1(WTIMC, AKCC);
    assert false
      report "Check memory mode information!"
      severity note;
    Progress <= 10;

    ---------------------------------------------------------------------------
    -- CONTINUE COMMUNICATE WITH TEST MICROPROGRAM
    ---------------------------------------------------------------------------
    -- WaitTMpgm No.5
    if MIRQOUT /= '0' then
      wait until MIRQOUT = '0';
    end if;

    -- Progress <= 33;
    -- WriteGMEM(x"23", x"89");
    -- Progress <= 34;
    -- readGMEMWord(x"23", gmem_data);

    progress <= 11;
    
    RdDbus(CPpar);
    wrCmd1(WTIMC, AKCC);
    if CPpar /= x"00" then
      assert false
        report "Error: Hardware failure detected -" severity warning;
      if CPpar <= x"40" then
        --assert false report "Error in GPU. CPpar: " & to_hstring(CPpar) severity note;
        assert false report "Error in GPU" severity note;
      elsif CPpar >= x"41" and CPpar <= x"4F" then
        --assert false report "Error in map memory. CPpar: " & to_hstring(CPpar) severity note;
        assert false report "Error in map memory" severity note;
      elsif CPpar >= x"81" and CPpar <= x"8F" then
        --assert false report "Error in primary memory. CPpar: " & to_hstring(CPpar) severity note;
        assert false report "Error in primary memory" severity note;
      elsif CPpar >= x"90" and CPpar <= x"9F" then
        -- assert false report "Error in ADL stepping. CPpar: " & to_hstring(CPpar) severity note;
        assert false report "Error in ADL stepping" severity note;
      elsif CPpar >= x"A0" and CPpar <= x"AF" then
        -- assert false report "Error in PC FIFO. CPpar: " & to_hstring(CPpar) severity note;
        assert false report "Error in PC FIFO." severity note;
      elsif CPpar = x"FF" then
        -- assert false report "uProgram derailed. CPpar: " & to_hstring(CPpar) severity note;
        assert false report "uProgram derailed." severity note;
      else
        -- assert false report "Unknown GPU error. CPpar: " & to_hstring(CPpar) severity note; 
        assert false report "Unknown GPU error." severity note;
      end if;
    else
      assert false report "Test OK!" severity note;
    end if;
    Progress <= 12;
    ---------------------------------------------------------------------------
    -- SET UP DEBUG TRACE FUNCTION
    ---------------------------------------------------------------------------

    wrCmd8(WSTRC, x"00", x"00", x"00", x"00", x"00", x"0E", x"41", x"41");
    -- trig at "0E00 41 41" 
    wrCmd1(WGTRC, x"41");               -- go trace, trig point beginning 
    Progress <= 13;
    ---------------------------------------------------------------------------
    -- READ TRACE DATA
    ---------------------------------------------------------------------------
    RdStatus1(recvWord);                -- Check that trace is running
    assert recvWord(3) = '1';
    wrCmd1(WGTRC, x"40");               -- reset trace
    RdStatus1(recvWord);                -- Check that trace is reset
    assert recvWord(3) = '0';
    RdTrcData(recvWord);
    RdTrcData(recvWord);
    RdTrcData(recvWord);
    RdTrcData(recvWord);

    wait for 10*HALF_CLK_C_CYCLE;
    assert false
      report "Simulation finished!"
      severity failure;                 -- exit simulation
  end process;

end behav;


