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
-- 2021-1-19  		     1.0	     CJ			Created
-- 2021-3-19             1.1         CJ         Add read buffer
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.all;

entity pcie_a is
    port(
        REF_CLK                     : in  std_logic;                                             
        -- PCIe DMA
        PCIE_REQ_IF_CLK_O           : out std_logic;                      
        PCIE_REQ_IF_RST_O           : out std_logic;
        PCIE_RSP_IF_CLK_I           : in  std_logic;  --250 MHz,
        PCIE_RSP_IF_RST_I           : in  std_logic;  
                            
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
        REG1_REF_CLK                : in  std_logic;                    
        REG1_USER_CLK               : out std_logic;                    
        REG1_USER_RST               : out std_logic;                    
        REG1_WEA                    : in  std_logic;                    
        REG1_WDA                    : in  std_logic_vector(31 downto 0);
        REG1_ADA                    : in  std_logic_vector(15 downto 0);
        REG1_REA                    : in  std_logic;                    
        REG1_RDA                    : out std_logic_vector(31 downto 0);
        REG1_RDAV                   : out std_logic;                    
        REG1_AC                     : out std_logic;                  

        --NOC side
        NOC_DATA                    : out std_logic_vector(255 downto 0);
        PCIE_DATA                   : in  std_logic_vector(255 downto 0);
        PCIE_ADDRESS                : in  std_logic_vector(31 downto 0);
        PCIE_LENGTH                 : in  std_logic_vector(4 downto 0);
        PCIE_RDY                    : out std_logic;
        CMD_FLAG                    : out std_logic; --PCIe CMD
        NOC_CMD_FLAG                : in  std_logic;
        RW_FLAG                     : in  std_logic;  --0 means "read from PCIe", 1 means "write to PCIe"
        ENA_PCIE_CTL                : in  std_logic;
        ENA_PCIE_DATA               : in  std_logic;
        PCIE_REQ                    : in  std_logic;
        PCIE_ACK                    : out std_logic;
        NOC_RST                     : in  std_logic;
        reset_out                   : out std_logic;
        --Test
        h2c_cmd_t                   : out std_logic;
        c2h_cmd_t                   : out std_logic;
        pcie_wr_data_wrs_t          : out std_logic;
        pcie_wr_ctl_wrs_t           : out std_logic        
    );
end entity;

architecture rtl of pcie_a is


component fifo_generator_1
  port (
    rst             : in  std_logic;
    wr_clk          : in  std_logic;
    rd_clk          : in  std_logic;
    din             : in  std_logic_vector(255 downto 0);
    wr_en           : in  std_logic;
    rd_en           : in  std_logic;
    dout            : out std_logic_vector(255 downto 0);
    full            : out std_logic;
    wr_ack          : out std_logic;
    empty           : out std_logic;
    valid           : out std_logic;
    underflow       : out std_logic;
    rd_data_count   : out std_logic_vector(9 downto 0);
    wr_data_count   : out std_logic_vector(9 downto 0);
    wr_rst_busy     : out std_logic;
    rd_rst_busy     : out std_logic
  );
end component;

component ila_3
port (
	clk        : in  std_logic;
	probe0     : in std_logic_vector(255 downto 0); 
	probe1     : in std_logic_vector(57 downto 0); 
	probe2     : in std_logic_vector(0 downto 0); 
	probe3     : in std_logic_vector(0 downto 0); 
	probe4     : in std_logic_vector(0 downto 0); 
	probe5     : in std_logic_vector(0 downto 0); 
	probe6     : in std_logic_vector(0 downto 0); 
	probe7     : in std_logic_vector(0 downto 0); 
	probe8     : in std_logic_vector(0 downto 0); 
	probe9     : in std_logic_vector(0 downto 0); 
	probe10    : in std_logic_vector(0 downto 0);
	probe11    : in std_logic_vector(0 downto 0);
	probe12    : in std_logic_vector(0 downto 0);
	probe13    : in std_logic_vector(0 downto 0);
	probe14    : in std_logic_vector(0 downto 0);	
	probe15    : in std_logic_vector(0 downto 0);
    probe16    : in std_logic_vector(255 downto 0);
    probe17    : in std_logic_vector(4 downto 0); 
	probe18    : in std_logic_vector(0 downto 0);
	probe19    : in std_logic_vector(0 downto 0);
	probe20    : in std_logic_vector(0 downto 0);
	probe21    : in std_logic_vector(0 downto 0);
	probe22    : in std_logic_vector(0 downto 0);
	probe23    : in std_logic_vector(0 downto 0);
	probe24    : in std_logic_vector(0 downto 0);	
	probe25    : in std_logic_vector(0 downto 0);
	probe26    : in std_logic_vector(0 downto 0);
	probe27    : in std_logic_vector(0 downto 0);	
	probe28    : in std_logic_vector(9 downto 0);
	probe29    : in std_logic_vector(9 downto 0);
	probe30    : in std_logic_vector(1 downto 0)
);
end component;

component ila_4
port (
	clk        : in std_logic; 
	probe0     : in std_logic_vector(0 downto 0); 
	probe1     : in std_logic_vector(0 downto 0); 
	probe2     : in std_logic_vector(0 downto 0); 
	probe3     : in std_logic_vector(0 downto 0);
	probe4     : in std_logic_vector(255 downto 0)
);
end component;

