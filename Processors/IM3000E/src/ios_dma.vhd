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
-- File       : ios_dma.vhd
-- Author     : Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: DMA controller.
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2005-11-28		1.4 			CB			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.gp_pkg.all;

entity ios_dma is
  port (
    -- Clock and reset signals
    rst_en      : in  std_logic;  -- Reset (active low)  
    clk_p       : in std_logic;
    clk_c_en    : in  std_logic;  -- Oscillator clock
    clk_c2_pos  : in  std_logic;  -- clk_c / 2 
    clk_e_pos   : in  std_logic;  -- Execution clock        
    clk_e_neg   : in  std_logic;  -- Execution clock        
    gate_e      : in  std_logic;  -- Copy of execution clock used for gating 
    clk_i_pos       : in  std_logic;  -- I/O clock           
    -- Static control inputs
    use_direct  : in  std_logic;  -- Set when the direct bus is used
    dbl_direct  : in  std_logic;  -- Set if direct traffic is double-speed
    i_double    : in  std_logic;  -- Set when IOMEM pointer should double step
    -- Control signals
    held_e      : in  std_logic;  -- High when clk_e is stopped (high)
    pend_i      : in  std_logic;  -- High when clk_i rising edge pending
    pend_pio    : in  std_logic;  -- High when programmable I/O pending
    pend_dma    : out std_logic;  -- High when DMA I/O pending
    input_dma   : out std_logic;  -- High when input DMA I/O in progress
    block_out   : in  std_logic;  -- Block output I/O operations in the next cycle
    blocked_pio : in  std_logic;  -- High when a programmed operation was blocked
    dis_io      : out std_logic;  -- High output disables ildout and inext
    -- Data paths
    dbus        : in  std_logic_vector(7 downto 0); -- D bus
    direct      : in  std_logic_vector(7 downto 0); -- Direct data bus
    i_direct    : out std_logic_vector(7 downto 0); -- Source for direct bus mux in MMR
    -- I/O bus
    ilioa       : in  std_logic;  -- Load I/O address, active low 
    ildout      : in  std_logic;  -- Load output, active low
    inext       : in  std_logic;  -- Next input, active low
    ldout_e     : in  std_logic;  -- Load output in the clk_e domain
    next_e      : in  std_logic;  -- Next input in the clk_e domain
    idack       : out std_logic_vector(DMA_CHANNELS-1 downto 0);  -- DMA acknowledge
    idreq       : in  std_logic_vector(DMA_CHANNELS-1 downto 0);  -- DMA request
    idi         : in  std_logic_vector(7 downto 0); -- I/O data bus input from pins
    ido_core    : in  std_logic_vector(7 downto 0); -- I/O data bus input from core
    ido_mem     : out std_logic_vector(7 downto 0); -- I/O data bus output from IOMEM
    iden_mem    : out std_logic;  -- I/O data bus enable from IOMEM
    ido_dma     : out std_logic_vector(7 downto 0); -- I/O data bus output from DMA ctrl
    iden_dma    : out std_logic;  -- I/O data bus enable from DMA ctrl
    -- IOMEM signals
    iomem_ce_n  : out std_logic_vector(1 downto 0);   -- Chip enable (active low)
    iomem_we_n  : out std_logic;  -- Write enable (active low)
    iomem_a     : out std_logic_vector(IOMEM_ADDR_WIDTH-2 downto 0);  -- Address
    iomem_d     : out std_logic_vector(15 downto 0);  -- Data in
    iomem_q     : in  std_logic_vector(15 downto 0)); -- Data out
end ios_dma;

