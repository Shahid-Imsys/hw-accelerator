library ieee;
use ieee.std_logic_1164.all;
use work.all;
use work.digital_top_sim_pack.all;
use work.tb_components_pkg.all;

use work.gp_pkg.all;

entity main_tb is
end main_tb;

architecture tb of main_tb is

  type port_name_t is (A, B, C, D, E, F, G, H, I, J);

  type ports_t is array (A to J) of std_logic_vector(7 downto 0);

  signal pad              : ports_t;
  signal port_to_im4000   : ports_t;
  signal port_from_im4000 : ports_t;
  signal port_oe          : ports_t;


  constant HALF_CLK_C_CYCLE : time := 16000 ps;

  signal MX1_CK  : std_logic;
  signal MXOUT   : std_logic;
  signal MEXEC   : std_logic;
  signal MCKOUT0 : std_logic;
  signal MCKOUT1 : std_logic;
  signal MSDIN   : std_logic;
  signal MSDOUT  : std_logic;
  signal MIRQOUT : std_logic;
  signal MRESET  : std_logic;
  signal MRSTOUT : std_logic;
  signal MTEST   : std_logic                    := '0';
  signal MIRQ0   : std_logic;
  signal MIRQ1   : std_logic;
  signal D_DQ    : std_logic_vector(7 downto 0) := (others => 'Z');

  signal pa_i  : std_logic_vector(7 downto 0);
  signal PB    : std_logic_vector(7 downto 0);
  signal PC    : std_logic_vector(7 downto 0);
  signal PD    : std_logic_vector(7 downto 0);
  signal PE    : std_logic_vector(7 downto 0);
  signal PF    : std_logic_vector(7 downto 0);
  signal PG    : std_logic_vector(7 downto 0);
  signal PH    : std_logic_vector(7 downto 0);
  signal PI    : std_logic_vector(7 downto 0);
  signal pi_i  : std_logic_vector(7 downto 0);
  signal pi_o  : std_logic_vector(7 downto 0);
  signal pi_en : std_logic_vector(7 downto 0);
  signal PJ    : std_logic_vector(7 downto 0);
  signal pj_i  : std_logic_vector(7 downto 0);
  signal pj_o  : std_logic_vector(7 downto 0);
  signal pj_en : std_logic_vector(7 downto 0);

  signal MBYPASS    : std_logic;
  signal MWAKE      : std_logic;
  signal MLP_PWR_OK : std_logic := '0';
  signal XTAL1      : std_logic;

  signal reg_to_block : reg_to_block_t;

  signal xtal1_int  : std_logic := '0';
  signal mx1_ck_int : std_logic := '0';

  signal OSPI_DQ_i   : std_logic_vector(7 downto 0);
  signal OSPI_DQ_o   : std_logic_vector(7 downto 0);
  signal OSPI_DQ_e   : std_logic;
  signal OSPI_RWDS_i : std_logic;
  signal OSPI_RWDS_o : std_logic;
  signal OSPI_RWDS_e : std_logic;

  signal OSPI_Out  : OSPI_InterfaceOut_t;
  signal OSPI_DQ   : std_logic_vector(7 downto 0);
  signal OSPI_RWDS : std_logic;