component ila_5
port (
	clk        : in std_logic;
	probe0     : in std_logic_vector(0 downto 0);  
	probe1     : in std_logic_vector(31 downto 0); 
	probe2     : in std_logic_vector(15 downto 0); 
	probe3     : in std_logic_vector(0 downto 0);  
	probe4     : in std_logic_vector(31 downto 0); 
	probe5     : in std_logic_vector(0 downto 0); 
	probe6     : in std_logic_vector(0 downto 0); 
	probe7     : in std_logic_vector(31 downto 0); 
	probe8     : in std_logic_vector(31 downto 0); 
	probe9     : in std_logic_vector(31 downto 0); 
	probe10    : in std_logic_vector(31 downto 0); 
	probe11    : in std_logic_vector(0 downto 0); 
	probe12    : in std_logic_vector(0 downto 0); 
	probe13    : in std_logic_vector(0 downto 0); 
	probe14    : in std_logic_vector(0 downto 0)
);
end component;

    --pcie-noc IO
    signal clk                          : std_logic;
    signal h2c_cmd                      : std_logic;
    signal c2h_cmd                      : std_logic;
    signal ack                          : std_logic;
    signal h2c_addr_h                   : std_logic_vector(31 downto 0);
    signal h2c_addr_l                   : std_logic_vector(31 downto 0);
    signal c2h_addr_h                   : std_logic_vector(31 downto 0);
    signal c2h_addr_l                   : std_logic_vector(31 downto 0);
    signal up_address                   : std_logic_vector(57 downto 0);
    signal down_address                 : std_logic_vector(57 downto 0);
    signal reset                        : std_logic;
    signal tr_case                      : std_logic_vector(1 downto 0);
    signal tr_case_p                    : std_logic_vector(1 downto 0);
    signal noc_data_i                   : std_logic_vector(255 downto 0);
    signal pcie_data_i                  : std_logic_vector(255 downto 0);
    signal noc_cmd_reg                  : std_logic_vector(255 downto 0);
    signal ena_pcie_data_i              : std_logic;
    signal pcie_req_i                   : std_logic;
    signal pcie_ack_i                   : std_logic;
    signal noc_rst_i                    : std_logic;
    signal tr_mod                       : integer;
    --------------------------------------------------
    --Debug
    --------------------------------------------------
    signal pcie_wr_ctl_wrs_i            : std_logic;                
    signal pcie_len_i                   : std_logic_vector(4 downto 0);     
    signal fifo_data_i                  : std_logic_vector(255 downto 0);
    signal pcie_cmd_flag_i              : std_logic; 
    --fifo
    signal wr_clk_rb                    : std_logic;   
    signal rd_clk_rb                    : std_logic; 
    signal reset_rb                     : std_logic;
    signal din_rb                       : std_logic_vector(255 downto 0);
    signal wr_en_rb                     : std_logic;  
    signal rd_en_rb                     : std_logic;  
    signal dout_rb                      : std_logic_vector(255 downto 0); 
    signal full_rb                      : std_logic; 
    signal empty_rb                     : std_logic;
    signal empty_rb_P                   : std_logic; 
    signal wr_rst_busy_rb               : std_logic;        
    signal rd_rst_busy_rb               : std_logic;
    signal pcie_wr_data_wrs_i           : std_logic;
    signal pcie_rd_wrs_i                : std_logic;
    signal pcie_wr_req_data_i           : std_logic_vector(255 downto 0);
    signal pcie_req_if_clk_o_int        : std_logic;  
    --ILA signals
    signal probe0_i                     : std_logic_vector(255 downto 0);         
    signal probe1_i                     : std_logic_vector(57 downto 0);
    signal probe2_i                     : std_logic_vector(0 downto 0);
    signal probe3_i                     : std_logic_vector(0 downto 0);
    signal probe4_i                     : std_logic_vector(0 downto 0);
    signal probe5_i                     : std_logic_vector(0 downto 0);
    signal probe6_i                     : std_logic_vector(0 downto 0);
    signal probe7_i                     : std_logic_vector(0 downto 0);
    signal probe8_i                     : std_logic_vector(0 downto 0);
    signal probe9_i                     : std_logic_vector(0 downto 0);
    signal probe10_i                    : std_logic_vector(0 downto 0);
    signal probe11_i                    : std_logic_vector(0 downto 0);
    signal probe12_i                    : std_logic_vector(0 downto 0);
    signal probe13_i                    : std_logic_vector(0 downto 0);
    signal probe14_i                    : std_logic_vector(0 downto 0);
    signal probe15_i                    : std_logic_vector(0 downto 0);    
    signal probe16_i                    : std_logic_vector(255 downto 0);  
    signal probe17_i                    : std_logic_vector(4 downto 0);
    signal probe18_i                    : std_logic_vector(0 downto 0);
    signal probe19_i                    : std_logic_vector(0 downto 0);
    signal probe20_i                    : std_logic_vector(0 downto 0);
    signal probe21_i                    : std_logic_vector(0 downto 0);
    signal probe22_i                    : std_logic_vector(0 downto 0);
    signal probe23_i                    : std_logic_vector(0 downto 0);
    signal probe24_i                    : std_logic_vector(0 downto 0);
    signal probe25_i                    : std_logic_vector(0 downto 0);    
    signal probe26_i                    : std_logic_vector(0 downto 0);  
    signal probe27_i                    : std_logic_vector(0 downto 0);
    signal probe28_i                    : std_logic_vector(9 downto 0);
    signal probe29_i                    : std_logic_vector(9 downto 0); 
    signal probe30_i                    : std_logic_vector(1 downto 0);    
    signal probe0_l                     : std_logic_vector(0 downto 0);
    signal probe1_l                     : std_logic_vector(0 downto 0);
    signal probe2_l                     : std_logic_vector(0 downto 0);
    signal probe3_l                     : std_logic_vector(0 downto 0);
    signal probe4_l                     : std_logic_vector(255 downto 0);
    signal probe0_j                     : std_logic_vector(0 downto 0);  
	signal probe1_j                     : std_logic_vector(31 downto 0); 
	signal probe2_j                     : std_logic_vector(15 downto 0); 
	signal probe3_j                     : std_logic_vector(0 downto 0);  
	signal probe4_j                     : std_logic_vector(31 downto 0); 
	signal probe5_j                     : std_logic_vector(0 downto 0); 
	signal probe6_j                     : std_logic_vector(0 downto 0); 
	signal probe7_j                     : std_logic_vector(31 downto 0); 
	signal probe8_j                     : std_logic_vector(31 downto 0); 
	signal probe9_j                     : std_logic_vector(31 downto 0); 
	signal probe10_j                    : std_logic_vector(31 downto 0); 
	signal probe11_j                    : std_logic_vector(0 downto 0); 
	signal probe12_j                    : std_logic_vector(0 downto 0); 
	signal probe13_j                    : std_logic_vector(0 downto 0); 
	signal probe14_j                    : std_logic_vector(0 downto 0);
	   
    signal pcie_rdy_i_d                 : std_logic;   
    signal fifo_read_valid              : std_logic;
    signal fifo_underflow               : std_logic;
    signal fifo_read_en                 : std_logic;
    signal REG1_RDA_i                   : std_logic_vector(31 downto 0);
    signal REG1_AC_i                    : std_logic;
    signal REG1_RDAV_i                  : std_logic;
    signal us1                          : std_logic:= '1';
    signal reset_trig                   : std_logic:= '0';
    signal reset_trig_d1                : std_logic:= '0';
    signal reset_trig_d2                : std_logic:= '0';
    signal reset_trig_d3                : std_logic:= '0';
    signal reset_trig_d4                : std_logic:= '0';
    signal reset_trig_d5                : std_logic:= '0';
    signal reset_trig_d6                : std_logic:= '0';
    signal wr_ack                       : std_logic:= '0';
    signal ena_pcie_ctl_p               : std_logic;
    signal fifo_read_valid_delay        : std_logic_vector(20 downto 0);
    signal command_mode                 : std_logic;
    signal command_mode_P               : std_logic;
    signal command_mode_P2              : std_logic;
    signal command_flag                 : std_logic;
    signal command_flag_p1              : std_logic;
    signal command_flag_p2              : std_logic;
    signal command_flag_p3              : std_logic;
    signal command_flag_p4              : std_logic;
    signal command_flag_p5              : std_logic;
    signal data_mode                    : std_logic;
    signal read_fifo_count              : std_logic_vector(9 downto 0);
    signal write_fifo_count             : std_logic_vector(9 downto 0);
    signal PCIE_LENGTH_FIFO             : std_logic_vector(9 downto 0);
    signal data_counter                 : std_logic_vector(9 downto 0);
    signal write_fifo_complete          : std_logic;
    signal send_data_to_host            : std_logic; 
    signal last_data_word               : std_logic;
    signal first                        : std_logic;
    signal send_req_data_to_host        : std_logic;    
    signal write_fifo_complete_extended : std_logic;
    signal write_fifo_complete_meta     : std_logic;
    signal write_fifo_complete_d        : std_logic;
    signal write_fifo_complete_d_P      : std_logic;
    signal fifo_has_data                : std_logic;
    signal PCIE_RD_RESP_DATA_LAST_P     : std_logic;
    signal send_rsp_to_host             : std_logic;
    signal send_command_to_host         : std_logic;
    signal send_command_to_host_P       : std_logic; 
   
                         
