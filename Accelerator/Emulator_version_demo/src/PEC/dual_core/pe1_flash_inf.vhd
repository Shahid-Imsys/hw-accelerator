---------------------------------------------------
--DESIGNED BY MA NING
--flash mode:
--0:idle        --idle is used between two commands!!!!
--1:read
--2:write
--3:program
--4:page erase
--5:sector erase
--6:mass erase
--7:low standy by
--8:parameter register read/write
-- the erase operation is only performed by writing 5A to address A5!!!!!!!!!
---------------------------------------------------
--7/18/2014 1:38:04 PM initial version for flash interface
--6/15/2015 1:31:11 PM change flash size to 128 kB, add slow_mode for use flash data directly
--7/08/2015            remove slow_mode signal, since it's not needed, if the read_cycles is 0, the flash will not hold the clk_e
--8/10/2015 3:30:03 PM MN change read_cycles default value to 4
--8/31/2016 11:45:40 AM MN change rst_cn to asynchronous reset
---------------------------------------------------
LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use work.pe1_gp_pkg.all;

ENTITY pe1_flash_inf IS
	PORT (
	    clk_p       : in std_logic;
		even_c		: in std_logic;
	    rst_cn      : in std_logic;

	    flash_en    : in std_logic;-- flash enable
	    flash_mode  : in std_logic_vector(3 downto 0);--flash mode
	    out_line    : in std_logic;--line is changed by detecting adl and M operation
	    hold_flash  : out std_logic;
	    hold_flash_d: out std_logic;--hold flash for clock d

	    addr_in     : in std_logic_vector(16 downto 0);
        rd_in       : in std_logic;  -- low active
        wr_in       : in std_logic;  -- low active
        data_in     : in  std_logic_vector(7 downto 0); -- Data in from processor
        data_out    : out std_logic_vector(7 downto 0); -- Data out to processor
		ld_dqi_flash: out std_logic;

        CE          : out std_logic;
        ADDR        : out std_logic_vector(12 downto 0);
        WRONLY      : out std_logic;
        PERASE      : out std_logic;
        SERASE      : out std_logic;
        MERASE      : out std_logic;
        PROG        : out std_logic;
        INF         : out std_logic;
        POR         : out std_logic;
        SAVEN       : out std_logic;
        TM          : out std_logic_vector(3 downto 0);
        DATA_WR     : out std_logic_vector(31 downto 0);
        f0_ALE      : out std_logic;
        --f0_PVPP     : inout std_logic;
        f0_DATA_IN  : in std_logic_vector(31 downto 0);
        f0_RBB      : in std_logic;
        f1_ALE      : out std_logic;
        --f1_PVPP     : inout std_logic;
        f1_DATA_IN  : in std_logic_vector(31 downto 0);
        f1_RBB      : in std_logic;
        f2_ALE      : out std_logic;
        --f2_PVPP     : inout std_logic;
        f2_DATA_IN  : in std_logic_vector(31 downto 0);
        f2_RBB      : in std_logic;
        f3_ALE      : out std_logic;
        --f3_PVPP     : inout std_logic;
        f3_DATA_IN  : in std_logic_vector(31 downto 0);
        f3_RBB      : in std_logic--;
--        f4_ALE      : out std_logic;
--        --f4_PVPP     : inout std_logic;
--        f4_DATA_IN  : in std_logic_vector(31 downto 0);
--        f4_RBB      : in std_logic;
--        f5_ALE      : out std_logic;
--        --f5_PVPP     : inout std_logic;
--        f5_DATA_IN  : in std_logic_vector(31 downto 0);
--        f5_RBB      : in std_logic;
--        f6_ALE      : out std_logic;
--        --f6_PVPP     : inout std_logic;
--        f6_DATA_IN  : in std_logic_vector(31 downto 0);
--        f6_RBB      : in std_logic;
--        f7_ALE      : out std_logic;
--        --f7_PVPP     : inout std_logic;
--        f7_DATA_IN  : in std_logic_vector(31 downto 0);
--        f7_RBB      : in std_logic

		);
