---------------------------------------------------
--DESIGNED BY MA NING
--there are two types of memory for application in this dual core processor

--              memory architecture    corresponding bit
--                  FLASH    128 KB           0
--                  RAM4      16 KB           5(seperate power)
--                  RAM3      16 KB           4      
--                  RAM2      16 KB           3      
--                  RAM1      16 KB           2      
--                  RAM0      16 KB           1
--                             
--memory space (4GB)

---------------------------------------------------
--7/22/2014 3:02:01 PM  only core1 can access flash
--6/12/2015 3:18:58 PM  modify to 128 kB flash + 64 kB RAM + 16 kB RAM   
--6/12/2015 4:42:12 PM  Core2 is able to access flash only at very low frequency mode (read_cycle = 0)
--8/31/2016 11:48:08 AM change rst_n to asynchronous
---------------------------------------------------
library IEEE;

use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

use work.gp_pkg.all;

entity sdram_inf is
  port (
    clk_p       : in std_logic;
    even_c      : in std_logic;
    clk_d_pos   : in std_logic;
    clk_da_pos  : in std_logic;
    rst_n       : in std_logic;
    fast_d      : in std_logic;
    short_cycle : in std_logic;
    -----core1 sdram interface
    c1_d_addr   : in std_logic_vector(31 downto 0);
    c1_d_cs     : in std_logic;                     -- CS to SDRAM
    c1_d_ras    : in std_logic;                     -- RAS to SDRAM
    c1_d_cas    : in std_logic;                     -- CAS to SDRAM
    c1_d_we     : in std_logic;                     -- WE to SDRAM
    c1_d_dqi    : in std_logic_vector(7 downto 0);  -- Data in from processor
    c1_d_dqi_sd : in std_logic_vector(7 downto 0);  -- Data in from sdram
    c1_d_dqo    : out std_logic_vector(7 downto 0); -- Data out to processor
    -----core2 sdram interface
    c2_d_addr : in std_logic_vector(31 downto 0);
    c2_d_cs   : in std_logic;                     -- CS to SDRAM
    c2_d_ras  : in std_logic;                     -- RAS to SDRAM
    c2_d_cas  : in std_logic;                     -- CAS to SDRAM
    c2_d_we   : in std_logic;                     -- WE to SDRAM
    c2_d_dqi  : in std_logic_vector(7 downto 0);  -- Data in from processor
    c2_d_dqo  : out std_logic_vector(7 downto 0); -- Data out to processor
    --memory interface
    ram_a   : out main_ram_address_t;
    ram_di  : out main_ram_data_t;
    ram_do  : in main_ram_data_t;
    ram_cs  : out main_ram_cs_t;
    ram_web : out main_ram_web_t

  );
end sdram_inf;

architecture behav of sdram_inf is

  signal c1_wr_n       : std_logic;
  signal c2_wr_n       : std_logic;
  signal c1_csb        : std_logic;
  signal c2_csb        : std_logic;
  signal exSD_en       : std_logic;
  signal c1_data_inner : std_logic_vector (7 downto 0);
  signal c1_data_b1    : std_logic_vector (7 downto 0);
  signal c1_data_b2    : std_logic_vector (7 downto 0);
  signal c2_data_inner : std_logic_vector (7 downto 0);
  signal c2_data_b1    : std_logic_vector (7 downto 0);
  signal c2_data_b2    : std_logic_vector (7 downto 0);

  signal toReq_c1   : std_logic_vector(MEMNUM - 1 downto 0);
  signal toReq_c2   : std_logic_vector(MEMNUM - 1 downto 0);
  signal data_en_c1 : std_logic_vector(MEMNUM - 1 downto 0);
  signal data_en_c2 : std_logic_vector(MEMNUM - 1 downto 0);
  signal valueZero  : std_logic_vector(MEMNUM - 1 downto 0);
  signal pair_addr_1 : std_logic_vector (16 downto 0);
  signal pair_addr_2 : std_logic_vector (16 downto 0);

  signal c1_dqo_buffer   : std_logic_vector (7 downto 0);
  signal c2_dqo_buffer   : std_logic_vector (7 downto 0);
  signal c1_dqi_buffer   : std_logic_vector (7 downto 0);
  signal c2_dqi_buffer   : std_logic_vector (7 downto 0);
  signal c1_addr_buffer  : std_logic_vector (31 downto 0);
  signal c2_addr_buffer  : std_logic_vector (31 downto 0);
  signal toReq_c1_buffer : std_logic_vector(MEMNUM - 1 downto 0);
  signal toReq_c2_buffer : std_logic_vector(MEMNUM - 1 downto 0);
  signal c1_buf          : std_logic; -- Buffer flag for fast writing
  signal c2_buf          : std_logic; -- Buffer flag for fast writing