begin
-----------------------------------------------------
--signal port map
-----------------------------------------------------
--test
    h2c_cmd_t                      <= h2c_cmd;
    c2h_cmd_t                      <= c2h_cmd;
    pcie_wr_data_wrs_t             <= pcie_wr_data_wrs_i;
    pcie_wr_ctl_wrs_t              <= pcie_wr_ctl_wrs_i;
    
--NOC
    ena_pcie_data_i                <= ENA_PCIE_DATA;
    CMD_FLAG                       <= pcie_cmd_flag_i;  --PCIE_CMD_FLAG, use this when the command is written to read buffer
    PCIE_RDY                       <= pcie_rdy_i_d;     --pcie_rdy_i;
    PCIE_ACK                       <= pcie_ack_i;
    pcie_req_i                     <= PCIE_REQ;
    noc_rst_i                      <= NOC_RST;
    NOC_DATA                       <= noc_data_i;
    pcie_data_i                    <= PCIE_DATA;
--PCIe
    clk                            <= REF_CLK;
    PCIE_REQ_IF_CLK_O              <= pcie_req_if_clk_o_int; 
    PCIE_WR_REQ_CTRL_WRS           <= pcie_wr_ctl_wrs_i;    --ENA_PCIE_CTL and RW_FLAG;  
    PCIE_WR_REQ_CTRL_LENGTH        <= pcie_len_i;           --PCIE_LENGTH(4 downto 0);   
    PCIE_WR_REQ_CTRL_START_ADDR    <= down_address;              
    PCIE_WR_REQ_DATA_WRS           <= pcie_wr_data_wrs_i;   --ENA_PCIE_DATA and RW_FLAG;
    PCIE_WR_REQ_DATA               <= pcie_wr_req_data_i;
    PCIE_RD_REQ_WRS                <= pcie_rd_wrs_i;        --ENA_PCIE_CTL and not RW_FLAG;
    PCIE_RD_REQ_START_ADDR         <= up_address;                   
    PCIE_RD_REQ_LENGTH             <= pcie_len_i;      
    fifo_data_i                    <= PCIE_RD_RESP_DATA;    --PCIE_RD_RESP_DATA_pre
    pcie_req_if_clk_o_int          <= REF_CLK;
