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
-- Title      : NoC_switch
-- Project    : GP3000
-------------------------------------------------------------------------------
-- File       : NoC_switch.vhd
-- Author     : Azadeh Kaffash
-- Company    : Imsys Technologies AB
-- Date       : 2020.11.04
-------------------------------------------------------------------------------
-- Description: -- NoC switch Part of NoC simulation pkg
-- Switch settings:
-- 000   no switch
-- 001   broadcast
-- 010   shift 1 byte left
-- 011   shift 1 byte right
-- 100   shift 4 byte left	
-- 101   shift 8 bytes left
-- 110   shift 4 byte right	
-- 111   shift 8 byte right             
-------------------------------------------------------------------------------
-- TO-DO list :              
-------------------------------------------------------------------------------
-- Revisions  :
-- Date					Version		Author	Description
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.ACC_types.all;


entity Noc_Switch is
port (
        reset           : in  std_logic;
		switch_Input    : in  std_logic_vector(255 downto 0);
		switch_Out_en   : in  std_logic;
		decoder         : in  std_logic_vector(31 downto 0);
		switch_mux		: in  std_logic_vector(3 downto 0);
		switch_Out 		: out std_logic_vector(15 downto 0);
		NOC_bus         : out std_logic_vector(15 downto 0)
	);
end;


architecture struct of Noc_Switch is

	signal switch_mux_In   : switch_data_type;
	signal switch_bus	   : std_logic_vector(7 downto 0):= (others => '0');
	signal mux_out         : switch_mux_type;
	
begin

    switch_mux_In(0)    <= switch_Input(7 downto 0);
    switch_mux_In(1)    <= switch_Input(15 downto 8);
    switch_mux_In(2)    <= switch_Input(23 downto 16);
    switch_mux_In(3)    <= switch_Input(31 downto 24);
    switch_mux_In(4)    <= switch_Input(39 downto 32);
    switch_mux_In(5)    <= switch_Input(47 downto 40);
    switch_mux_In(6)    <= switch_Input(55 downto 48);
    switch_mux_In(7)    <= switch_Input(63 downto 56);
    switch_mux_In(8)    <= switch_Input(71 downto 64);
    switch_mux_In(9)    <= switch_Input(79 downto 72);
    switch_mux_In(10)   <= switch_Input(87 downto 80);
    switch_mux_In(11)   <= switch_Input(95 downto 88);
    switch_mux_In(12)   <= switch_Input(103 downto 96);
    switch_mux_In(13)   <= switch_Input(111 downto 104);
    switch_mux_In(14)   <= switch_Input(119 downto 112);
    switch_mux_In(15)   <= switch_Input(127 downto 120);
    switch_mux_In(16)   <= switch_Input(135 downto 128);
    switch_mux_In(17)   <= switch_Input(143 downto 136);
    switch_mux_In(18)   <= switch_Input(151 downto 144);
    switch_mux_In(19)   <= switch_Input(159 downto 152);
    switch_mux_In(20)   <= switch_Input(167 downto 160);
    switch_mux_In(21)   <= switch_Input(175 downto 168);
    switch_mux_In(22)   <= switch_Input(183 downto 176);
    switch_mux_In(23)   <= switch_Input(191 downto 184);
    switch_mux_In(24)   <= switch_Input(199 downto 192);
    switch_mux_In(25)   <= switch_Input(207 downto 200);
    switch_mux_In(26)   <= switch_Input(215 downto 208);
    switch_mux_In(27)   <= switch_Input(223 downto 216);
    switch_mux_In(28)   <= switch_Input(231 downto 224);
    switch_mux_In(29)   <= switch_Input(239 downto 232);
    switch_mux_In(30)   <= switch_Input(247 downto 240);
    switch_mux_In(31)   <= switch_Input(255 downto 248);   

	process (decoder,switch_mux_In)
    begin
		for i in 0 to 31 loop
			if decoder(i) ='1' then
				switch_bus <= switch_mux_In(i);
--			else 
--			 	switch_bus <= (others => '0');  --for removing inferring latch
			end if;
		end loop;
	end process;
	
	process (switch_mux,switch_bus,switch_mux_In,reset)
	begin
        if reset = '1' then
	        mux_out(0) <=(others => '0');
	        mux_out(1) <=(others => '0');
	    else    
            for i in 0 to 1 loop
                if switch_mux = "0000" then
                    mux_out(i) <= switch_mux_In(i);    
                elsif switch_mux = "0001" then
                    mux_out(i) <= switch_bus; ------------------------if it is changing at the same time it may be unstabel??
                elsif switch_mux = "0010" then
                    if (i > 0) then
                        mux_out(i) <= switch_mux_In(i-1);
                    else
                        mux_out(i) <=(others => '0');
                    end if;
                elsif switch_mux = "0011" then
                    if (i < 1) then
                        mux_out(i) <= switch_mux_In(i+1);
                    else
                        mux_out(i) <=(others => '0');
                    end if;	
                else			        	    							
                    mux_out(i) <=(others => '0');
                end if;
            end loop;
        end if;    
	end process;  
	
	NOC_bus    <= (mux_out(1) &  mux_out(0)) when switch_Out_en = '0' else (others => '0');
	switch_Out <= mux_out(1) &  mux_out(0);
	
--	process (switch_mux,switch_bus,switch_In)
--	begin
--		for i in 0 to 1 loop
--			if switch_mux = "0000" then
--				mux_out(i) <= switch_In(i);
--			elsif switch_mux = "0001" then
--				mux_out(i) <= switch_bus; ------------------------if it is changing at the same time it may be unstabel??
--			elsif switch_mux = "0010" then
--				if (i > 0) then
--					mux_out(i) <= switch_In(i-1);
--				else
--					mux_out(i) <=(others => '0');
--				end if;
--			elsif switch_mux = "0011" then
--			    mux_out(i) <= switch_In(i+1);
--			elsif switch_mux = "0100" then
--				mux_out(i) <=(others => '0');
--			elsif switch_mux = "0101" then
--				mux_out(i) <=(others => '0');
--			elsif switch_mux = "0110" then
--			    mux_out(i) <= switch_In(i+4);
--			elsif switch_mux = "0111" then
--				mux_out(i) <= switch_In(i+8);
--		    elsif switch_mux = "1000" then
--		        if (i = 0) then 
--		    	    mux_out(i) <= switch_In(i+1);
--		    	else
--		    	    mux_out(i) <= switch_In(i-1);
--		    	end if;
--		    elsif switch_mux = "1001" then	
--		        mux_out(i) <= switch_In(i+2);
--		    elsif switch_mux = "1010" then	
--		        mux_out(i) <= switch_In(i+4);
--		    elsif switch_mux = "1011" then	
--		        mux_out(i) <= switch_In(i+8);	
--		    elsif switch_mux = "1100" then	
--		        mux_out(i) <= switch_In(i+16);
--		    else 
--		        mux_out(i) <= (others => '0');	        	        		        	
--			end if;
--		end loop;		
--	end process;		
end;