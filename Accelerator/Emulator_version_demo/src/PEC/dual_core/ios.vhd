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
-- Title      : I/O subsystem
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : ios.vhd
-- Author     : Xing Zhao
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: I/O interface controller.
-- 
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		3.4 			CB			Created
-- 2005-12-15		3.5 			CB			Changed iden to active high
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.gp_pkg.all;
use work.mpgmfield_lib.all;

entity ios is   
  port (
    -- Clock and reset signals
    rst_en      : in    std_logic;      -- Reset (active low)  
    clk_p       : in    std_logic;
    clk_c_en    : in    std_logic;      -- Oscillator clock
    clk_c2_pos  : in    std_logic;      -- clk_c / 2
--    even_c      : in    std_logic;      -- High during even clk_c cycles
    clk_e_pos       : in    std_logic;      -- Execution clock   
    clk_e_neg       : in    std_logic;      -- Execution clock     
    --gate_e      : in    std_logic;      -- Copy of execution clock used for gating 
    clk_i_pos       : in    std_logic;      -- I/O clock
--    gate_i      : in    std_logic;      -- Copy of clk_i used for gating 
    -- Microprogram fields
    pl         : in    std_logic_vector(127 downto 0);   -- PD field
    -- Static control inputs
    -- Static control inputs
    use_direct  : in    std_logic;      -- Set when the direct bus is used
    dbl_direct  : in    std_logic;      -- Set if direct traffic is double-speed
    i_double    : in    std_logic;      -- Set when IOMEM pointer should double step
    -- Control inputs
    held_e      : in    std_logic;      -- High when clk_e is stopped (high)
    pend_i      : in    std_logic;      -- High when clk_i rising edge pending
    -- Data paths
    dbus        : in    std_logic_vector(7 downto 0);   -- D bus
    direct      : in    std_logic_vector(7 downto 0);   -- Direct data bus
    i_direct    : out   std_logic_vector(7 downto 0);   -- Source for direct bus mux in MMR
    dfio        : out   std_logic_vector(7 downto 0);   -- Source for D bus mux in DSL
    -- Control outputs
    hold_e      : out   std_logic;      -- Set high by this block to delay clk_e'
    -- I/O bus
    ilioa       : out   std_logic;      -- Load I/O address, active low 
    ildout      : out   std_logic;      -- Load output, active low
    inext       : out   std_logic;      -- Next input, active low
    idack       : out   std_logic_vector(DMA_CHANNELS-1 downto 0); -- DMA acknowledge
    idreq       : in    std_logic_vector(DMA_CHANNELS-1 downto 0); -- DMA request
    idi         : in    std_logic_vector(7 downto 0);   -- I/O data bus input
    ido         : out   std_logic_vector(7 downto 0);   -- I/O data bus output
    ios_iden    : out   std_logic;      -- I/O data bus enable
    iden        : in    std_logic;      -- High when I/O bus is driven by on-chip peripheral
    -- IOMEM signals
    iomem_ce_n  : out   std_logic_vector(1 downto 0);   -- Chip enable (active low)
    iomem_we_n  : out   std_logic;      -- Write enable (active low)
    iomem_a     : out   std_logic_vector(IOMEM_ADDR_WIDTH-2 downto 0);  -- Address
    iomem_d     : out   std_logic_vector(15 downto 0);  -- Data in
    iomem_q     : in    std_logic_vector(15 downto 0) -- Data out
    --CJ start
    --req_logic_sig         : out std_logic; --used to generate req_sig
    --ack_sig               : in std_logic;
    --pe_request            : out std_logic_vector(31 downto 0); --used to generate pe_req_in
    --data_dfm              : in std_logic_vector(127 downto 0);
    --dfm_vld               : in std_logic
    
  );


end ios;