--Read buffer
    wr_clk_rb                      <= PCIE_RSP_IF_CLK_I;
    rd_clk_rb                      <= REF_CLK;
    reset_rb                       <= reset_trig or reset_trig_d1 or reset_trig_d2; -- in datasheet of fifo it is mentioned that reset needs to be held at least 3 clk cycle of slowest clock --reset;    --reset_d or reset_d2; --PCIE_RSP_IF_RST_I;
    din_rb                         <= fifo_data_i;
    wr_en_rb                       <= PCIE_RD_RESP_DATA_VLD; -- or PCIE_RD_RESP_DATA_VLD_d1;  --PCIE_RD_RESP_DATA_FIRST; --PCIE_RD_RESP_DATA_VLD(it is one for 2 clock) This is valid for writing a command to the fifo, but later for writing data in the fifo it needs to be PCIE_RD_RESP_DATA_VLD 
    rd_en_rb                       <= fifo_read_en; --wr_ack_delay(12); -- and not wr_ack_delay(13) and not wr_ack_delay(14); --ena_pcie_data_i and not rw_flag;  --???
    
    REG1_USER_CLK                  <= clk; --REG1_REF_CLK;
    REG1_RDA                       <= REG1_RDA_i;
    REG1_AC                        <= REG1_AC_i;
    REG1_RDAV                      <= REG1_RDAV_i;
    REG1_USER_RST                  <= '0';
    
    reset_out                      <= reset;
    PCIE_REQ_IF_RST_O              <= '0'; 
    
--    PCIE_LENGTH_FIFO               <= "0000" & (PCIE_LENGTH + 1) & '0';

    process(clk)
    begin
        if rising_edge(clk) then
            PCIE_LENGTH_FIFO               <= "0000" & (PCIE_LENGTH + 1) & '0';
          end if;
    end process;           
                    
--    pcie_rdy_i <= PCIE_RD_RESP_DATA_VLD and PCIE_RD_RESP_DATA_LAST;
    pcie_ack_i <= PCIe_req and (not PCIE_WR_REQ_DATA_AFU) and (not PCIE_WR_REQ_CTRL_AFU);  --ack and (not PCIE_WR_REQ_DATA_AFU) and (not almost_full_wb);
  
    process(PCIE_RSP_IF_CLK_I)
    begin
        if rising_edge(PCIE_RSP_IF_CLK_I) then  
            PCIE_RD_RESP_DATA_LAST_P    <= PCIE_RD_RESP_DATA_LAST;
        end if;
    end process;
    
    write_fifo_complete_extended        <= PCIE_RD_RESP_DATA_LAST or PCIE_RD_RESP_DATA_LAST_P; 
    
    process(clk)
    begin
        if rising_edge(clk) then
            write_fifo_complete_meta     <= write_fifo_complete_extended;
            write_fifo_complete_d        <= write_fifo_complete_meta;
            write_fifo_complete_d_P      <= write_fifo_complete_d;
        end if;
    end process;                      
          
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                fifo_read_valid_delay  <= (others => '0');
            else   
                fifo_read_valid_delay(20 downto 1)  <= fifo_read_valid_delay(19 downto 0);
                fifo_read_valid_delay(0)            <= fifo_read_valid;
            end if;
        end if;
    end process;         
        
