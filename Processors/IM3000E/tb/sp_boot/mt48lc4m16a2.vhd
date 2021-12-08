-----------------------------------------------------------------------------------------
--
--     File Name: MT48LC4M16A2.VHD
--       Version: 0.0f
--          Date: July 8th, 1999
--         Model: Behavioral
--     Simulator: Model Technology (PC version 5.2e PE)
--
--  Dependencies: None
--
--        Author: Son P. Huynh
--         Email: sphuynh@micron.com
--         Phone: (208) 368-3825
--       Company: Micron Technology, Inc.
--   Part Number: MT48LC4M16A2 (1Mb x 16 x 4 Banks)
--
--   Description: Micron 64Mb SDRAM
--
--    Limitation: - Doesn't check for 4096-cycle refresh
--
--          Note: - Set simulator resolution to "ps" accuracy
--
--    Disclaimer: THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY 
--                WHATSOEVER AND MICRON SPECIFICALLY DISCLAIMS ANY 
--                IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR
--                A PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
--
--                Copyright (c) 1998 Micron Semiconductor Products, Inc.
--                All rights researved
--
--  Rev   Author          Phone         Date        Changes
--  ----  ----------------------------  ----------  -------------------------------------
--  0.0f  Son Huynh       208-368-3825  07/08/1999  Fix tWR = 1 Clk + 7.5 ns (Auto)
--        Micron Technology Inc.                    Fix tWR = 15 ns (Manual)
--                                                  Fix tRP (Autoprecharge to AutoRefresh)
--
--  0.0e  Son P. Huynh    208-368-3825  05/25/1999  Fix R/W Interrupting R/W with AP
--        Micron Technology Inc.
--
--  0.0d  Son P. Huynh    208-368-3825  04/08/1999  Fix tWR + tRP in Write with AP
--        Micron Technology Inc.
--
--  0.0c  Son P. Huynh    208-368-3825  01/14/1998  Add Load / Unload memory array
--        Micron Technology Inc.
--
--  0.0b  Son P. Huynh    208-368-3825  12/09/1998  Fix some timing check problem
--        Micron Technology Inc.                    - Improve model functionality
--
--  0.0a  Son P. Huynh    208-368-3825  08/10/1998  First Release
--        Micron Technology Inc.                    - Simple testbench included
-----------------------------------------------------------------------------------------

LIBRARY std;
    USE std.textio.ALL;
LIBRARY ieee;
    USE ieee.std_logic_1164.ALL;
LIBRARY work;
    USE work.io_utils.ALL;
    USE work.mti_pkg.ALL;

ENTITY mt48lc4m16a2 IS
    GENERIC (
        -- Timing Parameters for -75 (PC133) and CAS Latency = 2
        tAC       : TIME    :=  6.0 ns;
        tHZ       : TIME    :=  7.0 ns;
        tOH       : TIME    :=  2.7 ns;
        tMRD      : INTEGER :=  2;          -- 2 Clk Cycles
        tRAS      : TIME    := 44.0 ns;
        tRC       : TIME    := 66.0 ns;
        tRCD      : TIME    := 20.0 ns;
        tRP       : TIME    := 20.0 ns;
        tRRD      : TIME    := 15.0 ns;
        tWRa      : TIME    :=  7.5 ns;     -- A2 Version - Auto precharge mode only (1 Clk + 7.5 ns)
        tWRp      : TIME    := 15.0 ns;     -- A2 Version - Precharge mode only (15 ns)

        tAH       : TIME    :=  0.8 ns;
        tAS       : TIME    :=  1.5 ns;
        tCH       : TIME    :=  2.5 ns;
        tCL       : TIME    :=  2.5 ns;
        tCK       : TIME    := 10.0 ns;
        tDH       : TIME    :=  0.8 ns;
        tDS       : TIME    :=  1.5 ns;
        tCKH      : TIME    :=  0.8 ns;
        tCKS      : TIME    :=  1.5 ns;
        tCMH      : TIME    :=  0.8 ns;
        tCMS      : TIME    :=  1.5 ns;

        addr_bits : INTEGER := 12;
        data_bits : INTEGER := 16;
        col_bits  : INTEGER :=  8
    );
    PORT (
        Dq        : INOUT STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0) := (OTHERS => 'Z');
        Addr      : IN    STD_LOGIC_VECTOR (addr_bits - 1 DOWNTO 0) := (OTHERS => '0');
        Ba        : IN    STD_LOGIC_VECTOR := "00";
        Clk       : IN    STD_LOGIC := '0';
        Cke       : IN    STD_LOGIC := '1';
        Cs_n      : IN    STD_LOGIC := '1';
        Ras_n     : IN    STD_LOGIC := '1';
        Cas_n     : IN    STD_LOGIC := '1';
        We_n      : IN    STD_LOGIC := '1';
        Dqm       : IN    STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
        Load      : IN    STD_LOGIC := '0';
        Unload    : IN    STD_LOGIC := '0';
        Row_start : IN    INTEGER   :=  0;
        Row_end   : IN    INTEGER   :=  0
    );
END mt48lc4m16a2;