architecture rtl of ios is
  -- Timing conversion signals
  signal dis_io       : std_logic;-- Disengage I/O bus
  signal lioa_e       : std_logic;-- Load I/O address in the clk_e domain
  signal ldout_e      : std_logic;-- Load output in the clk_e domain
  signal next_e       : std_logic;-- Next input in the clk_e domain
  signal sync_e       : std_logic;-- Sync in the clk_e domain
  signal lioa_i       : std_logic;-- Load I/O address in the clk_e domain, stretched to clk_i
  signal ldout_i      : std_logic;-- Load output in the clk_e domain, stretched to clk_i
  signal next_i       : std_logic;-- Next input in the clk_e domain, stretched to clk_i
  signal sync_i       : std_logic;-- Sync in the clk_e domain, stretched to clk_i
  signal lioa_pend    : std_logic;-- Help FF to stretch load I/O address
  signal ldout_pend   : std_logic;-- Help FF to stretch load output
  signal next_pend    : std_logic;-- Help FF to stretch next input
  signal sync_pend    : std_logic;-- Help FF to stretch sync
  signal dbus_pend    : std_logic_vector(7 downto 0);-- Help register to stretch D bus
  signal pend_dma     : std_logic;-- Indicate DMA I/O operation in the next cycle
  signal input_dma    : std_logic;-- Indicate input DMA I/O operation in this cycle
  signal block_out    : std_logic;-- Block output I/O operations in the next cycle
  signal blocked_pio  : std_logic;-- High when a programmed operation was blocked
  signal pend_pio     : std_logic;-- Indicate programmable I/O operation in the next cycle
  signal wait_clk_e  : std_logic;
  signal wait_inext  : std_logic_vector(1 downto 0);
  signal idi_reg     : std_logic_vector(7 downto 0); -- I/O bus input register
  -- I/O bus data output buses
  signal ido_core    : std_logic_vector(7 downto 0); -- I/O data bus output from core
  signal iden_core   : std_logic; -- I/O data bus enable from DMA controller
  signal ido_dma     : std_logic_vector(7 downto 0); -- I/O data bus output from DMA controller
  signal iden_dma    : std_logic; -- I/O data bus enable from DMA controller
  signal ido_mem     : std_logic_vector(7 downto 0);-- I/O data bus output from IOMEM
  signal iden_mem    : std_logic; -- I/O data bus enable from IOMEM

  signal ilioa_int   : std_logic; -- Load I/O address, active low
  signal ildout_int  : std_logic; -- Load output, active low
  signal inext_int   : std_logic; -- Next input, active low
  signal i_direct_int: std_logic_vector(7 downto 0);
  signal idreq_int   : std_logic_vector(DMA_CHANNELS-1 downto 0);
  
  signal pl_pd_sig   : std_logic_vector(2 downto 0);   -- PD field
  attribute syn_keep : boolean;
  attribute syn_keep of idreq_int : signal is true;
  
begin
  pl_pd_sig <= ((pl(19) xor pl(66))&(pl(43) xor pl(39))& pl(38));
  -- Create I/O data bus enable
  ios_iden <= '1' when iden_core = '1' or iden_dma = '1' or iden_mem = '1' else '0';  
  -- Mux out ido
--  with std_logic_vector'(iden_dma, iden_mem) select 
--    ido <= ido_dma  when "10",
--           ido_mem  when "01",
--           ido_core when others;  
	ido <=	ido_dma when iden_dma = '1' and iden_mem = '0' else
					ido_mem when iden_dma = '0' and iden_mem = '1' else
					ido_core;
  
  -------------------------------------------------------------------------------
  -- Core -> I/O domain timing scheme conversion
  -------------------------------------------------------------------------------
  -- Decode PD field to create I/O control signals in the clk_e domain.
  -- The decodes are disabled if clk_e is held.
  lioa_e   <= '1' when held_e = '0' and pl_pd_sig = PD_LOADIOADDR   else '0';
  ldout_e  <= '1' when held_e = '0' and pl_pd_sig = PD_LDOUTPUT     else '0';
  next_e   <= '1' when held_e = '0' and pl_pd_sig = PD_NEXTINPUT    else '0';
  sync_e   <= '1' when held_e = '0' and pl_pd_sig = PD_SYNC         else '0';

  -- Gate the decodes with dis_io and extend them to the next rising clk_i edge. 
  lioa_i   <= lioa_e or lioa_pend;
  ldout_i  <= (ldout_e and not dis_io) or ldout_pend;
  next_i   <= (next_e and not dis_io) or next_pend;
  sync_i   <= sync_e or sync_pend;

  -- This signal is used to block output operations (both programmed and
  -- DMA) in the cycle immediately following an input operation.
