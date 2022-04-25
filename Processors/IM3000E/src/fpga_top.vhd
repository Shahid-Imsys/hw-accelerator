----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2022 10:24:00 AM
-- Design Name: 
-- Module Name: fpga_top - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.gp_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fpga_top is
    port (
        MRESET  : in  std_logic;
        MIRQOUT : out std_logic;
        MCKOUT0 : out std_logic;
        MIRQ0   : in  std_logic;
        MSDIN   : in  std_logic;
        MSDOUT  : out std_logic;

        PA6_SCK  : inout std_logic;
        PA5_CS_N : inout std_logic;
        PA0_SIN  : inout std_logic;
        PA7_SOUT : inout std_logic;

        URX    : inout std_logic;
        UTX    : inout std_logic;
        OE_CTR : out   std_logic;

        ENET_RST_N : out std_logic;

        ENET_MDC  : out   std_logic;
        ENET_MDIO : inout std_logic;

        ENET_TXCLK : in  std_logic;
        ENET_TXCTL : out std_logic;
        ENET_TXD0  : out std_logic;
        ENET_TXD1  : out std_logic;
        ENET_TXD2  : out std_logic;
        ENET_TXD3  : out std_logic;

        ENET_RXCLK : in std_logic;
        ENET_RXCTL : in std_logic;
        ENET_RXD0  : in std_logic;
        ENET_RXD1  : in std_logic;
        ENET_RXD2  : in std_logic;
        ENET_RXD3  : in std_logic;

        -- OSPI interface
        OSPI_Out  : out   OSPI_InterfaceOut_t;
        OSPI_DQ   : inout std_logic_vector(7 downto 0);
        OSPI_RWDS : inout std_logic;

        TEST_OUTP : out std_logic_vector(15 downto 0);

        -- VCU118
        VCU118_Clk300M_p : in  std_logic;
        VCU118_Clk300M_n : in  std_logic;
        LED              : out std_logic_vector (7 downto 0)
    );
end fpga_top;

