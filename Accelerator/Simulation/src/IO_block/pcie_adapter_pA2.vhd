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
-- Title      : PCIe Adapter
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : pcie_a.vhd
-- Author     : Chuhang Jin
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
-- Date					Version		Author	Description
-- 2020-1-19  		     1.0	     CJ			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity pcie_a is
    port(
        REF_CLK    : in    std_logic;                                     
        -- PCIe DMA
        PCIE_REQ_IF_CLK_O           : out std_logic;                      
        PCIE_REQ_IF_RST_O           : out std_logic;                      
        PCIE_WR_REQ_CTRL_WRS        : out std_logic;                      
                                                                          
        PCIE_WR_REQ_CTRL_LENGTH     : out std_logic_vector (4 downto 0);  
        PCIE_WR_REQ_CTRL_START_ADDR : out std_logic_vector (57 downto 0); 
                                                                          
        PCIE_WR_REQ_CTRL_AFU        : in  std_logic;                      
        PCIE_WR_REQ_DATA_WRS        : out std_logic;                      
        PCIE_WR_REQ_DATA            : out std_logic_vector (255 downto 0);
        PCIE_WR_REQ_DATA_AFU        : in  std_logic;                      
        PCIE_RD_REQ_WRS             : out std_logic;                      
        PCIE_RD_REQ_START_ADDR      : out std_logic_vector (57 downto 0); 
        PCIE_RD_REQ_LENGTH          : out std_logic_vector (4 downto 0);  
        PCIE_RD_REQ_AFU             : in  std_logic;                      
        PCIE_RD_RESP_DATA_VLD       : in  std_logic;                      
        PCIE_RD_RESP_DATA_FIRST     : in  std_logic;                      
        PCIE_RD_RESP_DATA_LAST      : in  std_logic;                      
        PCIE_RD_RESP_DATA           : in  std_logic_vector (255 downto 0);

        -- Config and status interface#1
        REG1_REF_CLK     : in    std_logic;                    
        REG1_USER_CLK    : out   std_logic;                    
        REG1_USER_RST    : out   std_logic;                    
        REG1_WEA         : in    std_logic;                    
        REG1_WDA         : in    std_logic_vector(31 downto 0);
        REG1_ADA         : in    std_logic_vector(15 downto 0);
        REG1_REA         : in    std_logic;                    
        REG1_RDA         : out   std_logic_vector(31 downto 0);
        REG1_RDAV        : out   std_logic;                    
        REG1_AC          : out   std_logic; 
                 

        --NOC side
        NOC_DATA         : out std_logic_vector(255 downto 0);
        PCIE_DATA        : in std_logic_vector(255 downto 0);
        PCIE_ADDRESS     : in std_logic_vector(31 downto 0);
        PCIE_LENGTH      : in std_logic_vector(4 downto 0);
        PCIE_RDY         : out std_logic;
        CMD_FLAG         : out std_logic;--PCIe CMD
        NOC_CMD_FLAG     : in std_logic;
        RW_FLAG          : in std_logic;
        ENA_PCIE_CTL     : in std_logic;
        ENA_PCIE_DATA    : in std_logic;
        PCIE_REQ         : in std_logic;
        PCIE_ACK         : out std_logic;
        NOC_RST          : in std_logic

        --N_REQ           : in std_logic;
        --OP              : out std_logic_vector(11 downto 0);
        --TR_S            : out std_logic_vector(15 downto 0);
        --ADDR_R          : out std_logic_vector(15 downto 0);
        --ADDR_C          : out std_logic_vector(15 downto 0);
        --SWITCH          : out std_logic_vector(3 downto 0);
        ----EXT_MEM         : in std_logic_vector(31 downto 0);
        --TRIG            : in std_logic;
        --N_RST           : in std_logic
    );
end entity;