--Config and status interface
    addr_reg : process(clk) --reg1_ref_clk)
    begin
        if rising_edge(clk) then --(reg1_ref_clk) then
            if reg1_wea = '1' then 
                if reg1_ada = x"0000" then
                    h2c_addr_h <= reg1_wda;     --Address that host stores commands. NOC will fetch the commands from this address in host's RAM
                elsif reg1_ada = x"0001" then --0004
                    h2c_addr_l <= reg1_wda;
                elsif reg1_ada = x"0002" then --0008
                    c2h_addr_h <= reg1_wda;     --1. NOC send a feedback signal to inform host that it will send a c2h_cmd to host.
                                                --2. Host detect the feedback signal and generate the RAM address that the c2h_cmd is going to be stored
                                                --3. Host write the address to c2h_addr_h&l regs.
                                                --4. NOC start the transfer through PCIe interface.
                elsif reg1_ada = x"0003" then  --000c
                    c2h_addr_l <= reg1_wda;
                end if;
            end if;
        end if;
    end process;
    
    ctrl_reg: process(clk) --(reg1_ref_clk)
    begin
        if rising_edge(clk) then --reg1_ref_clk) then
        
            reset_trig_d1   <= reset_trig;
            reset_trig_d2   <= reset_trig_d1;
            reset_trig_d3   <= reset_trig_d2;
            reset_trig_d4   <= reset_trig_d3;
            reset_trig_d5   <= reset_trig_d4;
            reset_trig_d6   <= reset_trig_d5;           
            reset           <= reset_trig and not (reset_trig_d1 or reset_trig_d2 or reset_trig_d3 or reset_trig_d4 or reset_trig_d5 or reset_trig_d6); 
                                    
            if NOC_CMD_FLAG = '1' then
            --if pcie_wr_ctl_wrs_i = '1' then
                c2h_cmd             <= '1';
            end if;       
         
            if reset = '1' then
                h2c_cmd             <= '0'; 
                c2h_cmd             <= '0'; 
            else
                if reg1_wea = '1' and reg1_ada = x"0004" then  --0010
                    h2c_cmd         <= reg1_wda(0);                --ctrl register bit 0, for command
                    ack             <= reg1_wda(1);                --ctrl register bit 1, for acknowledgement
                    reset_trig      <= reg1_wda(2);                --ctrl register bit 2, for reset
                else
                    if ena_pcie_data_i = '1' then
                        h2c_cmd     <= '0';
                    end if;    
                    reset_trig      <= '0';
                end if;
                if reg1_wea = '1' and reg1_ada = x"0005" then  --0014
                    c2h_cmd         <= reg1_wda(0);
                end if;    
            end if;
        end if;        
    end process;


    status_reg: process(clk) --(reg1_ref_clk)
    begin
        if rising_edge(clk) then --(reg1_ref_clk) then
            if REG1_REA = '1' then
                if reg1_ada = x"0000" then      --0000
                    REG1_RDA_i <= h2c_addr_h;
                elsif reg1_ada = x"0001" then   --0004
                    REG1_RDA_i <= h2c_addr_l;
                elsif reg1_ada = x"0002" then   --0008
                    REG1_RDA_i <= c2h_addr_h;
                elsif reg1_ada = x"0003" then   --000C
                    REG1_RDA_i <= c2h_addr_l;
                elsif reg1_ada = x"0004" then   --0010
                    REG1_RDA_i(0) <= h2c_cmd;
                    REG1_RDA_i(1) <= ack;
                    REG1_RDA_i(2) <= reset;
                    REG1_RDA_i(31 downto 3) <= "00000000000000000000000000000";
                elsif reg1_ada = x"0005" then   --0014
                    REG1_RDA_i(0) <= c2h_cmd;  
                    REG1_RDA_i(1) <= pcie_req_i; 
                    REG1_RDA_i(31 downto 2) <= "000000000000000000000000000000";                          
                end if;
            end if;
        end if;
    end process;                   
    
    process(clk)
    begin
        if rising_edge(clk) then
            REG1_AC_i   <= REG1_REA or REG1_WEA;
            REG1_RDAV_i <= REG1_REA;
        end if;
    end process; 
                         
    noc_data_1 : process(clk,tr_case,fifo_read_valid,reset)
    begin
        if rising_edge(clk) then
            tr_case_p           <= tr_case;
            if reset = '1' then
                noc_data_i      <= (others=> '0');
            elsif fifo_read_valid = '1' then
                if tr_case = "00" then                          --command is read from fifo
                    if fifo_read_valid = '1' and fifo_read_valid_delay(0) = '0' then 
                        noc_data_i  <= dout_rb;
                    end if;    
                elsif tr_case = "01" and tr_case_p = "01" then  --data is read from fifo
                    noc_data_i  <= dout_rb;
                end if;       
            end if;    
        end if;
    end process; 
    
    noc_cmd_l : process(clk,tr_case,fifo_read_valid,reset)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                noc_cmd_reg     <= (others=> '0');
            elsif tr_case = "00" then 
                if fifo_read_valid = '1' and fifo_read_valid_delay(0) = '0' then
                    noc_cmd_reg <= dout_rb;
                end if;     
            end if;
        end if;    
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            command_flag_p1     <= command_flag;
            command_flag_p2     <= command_flag_p1;
            command_flag_p3     <= command_flag_p2;
            command_flag_p4     <= command_flag_p3;
            command_flag_p5     <= command_flag_p4;
            command_mode_P      <= command_mode;
            command_mode_P2     <= command_mode_P;
        end if;
    end process;            

