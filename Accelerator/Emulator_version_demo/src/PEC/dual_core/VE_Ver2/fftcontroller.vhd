-- FFT address generator
-- Oscar Gustafsson, oscar.gustafsson@liu.se, 2022-02-04

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.instructiontypes.all;
use work.vetypes.all;


entity fftcontroller is
  generic (
    simulation : boolean := true              -- Debug
    );
  port (
    clk          : in  std_logic;
    en           : in  std_logic;
    start        : in  std_logic;
    stages       : in  unsigned(2 downto 0);  -- N = 2^(stages + 2), at most 7
    data0addr    : out std_logic_vector(7 downto 0);
    data1addr    : out std_logic_vector(7 downto 0);
    tfaddr       : out std_logic_vector(7 downto 0);
    read_en      : out std_logic;
    write_en     : out std_logic;
    memreg_c     : out memreg_ctrl;
    writebuff_c  : out memreg_ctrl;
    done         : out std_logic;
    finalstage   : out std_logic;
    inst_arith   : out instruction;
    inst_add     : out ppctrl_t;
    inst_shift   : out ppshift_shift_ctrl;
    inst_addbias : out ppshift_addbias_ctrl;
    inst_clip    : out ppshift_clip_ctrl;
    stall        : out unsigned(7 downto 0)
    );
end entity;


architecture first of fftcontroller is
  signal cyclecounter      : integer range 0 to 3         := 0;
  signal shifted_bfcounter : unsigned(7 downto 0)         := (others => '0');
  signal bfmax             : unsigned(7 downto 0)         := (others => '0');
  signal bfcounter         : unsigned(7 downto 0)         := (others => '0');
  signal maskcount         : unsigned(7 downto 0)         := (others => '0');
  signal maskreg           : unsigned(7 downto 0)         := (others => '0');
  signal stagemax          : unsigned(3 downto 0)         := (others => '0');
  signal stagecounter      : unsigned(3 downto 0)         := (others => '0');
  signal done_int          : std_logic                    := '0';
  signal genenable         : std_logic                    := '0';
  signal bfenable          : std_logic                    := '0';
  signal stageenable       : std_logic                    := '0';
  signal data0addrtmp      : std_logic_vector(7 downto 0) := (others => '0');
  signal data1addrtmp      : std_logic_vector(7 downto 0) := (others => '0');
  signal data0addrmasked   : std_logic_vector(7 downto 0) := (others => '0');
  signal data1addrmasked   : std_logic_vector(7 downto 0) := (others => '0');
  signal swap_int          : std_logic                    := '0';
  signal swap_swap         : swap_t;
  signal finalcycle        : std_logic                    := '0';
  signal maxstagereached   : std_logic                    := '0';
begin

-- Cycle counter
  process(clk)
  begin
    if rising_edge(clk) then
      if en = '1' then
        if start = '1' then
          cyclecounter <= 0;
        elsif (genenable = '1' and done_int = '0') then
          if cyclecounter = 3 then
            cyclecounter <= 0;
          else
            cyclecounter <= cyclecounter + 1;
          end if;
        end if;
      end if;
    end if;
  end process;

  bfenable <= '1' when cyclecounter = 3 and done_int = '0' else '0';

-- Output instruction

  process(all)
  begin
    -- Default values
    inst_shift <=
      (acce      => enable,
       shift     => 8,
       use_lod   => '0',
       shift_dir => right);
    inst_addbias <=
      (acc   => pass,
       quant => unbiased);
    inst_clip <=
      (clip   => clip16,
       outreg => out76);
    case cyclecounter is
      when 0 =>
        inst_arith <= fftadd0;
        inst_add   <= add32;
      when 1 =>
        inst_arith <= fftadd1;
        inst_add   <= add10;
        inst_clip.outreg <= out54;
      when 2 =>
        inst_arith <= fftsub0;
        inst_add   <= fftsub0;
        inst_shift.shift <= 16;
        inst_clip.outreg <= out32;
      when 3 =>
        inst_arith <= fftsub1;
        inst_add   <= fftsub1;
        inst_shift.shift <= 16;
        inst_clip.outreg <= out10;
    end case;
  end process;


-- Butterfly counter
  process(clk)
  begin
    if rising_edge(clk) then
      if en = '1' then
        if start = '1' then
          bfcounter <= (others => '0');
        elsif bfenable = '1' then
          if bfcounter = bfmax then
            bfcounter <= (others => '0');
          else
            bfcounter <= bfcounter + 1;
          end if;
        end if;
      end if;
    end if;
  end process;

  stageenable <= '1' when bfcounter = bfmax and bfenable = '1' else '0';

-- Stage counter
  process(clk)
  begin
    if rising_edge(clk) then
      if en = '1' then
        if start = '1' then
          stagecounter <= (others => '0');
          done_int     <= '0';
        elsif stageenable = '1' then
          if maxstagereached = '1' then
            done_int <= '1';
          else
            done_int     <= '0';
            stagecounter <= stagecounter + 1;
          end if;
        end if;
      else
        done_int <= '1';
      end if;
    end if;
  end process;

  finalcycle <= '1' when stageenable = '1' and stagecounter >= stagemax else '0';