architecture rtl of pcie_a is
    --pcie-noc IO
    signal clk             : std_logic;
    signal h2c_cmd         : std_logic;
    signal c2h_cmd         : std_logic;
    signal h2c_addr_h      : std_logic_vector(31 downto 0);
    signal h2c_addr_l      : std_logic_vector(31 downto 0);
    signal c2h_addr_h      : std_logic_vector(31 downto 0);
    signal c2h_addr_l      : std_logic_vector(31 downto 0);
    signal up_address      : std_logic_vector(57 downto 0);
    signal down_address    : std_logic_vector(57 downto 0);
    signal reset           : std_logic;

    signal tr_case         : std_logic_vector(1 downto 0);
    signal noc_data_i      : std_logic_vector(255 downto 0);
    signal pcie_data_i     : std_logic_vector(255 downto 0);
    --signal pcie_address_i  : std_logic_vector(31 downto 0);
    signal noc_cmd_reg     : std_logic_vector(255 downto 0);  --Irrelevant to NOC_CMD_FLAG
    signal ena_pcie_data_i : std_logic;
    signal pcie_req_i      : std_logic;
    signal pcie_ack_i      : std_logic;
    signal pcie_rdy_i      : std_logic;
    --signal up_cmd          : std_logic_vector(255 downto 0);
    --signal c4_trig         : std_logic;
    signal reset_i           : std_logic;
    signal noc_rst_i         : std_logic;
    signal tr_mod          : integer;
    --------------------------------------------------
    --Debug
    --------------------------------------------------
    signal db_1            : std_logic_vector(31 downto 0);
    signal db_2            : std_logic_vector(31 downto 0);
    signal db_3            : std_logic_vector(31 downto 0);
    signal db_4            : std_logic_vector(31 downto 0);
    signal db_5            : std_logic_vector(31 downto 0);
    signal db_6            : std_logic_vector(31 downto 0);
    signal db_7            : std_logic_vector(31 downto 0);
    signal db_8            : std_logic_vector(31 downto 0);
    signal db_9            : std_logic_vector(31 downto 0);
    signal db_10            : std_logic_vector(31 downto 0);
    signal db_11            : std_logic_vector(31 downto 0);
    signal db_12            : std_logic_vector(31 downto 0);
    signal db_13            : std_logic_vector(31 downto 0);
    --type mem_type is array (1024 downto 0) of std_logic_vector(255 downto 0);
    --signal t_mem : mem_type;
    --signal addr_p: std_logic_vector(15 downto 0);
    --signal len_c : std_logic_vector(15 downto 0);
    --signal rw_mem : std_logic;
begin
-----------------------------------------------------
--signal port map
-----------------------------------------------------
--NOC
    ena_pcie_data_i                <= ENA_PCIE_DATA;
    CMD_FLAG                       <= h2c_cmd;
    c2h_cmd                        <= NOC_CMD_FLAG; 
    PCIE_RDY                       <= pcie_rdy_i;
    PCIE_ACK                       <= pcie_ack_i;
    pcie_req_i                     <= PCIE_REQ;
    noc_rst_i                      <= NOC_RST;
    NOC_DATA                       <= noc_data_i;
    pcie_data_i                    <= PCIE_DATA;
--PCIe
    clk                            <= REF_CLK; 
    PCIE_WR_REQ_CTRL_WRS           <= ENA_PCIE_CTL and RW_FLAG;
    PCIE_WR_REQ_CTRL_LENGTH        <= PCIE_LENGTH(4 downto 0);
    PCIE_WR_REQ_CTRL_START_ADDR    <= down_address;
    PCIE_WR_REQ_DATA_WRS           <= ENA_PCIE_DATA and RW_FLAG;
    PCIE_WR_REQ_DATA               <= pcie_data_i;
    PCIE_RD_REQ_WRS                <= ENA_PCIE_CTL and not RW_FLAG;
    PCIE_RD_REQ_START_ADDR         <= up_address;
    PCIE_RD_REQ_LENGTH             <= PCIE_LENGTH(4 downto 0);
    noc_data_i                     <= PCIE_RD_RESP_DATA;
--Not necessary:
    pcie_rdy_i <= '1';
    pcie_ack_i <= '1';
