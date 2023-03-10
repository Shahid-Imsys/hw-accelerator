--convolution controller
--this block generates the control signals for addressing unit, mem 
--and convolution instructions to the ve core.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.instructiontypes.all;
use work.vetypes.all;

entity convcontroller is 
  port(
    clk              : in std_logic;
    rst              : in std_logic;
    en               : in std_logic;
    clk_e_pos        : in std_logic;
    start            : in std_logic;
    cnt_rst          : in std_logic;
    data_valid       : in std_logic;
    mode_a           : in std_logic;
    mode_b           : in std_logic;
    mode_c           : in std_logic;
    bypass           : in std_logic;
    config           : in std_logic_vector(7 downto 0);
    pp_ctl           : in std_logic_vector(7 downto 0);
    dot_cnt          : in std_logic_vector(7 downto 0);
    oc_cnt           : in std_logic_vector(7 downto 0);
    scale            : in std_logic_vector(4 downto 0);
    mode_c_l         : out std_logic;
    bypass_reg       : out std_logic;
    load             : out std_logic;
    rd_en            : out std_logic;
    left_rst         : out std_logic;
    right_rst        : out std_logic;
    bias_load        : out std_logic; 
    bias_rd_en       : out std_logic;
    ext_load         : out std_logic;
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
    stall            : out unsigned(3 downto 0);
    busy             : out std_logic
  );
end entity;

architecture convctrl of convcontroller is
  --signals
  signal cyclecounter   : integer;
  signal bypass_int     : std_logic;
  signal bypass_int_reg : std_logic;
  signal bias_load_int  : std_logic;
  signal bias_rd_en_int : std_logic;
  signal o_mux_ena      : std_logic;
  signal pselector_en   : std_logic;
  signal pp_stage_1     : std_logic;
  signal pp_stage_2     : std_logic;
  signal conv_out_p     : std_logic;
  signal max_sel        : std_logic;
  signal a_delay        : std_logic;
  signal ppinst_s       : ppctrl_t;
  signal ppinst_p       : ppctrl_t;
  signal conv_out_sel   : std_logic_vector(2 downto 0);
  signal conv_loop      : unsigned(7 downto 0);
  signal conv_oloop     : unsigned(7 downto 0);

