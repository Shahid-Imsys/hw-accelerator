---------------------------------------------------
--DESIGNED BY MA NING
--there are two types of memory for application in this dual core processor

--              memory architecture    corresponding bit
--                  FLASH    128 KB           0
--                  RAM4      16 KB           5(seperate power)
--                  RAM3      16 KB           4      
--                  RAM2      16 KB           3      
--                  RAM1      16 KB           2      
--                  RAM0      16 KB           1
--                             
--memory space (4GB)

---------------------------------------------------
--7/22/2014 3:02:01 PM  only core1 can access flash
--6/12/2015 3:18:58 PM  modify to 128 kB flash + 64 kB RAM + 16 kB RAM   
--6/12/2015 4:42:12 PM  Core2 is able to access flash only at very low frequency mode (read_cycle = 0)
--8/31/2016 11:48:08 AM change rst_n to asynchronous
---------------------------------------------------
LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use work.gp_pkg.all;

ENTITY sdram_inf IS 
	PORT ( 
	    clk_p       : in std_logic;
	    clk_d_pos   : in std_logic;
	    clk_da_pos  : in std_logic;
	    rst_n       : in std_logic;
	    fast_d      : in std_logic;
		short_cycle : in std_logic; 
		-----core1 sdram interface
	    c1_d_addr   : in std_logic_vector(31 downto 0);
		c1_d_cs     : in std_logic;  -- CS to SDRAM
        c1_d_ras    : in std_logic;  -- RAS to SDRAM
        c1_d_cas    : in std_logic;  -- CAS to SDRAM
        c1_d_we     : in std_logic;  -- WE to SDRAM
        c1_d_dqi    : in  std_logic_vector(7 downto 0); -- Data in from processor
        c1_d_dqi_sd : in  std_logic_vector(7 downto 0); -- Data in from sdram
        c1_d_dqo    : out std_logic_vector(7 downto 0); -- Data out to processor
        -----core2 sdram interface
	    c2_d_addr   : in std_logic_vector(31 downto 0);
		c2_d_cs     : in std_logic;  -- CS to SDRAM
        c2_d_ras    : in std_logic;  -- RAS to SDRAM
        c2_d_cas    : in std_logic;  -- CAS to SDRAM
        c2_d_we     : in std_logic;  -- WE to SDRAM
        c2_d_dqi    : in  std_logic_vector(7 downto 0); -- Data in from processor
        c2_d_dqo    : out std_logic_vector(7 downto 0); -- Data out to processor
        --memory interface
        --flash
	    f_addr_in   : out std_logic_vector(16 downto 0);
        f_rd_in     : out std_logic;  -- low active
        f_wr_in     : out std_logic;  -- low active        
        f_data_in   : out  std_logic_vector(7 downto 0); -- Data in from processor
        f_data_out  : in std_logic_vector(7 downto 0); -- Data out to processor

        --RAM0 higher 1K address maybe used as patching address
        RAM0_DO     : in  std_logic_vector (7 downto 0);
        RAM0_DI     : out std_logic_vector (7 downto 0);
        RAM0_A      : out std_logic_vector (13 downto 0);
        RAM0_WEB    : out std_logic;
        RAM0_CS     : out std_logic;
        --RAM1 higher 1K address maybe used as patching address
        RAM1_DO     : in  std_logic_vector (7 downto 0);
        RAM1_DI     : out std_logic_vector (7 downto 0);
        RAM1_A      : out std_logic_vector (13 downto 0);
        RAM1_WEB    : out std_logic;
        RAM1_CS     : out std_logic;
        --RAM2
        RAM2_DO     : in  std_logic_vector (7 downto 0);
        RAM2_DI     : out std_logic_vector (7 downto 0);
        RAM2_A      : out std_logic_vector (13 downto 0);
        RAM2_WEB    : out std_logic;
        RAM2_CS     : out std_logic;
        --RAM3
        RAM3_DO     : in  std_logic_vector (7 downto 0);
        RAM3_DI     : out std_logic_vector (7 downto 0);
        RAM3_A      : out std_logic_vector (13 downto 0);
        RAM3_WEB    : out std_logic;
        RAM3_CS     : out std_logic;
        --RAM4
        RAM4_DO     : in  std_logic_vector (7 downto 0);
        RAM4_DI     : out std_logic_vector (7 downto 0);
        RAM4_A      : out std_logic_vector (13 downto 0);
        RAM4_WEB    : out std_logic;
        RAM4_CS     : out std_logic
		);