begin

  valueZero <= (others => '0');

  -- Each pair_addr contains two ram instances
  pair_addr_1 <= c1_d_addr(31 downto 15);
  pair_addr_2 <= c2_d_addr(31 downto 15);

  fix_toreq1_p : process (pair_addr_1) is
  begin -- process fix_toreq2_p
    toReq_c1 <= (others => '0');
    if unsigned(pair_addr_1) < (MEMNUM / 2) then -- Verify that adress is whitin memory.
      toReq_c1(to_integer(unsigned(pair_addr_1))) <= '1';
    end if;
  end process fix_toreq1_p;

  fix_toreq2_p : process (pair_addr_2) is
  begin -- process fix_toreq2_p
    toReq_c2 <= (others => '0');
    if unsigned(pair_addr_2) < (MEMNUM / 2) then -- Verify that adress is whitin memory.
      toReq_c2(to_integer(unsigned(pair_addr_2))) <= '1';
    end if;
  end process fix_toreq2_p;

  process (clk_p, rst_n)
  begin
    if rst_n = '0' then
      c1_data_b1 <= x"00";
      c1_data_b2 <= x"00";
      data_en_c1 <= (others => '0');
      exSD_en    <= '0';

    elsif (rising_edge(clk_p)) then
      if clk_d_pos = '0' then --rising_edge(clk_d)
        if (data_en_c1 /= valueZero) then
          c1_data_b1 <= c1_data_inner;
        end if;
        c1_data_b2 <= c1_data_b1;
        if (c1_csb = '0') then
          data_en_c1 <= toReq_c1;
          if (toReq_c1 = valueZero) then
            exSD_en <= '1';
          else
            exSD_en <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;

  process (clk_p, rst_n)
  begin
    if rst_n = '0' then
      c2_data_b1 <= x"00";
      c2_data_b2 <= x"00";
      data_en_c2 <= (others => '0');

    elsif (rising_edge(clk_p)) then
      if clk_da_pos = '0' then --rising_edge(clk_d)
        if (data_en_c2 /= valueZero) then
          c2_data_b1 <= c2_data_inner;
        end if;
        c2_data_b2 <= c2_data_b1;
        if (c2_csb = '0') then
          data_en_c2 <= toReq_c2;
        end if;
      end if;
    end if;
  end process;

  -- Choose what data goes into dqo buffer to handle fast transfer
  dqo_buffer : process (clk_p, rst_n)
  begin
    if rst_n = '0' then
      c1_dqo_buffer <= x"00";
      c2_dqo_buffer <= x"00";

    elsif (rising_edge(clk_p)) then

      -- Core 1
      for i in 0 to (MEMNUM/2 - 1) loop
        if (even_c = '0' and data_en_c1(i) = '1') then
          if (c1_d_addr(0) = '0') then
            c1_dqo_buffer <= ram_do(2 * i + 1);
          else
            c1_dqo_buffer <= ram_do(2 * i);
          end if;
        end if;

        -- Core 2
        if (even_c = '1' and data_en_c2(i) = '1') then
          if (c2_d_addr(0) = '0') then
            c2_dqo_buffer <= ram_do(2 * i + 1);
          else
            c2_dqo_buffer <= ram_do(2 * i);
          end if;
        end if;
      end loop;
    end if;
  end process;

  -- Get data from RAM or dqo buffer. Core 1 reads data from buffer when Core 2 reads from RAM and vice versa
  choose_ram_data1_p : process (c1_d_dqi, data_en_c1, ram_do, even_c, c1_d_addr, c1_dqo_buffer)
  begin
    c1_data_inner <= c1_d_dqi;

    if (c1_d_addr(0) = '0') then
      if (even_c = '0') then
        for i in 0 to (MEMNUM/2 - 1) loop
          c1_data_inner <= ram_do(i * 2) when data_en_c1(i) = '1';
        end loop; -- i
      else
        c1_data_inner <= c1_dqo_buffer;
      end if;

    else
      if (even_c = '0') then
        for i in 0 to (MEMNUM/2 - 1) loop
          c1_data_inner <= ram_do(i * 2 + 1) when data_en_c1(i) = '1';
        end loop; -- i
      else
        c1_data_inner <= c1_dqo_buffer;
      end if;
    end if;
  end process;

  choose_ram_data2_p : process (c2_d_dqi, data_en_c2, ram_do, even_c, c2_d_addr, c2_dqo_buffer)
  begin
    c2_data_inner <= c2_d_dqi;

    if (c2_d_addr(0) = '0') then
      if (even_c = '1') then
        for i in 0 to (MEMNUM/2 - 1) loop
          c2_data_inner <= ram_do(i * 2) when data_en_c2(i) = '1';
        end loop; -- i
      else
        c2_data_inner <= c2_dqo_buffer;
      end if;

    else
      if (even_c = '1') then
        for i in 0 to (MEMNUM/2 - 1) loop
          c2_data_inner <= ram_do(i * 2 + 1) when data_en_c2(i) = '1';
        end loop; -- i
      else
        c2_data_inner <= c2_dqo_buffer;
      end if;
    end if;
  end process;

  c1_d_dqo <= c1_d_dqi_sd when exSD_en = '1' else
    c1_data_inner when short_cycle = '1' else
    c1_data_b1 when fast_d = '0' else
    c1_data_b2;
  c2_d_dqo <= c2_data_inner when short_cycle = '1' else
    c2_data_b1 when fast_d = '0' else
    c2_data_b2;

  -- If Core 1 tries to write data to RAM on Core 2's clock cycle or vice versa
  -- then buffer data, address and RAM instance pair as well as set a flag.
  -- If address is even then incrementing addresses are used
  -- If address is odd then decrementing addresses are used
  dqi_buffer : process (clk_p, rst_n)
  begin
    if rst_n = '0' then
      c1_dqi_buffer   <= x"00";
      c2_dqi_buffer   <= x"00";
      c1_addr_buffer  <= (others => '0');
      c2_addr_buffer  <= (others => '0');
      toReq_c1_buffer <= (others => '0');
      toReq_c2_buffer <= (others => '0');
      c1_buf          <= '0';
      c2_buf          <= '0';

    elsif (rising_edge(clk_p)) then
      c1_dqi_buffer   <= x"00";
      c2_dqi_buffer   <= x"00";
      c1_addr_buffer  <= (others => '0');
      c2_addr_buffer  <= (others => '0');
      toReq_c1_buffer <= (others => '0');
      toReq_c2_buffer <= (others => '0');
      c1_buf          <= '0';
      c2_buf          <= '0';

      -- Core 1
      if (even_c = '0' and c1_d_we = '0') then
        c1_dqi_buffer   <= c1_d_dqi;
        toReq_c1_buffer <= toReq_c1;
        c1_buf          <= '1';
        if (c1_d_addr(0) = '0') then
          c1_addr_buffer <= std_logic_vector(unsigned(c1_d_addr) + 1);
        else
          c1_addr_buffer <= std_logic_vector(unsigned(c1_d_addr) - 1);
        end if;

        -- Core 2
      elsif (even_c = '1' and c2_d_we = '0') then
        c2_dqi_buffer   <= c2_d_dqi;
        toReq_c2_buffer <= toReq_c2;
        c2_buf          <= '1';
        if (c2_d_addr(0) = '0') then
          c2_addr_buffer <= std_logic_vector(unsigned(c2_d_addr) + 1);
        else
          c2_addr_buffer <= std_logic_vector(unsigned(c2_d_addr) - 1);
        end if;
      end if;
    end if;
  end process;

  c1_csb <= c1_d_cs or (not c1_d_ras) or c1_d_cas;
  c2_csb <= c2_d_cs or (not c2_d_ras) or c2_d_cas;

  c1_wr_n <= c1_d_cs or c1_d_we;
  c2_wr_n <= c2_d_cs or c2_d_we;

  --------------------------------
  -- RAM
  --------------------------------

  -- Set RAM address. Include buffered address for writing if buffer flag is set
  process (toReq_c1, toReq_c2, c1_csb, c2_csb, c1_d_addr, c2_d_addr, even_c, c1_buf, c2_buf, toReq_c1_buffer, toReq_c2_buffer, c1_addr_buffer, c2_addr_buffer)
  begin
    for i in 0 to (MEMNUM/2 - 1) loop
      -- Core 1
      if (even_c = '1') then
        ram_a(2 * i)     <= c1_d_addr(14 downto 1);
        ram_a(2 * i + 1) <= c1_d_addr(14 downto 1);

        if (c1_buf = '1' and toReq_c1_buffer(i) = '1') then
          if (c1_addr_buffer(0) = '0') then
            ram_a(2 * i) <= c1_addr_buffer(14 downto 1);
          else
            ram_a(2 * i + 1) <= c1_addr_buffer(14 downto 1);
          end if;
        end if;

        -- Core 2
      else
        ram_a(2 * i)     <= c2_d_addr(14 downto 1);
        ram_a(2 * i + 1) <= c2_d_addr(14 downto 1);

        if (c2_buf = '1' and toReq_c2_buffer(i) = '1') then
          if (c2_addr_buffer(0) = '0') then
            ram_a(2 * i) <= c2_addr_buffer(14 downto 1);
          else
            ram_a(2 * i + 1) <= c2_addr_buffer(14 downto 1);
          end if;
        end if;
      end if;

    end loop;
  end process;

  -- Set data in to RAM. Include buffered data if buffer flag is set
  process (toReq_c1, toReq_c2, c1_csb, c2_csb, c1_d_dqi, c2_d_dqi, even_c, c1_d_addr, c2_d_addr, c1_buf, c2_buf, c1_addr_buffer, c2_addr_buffer, toReq_c1_buffer, toReq_c2_buffer, c1_dqi_buffer, c2_dqi_buffer)
  begin
    for i in 0 to (MEMNUM/2 - 1) loop

      -- Core1
      if (even_c = '1') then
        if (c1_d_addr(0) = '0') then
          ram_di(2 * i) <= c1_d_dqi;
        else
          ram_di(2 * i + 1) <= c1_d_dqi;
        end if;

        if (c1_buf = '1' and toReq_c1_buffer(i) = '1') then
          if (c1_addr_buffer(0) = '0') then
            ram_di(2 * i) <= c1_dqi_buffer;
          else
            ram_di(2 * i + 1) <= c1_dqi_buffer;
          end if;
        end if;

        -- Core 2
      else
        if (c2_d_addr(0) = '0') then
          ram_di(2 * i) <= c2_d_dqi;
        else
          ram_di(2 * i + 1) <= c2_d_dqi;
        end if;

        if (c2_buf = '1' and toReq_c2_buffer(i) = '1') then
          if (c2_addr_buffer(0) = '0') then
            ram_di(2 * i) <= c2_dqi_buffer;
          else
            ram_di(2 * i + 1) <= c2_dqi_buffer;
          end if;
        end if;
      end if;
    end loop;
  end process;

  process (c1_csb, toReq_c1, c2_csb, toReq_c2, c1_buf, c2_buf) -- CS adjusted for interleaved memory
  begin

    for i in 0 to (MEMNUM/2 - 1) loop
      ram_cs(2 * i)     <= not (((c1_csb and (not c1_buf)) or (not toReq_c1(i))) and ((c2_csb and (not c2_buf)) or (not toReq_c2(i))));
      ram_cs(2 * i + 1) <= not (((c1_csb and (not c1_buf)) or (not toReq_c1(i))) and ((c2_csb and (not c2_buf)) or (not toReq_c2(i))));
    end loop;
  end process;

  -- Activate correct write enable when writing to RAM. Include buffered address if buffer flag is set
  process (c1_wr_n, c2_wr_n, toReq_c1, toReq_c2, even_c, c1_d_addr, c2_d_addr, c1_buf, c2_buf, toReq_c1_buffer, toReq_c2_buffer, c1_addr_buffer, c2_addr_buffer)
  begin
    for i in 0 to (MEMNUM/2 - 1) loop
      ram_web(2 * i)     <= '1';
      ram_web(2 * i + 1) <= '1';

      -- Core 1
      if (even_c = '1') then
        if (c1_wr_n = '0' and toReq_c1(i) = '1') then
          if (c1_d_addr(0) = '0') then
            ram_web(2 * i) <= '0';
          else
            ram_web(2 * i + 1) <= '0';
          end if;
        end if;
        if (c1_buf = '1' and toReq_c1_buffer(i) = '1') then
          if (c1_addr_buffer(0) = '0') then
            ram_web(2 * i) <= '0';
          else
            ram_web(2 * i + 1) <= '0';
          end if;
        end if;
      end if;

      -- Core 2
      if (even_c = '0') then
        if (c2_wr_n = '0' and toReq_c2(i) = '1') then
          if (c2_d_addr(0) = '0') then
            ram_web(2 * i) <= '0';
          else
            ram_web(2 * i + 1) <= '0';
          end if;
        end if;
        if (c2_buf = '1' and toReq_c2_buffer(i) = '1') then
          if (c2_addr_buffer(0) = '0') then
            ram_web(2 * i) <= '0';
          else
            ram_web(2 * i + 1) <= '0';
          end if;
        end if;
      end if;

    end loop;
  end process;

  --------------------------------
  -- RAM
  --------------------------------

end behav;