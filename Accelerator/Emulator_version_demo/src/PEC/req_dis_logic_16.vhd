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
-- Title      : req_logic
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : Req_logic.vhd
-- Author     : Chuhang Jin
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: Request buffer logic and data distribution network
--              
--              
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2020-10-21  		     1.0	     CJ			Created
-- 2020-11-15            2.0         CJ         Distribution network added
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cluster_pkg.all;

entity req_dst_logic is
    port(
        --Shared
        CLK_P     : in std_logic;
        CLK_E     : in std_logic;   --Generated by PE pair 1 
        CLK_E_NEG     : in std_logic;
        RESET     : in std_logic;
        --Requet logic
        REQ_TO_NOC : out std_logic;
        REQ_SIG   : in std_logic_vector(15 downto 0);
        ACK_SIG   : out std_logic_vector(15 downto 0);
        PE_REQ_IN    : in pe_req; -- pe_req(0) is the last PE (PE 64)
        OUTPUT    : out std_logic_vector(31 downto 0);
        RD_FIFO   : in std_logic;
        FIFO_VLD  : out std_logic;
        FOUR_WD_LEFT : out std_logic;
        --Distribution network
        DATA_NOC  : in std_logic_vector(127 downto 0);
        PE_UNIT   : in std_logic_vector(3 downto 0);
        B_CAST    : in std_logic;
        DATA_OUT  : out pe_data
    
    );
end entity req_dst_logic;

architecture rtl of req_dst_logic is
COMPONENT fifo_generator_0
    PORT (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full : OUT STD_LOGIC;
    almost_full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    almost_empty : OUT STD_LOGIC;
    prog_empty : OUT STD_LOGIC;
    valid      : OUT STD_LOGIC;
    data_count : OUT STD_LOGIC_VECTOR(9 downto 0)
  );
END COMPONENT;
    --type pe_req_in is array (63 downto 0) of std_logic_vector(25 downto 0);
    signal id_num   : std_logic_vector(3 downto 0):="0000";
    signal poll_act : std_logic;
    signal fifo_rdy : std_logic; --active low
    signal add_in_1 : std_logic_vector(3 downto 0);
    signal add_in_2 : std_logic_vector(3 downto 0):="0000";
    signal add_out  : std_logic_vector(3 downto 0);
    signal bs_out   : std_logic_vector(15 downto 0);
    signal pe_mux_out : std_logic_vector(31 downto 0);
    signal req_core  :  std_logic_vector(31 downto 0);
    signal wr      : std_logic;
    signal rd      : std_logic;
    signal full    : std_logic;
    signal almost_full : std_logic;
    signal empty   : std_logic;
    signal almost_empty : std_logic;
    signal wr_req  : std_logic;
    signal ack_sig_i :std_logic_vector(15 downto 0); --Will be replaced with a DTM fifo signal.
    signal loop_c  : integer := 0;
    signal chain   : std_logic;
    signal data_in_fifo : std_logic_vector(9 downto 0);


begin
    --Recognize the write request and hold the wr_req signal for 4 clock cycles.
    process(clk_p)
    begin
        if rising_edge(clk_p) and clk_e_neg = '0' then
            if loop_c = 0 then
                if PE_REQ_IN(to_integer(unsigned(id_num)))(31)= '1' and PE_REQ_IN(to_integer(unsigned(id_num)))(30) = '1' then
                    wr_req <= '1';
                    loop_c <= 1;
                else
                    if PE_REQ_IN(to_integer(unsigned(id_num)))(29)= '1' then
                        chain<= '1';
                    else
                        chain <= '0';
                    end if;
                    wr_req <= '0';
                    loop_c <= 0;
                end if;
            elsif loop_c = 4 then
                wr_req <= '0';
                loop_c <= 0;
            else
                loop_c <= loop_c + 1;
            end if;
        end if;
    end process;
            

