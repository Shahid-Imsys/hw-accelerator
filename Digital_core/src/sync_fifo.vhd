library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;

entity sync_fifo is 
  generic (
    WIDTH : integer := 8;   -- Data width in bits
    BITS : integer := 4     -- fifo depth equal to 2^BITS + 1
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
  
  signal full : std_logic;
  signal empty : std_logic;   -- does not include ftwt reg

  signal fwft_ready : std_logic;

begin

  -- state combinatorials 

  full <= '1' when (wptr(BITS-1 downto 0) = rptr(BITS-1 downto 0)) and (wptr(BITS) /= rptr(BITS)) else
          '0';
  empty <= '1' when wptr = rptr else 
           '0';
  level <= to_slv(2**BITS + 1, level'length) when full else
           to_slv(1, level'length) when (out_valid and empty) or fwft_ready else
           (others => '0') when empty else
           std_logic_vector(signed(wptr) - signed(rptr) + 1);
  
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

  in_ready <= not full;

  -- read machine

  process (clk, areset_n) begin
    if not areset_n then
      rptr <= (others => '0');
    elsif rising_edge(clk) then
      if not empty and fwft_ready then
        rptr <= rptr + 1;
        out_data <= mem(to_integer(rptr(BITS-1 downto 0)));
      end if;
    end if;
  end process;

  --  fwft logic

  fwft_ready <= (not empty) and (out_ready or not out_valid);

  process (clk, areset_n) begin
    if not areset_n then
      out_valid <= '0';
    elsif rising_edge(clk) then
      if fwft_ready then
        out_valid <= '1';
      elsif out_ready then
        out_valid <= '0';
      end if;
    end if;
  end process;

end fpga;