ARCHITECTURE behave OF mt48lc4m16a2 IS
    TYPE   State       IS (ACT, A_REF, BST, LMR, NOP, PRECH, READ, READ_A, WRITE, WRITE_A, FILE_LOAD, FILE_UNLOAD);
    TYPE   Array4xI    IS ARRAY (3 DOWNTO 0) OF INTEGER;
    TYPE   Array4xT    IS ARRAY (3 DOWNTO 0) OF TIME;
    TYPE   Array4xB    IS ARRAY (3 DOWNTO 0) OF BIT;
    TYPE   Array4x2BV  IS ARRAY (3 DOWNTO 0) OF BIT_VECTOR (1 DOWNTO 0);
    TYPE   Array4xCBV  IS ARRAY (4 DOWNTO 0) OF BIT_VECTOR (Col_bits - 1 DOWNTO 0);
    TYPE   Array_state IS ARRAY (4 DOWNTO 0) OF State;
    SIGNAL Operation : State := NOP;
    SIGNAL Mode_reg : BIT_VECTOR (addr_bits - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Active_enable, Aref_enable, Burst_term : BIT := '0';
    SIGNAL Mode_reg_enable, Prech_enable, Read_enable, Write_enable : BIT := '0';
    SIGNAL Burst_length_1, Burst_length_2, Burst_length_4, Burst_length_8 : BIT := '0';
    SIGNAL Cas_latency_2, Cas_latency_3 : BIT := '0';
    SIGNAL Ras_in, Cas_in, We_in : BIT := '0';
    SIGNAL Write_burst_mode : BIT := '0';
    SIGNAL Sys_clk, CkeZ : BIT := '0';
    SIGNAL WR_counter : Array4xI := (0 & 0 & 0 & 0);

    -- Checking internal wires
    SIGNAL Pre_chk : BIT_VECTOR (3 DOWNTO 0) := "0000";
    SIGNAL Act_chk : BIT_VECTOR (3 DOWNTO 0) := "0000";
    SIGNAL Dq_in_chk, Dq_out_chk : BIT := '0';
    SIGNAL Bank_chk : BIT_VECTOR (1 DOWNTO 0) := "00";
    SIGNAL Row_chk : BIT_VECTOR (addr_bits - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Col_chk : BIT_VECTOR (col_bits - 1 DOWNTO 0) := (OTHERS => '0');

    -- debug
    signal DQ_tmp : std_logic_vector(data_bits-1 downto 0);
    
    BEGIN
      -- debug
      DQ_tmp <= Dq;
      
        -- CS# Decode
        WITH Cs_n SELECT
            Cas_in <= TO_BIT (Cas_n, '1') WHEN '0',
                      '1' WHEN '1',
                      '1' WHEN OTHERS;
        WITH Cs_n SELECT
            Ras_in <= TO_BIT (Ras_n, '1') WHEN '0',
                      '1' WHEN '1',
                      '1' WHEN OTHERS;
        WITH Cs_n SELECT
            We_in  <= TO_BIT (We_n,  '1') WHEN '0',
                      '1' WHEN '1',
                      '1' WHEN OTHERS;

        -- Commands Decode
        Active_enable   <= NOT(Ras_in) AND     Cas_in  AND     We_in;
        Aref_enable     <= NOT(Ras_in) AND NOT(Cas_in) AND     We_in;
        Burst_term      <=     Ras_in  AND     Cas_in  AND NOT(We_in);
        Mode_reg_enable <= NOT(Ras_in) AND NOT(Cas_in) AND NOT(We_in);
        Prech_enable    <= NOT(Ras_in) AND     Cas_in  AND NOT(We_in);
        Read_enable     <=     Ras_in  AND NOT(Cas_in) AND     We_in;
        Write_enable    <=     Ras_in  AND NOT(Cas_in) AND NOT(We_in);

        -- Burst Length Decode
        Burst_length_1  <= NOT(Mode_reg(2)) AND NOT(Mode_reg(1)) AND NOT(Mode_reg(0));
        Burst_length_2  <= NOT(Mode_reg(2)) AND NOT(Mode_reg(1)) AND     Mode_reg(0);
        Burst_length_4  <= NOT(Mode_reg(2)) AND     Mode_reg(1)  AND NOT(Mode_reg(0));
        Burst_length_8  <= NOT(Mode_reg(2)) AND     Mode_reg(1)  AND     Mode_reg(0);

        -- CAS Latency Decode
        Cas_latency_2   <= NOT(Mode_reg(6)) AND     Mode_reg(5)  AND NOT(Mode_reg(4));
        Cas_latency_3   <= NOT(Mode_reg(6)) AND     Mode_reg(5)  AND     Mode_reg(4);

        -- Write Burst Mode
        Write_burst_mode <= Mode_reg(9);

        -- System Clock
        int_clk : PROCESS (Clk)
            begin
                IF Clk'LAST_VALUE = '0' AND Clk = '1' THEN
                    CkeZ <= TO_BIT(Cke, '1');
                END IF;
                Sys_clk <= CkeZ AND TO_BIT(Clk, '0');
        END PROCESS;

        state_register : PROCESS
            TYPE ram_type IS ARRAY (2**col_bits - 1 DOWNTO 0) OF BIT_VECTOR (data_bits - 1 DOWNTO 0);
            TYPE ram_pntr IS ACCESS ram_type;
            TYPE ram_stor IS ARRAY (2**addr_bits - 1 DOWNTO 0) OF ram_pntr;
            VARIABLE Bank0 : ram_stor;
            VARIABLE Bank1 : ram_stor;
            VARIABLE Bank2 : ram_stor;
            VARIABLE Bank3 : ram_stor;
            VARIABLE Row_index, Col_index : INTEGER := 0;
            VARIABLE Dq_temp : BIT_VECTOR (data_bits - 1 DOWNTO 0) := (OTHERS => '0');

            VARIABLE Col_addr : Array4xCBV;
            VARIABLE Bank_addr : Array4x2BV;
            VARIABLE Dqm_reg0, Dqm_reg1 : BIT_VECTOR (1 DOWNTO 0) := "00";

            VARIABLE Bank, Previous_bank : BIT_VECTOR (1 DOWNTO 0) := "00";
            VARIABLE B0_row_addr, B1_row_addr, B2_row_addr, B3_row_addr : BIT_VECTOR (addr_bits - 1 DOWNTO 0) := (OTHERS => '0');
            VARIABLE Col_brst : BIT_VECTOR (col_bits - 1 DOWNTO 0) := (OTHERS => '0');
            VARIABLE Row : BIT_VECTOR (addr_bits - 1 DOWNTO 0) := (OTHERS => '0');
            VARIABLE Col : BIT_VECTOR (col_bits - 1 DOWNTO 0) := (OTHERS => '0');
            VARIABLE Burst_counter : INTEGER := 0;

            VARIABLE Command : Array_state;
            VARIABLE Bank_precharge : Array4x2BV;
            VARIABLE A10_precharge : Array4xB := ('0' & '0' & '0' & '0');
            VARIABLE Auto_precharge : Array4xB := ('0' & '0' & '0' & '0');
            VARIABLE Read_precharge : Array4xB := ('0' & '0' & '0' & '0');
            VARIABLE Write_precharge : Array4xB := ('0' & '0' & '0' & '0');
            VARIABLE Count_precharge : Array4xI := (0 & 0 & 0 & 0);
            VARIABLE RW_interrupt_write : Array4xB := ('0' & '0' & '0' & '0');
            VARIABLE RW_interrupt_read : Array4xB := ('0' & '0' & '0' & '0');

            VARIABLE Data_in_enable, Data_out_enable : BIT := '0';
            VARIABLE Pc_b0, Pc_b1, Pc_b2, Pc_b3 : BIT := '0';
            VARIABLE Act_b0, Act_b1, Act_b2, Act_b3 : BIT := '0';

            -- Timing Check
            VARIABLE MRD_chk : INTEGER := 0;
            VARIABLE RC_chk, RRD_chk : TIME := 0 ns;
            VARIABLE RAS_chk0, RAS_chk1, RAS_chk2, RAS_chk3 : TIME := 0 ns;
            VARIABLE RCD_chk0, RCD_chk1, RCD_chk2, RCD_chk3 : TIME := 0 ns;
            VARIABLE RP_chk0, RP_chk1, RP_chk2, RP_chk3 : TIME := 0 ns;
            VARIABLE WR_chk : Array4xT := (0 ns & 0 ns & 0 ns & 0 ns);

            -- Load and Unload variables
            FILE     load_file : TEXT IS IN  "loaddata.txt";   -- Data load
            FILE     out_file0 : TEXT IS OUT "outdata0.txt";   -- Data dump for bank 0
            FILE     out_file1 : TEXT IS OUT "outdata1.txt";   -- Data dump for bank 1
            FILE     out_file2 : TEXT IS OUT "outdata2.txt";   -- Data dump for bank 2
            FILE     out_file3 : TEXT IS OUT "outdata3.txt";   -- Data dump for bank 3
            VARIABLE l_in, l_out0, l_out1, l_out2, l_out3 : LINE;
            VARIABLE array_buffer : BIT_VECTOR (data_bits - 1 DOWNTO 0) := (OTHERS => '0');
            VARIABLE write_data_var : STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0) := (OTHERS => '0');
            VARIABLE row_load, col_load, dq_load : INTEGER;
            VARIABLE ba_load : BIT_VECTOR (1 DOWNTO 0);
            VARIABLE dq_vec : BIT_VECTOR (data_bits - 1 DOWNTO 0);
            VARIABLE i, j, k : INTEGER;

            -- Initialize empty rows
            PROCEDURE Init_mem (Bank : BIT_VECTOR (1 DOWNTO 0); Row_index : INTEGER) IS
                VARIABLE i, j : INTEGER := 0;
                BEGIN
                    IF Bank = "00" THEN
                        IF Bank0 (Row_index) = NULL THEN                        -- Check to see if row empty
                            Bank0 (Row_index) := NEW ram_type;                  -- Open new row for access
                            FOR i IN (2**col_bits - 1) DOWNTO 0 LOOP            -- Filled row with zeros
                                FOR j IN (data_bits - 1) DOWNTO 0 LOOP
                                    Bank0 (Row_index) (i) (j) := '0';
                                END LOOP;
                            END LOOP;
                        END IF;
                    ELSIF Bank = "01" THEN
                        IF Bank1 (Row_index) = NULL THEN
                            Bank1 (Row_index) := NEW ram_type;
                            FOR i IN (2**col_bits - 1) DOWNTO 0 LOOP
                                FOR j IN (data_bits - 1) DOWNTO 0 LOOP
                                    Bank1 (Row_index) (i) (j) := '0';
                                END LOOP;
                            END LOOP;
                        END IF;
                    ELSIF Bank = "10" THEN
                        IF Bank2 (Row_index) = NULL THEN
                            Bank2 (Row_index) := NEW ram_type;
                            FOR i IN (2**col_bits - 1) DOWNTO 0 LOOP
                                FOR j IN (data_bits - 1) DOWNTO 0 LOOP
                                    Bank2 (Row_index) (i) (j) := '0';
                                END LOOP;
                            END LOOP;
                        END IF;
                    ELSIF Bank = "11" THEN
                        IF Bank3 (Row_index) = NULL THEN
                            Bank3 (Row_index) := NEW ram_type;
                            FOR i IN (2**col_bits - 1) DOWNTO 0 LOOP
                                FOR j IN (data_bits - 1) DOWNTO 0 LOOP
                                    Bank3 (Row_index) (i) (j) := '0';
                                END LOOP;
                            END LOOP;
                        END IF;
                    END IF;
                END;

            -- Burst Counter
            PROCEDURE Burst_decode IS
                VARIABLE Col_int : INTEGER := 0;
                VARIABLE Col_vec, Col_temp : BIT_VECTOR (col_bits - 1 DOWNTO 0) := (OTHERS => '0');
                BEGIN
                    -- Advance Burst Counter
                    Burst_counter := Burst_counter + 1;

                    -- Burst Type
                    IF Mode_reg (3) = '0' THEN
                        Col_int := TO_INTEGER(Col);
                        Col_int := Col_int + 1;
                        TO_BITVECTOR (Col_int, Col_temp);
                    ELSIF Mode_reg (3) = '1' THEN
                        TO_BITVECTOR (Burst_counter, Col_vec);
                        Col_temp (2) :=  Col_vec (2) XOR Col_brst (2);
                        Col_temp (1) :=  Col_vec (1) XOR Col_brst (1);
                        Col_temp (0) :=  Col_vec (0) XOR Col_brst (0);
                    END IF;

                    -- Burst Length
                    IF Burst_length_2 = '1' THEN
                        Col (0) := Col_temp (0);
                    ELSIF Burst_length_4 = '1' THEN
                        Col (1 DOWNTO 0) := Col_temp (1 DOWNTO 0);
                    ELSIF Burst_length_8 = '1' THEN
                        Col (2 DOWNTO 0) := Col_temp (2 DOWNTO 0);
                    ELSE
                        Col := Col_temp;
                    END IF;

                    -- Burst Read Single Write
                    IF Write_burst_mode = '1' AND Data_in_enable = '1' THEN
                        Data_in_enable := '0';
                    END IF;

                    -- Data counter
                    IF Burst_length_1 = '1' THEN
                        IF Burst_counter >= 1 THEN
                            IF Data_in_enable = '1' THEN
                                Data_in_enable := '0';
                            ELSIF Data_out_enable = '1' THEN
                                Data_out_enable := '0';
                            END IF;
                        END IF;
                    ELSIF Burst_length_2 = '1' THEN
                        IF Burst_counter >= 2 THEN
                            IF Data_in_enable = '1' THEN
                                Data_in_enable := '0';
                            ELSIF Data_out_enable = '1' THEN
                                Data_out_enable := '0';
                            END IF;
                        END IF;
                    ELSIF Burst_length_4 = '1' THEN
                        IF Burst_counter >= 4 THEN
                            IF Data_in_enable = '1' THEN
                                Data_in_enable := '0';
                            ELSIF Data_out_enable = '1' THEN
                                Data_out_enable := '0';
                            END IF;
                        END IF;
                    ELSIF Burst_length_8 = '1' THEN
                        IF Burst_counter >= 8 THEN
                            IF Data_in_enable = '1' THEN
                                Data_in_enable := '0';
                            ELSIF Data_out_enable = '1' THEN
                                Data_out_enable := '0';
                            END IF;
                        END IF;
                    END IF;
                END;

            BEGIN
                WAIT ON Sys_clk, WR_counter(0), WR_counter(1), WR_counter(2), WR_counter(3);
                    IF Sys_clk'event and Sys_clk = '1' AND Load = '0' AND Unload = '0' THEN
                        -- Internal Command Pipeline
                        Command(0) := Command(1);
                        Command(1) := Command(2);
                        Command(2) := Command(3);
                        Command(3) := NOP;

                        Col_addr(0) := Col_addr(1);
                        Col_addr(1) := Col_addr(2);
                        Col_addr(2) := Col_addr(3);
                        Col_addr(3) := (OTHERS => '0');

                        Bank_addr(0) := Bank_addr(1);
                        Bank_addr(1) := Bank_addr(2);
                        Bank_addr(2) := Bank_addr(3);
                        Bank_addr(3) := "00";

                        Bank_precharge(0) := Bank_precharge(1);
                        Bank_precharge(1) := Bank_precharge(2);
                        Bank_precharge(2) := Bank_precharge(3);
                        Bank_precharge(3) := "00";

                        A10_precharge(0) := A10_precharge(1);
                        A10_precharge(1) := A10_precharge(2);
                        A10_precharge(2) := A10_precharge(3);
                        A10_precharge(3) := '0';

                        -- Operation Decode (Optional for showing current command on posedge clock / debug feature)
                        IF Active_enable = '1' THEN
                            Operation <= ACT;
                        ELSIF Aref_enable = '1' THEN
                            Operation <= A_REF;
                        ELSIF Burst_term = '1' THEN
                            Operation <= BST;
                        ELSIF Mode_reg_enable = '1' THEN
                            Operation <= LMR;
                        ELSIF Prech_enable = '1' THEN
                            Operation <= PRECH;
                        ELSIF Read_enable = '1' THEN
                            IF Addr(10) = '0' THEN
                                Operation <= READ;
                            ELSE
                                Operation <= READ_A;
                            END IF;
                        ELSIF Write_enable = '1' THEN
                            IF Addr(10) = '0' THEN
                                Operation <= WRITE;
                            ELSE
                                Operation <= WRITE_A;
                            END IF;
                        ELSE
                            Operation <= NOP;
                        END IF;

                        -- Dqm pipeline for Read
                        Dqm_reg0 := Dqm_reg1;
                        Dqm_reg1 := TO_BITVECTOR(Dqm);

                        -- Read or Write with Auto Precharge Counter
                        IF Auto_precharge (0) = '1' THEN
                            Count_precharge (0) := Count_precharge (0) + 1;
                        END IF;
                        IF Auto_precharge (1) = '1' THEN
                            Count_precharge (1) := Count_precharge (1) + 1;
                        END IF;
                        IF Auto_precharge (2) = '1' THEN
                            Count_precharge (2) := Count_precharge (2) + 1;
                        END IF;
                        IF Auto_precharge (3) = '1' THEN
                            Count_precharge (3) := Count_precharge (3) + 1;
                        END IF;

                        -- tMRD Counter
                        MRD_chk := MRD_chk + 1;
                        
                        -- tWR Counter
                        WR_counter(0) <= WR_counter(0) + 1;
                        WR_counter(1) <= WR_counter(1) + 1;
                        WR_counter(2) <= WR_counter(2) + 1;
                        WR_counter(3) <= WR_counter(3) + 1;

                        -- Auto Refresh
                        IF Aref_enable = '1' THEN
                            -- Auto Refresh to Auto Refresh
                            ASSERT (NOW - RC_chk >= tRC)
                                REPORT "tRC violation during Auto Refresh"
                                SEVERITY WARNING;
                            -- Precharge to Auto Refresh
                            ASSERT (NOW - RP_chk0 >= tRP OR NOW - RP_chk1 >= tRP OR NOW - RP_chk2 >= tRP OR NOW - RP_chk3 >= tRP)
                                REPORT "tRP violation during Auto Refresh"
                                SEVERITY WARNING;
                            -- All banks must be idle before refresh
                            IF (Pc_b3 ='0' OR Pc_b2 = '0' OR Pc_b1 ='0' OR Pc_b0 = '0') THEN
                                ASSERT (FALSE)
                                    REPORT "All banks must be Precharge before Auto Refresh"
                                    SEVERITY WARNING;
                            END IF;
                            -- Record current tRC time
                            RC_chk := NOW;
                        END IF;

                        -- Load Mode Register
                        IF Mode_reg_enable = '1' THEN
                            Mode_reg <= TO_BITVECTOR (Addr);
                            IF (Pc_b3 ='0' OR Pc_b2 = '0' OR Pc_b1 ='0' OR Pc_b0 = '0') THEN
                                ASSERT (FALSE)
                                    REPORT "All bank must be Precharge before Load Mode Register"
                                    SEVERITY WARNING;
                            END IF;
                            -- REF to LMR
                            ASSERT (NOW - RC_chk >= tRC)
                                REPORT "tRC violation during Load Mode Register"
                                SEVERITY WARNING;
                            -- LMR to LMR
                            ASSERT (MRD_chk >= tMRD)
                                REPORT "tMRD violation during Load Mode Register"
                                SEVERITY WARNING;
                            -- Record current tMRD time
                            MRD_chk := 0;
                        END IF;

                        -- Active Block (latch Bank and Row Address)
                        IF Active_enable = '1' THEN
                            IF Ba = "00" AND Pc_b0 = '1' THEN
                                Act_b0 := '1';
                                Pc_b0 := '0';
                                B0_row_addr := TO_BITVECTOR (Addr);
                                RCD_chk0 := NOW;
                                RAS_chk0 := NOW;
                                -- Precharge to Active Bank 0
                                ASSERT (NOW - RP_chk0 >= tRP)
                                    REPORT "tRP violation during Activate Bank 0"
                                    SEVERITY WARNING;
                            ELSIF Ba = "01" AND Pc_b1 = '1' THEN
                                Act_b1 := '1';
                                Pc_b1 := '0';
                                B1_row_addr := TO_BITVECTOR (Addr);
                                RCD_chk1 := NOW;
                                RAS_chk1 := NOW;
                                -- Precharge to Active Bank 1
                                ASSERT (NOW - RP_chk1 >= tRP)
                                    REPORT "tRP violation during Activate Bank 1"
                                    SEVERITY WARNING;
                            ELSIF Ba = "10" AND Pc_b2 = '1' THEN
                                Act_b2 := '1';
                                Pc_b2 := '0';
                                B2_row_addr := TO_BITVECTOR (Addr);
                                RCD_chk2 := NOW;
                                RAS_chk2 := NOW;
                                -- Precharge to Active Bank 2
                                ASSERT (NOW - RP_chk2 >= tRP)
                                    REPORT "tRP violation during Activate Bank 2"
                                    SEVERITY WARNING;
                            ELSIF Ba = "11" AND Pc_b3 = '1' THEN
                                Act_b3 := '1';
                                Pc_b3 := '0';
                                B3_row_addr := TO_BITVECTOR (Addr);
                                RCD_chk3 := NOW;
                                RAS_chk3 := NOW;
                                -- Precharge to Active Bank 3
                                ASSERT (NOW - RP_chk3 >= tRP)
                                    REPORT "tRP violation during Activate Bank 3"
                                    SEVERITY WARNING;
                            ELSIF Ba = "00" AND Pc_b0 = '0' THEN
                                ASSERT (FALSE)
                                    REPORT "Bank 0 is not Precharged"
                                    SEVERITY WARNING;
                            ELSIF Ba = "01" AND Pc_b1 = '0' THEN
                                ASSERT (FALSE)
                                    REPORT "Bank 1 is not Precharged"
                                    SEVERITY WARNING;
                            ELSIF Ba = "10" AND Pc_b2 = '0' THEN
                                ASSERT (FALSE)
                                    REPORT "Bank 2 is not Precharged"
                                    SEVERITY WARNING;
                            ELSIF Ba = "11" AND Pc_b3 = '0' THEN
                                ASSERT (FALSE)
                                    REPORT "Bank 3 is not Precharged"
                                    SEVERITY WARNING;
                            END IF;
                            -- Active Bank A to Active Bank B
                            IF ((Previous_bank /= TO_BITVECTOR (Ba)) AND (NOW - RRD_chk < tRRD)) THEN
                                ASSERT (FALSE)
                                    REPORT "tRRD violation during Activate"
                                    SEVERITY WARNING;
                            END IF;
                            -- LMR to ACT
                            ASSERT (MRD_chk >= tMRD)
                                REPORT "tMRD violation during Activate"
                                SEVERITY WARNING;
                            -- AutoRefresh to Activate
                            ASSERT (NOW - RC_chk >= tRC)
                                REPORT "tRC violation during Activate"
                                SEVERITY WARNING;
                            -- Record variable for checking violation
                            RRD_chk := NOW;
                            Previous_bank := TO_BITVECTOR (Ba);
                        END IF;

                        -- Precharge Block
                        IF Prech_enable = '1' THEN
                            IF Addr(10) = '1' THEN
                                Pc_b0 := '1'; 
                                Pc_b1 := '1'; 
                                Pc_b2 := '1'; 
                                Pc_b3 := '1';
                                Act_b0 := '0';
                                Act_b1 := '0';
                                Act_b2 := '0';
                                Act_b3 := '0';
                                RP_chk0 := NOW;
                                RP_chk1 := NOW;
                                RP_chk2 := NOW;
                                RP_chk3 := NOW;
                                -- Activate to Precharge all banks
                                ASSERT ((NOW - RAS_chk0 >= tRAS) OR (NOW - RAS_chk1 >= tRAS))
                                    REPORT "tRAS violation during Precharge all banks"
                                    SEVERITY WARNING;
                                -- tWR violation check for Write
                                IF ((NOW - WR_chk(0) < tWRp) OR (NOW - WR_chk(1) < tWRp) OR
                                    (NOW - WR_chk(2) < tWRp) OR (NOW - WR_chk(3) < tWRp)) THEN
                                    ASSERT (FALSE)
                                        REPORT "tWR violation during Precharge ALL banks"
                                        SEVERITY WARNING;
                                END IF;
                            ELSIF Addr(10) = '0' THEN
                                IF Ba = "00" THEN
                                    Pc_b0 := '1';
                                    Act_b0 := '0';
                                    RP_chk0 := NOW;
                                    -- Activate to Precharge bank 0
                                    ASSERT (NOW - RAS_chk0 >= tRAS)
                                        REPORT "tRAS violation during Precharge bank 0"
                                        SEVERITY WARNING;
                                ELSIF Ba = "01" THEN
                                    Pc_b1 := '1';
                                    Act_b1 := '0';
                                    RP_chk1 := NOW;
                                    -- Activate to Precharge bank 1
                                    ASSERT (NOW - RAS_chk1 >= tRAS)
                                        REPORT "tRAS violation during Precharge bank 1"
                                        SEVERITY WARNING;
                                ELSIF Ba = "10" THEN
                                    Pc_b2 := '1';
                                    Act_b2 := '0';
                                    RP_chk2 := NOW;
                                    -- Activate to Precharge bank 2
                                    ASSERT (NOW - RAS_chk2 >= tRAS)
                                        REPORT "tRAS violation during Precharge bank 2"
                                        SEVERITY WARNING;
                                ELSIF Ba = "11" THEN
                                    Pc_b3 := '1';
                                    Act_b3 := '0';
                                    RP_chk3 := NOW;
                                    -- Activate to Precharge bank 3
                                    ASSERT (NOW - RAS_chk3 >= tRAS)
                                        REPORT "tRAS violation during Precharge bank 3"
                                        SEVERITY WARNING;
                                END IF;
                                -- tWR violation check for Write
                                ASSERT (NOW - WR_chk(TO_INTEGER(Ba)) >= tWRp)
                                    REPORT "tWR violation during Precharge"
                                    SEVERITY WARNING;
                            END IF;
                            -- Terminate a Write Immediately (if same bank or all banks)
                            IF (Data_in_enable = '1' AND (Bank = TO_BITVECTOR(Ba) OR Addr(10) = '1')) THEN
                                Data_in_enable := '0';
                            END IF;
                            -- Precharge Command Pipeline for READ
                            IF CAS_latency_3 = '1' THEN
                                Command(2) := PRECH;
                                Bank_precharge(2) := TO_BITVECTOR (Ba);
                                A10_precharge(2) := TO_BIT(Addr(10));
                            ELSIF CAS_latency_2 = '1' THEN
                                Command(1) := PRECH;
                                Bank_precharge(1) := TO_BITVECTOR (Ba);
                                A10_precharge(1) := TO_BIT(Addr(10));
                            END IF;
                        END IF;

                        -- Burst Terminate
                        IF Burst_term = '1' THEN
                            -- Terminate a Write immediately
                            IF Data_in_enable = '1' THEN
                                Data_in_enable := '0';
                            END IF;
                            -- Terminate a Read depend on CAS Latency
                            IF CAS_latency_3 = '1' THEN
                                Command(2) := BST;
                            ELSIF CAS_latency_2 = '1' THEN
                                Command(1) := BST;
                            END IF;
                        END IF;

                        -- Read, Write, Column Latch
                        IF Read_enable = '1' OR Write_enable = '1' THEN
                            -- Check to see if bank is open (ACT) for Read or Write
                            IF ((Ba = "00" AND Pc_b0 = '1') OR (Ba = "01" AND Pc_b1 = '1') OR (Ba = "10" AND Pc_b2 = '1') OR (Ba = "11" AND Pc_b3 = '1')) THEN
                                ASSERT (FALSE)
                                    REPORT "Cannot Read or Write - Bank is not Activated"
                                    SEVERITY WARNING;
                            END IF;
                            -- Activate to Read or Write
                            IF Ba = "00" THEN
                                ASSERT (NOW - RCD_chk0 >= tRCD)
                                    REPORT "tRCD violation during Read or Write to Bank 0"
                                    SEVERITY WARNING;
                            ELSIF Ba = "01" THEN
                                ASSERT (NOW - RCD_chk1 >= tRCD)
                                    REPORT "tRCD violation during Read or Write to Bank 1"
                                    SEVERITY WARNING;
                            ELSIF Ba = "10" THEN
                                ASSERT (NOW - RCD_chk2 >= tRCD)
                                    REPORT "tRCD violation during Read or Write to Bank 2"
                                    SEVERITY WARNING;
                            ELSIF Ba = "11" THEN
                                ASSERT (NOW - RCD_chk3 >= tRCD)
                                    REPORT "tRCD violation during Read or Write to Bank 3"
                                    SEVERITY WARNING;
                            END IF;
                            -- Read Command
                            IF Read_enable = '1' THEN
                                -- CAS Latency Pipeline
                                IF Cas_latency_3 = '1' THEN
                                    IF Addr(10) = '1' THEN
                                        Command(2) := READ_A;
                                    ELSE
                                        Command(2) := READ;
                                    END IF;
                                    Col_addr (2) := TO_BITVECTOR (Addr(col_bits - 1 DOWNTO 0));
                                    Bank_addr (2) := TO_BITVECTOR (Ba);
                                ELSIF Cas_latency_2 = '1' THEN
                                    IF Addr(10) = '1' THEN
                                        Command(1) := READ_A;
                                    ELSE
                                        Command(1) := READ;
                                    END IF;
                                    Col_addr (1) := TO_BITVECTOR (Addr(col_bits - 1 DOWNTO 0));
                                    Bank_addr (1) := TO_BITVECTOR (Ba);
                                END IF;

                                -- Read intterupt a Write (terminate Write immediately)
                                IF Data_in_enable = '1' THEN
                                    Data_in_enable := '0';
                                END IF;

                            -- Write Command
                            ELSIF Write_enable = '1' THEN
                                IF Addr(10) = '1' THEN
                                    Command(0) := WRITE_A;
                                ELSE
                                    Command(0) := WRITE;
                                END IF;
                                Col_addr (0) := TO_BITVECTOR (Addr(col_bits - 1 DOWNTO 0));
                                Bank_addr (0) := TO_BITVECTOR (Ba);

                                -- Write intterupt a Write (terminate Write immediately)
                                IF Data_in_enable = '1' THEN
                                    Data_in_enable := '0';
                                END IF;

                                -- Write interrupt a Read (terminate Read immediately)
                                IF Data_out_enable = '1' THEN
                                    Data_out_enable := '0';
                                END IF;
                            END IF;

                            -- Interrupt a Write with Auto Precharge
                            IF Auto_precharge(TO_INTEGER(Bank)) = '1' AND Write_precharge(TO_INTEGER(Bank)) = '1' THEN
                                RW_interrupt_write(TO_INTEGER(Bank)) := '1';
                            END IF;

                            -- Interrupt a Read with Auto Precharge
                            IF Auto_precharge(TO_INTEGER(Bank)) = '1' AND Read_precharge(TO_INTEGER(Bank)) = '1' THEN
                                RW_interrupt_read(TO_INTEGER(Bank)) := '1';
                            END IF;

                            -- Read or Write with Auto Precharge
                            IF Addr(10) = '1' THEN
                                Auto_precharge (TO_INTEGER(Ba)) := '1';
                                Count_precharge (TO_INTEGER(Ba)) := 0;
                                IF Read_enable = '1' THEN
                                    Read_precharge (TO_INTEGER(Ba)) := '1';
                                ELSIF Write_enable = '1' THEN
                                    Write_precharge (TO_INTEGER(Ba)) := '1';
                                END IF;
                            END IF;
                        END IF;

                        -- Read with AutoPrecharge Calculation
                        --      The device start internal precharge when:
                        --          1.  BL/2 cycles after command
                        --      and 2.  Meet tRAS requirement
                        --       or 3.  Interrupt by a Read or Write (with or without Auto Precharge)
                        IF ((Auto_precharge(0) = '1') AND (Read_precharge(0) = '1')) THEN
                            IF (((NOW - RAS_chk0 >= tRAS) AND
                                ((Burst_length_1 = '1' AND Count_precharge(0) >= 1)  OR
                                 (Burst_length_2 = '1' AND Count_precharge(0) >= 2)  OR
                                 (Burst_length_4 = '1' AND Count_precharge(0) >= 4)  OR
                                 (Burst_length_8 = '1' AND Count_precharge(0) >= 8))) OR
                                 (RW_interrupt_read(0) = '1')) THEN
                                Pc_b0 := '1';
                                Act_b0 := '0';
                                RP_chk0 := NOW;
                                Auto_precharge(0) := '0';
                                Read_precharge(0) := '0';
                                RW_interrupt_read(0) := '0';
                            END IF;
                        END IF;
                        IF ((Auto_precharge(1) = '1') AND (Read_precharge(1) = '1')) THEN
                            IF (((NOW - RAS_chk1 >= tRAS) AND
                                ((Burst_length_1 = '1' AND Count_precharge(1) >= 1)  OR
                                 (Burst_length_2 = '1' AND Count_precharge(1) >= 2)  OR
                                 (Burst_length_4 = '1' AND Count_precharge(1) >= 4)  OR
                                 (Burst_length_8 = '1' AND Count_precharge(1) >= 8))) OR
                                 (RW_interrupt_read(1) = '1')) THEN
                                Pc_b1 := '1';
                                Act_b1 := '0';
                                RP_chk1 := NOW;
                                Auto_precharge(1) := '0';
                                Read_precharge(1) := '0';
                                RW_interrupt_read(1) := '0';
                            END IF;
                        END IF;
                        IF ((Auto_precharge(2) = '1') AND (Read_precharge(2) = '1')) THEN
                            IF (((NOW - RAS_chk2 >= tRAS) AND
                                ((Burst_length_1 = '1' AND Count_precharge(2) >= 1)  OR
                                 (Burst_length_2 = '1' AND Count_precharge(2) >= 2)  OR
                                 (Burst_length_4 = '1' AND Count_precharge(2) >= 4)  OR
                                 (Burst_length_8 = '1' AND Count_precharge(2) >= 8))) OR
                                 (RW_interrupt_read(2) = '1')) THEN
                                Pc_b2 := '1';
                                Act_b2 := '0';
                                RP_chk2 := NOW;
                                Auto_precharge(2) := '0';
                                Read_precharge(2) := '0';
                                RW_interrupt_read(2) := '0';
                            END IF;
                        END IF;
                        IF ((Auto_precharge(3) = '1') AND (Read_precharge(3) = '1')) THEN
                            IF (((NOW - RAS_chk3 >= tRAS) AND
                                ((Burst_length_1 = '1' AND Count_precharge(3) >= 1)  OR
                                 (Burst_length_2 = '1' AND Count_precharge(3) >= 2)  OR
                                 (Burst_length_4 = '1' AND Count_precharge(3) >= 4)  OR
                                 (Burst_length_8 = '1' AND Count_precharge(3) >= 8))) OR
                                 (RW_interrupt_read(3) = '1')) THEN
                                Pc_b3 := '1';
                                Act_b3 := '0';
                                RP_chk3 := NOW;
                                Auto_precharge(3) := '0';
                                Read_precharge(3) := '0';
                                RW_interrupt_read(3) := '0';
                            END IF;
                        END IF;

                        -- Internal Precharge or Bst
                        IF Command(0) = PRECH THEN                          -- PRECH terminate a read if same bank or all banks
                            IF Bank_precharge(0) = Bank OR A10_precharge(0) = '1' THEN
                                IF Data_out_enable = '1' THEN
                                    Data_out_enable := '0';
                                END IF;
                            END IF;
                        ELSIF Command(0) = BST THEN                         -- BST terminate a read regardless of bank
                            IF Data_out_enable = '1' THEN
                                Data_out_enable := '0';
                            END IF;
                        END IF;

                        IF Data_out_enable = '0' THEN
                            Dq <= TRANSPORT (OTHERS => 'Z') AFTER tOH;
                        END IF;

                        -- Detect Read or Write Command
                        IF Command(0) = READ OR Command(0) = READ_A THEN
                            Bank := Bank_addr (0);
                            Col := Col_addr (0);
                            Col_brst := Col_addr (0);
                            IF Bank_addr (0) = "00" THEN
                                Row := B0_row_addr;
                            ELSIF Bank_addr (0) = "01" THEN
                                Row := B1_row_addr;
                            ELSIF Bank_addr (0) = "10" THEN
                                Row := B2_row_addr;
                            ELSE
                                Row := B3_row_addr;
                            END IF;
                            Burst_counter := 0;
                            Data_in_enable := '0';
                            Data_out_enable := '1';
                        ELSIF Command(0) = WRITE OR Command(0) = WRITE_A THEN
                            Bank := Bank_addr(0);
                            Col := Col_addr(0);
                            Col_brst := Col_addr(0);
                            IF Bank_addr (0) = "00" THEN
                                Row := B0_row_addr;
                            ELSIF Bank_addr (0) = "01" THEN
                                Row := B1_row_addr;
                            ELSIF Bank_addr (0) = "10" THEN
                                Row := B2_row_addr;
                            ELSE
                                Row := B3_row_addr;
                            END IF;
                            Burst_counter := 0;
                            Data_in_enable := '1';
                            Data_out_enable := '0';
                        END IF;

                        -- DQ (Driver / Receiver)
                        Row_index := TO_INTEGER (Row);
                        Col_index := TO_INTEGER (Col);
                        IF Data_in_enable = '1' THEN
                            IF Dqm /= "11" THEN
                                Init_mem (Bank, Row_index);
                                IF Bank = "00" THEN
                                    Dq_temp := Bank0 (Row_index) (Col_index);
                                    IF Dqm = "01" THEN
                                        Dq_temp (15 DOWNTO 8) := TO_BITVECTOR (DQ_tmp (15 DOWNTO 8));
                                    ELSIF Dqm = "10" THEN
                                        Dq_temp (7 DOWNTO 0) := TO_BITVECTOR (DQ_tmp (7 DOWNTO 0));
                                    ELSE
                                        Dq_temp (15 DOWNTO 0) := TO_BITVECTOR (DQ_tmp (15 DOWNTO 0));
                                    END IF;
                                    Bank0 (Row_index) (Col_index) := Dq_temp;
                                ELSIF Bank = "01" THEN
                                    Dq_temp := Bank1 (Row_index) (Col_index);
                                    IF Dqm = "01" THEN
                                        Dq_temp (15 DOWNTO 8) := TO_BITVECTOR (DQ_tmp (15 DOWNTO 8));
                                    ELSIF Dqm = "10" THEN
                                        Dq_temp (7 DOWNTO 0) := TO_BITVECTOR (DQ_tmp (7 DOWNTO 0));
                                    ELSE
                                        Dq_temp (15 DOWNTO 0) := TO_BITVECTOR (DQ_tmp (15 DOWNTO 0));
                                    END IF;
                                    Bank1 (Row_index) (Col_index) := Dq_temp;
                                ELSIF Bank = "10" THEN
                                    Dq_temp := Bank2 (Row_index) (Col_index);
                                    IF Dqm = "01" THEN
                                        Dq_temp (15 DOWNTO 8) := TO_BITVECTOR (DQ_tmp (15 DOWNTO 8));
                                    ELSIF Dqm = "10" THEN
                                        Dq_temp (7 DOWNTO 0) := TO_BITVECTOR (DQ_tmp (7 DOWNTO 0));
                                    ELSE
                                        Dq_temp (15 DOWNTO 0) := TO_BITVECTOR (DQ_tmp (15 DOWNTO 0));
                                    END IF;
                                    Bank2 (Row_index) (Col_index) := Dq_temp;
                                ELSIF Bank = "11" THEN
                                    Dq_temp := Bank3 (Row_index) (Col_index);
                                    IF Dqm = "01" THEN
                                        Dq_temp (15 DOWNTO 8) := TO_BITVECTOR (DQ_tmp (15 DOWNTO 8));
                                    ELSIF Dqm = "10" THEN
                                        Dq_temp (7 DOWNTO 0) := TO_BITVECTOR (DQ_tmp (7 DOWNTO 0));
                                    ELSE
                                        Dq_temp (15 DOWNTO 0) := TO_BITVECTOR (DQ_tmp (15 DOWNTO 0));
                                    END IF;
                                    Bank3 (Row_index) (Col_index) := Dq_temp;
                                END IF;
                                WR_chk(TO_INTEGER(Bank)) := NOW;
                                WR_counter(TO_INTEGER(Bank)) <= 0;
                            END IF;
                            Burst_decode;
                        ELSIF Data_out_enable = '1' THEN
                            IF Dqm_reg0 /= "11" THEN
                                Init_mem (Bank, Row_index);
                                IF Bank = "00" THEN
                                    Dq_temp (15 DOWNTO 0) := Bank0 (Row_index) (Col_index);
                                    IF Dqm_reg0 = "00" THEN
                                        Dq (15 DOWNTO 0) <= TRANSPORT TO_STDLOGICVECTOR (Dq_temp (15 DOWNTO 0)) AFTER tAC;
                                    ELSIF Dqm_reg0 = "01" THEN
                                        Dq (15 DOWNTO 8)  <= TRANSPORT TO_STDLOGICVECTOR (Dq_temp (15 DOWNTO 8)) AFTER tAC;
                                        Dq (7 DOWNTO 0)  <= TRANSPORT (OTHERS => 'Z') AFTER tAC;
                                    ELSIF Dqm_reg0 = "10" THEN
                                        Dq (15 DOWNTO 8)  <= TRANSPORT (OTHERS => 'Z') AFTER tAC;
                                        Dq (7 DOWNTO 0) <= TRANSPORT TO_STDLOGICVECTOR (Dq_temp (7 DOWNTO 0)) AFTER tAC;
                                    END IF;
                                ELSIF Bank = "01" THEN
                                    Dq_temp (15 DOWNTO 0) := Bank1 (Row_index) (Col_index);
                                    IF Dqm_reg0 = "00" THEN
                                        Dq (15 DOWNTO 0) <= TRANSPORT TO_STDLOGICVECTOR (Dq_temp (15 DOWNTO 0)) AFTER tAC;
                                    ELSIF Dqm_reg0 = "01" THEN
                                        Dq (15 DOWNTO 8)  <= TRANSPORT TO_STDLOGICVECTOR (Dq_temp (15 DOWNTO 8)) AFTER tAC;
                                        Dq (7 DOWNTO 0)  <= TRANSPORT (OTHERS => 'Z') AFTER tAC;
                                    ELSIF Dqm_reg0 = "10" THEN
                                        Dq (15 DOWNTO 8)  <= TRANSPORT (OTHERS => 'Z') AFTER tAC;
                                        Dq (7 DOWNTO 0) <= TRANSPORT TO_STDLOGICVECTOR (Dq_temp (7 DOWNTO 0)) AFTER tAC;
                                    END IF;
                                ELSIF Bank = "10" THEN
                                    Dq_temp (15 DOWNTO 0) := Bank2 (Row_index) (Col_index);
                                    IF Dqm_reg0 = "00" THEN
                                        Dq (15 DOWNTO 0) <= TRANSPORT TO_STDLOGICVECTOR (Dq_temp (15 DOWNTO 0)) AFTER tAC;
                                    ELSIF Dqm_reg0 = "01" THEN
                                        Dq (15 DOWNTO 8)  <= TRANSPORT TO_STDLOGICVECTOR (Dq_temp (15 DOWNTO 8)) AFTER tAC;
                                        Dq (7 DOWNTO 0)  <= TRANSPORT (OTHERS => 'Z') AFTER tAC;
                                    ELSIF Dqm_reg0 = "10" THEN
                                        Dq (15 DOWNTO 8)  <= TRANSPORT (OTHERS => 'Z') AFTER tAC;
                                        Dq (7 DOWNTO 0) <= TRANSPORT TO_STDLOGICVECTOR (Dq_temp (7 DOWNTO 0)) AFTER tAC;
                                    END IF;
                                ELSIF Bank = "11" THEN
                                    Dq_temp (15 DOWNTO 0) := Bank3 (Row_index) (Col_index);
                                    IF Dqm_reg0 = "00" THEN
                                        Dq (15 DOWNTO 0) <= TRANSPORT TO_STDLOGICVECTOR (Dq_temp (15 DOWNTO 0)) AFTER tAC;
                                    ELSIF Dqm_reg0 = "01" THEN
                                        Dq (15 DOWNTO 8)  <= TRANSPORT TO_STDLOGICVECTOR (Dq_temp (15 DOWNTO 8)) AFTER tAC;
                                        Dq (7 DOWNTO 0)  <= TRANSPORT (OTHERS => 'Z') AFTER tAC;
                                    ELSIF Dqm_reg0 = "10" THEN
                                        Dq (15 DOWNTO 8)  <= TRANSPORT (OTHERS => 'Z') AFTER tAC;
                                        Dq (7 DOWNTO 0) <= TRANSPORT TO_STDLOGICVECTOR (Dq_temp (7 DOWNTO 0)) AFTER tAC;
                                    END IF;
                                END IF;
                            ELSE
                                  Dq <= TRANSPORT (OTHERS => 'Z') AFTER tHZ;
                            END IF;
                            Burst_decode;
                        END IF;

                    ELSIF Sys_clk'event and Sys_clk = '1' AND Load = '1' AND Unload = '0' THEN
                        Operation <= FILE_LOAD;
                        WHILE NOT ENDFILE (load_file) LOOP
                            READLINE (load_file, l_in);
                            IF l_in'LENGTH > 0 THEN
                                read (l_in, row_load, 16);                          -- Load from HEX to INTEGER
                                read (l_in, col_load, 16);                          -- Load from HEX to INTEGER
                                read (l_in, ba_load);
                                read (l_in, dq_load, 16);                           -- Load from HEX to INTEGER

                                TO_BITVECTOR (dq_load, dq_vec);

                                IF ba_load = "00" THEN
                                    IF Bank0(row_load) = NULL THEN                  --initialize new memory block
                                        Bank0(row_load) := new ram_type;
                                        FOR i IN (2**(col_bits))-1 DOWNTO 0 LOOP
                                            FOR k IN data_bits - 1 DOWNTO 0 LOOP
                                                Bank0(row_load) (i) (k) := '0';
                                            END LOOP;
                                        END LOOP;
                                    END IF;
                                    Bank0(row_load)(col_load) := dq_vec;
                                ELSIF ba_load = "01" THEN
                                    IF Bank1(row_load) = NULL THEN                  --initialize new memory block
                                        Bank1(row_load) := new ram_type;
                                        FOR i IN (2**(col_bits))-1 DOWNTO 0 LOOP
                                            FOR k IN data_bits - 1 DOWNTO 0 LOOP
                                                Bank1(row_load) (i) (k) := '0';
                                            END LOOP;
                                        END LOOP;
                                    END IF;
                                    Bank1(row_load)(col_load) := dq_vec;
                                ELSIF ba_load = "10" THEN
                                    IF Bank2(row_load) = NULL THEN                  --initialize new memory block
                                        Bank2(row_load) := new ram_type;
                                        FOR i IN (2**(col_bits))-1 DOWNTO 0 LOOP
                                            FOR k IN data_bits - 1 DOWNTO 0 LOOP
                                                Bank2(row_load) (i) (k) := '0';
                                            END LOOP;
                                        END LOOP;
                                    END IF;
                                    Bank2(row_load)(col_load) := dq_vec;
                                ELSIF ba_load = "11" THEN
                                    IF Bank3(row_load) = NULL THEN                  --initialize new memory block
                                        Bank3(row_load) := new ram_type;
                                        FOR i IN (2**(col_bits))-1 DOWNTO 0 LOOP
                                            FOR k IN data_bits - 1 DOWNTO 0 LOOP
                                                Bank3(row_load) (i) (k) := '0';
                                            END LOOP;
                                        END LOOP;
                                    END IF;
                                    Bank3(row_load)(col_load) := dq_vec;
                                END IF;
                            END IF;
                        END LOOP;
                    ELSIF Sys_clk'event and Sys_clk = '1' AND Load = '0' AND Unload = '1' THEN
                        Operation <= FILE_UNLOAD;
                        ASSERT (Row_start < 2**(Addr'HIGH + 1))
                            REPORT "Row_start is out of range for device"
                            SEVERITY ERROR;
                        ASSERT (Row_end < 2**(Addr'HIGH + 1))
                            REPORT "Row_end is out of range for device"
                            SEVERITY ERROR;
                        ASSERT ((Row_end - Row_start) >= 0)
                            REPORT "The Row ranges for Unload is invalid!"
                            SEVERITY ERROR;
                        IF ((Row_end - Row_start) >= 0) THEN
                            FOR i IN Row_start TO Row_end LOOP
                                j := 1;
                                IF (Ba = "00") THEN                                             -- Unload Bank 0
                                    WRITE (l_out0, STRING'("Micron Technology Inc. - Unload Data Array - Bank   0 Row "));
                                    WRITE (l_out0, i, RIGHT, 3, HEX, FALSE);
                                    WRITELINE (out_file0, l_out0);
                                    FOR k IN 0 TO ((2**Col_bits) - 1) LOOP                      -- Display Row and Column
                                        IF (j = 1) THEN
                                            WRITE (l_out0, i, RIGHT, 3, HEX, FALSE);
                                            WRITE (l_out0, STRING'(" : "));
                                            WRITE (l_out0, k, RIGHT, 3, HEX, FALSE);
                                            WRITE (l_out0, STRING'(" : "));
                                        END IF;

                                        IF (Bank0 (i) = NULL) THEN                              -- Row is empty, write message and exit
                                            WRITE (l_out0, STRING'("  Row "));
                                            WRITE (l_out0, i);
                                            WRITE (l_out0, STRING'(" is empty."));
                                            WRITELINE (out_file0, l_out0);
                                            EXIT;
                                        ELSE                                                    -- Buffering
                                            array_buffer := Bank0 (i) (k);
                                        END IF;

                                        write_data_var := TO_STDLOGICVECTOR(array_buffer);      -- Convert to STD_LOGIC_VECTOR
                                        WRITE (l_out0, write_data_var, RIGHT, 6, HEX, FALSE);   -- Write message
                                        IF (j = 16) then
                                            WRITELINE (out_file0, l_out0);
                                            j := 1;
                                        ELSE
                                            j := j + 1;
                                        END IF;
                                    END LOOP;
                                ELSIF (Ba = "01") THEN
                                    WRITE (l_out1, STRING'("Micron Technology Inc. - Unload Data Array - Bank   1 Row "));
                                    WRITE (l_out1, i, RIGHT, 3, HEX, FALSE);
                                    WRITELINE (out_file1, l_out1);
                                    FOR k IN 0 TO ((2**Col_bits) - 1) LOOP
                                        IF (j = 1) THEN
                                            WRITE (l_out1, i, RIGHT, 3, HEX, FALSE);
                                            WRITE (l_out1, STRING'(" : "));
                                            WRITE (l_out1, k, RIGHT, 3, HEX, FALSE);
                                            WRITE (l_out1, STRING'(" : "));
                                        END IF;

                                        IF (Bank1 (i) = NULL) THEN
                                            WRITE (l_out1, STRING'("  Row "));
                                            WRITE (l_out1, i);
                                            WRITE (l_out1, STRING'(" is empty."));
                                            WRITELINE (out_file1, l_out1);
                                            EXIT;
                                        ELSE
                                            array_buffer := Bank1 (i) (k);
                                        END IF;

                                        write_data_var := TO_STDLOGICVECTOR(array_buffer);
                                        WRITE (l_out1, write_data_var, RIGHT, 6, HEX, FALSE);
                                        IF (j = 16) then
                                            WRITELINE (out_file1, l_out1);
                                            j := 1;
                                        ELSE
                                            j := j + 1;
                                        END IF;
                                    END LOOP;
                                ELSIF (Ba = "10") THEN
                                    WRITE (l_out2, STRING'("Micron Technology Inc. - Unload Data Array - Bank   2 Row "));
                                    WRITE (l_out2, i, RIGHT, 3, HEX, FALSE);
                                    WRITELINE (out_file2, l_out2);
                                    FOR k IN 0 TO ((2**Col_bits) - 1) LOOP
                                        IF (j = 1) THEN
                                            WRITE (l_out2, i, RIGHT, 3, HEX, FALSE);
                                            WRITE (l_out2, STRING'(" : "));
                                            WRITE (l_out2, k, RIGHT, 3, HEX, FALSE);
                                            WRITE (l_out2, STRING'(" : "));
                                        END IF;

                                        IF (Bank2 (i) = NULL) THEN
                                            WRITE (l_out2, STRING'("  Row "));
                                            WRITE (l_out2, i);
                                            WRITE (l_out2, STRING'(" is empty."));
                                            WRITELINE (out_file2, l_out2);
                                            EXIT;
                                        ELSE
                                            array_buffer := Bank2 (i) (k);
                                        END IF;

                                        write_data_var := TO_STDLOGICVECTOR(array_buffer);
                                        WRITE (l_out2, write_data_var, RIGHT, 6, HEX, FALSE);
                                        IF (j = 16) then
                                            WRITELINE (out_file2, l_out2);
                                            j := 1;
                                        ELSE
                                            j := j + 1;
                                        END IF;
                                    END LOOP;
                                ELSIF (Ba = "11") THEN
                                    WRITE (l_out3, STRING'("Micron Technology Inc. - Unload Data Array - Bank   3 Row "));
                                    WRITE (l_out3, i, RIGHT, 3, HEX, FALSE);
                                    WRITELINE (out_file3, l_out3);
                                    FOR k IN 0 TO ((2**Col_bits) - 1) LOOP
                                        IF (j = 1) THEN
                                            WRITE (l_out3, i, RIGHT, 3, HEX, FALSE);
                                            WRITE (l_out3, STRING'(" : "));
                                            WRITE (l_out3, k, RIGHT, 3, HEX, FALSE);
                                            WRITE (l_out3, STRING'(" : "));
                                        END IF;

                                        IF (Bank3 (i) = NULL) THEN
                                            WRITE (l_out3, STRING'("  Row "));
                                            WRITE (l_out3, i);
                                            WRITE (l_out3, STRING'(" is empty."));
                                            WRITELINE (out_file3, l_out3);
                                            EXIT;
                                        ELSE
                                            array_buffer := Bank3 (i) (k);
                                        END IF;

                                        write_data_var := TO_STDLOGICVECTOR(array_buffer);
                                        WRITE (l_out3, write_data_var, RIGHT, 6, HEX, FALSE);
                                        IF (j = 16) then
                                            WRITELINE (out_file3, l_out3);
                                            j := 1;
                                        ELSE
                                            j := j + 1;
                                        END IF;
                                    END LOOP;
                                END IF;
                            END LOOP;
                        END IF;

                    END IF;

                    -- Write with AutoPrecharge Calculation
                    --      The device start internal precharge when:
                    --          1.  tWR cycles after command
                    --      and 2.  Meet tRAS requirement
                    --       or 3.  Interrupt by a Read or Write (with or without Auto Precharge)
                    IF ((Auto_precharge(0) = '1') AND (Write_precharge(0) = '1')) THEN
                        IF (((NOW - RAS_chk0 >= tRAS) AND
                           (((Burst_length_1 = '1' OR Write_burst_mode = '1' ) AND Count_precharge(0) >= 1)  OR
                             (Burst_length_2 = '1'                             AND Count_precharge(0) >= 2)  OR
                             (Burst_length_4 = '1'                             AND Count_precharge(0) >= 4)  OR
                             (Burst_length_8 = '1'                             AND Count_precharge(0) >= 8))) OR
                             (RW_interrupt_write(0) = '1' AND WR_counter(0) >= 2)) THEN
                            Auto_precharge(0) := '0';
                            Write_precharge(0) := '0';
                            RW_interrupt_write(0) := '0';
                            WAIT FOR tWRa;
                            Pc_b0 := '1';
                            Act_b0 := '0';
                            RP_chk0 := NOW;
                        END IF;
                    END IF;

                    IF ((Auto_precharge(1) = '1') AND (Write_precharge(1) = '1')) THEN
                        IF (((NOW - RAS_chk1 >= tRAS) AND
                           (((Burst_length_1 = '1' OR Write_burst_mode = '1' ) AND Count_precharge(1) >= 1)  OR
                             (Burst_length_2 = '1'                             AND Count_precharge(1) >= 2)  OR
                             (Burst_length_4 = '1'                             AND Count_precharge(1) >= 4)  OR
                             (Burst_length_8 = '1'                             AND Count_precharge(1) >= 8))) OR
                             (RW_interrupt_write(1) = '1' AND WR_counter(1) >= 2)) THEN
                            Auto_precharge(1) := '0';
                            Write_precharge(1) := '0';
                            RW_interrupt_write(1) := '0';
                            WAIT FOR tWRa;
                            Pc_b1 := '1';
                            Act_b1 := '0';
                            RP_chk1 := NOW;
                        END IF;
                    END IF;

                    IF ((Auto_precharge(2) = '1') AND (Write_precharge(2) = '1')) THEN
                        IF (((NOW - RAS_chk2 >= tRAS) AND
                           (((Burst_length_1 = '1' OR Write_burst_mode = '1' ) AND Count_precharge(2) >= 1)  OR
                             (Burst_length_2 = '1'                             AND Count_precharge(2) >= 2)  OR
                             (Burst_length_4 = '1'                             AND Count_precharge(2) >= 4)  OR
                             (Burst_length_8 = '1'                             AND Count_precharge(2) >= 8))) OR
                             (RW_interrupt_write(2) = '1' AND WR_counter(2) >= 2)) THEN
                            Auto_precharge(2) := '0';
                            Write_precharge(2) := '0';
                            RW_interrupt_write(2) := '0';
                            WAIT FOR tWRa;
                            Pc_b2 := '1';
                            Act_b2 := '0';
                            RP_chk2 := NOW;
                        END IF;
                    END IF;

                    IF ((Auto_precharge(3) = '1') AND (Write_precharge(3) = '1')) THEN
                        IF (((NOW - RAS_chk3 >= tRAS) AND
                           (((Burst_length_1 = '1' OR Write_burst_mode = '1' ) AND Count_precharge(3) >= 1)  OR
                             (Burst_length_2 = '1'                             AND Count_precharge(3) >= 2)  OR
                             (Burst_length_4 = '1'                             AND Count_precharge(3) >= 4)  OR
                             (Burst_length_8 = '1'                             AND Count_precharge(3) >= 8))) OR
                             (RW_interrupt_write(3) = '1' AND WR_counter(3) >= 2)) THEN
                            Auto_precharge(3) := '0';
                            Write_precharge(3) := '0';
                            RW_interrupt_write(3) := '0';
                            WAIT FOR tWRa;
                            Pc_b3 := '1';
                            Act_b3 := '0';
                            RP_chk3 := NOW;
                        END IF;
                    END IF;

                -- Checking internal wires (Optional for debug purpose)
                Pre_chk (0) <= Pc_b0;
                Pre_chk (1) <= Pc_b1;
                Pre_chk (2) <= Pc_b2;
                Pre_chk (3) <= Pc_b3;
                Act_chk (0) <= Act_b0;
                Act_chk (1) <= Act_b1;
                Act_chk (2) <= Act_b2;
                Act_chk (3) <= Act_b3;
                Dq_in_chk   <= Data_in_enable;
                Dq_out_chk  <= Data_out_enable;
                Bank_chk    <= Bank;
                Row_chk     <= Row;
                Col_chk     <= Col;
        END PROCESS;


        -- Clock timing checks
        Clock_check : PROCESS
            VARIABLE Clk_low, Clk_high : TIME := 0 ns;
            BEGIN
                WAIT ON Clk;
                    IF (Clk = '1' AND NOW >= 10 ns) THEN
                        ASSERT (NOW - Clk_low >= tCL)
                            REPORT "tCL violation"
                            SEVERITY WARNING;
                        ASSERT (NOW - Clk_high >= tCK)
                            REPORT "tCK violation"
                            SEVERITY WARNING;
                        Clk_high := NOW;
                    ELSIF (Clk = '0' AND NOW /= 0 ns) THEN
                        ASSERT (NOW - Clk_high >= tCH)
                            REPORT "tCH violation"
                            SEVERITY WARNING;
                        Clk_low := NOW;
                    END IF;
        END PROCESS;

        -- Setup timing checks
        Setup_check : PROCESS
            BEGIN
                WAIT ON Clk;
                    IF Clk = '1' AND Cs_n = '0' THEN
                        ASSERT(Cke'LAST_EVENT >= tCKS)
                            REPORT "CKE Setup time violation -- tCKS"
                            SEVERITY WARNING;
                        ASSERT(Cs_n'LAST_EVENT >= tCMS)
                            REPORT "CS# Setup time violation -- tCMS"
                            SEVERITY WARNING;
                        ASSERT(Cas_n'LAST_EVENT >= tCMS)
                            REPORT "CAS# Setup time violation -- tCMS"
                            SEVERITY WARNING;
                        ASSERT(Ras_n'LAST_EVENT >= tCMS)
                            REPORT "RAS# Setup time violation -- tCMS"
                            SEVERITY WARNING;
                        ASSERT(We_n'LAST_EVENT >= tCMS)
                            REPORT "WE# Setup time violation -- tCMS"
                            SEVERITY WARNING;
                        ASSERT(Dqm'LAST_EVENT >= tCMS)
                            REPORT "Dqm Setup time violation -- tCMS"
                            SEVERITY WARNING;
                        ASSERT(Addr'LAST_EVENT >= tAS)
                            REPORT "ADDR Setup time violation -- tAS"
                            SEVERITY WARNING;
                        ASSERT(Ba'LAST_EVENT >= tAS)
                            REPORT "BA Setup time violation -- tAS"
                            SEVERITY WARNING;
                        IF We_n = '0' AND Cas_n = '0' THEN
                            ASSERT(Dq'LAST_EVENT >= tDS)
                                REPORT "Dq Setup time violation -- tDS"
                                SEVERITY WARNING;
                        END IF;   
                    END IF;   
        END PROCESS;

        -- Hold timing checks
        Hold_check : PROCESS
            BEGIN
                WAIT ON Clk'DELAYED (tCKH), Clk'DELAYED (tCMH), Clk'DELAYED (tAH), Clk'DELAYED (tDH);
                    IF Clk'DELAYED (tCKH) = '1' THEN
                        ASSERT(Cke'LAST_EVENT > tCKH)
                            REPORT "CKE Hold time violation -- tCKH"
                            SEVERITY WARNING;
                    END IF;
                    IF Clk'DELAYED (tCMH) = '1' THEN
                        ASSERT(Cs_n'LAST_EVENT > tCMH)
                            REPORT "CS# Hold time violation -- tCMH"
                            SEVERITY WARNING;
                        ASSERT(Cas_n'LAST_EVENT > tCMH)
                            REPORT "CAS# Hold time violation -- tCMH"
                            SEVERITY WARNING;
                        ASSERT(Ras_n'LAST_EVENT > tCMH)
                            REPORT "RAS# Hold time violation -- tCMH"
                            SEVERITY WARNING;
                        ASSERT(We_n'LAST_EVENT > tCMH)
                            REPORT "WE# Hold time violation -- tCMH"
                            SEVERITY WARNING;
                        ASSERT(Dqm'LAST_EVENT > tCMH)
                            REPORT "Dqm Hold time violation -- tCMH"
                            SEVERITY WARNING;
                    END IF;
                    IF Clk'DELAYED (tAH) = '1' THEN
                        ASSERT(Addr'LAST_EVENT > tAH)
                            REPORT "ADDR Hold time violation -- tAH"
                            SEVERITY WARNING;
                        ASSERT(Ba'LAST_EVENT > tAH)
                            REPORT "BA Hold time violation -- tAH"
                            SEVERITY WARNING;
                    END IF;
                    IF Clk'DELAYED (tDH) = '1' THEN
                        ASSERT(Dq'LAST_EVENT > tDH)
                            REPORT "Dq Hold time violation -- tDH"
                            SEVERITY WARNING;
                    END IF;
        END PROCESS;

END behave;
