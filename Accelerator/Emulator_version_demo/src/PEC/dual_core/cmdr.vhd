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
-- Title      : Cluster Memory Data Register
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : CMDR.vhd
-- Author     : Chuhang Jin
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: Data from memory (DFM) and data to memory (DTM) logic for 
--              connection with cluster memory
-------------------------------------------------------------------------------
-- TO-DO list :
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2021-10-26           1.0         CJ      Created        
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmdr is
    port(
        --Clock and reset functions
        CLK_P     : in std_logic;
        RST_EN    : in std_logic;
        CLK_E_NEG : in std_logic;   
        --Microprogram control
        PL        : in std_logic_vector(127 downto 0);
        --Cluster data interface
        EXE       : in std_logic;
        DATA_VLD  : in std_logic;
        REQ_OUT   : out std_logic;
        ACK_IN    : in std_logic;
        DIN       : in std_logic_vector(127 downto 0);
        DOUT      : out std_logic_vector(31 downto 0);
        --Core interface
        YBUS      : in std_logic_vector(7 downto 0);
        LD_MPGM   : in std_logic;
        VE_DIN    : out std_logic_vector(63 downto 0); --to vector engine
        DBUS_DATA : out std_logic_vector(7 downto 0);  --to DSL
        MPGMM_IN  : out std_logic_vector(127 downto 0); --to microprogram memory
        VE_DTMO   : in std_logic_vector(127 downto 0)  --output DTM data from VE;
        
    );
end; 

architecture rtl of cmdr is

    COMPONENT fifo_generator_0
    PORT (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    prog_full : OUT STD_LOGIC;
    wr_rst_busy : OUT STD_LOGIC;
    rd_rst_busy : OUT STD_LOGIC
    );
    END COMPONENT;

    --control fields
    signal pl_dbus_s     : std_logic_vector(4 downto 0);
    signal pl_dfm_byte    : std_logic_vector(3 downto 0);
    --signal pl_pd_sig      : std_logic_vector(2 downto 0);
    signal ddfm_trig     : std_logic;
    signal ld_dtm        : std_logic;
    signal fifo_push     : std_logic;
    signal dtm_mux_sel    : std_logic_vector(1 downto 0);
    signal pl_send_req   : std_logic;
    signal send_req_d    : std_logic;
    signal send_req      : std_logic;

    signal ve_data_int : std_logic_vector(63 downto 0);
    signal mp_data_int : std_logic_vector(127 downto 0);
    signal dbus_reg    : std_logic_vector(127 downto 0);
    signal output_int  : std_logic_vector(32 downto 0);
    signal dbus_int    : std_logic_vector(7 downto 0);
    signal dtm_reg     : std_logic_vector(31 downto 0);
    signal ve_in_cnt   : std_logic_vector(1 downto 0);
    signal ld_dtm_v    : std_logic;
    signal fifo_wr_en  : std_logic;
    signal fifo_rd_en  : std_logic;
    signal init_mpgm_rq : std_logic_vector(31 downto 0);
    signal init_mpgm_rq_single : std_logic_vector(31 downto 0);
    signal empty       : std_logic;
    signal fb          : std_logic;
    signal req         : std_logic;
    signal srst        : std_logic;
    attribute keep : string;
    attribute keep of mp_data_int : signal is "true";

begin
--*******************************************************************     
-- Cluster DFM
--*******************************************************************
    pl_dfm_byte  <= PL(112 downto 109);
    pl_dbus_s    <= pl(108)&pl(50)&pl(22)&pl(14)&pl(44);
    process(clk_p)
    begin 
        if rising_edge(clk_p) then
            if RST_EN = '0' then
                ddfm_trig <= '0';
            elsif pl_dbus_s = "10001" then
                ddfm_trig <= '1';
            elsif DATA_VLD = '1' then
                ddfm_trig <= '0';
            end if;
        end if;
    end process;
    process(clk_p)
    begin
        if rising_edge(clk_p) then
            if RST_EN = '0' then
                ve_data_int <= (others => '0');
                mp_data_int <= (others => '0');
                dbus_reg <= (others => '0');
            elsif DATA_VLD = '1' then 
                mp_data_int <= DIN;           --input to microprogram data
                if CLK_E_NEG = '0' then
                    ve_data_int <= DIN(63 downto 0); --input lower half to vector engine at falling edge of clk_e
                elsif CLK_E_NEG = '1' then
                    ve_data_int <= DIN(127 downto 64); --input upper half to vector engine at rising edge of clk_e
                end if;
                if ddfm_trig = '1' then --load dbus register once when d source is cdfm (maximum 16 clk_e cycles before send next read request to cluster controller!!)
                    dbus_reg <= DIN;
                end if;
            end if;
        end if;
    end process;

    dbus_int <= dbus_reg(8*(to_integer(unsigned(pl_dfm_byte)))+7 downto 8*(to_integer(unsigned(pl_dfm_byte))));
    VE_DIN <= ve_data_int;
    MPGMM_IN <= mp_data_int;
    DBUS_DATA <= dbus_int;