architecture rtl of ios_dma is
  -- Command decode
  signal rst_mode   : std_logic;
  signal base_sel   : std_logic;
  signal mode_sel   : std_logic;
  signal dmap_sel   : std_logic;
  signal piop_sel   : std_logic;
  signal buf_sel    : std_logic;
  signal any_sel    : std_logic;
  signal byte_cnt   : std_logic_vector(1 downto 0);
  signal ch_sel     : std_logic_vector(DMA_CHBITS-1 downto 0);
  signal dis_io_int : std_logic;
  -- Base address registers
  type   base_type is array(DMA_CHANNELS-1 downto 0) of std_logic_vector(IOMEM_ADDR_WIDTH-5 downto 0);
  signal ber        : base_type;  -- Buffer end address
  signal bsr        : base_type;  -- Buffer start address
  signal base_out   : std_logic_vector(7 downto 0);   -- To ido_dma mux
  -- Channel mode registers
  signal priority   : std_logic_vector(DMA_CHANNELS-1 downto 0);  -- Low priority
  signal active     : std_logic_vector(DMA_CHANNELS-1 downto 0);  -- Channel active
  signal dir        : std_logic_vector(DMA_CHANNELS-1 downto 0);  -- Direction (out if high)
  signal suse       : std_logic_vector(DMA_CHANNELS-1 downto 0);  -- Use stop
  signal dmap_stop  : std_logic_vector(DMA_CHANNELS-1 downto 0);  -- Stop encountered
  signal mode_out   : std_logic_vector(7 downto 0);   -- To ido_dma mux
  -- DMA pointers
  signal input_pio  : std_logic;  -- High when input programmable I/O in progress
  signal piop_cnt   : std_logic_vector(DMA_CHANNELS-1 downto 0);  -- Step piop pointer
  signal dmap_cnt   : std_logic_vector(DMA_CHANNELS-1 downto 0);  -- Step dmap pointer
  signal pio_rd     : std_logic;  -- Processor side read signal
  signal pio_wr     : std_logic;  -- Processor side write signal
  signal pio_ce     : std_logic;  -- Processor side chip enable to IOMEM
  signal pio_we     : std_logic;  -- Processor side write enable to IOMEM
  signal dma_ce     : std_logic;  -- I/O side chip enable to IOMEM
  signal dma_we     : std_logic;  -- I/O side write enable to IOMEM
  type   ptr_type is array(DMA_CHANNELS-1 downto 0) of std_logic_vector(10 downto 0);
  signal piop       : ptr_type;   -- Processor side pointer
  signal dmap       : ptr_type;   -- I/O side pointer
  signal maddr      : std_logic_vector(IOMEM_ADDR_WIDTH-1 downto 0);  -- Logical IOMEM address
  signal xmaddr      : std_logic_vector(IOMEM_ADDR_WIDTH-1 downto 0);  -- Logical IOMEM address
  signal save_dmap  : std_logic_vector(7 downto 0);   -- Saves low part of dmap when read
  signal dmap_out   : std_logic_vector(7 downto 0);   -- To ido_dma mux
  -- Data path
  signal even_in    : std_logic_vector(7 downto 0);   -- Even input register for IOMEM
  signal odd_in     : std_logic_vector(7 downto 0);   -- Odd input register for IOMEM
  signal even_out   : std_logic_vector(7 downto 0);   -- Even output register for IOMEM
  signal odd_out    : std_logic_vector(7 downto 0);   -- Odd output register for IOMEM
  signal ido_le     : std_logic;  -- Latch enable for the ido_mem bus latch
  signal ido_sel    : std_logic;  -- IOMEM half select for the ido_mem bus
  signal out_sel    : std_logic;  -- Output register half select
  signal i_dir_sel  : std_logic;  -- i_direct bus half select
  attribute syn_keep              : boolean;
  attribute syn_keep of dma_ce    : signal is true;
  attribute syn_keep of dmap_out  : signal is true;
  
