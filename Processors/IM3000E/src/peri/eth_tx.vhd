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
-- Title      : Ethernet transmitter
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : eth_tx.vhd
-- Author     : Christian Blixt
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: 
--              
-------------------------------------------------------------------------------
-- TO-DO list :
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date                                 Version         Author  Description
-- 2005-12-15           1.0                             CB                      Created
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.gp_pkg.all;

entity eth_tx is
  generic (
    g_build_type : memory_type_t                := asic;
    TX_CTL_ADR   : std_logic_vector(7 downto 0) := x"23";  --acts as CTL/STS
    TX_SIZE      : natural                      := 3);  -- 2-log of TX fifo size in nibbles             
  port (
    -- Processor interface  
    clk_p     : in  std_logic;
    clk_i_pos : in  std_logic;
    ilioa     : in  std_logic;
    ildout    : in  std_logic;
    inext     : in  std_logic;
    idack     : in  std_logic;
    idreq     : out std_logic;
    idi       : in  std_logic_vector(7 downto 0);
    ido       : out std_logic_vector(7 downto 0);
    iden      : out std_logic;
    irq       : out std_logic;
    -- PHY Interface
    clk_tx    : in  std_logic;
    clken     : in  std_logic;
    txen      : out std_logic;
    txer      : out std_logic;
    col       : in  std_logic;
    crs       : in  std_logic;
    txd       : out std_logic_vector(3 downto 0);
    -- Control register outputs
    fast      : out std_logic;
    phy_sel   : out std_logic;
    tstamp    : out std_logic;
    -- System reset
    rst_en    : in  std_logic);         -- Active low
end entity eth_tx;

architecture structure of eth_tx is

  component eth_tx_fifo
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(1 downto 0);
      dina  : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(7 downto 0);
      clkb  : in  std_logic;
      web   : in  std_logic_vector(0 downto 0);
      addrb : in  std_logic_vector(2 downto 0);
      dinb  : in  std_logic_vector(3 downto 0);
      doutb : out std_logic_vector(3 downto 0)
      );
  end component;

-- Address decode & ido mux                                                 --
  signal tx_reg_sel : std_logic;
  signal tx_reg_wr  : std_logic;
  signal tx_reg_rd  : std_logic;

-- Control/status registers                                                 --
  signal tx_reg    : std_logic_vector(7 downto 0);
  signal syn_reset : std_logic;
  signal set_go    : std_logic;
  signal full_dpx  : std_logic;
  signal go_i      : std_logic;
  signal go_tx     : std_logic;
  signal go_tx2    : std_logic;
  signal rst_tx    : std_logic;
  signal rst_tx2   : std_logic;
  signal collision : std_logic;

-- TX control.
  type tx_states is (IDLE, PREAMBLE, DATA, CRC, JAM, IFG1, IFG2);
  signal tx_state   : tx_states;
  signal valid_col  : std_logic;        -- Half-duplex collision
  signal valid_crs  : std_logic;        -- Half-duplex carrier sense
  signal gctr       : std_logic_vector(3 downto 0);
  signal tx_done    : std_logic;  -- Transmission done pulse, clk_tx domain
  signal preamble_5 : std_logic;
  signal preamble_8 : std_logic;
  signal tx_read    : std_logic;
  signal crc_gen    : std_logic;

-- TX fifo.
  type tx_fifo_type is array(2**TX_SIZE - 1 downto 0) of std_logic_vector(3 downto 0);
  signal tx_fifo     : tx_fifo_type;
  signal fifo_reset  : std_logic;
  signal tx_dout     : std_logic_vector(3 downto 0);
  signal tx_wctr     : std_logic_vector(TX_SIZE-2 downto 0);  -- Counts bytes
  signal tx_rctr     : std_logic_vector(TX_SIZE-1 downto 0);  -- Counts nibbles
  signal tx_count_i  : integer range 0 to 2**TX_SIZE - 1;     -- Counts bytes
  signal tx_rctr1_i  : std_logic;
  signal tx_rctr1_i2 : std_logic;
  signal tx_length   : std_logic_vector(11 downto 0);         -- Counts nibbles
  signal tx_full     : std_logic;
  signal tx_afull    : std_logic;
  signal tx_aempty   : std_logic;

