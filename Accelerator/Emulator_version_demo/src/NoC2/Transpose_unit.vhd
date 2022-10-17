----------------------------------------------------------------------------------
-- Company: Imsys Technologies AB
-- Engineer: Azadeh Kaffash
-- 
-- Create Date: 14.02.2022 14:49:19
-- Design Name: Transpose_unit
-- Module Name: Transpose_unit - Behavioral
-- Project Name: NOCv2
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
use work.ACC_types.all;

entity Transpose_unit is
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
end Transpose_unit;

architecture Behavioral of Transpose_unit is

    --signal declaration
    signal  TP_Data0                : TP_data_type;
    signal  TP_Data1                : TP_data_type;    
    signal  addr_cntr1              : integer range 0 to 15;
    signal  addr_cntr0              : integer range 0 to 15;
    signal  TP_Interchange_FF       : std_logic;
    signal  TP_Interchange_FF_d     : std_logic;
    signal  Noc_reg_mux0            : std_logic_vector(127 downto 0);
    signal  Noc_data_mux0           : std_logic_vector(127 downto 0);
    signal  Noc_reg_mux1            : std_logic_vector(127 downto 0);
    signal  Noc_data_mux1           : std_logic_vector(127 downto 0);
    signal  Enable_TP1_Down         : std_logic;
    signal  Enable_TP1_UP           : std_logic;
    signal  Enable_TP0_Down         : std_logic;
    signal  Enable_TP0_UP           : std_logic;
    signal  TP1_RW                  : std_logic;
    signal  TP0_RW                  : std_logic;