-------------------------------------------------------------
--Polling mechanism
-------------------------------------------------------------
--Activation 
process (clk_p, fifo_rdy, req_sig)
begin
    if reset = '1' then
            poll_act <= '0'; 
    elsif fifo_rdy='0' and req_sig /= (req_sig'range => '0') then 
            poll_act <= '1'; 
    else
            poll_act <= '0';
    end if;
end process;

process(clk_p,req_sig)
begin 
        if req_sig /= (req_sig'range => '0') then
        REQ_TO_NOC <= '1';
        else
        REQ_TO_NOC <= '0';
        end if;
end process;
--ID Number Register and write controller
process(poll_act,clk_p)
begin
    if rising_edge(clk_p) and clk_e_neg = '0' then
        if poll_act = '1' then
            ack_sig_i <= (others =>'0');
            ack_sig_i(to_integer(unsigned(id_num))) <= '1';
        else
            ack_sig_i <= (others =>'0');
        end if;
    end if;
end process;
ack_sig <= ack_sig_i;

--Barrel Shifter

process(poll_act,req_sig)
variable sh_0, sh_1, sh_2, sh_3 : std_logic_vector(15 downto 0);
begin
    if poll_act = '1' then
        
            if id_num(3) = '0' then
                sh_3 := req_sig;
            elsif id_num(3) = '1' then
                sh_3 := req_sig(7 downto 0) & req_sig(15 downto 8);
            end if;
        
            if id_num(2) = '0' then
                sh_2 := sh_3;
            elsif id_num(2) = '1' then
                sh_2 := sh_3(11 downto 0) & sh_3(15 downto 12);
            end if;
        
            if id_num(1) = '0' then
                sh_1 := sh_2;
            elsif id_num(1) = '1' then
                sh_1 := sh_2(13 downto 0) & sh_2(15 downto 14);
            end if;
        
            if id_num(0) = '0' then
                sh_0 := sh_1;
            elsif id_num(0) = '1' then
                sh_0 := sh_1(14 downto 0) & sh_1(15);
            end if;
    
            bs_out <= sh_0;

    end if;
end process;

--Priority Encoder 

process(req_sig, poll_act,bs_out)
variable cnt : integer := 0;
begin
    
        if poll_act = '1' then
            cnt := 0;
            for i in 15 downto 0 loop
                
                if bs_out(i) = '0'then
                    cnt := cnt+1;
                elsif bs_out(i) = '1' then
                    add_in_2 <= std_logic_vector(to_unsigned(cnt +1, 4)); --id"0001" is the first PE
                    
                    exit;
                end if;
            end loop;
        else 
            add_in_2 <= (others => '0');
        end if;
    
end process;

--Adder
add_in_1 <= id_num;
process(add_in_2,wr_req,chain)
begin

        if wr_req = '1' or chain = '1' then
            id_num <= add_in_1;
        else
            id_num<= std_logic_vector(to_unsigned(to_integer(unsigned(add_in_1))+to_integer(unsigned(add_in_2)),4));
        end if;
    
end process;

----------------------------------------------------------------
--Request Buffer
----------------------------------------------------------------
--PE Mux
process(clk_p)
begin
    if rising_edge(clk_p) and clk_e_neg = '0' then
        pe_mux_out <= PE_REQ_IN(to_integer(unsigned(id_num))); --PE req in comes the same clock cycle when req_sig is raised
    end if;
end process;

--Request FIFO

wr <= poll_act;
req_core <= pe_mux_out;
fifo_rdy <= almost_full and rd;
rd       <= RD_FIFO;

----------------------------------------------------------------
--Distribution network
----------------------------------------------------------------
--PE Demux
process(clk_e)  --Should internal destination listed here?
begin
    if B_CAST= '1' then
        for i in 15 downto 0 loop
            data_out (i)<= DATA_NOC;
        end loop;
    else 
        data_out(to_integer(unsigned(PE_UNIT))) <= DATA_NOC;
    end if;
end process;

request_fifo : fifo_generator_0
  PORT MAP (
    clk => clk_e,
    srst => reset,
    din => req_core,
    wr_en => wr,
    rd_en => rd,
    dout => output,
    full => full,
    almost_full => almost_full,
    empty => empty,
    almost_empty => almost_empty,
    prog_empty => FOUR_WD_LEFT,
    valid      => FIFO_VLD,
    data_count => data_in_fifo
  );
end architecture;