architecture rtl of fpga_top is

    component clk_wiz_0
        port(                                 -- Clock in ports
            clk_in1_p : in  std_logic;
            clk_in1_n : in  std_logic;
            -- Clock out ports
            clk_200M  : out std_logic;
            clk_100M  : out std_logic;
            clk_50M  : out std_logic
        );
    end component;

    component top is
        generic (
            g_memory_type : memory_type_t := referens;
            g_clock_frequency : integer         -- Frequency in MHz
        );
        port (
            -- clocks and control signals
            HCLK    : in  std_logic;            -- clk input   
            MRESET  : in  std_logic;  -- system reset               low active
            MRSTOUT : out std_logic;
            MIRQOUT : out std_logic;            -- interrupt request output    
            MCKOUT0 : out std_logic;            --for trace adapter
            MCKOUT1 : out std_logic;            --programable clock out
            mckout1_en : out std_logic;         -- Enable signal for MCKOUT1 pad.
            MTEST   : in  std_logic;  --                            high active                 
            MBYPASS : in  std_logic;
            MIRQ0   : in  std_logic;  --                            low active
            MIRQ1   : in  std_logic;  --                            low active
            -- SW debug                                                               
            MSDIN   : in  std_logic;            -- serial data in (debug)     
            MSDOUT  : out std_logic;            -- serial data out    

            MWAKEUP_LP : in    std_logic;       --                          high active
            MLP_PWR_OK : in    std_logic;
            -- power management control
            --pwr_switch_on : out std_logic_vector(3 downto 0);
            MPMIC_CORE : out   std_logic;
            MPMIC_IO   : out   std_logic;
            -- SDRAM interface (41bits)
            D_CLK      : out   std_logic;       --clock to SDRAM
            D_CS       : out   std_logic;       -- CS to SDRAM
            D_RAS      : out   std_logic;       -- RAS to SDRAM
            D_CAS      : out   std_logic;       -- CAS to SDRAM
            D_WE       : out   std_logic;       -- WE to SDRAM
            D_DQM      : out   std_logic_vector(7 downto 0);  --data mask
            D_DQ       : inout std_logic_vector(7 downto 0);  --data
            D_A        : out   std_logic_vector(13 downto 0);
            D_BA       : out   std_logic_vector(1 downto 0);
            D_CKE      : out   std_logic_vector(3 downto 0);

            -- Analog internal signals
            pwr_ok     : in  std_logic;  -- Power on detector output (active high)  
            dis_bmem   : out std_logic;         -- Disable for vdd_bmem (active high)  
            vdd_bmem   : in  std_logic;         -- Power for the BMEM block  
            VCC18LP    : in  std_logic;         -- Power for the RTC block  
            rxout      : in  std_logic;         -- RTC oscillator output  
            ach_sel0   : out std_logic;         -- ADC channel select, bit 0  
            ach_sel1   : out std_logic;         -- ADC channel select, bit 1  
            ach_sel2   : out std_logic;         -- ADC channel select, bit 2  
            adc_bits   : in  std_logic;  -- Bitstream from the analog part of ADC
            adc_ref2v  : out std_logic;  -- Select 2V internal ADC reference (1V)
            adc_extref : out std_logic;  -- Select external ADC reference (internal)
            adc_diff   : out std_logic;  -- Select differential ADC mode (single-ended)
            adc_en     : out std_logic;         -- Enable for the ADC
            dac0_bits  : out std_logic;         -- Bitstream to DAC0
            dac1_bits  : out std_logic;         -- Bitstream to DAC1 
            dac0_en    : out std_logic;         -- Enable for DAC0
            dac1_en    : out std_logic;         -- Enable for DAC1 
            clk_a      : out std_logic;         -- Clock to the DAC's and ADC 

            -- Port A
            pa_i       : in  std_logic_vector(7 downto 0);
            pa_en      : out std_logic_vector(7 downto 0);
            pa_o       : out std_logic_vector(7 downto 0);
            -- Port B
            pb_i       : in  std_logic_vector(7 downto 0);
            pb_en      : out std_logic_vector(7 downto 0);
            pb_o       : out std_logic_vector(7 downto 0);
            -- Port C
            pc_i       : in  std_logic_vector(7 downto 0);
            pc_en      : out std_logic_vector(7 downto 0);
            pc_o       : out std_logic_vector(7 downto 0);
            -- Port D
            pd_i       : in  std_logic_vector(7 downto 0);
            pd_en      : out std_logic_vector(7 downto 0);
            pd_o       : out std_logic_vector(7 downto 0);
            -- Port E
            pe_i       : in  std_logic_vector(7 downto 0);
            pe_en      : out std_logic_vector(7 downto 0);
            pe_o       : out std_logic_vector(7 downto 0);
            -- Port F
            pf_i       : in  std_logic_vector(7 downto 0);
            pf_en      : out std_logic_vector(7 downto 0);
            pf_o       : out std_logic_vector(7 downto 0);
            -- Port G
            pg_i       : in  std_logic_vector(7 downto 0);
            pg_en      : out std_logic_vector(7 downto 0);
            pg_o       : out std_logic_vector(7 downto 0);
            -- Port H
            ph_i       : in  std_logic_vector(7 downto 0);
            ph_en      : out std_logic_vector(7 downto 0);
            ph_o       : out std_logic_vector(7 downto 0);
            -- Port I
            pi_i       : in  std_logic_vector(7 downto 0);
            pi_en      : out std_logic_vector(7 downto 0);
            pi_o       : out std_logic_vector(7 downto 0);
            -- Port J
            pj_i       : in  std_logic_vector(7 downto 0);
            pj_en      : out std_logic_vector(7 downto 0);
            pj_o       : out std_logic_vector(7 downto 0);

            -- I/O cell configuration control outputs
            -- d_hi        : out std_logic; -- High drive on DRAM interface, now used for other outputs
            -- d_sr        : out std_logic; -- Slew rate limit on DRAM interface
            d_lo        : out std_logic; -- Low drive on DRAM interface
            p1_hi       : out std_logic; -- High drive on port group 1 pins
            p1_sr       : out std_logic; -- Slew rate limit on port group 1 pins
            p2_hi       : out std_logic; -- High drive on port group 2 pins
            p2_sr       : out std_logic; -- Slew rate limit on port group 2 pins
            p3_hi       : out std_logic; -- High drive on port group 3 pins
            p3_sr       : out std_logic; -- Slew rate limit on port group 3 pins

            -- OSPI interface
            OSPI_Out    : out  OSPI_InterfaceOut_t;
            OSPI_DQ_i   : in  std_logic_vector(7 downto 0);
            OSPI_DQ_o   : out std_logic_vector(7 downto 0);
            OSPI_DQ_e   : out std_logic;
            OSPI_RWDS_i : in  std_logic;
            OSPI_RWDS_o : out std_logic;
            OSPI_RWDS_e : out std_logic
        );
    end component;

    -- SDRAM (remove)
    signal D_CLK : std_logic;
    signal D_CS  : std_logic;
    signal D_RAS : std_logic;
    signal D_CAS : std_logic;
    signal D_WE  : std_logic;
    signal D_DQM : std_logic_vector(7 downto 0);
    signal D_DQ  : std_logic_vector(7 downto 0);
    signal D_A   : std_logic_vector(13 downto 0);
    signal D_BA  : std_logic_vector(1 downto 0);
    signal D_CKE : std_logic_vector(3 downto 0);

    signal MRSTOUT : std_logic;

    -- NC PINS!!!!
    signal MCKOUT1    : std_logic;        -- out
    signal MTEST      : std_logic;        -- in
    signal MBYPASS    : std_logic;        -- in
    signal MIRQ1      : std_logic;        -- in
    signal MWAKEUP_LP : std_logic;        -- in
    signal MLP_PWR_OK : std_logic;        -- in
    signal MPMIC_CORE : std_logic;        -- out
    signal MPMIC_IO   : std_logic;        -- out

    -- Misc analog in (also NC)
    signal pwr_ok     : std_logic; -- in  
    signal vdd_bmem   : std_logic; -- in  
    signal VCC18LP    : std_logic; -- in  
    signal rxout      : std_logic; -- in  
    signal adc_bits   : std_logic; -- in  

    -- Outputs (NC)
    signal dis_bmem   : std_logic; -- out 
    signal ach_sel0   : std_logic; -- out 
    signal ach_sel1   : std_logic; -- out 
    signal ach_sel2   : std_logic; -- out 
    signal adc_ref2v  : std_logic; -- out 
    signal adc_extref : std_logic; -- out 
    signal adc_diff   : std_logic; -- out 
    signal adc_en     : std_logic; -- out 
    signal dac0_bits  : std_logic; -- out 
    signal dac1_bits  : std_logic; -- out 
    signal dac0_en    : std_logic; -- out 
    signal dac1_en    : std_logic; -- out 
    signal clk_a      : std_logic; -- out 

    -- Ports
        
    signal pa_i : std_logic_vector(7 downto 0);
    signal pb_i : std_logic_vector(7 downto 0);
    signal pc_i : std_logic_vector(7 downto 0);
    signal pd_i : std_logic_vector(7 downto 0);
    signal pe_i : std_logic_vector(7 downto 0);
    signal pf_i : std_logic_vector(7 downto 0);
    signal pg_i : std_logic_vector(7 downto 0);
    signal ph_i : std_logic_vector(7 downto 0);
    signal pi_i : std_logic_vector(7 downto 0);
    signal pj_i : std_logic_vector(7 downto 0);

    signal pa_o : std_logic_vector(7 downto 0);
    signal pb_o : std_logic_vector(7 downto 0);
    signal pc_o : std_logic_vector(7 downto 0);
    signal pd_o : std_logic_vector(7 downto 0);
    signal pe_o : std_logic_vector(7 downto 0);
    signal pf_o : std_logic_vector(7 downto 0);
    signal pg_o : std_logic_vector(7 downto 0);
    signal ph_o : std_logic_vector(7 downto 0);
    signal pi_o : std_logic_vector(7 downto 0);
    signal pj_o : std_logic_vector(7 downto 0);

    signal pa_p : std_logic_vector(7 downto 0);
    signal pb_p : std_logic_vector(7 downto 0);
    signal pc_p : std_logic_vector(7 downto 0);
    signal pd_p : std_logic_vector(7 downto 0);
    signal pe_p : std_logic_vector(7 downto 0);
    signal pf_p : std_logic_vector(7 downto 0);
    signal pg_p : std_logic_vector(7 downto 0);
    signal ph_p : std_logic_vector(7 downto 0);
    signal pi_p : std_logic_vector(7 downto 0);
    signal pj_p : std_logic_vector(7 downto 0);
        
    signal pa_en  : std_logic_vector(7 downto 0);
    signal pb_en  : std_logic_vector(7 downto 0);
    signal pc_en  : std_logic_vector(7 downto 0);
    signal pd_en  : std_logic_vector(7 downto 0);
    signal pe_en  : std_logic_vector(7 downto 0);
    signal pf_en  : std_logic_vector(7 downto 0);
    signal pg_en  : std_logic_vector(7 downto 0);
    signal ph_en  : std_logic_vector(7 downto 0);
    signal pi_en  : std_logic_vector(7 downto 0);
    signal pj_en  : std_logic_vector(7 downto 0);

    signal OSPI_DQ_i   : std_logic_vector(7 downto 0);
    signal OSPI_DQ_o   : std_logic_vector(7 downto 0);
    signal OSPI_DQ_e   : std_logic;                   
    signal OSPI_RWDS_i : std_logic;                   
    signal OSPI_RWDS_o : std_logic;                   
    signal OSPI_RWDS_e : std_logic;                    

    signal HCLK     : std_logic;
    signal clk_200m : std_logic;
    signal clk_100m : std_logic;
    signal clk_50m  : std_logic;

    signal counter34 : unsigned(33 downto 0) := (others => '0');


