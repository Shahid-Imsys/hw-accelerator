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
-- Title      : ve
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : ve.vhd
-- Author     : Chuhang Jin
-- Company    : Imsys Technologies AB
-- Date       : 
-------------------------------------------------------------------------------
-- Description: vector engine
--              
--              
-------------------------------------------------------------------------------
-- TO-DO list : 
--              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-- 2021-5-19  		     1.0	     CJ			Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.cluster_pkg.all;

entity ve is
    port(
        --Control inputs
        CLK_P:                 in std_logic;
        CLK_E_POS :            in std_logic;
        CLK_E_NEG :            in std_logic;
        RST       :            in std_logic;

        PL        :            in std_logic_vector(127 downto 0);
        YBUS      :            in std_logic_vector(7 downto 0); -- Y bus
        --DFY       :            in std_logic_vector(63 downto 0);

        DDI_VLD   :            in std_logic;  --input data valid, from CC
        --Data inputs
        VE_IN     :            in std_logic_vector(63 downto 0);
        --Data outputs
        VE_OUT    :            out std_logic_vector(7 downto 0)
       );
end entity ve;

architecture rtl of ve is

COMPONENT c_accum_0
  PORT (
    B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    BYPASS : IN STD_LOGIC;
    SCLR : IN STD_LOGIC;
    Q : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
  );
