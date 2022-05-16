----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2022 15:59:21
-- Design Name: 
-- Module Name: Tag_Line_Block - Behavioral
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

entity Tag_Line_Block is
    Port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;       
        Load_Tag_Shift_Counter  : in  std_logic;
        Start_Tag_Shift         : in  std_logic;
        Shift_Count             : in  std_logic_vector(7 downto 0); 
        Load_TAG_Cmd_reg        : in  std_logic;
        Load_TAG_Arg_reg        : in  std_logic;
        PEC_AS0                 : in  std_logic_vector(14 downto 0);
        PEC_AS1                 : in  std_logic_vector(14 downto 0);
        PEC_TS                  : in  std_logic_vector(15 downto 0);
        PEC_CMD                 : in  std_logic_vector(5 downto 0);
        Tag_Line                : out std_logic;
        TAG_shift               : out std_logic      
     );
end Tag_Line_Block;

architecture Behavioral of Tag_Line_Block is

    signal Tag_Shift_Counter    : unsigned(7 downto 0);
    signal Start_Tag_Shift_pre  : std_logic;
    signal TAG_shift_i          : std_logic;
    signal PEC_Reg              : std_logic_vector(52 downto 0);  -- to add one cycle for CC command buffer original was signal PEC_Reg 
    signal PEC_CMD_Ready        : std_logic;
    signal PEC_Arg_Ready        : std_logic;
    signal Tag_shift_p          : std_logic;    
    
begin

    TAG_shift   <= TAG_shift_i;

    -----Tag_Line_Controller
    process (clk, Reset)
    begin
        if Reset = '1' then
           Tag_Shift_Counter            <= (others => '0');
           Start_Tag_Shift_pre          <= '0';
           TAG_shift_i                  <= '0';
        elsif rising_edge(clk) then
            if Load_Tag_Shift_Counter = '1' then
                Tag_Shift_Counter       <= unsigned(Shift_Count) + 1;  -- to add one cycle for CC command buffer original was Tag_Shift_Counter <= Shift_Count;
            elsif Start_Tag_Shift = '1' or Start_Tag_Shift_pre = '1' then
                Tag_Shift_Counter       <= Tag_Shift_Counter - 1;
                Start_Tag_Shift_pre     <= '1';
                TAG_shift_i             <= '1';
                if Tag_Shift_Counter = 0 then      
                    TAG_shift_i         <= '0';
                    Start_Tag_Shift_pre <= '0';
                    Tag_Shift_Counter   <= (others => '0');
                end if;
            end if;
        end if;
    end process;
    
    -----TAG INTERFACE
    process (clk, Reset)
    begin  
        if Reset = '1' then
            PEC_Reg                     <= (others => '0');
            PEC_CMD_Ready               <= '0';
            PEC_Arg_Ready               <= '0';
            Tag_shift_p                 <= '0';
            Tag_Line                    <= '0';
        elsif rising_edge(clk) then
            Tag_shift_p                 <= TAG_shift_i;           
            if Load_TAG_Cmd_reg = '1' then
                PEC_Reg(52 downto 47)   <= PEC_CMD;  -- to add one cycle for CC command buffer
                PEC_Reg(46)             <= '0';      -- to add one cycle for CC command buffer
                PEC_CMD_Ready           <= '1';
            end if;

            if Load_TAG_Arg_reg = '1' then
                PEC_Reg(45 downto 30)   <= PEC_TS;
                PEC_Reg(29 downto 15)   <= PEC_AS0;
                PEC_Reg(14 downto 0)    <= PEC_AS1;
                PEC_Arg_Ready           <= '1'; 
            end if;    

            if TAG_shift_i = '1' and PEC_CMD_Ready = '1' and PEC_Arg_Ready = '1' then
                Tag_Line                <= PEC_Reg(52); 
                PEC_Reg(52 downto 0)    <= PEC_Reg(51 downto 0) & '0';                
            end if;
                         
            if TAG_shift_i = '0' and Tag_shift_p = '1' then
                PEC_CMD_Ready           <= '0';
                PEC_Arg_Ready           <= '0';
                Tag_Line                <= '0';
                PEC_Reg                 <= ( others => '0'); 
            end if;
        end if;
    end process;    

end Behavioral;