END pe1_flash_inf;

ARCHITECTURE behav OF pe1_flash_inf IS

    signal idle             : STD_LOGIC;
	signal read_en          : STD_LOGIC;
	signal write_en         : STD_LOGIC;
	signal program_en       : STD_LOGIC;
	signal perase_en        : STD_LOGIC;
	signal serase_en        : STD_LOGIC;
	signal merase_en        : STD_LOGIC;

	signal low_standy       : STD_LOGIC;
	signal para_en          : STD_LOGIC;
	signal rd_ale           : STD_LOGIC;
	signal wr_ale           : STD_LOGIC;

	signal test_mode        : STD_LOGIC_VECTOR (4 DOWNTO 0);--INF, TM[3:0]
    signal read_cycles      : STD_LOGIC_VECTOR (3 DOWNTO 0);
    signal read_cnt         : STD_LOGIC_VECTOR (3 DOWNTO 0);

	--signal addr_sel    		: STD_LOGIC_VECTOR (4 DOWNTO 0);--
	signal addr_sel    		: STD_LOGIC_VECTOR (3 DOWNTO 0);--
    signal data_out_int    : STD_LOGIC_VECTOR (7 DOWNTO 0);--data buffer for reading
    signal data_reg3        : STD_LOGIC_VECTOR (7 DOWNTO 0);--data buffer for first data
    signal data_reg2        : STD_LOGIC_VECTOR (7 DOWNTO 0);--data buffer for second data
    signal data_reg1        : STD_LOGIC_VECTOR (7 DOWNTO 0);--data buffer for third data

	signal CE_int      		: std_logic;
	signal hold_flash_int	: std_logic;
	signal hold_flash_pre   : std_logic;
	signal WRONLY_int      	: std_logic;
    signal PERASE_int      	: std_logic;
    signal SERASE_int      	: std_logic;
    signal MERASE_int      	: std_logic;
    signal PROG_int        	: std_logic;
	signal wrf_en		   	: std_logic;
	signal erase_en		   	: std_logic;
--	signal slow_mode        : std_logic;--in this mode, clock is slow enough to read flash data in next cycle
BEGIN
    --ENABLE parsing
    idle        <= '1' WHEN flash_mode 	= "0000" and flash_en = '1' ELSE '0';
    read_en     <= '1' WHEN flash_mode 	= "0001" and flash_en = '1' ELSE '0';
    write_en    <= '1' WHEN flash_mode 	= "0010" and flash_en = '1' ELSE '0';
    program_en  <= '1' WHEN flash_mode 	= "0011" and flash_en = '1' ELSE '0';
    perase_en   <= '1' WHEN flash_mode 	= "0100" and flash_en = '1' ELSE '0';
    serase_en   <= '1' WHEN flash_mode 	= "0101" and flash_en = '1' ELSE '0';
    merase_en   <= '1' WHEN flash_mode 	= "0110" and flash_en = '1' ELSE '0';
    low_standy  <= '1' WHEN flash_mode 	= "0111" and flash_en = '1' ELSE '0';
    para_en     <= '1' WHEN flash_mode 	= "1000" and flash_en = '1' ELSE '0';