-- TX CRC.
  signal crc_in  : std_logic_vector(3 downto 0);
  signal crc_out : std_logic_vector(31 downto 0);

-- FPGA specific 
  signal wea : std_logic_vector(0 downto 0);


begin
----------------------------------------------------------------
-- Address decode & ido mux.
----------------------------------------------------------------
  -- This process decodes I/O addresses
  process (clk_p)
  begin
    if rising_edge(clk_p) then          -- rising_edge(clk_i)
      if rst_en = '0' then
        tx_reg_sel <= '0';
      elsif ilioa = '0' and clk_i_pos = '0' then
        tx_reg_sel <= '0';
        if idi = TX_CTL_ADR then
          tx_reg_sel <= '1';
        end if;
      end if;
    end if;
  end process;
  tx_reg_wr <= '1' when tx_reg_sel = '1' and ildout = '0' else '0';
  tx_reg_rd <= '1' when tx_reg_sel = '1' and inext = '0'  else '0';

  ido <= tx_reg;

  iden <= tx_reg_rd;

----------------------------------------------------------------
-- Control/status registers.
----------------------------------------------------------------
  -- TX control/status register.
  process (clk_p)
  begin
    if rising_edge(clk_p) then          --rising_edge(clk_i)
      if rst_en = '0' then
        set_go             <= '0';
        tx_reg(6 downto 3) <= "1000";
      elsif clk_i_pos = '0' then
        set_go <= '0';
        if tx_reg_wr = '1' then
          set_go             <= idi(7);  -- Writing '1' to bit 7 will cause a high pulse on set_go          
          tx_reg(6 downto 3) <= idi(6 downto 3);
        end if;
      end if;
    end if;
  end process;

  tx_reg(7) <= go_i;
  syn_reset <= tx_reg(6);
  fast      <= tx_reg(5);
  full_dpx  <= tx_reg(4);
  phy_sel   <= tx_reg(3);
  tx_reg(2) <= collision;
  tx_reg(1) <= '0';
  tx_reg(0) <= '0';

  -- Interrupt request, set when frame sent, reset
  -- when TX status register is read.
  process(clk_p)
  begin
    if rising_edge(clk_p) then          --rising_edge(clk_i)
      if rst_en = '0' then
        irq <= '0';
      elsif tx_done = '1' then
        irq <= '1';
      elsif tx_reg_rd = '1' and clk_i_pos = '0' then
        irq <= '0';
      end if;
    end if;
  end process;

  -- 'go_i' status bit, set when transmission is initiated, reset
  -- on syn_reset or when frame sent.
  process (clk_p)
  begin
    if rising_edge(clk_p) then          --rising_edge(clk_i)
      if rst_en = '0' or tx_done = '1' then
        go_i <= '0';
      elsif clk_i_pos = '0' then
        if syn_reset = '1' then
          go_i <= '0';
        elsif set_go = '1' then
          go_i <= '1';
        end if;
      end if;
    end if;
  end process;

  -- go_tx2 signal, essentially the 'go_i' status bit in the clk_tx domain.
  process (clk_tx, syn_reset)
  begin
    if syn_reset = '1' then
      go_tx2 <= '0';
      go_tx  <= '0';
    elsif rising_edge(clk_tx) then
      if clken = '1' then
        go_tx2 <= go_tx;
        go_tx  <= go_i;
      end if;
    end if;
  end process;

  -- rst_tx2 signal, active low asynchronous reset for the clk_tx domain.
  process (clk_tx, syn_reset)
  begin
    if syn_reset = '1' then
      rst_tx2 <= '0';
      rst_tx  <= '0';
    elsif rising_edge(clk_tx) then
      if clken = '1' then
        rst_tx2 <= rst_tx;
        rst_tx  <= '1';
      end if;
    end if;
  end process;

  -- 'collision' status bit, set on half-duplex collision,
  -- reset on syn_reset.
  process (clk_p)
  begin
    if rising_edge(clk_p) then          --rising_edge(clk_i)
      if rst_en = '0' then
        collision <= '0';
      elsif clk_i_pos = '0' then
        if syn_reset = '1' then
          collision <= '0';
        elsif valid_col = '1' then
          collision <= '1';
        end if;
      end if;
    end if;
  end process;