begin
   

    Noc_reg_mux   <= Noc_reg_mux0  when TP_Interchange_FF = '1' else Noc_reg_mux1;
    Noc_data_mux  <= Noc_data_mux0 when TP_Interchange_FF = '1' else Noc_data_mux1;
    
    Enable_TP1_Down  <= '1' when Data_dir = '0' and ((En_TP_write = '1' and TP_Interchange_FF = '1') or (En_TP_read = '1' and TP_Interchange_FF = '0'))  else '0';
    Enable_TP1_UP    <= '1' when Data_dir = '1' and ((En_TP_write = '1' and TP_Interchange_FF = '1') or (En_TP_read = '1' and TP_Interchange_FF = '0'))  else '0'; 
    Enable_TP0_Down  <= '1' when Data_dir = '0' and ((En_TP_write = '1' and TP_Interchange_FF = '0') or (En_TP_read = '1' and TP_Interchange_FF = '1'))  else '0';
    Enable_TP0_UP    <= '1' when Data_dir = '1' and ((En_TP_write = '1' and TP_Interchange_FF = '0') or (En_TP_read = '1' and TP_Interchange_FF = '1'))  else '0'; 

    TP1_RW           <= '1' when TP_Interchange_FF = '1' else '0';
    TP0_RW           <= '1' when TP_Interchange_FF = '0' else '0';
    
    --TP1 READ Downstream
    Noc_reg_mux1     <= TP_Data1(15)(addr_cntr1) & TP_Data1(14)(addr_cntr1) & TP_Data1(13)(addr_cntr1) & TP_Data1(12)(addr_cntr1) & 
                        TP_Data1(11)(addr_cntr1) & TP_Data1(10)(addr_cntr1) & TP_Data1(9)(addr_cntr1)  & TP_Data1(8)(addr_cntr1)  & 
                        TP_Data1(7)(addr_cntr1)  & TP_Data1(6)(addr_cntr1)  & TP_Data1(5)(addr_cntr1)  & TP_Data1(4)(addr_cntr1)  & 
                        TP_Data1(3)(addr_cntr1)  & TP_Data1(2)(addr_cntr1)  & TP_Data1(1)(addr_cntr1)  & TP_Data1(0)(addr_cntr1) when Enable_TP1_Down = '1' and TP1_RW = '0' and Reset = '1' else x"00000000000000000000000000000000" when Reset = '0' else x"00000000000000000000000000000000";
    
    --TP1 READ Upstream
    Noc_data_mux1    <= TP_Data1(addr_cntr1)(15) & TP_Data1(addr_cntr1)(14) & TP_Data1(addr_cntr1)(13) & TP_Data1(addr_cntr1)(12) &
                        TP_Data1(addr_cntr1)(11) & TP_Data1(addr_cntr1)(10) & TP_Data1(addr_cntr1)(9)  & TP_Data1(addr_cntr1)(8)  &
                        TP_Data1(addr_cntr1)(7)  & TP_Data1(addr_cntr1)(6)  & TP_Data1(addr_cntr1)(5)  & TP_Data1(addr_cntr1)(4)  &
                        TP_Data1(addr_cntr1)(3)  & TP_Data1(addr_cntr1)(2)  & TP_Data1(addr_cntr1)(1)  & TP_Data1(addr_cntr1)(0) when Enable_TP1_UP = '1'   and TP1_RW = '0' and Reset = '1' else x"00000000000000000000000000000000" when Reset = '0' else x"00000000000000000000000000000000";
    
    --TP0 READ Downstream                    
    Noc_reg_mux0     <= TP_Data0(15)(addr_cntr0) & TP_Data0(14)(addr_cntr0) & TP_Data0(13)(addr_cntr0) & TP_Data0(12)(addr_cntr0) & 
                        TP_Data0(11)(addr_cntr0) & TP_Data0(10)(addr_cntr0) & TP_Data0(9)(addr_cntr0)  & TP_Data0(8)(addr_cntr0)  & 
                        TP_Data0(7)(addr_cntr0)  & TP_Data0(6)(addr_cntr0)  & TP_Data0(5)(addr_cntr0)  & TP_Data0(4)(addr_cntr0)  & 
                        TP_Data0(3)(addr_cntr0)  & TP_Data0(2)(addr_cntr0)  & TP_Data0(1)(addr_cntr0)  & TP_Data0(0)(addr_cntr0) when Enable_TP0_Down = '1' and TP0_RW = '0' and Reset = '1' else x"00000000000000000000000000000000" when Reset = '0' else x"00000000000000000000000000000000";
                        
    --TP0 READ Upstream
    Noc_data_mux0    <= TP_Data0(addr_cntr0)(15) & TP_Data0(addr_cntr0)(14) & TP_Data0(addr_cntr0)(13) & TP_Data0(addr_cntr0)(12) &
                        TP_Data0(addr_cntr0)(11) & TP_Data0(addr_cntr0)(10) & TP_Data0(addr_cntr0)(9)  & TP_Data0(addr_cntr0)(8)  &
                        TP_Data0(addr_cntr0)(7)  & TP_Data0(addr_cntr0)(6)  & TP_Data0(addr_cntr0)(5)  & TP_Data0(addr_cntr0)(4)  &
                        TP_Data0(addr_cntr0)(3)  & TP_Data0(addr_cntr0)(2)  & TP_Data0(addr_cntr0)(1)  & TP_Data0(addr_cntr0)(0) when Enable_TP0_UP = '1'   and TP0_RW = '0' and Reset = '1' else x"00000000000000000000000000000000" when Reset = '0' else  x"00000000000000000000000000000000";                                            
     
             
    process(clk, reset)
    variable i : integer range 0 to 15 := 0;
    begin
        if reset = '0' then
            addr_cntr1              <= 0;
            addr_cntr0              <= 0;      
            TP_Interchange_FF       <= '0';
        elsif rising_edge(clk) then
            ----TP1
            --Downstream--------------------------------------------------------------------------------------------------------------------
            if Enable_TP1_Down = '1' then
                --TP WRITE
                if TP1_RW = '1' then                  
                    for i in 0 to 15 loop
                        TP_Data1(addr_cntr1)(i)  <= IO_data(i*8 +7 downto i*8);
                    end loop;
                end if;
            end if;
            --Upstream----------------------------------------------------------------------------------------------------------------------
            if Enable_TP1_UP = '1' then
                --TP WRITE
                if TP1_RW = '1' then
                    for i in 0 to 15 loop
                        TP_Data1(i)(addr_cntr1)   <= switch_data(i*8 +7 downto i*8);
                    end loop;
                end if;                            
            end if;
            ----END of TP1----------------------------------------------------------------------------------------------------------------------
            
            ----TP0
            --Downstream--------------------------------------------------------------------------------------------------------------------
            if Enable_TP0_Down = '1' and TP0_RW = '1' then
                --TP WRITE
                -- if TP0_RW = '1' then                                  
                    for i in 0 to 15 loop
                        TP_Data0(addr_cntr0)(i)  <= IO_data(i*8 +7 downto i*8);
                    end loop;
                -- end if;
            end if;
            --Upstream----------------------------------------------------------------------------------------------------------------------
            if Enable_TP0_UP = '1' then
                --TP WRITE
                if TP0_RW = '1' then                           
                    for i in 0 to 15 loop
                        TP_Data0(i)(addr_cntr0)   <= switch_data(i*8 +7 downto i*8);
                    end loop;
                end if;                
            end if;
            ----END of TP0----------------------------------------------------------------------------------------------------------------------
                                                       
            if TP_Interchange = '1' then
                TP_Interchange_FF    <= not TP_Interchange_FF;
            end if;
            TP_Interchange_FF_d  <= TP_Interchange_FF;           

            if Reset_TPC = '1' then
                addr_cntr1   <= 0;
                addr_cntr0   <= 0;
            else
                if Enable_TP1_Down = '1' or Enable_TP1_UP = '1' then
                    if addr_cntr1 < 15 then
                        addr_cntr1 <= addr_cntr1 + 1;
                    else
                        addr_cntr1 <= 0;
                    end if;    
                end if;
                if Enable_TP0_Down = '1' or Enable_TP0_UP = '1' then
                    if addr_cntr0 < 15 then
                        addr_cntr0 <= addr_cntr0 + 1;
                    else
                         addr_cntr0 <= 0;
                    end if;        
                end if;                
            end if;                    
        end if; --reset
    end process;

end Behavioral;