--    slow_mode   <= '1' WHEN read_cycles = "0000" ELSE '0';
    --flash parameter register configuration
    process (clk_p, rst_cn)
	begin
	    if rst_cn = '0' then
	        test_mode <= (others => '0');
	        read_cycles <= "0100";   --change default value to 4
	    elsif (rising_edge(clk_p)) then
	        if para_en = '1' then--rising_edge(clk_d)
		        if (addr_in(7 DOWNTO 0) = x"00") AND wr_in = '0' then
		            test_mode <= data_in(4 DOWNTO 0);
		        end if;
		        if (addr_in(7 DOWNTO 0) = x"01") AND wr_in = '0' then
		            read_cycles <= data_in(3 DOWNTO 0);
		        end if;
		    end if;
		end if;
	end process;
    --hold signal generated when reading
    process (clk_p, rst_cn)
	begin
	    if rst_cn = '0' then
	        read_cnt <= (others => '0');
	    elsif (rising_edge(clk_p)) then
	        if even_c = '1' and read_cnt /= x"0" then
		        read_cnt <= read_cnt - '1';
		    elsif even_c = '1' and read_en = '1' and hold_flash_int = '0' then--
		        if rd_in = '0' and out_line = '1' then
		            read_cnt <= read_cycles;
		        end if;
		    end if;
		end if;
	end process;

    hold_flash_pre <= read_en and even_c and (not rd_in) and out_line when  read_cycles /= x"0" else
                      '0';
    hold_flash_int <= '1' when read_cnt /= x"0" else '0';--waiting for reading data
    hold_flash_d <= hold_flash_int;
    hold_flash <= hold_flash_int or hold_flash_pre;
	ld_dqi_flash <= '1' when read_cnt = x"1" else '0';
    --generate ale from rd_in or wr_in
    process (clk_p, rst_cn)
	begin
	    if rst_cn = '0' then
	        rd_ale <= '0';
			wr_ale <= '0';
	    elsif (rising_edge(clk_p)) then
	       if CE_int = '1' and hold_flash_int = '0' then--
				if (read_en = '1') then
					if (rd_in = '0' and out_line = '1') then--one line is only needed to read once
						rd_ale <= '1';
					else
						rd_ale <= '0';
					end if;
				elsif (rd_in = '0') then
					rd_ale <= '1';
				else
					rd_ale <= '0';
				end if;
		        if (wr_in = '0') then
					wr_ale <= '1';
				else
					wr_ale <= '0';
				end if;
			else
				rd_ale <= '0';
				wr_ale <= '0';
		    end if;
		end if;
	end process;

	--buffer data for write
	process (clk_p, rst_cn)
	begin
	    if rst_cn = '0' then
	        data_reg1 <= (others => '0');
	        data_reg2 <= (others => '0');
	        data_reg3 <= (others => '0');
		elsif (rising_edge(clk_p)) then
	        if (write_en = '1' or program_en = '1') and wr_in = '0' then--rising_edge(clk_d)
		        if addr_in(1 DOWNTO 0) = "00" then
		            data_reg1 <= data_in;
		        end if;
		        if addr_in(1 DOWNTO 0) = "01" then
		            data_reg2 <= data_in;
		        end if;
		        if addr_in(1 DOWNTO 0) = "10" then
		            data_reg3 <= data_in;
		        end if;
		    end if;
		end if;
	end process;
	-------------------------------------
	--data in
	-------------------------------------
	--address buffer
	process (clk_p, rst_cn)
	begin
	    if rst_cn = '0' then
	        addr_sel <= (others => '0');
		elsif (rising_edge(clk_p)) then
	        if rd_in = '0' and read_en = '1' then--rising_edge(clk_d)
		        --addr_sel <= addr_in(4 DOWNTO 0);
		        addr_sel <= addr_in(3 DOWNTO 0);
		    end if;
		end if;
	end process;

	process (addr_sel, f0_DATA_IN, f1_DATA_IN, f2_DATA_IN, f3_DATA_IN)--, f4_DATA_IN, f5_DATA_IN, f6_DATA_IN, f7_DATA_IN)
	begin
	    case addr_sel is
            when "0000" => data_out_int <= f0_DATA_IN(7 DOWNTO 0);
            when "0001" => data_out_int <= f0_DATA_IN(15 DOWNTO 8);
            when "0010" => data_out_int <= f0_DATA_IN(23 DOWNTO 16);
            when "0011" => data_out_int <= f0_DATA_IN(31 DOWNTO 24);
            when "0100" => data_out_int <= f1_DATA_IN(7 DOWNTO 0);
            when "0101" => data_out_int <= f1_DATA_IN(15 DOWNTO 8);
            when "0110" => data_out_int <= f1_DATA_IN(23 DOWNTO 16);
            when "0111" => data_out_int <= f1_DATA_IN(31 DOWNTO 24);
            when "1000" => data_out_int <= f2_DATA_IN(7 DOWNTO 0);
            when "1001" => data_out_int <= f2_DATA_IN(15 DOWNTO 8);
            when "1010" => data_out_int <= f2_DATA_IN(23 DOWNTO 16);
            when "1011" => data_out_int <= f2_DATA_IN(31 DOWNTO 24);
            when "1100" => data_out_int <= f3_DATA_IN(7 DOWNTO 0);
            when "1101" => data_out_int <= f3_DATA_IN(15 DOWNTO 8);
            when "1110" => data_out_int <= f3_DATA_IN(23 DOWNTO 16);
            when others => data_out_int <= f3_DATA_IN(31 DOWNTO 24);