----------------------------------------------------------------
-- TX control.
----------------------------------------------------------------
  valid_col <= col and not full_dpx;
  valid_crs <= crs and not full_dpx;

  -- TX control state machine.
  process (clk_tx, rst_tx2)
  begin
    if rst_tx2 = '0' then
      tx_done  <= '0';
      gctr     <= x"0";
      tx_state <= IDLE;
      tstamp   <= '0';
    elsif rising_edge(clk_tx) then
      if clken = '1' then
        tx_done <= '0';
        tstamp  <= '0';
        case tx_state is
                                ----------------------------------------------------------
          when IDLE =>          -- Nothing to do, wait for something to happen
            gctr <= x"0";
            if valid_crs = '1' then
              tx_state <= IFG1;  -- Incoming frame in half duplex, can't transmit
            elsif go_tx2 = '1' then
              tx_state <= PREAMBLE;     -- GO bit set, start sending frame
            end if;
                                ----------------------------------------------------------
          when PREAMBLE =>              -- Transmit 16 nibbles of preamble
            gctr <= gctr + 1;
            if gctr = 15 then
              tstamp   <= '1';
              tx_state <= DATA;  -- 16 nibbles sent, start transmission of data
            end if;
                                ----------------------------------------------------------
          when DATA =>                  -- Transmit the data
            gctr <= x"0";
            if valid_col = '1' then
              tx_state <= JAM;  -- Collision in half duplex, go transmit jam sequence
            elsif tx_aempty = '1' then
              tx_state <= CRC;
            end if;
                                ----------------------------------------------------------
          when CRC =>                   -- Transmit the 4 bytes of CRC
            gctr <= gctr + 1;
            if valid_col = '1' then
              tx_state <= JAM;  -- Collision in half duplex, go transmit jam sequence
              gctr     <= x"0";
            elsif gctr = 7 then
              tx_state <= IFG1;
              tx_done  <= '1';
              gctr     <= x"0";
            end if;
                                ----------------------------------------------------------
          when JAM =>                   -- Transmit jam sequence
            gctr <= gctr + 1;
            if gctr = 7 then
              tx_state <= IFG1;
              tx_done  <= '1';
              gctr     <= x"0";
            end if;
                                ----------------------------------------------------------      
          when IFG1 =>                  -- Wait for incoming frame to pass
            gctr <= gctr + 1;
            if valid_crs = '0' and gctr = 15 then
              tx_state <= IFG2;
            end if;
                                ----------------------------------------------------------              
          when IFG2 =>                  -- Wait for interframe gap
            gctr <= gctr + 1;
            if gctr = 7 then
              tx_state <= IDLE;
            end if;
                                ----------------------------------------------------------              
          when others =>
            tx_state <= IDLE;
        end case;
      end if;
    end if;
  end process;
  preamble_5 <= '1' when tx_state = PREAMBLE               else '0';  -- 16 nibbles
  preamble_8 <= '1' when tx_state = PREAMBLE and gctr = 15 else '0';  -- last nibble
  tx_read    <= '1' when tx_state = DATA else
             '1' when tx_state = PREAMBLE and gctr >= 12 else '0';
  crc_gen <= '1' when tx_state = DATA else
             '1' when tx_state = CRC else '0';
  txen <= '1' when tx_state = PREAMBLE else
          '1' when tx_state = DATA else
          '1' when tx_state = CRC else
          '1' when tx_state = JAM else '0';
  txer <= '0';

  -- Output data, from fifo or from CRC generator.
  txd <= not crc_out(31 downto 28) when tx_state = CRC else
         tx_dout when tx_state = DATA else
         preamble_8 & preamble_5 & '0' & preamble_5;

