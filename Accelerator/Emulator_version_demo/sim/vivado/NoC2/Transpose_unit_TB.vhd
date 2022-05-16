----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2022 14:48:47
-- Design Name: 
-- Module Name: Transpose_unit_TB - Behavioral
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

entity Transpose_unit_TB is
--  Port ( );
end Transpose_unit_TB;

architecture Behavioral of Transpose_unit_TB is

    component Transpose_unit is
    port(
        clk                     : in  std_logic;
        Reset                   : in  std_logic;
        Reset_TPC               : in  std_logic;
        En_TP_write             : in  std_logic;
        En_TP_read              : in  std_logic;
        Data_dir                : in  std_logic;
        TP_Interchange          : in  std_logic;                                       
        IO_data                 : in  std_logic_vector(127 downto 0);
        switch_data             : in  std_logic_vector(127 downto 0);
        Noc_reg_mux             : out std_logic_vector(127 downto 0);
        Noc_data_mux            : out std_logic_vector(127 downto 0)  
    );
    end component;
    
    signal    clk                 : std_logic;
    signal    Reset               : std_logic;
    signal    Reset_TPC           : std_logic;
    signal    En_TP_write         : std_logic;
    signal    En_TP_read          : std_logic;
    signal    Data_dir            : std_logic;
    signal    Disable_TP_write    : std_logic;
    signal    TP_Interchange      : std_logic;
    signal    IO_data             : std_logic_vector(127 downto 0);
    signal    switch_data         : std_logic_vector(127 downto 0);
    signal    Noc_reg_mux         : std_logic_vector(127 downto 0);
    signal    Noc_data_mux        : std_logic_vector(127 downto 0);