--            when "01111" => data_out_int <= f3_DATA_IN(31 DOWNTO 24);
--            when "10000" => data_out_int <= f4_DATA_IN(7 DOWNTO 0);
--            when "10001" => data_out_int <= f4_DATA_IN(15 DOWNTO 8);
--            when "10010" => data_out_int <= f4_DATA_IN(23 DOWNTO 16);
--            when "10011" => data_out_int <= f4_DATA_IN(31 DOWNTO 24);
--            when "10100" => data_out_int <= f5_DATA_IN(7 DOWNTO 0);
--            when "10101" => data_out_int <= f5_DATA_IN(15 DOWNTO 8);
--            when "10110" => data_out_int <= f5_DATA_IN(23 DOWNTO 16);
--            when "10111" => data_out_int <= f5_DATA_IN(31 DOWNTO 24);
--            when "11000" => data_out_int <= f6_DATA_IN(7 DOWNTO 0);
--            when "11001" => data_out_int <= f6_DATA_IN(15 DOWNTO 8);
--            when "11010" => data_out_int <= f6_DATA_IN(23 DOWNTO 16);
--            when "11011" => data_out_int <= f6_DATA_IN(31 DOWNTO 24);
--            when "11100" => data_out_int <= f7_DATA_IN(7 DOWNTO 0);
--            when "11101" => data_out_int <= f7_DATA_IN(15 DOWNTO 8);
--            when "11110" => data_out_int <= f7_DATA_IN(23 DOWNTO 16);
--            when others => data_out_int <= f7_DATA_IN(31 DOWNTO 24);
        end case;
	end process;

    data_out <= --f7_RBB & f6_RBB & f5_RBB & f4_RBB & f3_RBB & f2_RBB & f1_RBB & f0_RBB when para_en = '1' else
	            "0000" & f3_RBB & f2_RBB & f1_RBB & f0_RBB when para_en = '1' else
	            data_out_int ;
    -------------------------------------
    --flash signals
    -------------------------------------
    CE_int      <= read_en or write_en or program_en or perase_en or serase_en or merase_en;
    ADDR    <= addr_in (16 DOWNTO 4);
    WRONLY_int  <= '1' when write_en = '1'      and addr_in(1 downto 0) = "11"                      else '0';--the first three bytes should be bufferred
    PROG_int    <= '1' when program_en = '1'    and addr_in(1 downto 0) = "11"                      else '0';--active only when four bytes are ready
    PERASE_int  <= '1' when perase_en = '1'     and addr_in(7 DOWNTO 0) = x"A5" and data_in = x"5A" else '0';--to avoid miss erase
    SERASE_int  <= '1' when serase_en = '1'     and addr_in(7 DOWNTO 0) = x"A5" and data_in = x"5A" else '0';
    MERASE_int  <= '1' when merase_en = '1'     and addr_in(7 DOWNTO 0) = x"A5" and data_in = x"5A" else '0';
	wrf_en <= WRONLY_int OR PROG_int;
	erase_en <= PERASE_int OR SERASE_int OR MERASE_int;
    INF     <= test_mode(4);
    POR     <= rst_cn;
    SAVEN   <= low_standy;
    TM      <= test_mode(3 DOWNTO 0);
	DATA_WR <= data_in & data_reg3 & data_reg2 & data_reg1;
    f0_ALE  <=  rd_ale when read_en = '1' else--and (addr_in(3 DOWNTO 2) = "00" or slow_mode = '0') else--read enable when flash is selected or in fast mode (all flash will be read)
				wr_ale when erase_en = '1' else
                wr_ale when addr_in(3 DOWNTO 2) = "00" and wrf_en = '1' else
				rd_ale when addr_in(3 DOWNTO 2) = "00" and (write_en = '1' or program_en = '1') else			--for command end in write or program mode
                '0';
    f1_ALE  <=  rd_ale when read_en = '1' else--and (addr_in(3 DOWNTO 2) = "01" or slow_mode = '0') else--read enable when flash is selected or in fast mode (all flash will be read)
				wr_ale when erase_en = '1' else
                wr_ale when addr_in(3 DOWNTO 2) = "01" and wrf_en = '1' else
				rd_ale when addr_in(3 DOWNTO 2) = "01" and (write_en = '1' or program_en = '1') else			--for command end in write or program mode
                '0';
    f2_ALE  <=  rd_ale when read_en = '1' else--and (addr_in(3 DOWNTO 2) = "10" or slow_mode = '0') else--read enable when flash is selected or in fast mode (all flash will be read)
				wr_ale when erase_en = '1' else
                wr_ale when addr_in(3 DOWNTO 2) = "10" and wrf_en = '1' else
				rd_ale when addr_in(3 DOWNTO 2) = "10" and (write_en = '1' or program_en = '1') else			--for command end in write or program mode
                '0';
    f3_ALE  <=  rd_ale when read_en = '1' else--and (addr_in(3 DOWNTO 2) = "11" or slow_mode = '0') else--read enable when flash is selected or in fast mode (all flash will be read)
				wr_ale when erase_en = '1' else
                wr_ale when addr_in(3 DOWNTO 2) = "11" and wrf_en = '1' else
				rd_ale when addr_in(3 DOWNTO 2) = "11" and (write_en = '1' or program_en = '1') else			--for command end in write or program mode
                '0';
