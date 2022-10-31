

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.instructiontypes.all;
use work.vetypes.all;

entity convcontroller is 
  port(
    clk              : in std_logic;
    rst              : in std_logic;
    clk_e_pos        : in std_logic;
    start            : in std_logic;
    mode_a           : in std_logic;
    mode_b           : in std_logic;
    mode_c           : in std_logic;
    addr_reload      : in std_logic;
    bias_addr_assign : in std_logic;
    config           : in std_logic_vector(7 downto 0);
    pp_ctl           : in std_logic_vector(7 downto 0);
    conv_saddr_l     : in std_logic_vector(7 downto 0);
    conv_saddr_r     : in std_logic_vector(7 downto 0);
    loop_counter     : in std_logic_vector(7 downto 0);
    oloop_counter    : in std_logic_vector(7 downto 0);
    bias_index_start : in std_logic_vector(7 downto 0);
    bias_index_end   : in std_logic_vector(7 downto 0);
    scale            : in std_logic_vector(4 downto 0);
    conv_loop_ctr    : out std_logic_vector(7 downto 0);
    data_addr        : out std_logic_vector(7 downto 0);
    weight_addr      : out std_logic_vector(7 downto 0);
    bias_addr        : out std_logic_vector(7 downto 0);
    bias_mux         : out std_logic_vector(1 downto 0);
    mode_c_l         : out std_logic;
    data_rd_en       : out std_logic;
    data_wr_en       : out std_logic;
    weight_rd_en     : out std_logic;
    weight_wr_en     : out std_logic;
    bias_rd_ena      : out std_logic;
    enable_shift     : out std_logic;
    enable_add_bias  : out std_logic;
    enable_clip      : out std_logic;
    memreg_c         : out memreg_ctrl;
    writebuff_c      : out memreg_ctrl;
    inst             : out instruction;
    ppinst           : out ppctrl_t;
    ppshiftinst      : out ppshift_shift_ctrl;
    addbiasinst      : out ppshift_addbias_ctrl;
    clipinst         : out ppshift_clip_ctrl;
    busy             : out std_logic
  );
end entity;

architecture convctrl of convcontroller is
  --signals
  signal o_mux_ena      : std_logic;
  signal pselector_en   : std_logic;
  signal pp_stage_1     : std_logic;
  signal pp_stage_2     : std_logic;
  signal conv_out_p     : std_logic;
  signal a_delay        : std_logic;
  signal conv_out_sel   : std_logic_vector(2 downto 0);
  signal conv_addr_l    : std_logic_vector(7 downto 0);
  signal conv_addr_r    : std_logic_vector(7 downto 0);
  signal conv_loop      : unsigned(7 downto 0);
  signal conv_oloop     : unsigned(7 downto 0);
  signal bias_addr_reg  : std_logic_vector(7 downto 0);
  signal ppinst_p       : ppctrl_t;
  signal ppinst_s       : ppctrl_t;