--Config and status interface
    addr_reg: process(clk)
    begin
        if rising_edge(clk) then
            if reg1_wea = '1' then 
                if reg1_ada = x"0000" then
                    h2c_addr_h <= reg1_wda;
                elsif reg1_ada = x"0004" then
                    h2c_addr_l <= reg1_wda;
                elsif reg1_ada = x"0008" then
                    c2h_addr_h <= reg1_wda;
                elsif reg1_ada = x"000c" then
                    c2h_addr_l <= reg1_wda;
                end if;
            end if;
        end if;
    end process;
    
    ctrl_reg: process(clk)
    begin
        if rising_edge(clk) then
            if reg1_wea = '1' and reg1_ada = x"0010" then
                
                h2c_cmd  <= reg1_wda(0);   --ctrl register bit 0, for command
                --pcie_ack  <= reg1_wda(1);   --ctrl register bit 1, for acknowledgement
                reset     <= reg1_wda(2);   --ctrl register bit 2, for reset
                --pcie_rdy  <= reg1_wda(3);   --ctrl register bit 3, for pcie-ready acknowledgement
            elsif tr_case = "00" and ena_pcie_data = '1' then
                h2c_cmd <= '0';
            else
                h2c_cmd  <= 'Z';
                pcie_ack  <= 'Z';
                reset     <= 'Z';
            end if;
        end if;
    end process;

    status_reg: process(clk)
    begin
        if rising_edge(clk) then
            if reg1_rea = '1' and reg1_ada = x"0014" then
                reg1_rda(1) <= c2h_cmd;
                reg1_rda(2) <= pcie_req;
            end if;
        end if;
    end process;

    debug_reg : process(clk)
    begin 
        if rising_edge(clk) then
            if reg1_rea = '1' then 
                if reg1_ada = x"0020" then
                    reg1_rda <= db_1;
                elsif reg1_ada = x"0024" then
                    reg1_rda <= db_2;
                elsif reg1_ada = x"0028" then
                    reg1_rda <= db_3;
                elsif reg1_ada = x"002c" then
                    reg1_rda <= db_4;
                elsif reg1_ada = x"0030" then
                    reg1_rda <= db_5;
                elsif reg1_ada = x"0034" then
                    reg1_rda <= db_6;
                elsif reg1_ada = x"0038" then
                    reg1_rda <= db_7;
                elsif reg1_ada = x"003c" then
                    reg1_rda <= db_8;
                elsif reg1_ada = x"0040" then
                    reg1_rda <= db_9;
                elsif reg1_ada = x"0044" then
                    reg1_rda <= db_10;
                elsif reg1_ada = x"0048" then
                    reg1_rda <= db_11;
                elsif reg1_ada = x"004c" then
                    reg1_rda <= db_12;
                elsif reg1_ada = x"0050" then
                    reg1_rda <= db_13;
                end if;
            end if;
        end if;
    end process;
-----------------------------------------------------
--User cases
-----------------------------------------------------
    u_case : process(clk) 
    begin
        if rising_edge(clk) then
            --RESET
            if reset = '1' or noc_rst_i = '1' then
                noc_cmd_reg <= (others=>'0');
                up_address <= (others=>'0');
                down_address <=(others => '0');
            elsif tr_case = "00" then
                if h2c_cmd = '1' then
                    up_address <= h2c_addr_h & h2c_addr_l(31 downto 6);
                    --User case 1
                    if ena_pcie_data_i = '1' then
                        noc_cmd_reg <= PCIE_RD_RESP_DATA;
                        noc_data_i  <= PCIE_RD_RESP_DATA;
                    end if;
                --User case 2
                elsif c2h_cmd = '1' then
                    down_address <= c2h_addr_h & c2h_addr_l(31 downto 6);
                    --if pcie_ack = '1' then
                    --    ena_pcie_data <= '1';
                    --    rw_flag <= "10";  --Write mode
                    --    pcie_data <= up_cmd;
                    --    ena_pcie_ctl <= '1';
                    --    pcie_req <= '0';
                    --end if;
                end if;
            --User case 3
            elsif tr_case = "01" then
                up_address <= x"00000000" & PCIE_ADDRESS(31 downto 6);
                --pcie length?
                --rw_flag <= "01";
                --ena_pcie_ctl <= '1';
                --if pcie_rdy <= '1' then
                --    ena_pcie_data <= '1';
                --    rw_flag <= "01";
                --    md_reg <= noc_data; 
                --    --t_mem(to_integer(unsigned(addr_p))) <= noc_data;
                --end if;
            --User case 4
            elsif tr_case = "10" then
                down_address <= x"00000000" & PCIE_ADDRESS(31 downto 6);
            end if;
        end if;
    end process;

    REG1_AC <= REG1_REA or REG1_WEA;
    REG1_RDAV <= REG1_REA;


