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
    prog_empty : OUT STD_LOGIC
  );
END COMPONENT;
    --type pe_req_in is array (63 downto 0) of std_logic_vector(25 downto 0);
    signal id_num   : std_logic_vector(5 downto 0):="000000";
    signal poll_act : std_logic;
    signal fifo_rdy : std_logic; --active low
    signal add_in_1 : std_logic_vector(5 downto 0);
    signal add_in_2 : std_logic_vector(5 downto 0):="000000";
    signal add_out  : std_logic_vector(5 downto 0);
    signal bs_out   : std_logic_vector(63 downto 0);
    signal pe_mux_out : std_logic_vector(31 downto 0);
    signal req_core  :  std_logic_vector(31 downto 0);
    signal wr      : std_logic;
    signal rd      : std_logic;
    signal full    : std_logic;
    signal almost_full : std_logic;
    signal empty   : std_logic;
    signal almost_empty : std_logic;
    signal wr_req  : std_logic;
    signal ack_sig_i :std_logic_vector(63 downto 0);
    signal loop_c  : integer := 0;


begin
    --Recognize the write request and hold the wr_req signal for 4 clock cycles.
    process(clk_e)
    --variable loop_c : integer:= 0;
    begin
        if rising_edge(clk_e) then
            loop_c <= loop_c + 1;
            if loop_c = 1 then
                if pe_mux_out(31)= '1' and pe_mux_out(30) = '1' then
                    wr_req <= '1';
                else 
                    wr_req <= '0';
                    loop_c <= 0;
                end if;
            elsif loop_c = 5 then
                wr_req <= '0';
                loop_c <= 0;
            end if;
        end if;
    end process;
            
    --Chain bit is going to be added
-------------------------------------------------------------
--Polling mechanism
-------------------------------------------------------------
--Activation 
process (clk_e, fifo_rdy, req_sig)
begin
    --if rising_edge(clk_e) then
    if reset = '1' then
            poll_act <= '0'; 
    elsif fifo_rdy='0' and req_sig /= (req_sig'range => '0') then 
            poll_act <= '1'; 
    else
            poll_act <= '0';
    end if;
    --end if;
end process;

process(clk_e,req_sig)
begin 
    --if rising_edge(clk_e) then
        if req_sig /= (req_sig'range => '0') then
        REQ_TO_NOC <= '1';
        else
        REQ_TO_NOC <= '0';
        end if;
    --end if;
end process;
--ID Number Register and write controller
process(poll_act,clk_e)
--variable num : integer := 0;
begin
    if rising_edge(clk_e) then
        if poll_act = '1' then
            ack_sig_i <= (others => '0');
            ack_sig_i(to_integer(unsigned(id_num))) <= '1';
            --req_core (5 downto 0) <= id_num;
            --id_num <= add_out;
            wr <= '1';
        else
            wr <= '0';
        end if;
    end if;
end process;
ack_sig <= ack_sig_i;
--Barrel Shifter

process(clk_e, id_num, req_sig, poll_act)
variable sh_0, sh_1, sh_2, sh_3, sh_4, sh_5 : std_logic_vector(63 downto 0);
begin
    if poll_act = '1' then
        if wr_req = '0' then
            if id_num(5) = '0' then
                sh_5 := req_sig;
            elsif id_num(5) = '1' then
                sh_5 := req_sig(31 downto 0) & req_sig(63 downto 32);
            end if;
        
            if id_num(4) = '0' then
                sh_4 := sh_5;
            elsif id_num(4) = '1' then
                sh_4 := sh_5(47 downto 0) & sh_5(63 downto 48);
            end if;
        
            if id_num(3) = '0' then
                sh_3 := sh_4;
            elsif id_num(3) = '1' then
                sh_3 := sh_4(55 downto 0) & sh_4(63 downto 56);
            end if;
        
            if id_num(2) = '0' then
                sh_2 := sh_3;
            elsif id_num(2) = '1' then
                sh_2 := sh_3(59 downto 0) & sh_3(63 downto 60);
            end if;
        
            if id_num(1) = '0' then
                sh_1 := sh_2;
            elsif id_num(1) = '1' then
                sh_1 := sh_2(61 downto 0) & sh_2(63 downto 62);
            end if;
        
            if id_num(0) = '0' then
                sh_0 := sh_1;
            elsif id_num(0) = '1' then
                sh_0 := sh_1(62 downto 0) & sh_1(63);
            end if;
    
            bs_out <= sh_0;
        elsif wr_req = '1' then
            bs_out <= (others =>'0');
        end if;
    end if;
end process;

--Priority Encoder 

process(clk_e,bs_out)
variable cnt : integer := 0;
--variable scop : std_logic := '0';
begin
    if poll_act = '1' and wr_req = '0'then
        cnt := 0;
        for i in 63 downto 0 loop
            --scop:= scop or bs_out(i);
            if bs_out(i) = '0'then
                cnt := cnt+1;
            elsif bs_out(i) = '1' then
                add_in_2 <= std_logic_vector(to_unsigned(cnt +1, 6));
                --scop := '0';
                exit;
            end if;
        end loop;
    else 
        add_in_2 <= (others => '0');
    end if;
end process;

--Adder

process(clk_e)
begin
    add_in_1 <= id_num;
    if rising_edge(clk_e) then
    --add_in_1 <= id_num;
    if wr_req = '0' then
        id_num<= std_logic_vector(to_unsigned(to_integer(unsigned(add_in_1))+to_integer(unsigned(add_in_2)),6));
    elsif wr_req = '1' then
        id_num <= add_in_1;
    end if;
    end if;
end process;

----------------------------------------------------------------
--Request Buffer
----------------------------------------------------------------
--PE Mux
process(ack_sig_i,id_num,loop_c)
begin
    --if rising_edge(clk_e) then
    if poll_act = '1' or wr_req = '1' then
    pe_mux_out <= PE_REQ_IN(to_integer(unsigned(id_num))); --PE req in comes the same clock cycle as req_sig is raised.
    end if;
end process;

--Request FIFO
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
        for i in 63 downto 0 loop
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
    prog_empty => FOUR_WD_LEFT
  );
end architecture;