END sdram_inf;

ARCHITECTURE behav OF sdram_inf IS	

	signal c1_wr_n   : std_logic;
	signal c2_wr_n   : std_logic;
	signal c1_csb        : std_logic;
	signal c2_csb        : std_logic;
	signal exSD_en    : std_logic;
	signal c1_data_inner : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal c1_data_b1    : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal c1_data_b2    : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal c2_data_inner : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal c2_data_b1    : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal c2_data_b2    : STD_LOGIC_VECTOR (7 DOWNTO 0);

    signal toReq_c1     : std_logic_vector(MEMNUM - 1 downto 0);
    signal toReq_c2     : std_logic_vector(MEMNUM - 1 downto 0);
    signal data_en_c1     : std_logic_vector(MEMNUM - 1 downto 0);
    signal data_en_c2     : std_logic_vector(MEMNUM - 1 downto 0);
    signal valueZero     : std_logic_vector(MEMNUM - 1 downto 0);
    signal row_addr_1    : STD_LOGIC_VECTOR (17 DOWNTO 0);
	signal row_addr_2    : STD_LOGIC_VECTOR (17 DOWNTO 0);
BEGIN
    row_addr_1 <= c1_d_addr(31 downto 14);
    row_addr_2 <= c2_d_addr(31 downto 14);
    toReq_c1(0) <= '1'  WHEN row_addr_1 = FLSH_ADDR0 OR row_addr_1 = FLSH_ADDR1 OR row_addr_1 = FLSH_ADDR2 OR row_addr_1 = FLSH_ADDR3 or 
                             row_addr_1 = FLSH_ADDR4 OR row_addr_1 = FLSH_ADDR5 OR row_addr_1 = FLSH_ADDR6 OR row_addr_1 = FLSH_ADDR7 ELSE '0';
    toReq_c1(1) <= '1'  WHEN row_addr_1 = RAM0_ADDR ELSE '0';
    toReq_c1(2) <= '1'  WHEN row_addr_1 = RAM1_ADDR ELSE '0';
    toReq_c1(3) <= '1'  WHEN row_addr_1 = RAM2_ADDR ELSE '0';
    toReq_c1(4) <= '1'  WHEN row_addr_1 = RAM3_ADDR ELSE '0';
    toReq_c1(5) <= '1'  WHEN row_addr_1 = RAM4_ADDR ELSE '0';
                
    toReq_c2(0) <= '1'  WHEN row_addr_2 = FLSH_ADDR0 OR row_addr_2 = FLSH_ADDR1 OR row_addr_2 = FLSH_ADDR2 OR row_addr_2 = FLSH_ADDR3 or 
                             row_addr_2 = FLSH_ADDR4 OR row_addr_2 = FLSH_ADDR5 OR row_addr_2 = FLSH_ADDR6 OR row_addr_2 = FLSH_ADDR7 ELSE '0';
    toReq_c2(1) <= '1'  WHEN row_addr_2 = RAM0_ADDR ELSE '0';
    toReq_c2(2) <= '1'  WHEN row_addr_2 = RAM1_ADDR ELSE '0';
    toReq_c2(3) <= '1'  WHEN row_addr_2 = RAM2_ADDR ELSE '0';
    toReq_c2(4) <= '1'  WHEN row_addr_2 = RAM3_ADDR ELSE '0';
    toReq_c2(5) <= '1'  WHEN row_addr_2 = RAM4_ADDR ELSE '0';
    
    valueZero <= (others => '0');
	process (clk_p, rst_n)
	begin
	    if rst_n = '0' then
	        c1_data_b1 <= x"00";
	        c1_data_b2 <= x"00";
	        data_en_c1 <= (others => '0');
	        exSD_en <= '0';
	    elsif (rising_edge(clk_p)) then
	        if clk_d_pos = '0' then--rising_edge(clk_d)
		        if (data_en_c1 /= valueZero) then
		            c1_data_b1 <= c1_data_inner;
		        end if;
		        c1_data_b2 <= c1_data_b1;
		        if (c1_csb = '0') then
		            data_en_c1 <= toReq_c1;
		            if (toReq_c1 = valueZero) then
		                exSD_en <= '1';
		            ELSE
		                exSD_en <= '0';
		            end if;
