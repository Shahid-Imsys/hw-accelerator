
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.instructiontypes.all;
use work.vetypes.all;

entity ve_wctrlpipe is

  port (
    -- general
    clk : in std_logic;
    reset : in std_logic;
    -- in
    data0_addr_i : in std_logic_vector(7 downto 0);
    data1_addr_i : in std_logic_vector(7 downto 0);
    weight_addr_i : in std_logic_vector(7 downto 0);
    data_ren_i : in std_logic;
    data_wen_i : in std_logic;
    weight_ren_i : in std_logic;
    weight_wen_i : in std_logic;
    enable_shift : in std_logic;
    enable_add_bias : in std_logic;
    enable_clip : in std_logic;

    data0_i : in std_logic_vector(31 downto 0);
    data1_i : in std_logic_vector(31 downto 0);
    weight_i : in std_logic_vector(63 downto 0);

    memreg_c_i : in memreg_ctrl;
    writebuff_c_i : in memreg_ctrl;
    inst_i : in instruction;
    ppinst_i : in ppctrl_t;
    ppshiftinst_i : in ppshift_shift_ctrl;
    addbiasinst_i : in ppshift_addbias_ctrl;
    clipinst_i : in ppshift_clip_ctrl;
    lzod_i : in  lzod_ctrl;
    zpdata_i : in std_logic_vector(7 downto 0);
    zpweight_i : in std_logic_vector(7 downto 0);
    bias_i : in std_logic_vector(31 downto 0);

    -- out
    data0_addr_o : out std_logic_vector(7 downto 0);
    data1_addr_o : out std_logic_vector(7 downto 0);
    weight_addr_o : out std_logic_vector(7 downto 0);
    data_ren_o : out std_logic;
    data_wen_o : out std_logic;
    weight_ren_o : out std_logic;
    weight_wen_o : out std_logic;

    outreg_o : out std_logic_vector(63 downto 0);
    writebuffer_o : out std_logic_vector(63 downto 0);

    -- en
    stall : in unsigned(3 downto 0) := (others => '0');
    en_o : out std_logic
  );
end entity;

architecture rtl of ve_wctrlpipe is
  -- delay constants
  constant en_delay : integer := 11; --10
  constant read_delay : integer := 0;
  constant memreg_c_delay : integer := 1;
  constant lzod_delay : integer := 2;
  constant zpdata_delay : integer := 2;
  constant zpweight_delay : integer := 2;
  constant inst_delay : integer := 4;
  constant ppinst_delay : integer := 5;
  constant ppshiftinst_delay : integer := 6;
  constant bias_delay : integer := 7;
  constant addbiasinst_delay : integer := 7;
  constant clipinst_delay : integer := 8;
  constant writebuff_c_delay : integer := 9;
  constant write_delay : integer := 10;
  -- signals
  signal en : std_logic;
  signal en_cntr : unsigned(3 downto 0) := (others => '0');
  type en_array is array (0 to en_delay) of std_logic;
  type pp_en_array is array (0 to ppshiftinst_delay) of std_logic;
  signal en_pipe : en_array := (others => '0');
  signal enable_shift_pipe : pp_en_array;
  signal enable_add_bias_pipe : pp_en_array;
  signal enable_clipp_pipe : pp_en_array;
  -- piped signals
  type addr_array is array (0 to write_delay) of std_logic_vector(7 downto 0);
  signal data0_addr_pipe : addr_array := (others => (others => '0'));
  signal data1_addr_pipe : addr_array := (others => (others => '0'));
  signal weight_addr_pipe : addr_array := (others => (others => '0'));
  signal data_ren_pipe : std_logic_vector(0 to read_delay) := (others => '0');
  signal data_wen_pipe : std_logic_vector(0 to write_delay) := (others => '0');
  signal weight_ren_pipe : std_logic_vector (0 to read_delay)  := (others => '0');
  signal weight_wen_pipe : std_logic_vector (0 to write_delay) := (others => '0');
  type memreg_c_array is array (0 to memreg_c_delay) of memreg_ctrl;
  signal memreg_c_pipe : memreg_c_array;
  type writebuff_c_array is array (0 to writebuff_c_delay) of memreg_ctrl;
  signal writebuff_c_pipe : writebuff_c_array;
  type lzod_array is array (0 to lzod_delay) of lzod_ctrl;
  signal lzod_pipe : lzod_array;
  type inst_array is array (0 to inst_delay) of instruction;
  signal inst_pipe : inst_array;
  type ppinst_array is array (0 to ppinst_delay) of ppctrl_t;
  signal ppinst_pipe : ppinst_array;
  type ppshiftinst_array is array (0 to ppshiftinst_delay) of ppshift_shift_ctrl;
  signal ppshiftinst_pipe : ppshiftinst_array;
  type addbiasinst_array is array (0 to addbiasinst_delay) of ppshift_addbias_ctrl;
  signal addbiasinst_pipe : addbiasinst_array;
  type clipinst_array is array (0 to clipinst_delay) of ppshift_clip_ctrl;
  signal clipinst_pipe : clipinst_array;
  type zpdata_array is array (0 to zpdata_delay) of std_logic_vector(7 downto 0);
  signal zpdata_pipe : zpdata_array  := (others => (others => '0'));
  type zpweight_array is array (0 to zpweight_delay) of std_logic_vector(7 downto 0);
  signal zpweight_pipe : zpweight_array  := (others => (others => '0'));
  type bias_array is array (0 to bias_delay) of std_logic_vector(31 downto 0);
  signal bias_pipe : bias_array  := (others => (others => '0'));

  -- components
  component vecore
  port (
    clk              : in  std_logic;
    enable_memreg    : in  std_logic;
    enable_add       : in  std_logic;
    enable_mul       : in  std_logic;
    enable_acc       : in  std_logic;
    enable_sum       : in  std_logic;
    enable_shift     : in  std_logic;
    enable_add_bias  : in  std_logic;
    enable_clip      : in  std_logic;
    enable_writebuff : in  std_logic;
    data0            : in  std_logic_vector(31 downto 0);
    data1            : in  std_logic_vector(31 downto 0);
    weight           : in  std_logic_vector(63 downto 0);
    memctrl          : in  memreg_ctrl;
    wbctrl           : in  memreg_ctrl;
    inst_addmul      : in  instruction;
    inst_acc         : in  instruction;
    ppinst           : in  ppctrl_t;
    shift_ctrl       : in  ppshift_shift_ctrl;
    bias_add_ctrl    : in  ppshift_addbias_ctrl;
    clip_ctrl        : in  ppshift_clip_ctrl;
    lzo_ctrl         : in  lzod_ctrl;
    zpdata           : in  std_logic_vector(7 downto 0);
    zpweight         : in  std_logic_vector(7 downto 0);
    bias             : in  std_logic_vector(31 downto 0);
    outreg           : out std_logic_vector(63 downto 0);
    writebuffer      : out std_logic_vector(63 downto 0)
  );
  end component vecore;