-----------------------------------------------------
--User cases
-----------------------------------------------------
    u_case : process(clk,tr_case,reset)
    --variable us1 : boolean:= true; 
    begin
        if rising_edge(clk) then                              
            --RESET
            if reset = '1' then --or noc_rst_i = '1' then ???
                up_address        <= (others=>'0');
                down_address      <=(others => '0');
                pcie_rd_wrs_i     <= '0';
                pcie_len_i        <= (others => '0');
                us1               <= '1';
                pcie_cmd_flag_i   <= '0';
                pcie_wr_req_data_i<= (others => '0');
                pcie_rdy_i_d      <= '0';          
                pcie_wr_data_wrs_i<= '0'; 
                pcie_wr_ctl_wrs_i <= '0';
                command_mode      <= '0';
                command_flag      <= '0';
                data_mode         <= '0';
                send_rsp_to_host  <= '0';
                send_command_to_host<= '0';
                send_command_to_host_P<= '0'; 
                last_data_word    <= '0'; 
                data_counter      <= (others => '0');
                first             <= '0'; 
                fifo_has_data     <= '0';
            else
                ena_pcie_ctl_p          <= ena_pcie_ctl;
                pcie_cmd_flag_i         <= command_flag or command_flag_p1 or command_flag_p2 or command_flag_p3 or command_flag_p4 or command_flag_p5; --fifo_read_valid_delay(0) or fifo_read_valid_delay(1) or fifo_read_valid_delay(2) or fifo_read_valid_delay(3) or fifo_read_valid_delay(4);
                empty_rb_P              <= empty_rb;
                send_command_to_host_P  <= send_command_to_host;
                
                if command_mode_P = '0' and command_mode_P2 = '1' then 
                    command_flag    <= '0';
                    fifo_read_en    <= '0';
                end if;    
                
                if command_mode = '1' then 
                    if not(empty_rb) = '1' then
                        fifo_read_en    <= '1';
                        command_flag    <= '1';
                        command_mode    <= '0';
                        first           <= '1';
                    end if;    
                elsif data_mode = '1' then
                    if write_fifo_complete_d = '0' and write_fifo_complete_d_P = '1' then --and not(empty_rb) = '1' then  -- When write_fifo_complete_d deasserts then after one clock empty_rb goes low.
                        fifo_has_data   <= '1';
                    end if;    
                    if fifo_has_data = '1' then 
                        if empty_rb = '0' then  
                            fifo_read_en    <= ena_pcie_data_i;   --'1';      --it reads fifo when NOC sets en_pcie_data to '1'
                            pcie_rdy_i_d    <= '1';
                         elsif empty_rb = '1' and empty_rb_P = '0' then
                            fifo_read_en    <= '0';
                            pcie_rdy_i_d    <= '0';
                            fifo_has_data   <= '0'; 
                         elsif empty_rb = '1' then
                            fifo_read_en    <= '0';
                            pcie_rdy_i_d    <= '0';                                     
                         end if;
                    end if;                                                     
                end if;               

                if tr_case = "00" then
                --User case 1         Command from host to cluster
                    if h2c_cmd = '1' then
                        up_address <= h2c_addr_h & h2c_addr_l(31 downto 6);
                        pcie_len_i <= (others => '0');
                        pcie_rd_wrs_i <= '0';
                        if us1 = '1' then
                            pcie_rd_wrs_i <= '1'; 
                            us1           <= '0';
                            command_mode  <= '1';
                        end if;                  
                    elsif h2c_cmd = '0' then        
                        us1 <= '1';         --default value ready for next command
                    end if;
                --User case 2        Command from cluster to host
                    if ena_pcie_ctl = '1' then
                        down_address        <= c2h_addr_h & c2h_addr_l(31 downto 6);
                        pcie_len_i          <= (others => '0');
                        pcie_wr_data_wrs_i  <= ena_pcie_data_i; 
                        pcie_wr_req_data_i  <= pcie_data_i;
                    elsif ena_pcie_ctl_p = '1' then
                        pcie_wr_ctl_wrs_i   <= rw_flag;
                        pcie_wr_data_wrs_i  <= '1';
                    else
                        down_address        <= (others => '0');
                        pcie_wr_data_wrs_i  <= '0';
                        pcie_wr_ctl_wrs_i   <= '0';
                        pcie_wr_req_data_i  <= (others => '0');                         
                    end if;
                    
                --User case 3    DDR to ...
                elsif tr_case = "01" then
                    if first = '1' then
                        send_req_data_to_host   <= '1';
                        first                   <= '0';
                    end if;
                    if send_req_data_to_host = '1' then      --send data request to host
                        command_mode    <= '0';
                        data_mode       <= '1';
                        up_address      <= x"00000000" & PCIE_ADDRESS(31 downto 6);
                        pcie_len_i      <= PCIE_LENGTH;
                        pcie_rd_wrs_i   <= ena_pcie_ctl and not rw_flag;
                        if pcie_ack_i = '1' then
                            send_rsp_to_host        <= '1';
                            send_req_data_to_host   <= '0';
                        end if;
                    elsif send_rsp_to_host = '1' then       --send Noc ready to host
                        data_mode   <= '0';         
                        if ena_pcie_ctl = '1' and ena_pcie_data_i = '1' then      
                            down_address        <= c2h_addr_h & c2h_addr_l(31 downto 6);
                            pcie_len_i          <= (others => '0');
                            pcie_wr_data_wrs_i  <= ena_pcie_data_i; 
                            pcie_wr_req_data_i  <= pcie_data_i;                    
                        elsif ena_pcie_ctl_p = '1' then
                            pcie_wr_ctl_wrs_i   <= rw_flag;
                            pcie_wr_data_wrs_i  <= '1';
                            send_rsp_to_host    <= '0';                                          
                        end if;
                    else
                        down_address        <= (others => '0');
                        pcie_wr_data_wrs_i  <= '0';
                        pcie_wr_ctl_wrs_i   <= '0';
                        pcie_wr_req_data_i  <= (others => '0');                       
                    end if;    
                       
                --User case 4  ... to DDR
                elsif tr_case = "10" then
                    command_mode        <= '0';
                    if pcie_ack_i = '1' and send_command_to_host = '0' then
                        send_data_to_host<= '1';
                    end if;    
                    
                    --send data to host
                    if send_data_to_host = '1' then
                        if ena_pcie_data_i = '1' then 
                            if data_counter < PCIE_LENGTH_FIFO - '1' then
                                data_counter  <= data_counter + '1';
                            elsif data_counter = PCIE_LENGTH_FIFO - '1' then
                                last_data_word      <= '1';
                                pcie_wr_ctl_wrs_i   <= '1';
                            end if; 
                        end if; 
                               
                        down_address        <= x"00000000" & PCIE_ADDRESS(31 downto 6);
                        pcie_len_i          <= PCIE_LENGTH;
                        pcie_wr_data_wrs_i  <= ena_pcie_data_i and rw_flag;
                        pcie_wr_req_data_i  <= pcie_data_i;
                        if last_data_word = '1' then
                            send_command_to_host<= '1';
                            send_data_to_host   <= '0';
                            last_data_word      <= '0';
                            data_counter        <= (others => '0');
                            down_address        <= (others => '0');
                            pcie_wr_data_wrs_i  <= '0';
                            pcie_wr_ctl_wrs_i   <= '0';
                            pcie_wr_req_data_i  <= (others => '0');                          
                        end if;    
                    end if;
                    
                    --send Noc ready to host
                    if pcie_ack_i = '1' and send_command_to_host = '1' then
                        if ena_pcie_ctl = '1' and ena_pcie_data_i = '1' then
                            down_address        <= c2h_addr_h & c2h_addr_l(31 downto 6);
                            pcie_len_i          <= (others => '0');
                            pcie_wr_data_wrs_i  <= ena_pcie_data_i; 
                            pcie_wr_req_data_i  <= pcie_data_i;                    
                        elsif ena_pcie_ctl_p = '1' then
                            pcie_wr_ctl_wrs_i   <= rw_flag;
                            pcie_wr_data_wrs_i  <= '1';
                            send_command_to_host<= '0';
                        end if;    
                    elsif send_command_to_host = '0' and send_command_to_host_P = '1' then
                        down_address        <= (others => '0');
                        pcie_wr_data_wrs_i  <= '0';
                        pcie_wr_ctl_wrs_i   <= '0';
                        pcie_wr_req_data_i  <= (others => '0');                            
                    end if;                        
                end if;  --tr_case
            end if;  --end of reset
        end if;      --end of clk
    end process;
    