begin   
  ------------------------------------------------------------------------------
  -- DMA controller command decoding
  ------------------------------------------------------------------------------
  cmd_decoding: process (clk_p)
  begin 
    if rising_edge(clk_p) then--rising_edge(clk_i)
        if rst_en = '0' then  
            rst_mode  <= '1';
            base_sel  <= '0';
            mode_sel  <= '0';
            dmap_sel  <= '0';
            piop_sel  <= '0';
            buf_sel   <= '0';
        elsif clk_i_pos = '0' then  
            rst_mode <= '0';
            if ilioa = '0' then
              base_sel  <= '0';
              mode_sel  <= '0';
              dmap_sel  <= '0';
              piop_sel  <= '0';
              buf_sel   <= '0';
              case ido_core is  
                when RESET_DMA    => rst_mode <= '1';
                when SET_DMA_BASE => base_sel <= '1';
                when SET_DMA_MODE => mode_sel <= '1';
                when GET_DMA_DMAP => dmap_sel <= '1';
                when GET_DMA_PIOP => piop_sel <= '1';
                when RD_WR_BUF    => buf_sel  <= '1';
                when others => null;
              end case;
            end if;
        end if;
    end if;
  end process cmd_decoding;

  any_sel <= base_sel or mode_sel or dmap_sel or piop_sel or buf_sel;

  iden_dma <= '1' when any_sel = '1' and inext = '0' else '0';

  ido_dma <= mode_out when mode_sel = '1' else
             dmap_out when dmap_sel = '1' or piop_sel = '1' else
             base_out;
             
  -- DMA command parameter byte counting      
  byte_cnt_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then --rising_edge(clk_i)  
        if rst_en = '0' then 
            byte_cnt <= (others => '0');
        elsif clk_i_pos = '0' then
            if ilioa = '0' then
              byte_cnt <= (others => '0');
            elsif any_sel = '1' and (ildout = '0' or inext = '0') and byte_cnt /= "11" then
              byte_cnt <= byte_cnt + 1;
            end if;
        end if;
    end if;
  end process byte_cnt_gen;
      
  -- DMA command channel selection      
  ch_sel_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then--rising_edge(clk_i)
        if rst_en = '0' then
            ch_sel <= (others => '0');
        elsif clk_i_pos = '0' then
            if any_sel = '1' and ildout = '0' and byte_cnt = 0 then
              ch_sel <= ido_core(DMA_CHBITS-1 downto 0);
            end if;
        end if;
    end if;
  end process ch_sel_gen; 

  ------------------------------------------------------------------------------
  -- DMA base address and priority registers
  ------------------------------------------------------------------------------
  -- Buffer end registers and priority.
  ber_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then--rising_edge(clk_i)
        if rst_en = '0' then
            priority <= (others => '0');
            ber <= (others => (others => '0'));
        elsif clk_i_pos = '0' then
            if base_sel = '1' and ildout = '0' and byte_cnt = 1 then
              priority(conv_integer(ch_sel)) <= ido_core(7);
              ber(conv_integer(ch_sel)) <= ido_core(IOMEM_ADDR_WIDTH-5 downto 0);
            end if;
        end if;
    end if;
  end process ber_gen;
  base_out <= priority(conv_integer(ch_sel)) & ber(conv_integer(ch_sel));

  -- Buffer start assignments, each buffer starts just after the previous
  -- except for the first, which starts at address zero.
  bsr_gen: process (ber)
  begin  
    bsr(0) <= (others => '0');
    for i in 1 to DMA_CHANNELS-1 loop
      bsr(i) <= ber(i-1);
    end loop;
  end process bsr_gen;

  ------------------------------------------------------------------------------
  -- DMA mode registers
  ------------------------------------------------------------------------------
  mode_regs: process (clk_p, rst_mode)
  begin
    if rst_mode = '1' then  
      active <= (others => '0');
      dir <= (others => '0');
      suse <= (others => '0');
    elsif rising_edge(clk_p) then--rising_edge(clk_i)
        if clk_i_pos = '0' then
            if mode_sel = '1' and ildout = '0' and byte_cnt = 1 then
              active(conv_integer(ch_sel)) <= ido_core(7);
              dir(conv_integer(ch_sel))    <= ido_core(6);
              suse(conv_integer(ch_sel))   <= ido_core(5);
            end if;
        end if;
    end if;
  end process mode_regs;
  mode_out <= active(conv_integer(ch_sel)) &
              dir(conv_integer(ch_sel)) &
              suse(conv_integer(ch_sel)) &
              "00000";

  ------------------------------------------------------------------------------
  -- DMA pointers
  ------------------------------------------------------------------------------
  -- Disengage the processors ldout_e and next_e commands from the i/O bus
  -- when it reads or writes in IOMEM. This to allow full-speed operation even
  -- when the I/O bus speed is lowered, and to allow DMA cycles to use the bus
  -- simultaneously. 
  dis_io_int <= '1' when buf_sel = '1' and byte_cnt /= 0 else '0';
  dis_io <= dis_io_int;

  -- Generate read and write signals for processor side. Write signal is delayed
  -- by one clk_e to compensate for the input registers in the data path.
  pio_wr_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then----rising_edge(clk_e)
        if rst_en = '0' then
            pio_wr <= '0';
        elsif clk_e_pos = '0' then 
            pio_wr <= dis_io_int and ldout_e;
        end if;
    end if;
  end process pio_wr_gen;
  pio_rd <= dis_io_int and next_e;
       
  -- Generate control signals for the processor side accesses in IOMEM.
  -- A channels piop_cnt line is high during the clk_e cycle when the processor
  -- accesses it. The processor uses the first clk_c cycle of a clk_e cycle to
  -- access the IOMEM, so pio_ce and pio_we are only active during the first
  -- half of an active (not held) clk_e cycle. pio_ce is active (high) on both
  -- read and write accesses, pio_we only on write accesses. 
  pio_acc: process (ch_sel, pio_wr, pio_rd, gate_e, held_e)
  begin
    piop_cnt <= (others => '0');
    pio_ce <= '0';
    pio_we <= '0';
    if pio_wr = '1' or pio_rd = '1' then
      if held_e = '0' then
        piop_cnt(conv_integer(ch_sel)) <= '1';
        if gate_e = '1' then
          pio_ce <= '1';
          if pio_wr = '1' then
            pio_we <= '1';
          end if;
        end if;
      end if;
    end if;
  end process pio_acc;

  -- Generate control signals for the I/O side accesses in IOMEM.
  -- A channels dmap_cnt line (from dackgen) is high during the clk_i cycle
  -- when an I/O unit accesses it. The I/O side uses the last clk_c cycle of
  -- a clk_i cycle to access the IOMEM, so dma_ce and dma_we are only active
  -- when pend_i is active. dma_ce is active (high) on both read and write
  -- accesses, dma_we only on write accesses. 
  dma_acc: process (dmap_cnt, dir, pend_i)
  begin
    dma_ce <= '0';
    dma_we <= '0';
    for i in 0 to DMA_CHANNELS-1 loop
      if dmap_cnt(i) = '1' and pend_i = '1' then
        dma_ce <= '1';
        if dir(i) = '0' then
          dma_we <= '1';
        end if;
      end if;
    end loop;
  end process dma_acc;

  -- Instantiate one DMA pointer (containing pointers for both processor
  -- and I/O sides) for each DMA channel.
  dmap_gen: for i in 0 to DMA_CHANNELS-1 generate
    ios_dmap: entity work.ios_dmap
      port map (  
        clk_p    => clk_p,
        clk_c2_pos=> clk_c2_pos,
        clk_e_pos     => clk_e_pos,
        clk_i_pos     => clk_i_pos,
        rst_en   => rst_en,
        active    => active(i),
        dir       => dir(i),
        suse      => suse(i),
        bsr       => bsr(i),
        ber       => ber(i),
        pend_i    => pend_i,
        dmap_cnt  => dmap_cnt(i),
        piop_cnt  => piop_cnt(i),
        i_double  => i_double,
        dmap_stop => dmap_stop(i),
        dmap      => dmap(i),
        piop      => piop(i));
  end generate dmap_gen;

  -- Generate logical memory address for IOMEM. Default source is the piop
  -- pointer of the last selected channel, used when the processor is accessing
  -- the buffer in IOMEM or reading the contents of piop. When the processor is
  -- reading the contents of a selected dmap pointer or when a DMA access is
  -- made on a channel, the corresponding dmap is output. 

  maddr_gen: process (dma_ce, piop, dmap, dmap_cnt, ch_sel)
  begin
                maddr <= piop(conv_integer(ch_sel));
    if dma_ce = '1' then
      for i in 0 to DMA_CHANNELS-1 loop
        if dmap_cnt(i) = '1' then
          maddr <= dmap(i);
        end if;
      end loop;
    end if;
  end process maddr_gen;

  xmaddr_gen: process (dmap_sel, piop, dmap, ch_sel)
  begin
    if dmap_sel = '1' then
      xmaddr <= dmap(conv_integer(ch_sel));
    else
      xmaddr <= piop(conv_integer(ch_sel));
    end if;
  end process xmaddr_gen;

  -- Output dmap or piop for the processor to read. If the selected channel has
  -- stopped, bit 7 of the high byte will be set. The low part is saved at the
  -- instant when the high part is read, prohibiting wrap in the low part without
  -- increment of the high part.
  save_dmap_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then--rising_edge(clk_i)
        if  rst_en = '0' then
            save_dmap <= (others => '0');
        elsif clk_i_pos = '0' then
            if dmap_sel = '1' and byte_cnt = 1 and inext = '0' then
              save_dmap <= xmaddr(7 downto 0);
            end if;
        end if;
    end if;
  end process save_dmap_gen;
  dmap_out <= dmap_stop(conv_integer(ch_sel)) & "0000" &
              xmaddr(IOMEM_ADDR_WIDTH-1 downto 8) when byte_cnt = 1
              else save_dmap;   

  ------------------------------------------------------------------------------
  -- DMA acknowledge generation
  ------------------------------------------------------------------------------
  ios_dackgen: entity work.ios_dackgen
    port map (
        clk_p  => clk_p,
      clk_i_pos       => clk_i_pos,
      rst_en      => rst_en,
      idreq       => idreq,
      active      => active,
      dir         => dir,
      dmap_stop   => dmap_stop,
      priority    => priority,
      pend_pio    => pend_pio,
      pend_dma    => pend_dma,
      input_dma   => input_dma,
      block_out   => block_out,
      blocked_pio => blocked_pio,
      dmap_cnt    => dmap_cnt,
      idack       => idack);
  input_pio <= not inext;
    
  ------------------------------------------------------------------------------
  -- IOMEM interface
  ------------------------------------------------------------------------------
  -- Chip enable to even or odd half of memory whenever processor or I/O
  -- accesses, selected by the low bit of the logical address. Enable both
  -- halves on processor double-byte accesses.
  iomem_ce_n(0) <= '0' when (pio_ce = '1' or dma_ce = '1') and maddr(0) = '0'
                   else '0' when pio_ce = '1' and dbl_direct = '1'
                   else '1';      
  iomem_ce_n(1) <= '0' when (pio_ce = '1' or dma_ce = '1') and maddr(0) = '1'
                   else '0' when pio_ce = '1' and dbl_direct = '1'
                   else '1';

  -- Write enable is true on write accesses from either side.
  iomem_we_n <= '0' when (dma_we = '1' or pio_we = '1') else '1';

  -- Physical address to both halves is high ten bits of logical address.
  iomem_a <= maddr(IOMEM_ADDR_WIDTH-1 downto 1);

  ------------------------------------------------------------------------------
  -- Data path
  ------------------------------------------------------------------------------
  -- Input register for the even direct bus byte, loaded on falling clk_e
  -- edge only when double byte transfers on the direct bus are used. 
  load_even_in: process (clk_p)
  begin
    if rising_edge(clk_p) then    --falling_edge(clk_e)
        if  rst_en = '0' then
            even_in <= (others => '0');
        elsif clk_e_neg = '0' then
            if dis_io_int = '1' and ldout_e = '1' and dbl_direct = '1' then
                even_in <= direct;
            end if;
        end if;
    end if;
  end process load_even_in;

  -- Input register for the odd direct bus byte or for data from D bus,
  -- loaded on rising clk_e edge. 
  load_odd_in: process (clk_p)
  begin
    if rising_edge(clk_p) then  --rising_edge(clk_e)
        if  rst_en = '0' then
            odd_in <= (others => '0');
        elsif clk_e_pos = '0' then
            if dis_io_int = '1' and ldout_e = '1' then
              if use_direct = '1' then
                odd_in <= direct;
              else
                odd_in <= dbus;
              end if;
            end if;
        end if;
    end if;
  end process load_odd_in;
      
  -- Data in to the even IOMEM half, taken from the id bus when the DMA
  -- side is writing to memory, otherwise from the even input register
  -- when double byte transfers on the direct bus are used, else from
  -- the odd input register.
  iomem_d(7 downto 0) <= idi when dma_we = '1' else
                         even_in when dbl_direct = '1' else
                         odd_in;
      
  -- Data in to the odd IOMEM half, taken from the id bus when the DMA
  -- side is writing to memory, otherwise from the odd input register.
  iomem_d(15 downto 8) <= idi when dma_we = '1' else
                          odd_in;

  -- On I/O side read accesses, save low bit of logical address to determine
  -- from which half data shall be taken in the next cycle. Also enable the
  -- I/O bus in the next cycle.
  ido_sel_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then--rising_edge(clk_i)
        if rst_en = '0' then
            iden_mem <= '0';
        elsif clk_i_pos = '0' then
            iden_mem <= '0';
            if dma_ce = '1' and dma_we = '0' then
              ido_sel <= maddr(0);
              iden_mem <= '1';
            end if;         
        end if;
    end if;
  end process ido_sel_gen;
     
  -- On I/O side read accesses, generate a latch enable signal to latch the
  -- data from IOMEM during the whole clk_i cycle.
  ido_le_gen: process (clk_p)
  begin
    if rising_edge(clk_p) then
        if  rst_en = '0' then
            ido_le <= '0';
        elsif clk_c_en = '1' then
            ido_le <= dma_ce and (not dma_we);
        end if;
    end if;
  end process ido_le_gen;
  
  -- Read IOMEM data from the selected half is latched here while being
  -- presented on the I/O bus.
  ido_mem_latch: process (iomem_q, ido_sel, ido_le)
    variable id_mux : std_logic_vector(7 downto 0);
  begin
    if ido_le = '1' then
      if ido_sel = '1' then
        ido_mem <= iomem_q(15 downto 8);
      else
        ido_mem <= iomem_q(7 downto 0);
      end if;
    end if;
  end process ido_mem_latch;

  -- On processor side read accesses, save low bit of logical address (or
  -- rather the current piop pointer, since the logical address has changed
  -- to dmap at clk_e rising edge) to determine from which half data shall be
  -- taken in the next cycle.
  -- Read IOMEM data from both halves is delayed here for one clk_e cycle
  -- before being presented on the i_direct bus.
  out_regs: process (clk_p)
  begin
    if rising_edge(clk_p) then --rising_edge(clk_e)
        if rst_en = '0' then
            out_sel <= '0';
            even_out <= (others => '0');
            odd_out <= (others => '0');
        elsif next_e = '1' and clk_e_pos = '0' then            
            out_sel   <= piop(conv_integer(ch_sel))(0);
            even_out  <= iomem_q(7 downto 0);
            odd_out   <= iomem_q(15 downto 8);
      end if;
    end if;
  end process out_regs;
      
  -- i_direct bus outputs even data during the first half of the clk_e cycle
  -- and odd during the second when double-byte transfers are used, otherwise
  -- it outputs the half that was accessed.
  i_dir_sel <= not gate_e when dbl_direct = '1' else out_sel;
  i_direct <= even_out when i_dir_sel = '0' else odd_out;
end rtl;