-- Mask and bfmax registers
  process(clk)
  begin
    if rising_edge(clk) then
      if en = '1' then
        if start = '1' then
          stagemax <= resize(stages, 4) + 1;
          case stages is
            -- N = 4
            when "000" => maskreg <= "11111110";
                          bfmax <= "00000001";
            -- N = 8
            when "001" => maskreg <= "11111100";
                          bfmax <= "00000011";
            -- N = 16
            when "010" => maskreg <= "11111000";
                          bfmax <= "00000111";
            -- N = 32
            when "011" => maskreg <= "11110000";
                          bfmax <= "00001111";
            -- N = 64
            when "100" => maskreg <= "11100000";
                          bfmax <= "00011111";
            -- N =128
            when "101" => maskreg <= "11000000";
                          bfmax <= "00111111";
            -- N = 256
            when "110" => maskreg <= "10000000";
                          bfmax <= "01111111";

            when others => maskreg <= "00000000";
                           bfmax <= "11111111";
          end case;
        elsif stageenable = '1' then
          maskreg <= '1' & maskreg(7 downto 1);
        end if;
      end if;
    end if;
  end process;

  -- Determine if right or left data memory halfs should be switched before the
  -- register
  swap_int <= bfcounter(7) xor bfcounter(6) xor bfcounter(5) xor bfcounter(4) xor
              bfcounter(3) xor bfcounter(2) xor bfcounter(1) xor bfcounter(0);
  swap_swap <= swap when swap_int = '1' else noswap;
  -- Select bit or bit to the right to later on insert a 0 or a 1
  process(maskreg, bfcounter)
  begin
    for i in 1 to 7 loop
      if maskreg(i) = '1' then
        maskcount(i) <= bfcounter(i-1);
      else
        maskcount(i) <= bfcounter(i);
      end if;
    end loop;
    maskcount(0) <= bfcounter(0);
  end process;

  -- Insert a zero or one in the correct position
  -- where maskreg switches from 1 to 0
  process(maskcount, maskreg)
  begin
    for i in 1 to 7 loop
      if maskreg(i) = '1' and maskreg(i-1) = '0' then
        data0addrtmp(i) <= '0';
        data1addrtmp(i) <= '1';
      else
        data0addrtmp(i) <= maskcount(i);
        data1addrtmp(i) <= maskcount(i);
      end if;
      if maskreg(0) = '1' then
        data0addrtmp(0) <= '0';
        data1addrtmp(0) <= '1';
      else
        data0addrtmp(0) <= maskcount(0);
        data1addrtmp(0) <= maskcount(0);
      end if;
    end loop;
  end process;

  -- Simple FSM to keep control of enable
  -- Currently redundant with done_int, but can possibly be set externally
  process(clk)
  begin
    if rising_edge(clk) then
      if en = '1' then
        if start = '1' then
          genenable <= '1';
        elsif stageenable = '1' and stagecounter >= stagemax then
          genenable <= '0';
        end if;
      end if;
    end if;
  end process;


  -- Check if stage counter has reached max
  maxstagereached <= '1' when stagecounter >= stagemax else '0';


  -- Read out in first cycle
  read_en  <= '1' when cyclecounter = 0 and genenable = '1' else '0';
  memreg_c <= (swap => swap_swap, datareg => enable, weightreg => enable)
              when cyclecounter = 0 else
              (swap => swap_swap, datareg => hold, weightreg => hold);
  -- Write in first cycle
  write_en    <= '1' when cyclecounter = 3 else '0';
  writebuff_c <= (swap => swap_swap, datareg => enable, weightreg => enable)
                 when cyclecounter = 3 else
                 (swap => swap_swap, datareg => hold, weightreg => hold);

  -- Set done signal from internal
  done <= done_int;

  -- Shift twiddle factor address
  shifted_bfcounter <= shift_left(bfcounter, to_integer(stagecounter));

  -- Mask out bits assuming that an N-point FFT have twiddle factors
  -- at the addresses 0 to N/2-1
  tfaddr <= std_logic_vector(shifted_bfcounter and bfmax);

  data0addrmasked <= data0addrtmp and std_logic_vector(bfmax);
  data1addrmasked <= data1addrtmp and std_logic_vector(bfmax);
  -- Output address, possibly swap
  data0addr       <= data0addrmasked when swap_int = '0' else data1addrmasked;
  data1addr       <= data1addrmasked when swap_int = '0' else data0addrmasked;

  -- Mark that we are in the final stage of computations (results to central memory)
  finalstage <= '1' when maxstagereached = '1' and genenable = '1' else '0';

  -- No need to stall
  stall <= (others => '0');
end architecture;
