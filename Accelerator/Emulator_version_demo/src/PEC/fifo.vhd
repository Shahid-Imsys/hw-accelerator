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
-- Title      : fifo
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : fifo.vhd
-- Author     : Chuhang Jin
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: Ringed buffer used as DTM FIFO
--              
--              
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date                                 Version         Author  Description
-- 2022-5-9                  1.0             CJ                 Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity fifo is
  generic(
    DATA_WIDTH         : integer;
    DATA_DEPTH         : integer;
    PROG_FULL_TRESHOLD : integer;
    USE_ASIC_MEMORIES  : boolean := true
    );
  port(
    clk          : in  std_logic;
    --rd_clk       : in std_logic;
    srst         : in  std_logic;
    rd_en        : in  std_logic;
    wr_en        : in  std_logic;
    full         : out std_logic;
    almost_full  : out std_logic;
    empty        : out std_logic;
    almost_empty : out std_logic;
    prog_full    : out std_logic;
    valid        : out std_logic;
    din          : in  std_logic_vector(DATA_WIDTH -1 downto 0);
    dout         : out std_logic_vector(DATA_WIDTH-1 downto 0);
    counter      : out integer range DATA_DEPTH-1 downto 0
    );
end entity;

architecture rtl of fifo is

  component SNPS_RF_DP_HD_256x80 is
    port (
      QB        : out std_logic_vector(79 downto 0);
      ADRA      : in  std_logic_vector(7 downto 0);
      DA        : in  std_logic_vector(79 downto 0);
      WEA       : in  std_logic;
      MEA       : in  std_logic;
      CLKA      : in  std_logic;
      TEST1A    : in  std_logic;
      TEST_RNMA : in  std_logic;
      RMEA      : in  std_logic;
      RMA       : in  std_logic_vector(3 downto 0);
      WA        : in  std_logic_vector(1 downto 0);
      WPULSE    : in  std_logic_vector(2 downto 0);
      LS        : in  std_logic;
      ADRB      : in  std_logic_vector(7 downto 0);
      MEB       : in  std_logic;
      CLKB      : in  std_logic;
      TEST1B    : in  std_logic;
      RMEB      : in  std_logic;
      RMB       : in  std_logic_vector(3 downto 0)
      );
  end component;

  type ram_type is array (DATA_DEPTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal ram : ram_type;

  subtype index_type is integer range ram_type'range;
  signal head     : index_type;
  signal tail     : index_type;
  signal tail_reg : index_type;

  signal almost_full_i  : std_logic;
  signal almost_empty_i : std_logic;
  signal empty_i        : std_logic;
  signal full_i         : std_logic;
  signal prog_full_i    : std_logic;
  signal valid_i        : std_logic;
  signal counter_i      : integer range DATA_DEPTH-1 downto 0;

  type DataOut_DP_type is array(natural range <>) of std_logic_vector(159 downto 0);
  signal DataOut_DP  : DataOut_DP_type(3 downto 0);
  signal WE_DP       : std_logic_vector(3 downto 0);
  signal Head_MemSel : integer range 0 to 3;
  signal Tail_MemSel : integer range 0 to 3;
  signal Head_Addr   : std_logic_vector(7 downto 0);
  signal Tail_Addr   : std_logic_vector(7 downto 0);
  signal rd_en_d     : std_logic;
  signal dout_reg    : std_logic_vector(DATA_WIDTH-1 downto 0);

  procedure increase (signal index : inout index_type) is
  begin
    if index = index_type'high then
      index <= index_type'low;
    else
      index <= index +1;
    end if;
  end procedure;

begin
  --HEAD
  process (clk)
  begin
    if rising_edge(clk) then
      if srst = '1' then
        head <= 0;
      elsif wr_en = '1' and full_i = '0'then
        increase(head);
      end if;
    end if;
  end process;

  --TAIL AND VALID FLAG
  process(clk)
  begin
    if rising_edge(clk) then
      if srst = '1' then
        tail     <= 0;
        tail_reg <= 0;
        valid_i  <= '0';
        rd_en_d  <= '0';
        dout_reg <= (others => '0');
      else
        rd_en_d <= rd_en;
        
        if rd_en = '1' then
          tail_reg <= tail;
        end if;

        if rd_en_d = '1' then
          dout_reg <= DataOut_DP(Tail_MemSel);
        end if;
        
        if rd_en = '1' and empty_i = '0' then
          increase(tail);
          valid_i <= '1';
        else
          valid_i <= '0';
        end if;
      end if;
    end if;
  end process;

  --DATA TRANSFER
  req_fifo_asic_gen : if USE_ASIC_MEMORIES = true generate

    dout        <= DataOut_DP(Tail_MemSel) when rd_en_d = '1' else dout_reg;
    Tail_Addr   <= std_logic_vector(to_unsigned(tail mod 256, 8)) when rd_en = '1' else std_logic_vector(to_unsigned(tail_reg mod 256, 8));
    Tail_MemSel <= tail / 256                                     when rd_en = '1' else tail_reg / 256;
    
    Head_MemSel <= head / 256;
    Head_Addr   <= std_logic_vector(to_unsigned(head mod 256, 8));
    

    dp_gen : for i in 0 to 3 generate
      WE_DP(i) <= wr_en when Head_MemSel = i else '0';


      req_fifo_mem0 : SNPS_RF_DP_HD_256x80
        port map (
          QB        => DataOut_DP(i)(79 downto 0),
          ADRA      => Head_Addr,
          DA        => din(79 downto 0),
          WEA       => WE_DP(i),
          MEA       => '1',
          CLKA      => clk,
          TEST1A    => '0',
          TEST_RNMA => '0',
          RMEA      => '0',
          RMA       => (others => '0'),
          WA        => (others => '0'),
          WPULSE    => (others => '0'),
          LS        => '0',
          ADRB      => Tail_Addr,
          MEB       => '1',
          CLKB      => clk,
          TEST1B    => '0',
          RMEB      => '0',
          RMB       => (others => '0'));

      req_fifo_mem1 : SNPS_RF_DP_HD_256x80
        port map (
          QB        => DataOut_DP(i)(159 downto 80),
          ADRA      => Head_Addr,
          DA        => din(159 downto 80),
          WEA       => WE_DP(i),
          MEA       => '1',
          CLKA      => clk,
          TEST1A    => '0',
          TEST_RNMA => '0',
          RMEA      => '0',
          RMA       => (others => '0'),
          WA        => (others => '0'),
          WPULSE    => (others => '0'),
          LS        => '0',
          ADRB      => Tail_Addr,
          MEB       => '1',
          CLKB      => clk,
          TEST1B    => '0',
          RMEB      => '0',
          RMB       => (others => '0'));
    end generate;
  end generate;

  req_fifo_sim_gen : if USE_ASIC_MEMORIES /= true generate
    process(clk)
    begin
      if rising_edge(clk) then
        if srst = '1' then
          ram  <= (others => (others => '0'));
          dout <= (others => '0');
        else
          if wr_en = '1' then
            ram(head) <= din;
          end if;

          if rd_en = '1' then
            dout <= ram(tail);
          end if;
        end if;
      end if;
    end process;
    ----DATA READ
    --process(clk)
    --begin
    --    if rising_edge(clk) then
    --        if rd_en = '1' and empty_i = '0' then
    --            dout <= ram(tail);
    --        end if;
    --    end if;
    --end process;

  end generate;

  --COUNTER
  process(head, tail)
  begin
    if head < tail then
      counter_i <= DATA_DEPTH + head - tail;
    else
      counter_i <= head - tail;
    end if;
  end process;

  --FLAGS
  process(counter_i)
  begin
    if counter_i = 0 then
      empty_i <= '1';
    else
      empty_i <= '0';
    end if;

    if counter_i <= 1 then
      almost_empty_i <= '1';
    else
      almost_empty_i <= '0';
    end if;

    if counter_i = DATA_DEPTH-1 then
      full_i <= '1';
    else
      full_i <= '0';
    end if;

    if counter_i >= DATA_DEPTH -2 then
      almost_full_i <= '1';
    else
      almost_full_i <= '0';
    end if;

    if counter_i >= PROG_FULL_TRESHOLD then
      prog_full_i <= '1';
    else
      prog_full_i <= '0';
    end if;
  end process;

  --OUTPUT
  empty        <= empty_i;
  almost_empty <= almost_empty_i;
  full         <= full_i;
  almost_full  <= almost_full_i;
  prog_full    <= prog_full_i;
  valid        <= valid_i;
  counter      <= counter_i;


end rtl;