begin

    LED(7)          <= not pa_o(7) when pa_en(7) = '1' else not PA7_SOUT;
    LED(6)          <= not pa_o(6) when pa_en(6) = '1' else not PA6_SCK;
    LED(5)          <= not pa_o(5) when pa_en(5) = '1' else not PA5_CS_N;
    LED(4)          <= not pa_o(0) when pa_en(0) = '1' else not PA0_SIN;
    LED(3 downto 0) <= std_logic_vector(counter34(33 downto 30));

    PA7_SOUT <= pa_p(7);
    pa_i(7)  <= PA7_SOUT;
    
    PA6_SCK  <= pa_p(6);
    pa_i(6)  <= PA6_SCK;
    
    PA5_CS_N <= pa_p(5);
    pa_i(5)  <= PA5_CS_N;
    
    PA0_SIN  <= pa_p(0);
    pa_i(0)  <= PA0_SIN;

    UTX     <= pj_p(0);
    pj_i(0) <= UTX;
    URX     <= pj_p(1);
    pj_i(1) <= URX;
    
    -- oSPI
    OSPI_DQ     <= OSPI_DQ_o   when OSPI_DQ_e   = '1' else (others => 'Z');   
    OSPI_RWDS   <= OSPI_RWDS_o when OSPI_RWDS_e = '1' else 'Z';
    OSPI_DQ_i   <= OSPI_DQ;
    OSPI_RWDS_i <= OSPI_RWDS;  

    OE_CTR <= '1';  -- Low tri-states levelshifter outputs

    -- Ethernet
    ENET_RST_N <= MRSTOUT;

    ENET_MDC  <= '0'; -- TODO
    ENET_MDIO <= 'Z'; -- TODO
    -- 
    pf_i(1)    <= ENET_TXCLK;
    ENET_TXCTL <= pf_o(0); -- RMII TX_EN to TX_CTL
    ENET_TXD0  <= pf_o(2);
    ENET_TXD1  <= pf_o(3);
    ENET_TXD2  <= '0';   -- RMII Not used ( TODO GND or floating? )
    ENET_TXD3  <= pg_o(0); -- RMII TX_ER to TXD3

    pg_i(1) <= ENET_RXCLK;
    pf_i(4) <= ENET_RXCTL; -- RMII DV to RX_CTL
    pf_i(6) <= ENET_RXD0;
    pf_i(7) <= ENET_RXD1;
    --pg_i(6) <= ENET_RXD2; -- RMII Not used
    pf_i(5) <= ENET_RXD3; -- RMII RX_ER to RXD3

    -- Analog in
    pwr_ok     <= '1'; -- Active high, not described in data book DEV7026
    vdd_bmem   <= '0'; -- Seems to be NC in top
    VCC18LP    <= '0'; -- Power for the RTC block. NC in top  
    rxout      <= '0'; -- 32KHz oscillator input, NC in rtc
    adc_bits   <= '0'; -- AC input stream

    MTEST      <= '0'; -- Active high, disabled (But what does it do?) 
    MBYPASS    <= '1'; -- Bypass PLL (use ext clock)
    MIRQ1      <= '1'; -- Active low
    MWAKEUP_LP <= '0'; -- Active high, not described in data book DEV7026
    MLP_PWR_OK <= '1'; -- Presumably active high??