END COMPONENT;
COMPONENT mult_gen_0
  PORT (
    CLK : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    P : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

    --------------------------------
    --PL signals
    --------------------------------
    --Receive engine signals
    signal re_start : std_logic;
    signal re_source : std_logic;
    --Vector engine signals
    signal ve_start : std_logic;
    signal dfy_dest_sel : std_logic_vector(2 downto 0);
    --signal wr_st_addr:std_logic; --TBD
    --signal wr_offset : std_logic;--TBD
    --signal wr_jump   : std_logic;--TBD
    --signal wr_depth  : std_logic;--TBD
    --signal mac_switch : std_logic;
    signal acc_latch  : std_logic;
    signal acc_clear : std_logic; --clear the accumulators
      --Post processing --TBA

    --Shared signals
    signal mode_a : std_logic; --mode A activate
    signal mode_b : std_logic; --mode B activate
    signal reload : std_logic; --reload address counters 
    signal reg_in : std_logic_vector(4 downto 0); --parameter register set field, including loop counter.
    
    --------------------------------
    --Registers
    --------------------------------
    type dfy_word is array(7 downto 0) of std_logic_vector(7 downto 0);
    signal re_addr_l   : std_logic_vector(7 downto 0); --Receive engine left address when DFM is used as the source
    signal re_addr_r   : std_logic_vector(7 downto 0);
    signal re_saddr_l  : std_logic_vector(7 downto 0); --Receive engine's left starting address when DFM is used as the source
    signal re_saddr_r  : std_logic_vector(7 downto 0);
    signal re_loop_reg : std_logic_vector(7 downto 0); --receive engine's loop counter register
    signal re_loop     : std_logic_vector(7 downto 0); --receive engine's loop counter
    signal re_saddr_a   : std_logic_vector(7 downto 0); --Receive engine mode A start address when DFY is used as the source
    signal re_saddr_b   : std_logic_vector(7 downto 0); 
    signal re_addr_a   : std_logic_vector(7 downto 0); 
    signal re_addr_b   : std_logic_vector(7 downto 0); 
    signal ve_addr_l   : std_logic_vector(7 downto 0); --data to address pointer left
    signal ve_saddr_l  : std_logic_vector(7 downto 0); --Left starting address register
    signal ve_addr_r   : std_logic_vector(7 downto 0);
    signal ve_saddr_r  : std_logic_vector(7 downto 0);
    signal ve_loop     : std_logic_vector(7 downto 0);
    signal ve_loop_reg : std_logic_vector(7 downto 0);
    signal offset_l    : std_logic_vector(7 downto 0); --offset register
    signal offset_r    : std_logic; 
    signal jump_l    : std_logic_vector(7 downto 0);--Jump register
    signal depth_l   : std_logic_vector(7 downto 0);--depth register
    signal mul_ctl   : std_logic_vector(7 downto 0); --turn off the multipliers.
    signal dfy_reg   : dfy_word;
    signal re_start_reg : std_logic; --RE start latch
    signal ve_start_reg : std_logic; --VE start latch

    signal addr_p_l  : std_logic_vector(7 downto 0);
    signal addr_p_r  : std_logic_vector(7 downto 0);
    --------------------------------
    --Register set selection fields (can be moved to mpgmfield_lib.vhd?)
    --------------------------------
    constant NON_ACT         : std_logic_vector(4 downto 0) := x"00";
    constant RE_START_ADDR_L : std_logic_vector(4 downto 0) := x"01"; --write left starting address of receive engine
    constant RE_START_ADDR_R : std_logic_vector(4 downto 0) := x"02"; --write right starting address of recieve engine
    constant RE_LC           : std_logic_vector(4 downto 0) := x"03"; --write receive engine's loop counter
    constant DFY_ADDR_A      : std_logic_vector(4 downto 0) := x"04"; --push back address from DFY
    constant DFY_ADDR_B      : std_logic_vector(4 downto 0) := x"05"; --push back address from DFY, B mode
    constant VE_START_ADDR_L : std_logic_vector(4 downto 0) := x"06"; --vector engine's left starting address
    constant VE_START_ADDR_R : std_logic_vector(4 downto 0) := x"07"; --vector engine's right starting address
    constant VE_LC           : std_logic_vector(4 downto 0) := x"08"; --vector engine's loop counter
    constant VE_OFFSET_L     : std_logic_vector(4 downto 0) := x"09"; --left offset
    constant VE_OFFSET_R     : std_logic_vector(4 downto 0) := x"0a"; --right offset
    constant VE_DEPTH_L      : std_logic_vector(4 downto 0) := x"0b"; --left depth
    constant VE_JUMP_L       : std_logic_vector(4 downto 0) := x"0c"; --left jump
    constant DFY             : std_logic_vector(4 downto 0) := x"0d"; --write DFY 
    constant MAC_SWITCH      : std_logic_vector(4 downto 0) := x"1f"; --write the multiplier control register


begin
    --Microcode translation
    dfy_dest_sel <= PL (118 downto 116); --DEST_BYTE
    re_start  <= PL(100);
    ve_start  <= PL(95); --VE_ST
    acc_latch <= PL(94); --ACCTOREG
    acc_clear <= PL(93); --CLR_ACC
    re_source <= PL(96); --RE_DFY_SRC
    reg_in    <= PL(105 downto 101);
    mode_a    <= PL(98);
    mode_b    <= PL(97);
    reload    <= PL(107); --ADDR_VE_RELOAD

    reg_write: process(clk_p)
    begin
        if rising_edge(clk_p) and clk_e_neg = '1' then --clk_e_neg
            if reg_in = RE_START_ADDR_L then
                re_saddr_l <= YBUS;
            elsif reg_in = RE_START_ADDR_R then
                re_saddr_r <= YBUS;
            elsif reg_in = RE_LC then
                re_loop_reg <= YBUS;
            elsif reg_in = DFY_ADDR_A then
                re_saddr_a <= YBUS;
            elsif reg_in = DFY_ADDR_B then
                re_saddr_b <= YBUS;
            elsif reg_in = VE_START_ADDR_L then
                ve_saddr_l <= YBUS;
            elsif reg_in = VE_START_ADDR_R then
                ve_saddr_r <= YBUS;
            elsif reg_in = VE_LC then
                ve_loop_reg <= YBUS;
            elsif reg_in = VE_OFFSET_L then
                offset_l <= YBUS;
            elsif reg_in = VE_OFFSET_R then
                offset_r <= YBUS(0);
            elsif reg_in = VE_DEPTH_L then
                depth_l <= YBUS;
            elsif reg_in = VE_JUMP_L then
                jump_l <= YBUS;
            elsif reg_in = DFY then
                dfy_reg(to_integer(unsigned(dfy_dest_sel))) <= YBUS;
            elsif reg_in = MAC_SWITCH then
                mul_ctl <= YBUS;
            end if;
        end if;
    end process;
----------------------------------------------------------------------------------
--Receive Engine
----------------------------------------------------------------------------------
    re_start_latch: process(re_start,re_loop,reload)
        if re_start = '1' then
            re_start_reg <= '1';
        else if re_loop = (re_loop'range => '0') and reload = '0' then
            re_start_reg <= '0';
        end if;
    end process;

    receive_addr_write : process (clk_p)
    begin 
        if rising_edge(clk_p) then
            if RST = '1' then        --Active low or high?
                re_addr_l<= (others => '0');
                re_addr_r <= (others => '0');
                re_loop <= (others => '0');
            elsif re_source = '0' and re_start_reg = '1' and re_loop /= (re_loop'range => '0') and DDI_VLD = '1' then

                re_loop <= re_loop -1;

                if mode_a = '1' then
                    if reload = '1' then
                        re_addr_l <= re_saddr_l;
                    else
                        re_addr_l <= re_addr_l +1;
                    end if;
                end if;

                if mode_b = '1' then
                    if reload = '1' then
                        re_addr_r <= re_saddr_r;
                    else
                        re_addr_r <= re_addr_r +1;
                    end if;
                end if;
            elsif re_start_reg = '1' and re_loop = (re_loop'range => '0') then
                if reload = '1' then
                    re_loop <= re_loop_reg -1;
                end if;
            end if;
        end if;
    end process;

    pushback_addr_write : process(clk_p) --generate address counter a abd b
    begin
        if rising_edge(clk_p) then
            if RST = '1' then
                re_addr_a <= (others => '0');
                re_addr_b <= (others => '0');
            elsif re_source = '1' and re_start = '1' then
                if mode_a = '1' then
                    if reload = '1' then
                        re_addr_a <= re_saddr_a;
                    else
                        re_addr_a <= re_addr_a +1;
                    end if;
                end if;
                
                if mode_b = '1' then
                    if reload = '1' then
                        re_addr_b <= re_saddr_b;
                    else
                        re_addr_b <= re_addr_b +1;
                    end if;
                end if;
            end if;
        end if;
    end process;
----------------------------------------------------------------------------------
--Vector Engine
----------------------------------------------------------------------------------

    ve_addr_gene: process(clk_p)
    begin
        if rising_edge(clk_p) then
            if RST = '1' then
                ve_addr_l <= (others => '0');
                ve_addr_r <= (others => '0');
                ve_loop <= (others => '0');
            elsif ve_start = '1' and ve_loop /= (ve_loop'range => '0') then
                ve_loop <= ve_loop -1;

                if mode_a = '1' then --active address pointer L
                    if reload = '1' then --load starting address,controlled by first step signal
                        ve_addr_l <= ve_saddr_l;
                    else
                        ve_addr_l <= ve_addr_l + step_l + jump_l + depth_l + offset_l; --calculate left address;
                    end if;
                end if;
    
                if mode_b = '1' then --active address pointer R
                    if reload = '1' then
                        ve_addr_r <= ve_saddr_r;
                    else
                        ve_addr_r <= ve_addr_r + step_r + jump_r + depth_r + offset_r; --calculate left address;
                    end if;
                end if;
            elsif ve_start = '1' and ve_loop = (ve_loop'range => '0') then
                if reload = '1' then
                    ve_loop <= ve_loop_reg;
                end if;
            end if;
        end if;
    end process;
    
------------------------
--Address_MUX
------------------------
    process
    begin
        if re_start = '1' and re_source = '0' then --Use receive engine's address counter l and r
            if mode_a = '1' then
                addr_p_l <= re_addr_l;
            end if;

            if mode_b = '1' then
                addr_p_r <= re_addr_r;
            end if;
        elsif re_start = '1' and re_source = '1' then --Use receive engine's address counter a and b
            if mode_a = '1' then
                addr_p_l <= re_addr_a;
            elsif mode_b = '1' then
                addr_p_l <= re_addr_b;
            end if;
        elsif ve_start = '1' then --Use vector engine's address counter
            if mode_a = '1' then
                addr_p_l <= ve_addr_l;
            end if;

            if mode_b = '1' then
                addr_p_r <= ve_addr_r;
            end if;
        end if;
    end process;

accu_0 : c_accum_0
  PORT MAP (
    B => B,
    CLK => CLK,
    CE => CE,
    BYPASS => BYPASS,
    SCLR => SCLR,
    Q => Q
  );
  mul_0 : mult_gen_0
  PORT MAP (
    CLK => CLK,
    A => A,
    B => B,
    P => P
  );
            
    
                    

                 
    