begin

  conv_out_p    <= pp_ctl(0);
  max_sel       <= pp_ctl(2);
  bias_load     <= bias_load_int when conv_out_p = '0' else o_mux_ena;
  bias_rd_en    <= bias_rd_en_int when conv_out_p = '0' else o_mux_ena;
  memreg_c      <= (swap => noswap, datareg => enable, weightreg => enable);
  writebuff_c   <= (swap => noswap, datareg => enable, weightreg => enable);
  ppinst        <= ppinst_p when conv_out_p = '1' else ppinst_s;
  ppshiftinst   <= (acce => enable, shift => to_integer(unsigned(scale)), use_lod => '0', shift_dir => right) when max_sel = '0'
                    else (acce => enable, shift => 0, use_lod => '0', shift_dir => right);
  addbiasinst   <= (acc => addbias, quant => trunc) when max_sel = '0' else (acc => pass, quant => unbiased);
  clipinst      <= (clip => clip8, outreg => out0) when max_sel = '0' else (clip => none, outreg => out10);

  cycle_counter : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        cyclecounter <= 0;
      elsif start = '1' then
        cyclecounter <= 0;
      elsif busy = '1' then
        cyclecounter <= cyclecounter + 1;
        if (unsigned(dot_cnt) < 7 and conv_out_sel = (conv_out_sel'range => '1')) or (unsigned(dot_cnt) >= 7 and conv_loop = 0) then
          cyclecounter <= 0;
        end if;
      end if;
    end if;
  end process;

  latch_signals: process(clk)
  begin
    if rising_edge(clk) then --latches at the rising_edge of clk_p. 
      if rst = '0' then
        busy <= '0';
        mode_c_l <= '0';
        bypass_int <= '0';
        bypass_int_reg <= '0';
        bypass_reg <= '0';
      elsif en = '1' then
        if start = '1' then
          busy <= '1';
        elsif bypass_reg = '1' and data_valid = '1' then
          busy <= '1';
        elsif bypass_reg = '1' and data_valid = '0' then
          busy <= '0';
        elsif oc_cnt = (oc_cnt'range => '0') and conv_loop = 0 then
          busy <= '0';
        elsif conv_oloop = 0 and conv_loop = 0 then 
          busy <= '0';
        end if;
        if start = '1' and mode_c = '1' then
          mode_c_l <= '1';
        elsif oc_cnt = (oc_cnt'range => '0') and conv_loop = 0 then
          mode_c_l <= '0';
        elsif conv_oloop = 0 and conv_loop = 0 then
          mode_c_l <= '0';
        end if;
        if bypass = '1' then
          bypass_int <= '1';
        elsif oc_cnt = (oc_cnt'range => '0') and conv_loop = 0 then
          bypass_int <= '0';
        elsif conv_oloop = 0 and conv_loop = 0 then
          bypass_int <= '0';
        end if;
        bypass_int_reg <= bypass_int;----dumb solution for sync data in bypass mode
        bypass_reg <= bypass_int_reg;
      end if;
    end if;
  end process;

  conv_loop_cnt: process(clk)
  begin
    if rising_edge(clk) then
      if RST = '0' then
        conv_loop <= (others => '0');
        conv_oloop <= (others => '0');
      elsif en = '1' then
        if cnt_rst = '1' and clk_e_pos = '1' then
          conv_loop <= unsigned(dot_cnt);
          conv_oloop <= unsigned(oc_cnt);
        elsif (start = '1' and busy = '1') or (data_valid = '1' and busy = '0') then
          if cnt_rst = '1' then
            conv_loop <= unsigned(dot_cnt);
            conv_oloop <= unsigned(oc_cnt);
          end if;
        elsif busy = '1' or (data_valid = '1' and busy = '0' and conv_loop /= unsigned(dot_cnt)) then
          if conv_out_p = '0' or unsigned(dot_cnt) >= 7 then
            if conv_loop = 0 then
              if conv_oloop /= 0 then
                conv_oloop <= conv_oloop - 1;
                if config(4) = '1' then --reload by config register, bit 4 in configure register
                  conv_loop <= unsigned(dot_cnt);
                end if;
              else
                conv_oloop <= conv_oloop;
              end if;
            elsif conv_loop /= 0 then
              conv_loop <= conv_loop - 1;
            end if;
          elsif unsigned(dot_cnt) < 7 then
            if cyclecounter = 7 then
              if conv_oloop /= 0 then
                conv_oloop <= conv_oloop - 1;
                if config(4) = '1' then --reload by config register, bit 4 in configure register
                  conv_loop <= unsigned(dot_cnt);
                end if;
              else
                conv_oloop <= conv_oloop;
              end if;
            elsif conv_loop /= 0 then
              conv_loop <= conv_loop - 1;
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;

  conv_inst_gen: process(clk)
  begin
    if rising_edge(clk) then
      if RST = '0' then
        inst <= nop;
        ppinst_s <= nop;
      elsif en = '1' then
        if (start = '1' and busy = '1') or (data_valid = '1' and busy = '0') then
          if config(1) = '0' then -- when this bit is not set clear the accumulator for each new computation.
            ppinst_s <= sumfirst;
          else 
            ppinst_s <= sum;
          end if;
          if conv_out_p = '1' then
            inst <= firstconv;
            if max_sel = '1' then
              inst <= firstmax;
            end if;
          else
            inst <= sum;
          end if;
        elsif busy = '1' or (data_valid = '1' and busy = '0' and conv_loop /= unsigned(dot_cnt)) then
          ppinst_s <= sum;
          if conv_out_p = '1' then
            inst <= conv;
            if max_sel = '1' then
              inst <= max;
            end if;
          else
            inst <= sum;
          end if;
          if conv_loop = 0 then
            if conv_out_p = '1' then
              inst <= firstconv;
              if max_sel = '1' then
                inst <= firstmax;
              end if;
            else
              inst <= sum;
            end if;
            ppinst_s <= sumfirst;
            if conv_oloop = 0 or (unsigned(dot_cnt) < 7 and pselector_en = '1') then
              inst <= nop;
              ppinst_s <= nop;
            end if;
          elsif conv_loop /= 0 then
            if conv_loop = 1 then
              ppinst_s <= sum;
              if conv_out_p = '1' then
                inst <= lastconv;
                if max_sel = '1' then
                  inst <= lastmax;
                end if;
              else
                inst <= sum;
              end if;
            end if;
          end if;
        else
          inst <= nop;
          ppinst_s <= nop;
        end if;
      end if;
    end if;
  end process;

  
  conv_addr_ctrl: process(clk)
  begin
    if rising_edge(clk) then
      if RST = '0' then
        left_rst <= '0';
        right_rst <= '0';
        bias_load_int <= '0';
        bias_rd_en_int <= '0';
        ext_load <= '0';
      elsif en = '1' then
        if cnt_rst = '1' and clk_e_pos = '1' then
          if mode_c_l = '0' then
            if mode_a = '1' then
              left_rst <= '1';
            end if;
            if mode_b = '1' then
              right_rst <= '1';
            end if;
          else
            left_rst <= '0';
            right_rst <= '0';
          end if;
        elsif (start = '1' and busy = '1') or (data_valid = '1' and busy = '0') then
          left_rst <= '0';
          right_rst <= '0';
          if pp_ctl(0) = '0' then
            bias_load_int <= '1';
            bias_rd_en_int <= '1';
          else
            bias_load_int <= '0';
            bias_rd_en_int <= '0';
          end if;
          load <= '1';
          rd_en <= '1';
          if cnt_rst = '1' then
            if mode_c_l = '0' then
              if mode_a = '1' or mode_b = '1' then
                if mode_a = '1' and clk_e_pos = '1' then
                  left_rst <= '1';
                end if;
                if mode_b = '1' and clk_e_pos = '1' then
                  right_rst <= '1';
                end if;
              end if;
            end if;
          end if;
        elsif busy = '1' or (data_valid = '1' and busy = '0' and conv_loop /= unsigned(dot_cnt)) then
          left_rst <= '0';
          right_rst <= '0';
          bias_load_int <= '0';
          bias_rd_en_int <= '0';
          if bypass_reg = '1' then
            if data_valid = '0' then
              load <= '0';
              rd_en <= '0';
            end if;
          end if;
          if conv_loop = 0 then
            ext_load <= '0';
            if pp_ctl(0) = '0' then
              bias_load_int <= '1';
              bias_rd_en_int <= '1';
            else
              bias_load_int <= '0';
              bias_rd_en_int <= '0';
            end if;
            if conv_oloop = 0 then
              load <= '0';
              rd_en <= '0';
              bias_load_int <= '0';
              bias_rd_en_int <= '0';
            end if;
          elsif conv_loop /= 0 then
            load <= '1';
            rd_en <= '1';    
            ext_load <= '0'; 
            if conv_loop = 1 then
              if mode_c_l = '1' then
                ext_load <= '1';
              end if;
              if config(2) = '1' then 
                left_rst <= '1';
              end if;
              if config(3) = '1' then
                right_rst <= '1';
              end if;
            end if;
          end if;
        else
          load <= '0';
          rd_en <= '0';
          bias_load_int <= '0';
          bias_rd_en_int <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        pselector_en <= '0';
      elsif (((unsigned(dot_cnt) < 7 and cyclecounter = unsigned(dot_cnt)) or (unsigned(dot_cnt) >=7 and conv_loop = 2)) and busy = '1') then
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
    if conv_out_p = '0' then
      if conv_loop = 1 then
        if pp_ctl(1) = '0' then 
          o_mux_ena <= '1';
        else
          o_mux_ena <= '0';
        end if;
      else
        o_mux_ena <= '0';
      end if;
    else
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

  pushback_stall : process(clk) --stall the computation to push back the result to buffer.
  begin
    if rising_edge(clk) then
      if rst = '0' then
        stall <= x"0";
      else
        if pp_ctl(4 downto 3) = "01" then 
          if conv_oloop = (unsigned(oc_cnt) - 7) and conv_loop = 1 then
            stall <= x"1";--stall the ve core for one clock cycle to push the result back to mem buffer.
          else
            stall <= x"0";
          end if;
        elsif bypass_reg = '1' then
          if (conv_oloop /= 0 or conv_loop /= 0) and data_valid = '0' and busy = '1' then --pause the ve 
            stall <= x"1";
          elsif data_valid = '1' then
            stall <= x"0";
          end if;
        end if;
      end if;
    end if;
  end process;

end architecture; 