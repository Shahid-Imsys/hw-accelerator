library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use work.adapter_types.all;

entity adapter is
	port (
		---*** accelerator interface (see DNN-SYS5023) ***---

		accel_clk : in std_logic;

		-- accelerator data/control interface

		accel_io_data : out std_logic_vector(127 downto 0);
		accel_noc_data : in std_logic_vector(127 downto 0);

		accel_noc_address : in std_logic_vector(31 downto 0);
		accel_noc_length : in std_logic_vector(15 downto 0);

		accel_fifo_ready : out std_logic_vector(5 downto 0);
		accel_noc_data_dir : in std_logic;
		accel_noc_data_en : in std_logic;
		accel_noc_write_req : in std_logic;
		accel_write_ack : out std_logic;

		---*** AXI domain interface ***---

		clk : in std_logic;
		areset_n : in std_logic;

		-- Request interface to I/O contoller (i.e. super DMA controller)

		request_ready : in std_logic;		-- accepts one read and one write request in parallel
		request_valid : out std_logic;
		request_data : out request_t;

		-- DMA control interface

		dma_ready : out std_logic;			-- accepts one read and one write request in parallel
		dma_valid : in std_logic;
		dma_data : in dma_req_t;
		dma_complete : out std_logic;		-- asserted for 1cy when one DMA transfer is completed

		-- AXI master interface to DDR subsystem

		--- write address channel
		m_axi_awaddr : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
		m_axi_awvalid : out std_logic;
		m_axi_awready : in std_logic;
		--- write data channel
		m_axi_wdata : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
		m_axi_wvalid : out std_logic;
		m_axi_wready : in std_logic;
		m_axi_wstrb : out std_logic_vector((AXI_DATA_WIDTH/8)-1 downto 0);
		--- write response channel
		m_axi_bvalid : in std_logic;
		m_axi_bready : out std_logic;
		m_axi_bresp : in std_logic_vector(1 downto 0);
		--- read address channel
		m_axi_araddr : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
		m_axi_arvalid : out std_logic;
		m_axi_arready : in std_logic;
		--- read data channel
		m_axi_rdata : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
		m_axi_rvalid : in std_logic;
		m_axi_rready : out std_logic;
		m_axi_rresp : in std_logic_vector(1 downto 0)
	);
end adapter;

architecture fpga_rtl of adapter is

	---*** accelerator interface (see DNN-SYS5023) ***---

	---*** AXI domain interface ***---

begin

	---*** accelerator interface (see DNN-SYS5023) ***---


	---*** AXI domain interface ***---

end fpga_rtl;
