----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2021 01:36:33 PM
-- Design Name: 
-- Module Name: Network_tb - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
use work.cluster_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Network_tb is
--  Port ( );
end Network_tb;

architecture Behavioral of Network_tb is
component req_dst_logic
port(        --Shared
        CLK_E     : in std_logic;
        RESET     : in std_logic;
        --Requet logic
        --REQ_CORE  : out std_logic_vector(31 downto 0);
        REQ_TO_NOC : out std_logic;
        REQ_SIG   : in std_logic_vector(63 downto 0);
        ACK_SIG   : out std_logic_vector(63 downto 0);
        PE_REQ_IN    : in pe_req;
        OUTPUT    : out std_logic_vector(31 downto 0);
        RD_FIFO   : in std_logic;
        FOUR_WD_LEFT : out std_logic;
        --DATA_CORE : in std_logic_vector(134 downto 0);
        --Distribution network
        DATA_NOC  : in std_logic_vector(127 downto 0);
        PE_UNIT   : in std_logic_vector(5 downto 0);
        B_CAST    : in std_logic;
        DATA_OUT  : out pe_data);
        end component;

signal clk_e_i        :  std_logic;
signal reset_i        :  std_logic;
signal req_to_noc_i   :  std_logic;
signal req_sig_i      :  std_logic_vector(63 downto 0);
signal ack_sig_i      :  std_logic_vector(63 downto 0);
signal pe_req_in_i    :  pe_req;
signal output_i       :  std_logic_vector(31 downto 0);
signal rd_fifo_i      :  std_logic;
signal four_wd_left_i :  std_logic;
signal data_noc_i     :  std_logic_vector(127 downto 0);
signal pe_unit_i      :  std_logic_vector(5 downto 0);
signal b_cast_i       :  std_logic;
signal data_out_i     :  pe_data;
begin

    process
    begin
        clk_e_i <= '1';
        wait for 30 ns;
        clk_e_i <= '0';
        wait for 30 ns;
    end process;
    
    process
    begin
    req_sig_i <= (others => '0');
    wait for 61 ns;
    req_sig_i <= (62 => '1', others => '0');
    --pe_req_in_i<=(3 => x"83456789", 0 => x"00001111",others => x"00000000");
    wait for 60 ns;
    req_sig_i <= (others => '0');
    pe_req_in_i<=(3 => x"83456789", 0 => x"00001111",others => x"00000000");
    --pe_req_in_i <=(others => (others => '0'));
    wait for 60 ns;
    req_sig_i <= (59=> '1',others => '0');
    --pe_req_in_i<=(5 => x"81111111", others => x"00000000");
    wait for 60 ns;
    req_sig_i <= (57 => '1', others => '0');
    pe_req_in_i<=(5 => x"81111111", others => x"00000000");
    wait for 60 ns;
    req_sig_i <= (others => '0' );
    wait for 1000ns;
    wait;
    end process;

req_dis_net : req_dst_logic
port map(
CLK_E           =>   clk_e_i,       
RESET           =>   reset_i,       
REQ_TO_NOC                =>   req_to_noc_i,  
REQ_SIG                   =>   req_sig_i,     
ACK_SIG                   =>   ack_sig_i,     
PE_REQ_IN                  =>   pe_req_in_i,   
OUTPUT                    =>   output_i,      
RD_FIFO                   =>   rd_fifo_i,     
FOUR_WD_LEFT               =>   four_wd_left_i,
DATA_NOC                =>   data_noc_i,    
PE_UNIT                 =>   pe_unit_i,     
B_CAST                  =>   b_cast_i,      
DATA_OUT                =>   data_out_i   
                  );
end Behavioral;