begin

  -- instances

  vecore_i : vecore
port map (
  clk              => clk,
  enable_memreg    => '1',
  enable_add       => '1',
  enable_mul       => '1',
  enable_acc       => '1',
  enable_sum       => '1',
  enable_shift     => enable_shift_pipe(ppshiftinst_delay),
  enable_add_bias  => enable_add_bias_pipe(ppshiftinst_delay),
  enable_clip      => enable_clipp_pipe(ppshiftinst_delay),
  enable_writebuff => '1',
  data0            => data0_i,
  data1            => data1_i,
  weight           => weight_i,
  memctrl          => memreg_c_pipe(memreg_c_delay),
  wbctrl           => writebuff_c_pipe(writebuff_c_delay),
  lzo_ctrl         => lzod_pipe(lzod_delay),
  inst_addmul      => inst_pipe(inst_delay-2),
  inst_acc         => inst_pipe(inst_delay),
  ppinst           => ppinst_pipe(ppinst_delay),
  shift_ctrl       => ppshiftinst_pipe(ppshiftinst_delay),
  bias_add_ctrl    => addbiasinst_pipe(addbiasinst_delay),
  clip_ctrl        => clipinst_pipe(clipinst_delay),
  zpdata           => zpdata_pipe(zpdata_delay),
  zpweight         => zpweight_pipe(zpweight_delay),
  bias             => bias_pipe(bias_delay),
  outreg           => outreg_o,
  writebuffer      => writebuffer_o
);

  -- ctrl pipe
  data0_addr_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        data0_addr_pipe(0) <= data0_addr_i;
      end if;
      for i in 1 to write_delay loop
        if en_pipe(i) = '1' then
          data0_addr_pipe(i) <= data0_addr_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  data1_addr_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        data1_addr_pipe(0) <= data1_addr_i;
      end if;
      for i in 1 to write_delay loop
        if en_pipe(i) = '1' then
          data1_addr_pipe(i) <= data1_addr_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  weight_addr_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        weight_addr_pipe(0) <= weight_addr_i;
      end if;
      for i in 1 to write_delay loop
        if en_pipe(i) = '1' then
          weight_addr_pipe(i) <= weight_addr_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  ren_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        data_ren_pipe(0) <= data_ren_i;
        weight_ren_pipe(0) <= weight_ren_i;
      end if;
      for i in 1 to read_delay loop
        if en_pipe(i) = '1' then
          data_ren_pipe(i) <= data_ren_pipe(i - 1);
          weight_ren_pipe(i) <= weight_ren_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  wen_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        data_wen_pipe(0) <= data_wen_i;
        weight_wen_pipe(0) <= weight_wen_i;
      end if;
      for i in 1 to write_delay loop
        if en_pipe(i) = '1' then
          data_wen_pipe(i) <= data_wen_pipe(i - 1);
          weight_wen_pipe(i) <= weight_wen_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  memreg_c_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        memreg_c_pipe(0) <= memreg_c_i;
      end if;
      for i in 1 to memreg_c_delay loop
        if en_pipe(i) = '1' then
          memreg_c_pipe(i) <= memreg_c_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  lzod_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        lzod_pipe(0) <= lzod_i;
      end if;
      for i in 1 to lzod_delay loop
        if en_pipe(i) = '1' then
          lzod_pipe(i) <= lzod_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  writebuff_c_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        writebuff_c_pipe(0) <= writebuff_c_i;
      end if;
      for i in 1 to writebuff_c_delay loop
        if en_pipe(i) = '1' then
          writebuff_c_pipe(i) <= writebuff_c_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  inst_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        inst_pipe(0) <= inst_i;
      end if;
      for i in 1 to inst_delay loop
        if en_pipe(i) = '1' then
          inst_pipe(i) <= inst_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  ppinst_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        ppinst_pipe(0) <= ppinst_i;
      end if;
      for i in 1 to ppinst_delay loop
        if en_pipe(i) = '1' then
          ppinst_pipe(i) <= ppinst_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  ppshiftinst_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        ppshiftinst_pipe(0) <= ppshiftinst_i;
        enable_shift_pipe(0) <= enable_shift;
        enable_add_bias_pipe(0) <= enable_add_bias;
        enable_clipp_pipe(0) <= enable_clip;
      end if;
      for i in 1 to ppshiftinst_delay loop
        if en_pipe(i) = '1' then
          ppshiftinst_pipe(i) <= ppshiftinst_pipe(i - 1);
          enable_shift_pipe(i) <= enable_shift_pipe(i - 1);
          enable_add_bias_pipe(i) <= enable_add_bias_pipe(i - 1);
          enable_clipp_pipe(i) <= enable_clipp_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  addbiasinst_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        addbiasinst_pipe(0) <= addbiasinst_i;
      end if;
      for i in 1 to addbiasinst_delay loop
        if en_pipe(i) = '1' then
          addbiasinst_pipe(i) <= addbiasinst_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  clipinst_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        clipinst_pipe(0) <= clipinst_i;
      end if;
      for i in 1 to clipinst_delay loop
        if en_pipe(i) = '1' then
          clipinst_pipe(i) <= clipinst_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  zpdata_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        zpdata_pipe(0) <= zpdata_i;
      end if;
      for i in 1 to zpdata_delay loop
        if en_pipe(i) = '1' then
          zpdata_pipe(i) <= zpdata_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  zpweight_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        zpweight_pipe(0) <= zpweight_i;
      end if;
      for i in 1 to zpweight_delay loop
        if en_pipe(i) = '1' then
          zpweight_pipe(i) <= zpweight_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;

  bias_pipeline : process (clk)
  begin
    if rising_edge(clk) then
      if en_pipe(0) = '1' then
        bias_pipe(0) <= bias_i;
      end if;
      for i in 1 to bias_delay loop
        if en_pipe(i) = '1' then
          bias_pipe(i) <= bias_pipe(i - 1);
        end if;
      end loop;
    end if;
  end process;
  -----------------------------------------------------------------------------
  -- TODO: add counter to stop pipeline and controller

  process (clk)
  begin
    if rising_edge(clk) then
      if en_cntr = 0 then
        en_cntr <= stall;
      else
        en_cntr <= en_cntr - 1;
      end if;
    end if;
  end process;

  en_pipeline : process (clk, en)
  begin
    en_pipe(0) <= en;
    if rising_edge(clk) then
      for i in 1 to en_delay loop
        en_pipe(i) <= en_pipe(i - 1);
      end loop;
    end if;
  end process;
  en <= '1' when en_cntr = 0 else '0';
  en_o <= en;

  -----------------------------------------------------------------------------
  -- out

  data0_addr_o <= data0_addr_pipe(read_delay) when (data_ren_pipe(read_delay) = '1') else data0_addr_pipe(write_delay);
  data1_addr_o <= data1_addr_pipe(read_delay) when (data_ren_pipe(read_delay) = '1') else data1_addr_pipe(write_delay);
  weight_addr_o <= weight_addr_pipe(read_delay) when (data_ren_pipe(read_delay) = '1') else weight_addr_pipe(write_delay);
  data_ren_o <= data_ren_pipe(read_delay) when (en_pipe(read_delay+1) = '1') else '0';
  data_wen_o <= data_wen_pipe(write_delay) when (en_pipe(write_delay+1) = '1') else '0';
  weight_ren_o <= weight_ren_pipe(read_delay) when (en_pipe(read_delay+1) = '1') else '0';
  weight_wen_o <= weight_wen_pipe(write_delay) when (en_pipe(write_delay+1) = '1') else '0'; --The cycle where stall gets set runs at the right time

end architecture;
