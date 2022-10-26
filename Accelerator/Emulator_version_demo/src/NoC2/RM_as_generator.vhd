----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.08.2022 15:14:19
-- Design Name: 
-- Module Name: RM_as_generator - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity RM_as_generator is
    port(
	    clk                  : in  std_logic;
	    Reset                : in  std_logic;
	    Load_IR              : in  std_logic;
	    Reset_IR             : in  std_logic;
	    Load_RM_as           : in  std_logic;
	    En_RM1               : in  std_logic;
	    RM_as_Mux            : in  std_logic;
	    RM_as                : in  std_logic_vector(14 downto 0);
	    Address_steps        : in  unsigned(118 downto 0);
	    End_values           : in  unsigned(118 downto 0);
	    RM_byte_as           : out unsigned(3 downto 0); 
	    RM_word_as           : out unsigned(14 downto 0);
	    RM_as_err            : out std_logic
    );	    
end RM_as_generator;

architecture Behavioral of RM_as_generator is

    type RegL1_data_type is array (0 to 5) of unsigned(19 downto 0);
    type RegL2_data_type is array (0 to 2) of unsigned(19 downto 0);
    type RegL3_data_type is array (0 to 1) of unsigned(19 downto 0);
    
    signal Reg_L1       : RegL1_data_type;
    signal Reg_L2       : RegL2_data_type;
    signal Reg_L3       : RegL3_data_type;
    signal Reg_L4       : unsigned(19 downto 0);
    signal Reg_L4_p1    : unsigned(3 downto 0);
    signal Reg_L4_p2    : unsigned(3 downto 0);
    signal Reg_L4_p3    : unsigned(3 downto 0);
    signal i            : integer;
    signal RM_as_counter: unsigned(14 downto 0);
    signal Load_IR1     : unsigned(5 downto 1);
    signal err          : std_logic_vector(11 downto 0);
    signal err_or       : std_logic;
    signal err_ff       : std_logic;
    signal Address_steps_0: unsigned(18 downto 0);
    signal End_values_0 : unsigned(18 downto 0);
     

begin

    RM_byte_as  <= Reg_L4_p2;
    RM_word_as  <= RM_as_counter when RM_as_Mux = '0' else Reg_L4(18 downto 4);  

    Load_IR1(1) <= '1' when Reg_L1(0) = End_values(18 downto 0)   else '0';
    Load_IR1(2) <= '1' when Reg_L1(1) = End_values(38 downto 20) and Load_IR1(1) = '1' else '0';
    Load_IR1(3) <= '1' when Reg_L1(2) = End_values(58 downto 40) and Load_IR1(2) = '1' else '0';
    Load_IR1(4) <= '1' when Reg_L1(3) = End_values(78 downto 60) and Load_IR1(3) = '1' else '0';
    Load_IR1(5) <= '1' when Reg_L1(4) = End_values(98 downto 80) and Load_IR1(4) = '1' else '0';
    
    err(0)      <= '1' when Reg_L1(0) > End_values(18 downto 0)   else '0';
    err(1)      <= '1' when Reg_L1(1) > End_values(38 downto 20)  else '0';
    err(2)      <= '1' when Reg_L1(2) > End_values(58 downto 40)  else '0';
    err(3)      <= '1' when Reg_L1(3) > End_values(78 downto 60)  else '0';
    err(4)      <= '1' when Reg_L1(4) > End_values(98 downto 80)  else '0';
    err(5)      <= '1' when Reg_L1(5) > End_values(118 downto 100) else '0';
    err(6)      <= '1' when Reg_L2(0) > x"7FFFF" else '0';
    err(7)      <= '1' when Reg_L2(1) > x"7FFFF" else '0';
    err(8)      <= '1' when Reg_L2(2) > x"7FFFF" else '0';
    err(9)      <= '1' when Reg_L3(0) > x"7FFFF" else '0';
    err(10)     <= '1' when Reg_L3(1) > x"7FFFF" else '0';
    err(11)     <= '1' when Reg_L4    > x"7FFFF" else '0';
    err_or      <= err(0) or err(1) or err(2) or err(3) or err(4) or err(5) or err(6) or err(7) or err(8) or err(9) or err(10);
    RM_as_err   <= err_ff;
    
    Address_steps_0 <= Address_steps(18 downto 0);
    End_values_0    <= End_values(18 downto 0);
    
    process(clk, reset)
    begin
        if reset = '0' then
            Reg_L1(0) <= (others => '0');
            Reg_L1(1) <= (others => '0');
            Reg_L1(2) <= (others => '0');
            Reg_L1(3) <= (others => '0');
            Reg_L1(4) <= (others => '0');
            Reg_L1(5) <= (others => '0');
            Reg_L2(0) <= (others => '0');
            Reg_L2(1) <= (others => '0');
            Reg_L2(2) <= (others => '0');
            Reg_L3(0) <= (others => '0');
            Reg_L3(1) <= (others => '0');
            Reg_L4    <= (others => '0');
            RM_as_counter   <= (others => '0');             
        elsif rising_edge(clk) then
            ---LOAD L1 REGs
            if Load_IR = '1' then
                Reg_L1(0)  <= Address_steps_0 + Reg_L1(0);
            end if;
                        
            for i in 1 to 5 loop
                if Load_IR1(i) = '1' then
                    Reg_L1(i)  <= Address_steps((i*20)+18 downto i*20)+ Reg_L1(i);
                else
                    Reg_L1(i)  <= Reg_L1(i);
                end if;    
            end loop;             
            
            ---RESET L1 REGs

            if ( (Reg_L1(0) = End_values(18 downto 0) and Load_IR = '1') or Reset_IR = '1') then
                Reg_L1(0) <= (others => '0');
            end if;
                           
            for i in 1 to 5 loop            
                if ( (Reg_L1(i) = End_values((i*20)+18 downto (i*20)) and Load_IR1(i) = '1') or Reset_IR = '1') then
                    Reg_L1(i) <= (others => '0');
                end if;
            end loop;
            
            for i in 0 to 2 loop
                if Reset_IR = '1' then
                    Reg_L2(i) <= (others => '0');
                    Reg_L3(0) <= (others => '0');
                    Reg_L3(1) <= (others => '0');
                    Reg_L4    <= (others => '0');
                else
                    Reg_L2(0) <= Reg_L1(0) + Reg_L1(1);
                    Reg_L2(1) <= Reg_L1(2) + Reg_L1(3);
                    Reg_L2(2) <= Reg_L1(4) + Reg_L1(5);
                    
                    Reg_L3(0) <= Reg_L2(0) + Reg_L2(1);
                    Reg_L3(1) <= Reg_L2(2) + unsigned(RM_as);
                    Reg_L4    <= Reg_L3(0) + Reg_L3(1); 
                end if;    
            end loop;
            
            Reg_L4_p1   <= Reg_L4(3 downto 0);
            Reg_L4_p2   <= Reg_L4_p1;
            Reg_L4_p3   <= Reg_L4_p2;
                                    
            --RM AS Counter
            if Load_RM_as = '1' then
                RM_as_counter   <= unsigned(RM_as);
            elsif EN_RM1 = '1' then
                RM_as_counter   <= RM_as_counter + 1;
            end if;
            
            --ERROR 
            err_ff      <= (err_or or err_ff) and not Reset_IR;   
            
        end if;
     end process;
                
end Behavioral;