--		        else
--		            data_en_c1 <= (others => '0');
		        end if;
		    end if;
		end if;
	end process;
	
	process (clk_p, rst_n)
	begin
	    if rst_n = '0' then
	        c2_data_b1 <= x"00";
	        c2_data_b2 <= x"00";
	        data_en_c2 <= (others => '0');
		elsif (rising_edge(clk_p)) then
	        if clk_da_pos = '0' then--rising_edge(clk_d)
		        if (data_en_c2 /= valueZero) then
		            c2_data_b1 <= c2_data_inner;
		        end if;
		        c2_data_b2 <= c2_data_b1;
		        if (c2_csb = '0') then
		            data_en_c2 <= toReq_c2;
--		        else 
--		            data_en_c2 <= (others => '0');
		        end if; 
		    end if;
		end if;
	end process;        
	c1_d_dqo <= c1_d_dqi_sd WHEN exSD_en = '1' ELSE
	            c1_data_inner WHEN short_cycle = '1' ELSE
	            c1_data_b1  WHEN fast_d = '0' ELSE
	            c1_data_b2;
	c2_d_dqo <= c2_data_inner WHEN short_cycle = '1' ELSE
	            c2_data_b1  WHEN fast_d = '0' ELSE
	            c2_data_b2;
	
    c1_data_inner <= f_data_out WHEN data_en_c1(0) = '1'          ELSE  --read flash
	                 RAM0_DO    WHEN data_en_c1(1) = '1'          ELSE  --read RAM0
	                 RAM1_DO    WHEN data_en_c1(2) = '1'          ELSE  --read RAM1
	                 RAM2_DO    WHEN data_en_c1(3) = '1'          ELSE  --read RAM2
	                 RAM3_DO    WHEN data_en_c1(4) = '1'          ELSE  --read RAM3 
	                 RAM4_DO    WHEN data_en_c1(5) = '1'          ELSE  --read RAM4
	                 c1_d_dqi;  
    c2_data_inner <= --f_data_out WHEN data_en_c2(0) = '1'          ELSE  --read flash 
                     RAM0_DO    WHEN data_en_c2(1) = '1'          ELSE  --read RAM0
	                 RAM1_DO    WHEN data_en_c2(2) = '1'          ELSE  --read RAM1
	                 RAM2_DO    WHEN data_en_c2(3) = '1'          ELSE  --read RAM2
	                 RAM3_DO    WHEN data_en_c2(4) = '1'          ELSE  --read RAM3 
	                 RAM4_DO    WHEN data_en_c2(5) = '1'          ELSE  --read RAM4
	                 c2_d_dqi; 

    c1_csb <= c1_d_cs OR (NOT c1_d_ras) OR c1_d_cas;
    c2_csb <= c2_d_cs OR (NOT c2_d_ras) OR c2_d_cas;

	c1_wr_n <= c1_d_cs OR (NOT c1_d_ras) OR c1_d_cas OR c1_d_we;
	c2_wr_n <= c2_d_cs OR (NOT c2_d_ras) OR c2_d_cas OR c2_d_we;
-----------------------flash----------------------       index is 0
    f_addr_in   <= c1_d_addr(16 downto 0);    
    f_rd_in     <=  (c1_csb OR (NOT c1_d_we) OR (NOT toReq_c1(0)));
    f_wr_in     <=                  (c1_wr_n OR (NOT toReq_c1(0)));
    f_data_in   <= c1_d_dqi;