begin  -- architecture tb


  top0 : entity work.top
    generic map (
      g_memory_type     => fpga,
      g_clock_frequency => 31
      )
    port map (
      clk_p   => MX1_CK,
      clk_rx  => '0', -- TODO
      clk_tx  => '0', -- TODO
      MRESET  => MRESET,
      rst_n   => MRESET,
      MRSTOUT => MRSTOUT,
      MIRQOUT => MIRQOUT,
      MCKOUT0 => MCKOUT0,
      MCKOUT1 => MCKOUT1,
      MTEST   => MTEST,
      MIRQ0   => MIRQ0,
      MIRQ1   => MIRQ1,
      -- SW debug
      MSDIN   => MSDIN,
      MSDOUT  => MSDOUT,

      ext_i_pos  => open,
      ext_ido    => (others => '0'),
      ext_iden   => '0',
      ext_idreq  => '1',
      ext_idack  => open,
      ext_ilioa  => open,
      ext_ildout => open,
      ext_inext  => open,
      ext_idi    => open,

      -- Port A
      pa_i  => port_to_im4000(A),
      pa_en => port_oe(A),
      pa_o  => port_from_im4000(A),
      -- Port B
      pb_i  => port_to_im4000(B),
      pb_en => port_oe(B),
      pb_o  => port_from_im4000(B),
      -- Port C
      pc_i  => port_to_im4000(C),
      pc_en => port_oe(C),
      pc_o  => port_from_im4000(C),
      -- Port D
      pd_i  => port_to_im4000(D),
      pd_en => port_oe(D),
      pd_o  => port_from_im4000(D),
      -- Port Eopen,
      pe_i  => port_to_im4000(E),
      pe_en => port_oe(E),
      pe_o  => port_from_im4000(E),
      -- Port F
      pf_i  => port_to_im4000(F),
      pf_en => port_oe(F),
      pf_o  => port_from_im4000(F),
      -- Port G
      pg_i  => port_to_im4000(G),
      pg_en => port_oe(G),
      pg_o  => port_from_im4000(G),
      -- Port H
      ph_i  => port_to_im4000(H),
      ph_en => port_oe(H),
      ph_o  => port_from_im4000(H),
      -- Port I
      pi_i  => port_to_im4000(I),
      pi_en => port_oe(I),
      pi_o  => port_from_im4000(I),
      -- Port J
      pj_i  => port_to_im4000(J),
      pj_en => port_oe(J),
      pj_o  => port_from_im4000(J),
      -- I/O cell configuration control outputs
      -- d_hi  => open,
      -- d_sr  => open,
      d_lo  => open,
      p1_hi => open,
      p1_sr => open,
      p2_hi => open,
      p2_sr => open,
      p3_hi => open,
      p3_sr => open,

      MBYPASS    => MBYPASS,
      MWAKEUP_LP => MWAKE,
      MLP_PWR_OK => MLP_PWR_OK,

      OSPI_Out   => OSPI_Out,
      OSPI_DQ_i  => OSPI_DQ_i,
      OSPI_DQ_o  => OSPI_DQ_o,
      OSPI_DQ_e  => OSPI_DQ_e,
      OSPI_RWDS_i => OSPI_RWDS_i,
      OSPI_RWDS_o => OSPI_RWDS_o,
      OSPI_RWDS_e => OSPI_RWDS_e,

      dis_bmem   => open,
      ach_sel0   => open,
      ach_sel1   => open,
      ach_sel2   => open,
      adc_ref2v  => open,
      adc_extref => open,
      adc_diff   => open,
      adc_en     => open,
      dac0_bits  => open,
      dac1_bits  => open,
      dac0_en    => open,
      dac1_en    => open,
      clk_a      => open,

      pwr_ok   => '1',
      vdd_bmem => '0',
      VCC18LP  => '1',
      rxout    => XTAL1,
      adc_bits => '0'
      );

  pad(A)(7 downto 5) <= "000";          -- This is read by ROM bootloader
  pad(A)(4 downto 3) <= "01";           -- Set SP communication at /2 speed
  pad(A)(2 downto 1) <= "01";           -- Set PLL multiplier to 4
  pad(A)(0)          <= '1';            -- Set PLL divider to 1

  OSPI_RWDS   <= OSPI_RWDS_o when OSPI_RWDS_e = '1' else 'Z';
  OSPI_RWDS_i <= OSPI_RWDS;

  OSPI_DQ   <= OSPI_DQ_o when OSPI_DQ_e = '1' else (others => 'Z');
  OSPI_DQ_i <= OSPI_DQ;

  g_ports_pad : for p in port_name_t generate
    g_pad : for i in 7 downto 0 generate
      i_pi : entity work.ZMA2GSD
        port map (
          o  => port_to_im4000(p)(i),
          i  => port_from_im4000(p)(i),
          IO => pad(p)(i),
          E  => port_oe(p)(i));
    end generate g_pad;
  end generate g_ports_pad;



  -- Reset the circuit for 10 ns;
  MRESET <= '0', '1' after 10 ns;

  -- This emulates a 31.25 MHz crystal
  mx1_ck_int <= not mx1_ck_int after HALF_CLK_C_CYCLE;
  MX1_CK     <= mx1_ck_int;

  -- This emulates a 32768 Hz crystal connected to RXOSC
  --xtal1_int <= not xtal1_int after 15259 ns;
  xtal1_int <= not xtal1_int after 1 us;
  XTAL1     <= xtal1_int;

  -- Bypass disabled
  MBYPASS <= '0';

  -- Wake-up signal inactive
  MWAKE <= '0';

  MIRQ0 <= '1';
  MIRQ1 <= '1';

  -- Connect MLP_PWR_OK to reset for simlicity.
  MLP_PWR_OK <= MRESET;

  i_debug_interface_bfm : entity work.debug_interface_bfm
    port map (

      MSDIN   => MSDIN,
      MSDOUT  => MSDOUT,
      MIRQOUT => MIRQOUT,
      MCKOUT0 => MCKOUT0,
      mrstout => MRSTOUT,

      reg_to_block   => reg_to_block,
      reg_from_block => open
      );

  i_uart : entity work.uart_tb
    port map (
      tx             => pad(J)(1),
      rx             => pad(J)(0),
      reg_to_block   => reg_to_block,
      reg_from_block => x"00"
      );

  i_octo_spi : entity work.octo_memory_bfm
    port map (
      ck      => OSPI_Out.CK_p,
      cs      => OSPI_Out.CS_n,
      rwds    => OSPI_RWDS,
      dq      => OSPI_DQ,
      reset_n => MRESET
      );

end architecture tb;