begin

  data_addr     <= conv_addr_l;
  weight_addr   <= conv_addr_r;
  bias_addr     <= bias_addr_reg;
  conv_loop_ctr <= std_logic_vector(conv_loop);
  conv_out_p    <= pp_ctl(0);
  memreg_c      <= (swap => noswap, datareg => enable, weightreg => enable);
  writebuff_c   <= (swap => noswap, datareg => enable, weightreg => enable);
  ppinst        <= ppinst_p when conv_out_p = '1' else ppinst_s;
  ppshiftinst   <= (acce => enable, shift => to_integer(unsigned(scale)), use_lod => '0', shift_dir => right);
  addbiasinst   <= (acc => addbias, quant => trunc);
  clipinst      <= (clip => clip8, outreg => out0);

  latch_signals: process(clk)
  begin
      if rising_edge(clk) then  
          if start = '1' then
            busy <= '1';
          elsif oloop_counter = (oloop_counter'range => '0') and conv_loop = x"00" then
            busy <= '0';
          elsif conv_oloop = (conv_oloop'range => '0') and conv_loop = x"00" then 
            busy <= '0';
          end if;
          if start = '1' and mode_c = '1' then
            mode_c_l <= '1';
          elsif oloop_counter = (oloop_counter'range => '0') and conv_loop = x"00" then
            mode_c_l <= '0';
          elsif conv_oloop = (conv_oloop'range => '0') and conv_loop = x"00" then
            mode_c_l <= '0';
          end if;
      end if;
  end process;

  --Mode left and right
  conv_addr_gen: process(clk)
  begin
    if rising_edge(clk) then
      if RST = '0' then
        conv_addr_l <= (others => '0');
        conv_addr_r <= (others => '0');
        conv_loop <= (others => '0');
        conv_oloop <= (others => '0');
      elsif addr_reload = '1' and clk_e_pos = '1' then
        conv_loop <= unsigned(loop_counter) - 1;
        if oloop_counter /= x"00" then    -- make sure ve compute at least one oloop
          conv_oloop <= unsigned(oloop_counter) - 1;
        else
          conv_oloop <= x"01";
        end if;
        if mode_a = '1' then
          conv_addr_l <= conv_saddr_l;
        end if;
        if mode_b = '1' then
          conv_addr_r <= conv_saddr_r;
        end if;
      elsif start = '1' and addr_reload = '1' then --load vector engine's outer loop  and inner loop by the control of microinstructions, ring mode doesn't need a address reload
        ppinst_s <= sumfirst;
        if conv_out_p = '1' then
          inst <= firstconv;
        --  ppinst <= nop;
        else
          inst <= sum;
        --  ppinst <= sumfirst;
        end if;
        if oloop_counter /= x"00" then    -- make sure ve compute at least one oloop
          conv_oloop <= unsigned(oloop_counter) - 1;
        else
          conv_oloop <= x"01";
        end if;
        conv_loop  <= unsigned(loop_counter) - 1;
        if mode_a = '1' or mode_b = '1' then
          if mode_a = '1' then                --- reload depending on mode.
            conv_addr_l <= conv_saddr_l;
          end if;
          if mode_b = '1' then
            conv_addr_r <= conv_saddr_r;
          end if;
        end if;
      elsif busy = '1' then--and conv_oloop /= (conv_oloop'range => '0')then --when outer loop is not 0, do self reload.
        ppinst_s <= sum;
        if conv_out_p = '1' then
          inst <= conv;
        --  ppinst <= nop;
        else
          inst <= sum;
        --  ppinst <= sum;
        end if;
        if conv_loop = x"00" then
          if config(4) = '1' then --reload by config register, bit 4 in configure register
            conv_loop <= unsigned(loop_counter) - 1;
          end if;
          if config(2) = '1' then 
            conv_addr_l <= conv_saddr_l;
          else  ---- need to be modified later
            conv_addr_l <= std_logic_vector(to_unsigned(to_integer(unsigned(conv_addr_l)+1),8));
          end if;
          if config(3) = '1' then
            conv_addr_r <= conv_saddr_r;
          else  ----need to be modified later
            conv_addr_r <= std_logic_vector(to_unsigned(to_integer(unsigned(conv_addr_r)+1),8));
          end if;
          if conv_out_p = '1' then
            inst <= firstconv;
          --  ppinst <= nop;
          else
            inst <= sum;
          --  ppinst <= sumfirst;
          end if;
          ppinst_s <= sumfirst;
          conv_oloop <= conv_oloop - 1;
        elsif conv_loop /= x"00" then
          conv_loop <= conv_loop - 1;
          conv_addr_l <= std_logic_vector(to_unsigned(to_integer(unsigned(conv_addr_l)+1),8));
          conv_addr_r <= std_logic_vector(to_unsigned(to_integer(unsigned(conv_addr_r)+1),8)); --calculate right address;
          if conv_loop = x"01" then
            ppinst_s <= sum;
            if conv_out_p = '1' then
              inst <= lastconv;
            else
              inst <= sum;
            --  ppinst <= sum;
            end if; 
          end if;
        end if;
      end if;
    end if;
  end process;
  
  process(clk)
  begin 
    if rising_edge(clk) then
      if rst = '0' then
        conv_out_sel <= (others => '0');
      elsif pselector_en = '1' then
        conv_out_sel <= std_logic_vector(to_signed(to_integer(signed(conv_out_sel))+1,3));
        if conv_out_sel = "000" then
          ppinst_p <= select0;
        elsif conv_out_sel = "001" then
          ppinst_p <= select1;
        elsif conv_out_sel = "010" then
          ppinst_p <= select2;
        elsif conv_out_sel = "011" then
          ppinst_p <= select3;
        elsif conv_out_sel = "100" then
          ppinst_p <= select4;
        elsif conv_out_sel = "101" then
          ppinst_p <= select5;
        elsif conv_out_sel = "110" then
          ppinst_p <= select6;
        elsif conv_out_sel = "111" then
          ppinst_p <= select7;
        end if;
      else
        ppinst_p <= nop;
      end if;
    end if;
  end process;

--Two modes
--For output from overall accumulator latch, this selector activates one clock.
--For output from unique accumulator latches, this mux activates eight clocks and select one accumulator latch in each clock cycle.
  process(clk)
  begin
    if rising_edge(clk) then
      if conv_loop = x"02" then
        if conv_out_p = '1' then
          pselector_en <= '1';
        else
          pselector_en <= '0';
        end if;
      elsif conv_out_sel = (conv_out_sel'range => '1') then --reset the output enable signal
        pselector_en <= '0';
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if conv_out_p = '0' then
        if conv_loop = x"01" then
          if pp_ctl(1) = '0' then 
            o_mux_ena <= '1';
          else
            o_mux_ena <= '0';
          end if;
        else
          o_mux_ena <= '0';
        end if;
      else--reset the output enable signal
        if pp_ctl(1) = '0' then 
          o_mux_ena <= pselector_en;
        else
          o_mux_ena <= '0';
        end if;
      end if;
    end if;
  end process;
                
  --Post Shifter --maximum 16 bits, scale <= "10000"
  process(clk) --Enable control, one clock delay of ourput selector
  begin
    if rising_edge(clk) then
      pp_stage_1 <= o_mux_ena;
      enable_shift <= pp_stage_1;
    end if;
  end process;

  bias_rd_ena <= o_mux_ena; 
--bias buffer --also activates at the clock cycle when shifter is activated, so shares the o_mux_ena signal
  process(clk)
  begin 
    if rising_edge(clk) then
      if bias_addr_assign = '1' then
        bias_addr_reg <= bias_index_start;  
      elsif o_mux_ena = '1' and pp_ctl(1) = '0' then
        bias_mux <= bias_addr_reg (1 downto 0);
        if bias_addr_reg = bias_index_end then
          bias_addr_reg <= bias_index_start;
        else
          bias_addr_reg <= std_logic_vector(to_unsigned(to_integer(unsigned(bias_addr_reg))+1,8));
        end if;
      else
        bias_addr_reg <= bias_addr_reg;
      end if;
    end if;
  end process;

--Post Adder
  process(clk) --Enable control, one clock delay adter shifter control.
  begin
    if rising_edge(clk) then
      pp_stage_2 <= pp_stage_1;
      a_delay <= pp_stage_2;
      enable_add_bias <= a_delay and not pp_ctl(1);
    end if;
  end process;

--Clip 8
  process(clk) --Enable control, one clock delay after adder control.
  begin
    if rising_edge(clk) then
      enable_clip <= enable_add_bias;
    end if;
  end process; 


end architecture; 