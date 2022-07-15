
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.math_real.all;

--use work.memtypes.all;
use work.instructiontypes.all;
use work.vetypes.all;

entity ve_wctrl is
  port (
    --general
    clk : in std_logic;
    reset : in std_logic;
    -- controller
    start : in std_logic;
    nt : in std_logic_vector(4 downto 0);
    done : out std_logic;
    -- ve_wctrlpipe
    data0 : in std_logic_vector(31 downto 0);
    data1 : in std_logic_vector(31 downto 0);
    weight : in std_logic_vector(63 downto 0);
    data0_addr_o : out std_logic_vector(7 downto 0);
    data1_addr_o : out std_logic_vector(7 downto 0);
    weight_addr_o : out std_logic_vector(7 downto 0);
    data_read_enable_o : out std_logic;
    data_write_enable_o : out std_logic;
    weight_read_enable_o : out std_logic;
    weight_write_enable_o : out std_logic;
    outreg : out std_logic_vector(63 downto 0);
    writebuffer : out std_logic_vector(63 downto 0)
  );
end entity;

architecture rtl of ve_wctrl is

    ----signals
  signal en_i : std_logic;
  signal data0_addr_i : std_logic_vector(7 downto 0);
  signal data1_addr_i : std_logic_vector(7 downto 0);
  signal weight_addr_i : std_logic_vector(7 downto 0);
  signal data_read_enable_i : std_logic;
  signal weight_read_enable_i : std_logic;
  signal weight_write_enable_i : std_logic;
  signal data_write_enable_i : std_logic;
  signal memreg_c_i : memreg_ctrl;
  signal writebuff_c_i : memreg_ctrl;
  signal inst_i : instruction;
  signal ppinst_i : ppctrl_t;
  signal ppshiftinst_i : ppshift_shift_ctrl;
  signal addbiasinst_i : ppshift_addbias_ctrl;
  signal clipinst_i : ppshift_clip_ctrl;
  signal zpdata_i : std_logic_vector(7 downto 0);
  signal zpweight_i : std_logic_vector(7 downto 0);
  signal bias_i : std_logic_vector(31 downto 0);
  signal stall : unsigned(3 downto 0);

    --components
  component ldlinvcontroller
    port (
      clk : in std_logic;
      start : in std_logic;
      en_i : in std_logic;
      nt : in std_logic_vector(4 downto 0);
      done : out std_logic;
      data0_addr_o : out std_logic_vector(7 downto 0);
      data1_addr_o : out std_logic_vector(7 downto 0);
      weight_addr_o : out std_logic_vector(7 downto 0);
      data_read_enable_o : out std_logic;
      data_write_enable_o : out std_logic;
      weight_read_enable_o : out std_logic;
      weight_write_enable_o : out std_logic;
      memreg_c_o : out memreg_ctrl;
      writebuff_c_o : out memreg_ctrl;
      inst_o : out instruction;
      ppinst_o : out ppctrl_t;
      ppshiftinst_o : out ppshift_shift_ctrl;
      addbiasinst_o : out ppshift_addbias_ctrl;
      clipinst_o : out ppshift_clip_ctrl;
      zpdata_o : out std_logic_vector(7 downto 0);
      zpweight_o : out std_logic_vector(7 downto 0);
      bias_o : out std_logic_vector(31 downto 0);
      en_max_o : out unsigned(3 downto 0)
    );
  end component;

  component ve_wctrlpipe
    port (
      clk : in std_logic;
      reset : in std_logic;
      data0_addr_i : in std_logic_vector(7 downto 0);
      data1_addr_i : in std_logic_vector(7 downto 0);
      weight_addr_i : in std_logic_vector(7 downto 0);
      data_ren_i : in std_logic;
      data_wen_i : in std_logic;
      weight_ren_i : in std_logic;
      weight_wen_i : in std_logic;
      data0_i : in std_logic_vector(31 downto 0);
      data1_i : in std_logic_vector(31 downto 0);
      weight_i : in std_logic_vector(63 downto 0);
      memreg_c_i : in memreg_ctrl;
      writebuff_c_i : in memreg_ctrl;
      lzod_i : in lzod_ctrl;
      inst_i : in instruction;
      ppinst_i : in ppctrl_t;
      ppshiftinst_i : in ppshift_shift_ctrl;
      addbiasinst_i : in ppshift_addbias_ctrl;
      clipinst_i : in ppshift_clip_ctrl;
      zpdata_i : in std_logic_vector(7 downto 0);
      zpweight_i : in std_logic_vector(7 downto 0);
      bias_i : in std_logic_vector(31 downto 0);
      data0_addr_o : out std_logic_vector(7 downto 0);
      data1_addr_o : out std_logic_vector(7 downto 0);
      weight_addr_o : out std_logic_vector(7 downto 0);
      data_ren_o : out std_logic;
      data_wen_o : out std_logic;
      weight_ren_o : out std_logic;
      weight_wen_o : out std_logic;
      outreg_o : out std_logic_vector(63 downto 0);
      writebuffer_o : out std_logic_vector(63 downto 0);
      stall : in unsigned(3 downto 0);
      en_o : out std_logic
    );
  end component;

begin

  ldlinvcontroller_inst : ldlinvcontroller
  port map(
    clk => clk,
    start => start,
    en_i => en_i,
    nt => nt,
    done => done,
    data0_addr_o => data0_addr_i,
    data1_addr_o => data1_addr_i,
    weight_addr_o => weight_addr_i,
    data_read_enable_o => data_read_enable_i,
    data_write_enable_o => data_write_enable_i,
    weight_read_enable_o => weight_read_enable_i,
    weight_write_enable_o => weight_write_enable_i,
    memreg_c_o => memreg_c_i,
    writebuff_c_o => writebuff_c_i,
    inst_o => inst_i,
    ppinst_o => ppinst_i,
    ppshiftinst_o => ppshiftinst_i,
    addbiasinst_o => addbiasinst_i,
    clipinst_o => clipinst_i,
    zpdata_o => zpdata_i,
    zpweight_o => zpweight_i,
    bias_o => bias_i,
    en_max_o => stall
  );
  ve_wctrlpipe_inst : ve_wctrlpipe
  port map(
    clk => clk,
    reset => reset,
    data0_addr_i => data0_addr_i,
    data1_addr_i => data1_addr_i,
    weight_addr_i => weight_addr_i,
    data_ren_i => data_read_enable_i,
    data_wen_i => data_write_enable_i,
    weight_ren_i => weight_read_enable_i,
    weight_wen_i => weight_write_enable_i,
    data0_i => data0,
    data1_i => data1,
    weight_i => weight,
    memreg_c_i => memreg_c_i,
    writebuff_c_i => writebuff_c_i,
    inst_i => inst_i,
    ppinst_i => ppinst_i,
    ppshiftinst_i => ppshiftinst_i,
    addbiasinst_i => addbiasinst_i,
    clipinst_i => clipinst_i,
    lzod_i => ("00", none),
    zpdata_i => zpdata_i,
    zpweight_i => zpweight_i,
    bias_i => bias_i,
    data0_addr_o => data0_addr_o,
    data1_addr_o => data1_addr_o,
    weight_addr_o => weight_addr_o,
    data_ren_o => data_read_enable_o,
    data_wen_o => data_write_enable_o,
    weight_ren_o => weight_read_enable_o,
    weight_wen_o => weight_write_enable_o,
    outreg_o => outreg,
    writebuffer_o => writebuffer,
    stall => stall,
    en_o => en_i
  );

end architecture;
