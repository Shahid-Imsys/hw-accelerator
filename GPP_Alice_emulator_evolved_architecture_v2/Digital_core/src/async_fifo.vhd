library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;

entity async_fifo is
	generic (
		WIDTH : integer := 8;		-- Data width in bits
		BITS : integer := 4			-- fifo depth equal to 2^BITS + 1
	);

	port (
		areset_n : in std_logic;
		in_clk : in std_logic;
		in_ready : out std_logic;
		in_valid : in std_logic;
		in_data : in std_logic_vector(WIDTH-1 downto 0);
		out_clk : in std_logic;
		out_ready : in std_logic;
		out_valid : out std_logic := '0';
		out_data : out std_logic_vector(WIDTH-1 downto 0) := (others => '0')
	);
end async_fifo;

architecture fpga of async_fifo is
	type mem_t is array (2**BITS-1 downto 0) of std_logic_vector(WIDTH-1 downto 0);

	signal mem : mem_t := (others => (others => '0'));

	signal wptr : unsigned(BITS downto 0) := (others => '0');
	signal rptr : unsigned(BITS downto 0) := (others => '0');

	signal full : std_logic;
	signal empty : std_logic;

	component gray_cdc is
		generic (WIDTH : integer);
		port (
			clk : in std_logic;
			reset_n : in std_logic;
			input : in unsigned(WIDTH-1 downto 0);
			output : out unsigned(WIDTH-1 downto 0)
		);
	end component;

	signal wptr_g : unsigned(BITS downto 0);
	signal rptr_g : unsigned(BITS downto 0);

	signal fwft_ready : std_logic;

begin

	-- clock domain crossing for r/w pointers using gray code

	rpg : gray_cdc
	generic map (WIDTH => BITS+1)
	port map (clk => in_clk,
					  reset_n => areset_n,
						input => rptr,
						output => rptr_g);

	wpg : gray_cdc
	generic map (WIDTH => BITS+1)
	port map (clk => out_clk,
					  reset_n => areset_n,
						input => wptr,
						output => wptr_g);

	-- state combinatorials

	full <= '1' when (wptr(BITS-1 downto 0) = rptr_g(BITS-1 downto 0)) AND (wptr(BITS) /= rptr_g(BITS))
					else '0';
	empty <= '1' when (wptr_g = rptr)
					 else '0';
	
	-- write machine

	process (in_clk, areset_n) begin
			if not areset_n then
				wptr <= (others => '0');
			elsif rising_edge(in_clk) then
				if not full and in_valid then
					wptr <= wptr + 1;
					mem(to_integer(wptr(BITS-1 downto 0))) <= in_data;
				end if;
			end if;
	end process;

	in_ready <= not full;

	-- read machine

	process (out_clk, areset_n) begin
			if not areset_n then
				rptr <= (others => '0');
			elsif rising_edge(out_clk) then
				if not empty and fwft_ready then
					rptr <= rptr + 1;
					out_data <= mem(to_integer(rptr(BITS-1 downto 0)));
				end if;
			end if;
	end process;

	--	fwft logic

	fwft_ready <= not empty and (out_ready or not out_valid);

	process (out_clk, areset_n) begin
		if not areset_n then
		  out_valid <= '0';
		elsif rising_edge(out_clk) then
			if fwft_ready then
				out_valid <= '1';
			elsif out_ready then
				out_valid <= '0';
			end if;
		end if;
	end process;

end fpga;
