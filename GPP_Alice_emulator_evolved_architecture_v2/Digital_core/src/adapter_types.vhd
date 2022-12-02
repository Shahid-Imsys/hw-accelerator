library ieee;
use ieee.std_logic_1164.all;

package adapter_types is

	constant AXI_ADDR_WIDTH : integer := 32;
	constant FIFO_BITS : integer := 8;		-- FIFO depth = 2^FIFO_BITS + 1

	-- requests from accelerator to adapter

	type request_t is record
		address : std_logic_vector(31 downto 0);
		length : std_logic_vector(15 downto 0);
		to_ddr : std_logic;							-- to accelerator when 0
	end record request_t;

	function req2slv(constant din : request_t) return std_logic_vector;
	function slv2req(constant din : std_logic_vector) return request_t;

	-- requests from I/O controller to AXI DMA

	type dma_req_t is record
		address : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
		length : std_logic_vector(15 downto 0);
		to_ddr : std_logic;						-- to adapter when 0
	end record dma_req_t;

end adapter_types;


package body adapter_types is

	function req2slv(constant din : request_t) return std_logic_vector is
		variable r : std_logic_vector(48 downto 0);
	begin
		r(31 downto 0) := din.address;
		r(47 downto 32) := din.length;
		r(48) := din.to_ddr;
		return r;
	end req2slv;

	function slv2req(constant din : std_logic_vector) return request_t is
		variable r : request_t;
	begin
		r.address := din(31 downto 0);
		r.length := din(47 downto 32);
		r.to_ddr := din(48);
		return r;
	end slv2req;

end package body adapter_types;