--*******************************************************************     
-- Cluster DTM
--*******************************************************************
    --Cluster DTM has two input sources. One is ybus, which is controlled by the microcode directly and the bandwidth is 8 bits per clock e cycle
    --The other is VE's DTM buffer. The rate is 32 bits per clock e cycle.
    --pl_pd_sig <= (pl(19) xor pl(66))&(pl(43) xor pl(39))& pl(38);
    ld_dtm <= pl(43) xor pl(39); --PD signal bit 1.
    dtm_mux_sel <= pl(117 downto 116);
    ld_dtm_v <= pl(88);
    fifo_push <= pl(114);
    pl_send_req <= pl(113);
    init_mpgm_rq <= "01000111111111110000000000000000"; --Broadcast request for 7 PEs.
    init_mpgm_rq_single <= "01000000111111110000000000000000"; --Broadcast request for 1 PE.
    process(clk_p)
    begin
    if rising_edge(clk_p) then --
        if rst_en = '0' then
            dtm_reg <= (others => '0');
            ve_in_cnt <= (others => '0');
        elsif EXE = '1' then   --load DTM with initial microcode loading word when receives exe command from cluster controller
            dtm_reg <= init_mpgm_rq_single;
            ve_in_cnt <= (others => '0');
        elsif ld_dtm = '1' and CLK_E_NEG = '1' then --rising_edge
            dtm_reg(8*(to_integer(unsigned(dtm_mux_sel)))+7 downto 8*(to_integer(unsigned(dtm_mux_sel)))) <= YBUS;
            ve_in_cnt <= (others => '0');
        elsif ld_dtm_v = '1' and CLK_E_NEG = '1' then --rising_edge
            dtm_reg <= VE_DTMO(32*(to_integer(unsigned(ve_in_cnt)))+31 downto 32*(to_integer(unsigned(ve_in_cnt))));
            ve_in_cnt <= std_logic_vector(to_unsigned(to_integer(unsigned(ve_in_cnt))+1,2));
        end if;
    end if;
    end process;
    --Fifo control signals
    process(clk_p)
    begin
        if rising_edge(clk_p) then
            if EXE = '1' or fifo_push = '1' then --push data to fifo at falling edge of clock e.
                if CLK_E_NEG = '0' then
                    fifo_wr_en <= '1';
                else
                    fifo_wr_en <= '0';
                end if;
            else
                fifo_wr_en <= '0';
            end if;
        end if;
    end process;

    process(clk_p)
    begin
        if rising_edge(clk_p) then
            if clk_e_neg = '1' then --rising_edge
                if EXE ='1'then
                    send_req_d <= '1';
                else
                    send_req_d <= pl_send_req;
                end if;
                send_req <= send_req_d;
            end if;
        end if;
    end process;

    process(clk_p)
    begin
        if rising_edge(clk_p) then
            if send_req = '1' and CLK_E_NEG = '0' and empty = '0'then
                fifo_rd_en <= '1';
            else
                fifo_rd_en <= '0';
            end if;
        end if;
    end process;

    process(clk_p) --send_req set the req flag and ack(fb) resets the req_flag.
    begin
        if rising_edge(clk_p) then
            if clk_e_neg = '1' then
                if rst_en = '0' then
                    req <= '0';
                elsif fb = '0' then 
                    if send_req = '1' then
                        req <= '1';
                    end if;
                elsif fb = '1' then
                    req <= '0';
                end if;
            end if;
        end if;
    end process;
    
    REQ_OUT <= req;
    fb  <= ACK_IN;
    srst <= not rst_en;

    req_fifo : fifo_generator_0
    PORT MAP (
    clk => CLK_P,
    srst => srst,
    din => dtm_reg,
    wr_en => fifo_wr_en,
    rd_en => fifo_rd_en,
    dout => DOUT,
    full => open,
    empty => empty,
    prog_full => open, --asserts when 5 words inside
    wr_rst_busy => open,
    rd_rst_busy => open
    );
end architecture;



