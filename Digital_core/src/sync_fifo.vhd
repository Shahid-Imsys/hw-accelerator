library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_fifo is
  generic (
    WIDTH : integer := 8;   -- Data width in bits
    BITS : integer := 4     -- fifo depth equal to 2^BITS
  );

  port (
    areset_n : in std_logic;
    clk : in std_logic;
    in_ready : out std_logic;
    in_valid : in std_logic;
    in_data : in std_logic_vector(WIDTH-1 downto 0);
    out_ready : in std_logic;
    out_valid : out std_logic := '0';
    out_data : out std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    level : out std_logic_vector(BITS downto 0)
  );
end sync_fifo;

architecture fpga of sync_fifo is
  type mem_t is array (2**BITS-1 downto 0) of std_logic_vector(WIDTH-1 downto 0);

  signal mem : mem_t := (others => (others => '0'));

  signal wptr : unsigned(BITS downto 0) := (others => '0');
  signal rptr : unsigned(BITS downto 0) := (others => '0');

  signal full  : std_logic;
  signal empty : std_logic;

begin

  -- state combinatorials

  full <= '1' when (wptr(BITS-1 downto 0) = rptr(BITS-1 downto 0)) and (wptr(BITS) /= rptr(BITS)) else
          '0';
  empty <= '1' when wptr = rptr else
           '0';
  level <= std_logic_vector(wptr - rptr);

  -- write machine

  process (clk, areset_n) begin
    if not areset_n then
      wptr <= (others => '0');
    elsif rising_edge(clk) then
      if not full and in_valid then
        mem(to_integer(wptr(BITS-1 downto 0))) <= in_data;
        wptr <= wptr + 1;
      end if;
    end if;
  end process;

  in_ready <= '0' when to_integer(unsigned(level)) = 2**BITS else '1';

  -- read machine

  process (clk, areset_n) begin
    if not areset_n then
      rptr <= (others => '0');
    elsif rising_edge(clk) then
      if not empty and out_ready and out_valid then
        rptr <= rptr + 1;
      end if;
    end if;
  end process;

  out_data  <= mem(to_integer(rptr(BITS-1 downto 0)));
  out_valid <= not empty;

end fpga;