-----------------------------------------------------
--NOC state machine
-----------------------------------------------------         

    transfer : process (noc_cmd_reg)
    begin
        case noc_cmd_reg(11 downto 0) is
            when x"000" =>
            tr_mod <= 0;
            when x"010" =>
            tr_mod <= 1;
            when x"012" =>
            tr_mod <= 2;
            when x"014" =>
            tr_mod <= 3;
            when x"016" =>
            tr_mod <= 4;
            when x"018" =>
            tr_mod <= 5;
            when x"01a" =>
            tr_mod <= 6;
            when x"01c" =>
            tr_mod <= 7;
            when x"01e" =>
            tr_mod <= 8;
            when x"020" =>
            tr_mod <= 9;
            when x"022" =>
            tr_mod <= 10;
            when x"024" =>
            tr_mod <= 11;
            when x"026" =>
            tr_mod <= 12;
            when x"028" =>
            tr_mod <= 13;
            when x"02a" =>
            tr_mod <= 14;
            when x"02c" =>
            tr_mod <= 15;
            when x"02e" =>
            tr_mod <= 16;
            when others =>
            tr_mod <= 17;
        end case;
    end process;

    tr_act: process(tr_mod)
    begin
            if tr_mod = 1 or tr_mod = 3 or tr_mod = 4 then
                tr_case <= "01";
            elsif tr_mod = 6 or tr_mod = 10 or tr_mod = 11 or tr_mod = 14 then
                tr_case <= "10";
            else
                tr_case <= "00";
            end if;
    end process;


    --addr_dist: process(tr_mod,ena_pcie_data)
    --begin
    --    if tr_mod = 0 then
    --        pcie_address <= (others => '0'); --can be replaced with a specific address
    --        tr_size      <= (others => '0');
    --    elsif tr_mod = 1 then
    --        pcie_address <= noc_cmd_reg(95 downto 64);
    --        address_r <= noc_cmd_reg(47 downto 32);
    --        tr_size   <= noc_cmd_reg(31 downto 16);
    --    elsif tr_mod = 3 then
    --        pcie_address <= noc_cmd_reg(95 downto 64);
    --        address_c <= noc_cmd_reg(63 downto 48);
    --        tr_size   <= noc_cmd_reg(31 downto 16);
    --    elsif tr_mod = 4 then
    --        pcie_address <= noc_cmd_reg(95 downto 64);
    --        address_c <= noc_cmd_reg(63 downto 48);
    --        tr_size   <= noc_cmd_reg(31 downto 16);
    --    elsif tr_mod =6 then
    --        pcie_address <= noc_cmd_reg(95 downto 64);
    --        address_r <= noc_cmd_reg(47 downto 32);
    --        tr_size   <= noc_cmd_reg(31 downto 16);
    --    elsif tr_mod =8 then
    --        address_c <= noc_cmd_reg(63 downto 48);
    --        address_r <= noc_cmd_reg(47 downto 32);
    --        tr_size   <= noc_cmd_reg(31 downto 16);
    --    elsif tr_mod =9 then
    --        address_c <= noc_cmd_reg(63 downto 48);
    --        address_r <= noc_cmd_reg(47 downto 32);
    --        tr_size   <= noc_cmd_reg(31 downto 16);
    --    elsif tr_mod =10 then
    --        pcie_address <= noc_cmd_reg(95 downto 64);
    --        address_r <= noc_cmd_reg(47 downto 32);
    --        tr_size   <= noc_cmd_reg(31 downto 16);
    --    elsif tr_mod =11 then
    --        pcie_address <= noc_cmd_reg(95 downto 64);
    --        address_c <= noc_cmd_reg(63 downto 48);
    --        tr_size   <= noc_cmd_reg(31 downto 16);
    --    elsif tr_mod =13 then
    --        address_c <= noc_cmd_reg(63 downto 48);
    --        address_r <= noc_cmd_reg(47 downto 32);
    --        tr_size   <= noc_cmd_reg(31 downto 16);
    --    elsif tr_mod =14 then
    --        pcie_address <= noc_cmd_reg(95 downto 64);
    --        address_r <= noc_cmd_reg(47 downto 32);
    --        tr_size   <= noc_cmd_reg(31 downto 16);
    --    end if;
    --end process;