--  block_out <=	'0' when iden = '1' else
  block_out <=	'1' when inext_int = '0' or input_dma = '1' else
  							'0';
  
  -- These FFs help with extending the PD field decodes to the clk_i edge.

  pend_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then--rising_edge(clk_c2)  
        if rst_en = '0' then  
            lioa_pend <= '0';
            ldout_pend <= '0';
            next_pend <= '0';
            sync_pend <= '0';
        elsif clk_c2_pos = '0' then
            lioa_pend <= lioa_i;
            ldout_pend <= ldout_i;
            next_pend <= next_i;
            sync_pend  <= sync_i;
            if pend_i = '1' then
              sync_pend <= '0';
              if pend_dma = '0' then
                next_pend <= '0';
                if block_out = '0' then
                  lioa_pend <= '0';
                  ldout_pend <= '0';
                end if;
              end if;
            end if;
        end if;
    end if;
  end process pend_gen;
  
  -- Save D bus value on output operations that will be pending.
  dbus_pend_gen: process (clk_p)
  begin  
    if rising_edge(clk_p) then--rising_edge(clk_e)
        if rst_en = '0' then
           dbus_pend <= (others => '0'); 
        elsif clk_e_pos = '0' then
            if pend_i = '0' or pend_dma = '1' or block_out = '1' then
              if lioa_e = '1' or (ldout_e = '1' and dis_io = '0') then
                dbus_pend <= dbus;
              end if;
            end if;
        end if;
    end if;
  end process dbus_pend_gen;

  -- Hold clk_e if a new I/O operation is attempted while another is pending.
  hold_e <= '1' when (pl_pd_sig = PD_LOADIOADDR or pl_pd_sig = PD_LDOUTPUT or
                      pl_pd_sig = PD_NEXTINPUT or pl_pd_sig = PD_SYNC) and
                     (lioa_pend = '1' or ldout_pend = '1' or
                      next_pend = '1' or sync_pend = '1')
            else '0';   
  
  -- Indicate that a programmable I/O operation will occur in the next cycle.
  pend_pio <= lioa_i or ldout_i or next_i;

  -- Clock out any I/O operations on the interface.
  clk_i_output: process (clk_p)
  begin
    if rising_edge(clk_p) then    --rising_edge(clk_i) 
        if rst_en = '0' then          
            ilioa_int <= '1';
            ildout_int <= '1';
            inext_int <= '1';
        elsif clk_i_pos = '0' then
            ilioa_int <= '1';
            ildout_int <= '1';
            inext_int <= '1';
            if pend_dma = '0' then
              inext_int <= not next_i;
              if block_out = '0' then
                ilioa_int <= not lioa_i;
                ildout_int <= not ldout_i;
              end if;
            end if;
        end if;
    end if;
  end process clk_i_output;
  ilioa  <= ilioa_int;
  ildout <= ildout_int;
  inext  <= inext_int;

  -- Indicate that a programmed output operation was blocked by a previous
  -- input operation.
  blocked_pio_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then--rising_edge(clk_i) 
        if rst_en = '0' then          
            blocked_pio <= '0';
        elsif clk_i_pos = '0' then
            blocked_pio <= (lioa_i or ldout_i) and block_out and not pend_dma;
        end if;
    end if;
  end process blocked_pio_gen;

  -- Enable the data bus on output operations.
  iden_core <= '1' when ilioa_int = '0' or ildout_int = '0'
               else '0';
  
  -- Clock out new bus data on output operations.
  ido_core_gen: process (clk_p)
  begin 
    if rising_edge(clk_p) then --rising_edge(clk_i)
        if rst_en = '0' then
            ido_core <= (others => '0');
        elsif clk_i_pos = '0' then
            if lioa_i = '1' or ldout_i = '1' then 
              if lioa_pend = '0' and ldout_pend = '0' then
                ido_core <= dbus;
              else
                ido_core <= dbus_pend;
              end if;        
            end if;
        end if;        
    end if;
  end process ido_core_gen;

  -- These signals keep track of the different cases possible
  -- on input operations.       

  process (clk_p)
  begin
    if rising_edge(clk_p) then--rising_edge(clk_c2)
        if rst_en = '0' then
            wait_inext <= "00";
            wait_clk_e <= '0';
        elsif clk_c2_pos = '0' then
            if dis_io = '0' then
              if (inext_int = '0' and pend_i = '1') xor (next_e = '1') then
                if next_e = '1' then
                  wait_inext <= wait_inext + 1;
                else
                  wait_inext <= wait_inext - 1;
                end if;
              end if;
            end if;
            if next_e = '1' then
              wait_clk_e <= '1';
            elsif held_e = '0' then
              wait_clk_e <= '0';
            end if;
        end if;
    end if;
  end process;
  
  -- This register hold input data until it can be accepted by the
  -- DFIO register if clk_e is held.
  idi_reg_gen: process (clk_p)
  begin 
    if rising_edge(clk_p) then    --rising_edge(clk_i)
        if rst_en = '0' then
            idi_reg <= (others => '0');
        elsif inext_int = '0' and clk_i_pos = '0' then
            idi_reg <= idi;
      end if;
    end if;
  end process idi_reg_gen;
  
  -- Clock in data from the data bus on input operations.
  -- When the I/O bus is disengaged, DFIO is taken from the direct bus
  -- rather than from the I/O data bus.

  dfio_gen: process (clk_p)
  begin 
    if rising_edge(clk_p) then--rising_edge(clk_c2)
        if rst_en = '0' then
            dfio <= (others => '0');
        elsif clk_c2_pos = '0' then
            if dis_io = '0' then
              if inext_int = '0' and pend_i = '1' and
                (held_e = '0' or wait_inext = "10" or wait_clk_e = '0') then
                dfio <= idi;
              elsif held_e = '0' and wait_inext = "00" and wait_clk_e = '1' then
                dfio <= idi_reg;
              end if;
            elsif wait_clk_e = '1' and held_e = '0' then
              dfio <= i_direct_int;
            end if;
        end if;
    end if;
  end process dfio_gen;

