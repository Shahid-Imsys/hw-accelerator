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
    clk_p       : in  std_logic;
    clk_d_pos   : in  std_logic;
    clk_da_pos  : in  std_logic;
    rst_n       : in  std_logic;
    fast_d      : in  std_logic;
    short_cycle : in  std_logic;
    -----core1 sdram interface
    c1_d_addr   : in  std_logic_vector(31 downto 0);
    c1_d_cs     : in  std_logic;                     -- CS to SDRAM
    c1_d_ras    : in  std_logic;                     -- RAS to SDRAM
    c1_d_cas    : in  std_logic;                     -- CAS to SDRAM
    c1_d_we     : in  std_logic;                     -- WE to SDRAM
    c1_d_dqi    : in  std_logic_vector(7 downto 0);  -- Data in from processor
    c1_d_dqi_sd : in  std_logic_vector(7 downto 0);  -- Data in from sdram
    c1_d_dqo    : out std_logic_vector(7 downto 0);  -- Data out to processor
    -----core2 sdram interface
    c2_d_addr   : in  std_logic_vector(31 downto 0);
    c2_d_cs     : in  std_logic;                     -- CS to SDRAM
    c2_d_ras    : in  std_logic;                     -- RAS to SDRAM
    c2_d_cas    : in  std_logic;                     -- CAS to SDRAM
    c2_d_we     : in  std_logic;                     -- WE to SDRAM
    c2_d_dqi    : in  std_logic_vector(7 downto 0);  -- Data in from processor
    c2_d_dqo    : out std_logic_vector(7 downto 0);  -- Data out to processor
    --memory interface
    ram_a       : out main_ram_address_t;
    ram_di      : out main_ram_data_t;
    ram_do      : in  main_ram_data_t;
    ram_cs      : out main_ram_cs_t;
    ram_web     : out main_ram_web_t

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
  signal row_addr_1 : std_logic_vector (17 downto 0);
  signal row_addr_2 : std_logic_vector (17 downto 0);

  attribute mark_debug : string;
  attribute mark_debug of c1_data_b1: signal is "true";  
  attribute mark_debug of c1_data_b2: signal is "true";  
  attribute mark_debug of fast_d: signal is "true";  

begin
  row_addr_1 <= c1_d_addr(31 downto 14);
  row_addr_2 <= c2_d_addr(31 downto 14);


  fix_toreq2_p : process (row_addr_2) is
  begin  -- process fix_toreq2_p
    toReq_c2                                   <= (others => '0');
    if unsigned(row_addr_2) < MEMNUM then -- Verify that adress is whitin memory.
      toReq_c2(to_integer(unsigned(row_addr_2))) <= '1';
      end if;
  end process fix_toreq2_p;

  fix_toreq1_p : process (row_addr_1) is
  begin  -- process fix_toreq2_p
    toReq_c1                                   <= (others => '0');
    if unsigned(row_addr_1) < MEMNUM then -- Verify that adress is whitin memory.
      toReq_c1(to_integer(unsigned(row_addr_1))) <= '1';
    end if;
  end process fix_toreq1_p;

  fix_to_req_g : for i in toReq_c2'range generate

  end generate fix_to_req_g;

  valueZero <= (others => '0');
  process (clk_p, rst_n)
  begin
    if rst_n = '0' then
      c1_data_b1 <= x"00";
      c1_data_b2 <= x"00";
      data_en_c1 <= (others => '0');
      exSD_en    <= '0';
    elsif (rising_edge(clk_p)) then
      if clk_d_pos = '0' then           --rising_edge(clk_d)
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
--                      else
--                          data_en_c1 <= (others => '0');
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
      if clk_da_pos = '0' then          --rising_edge(clk_d)
        if (data_en_c2 /= valueZero) then
          c2_data_b1 <= c2_data_inner;
        end if;
        c2_data_b2 <= c2_data_b1;
        if (c2_csb = '0') then
          data_en_c2 <= toReq_c2;
--                      else 
--                          data_en_c2 <= (others => '0');
        end if;
      end if;
    end if;
  end process;
  c1_d_dqo <= c1_d_dqi_sd when exSD_en = '1' else
              c1_data_inner when short_cycle = '1' else
              c1_data_b1    when fast_d = '0' else
              c1_data_b2;
  c2_d_dqo <= c2_data_inner when short_cycle = '1' else
              c2_data_b1 when fast_d = '0' else
              c2_data_b2;

  choose_ram_data_p : process (c1_d_dqi, c2_d_dqi, data_en_c1,
                               data_en_c2, ram_do) is
  begin  -- process choose_ram_data_p
    c1_data_inner <= c1_d_dqi;
    c2_data_inner <= c2_d_dqi;

    for i in ram_do'range loop
      c1_data_inner <= ram_do(i) when data_en_c1(i) = '1';
      c2_data_inner <= ram_do(i) when data_en_c2(i) = '1';
    end loop;  -- i
  end process choose_ram_data_p;


  c1_csb <= c1_d_cs or (not c1_d_ras) or c1_d_cas;
  c2_csb <= c2_d_cs or (not c2_d_ras) or c2_d_cas;

  c1_wr_n <= c1_d_cs or (not c1_d_ras) or c1_d_cas or c1_d_we;
  c2_wr_n <= c2_d_cs or (not c2_d_ras) or c2_d_cas or c2_d_we;

-----------------------RAM0----------------------       index is 1

  set_ram_adress_g : for i in ram_a'range generate
    ram_a(i)   <= c2_d_addr(13 downto 0) when toReq_c2(i) = '1' and c2_csb = '0' else c1_d_addr(13 downto 0);
    ram_di(i)  <= c2_d_dqi               when toReq_c2(i) = '1' and c2_csb = '0' else c1_d_dqi;
    ram_cs(i)  <= not ((c1_csb or (not toReq_c1(i))) and (c2_csb or (not toReq_c2(i))));
    ram_web(i) <= (c1_wr_n or (not toReq_c1(i))) and (c2_wr_n or (not toReq_c2(i)));
  end generate set_ram_adress_g;


-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

end behav;