--
    --len_conv : process(tr_size)
    --begin
    --    if tr_size(0) = '0' then --even length
    --        pcie_length <= '0' & tr_size(15 downto 1);
    --    elsif tr_size(0) = '1' then --odd length
    --        pcie_length <= std_logic_vector(to_unsigned(to_integer(unsigned('0' & tr_size(15 downto 1)))+1,16));
    --    end if;
    --end process;
--
    debug: process(clk, tr_mod, ena_pcie_ctl, ena_pcie_data,tr_case)
    begin
        if tr_case = "00" then
            if ena_pcie_data_i = '1'then
                db_1(11 downto 0) <= PCIE_RD_RESP_DATA(11 downto 0);
            end if;
        elsif tr_case = "01" then
            if ena_pcie_ctl ='1' and ena_pcie_data ='1' then
                db_1 <= PCIE_ADDRESS;
            end if;
        end if;
    end process;

    db_2 <= h2c_addr_h;
    db_3 <= h2c_addr_l;
    db_4 <= c2h_addr_h;
    db_5 <= c2h_addr_l;
    db_6 <= noc_data_i(31 downto 0);
    db_7 <= noc_data_i(63 downto 32);
    db_8 <= noc_data_i(95 downto 64);
    db_9 <= noc_data_i(127 downto 96);
    db_10 <= noc_data_i(159 downto 128);
    db_11 <= noc_data_i(191 downto 160);
    db_12 <= noc_data_i(223 downto 192);
    db_13 <= noc_data_i(255 downto 224);
        
--Additional testing
    --data_rw : process(clk)
    --begin
    --    if rising_edge(clk) then
    --        noc_rst <= '0';
    --        if tr_case = "01" then
    --            if rw_mem /= '1' then
    --                addr_p <= address_c;
    --                len_c  <= tr_size;
    --                rw_mem <= '1';
    --            elsif rw_mem = '1' then
    --                if ena_pcie_data = '1' and len_c/= x"0000" then
    --                    --t_mem(to_integer(unsigned(addr_p))) <= md_reg;
    --                    addr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_p))+1,16));
    --                    len_c <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_p))-1,16));
    --                elsif len_c = x"0000" then
    --                    rw_mem <= '0';
    --                    noc_rst <= '1';
    --                end if;
    --            end if;
    --        elsif tr_case = "10" then
    --            if rw_mem = '0' then
    --                addr_p <= address_c;
    --                len_c  <= tr_size;
    --                rw_mem <= '1';
    --            elsif rw_mem = '1' then
    --                if ena_pcie_data = '1' and len_c/= x"0000" then
    --                    --md_reg <= t_mem(to_integer(unsigned(addr_p)));
    --                    addr_p <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_p))+1,16));
    --                    len_c <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_p))-1,16));
    --                elsif len_c = x"0000" then
    --                    rw_mem <= '0';
    --                    noc_rst <= '1';
    --                end if;
    --            end if;
    --        end if;
    --    end if;
    --end process;
end architecture rtl;








    
    

                