-------------------------------------------------------------------------------
-- DMA controller
-------------------------------------------------------------------------------
  idreq_int <= idreq;
  ios_dma0: entity work.ios_dma
    port map (
      rst_en       => rst_en,
      clk_p        => clk_p,
      clk_c_en        => clk_c_en,
      clk_c2_pos       => clk_c2_pos,
--      even_c       => even_c,
      clk_e_pos        => clk_e_pos,
      clk_e_neg        => clk_e_neg,
      --gate_e       => gate_e,
      clk_i_pos        => clk_i_pos,
      use_direct   => use_direct,
      dbl_direct   => dbl_direct,
      i_double     => i_double,
      held_e       => held_e,
      pend_i       => pend_i,
      pend_pio     => pend_pio,
      pend_dma     => pend_dma,
      input_dma    => input_dma,
      block_out    => block_out,
      blocked_pio  => blocked_pio,
      dis_io       => dis_io,
      dbus         => dbus,
      direct       => direct,
      i_direct     => i_direct_int,
      ilioa        => ilioa_int,
      ildout       => ildout_int,
      inext        => inext_int,
      ldout_e      => ldout_e,
      next_e       => next_e,
      idack        => idack,
      idreq        => idreq_int,
      idi          => idi,
      ido_core     => ido_core,
      ido_mem      => ido_mem,
      iden_mem     => iden_mem,
      ido_dma      => ido_dma,
      iden_dma     => iden_dma,
      iomem_ce_n   => iomem_ce_n,
      iomem_we_n   => iomem_we_n,
      iomem_a      => iomem_a,
      iomem_d      => iomem_d,
      iomem_q      => iomem_q);
  i_direct <= i_direct_int;
end rtl;