-----------------------------------------------------
--NOC state machine
-----------------------------------------------------         

    transfer : process (noc_cmd_reg)
    begin
        case noc_cmd_reg(11 downto 0) is
            when x"000" =>
            tr_mod <= 0;
            when x"010" =>  --MOVE_DDR_MUX_RM
            tr_mod <= 1;
            when x"012" =>
            tr_mod <= 2;
            when x"014" =>  --MOVE_DDR_MUX_CM_UNI
            tr_mod <= 3;
            when x"016" =>  --MOVE_DDR_MUX_CM_BRO
            tr_mod <= 4;
            when x"018" =>
            tr_mod <= 5;
            when x"01a" =>  --MOVE_RM_MUX_DDR
            tr_mod <= 6;
            when x"01c" =>
            tr_mod <= 7;
            when x"01e" =>  --MOVE_RM_CM_UNI
            tr_mod <= 8;
            when x"020" =>  --MOVE_RM_CM_BRO
            tr_mod <= 9;
            when x"022" =>  --MOVE_RM_PM
            tr_mod <= 10;
            when x"024" =>  --MOVE_CM_MUX_DDR
            tr_mod <= 11;
            when x"026" =>
            tr_mod <= 12;
            when x"028" =>  --MOVE_CM_RM
            tr_mod <= 13;
            when x"02a" =>  --MOVE_PM_RM 
            tr_mod <= 14;
            when x"02c" =>  --EXECUTE
            tr_mod <= 15;
            when x"02e" =>  --CONTINUE
            tr_mod <= 16;
            when others =>
            tr_mod <= 17;
        end case;
    end process;

    tr_act: process(tr_mod)
    begin
        if tr_mod = 1 or tr_mod = 3 or tr_mod = 4 then
            tr_case <= "01";  --DDR to RM or CM
        elsif tr_mod = 6 or tr_mod = 10 or tr_mod = 11 or tr_mod = 14 then
            tr_case <= "10";  --RM to DDR,RM to PM,CM to DDR,PM to RM
        else
            tr_case <= "00";
        end if;
    end process;
    
    probe0_j(0)           <= REG1_WEA;
    probe1_j(31 downto 0) <= REG1_WDA;
    probe2_j(15 downto 0) <= REG1_ADA;
    probe3_j(0)           <= REG1_REA;
    probe4_j(31 downto 0) <= REG1_RDA_i;
    probe5_j(0)           <= REG1_RDAV_i;
    probe6_j(0)           <= REG1_AC_i;
    probe7_j(31 downto 0) <= h2c_addr_h;
    probe8_j(31 downto 0) <= h2c_addr_l;
    probe9_j(31 downto 0) <= c2h_addr_h;
    probe10_j(31 downto 0)<= c2h_addr_l;
    probe11_j(0)          <= h2c_cmd;
    probe12_j(0)          <= ack;    
    probe13_j(0)          <= reset_trig;
    probe14_j(0)          <= c2h_cmd;

    probe0_i(255 downto 0)<= pcie_wr_req_data_i;      
    probe1_i(57 downto 0) <= noc_data_i(57 downto 0);   --down_address    --58  PCIE_RD_REQ_START_ADDR 
    probe2_i(0)           <= NOC_CMD_FLAG;  --us1;                           	
    probe3_i(0)           <= ena_pcie_ctl;                             
    probe4_i(0)           <= empty_rb;                   
    probe5_i(0)           <= write_fifo_complete_d;
    probe6_i(0)           <= c2h_cmd;                           
    probe7_i(0)           <= ena_pcie_data_i;
    probe8_i(0)           <= pcie_wr_data_wrs_i;       
    probe9_i(0)           <= pcie_wr_ctl_wrs_i;       
    probe10_i(0)          <= pcie_cmd_flag_i;         
    probe11_i(0)          <= fifo_read_valid;          
    probe12_i(0)          <= send_req_data_to_host;            
    probe13_i(0)          <= PCIE_WR_REQ_DATA_AFU;    
    probe14_i(0)          <= pcie_ack_i;
    probe15_i(0)          <= pcie_rd_wrs_i;             
    probe16_i(255 downto 0)<= pcie_data_i; --dout_rb; 
    probe17_i(4 downto 0) <= noc_cmd_reg(4 downto 0);   --pcie_len_i;
    probe18_i(0)          <= h2c_cmd;                   
    probe19_i(0)          <= pcie_rdy_i_d;
    probe20_i(0)          <= last_data_word;
    probe21_i(0)          <= send_command_to_host;
    probe22_i(0)          <= send_data_to_host;
    probe23_i(0)          <= command_mode;
    probe24_i(0)          <= command_flag;
    probe25_i(0)          <= data_mode;
    probe26_i(0)          <= fifo_read_en;
    probe27_i(0)          <= send_rsp_to_host;
    probe28_i(9 downto 0) <= data_counter;
    probe29_i(9 downto 0) <= PCIE_LENGTH_FIFO; 
    probe30_i(1 downto 0) <= tr_case; 
            
    probe0_l(0)           <= PCIE_RD_RESP_DATA_VLD;
    probe1_l(0)           <= PCIE_RD_RESP_DATA_FIRST;     
    probe2_l(0)           <= wr_ack; 
    probe3_l(0)           <= PCIE_RD_RESP_DATA_LAST;
    probe4_l(255 downto 0)<= PCIE_RD_RESP_DATA;

  
  rd_buffer : fifo_generator_1
  port map (
    rst             => reset_rb,
    wr_clk          => wr_clk_rb,
    rd_clk          => rd_clk_rb,
    din             => din_rb,
    wr_en           => wr_en_rb,
    rd_en           => rd_en_rb,
    dout            => dout_rb,
    full            => full_rb,
    wr_ack          => wr_ack,
    empty           => empty_rb,
    valid           => fifo_read_valid,
    underflow       => fifo_underflow,
    rd_data_count   => read_fifo_count,
    wr_data_count   => write_fifo_count,
    wr_rst_busy     => wr_rst_busy_rb,
    rd_rst_busy     => rd_rst_busy_rb
  );
    
  ILA_PCIE : ila_3
  port map (
	clk        => clk,
	probe0     => probe0_i, 
	probe1     => probe1_i, 
	probe2     => probe2_i, 
	probe3     => probe3_i, 
	probe4     => probe4_i, 
	probe5     => probe5_i, 
	probe6     => probe6_i, 
	probe7     => probe7_i, 
	probe8     => probe8_i, 
	probe9     => probe9_i, 
	probe10    => probe10_i,
	probe11    => probe11_i,
	probe12    => probe12_i,
	probe13    => probe13_i,
	probe14    => probe14_i,
	probe15    => probe15_i,
	probe16    => probe16_i,
	probe17    => probe17_i,
	probe18    => probe18_i,
	probe19    => probe19_i,
	probe20    => probe20_i,
	probe21    => probe21_i,
	probe22    => probe22_i,
	probe23    => probe23_i,
	probe24    => probe24_i,
	probe25    => probe25_i,
	probe26    => probe26_i,
	probe27    => probe27_i,
	probe28    => probe28_i,
	probe29    => probe29_i,
	probe30    => probe30_i			
);

  ILA_REG : ila_5
  port map (
	clk => clk,
	probe0     => probe0_j, 
	probe1     => probe1_j, 
    probe2     => probe2_j, 
	probe3     => probe3_j, 
	probe4     => probe4_j, 
	probe5     => probe5_j, 
	probe6     => probe6_j, 
	probe7     => probe7_j, 
	probe8     => probe8_j, 
	probe9     => probe9_j, 
	probe10    => probe10_j, 
	probe11    => probe11_j, 
	probe12    => probe12_j, 
	probe13    => probe13_j,
	probe14    => probe14_j
);

  ILA_PCIE_RESP : ila_4
  port map (
	clk        => PCIE_RSP_IF_CLK_I,
	probe0     => probe0_l, 
	probe1     => probe1_l, 
	probe2     => probe2_l, 
	probe3     => probe3_l,
	probe4     => probe4_l
);
   
end architecture rtl;