--    f4_ALE  <=  rd_ale when read_en = '1' else
--				wr_ale when erase_en = '1' else
--                wr_ale when addr_in(4 DOWNTO 2) = "100" and wrf_en = '1' else
--				rd_ale when addr_in(4 DOWNTO 2) = "100" and (write_en = '1' or program_en = '1') else			--for command end in write or program mode
--                '0';
--    f5_ALE  <=  rd_ale when read_en = '1' else
--				wr_ale when erase_en = '1' else
--                wr_ale when addr_in(4 DOWNTO 2) = "101" and wrf_en = '1' else
--				rd_ale when addr_in(4 DOWNTO 2) = "101" and (write_en = '1' or program_en = '1') else			--for command end in write or program mode
--                '0';
--    f6_ALE  <=  rd_ale when read_en = '1' else
--				wr_ale when erase_en = '1' else
--                wr_ale when addr_in(4 DOWNTO 2) = "110" and wrf_en = '1' else
--				rd_ale when addr_in(4 DOWNTO 2) = "110" and (write_en = '1' or program_en = '1') else			--for command end in write or program mode
--                '0';
--    f7_ALE  <=  rd_ale when read_en = '1' else
--				wr_ale when erase_en = '1' else
--                wr_ale when addr_in(4 DOWNTO 2) = "111" and wrf_en = '1' else
--				rd_ale when addr_in(4 DOWNTO 2) = "111" and (write_en = '1' or program_en = '1') else			--for command end in write or program mode
--                '0';
	CE 		<= CE_int;
	WRONLY 	<= WRONLY_int;
	PROG   	<= PROG_int  ;
	PERASE 	<= PERASE_int;
    SERASE 	<= SERASE_int;
	MERASE 	<= MERASE_int;

END behav;