-----------------------RAM0----------------------       index is 1
    RAM0_DI     <= c2_d_dqi                     WHEN toReq_c2(1) = '1' and c2_csb = '0' ELSE  c1_d_dqi;
    RAM0_A      <= c2_d_addr(13 downto 0)       WHEN toReq_c2(1) = '1' and c2_csb = '0' ELSE  c1_d_addr(13 downto 0);                                                         --core1 use RAM1
    RAM0_WEB    <=                  (c1_wr_n OR (NOT toReq_c1(1))) 
                                AND (c2_wr_n OR (NOT toReq_c2(1)));
    RAM0_CS    <=               NOT ((c1_csb OR (NOT toReq_c1(1))) AND (c2_csb OR (NOT toReq_c2(1))) );
-----------------------RAM1----------------------       index is 2
    RAM1_DI     <= c2_d_dqi                     WHEN toReq_c2(2) = '1' and c2_csb = '0' ELSE  c1_d_dqi;
    RAM1_A      <= c2_d_addr(13 downto 0)       WHEN toReq_c2(2) = '1' and c2_csb = '0' ELSE  c1_d_addr(13 downto 0);                                                         --core1 use RAM1
    RAM1_WEB    <=                  (c1_wr_n OR (NOT toReq_c1(2))) 
                                AND (c2_wr_n OR (NOT toReq_c2(2)));
    RAM1_CS    <=              NOT ( (c1_csb OR (NOT toReq_c1(2))) AND (c2_csb OR (NOT toReq_c2(2))) );
-----------------------RAM2----------------------       index is 3
    RAM2_DI     <= c2_d_dqi                     WHEN toReq_c2(3) = '1' and c2_csb = '0' ELSE  c1_d_dqi;
    RAM2_A      <= c2_d_addr(13 downto 0)       WHEN toReq_c2(3) = '1' and c2_csb = '0' ELSE  c1_d_addr(13 downto 0);                                                         --core1 use RAM1
    RAM2_WEB    <=                  (c1_wr_n OR (NOT toReq_c1(3))) 
                                AND (c2_wr_n OR (NOT toReq_c2(3)));
    RAM2_CS    <=              NOT ( (c1_csb OR (NOT toReq_c1(3))) AND (c2_csb OR (NOT toReq_c2(3))) );               
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------RAM3----------------------       index is 4
    RAM3_DI     <= c2_d_dqi                     WHEN toReq_c2(4) = '1' and c2_csb = '0' ELSE  c1_d_dqi;
    RAM3_A      <= c2_d_addr(13 downto 0)       WHEN toReq_c2(4) = '1' and c2_csb = '0' ELSE  c1_d_addr(13 downto 0);                                                         --core1 use RAM1
    RAM3_WEB    <=                  (c1_wr_n OR (NOT toReq_c1(4))) 
                                AND (c2_wr_n OR (NOT toReq_c2(4)));
    RAM3_CS    <=              NOT ( (c1_csb OR (NOT toReq_c1(4))) AND (c2_csb OR (NOT toReq_c2(4))) );               
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------RAM4----------------------       index is 5
    RAM4_DI     <= c2_d_dqi                     WHEN toReq_c2(5) = '1' and c2_csb = '0' ELSE  c1_d_dqi;
    RAM4_A      <= c2_d_addr(13 downto 0)       WHEN toReq_c2(5) = '1' and c2_csb = '0' ELSE  c1_d_addr(13 downto 0);                                                         --core1 use RAM1
    RAM4_WEB    <=                  (c1_wr_n OR (NOT toReq_c1(5))) 
                                AND (c2_wr_n OR (NOT toReq_c2(5)));
    RAM4_CS    <=              NOT ( (c1_csb OR (NOT toReq_c1(5))) AND (c2_csb OR (NOT toReq_c2(5))) );               
-----------------------------------------------------------------------------------------------------------------------------------------      
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	
END behav;
