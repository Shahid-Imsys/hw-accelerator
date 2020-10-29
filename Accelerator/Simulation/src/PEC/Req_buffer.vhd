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
-- Description: Request buffer logic
--              
--              
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2020-10-21  		     1.0	     CJ			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity req_logic is
    port(
        clk_p     : in std_logic;
        req_core  : out std_logic_vector(31 downto 0);
        req_sig   : in std_logic_vector(63 downto 0);
        ack_sig   : out std_logic_vector(63 downto 0);
        req_in_1  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
        req_in_2  : in std_logic_vector(25 downto 0);
    );
end entity req_logic;

architecture behav of req_logic is
    type pe_req_in is array (63 downto 0) of std_logic_vector(25 downto 0);
    signal id_num   : std_logic_vector(5 downto 0);
    signal poll_act : std_logic;
    signal fifo_rdy : std_logic;
    signal add_in_1 : std_logic_vector(5 downto 0);
    signal add_in_2 : std_logic_vector(5 downto 0);
    signal add_out  : std_logic_vector(5 downto 0);
    signal bs_out   : std_logic_vector(63 downto 0);
    signal pe_mux_out : std_logic_vector(25 downto 0);

begin
-------------------------------------------------------------
--Polling mechanism
-------------------------------------------------------------
--Activation 
process (clk_p)
begin 
    if fifo_rdy='1' and req_sig /= (req_sig'range => '0') and rising_edge(clk_p) then 
        poll_act <= '1'; 
    else
        poll_act <= '0';
    end if;
end process;
--ID Number Register
process(poll_act)
--variable num : integer := 0;
begin
    --num := to_integer(unsigned(id_num)); 
    if poll_act = '1' then
        ack_sig(to_integer(unsigned(id_num)))<= '1';
        req_core (5 downto 0) <= id_num;
        id_num <= add_out;
    end if;
end process;

--Barrel Shifter

process(id_num, req_sig)
variable sh_0, sh_1, sh_2, sh_3, sh_4, sh_5 : std_logic_vector(63 downto 0);
begin
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
end process;

--Priority Encoder

process(bs_out)
variable cnt : integer := 0;
variable scop : std_logic := '0';
begin
    for i in 63 downto 0 loop
    scop:= scop and bs_out(i);
    if scop = '0'then
        cnt := cnt+1;
    elsif scop = '1' then
        add_in_2 <= std_logic_vector(to_unsigned(cnt -1, 6));
        exit;
    end if;
    end loop;
end process;

--Adder

process(add_in_2)
begin
    add_out<= std_logic_vector(to_unsigned(to_integer(unsigned(add_in_1))+to_integer(unsigned(add_in_2)),6));
end process;

----------------------------------------------------------------
--Request Buffer
----------------------------------------------------------------
--PE Mux
process(id_num)
begin
    pe_mux_out <= pe_req_in(to_integer(unsigned(id_num)));
end process;

--Request FIFO
process(id_num,pe_mux_out)
begin
    req_core <= pe_mux_out & id_num;
    fifo_rdy <= '1';
end process;


end architecture;