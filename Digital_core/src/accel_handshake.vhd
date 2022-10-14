library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use work.adapter_types.all;

entity accel_handshake is
	port (
		-- accelerator interface

		accel_clk : in std_logic;

		accel_io_data : out std_logic_vector(127 downto 0);
		accel_noc_data : in std_logic_vector(127 downto 0);

		accel_noc_address : in std_logic_vector(31 downto 0);
		accel_noc_length : in std_logic_vector(15 downto 0);

		accel_fifo_ready : out std_logic_vector(5 downto 0); -- note: returns /remaining/ words in fifo when accel_noc_data_en = 1 (i.e. tx)
		accel_noc_data_dir : in std_logic;
		accel_noc_data_en : in std_logic;
		accel_noc_write_req : in std_logic;
		accel_write_ack : out std_logic;

		-- adapter interface

		areset_n : in std_logic;
		clk : in std_logic;

		request_ready : in std_logic;
		request_valid : out std_logic;
		request_data : out request_t;

		io_data_ready : out std_logic;
		io_data_valid : in std_logic;
		io_data_data : in std_logic_vector(127 downto 0);

		noc_data_ready : in std_logic;
		noc_data_valid : out std_logic;
		noc_data_data : out std_logic_vector(127 downto 0)
	);
end accel_handshake;

architecture fpga of accel_handshake is

	component sync_fifo is
		generic (WIDTH : integer; BITS : integer);
		port (
			areset_n : in std_logic;
			clk : in std_logic;
			in_ready : out std_logic;
			in_valid : in std_logic;
			in_data : in std_logic_vector(WIDTH-1 downto 0);
			out_ready : in std_logic;
			out_valid : out std_logic;
			out_data : out std_logic_vector(WIDTH-1 downto 0);
			level : out std_logic_vector(BITS downto 0)
		);
	end component;

	component async_fifo is
		generic (WIDTH : integer; BITS : integer);
		port (
			areset_n : in std_logic;
			in_clk : in std_logic;
			in_ready : out std_logic;
			in_valid : in std_logic;
			in_data : in std_logic_vector(WIDTH-1 downto 0);
			out_clk : in std_logic;
			out_ready : in std_logic;
			out_valid : out std_logic;
			out_data : out std_logic_vector(WIDTH-1 downto 0)
		);
	end component;

	signal req_ready : std_logic;
	signal req_valid : std_logic := '0';
	signal req_data_in : request_t;
	signal req_data_out : std_logic_vector(48 downto 0);
	signal req_ack_cnt : integer range 0 to 2 := 0;

	signal rx_in_ready : std_logic;
	signal rx_in_valid : std_logic;
	signal rx_in_data : std_logic_vector(127 downto 0);
	signal rx_out_ready : std_logic;
	signal rx_out_valid : std_logic;
	signal rx_out_data : std_logic_vector(127 downto 0);
	signal rx_level : std_logic_vector(FIFO_BITS downto 0);

	signal tx_in_ready : std_logic;
	signal tx_in_valid : std_logic;
	signal tx_in_data : std_logic_vector(127 downto 0);
	signal tx_out_ready : std_logic;
	signal tx_out_valid : std_logic;
	signal tx_out_data : std_logic_vector(127 downto 0);
	signal tx_level : std_logic_vector(FIFO_BITS downto 0);

	signal rx_level_trunc : std_logic_vector(5 downto 0);
	signal tx_remain_trunc  : std_logic_vector(5 downto 0);
	signal tx_remain : integer;
	constant full_trunc : std_logic_vector(5 downto 0) := std_logic_vector(to_unsigned(2**5 - 1, 6));
	
begin

	rx_level_trunc <= rx_level(5 downto 0) when unsigned(rx_level) < 2**5 else 
										full_trunc;

	tx_remain <= 2**FIFO_BITS - to_integer(signed(tx_level(FIFO_BITS downto 0)));

	tx_remain_trunc <= std_logic_vector(to_signed(tx_remain, tx_remain_trunc'length)) when tx_remain < 2**5 else 
										 full_trunc;

	accel_fifo_ready <= rx_level_trunc when not accel_noc_data_dir else
											tx_remain_trunc;

	-- request data path (accelerator -> dma)

	req_data_in <= (address => accel_noc_address, length => accel_noc_length, to_ddr => accel_noc_data_dir);

	req_cdc : async_fifo
		generic map (WIDTH => 16+32+1, BITS => 2)
		port map (
			areset_n => areset_n,
			in_clk => accel_clk,
			in_ready => req_ready,
			in_valid => req_valid,
			in_data => req2slv(req_data_in),
			out_clk => clk,
			out_ready => request_ready,
			out_valid => request_valid,
			out_data => req_data_out);

	request_data <= slv2req(req_data_out);

	process (accel_clk, areset_n) begin		-- miinimal fsm
		if not areset_n then
			req_ack_cnt <= 0;
		elsif rising_edge(accel_clk) then
			if (req_ack_cnt = 0) and accel_noc_write_req = '1' and req_ready = '1' then
				req_ack_cnt <= 2;
			elsif req_ack_cnt /= 0 then
				req_ack_cnt <= req_ack_cnt - 1;
			end if;
		end if;
	end process;

	process (accel_clk, areset_n) begin
		if not areset_n then
			req_valid <= '0';
		elsif rising_edge(accel_clk) then
			req_valid <= '1' when req_ack_cnt = 2 else '0';
		end if;
	end process;

	accel_write_ack <= '1' when req_ack_cnt /= 0 else '0';

	-- rx data path (ddr -> accelerator)

	rx_cdc : async_fifo
		generic map (WIDTH => 128, BITS => 2)
		port map (
			areset_n => areset_n,
			in_clk => clk,
			in_ready => io_data_ready,
			in_valid => io_data_valid,
			in_data => io_data_data,
			out_clk => accel_clk,
			out_ready => rx_in_ready,
			out_valid => rx_in_valid,
			out_data => rx_in_data);

	rx_fifo : sync_fifo
		generic map (WIDTH => 128, BITS => FIFO_BITS)
		port map (
			areset_n => areset_n,
			clk => accel_clk,
			in_ready => rx_in_ready,
			in_valid => rx_in_valid,
			in_data => rx_in_data,
			out_ready => rx_out_ready,
			out_valid => rx_out_valid,
			out_data => rx_out_data,
			level => rx_level);

	rx_out_ready <= not accel_noc_data_dir and accel_noc_data_en;
	accel_io_data <= rx_out_data;

	-- tx data path (accelerator -> ddr)

	tx_fifo : sync_fifo
		generic map (WIDTH => 128, BITS => FIFO_BITS)
		port map (
			areset_n => areset_n,
			clk => accel_clk,
			in_ready => tx_in_ready,
			in_valid => tx_in_valid,
			in_data => tx_in_data,
			out_ready => tx_out_ready,
			out_valid => tx_out_valid,
			out_data => tx_out_data,
			level => tx_level);

	tx_in_valid <= accel_noc_data_dir and accel_noc_data_en;
	tx_in_data <= accel_noc_data;

	tx_cdc : async_fifo
		generic map (WIDTH => 128, BITS => 2)
		port map (
			areset_n => areset_n,
			in_clk => accel_clk,
			in_ready => tx_out_ready,
			in_valid => tx_out_valid,
			in_data => tx_out_data,
			out_clk => clk,
			out_ready => noc_data_ready,
			out_valid => noc_data_valid,
			out_data => noc_data_data);

end fpga;