---------------------------------------------------------------------
-- TX fifo.
---------------------------------------------------------------------
  fifo_reset <= not rst_tx2 or tx_done;

  gen_tx_fifo_fpga : if g_build_type = fpga generate
    process (clk_p)
    begin
      if rising_edge(clk_p) then        --rising_edge(clk_i)
        if rst_tx2 = '0' then
          tx_wctr <= (others => '0');
          wea     <= (others => '0');
        elsif idack = '0' and clk_i_pos = '0' then
          tx_wctr <= tx_wctr + 1;
          wea(0)  <= '1';
        else
          wea(0) <= '0';
        end if;
      end if;
    end process;

    tx_fifo_mem : eth_tx_fifo
      port map (
        clka  => clk_p,
        wea   => wea,
        addra => tx_wctr,
        dina  => idi,
        douta => open,
        clkb  => clk_tx,
        web   => "0",
        addrb => tx_rctr,
        dinb  => "----",
        doutb => tx_dout
        );
  end generate;

  gen_tx_fifo_other : if g_build_type /= fpga generate
    -- Write counter and fifo write.
    process (clk_p)
    begin
      if rising_edge(clk_p) then        --rising_edge(clk_i)
        if rst_tx2 = '0' then
          tx_wctr <= (others => '0');
        elsif idack = '0' and clk_i_pos = '0' then
          tx_fifo(conv_integer(tx_wctr & '0')) <= idi(3 downto 0);
          tx_fifo(conv_integer(tx_wctr & '1')) <= idi(7 downto 4);
          tx_wctr                              <= tx_wctr + 1;
        end if;
      end if;
    end process;
    tx_dout <= tx_fifo(conv_integer(tx_rctr));
  end generate;

  -- Read counter and fifo read.
  process (clk_tx, rst_tx2, fifo_reset)
  begin
    if fifo_reset = '1' then
      tx_rctr <= (others => '0');
    elsif rising_edge(clk_tx) then
      if clken = '1' then
        if tx_read = '1' then           -- Read one nibble
          tx_rctr <= tx_rctr + 1;
        end if;
      end if;
    end if;
  end process;



  -- Level counter and fifo flags, counts bytes, synchronized to clk_i.
  process (clk_p)
  begin
    if rising_edge(clk_p) then          --rising_edge(clk_i)
      if rst_tx2 = '0' then
        tx_count_i  <= 0;
        tx_rctr1_i  <= '0';
        tx_rctr1_i2 <= '0';
      elsif clk_i_pos = '0' then
        if ((tx_rctr1_i xor tx_rctr1_i2) xnor idack) = '1' then
          if idack = '1' then
            tx_count_i <= tx_count_i - 1;  -- Subtract from counter every 2:nd nibble read
          else
            tx_count_i <= tx_count_i + 1;  -- Add to counter on every time fifo written
          end if;
        end if;
        tx_rctr1_i  <= tx_rctr(1);  -- Synchronize bit 1 of tx_rctr to clk_i, because
        tx_rctr1_i2 <= tx_rctr1_i;      -- fifo is read twice for every byte
      end if;
    end if;
  end process;
  tx_full  <= '1' when tx_count_i >= 2**(TX_SIZE-1)    else '0';
  tx_afull <= '1' when tx_count_i = 2**(TX_SIZE-1) - 1 else '0';

  -- DMA request logic.
  idreq <= '1' when go_i = '0' or rst_tx2 = '0' else  -- No req when not enabled
           '1' when tx_full = '1'                  else  -- No req when fifo full
           '1' when tx_afull = '1' and idack = '0' else  -- No req when last byte already ack'ed
           '0';                         -- Otherwise, request

  -- Frame length counter, loaded during last four clocks of preamble.
  process (clk_tx, rst_tx2)
  begin
    if rst_tx2 = '0' then
      tx_length <= (others => '0');
    elsif rising_edge(clk_tx) then
      if clken = '1' then
        if tx_read = '1' then
          if crc_gen = '0' then
            if gctr = 12 then
              tx_length(11 downto 9) <= tx_dout(2 downto 0);
            elsif gctr = 14 then
              tx_length(4 downto 0) <= tx_dout & '0';
            elsif gctr = 15 then
              tx_length(8 downto 5) <= tx_dout;
            end if;
          else
            tx_length <= tx_length - 1;
          end if;
        end if;
      end if;
    end if;
  end process;
  tx_aempty <= '1' when tx_length = 1 else '0';

----------------------------------------------------------------
-- Instantiation of TX CRC.
----------------------------------------------------------------
  eth_crc1 : entity work.eth_crc
    port map (
      clk    => clk_tx,
      clken  => clken,
      rst    => fifo_reset,
      enable => crc_gen,
      data   => crc_in,
      crc    => crc_out);

  -- Feed back output in to input when CRC is shifted out.
  crc_in <= tx_dout when tx_read = '1' else
            crc_out(31 downto 28);

end architecture structure;

