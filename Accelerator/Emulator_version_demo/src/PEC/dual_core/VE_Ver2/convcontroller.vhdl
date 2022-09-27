

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
    left_done        : in std_logic;
    right_done       : in std_logic;
    bias_done        : in std_logic;
    au_counters      : in au_param;
    au_cmp           : in au_param;
    au_offset        : in au_param;
    config           : in std_logic_vector(7 downto 0);
    pp_ctl           : in std_logic_vector(7 downto 0);
    scale            : in std_logic_vector(4 downto 0);
    mode_a_l         : out std_logic;
    mode_b_l         : out std_logic;
    mode_c_l         : out std_logic;
    bias_en          : out std_logic;
    load             : out std_logic;
    bias_load        : out std_logic;
    rd_en            : out std_logic;
    bias_rd_en       : out std_logic;
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
  signal pp_stage_1     : std_logic;
  signal pp_stage_2     : std_logic;
  signal conv_out_p     : std_logic;
  signal a_delay        : std_logic;
  signal conv_out_sel   : std_logic_vector(2 downto 0);
  signal bias_addr_reg  : std_logic_vector(7 downto 0);
  signal clockcycle     : integer := 0;

begin

  --data_addr     <= conv_addr_l;
  --weight_addr   <= conv_addr_r;
  --bias_addr     <= bias_addr_reg;
  conv_out_p    <= pp_ctl(0);
  memreg_c      <= (swap => noswap, datareg => enable, weightreg => enable);
  writebuff_c   <= (swap => noswap, datareg => enable, weightreg => enable);
  ppshiftinst   <= (acce => enable, shift => to_integer(unsigned(scale)), use_lod => '0', shift_dir => right);
  addbiasinst   <= (acc  => addbias, quant => trunc);
  clipinst      <= (clip => clip8, outreg => out0);

  process(clk)
  begin
    if rising_edge(clk) then
      if start = '1' then
        clockcycle <= 0;
      else
        clockcycle <= clockcycle + 1;
      end if;
    end if;
  end process;

  latch_signals: process(clk)
  begin
    if rising_edge(clk) then --latches at the rising_edge of clk_p. 
      if rst = '0' then
        busy <= '0';
      else
        
        if start = '1' then
          busy <= '1';
        elsif left_done = '1' and right_done = '1' then 
          busy <= '0';
        end if;

        if start = '1' and mode_a = '1' and mode_b = '0' then
          mode_a_l <= '1';    --this should become enable signal for left au, data valid should become load signal for left au
        elsif left_done = '1' then
          mode_a_l <= '0';
        end if;
        if start = '1' and mode_a = '0' and mode_b = '1' then
          mode_b_l <= '1';
        elsif right_done = '1' then
          mode_b_l <= '0';
        end if;
        if start = '1' and mode_a = '1' and mode_b = '1' then
          bias_en <= '1';
        elsif bias_done = '1' then
          bias_en <= '0';
        end if;

        --if start = '1' and mode_c = '1' then
        --  mode_c_l <= '1';
        --elsif conv_oloop = (conv_oloop'range => '0') then
        --  mode_c_l <= '0';
        --end if;
      end if;
    end if;
  end process;

  conv_addr_gen: process(clk)
  begin
    if rising_edge(clk) then
      if RST = '0' then
        load <= '0';
        rd_en <= '0';
        inst <= firstconv;
      elsif busy = '1' and mode_a_l = '1' and mode_b_l = '1' then --load vector engine's outer loop  and inner loop by the control of microinstructions, ring mode doesn't need a address reload
        load <= '1';
        rd_en <= '1';
        if left_done = '1' and right_done = '1' then
          load <= '0';
          rd_en <= '0';
        end if;
        if au_counters(0) = au_cmp(0) or start = '1' then
          inst <= firstconv;
        elsif au_counters(0) = au_cmp(0)-au_offset(0) then
          inst <= lastconv;
        else
          inst <= conv;
        end if;
      end if;
    end if;
  end process;
  
--Two modes
--For output from overall accumulator latch, this selector activates one clock.
--For output from unique accumulator latches, this mux activates eight clocks and select one accumulator latch in each clock cycle.
  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        o_mux_ena <= '0';
      else
        if mode_a_l = '1' and mode_b_l = '1' then
          if au_counters(0) = au_cmp(0)- au_offset(0) then
            o_mux_ena <= '1';
          elsif conv_out_p = '0' then --11 clock delay of config(7)
            o_mux_ena <= '0';
          elsif conv_out_sel = (conv_out_sel'range => '1') then --reset the output enable signal
            o_mux_ena <= '0';
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
      else
        if mode_a_l = '1' and mode_b_l = '1' then
          if au_counters(0) = au_cmp(0)- au_offset(0) then
            if conv_out_p = '0' then
              ppinst <= sumfirst;
            elsif conv_out_p = '1' then
              conv_out_sel <= std_logic_vector(to_signed(to_integer(signed(conv_out_sel))+1,3));
              if conv_out_sel = "000" then
                ppinst <= select0;
              elsif conv_out_sel = "001" then
                ppinst <= select1;
              elsif conv_out_sel = "010" then
                ppinst <= select2;
              elsif conv_out_sel = "011" then
                ppinst <= select3;
              elsif conv_out_sel = "100" then
                ppinst <= select4;
              elsif conv_out_sel = "101" then
                ppinst <= select5;
              elsif conv_out_sel = "110" then
                ppinst <= select6;
              elsif conv_out_sel = "111" then
                ppinst <= select7;
              end if;
            end if;
          elsif o_mux_ena = '1' then
            if conv_out_p = '0' then
              ppinst <= sumall;
            end if;
          elsif pp_stage_1 = '1' then
            ppinst <= nop;
          end if;
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

--bias buffer --also activates at the clock cycle when shifter is activated, so shares the o_mux_ena signal
  process(clk)
  begin 
    if rising_edge(clk) then        
      if rst = '0' then
        bias_load <= '0';
        bias_rd_en <= '0';
      else
        if pp_stage_1 = '1' then
          bias_load <= '1';
          bias_rd_en <= '1';
          if bias_done = '1' then
            bias_load <= '0';
            bias_rd_en <= '0';
          end if;
        else 
          bias_load <= '0';
          bias_rd_en <= '0';
        end if;
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