port_out_z_gen: for i  in 0 to 7 generate
   pa_p(i) <= pa_o(i) when pa_en(i) = '1' else 'Z';
   pb_p(i) <= pb_o(i) when pb_en(i) = '1' else 'Z';
   pc_p(i) <= pc_o(i) when pc_en(i) = '1' else 'Z';
   pd_p(i) <= pd_o(i) when pd_en(i) = '1' else 'Z';
   pe_p(i) <= pe_o(i) when pe_en(i) = '1' else 'Z';
   pf_p(i) <= pf_o(i) when pf_en(i) = '1' else 'Z';
   pg_p(i) <= pg_o(i) when pg_en(i) = '1' else 'Z';
   ph_p(i) <= ph_o(i) when ph_en(i) = '1' else 'Z';
   pi_p(i) <= pi_o(i) when pi_en(i) = '1' else 'Z';
   pj_p(i) <= pj_o(i) when pj_en(i) = '1' else 'Z';
end generate;

    LED_cnt_proc : process(HCLK)
    begin
        if rising_edge(HCLK) then
            counter34 <= counter34 + 1;
        end if;
    end process;

    fpga_pll_inst : clk_wiz_0
        port map (
            clk_in1_p => VCU118_Clk300M_p,
            clk_in1_n => VCU118_Clk300M_n,
            clk_200M  => clk_200M,
            clk_100M  => clk_100M,
            clk_50M   => clk_50M
        );

    HCLK <= clk_100m;

    im4000_inst : top
        generic map (
            g_memory_type     => fpga,
            g_clock_frequency => 100  -- Frequency in MHz
        )
        port map (
            HCLK       => HCLK,
            MRESET     => MRESET,
            MRSTOUT    => MRSTOUT,
            MIRQOUT    => MIRQOUT,
            MCKOUT0    => MCKOUT0,
            MCKOUT1    => MCKOUT1,
            MTEST      => MTEST,
            MBYPASS    => MBYPASS,
            MIRQ0      => MIRQ0,
            MIRQ1      => MIRQ1,
            MSDIN      => MSDIN,
            MSDOUT     => MSDOUT,
            MWAKEUP_LP => MWAKEUP_LP,
            MLP_PWR_OK => MLP_PWR_OK,
            MPMIC_CORE => MPMIC_CORE,
            MPMIC_IO   => MPMIC_IO,
            D_CLK      => D_CLK,
            D_CS       => D_CS,
            D_RAS      => D_RAS,
            D_CAS      => D_CAS,
            D_WE       => D_WE,
            D_DQM      => D_DQM,
            D_DQ       => D_DQ,
            D_A        => D_A,
            D_BA       => D_BA,
            D_CKE      => D_CKE,
            pwr_ok     => pwr_ok,
            dis_bmem   => dis_bmem,
            vdd_bmem   => vdd_bmem,
            VCC18LP    => VCC18LP,
            rxout      => rxout,
            ach_sel0   => ach_sel0,
            ach_sel1   => ach_sel1,
            ach_sel2   => ach_sel2,
            adc_bits   => adc_bits,
            adc_ref2v  => adc_ref2v,
            adc_extref => adc_extref,
            adc_diff   => adc_diff,
            adc_en     => adc_en,
            dac0_bits  => dac0_bits,
            dac1_bits  => dac1_bits,
            dac0_en    => dac0_en,
            dac1_en    => dac1_en,
            clk_a      => clk_a,
            pa_i       => pa_i ,
            pa_en      => pa_en,
            pa_o       => pa_o ,
            pb_i       => pb_i ,
            pb_en      => pb_en,
            pb_o       => pb_o ,
            pc_i       => pc_i ,
            pc_en      => pc_en,
            pc_o       => pc_o ,
            pd_i       => pd_i ,
            pd_en      => pd_en,
            pd_o       => pd_o ,
            pe_i       => pe_i ,
            pe_en      => pe_en,
            pe_o       => pe_o ,
            pf_i       => pf_i ,
            pf_en      => pf_en,
            pf_o       => pf_o ,
            pg_i       => pg_i ,
            pg_en      => pg_en,
            pg_o       => pg_o ,
            ph_i       => ph_i ,
            ph_en      => ph_en,
            ph_o       => ph_o ,
            pi_i       => pi_i ,
            pi_en      => pi_en,
            pi_o       => pi_o ,
            pj_i       => pj_i ,
            pj_en      => pj_en,
            pj_o       => pj_o ,
            OSPI_Out   => OSPI_Out,
            OSPI_DQ_i  => OSPI_DQ_i,
            OSPI_DQ_o  => OSPI_DQ_o,
            OSPI_DQ_e  => OSPI_DQ_e,
            OSPI_RWDS_i => OSPI_RWDS_i,
            OSPI_RWDS_o => OSPI_RWDS_o,
            OSPI_RWDS_e => OSPI_RWDS_e
        );

end rtl;