begin

    UUT: Transpose_unit port map (clk => clk, Reset => Reset, Reset_TPC => Reset_TPC, En_TP_write => En_TP_write, En_TP_read => En_TP_read, Data_dir => Data_dir, TP_Interchange => TP_Interchange, IO_data => IO_data, switch_data => switch_data, Noc_reg_mux => Noc_reg_mux, Noc_data_mux => Noc_data_mux); 

    process
    begin
        Reset               <= '0';
        Reset_TPC           <= '0';
        En_TP_write         <= '0';
        En_TP_read          <= '0';
        Data_dir            <= '0';
        TP_Interchange      <= '0';
        wait for 50 ns;    
        Reset               <= '1';   
        wait for 40 ns;    
        Reset               <= '0';
        wait for 40 ns;    
        Reset_TPC           <= '1';
        wait for 40 ns;    
        Reset_TPC           <= '0';
        ----WRITE TP0
        wait for 20 ns;
        En_TP_write         <= '1';                               
        IO_data             <= x"0F0E0D0C0B0A09080706050403020100";
        wait for 20 ns;
        IO_data             <= x"1F1E1D1C1B1A19181716151413121110";
        wait for 20 ns;
        IO_data             <= x"2F2E2D2C2B2A29282726252423222120";
        wait for 20 ns;
        IO_data             <= x"3F3E3D3C3B3A39383736353433323130";
        wait for 20 ns;
        IO_data             <= x"4F4E4D4C4B4A49484746454443424140";
        wait for 20 ns;
        IO_data             <= x"5F5E5D5C5B5A59585756555453525150";
        wait for 20 ns;
        IO_data             <= x"6F6E6D6C6B6A69686766656463626160";
        wait for 20 ns;
        IO_data             <= x"7F7E7D7C7B7A79787776757473727170";
        wait for 20 ns;
        IO_data             <= x"8F8E8D8C8B8A89888786858483828180";
        wait for 20 ns;
        IO_data             <= x"9F9E9D9C9B9A99989796959493929190";
        wait for 20 ns;
        IO_data             <= x"AFAEADACABAAA9A8A7A6A5A4A3A2A1A0";
        wait for 20 ns;
        IO_data             <= x"BFBEBDBCBBBAB9B8B7B6B5B4B3B2B1B0";
        wait for 20 ns;
        IO_data             <= x"CFCECDCCCBCAC9C8C7C6C5C4C3C2C1C0";
        wait for 20 ns;
        IO_data             <= x"DFDEDDDCDBDAD9D8D7D6D5D4D3D2D1D0";
        wait for 20 ns;
        IO_data             <= x"EFEEEDECEBEAE9E8E7E6E5E4E3E2E1E0";
        wait for 20 ns;
        IO_data             <= x"FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0";                                                                                                   
        ----WRITE TP1 & READ TP0
        TP_Interchange      <= '1';
        wait for 20 ns;
        TP_Interchange      <= '0'; 
        En_TP_read          <= '1';               
        IO_data             <= x"55005500550055005500550055005500";
        wait for 20 ns;
        IO_data             <= x"66116611661166116611661166116611";
        wait for 20 ns;
        IO_data             <= x"77227722772277227722772277227722";
        wait for 20 ns;
        IO_data             <= x"88338833883388338833883388338833";
        wait for 20 ns;
        IO_data             <= x"99449944994499449944994499449944";
        wait for 20 ns;
        IO_data             <= x"AA55AA55AA55AA55AA55AA55AA55AA55";
        wait for 20 ns;
        IO_data             <= x"BB66BB66BB66BB66BB66BB66BB66BB66";
        wait for 20 ns;
        IO_data             <= x"CC77CC77CC77CC77CC77CC77CC77CC77";
        wait for 20 ns;
        IO_data             <= x"DD88DD88DD88DD88DD88DD88DD88DD88";
        wait for 20 ns;
        IO_data             <= x"EE99EE99EE99EE99EE99EE99EE99EE99";
        wait for 20 ns;
        IO_data             <= x"FFAAFFAAFFAAFFAAFFAAFFAAFFAAFFAA";
        wait for 20 ns;
        IO_data             <= x"00BB00BB00BB00BB00BB00BB00BB00BB";
        wait for 20 ns;
        IO_data             <= x"01CC01CC01CC01CC01CC01CC01CC01CC";
        wait for 20 ns;
        IO_data             <= x"02DD02DD02DD02DD02DD02DD02DD02DD";
        wait for 20 ns;
        IO_data             <= x"03EE03EE03EE03EE03EE03EE03EE03EE";
        wait for 20 ns;
        IO_data             <= x"04FF04FF04FF04FF04FF04FF04FF04FF";
        TP_Interchange      <= '1';                
        wait for 20 ns;
        ----WRITE TP0 & READ TP1
        IO_data             <= x"0F0E0D0C0B0A09080706050403020100";
        TP_Interchange      <= '0';        
        wait for 20 ns;
        IO_data             <= x"1F1E1D1C1B1A19181716151413121110";
        wait for 20 ns;
        IO_data             <= x"2F2E2D2C2B2A29282726252423222120";
        wait for 20 ns;
        IO_data             <= x"3F3E3D3C3B3A39383736353433323130";
        wait for 20 ns;
        IO_data             <= x"4F4E4D4C4B4A49484746454443424140";
        wait for 20 ns;
        IO_data             <= x"5F5E5D5C5B5A59585756555453525150";
        wait for 20 ns;
        IO_data             <= x"6F6E6D6C6B6A69686766656463626160";
        wait for 20 ns;
        IO_data             <= x"7F7E7D7C7B7A79787776757473727170";
        wait for 20 ns;
        IO_data             <= x"8F8E8D8C8B8A89888786858483828180";
        wait for 20 ns;
        IO_data             <= x"9F9E9D9C9B9A99989796959493929190";
        wait for 20 ns;
        IO_data             <= x"AFAEADACABAAA9A8A7A6A5A4A3A2A1A0";
        wait for 20 ns;
        IO_data             <= x"BFBEBDBCBBBAB9B8B7B6B5B4B3B2B1B0";
        wait for 20 ns;
        IO_data             <= x"CFCECDCCCBCAC9C8C7C6C5C4C3C2C1C0";
        wait for 20 ns;
        IO_data             <= x"DFDEDDDCDBDAD9D8D7D6D5D4D3D2D1D0";
        wait for 20 ns;
        IO_data             <= x"EFEEEDECEBEAE9E8E7E6E5E4E3E2E1E0";
        wait for 20 ns;
        IO_data             <= x"FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0";
        TP_Interchange      <= '1';
        wait for 20 ns;
        ----WRITE TP1 & READ TP0
        TP_Interchange      <= '0';
        IO_data             <= x"0F0E0D0C0B0A09080706050403020100";
        wait for 20 ns;
        TP_Interchange      <= '0';
        IO_data             <= x"1F1E1D1C1B1A19181716151413121110";
        wait for 20 ns;
        IO_data             <= x"2F2E2D2C2B2A29282726252423222120";
        wait for 20 ns;
        IO_data             <= x"3F3E3D3C3B3A39383736353433323130";
        wait for 20 ns;
        IO_data             <= x"4F4E4D4C4B4A49484746454443424140";
        wait for 20 ns;
        IO_data             <= x"5F5E5D5C5B5A59585756555453525150";
        wait for 20 ns;
        IO_data             <= x"6F6E6D6C6B6A69686766656463626160";
        wait for 20 ns;
        IO_data             <= x"7F7E7D7C7B7A79787776757473727170";
        wait for 20 ns;
        IO_data             <= x"8F8E8D8C8B8A89888786858483828180";
        wait for 20 ns;
        IO_data             <= x"9F9E9D9C9B9A99989796959493929190";
        wait for 20 ns;
        IO_data             <= x"AFAEADACABAAA9A8A7A6A5A4A3A2A1A0";
        wait for 20 ns;
        IO_data             <= x"BFBEBDBCBBBAB9B8B7B6B5B4B3B2B1B0";
        wait for 20 ns;
        IO_data             <= x"CFCECDCCCBCAC9C8C7C6C5C4C3C2C1C0";
        wait for 20 ns;
        IO_data             <= x"DFDEDDDCDBDAD9D8D7D6D5D4D3D2D1D0";
        wait for 20 ns;
        IO_data             <= x"EFEEEDECEBEAE9E8E7E6E5E4E3E2E1E0";
        wait for 20 ns;
        IO_data             <= x"FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0";
        TP_Interchange      <= '1';         
        wait for 20 ns;
        ----READ TP1
        En_TP_write         <= '0';
        TP_Interchange      <= '0';         
        wait for 320 ns;   
    end process;
   
    process
    begin
        clk <= '0';
        for i in 1 to 3000 loop
            wait for 10ns;
            clk <= not clk;
        end loop;
        wait;
    end process;
end Behavioral;
