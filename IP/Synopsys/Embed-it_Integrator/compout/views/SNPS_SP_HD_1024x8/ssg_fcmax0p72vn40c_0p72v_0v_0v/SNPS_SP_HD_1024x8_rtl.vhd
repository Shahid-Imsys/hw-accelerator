-----------------------------------------------------------------------
--               Copyright(c) Synopsys, Inc.                           
--     All Rights reserved - Unpublished -rights reserved under        
--     the Copyright laws of the United States of America.             
--                                                                     
--  U.S. Patents: 7,093,156 B1 and 7,406,620 B2 (and more pending).    
--                                                                     
--  This file includes the Confidential information of Synopsys, Inc.  
--  and GLOBALFOUNDRIES.                                               
--  The receiver of this Confidential Information shall not disclose   
--  it to any third party and shall protect its confidentiality by     
--  using the same degree of care, but not less than a reasonable      
--  degree of care, as the receiver uses to protect receiver's own     
--  Confidential Information.                                          
--  Licensee acknowledges and agrees that all output generated for     
--  Licensee by Synopsys, Inc. as described in the pertinent Program   
--  Schedule(s), or generated by Licensee through use of any Compiler  
--  licensed hereunder contains information that complies with the     
--  Virtual Component Identification Physical Tagging Standard (VCID)  
--  as maintained by the Virtual Socket Interface Alliance (VSIA).     
--  Such information may be expressed in GDSII Layer 63 or other such  
--  layer designated by the VSIA, hardware definition languages, or    
--  other formats.  Licensee is not authorized to alter or change any  
--  such information.                                                  
-----------------------------------------------------------------------
--                                                                     
--  Built for linux64 and running on linux64.                          
--                                                                     
--  Software           : Rev: S-2021.09-SP1                            
--  Library Format     : Rev: 1.05.00                                  
--  Compiler Name      : gf22nsd41p11s1dcl02msa04p1                    
--  Platform           : Linux3.10.0-957.5.1.el7.x86_64                
--                     : #1 SMP Wed Dec 19 10:46:58 EST 2018x86_64     
--  Date of Generation : Mon May 23 13:56:42 CEST 2022                 
--                                                                     
-----------------------------------------------------------------------
--   --------------------------------------------------------------     
--                       Template Revision : 6.2.5                      
--   --------------------------------------------------------------     
--                      * Synchronous, 1-Port SRAM *                  
--                     * VHDL Behavioral/RTL Model *                  
--                THIS IS A SYNCHRONOUS 1-PORT MEMORY MODEL           
--                                                                    
--   Memory Name:SNPS_SP_HD_1024x8                                    
--   Memory Size:1024 words x 8 bits                                  
--                                                                    
--                               PORT NAME                            
--                               ---------                            
--               Output Ports                                         
--                                   Q[7:0]                           
--               Input Ports:                                         
--                                   ADR[9:0]                         
--                                   D[7:0]                           
--                                   WE                               
--                                   ME                               
--                                   CLK                              
--                                   TEST1                            
--                                   TEST_RNM                         
--                                   RME                              
--                                   RM[3:0]                          
--                                   WA[1:0]                          
--                                   WPULSE[2:0]                      
--                                   LS                               
--                                   BC0                              
--                                   BC1                              
--                                   BC2                              
-- -------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;

entity generic_vhd_SNPS_SP_HD_1024x8 is
  generic (
        words            : integer            := 1024;
        addrbits         : integer            := 10;
        bits             : integer            := 8;
        NW               : integer            := 1;
        NADDR            : integer            := 1;
        rmbits           : integer            := 3;
        wabits           : integer            := 2;
        wpulsebits       : integer            := 3;
        MES_CNTRL        : string             := "ON"
   );
   port (
  Q : out std_logic_vector (bits-1 downto 0);
  ADR : in std_logic_vector (addrbits-1 downto 0);
  D : in std_logic_vector (bits-1 downto 0);
  WE : in std_logic;
  ME : in std_logic;
  CLK : in std_logic;
  TEST1 : in std_logic;
  TEST_RNM : in std_logic;
  RME : in std_logic;
  RM : in std_logic_vector (rmbits-1 downto 0);
  WA : in std_logic_vector (wabits-1 downto 0);
  WPULSE : in std_logic_vector (wpulsebits-1 downto 0);
  LS : in std_logic;
  BC0 : in std_logic;
  BC1 : in std_logic;
  BC2 : in std_logic;
  t3_me : in time
   );
end generic_vhd_SNPS_SP_HD_1024x8;

architecture behav of generic_vhd_SNPS_SP_HD_1024x8 is
subtype A_WORD is std_logic_vector( bits-1 downto 0 );
TYPE  ram_array is ARRAY  (0 to words -1) of std_logic_vector( bits-1 downto 0 );
SIGNAL  allx : std_logic_vector( bits-1 downto 0 ) := (others=>'X');
SIGNAL  allz : std_logic_vector( bits-1 downto 0 ) := (others=>'Z');
SIGNAL  ADR_lat : integer range (2**NADDR)-1 downto 0;
SIGNAL  Q_tmp : std_logic_vector (bits-1 downto 0);

SIGNAL  WE_old : std_logic;
SIGNAL  ME_old : std_logic;
SIGNAL  ADR_old : std_logic_vector(9 downto 0);
SIGNAL  D_old : std_logic_vector(7 downto 0);
SIGNAL  WA_old : std_logic_vector (wabits-1 downto 0);
SIGNAL  WPULSE_old : std_logic_vector (wpulsebits-1 downto 0);
SIGNAL  mes_all_valid : Boolean := false;

--  Address Calculate FUNCTION
function TO_INT( address : std_logic_vector(NADDR-1 downto 0) ) return integer is
        variable add : integer := 0;
begin  
        for index in 0 to NADDR-1 loop
                if( address(index) = '1' ) then
                        add := add + (2**index);
                end if;
        end loop;
        return add;
end TO_INT;

function TO_OR(oper : std_logic_vector) return std_logic is
  variable or_bit : std_logic;
begin
  or_bit := '0';
  for i in oper'RANGE loop
    or_bit := or_bit or oper(i);
  end loop;
  return or_bit;
end TO_OR;

begin


-- Latch Syncronous signals
    ME_old <= ME;
    ADR_old <= ADR;
    D_old <= D;
    WE_old <= WE;
    WA_old <= WA;
    WPULSE_old <= WPULSE;


-- Address Calculate
    ADR_lat <= ADR_lat when (IS_X(ADR)) else TO_INT(ADR_old);



-- Aport Data Output
control_Q:
process( Q_tmp ) begin
-- Normal Mode
   Q <= Q_tmp;
end process;

port_A_B  :
process( CLK, D, BC0, BC1, BC2, TEST_RNM, TEST1, t3_me)
   VARIABLE mem_core_array : ram_array;
   VARIABLE addressx : Boolean := false;
   VARIABLE address : integer;
   VARIABLE WElatched : std_logic;
   VARIABLE MElatched : std_logic;
   VARIABLE ADRlatched : std_logic_vector(9 downto 0);
   VARIABLE Dlatched : std_logic_vector(7 downto 0);
   VARIABLE WAlatched : std_logic_vector(wabits-1 downto 0);
   VARIABLE WPULSElatched : std_logic_vector(wpulsebits-1 downto 0);
   VARIABLE diff_me_tch  : std_ulogic   := '0';
   VARIABLE diff_me_tcc  : std_ulogic   := '0';
   VARIABLE t0_pfirst : time := 0 ns;
   VARIABLE t1_pfirst : time := 0 ns;
   VARIABLE t2_pnow   : time := 0 ns;
   VARIABLE t2_nnow   : time := 0 ns;

   VARIABLE Q_temp : std_logic_vector (bits-1 downto 0);
   VARIABLE Q_test : std_logic_vector (bits-1 downto 0);
   VARIABLE CLK_time : time := 0.0 ns;
   VARIABLE TEST1latched : std_ulogic := '0';
   VARIABLE TEST_RNMlatched : std_ulogic := '0';


function local_slr ( oper : STD_LOGIC_VECTOR; count : NATURAL) return STD_LOGIC_VECTOR is
   variable temp_oper : STD_LOGIC_VECTOR(oper'range) := oper;
   variable value : STD_LOGIC_VECTOR(oper'range);
 begin
  value(oper'Left+count-1 downto oper'Left) := ( others => '0');
  value(oper'Left-count downto oper'Right) := oper(oper'Left downto oper'Right+count);
  return (value);
 end local_slr;

function TO_XOR(oper : std_logic_vector) return std_logic is
  variable xor_bit : std_logic;
begin
  xor_bit := '0';
  for i in oper'RANGE loop
    xor_bit := xor_bit xor oper(i);
  end loop;
  return xor_bit;
end TO_XOR;

-- converts vector to integer
function to_unsigned_integer (oper : STD_LOGIC_VECTOR) return INTEGER is
 variable value : INTEGER := 0;
 variable temp_no : INTEGER := 1;
 variable temp_oper : STD_LOGIC_VECTOR(oper'range) := oper;
 variable INDEX : INTEGER := 1;
 begin
  if ( MES_CNTRL="ON" or MES_CNTRL="WARN") then
  assert oper'length <= 31
  report "VIRL_MEM_WARNING: argument is too large in TO_INTEGER, only lower 31 bits will be taken"
  severity note;
  end if;
  if (not (Is_X(oper))) then
   for I in temp_oper'reverse_range loop
    case (temp_oper(I)) is
     when '1' =>
      value := value + temp_no;
     when others =>
      null;
    end case;
    INDEX := INDEX + 1;
    exit when INDEX > 31;
    temp_no := temp_no + temp_no;
   end loop;
  else
   if( MES_CNTRL="ON" or MES_CNTRL="WARN" ) then
   assert FALSE report "VIRL_MEM_WARNING: Illegal value detected in conversion TO_unsigned_INTEGER" severity note;
   end if;
   value := 0;
  end if;
  return (value);
 end to_unsigned_integer;

function to_std_logicvector (oper,no_of_bits : NATURAL) return STD_LOGIC_VECTOR is
 variable temp_oper : NATURAL := 0;
 variable vect : STD_LOGIC_VECTOR(no_of_bits-1 downto 0) := (others => '0');
 begin
  temp_oper := oper;
  for i in vect'reverse_range loop
   if ((temp_oper mod 2) = 1) then
    vect(i) := '1';
   else
    vect(i) := '0';
   end if;
   temp_oper := temp_oper/2;
  end loop;
  return (vect);
 end to_std_logicvector;
 

procedure trash_mem(mem_core_array : inout ram_array) is
 variable word_line : std_logic_vector (7 downto 0);
 begin
  for i in 0 to 1023 loop
   word_line := mem_core_array(i);
   for j in 0 to 7 loop
    word_line(j) := 'X';
   end loop;
   mem_core_array(i) := word_line;
  end loop;
 end;



procedure corrupt_cur_loc(mem_core_array : inout ram_array; Adr : in NATURAL) is
 variable word_line : std_logic_vector (7 downto 0);
 begin
  word_line := mem_core_array(Adr);
  for i in 0 to 7 loop
   word_line(i) := 'X';
  end loop;
  mem_core_array(Adr) := word_line;
 end;



-- function for sll operation ( Modelsim Requirement)

   function local_sll ( oper : STD_LOGIC_VECTOR; count : NATURAL) return STD_LOGIC_VECTOR is
        variable temp_oper : STD_LOGIC_VECTOR(oper'range) := oper;
        variable value : STD_LOGIC_VECTOR(oper'range);
    begin
     value(oper'Right+count-1 downto oper'Right) := ( others => '0');
     value(oper'Left downto oper'Right+count) := oper(oper'Left-count downto oper'Right);
     return (value);
    end local_sll;
 
-- function for sla operation ( Modelsim Requirement)
 
   function local_sla ( oper : BIT_VECTOR; count : NATURAL) return BIT_VECTOR is
        variable temp_oper : BIT_VECTOR(oper'range) := oper;
        variable value : BIT_VECTOR(oper'range);
    begin
     value(oper'Right+count-1 downto oper'Right) := ( others => oper(oper'Right));
     value(oper'Left downto oper'Right+count) := oper(oper'Left-count downto oper'Right);
     return (value);
    end local_sla;
 
begin




  if ( CLK'event and CLK /= '0' ) then
    t0_pfirst := t1_pfirst;
    t1_pfirst := t2_pnow;
    t2_pnow := now;
    if ((t1_pfirst < t3_me) and (t3_me < t2_pnow)) then
      diff_me_tch := '1';
    end if;
    if ((t0_pfirst < t3_me) and (t3_me < t2_pnow)) then
      diff_me_tcc := '1';
    end if;
  end if;
  if ( CLK'event and CLK = '0' ) then
      t2_nnow := now;
  end if;
  if ( CLK'event and CLK /= '1' and CLK'last_value /= '0' ) then
    diff_me_tch := '0';
    diff_me_tcc := '0';
  end if;

  if ( t3_me'event ) then
    if ((t2_pnow < t3_me) and (t2_nnow < t3_me)) then
      diff_me_tch := '1';
    end if;
  end if;


-- Normal Mode
-- CLK 0->X OR X->1 OR 1->X 
 if( ( CLK'event and CLK'last_value='0' and CLK='X' ) and (diff_me_tch = '1' or ME /= '0') ) then          -- if CLK 0->X
    if( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid ) then
      assert false report "<<VIRL_MEM_ERR:CLK(0->X) unknown>>" severity note;
    end if;
    trash_mem(mem_core_array);
    Q_tmp <= allx;
 elsif( ( CLK'event and CLK'last_value='X' and CLK='1' ) and (diff_me_tch = '1' or ME /= '0') ) then       -- if CLK X->1
    Q_tmp <= allx;
 elsif( ( CLK'event and CLK'last_value='1' and CLK='X' ) and (diff_me_tch = '1' or ME /= '0') ) then       -- if CLK 1->X
   if( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid ) then
     assert false report "<<VIRL_MEM_ERR:CLK(1->X) unknown>>" severity note;
   end if;
   trash_mem(mem_core_array);
   Q_tmp <= allx;
 end if;

-- Negedge of CLK
 if( CLK'event and CLK'last_value='1' and CLK='0' ) then       -- if CLK 1->0
    if ( TEST1latched = '1' and MElatched = '1' and WElatched /= '1' and ADR_lat < NW   and TEST_RNM='0' ) then

      Q_temp := mem_core_array(to_unsigned_integer(ADRlatched));
      Q_tmp <= Q_temp;
    end if;
 end if;

-- Posedge of CLK
 if( CLK'event and CLK'last_value='0' and CLK='1' ) then       -- if CLK 0->1
      CLK_time := NOW;
       ADRlatched := TO_X01(ADR_old);
       MElatched := TO_X01(ME_old);
       WElatched := TO_X01(WE_old);
       Dlatched := TO_X01(D_old);
       TEST1latched := TO_X01(TEST1);
       TEST_RNMlatched := TO_X01(TEST_RNM);
       WAlatched := TO_X01(WA_old);
       WPULSElatched := TO_X01(WPULSE_old);
       if (TEST_RNMlatched = '1') then
         MElatched := '0';
       end if;

       if (LS = 'X' and MElatched /= '0') then
         if( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid ) then
           assert false report "<<VIRL_MEM_ERR: LS unknown>>" severity note;
         end if;
         trash_mem(mem_core_array);
         Q_tmp <= allx;
       elsif ( BC0 = 'X' and WElatched /='0') then
         if( (MES_CNTRL="ON" or MES_CNTRL="WARN") and NOW /= 0 ns and mes_all_valid ) then
          --assert false report "<<VIRL_MEM_WARN: BC0 unknown >>" severity note;
         end if;
       elsif ( (BC1 = 'X' or BC2 = 'X') and WElatched /='0') then
         if( (MES_CNTRL="ON" or MES_CNTRL="WARN") and NOW /= 0 ns and mes_all_valid ) then
          --assert false report "<<VIRL_MEM_WARN: BC1 or BC2 unknown >>" severity note;
         end if;
       else 
-- Check for ADR unknown
       if ( IS_X(ADRlatched) and MElatched /= '0' and (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid ) then
         assert false report "<<VIRL_MEM_ERR:ADR unknown>>" severity note;
       end if;

       addressx := IS_X(ADRlatched);
      if ( not addressx) then
        address := to_unsigned_integer(ADRlatched);
      end if ;                            

 
-- Normal read/write operation 
-- ME = X
    if( MElatched ='X' ) then
      if( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid ) then
        assert false report "<<VIRL_MEM_ERR:ME unknown>>" severity note;
      end if;
       trash_mem(mem_core_array);
        if( WElatched = '1' ) then   -- if Write mode and ME is X
          if( IS_X(ADRlatched) ) then
          elsif( ADR_lat >= NW ) then
            if( (MES_CNTRL="ON" or MES_CNTRL="WARN") and mes_all_valid ) then
              assert false report "<<VIRL_MEM_WARNING: ADR greater fixed WORD space>>" severity note;
            end if; --end if of MES_CNTRL
          else
           if( (MES_CNTRL="ON" or MES_CNTRL="ERR")and NOW /= 0 ns and mes_all_valid ) then
             assert false report "<<VIRL_MEM_ERR: Valid ADR ,but memory corrupted due to unknown ME >>" severity note;
           end if;  --end if of MES_CNTRL
          end if;   --end if of IS_X(ADRlatched)
        elsif ( WElatched = '0' ) then         -- else if Read and ME is X
          Q_tmp <= allx;
        end if;                      -- end of if write enable and ME is X
    end if;          -- end of if ME X

-- ME=1  (ME Enable)
    if( MElatched ='1' ) then
-- Memory Enable & Read mode
     if( WElatched='0' ) then
       if ( IS_X(RM) ) then 
           if ( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid and RME = '1' ) then
             assert false report "<<VIRL_MEM_ERR:RM unknown>>" severity note;
           end if;  --end if of MES_CNTRL
           Q_tmp <= allx;
       else
        if ( IS_X(TEST1) ) then
          if( (MES_CNTRL="ON" or MES_CNTRL="ERR")and NOW /= 0 ns and mes_all_valid  ) then
            assert false report "<<VIRL_MEM_ERR:TEST1 unknown>>" severity note;
          end if;  --end if of MES_CNTRL
          Q_tmp <= allx;
        elsif ( IS_X(TEST_RNMlatched) ) then
          if( (MES_CNTRL="ON" or MES_CNTRL="ERR")and NOW /= 0 ns and mes_all_valid  ) then
            assert false report "<<VIRL_MEM_ERR:TEST_RNM unknown>>" severity note;
          end if;  --end if of MES_CNTRL
          Q_tmp <= allx;
          trash_mem(mem_core_array);
        elsif( IS_X(ADRlatched) ) then    -- if WE disable, ME enable & Address X
          Q_tmp <= allx;
          trash_mem(mem_core_array);
        elsif( ADR_lat >= NW ) then     -- else if of Add X
          if( (MES_CNTRL="ON" or MES_CNTRL="WARN")and mes_all_valid ) then 
            assert false report "<<VIRL_MEM_WARNING: ADR greater fixed WORD space>>" severity note;
          end if;
          Q_tmp <= allx;
        else                                       -- else of Add X (Normal Read memory)
          Q_temp := mem_core_array(ADR_lat);
          Q_tmp <= Q_temp;
          if ( TEST1 = '1' ) then
            Q_tmp <= allx;
          end if;
        end if;  -- end of address check
       end if;  -- end of RM X

-- Memory enable and Write mode 
    elsif( WElatched='1' ) then     


       if ( IS_X(RM) ) then 
         if ( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid and RME = '1' ) then
           assert false report "<<VIRL_MEM_ERR:RM unknown>>" severity note;
         end if;

         corrupt_cur_loc(mem_core_array,address);
       else
        if ( IS_X(TEST1) ) then
         if( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid  ) then
           assert false report "<<VIRL_MEM_ERR: TEST1 unknown - Write mode>>" severity note;
         end if;

         corrupt_cur_loc(mem_core_array,address);
        elsif ( IS_X(TEST_RNMlatched) ) then
          if( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid  ) then
            assert false report "<<VIRL_MEM_ERR: TEST_RNM unknown - Write mode>>" severity note;
          end if;
        trash_mem(mem_core_array);
        elsif( IS_X(ADRlatched) ) then    -- if Add X 
          trash_mem(mem_core_array);

        elsif( ADR_lat >= NW ) then    -- else if of Add X
         if( (MES_CNTRL="ON" or MES_CNTRL="WARN")and mes_all_valid ) then
           assert false report "<<VIRL_MEM_WARNING: ADR greater fixed WORD space>>" severity note;
         end if;
        else                                   -- else of Add X (Memory write)
        mem_core_array(ADR_lat) := Dlatched;
        Q_temp :=  mem_core_array(ADR_lat);
        mes_all_valid <= true;
          if ( IS_X(Dlatched) and (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid  ) then
            assert false report "<<VIRL_MEM_ERR:D unknown>>" severity note;
          end if;
        end if;
       end if;         -- end of RM is X

-- Memory is enable and Write enable is X
    elsif( WElatched='X' ) then
      Q_tmp <= allx;
      if( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid  ) then
        assert false report "<<VIRL_MEM_ERR:WE unknown>>" severity note;
      end if;

      if( IS_X(ADRlatched) ) then    -- WE and Add both X
        trash_mem(mem_core_array);
      elsif( ADR_lat >= NW ) then   -- else if of Add X and WE X
        if( (MES_CNTRL="ON" or MES_CNTRL="WARN")and mes_all_valid ) then
          assert false report "<<VIRL_MEM_WARNING: ADR greater fixed WORD space>>" severity note;
        end if;
      else      -- else of Add X
        corrupt_cur_loc(mem_core_array,address);
      end if;
    end if;
    if( MElatched /='0' ) then
      if ( IS_X(WAlatched) and WElatched /= '0') then
        if( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid  ) then
          assert false report "<<VIRL_MEM_ERR: WA unknown - Write mode>>" severity note;
        end if;
        trash_mem(mem_core_array);
      end if;
      if ( IS_X(WPULSElatched) and WElatched /= '0') then
        if( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid  ) then
          assert false report "<<VIRL_MEM_ERR: WPULSE unknown - Write mode>>" severity note;
        end if;
        trash_mem(mem_core_array);
      end if;
    end if;
 end if;


   end if; -- end of else of no power control pin unknown
 end if; -- end of posedge of clock
 if (BC0'event and NOW /= 0 ns) then
   if ( LS /= '0') then
      if( (MES_CNTRL="ON" or MES_CNTRL="WARN") and NOW /= 0 ns and mes_all_valid ) then
        assert false report "<<VIRL_MEM_WARN: Assertion on BC0 pin during Light Sleep >>" severity note;
      end if;
      trash_mem(mem_core_array);
   end if;
   if ( BC0 = 'X' ) then
     if( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid ) then
       assert false report "<<VIRL_MEM_ERR: BC0 unknown >>" severity note;
     end if;
     trash_mem(mem_core_array);
   end if;
 end if;

 if (( BC1'event or BC2'event ) and NOW /= 0 ns) then
   if ( LS /= '0') then
      if( (MES_CNTRL="ON" or MES_CNTRL="WARN") and NOW /= 0 ns and mes_all_valid ) then
        assert false report "<<VIRL_MEM_WARN: Assertion on BC1/2 pin during Light Sleep >>" severity note;
      end if;
      trash_mem(mem_core_array);
   end if;
   if ( BC1 = 'X' ) then
     if( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid ) then
       assert false report "<<VIRL_MEM_ERR: BC1 unknown >>" severity note;
     end if;
     trash_mem(mem_core_array);
   end if;
   if ( BC2 = 'X') then
     if( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns and mes_all_valid ) then
       assert false report "<<VIRL_MEM_ERR: BC2 unknown >>" severity note;
     end if;
     trash_mem(mem_core_array);
   end if;
 end if;


      if ( TEST1'event and TEST1 = '1' ) then
        if ( TEST1 = '1' ) then
         if( (MES_CNTRL="ON"or MES_CNTRL="WARN") and NOW /= 0 ns and mes_all_valid ) then
          assert FALSE
          report "<<VIRL_MEM_WARNING: Tcc value in the RAM model is for TEST1=0,but the input value is TEST1=1 >>"
          severity note;
          end if;
        end if;
        if ( CLK='1' and MElatched = '1' ) then
          Q_tmp <= allx;
        end if;
      end if;
   if ( TEST_RNM'event and TEST1latched = '1' and CLK='1' and ME_old = '1' ) then
     if ( WElatched = '1' ) then
       corrupt_cur_loc(mem_core_array,address);
       else
         Q_tmp <= allx;
       end if;
   end if;

  end process;

end behav;

---------------- ACTUAL MEMORY DESCRIPTION   ---------------------------

library IEEE;
library work;
use IEEE.std_logic_1164.all;

entity SNPS_SP_HD_1024x8 is

  generic (
        XGenerationOn     : Boolean                := True;
        words             : integer                := 1024;
        addrbits          : integer                := 10;
        bits              : integer                := 8;
        MES_CNTRL         : string                 := "ON"
   );

 port (
        Q : out std_logic_vector(7 downto 0);
        ADR : in std_logic_vector(9 downto 0);
        D : in std_logic_vector(7 downto 0);
        WE : in std_logic;
        ME : in std_logic;
        CLK : in std_logic;
        TEST1 : in std_logic;
        TEST_RNM : in std_logic;
        RME : in std_logic;
        RM : in std_logic_vector(3 downto 0);
        WA : in std_logic_vector(1 downto 0);
        WPULSE : in std_logic_vector(2 downto 0);
        LS : in std_logic;
        BC0 : in std_logic;
        BC1 : in std_logic;
        BC2 : in std_logic );

end SNPS_SP_HD_1024x8;

architecture behaviour of SNPS_SP_HD_1024x8 is

component generic_vhd_SNPS_SP_HD_1024x8
  generic (
        words             : integer                := 1024;
        addrbits          : integer                := 10;
        bits              : integer                := 8;
        NW                : integer                := 1;
        NADDR             : integer                := 1;
        rmbits            : integer                := 3;
        wabits            : integer                := 2;
        wpulsebits        : integer                := 3;
        MES_CNTRL         : string                 := "ON"
  );

  port (
  Q : out std_logic_vector (bits-1 downto 0);
  ADR : in std_logic_vector (addrbits-1 downto 0);
  D : in std_logic_vector (bits-1 downto 0);
  WE : in std_logic;
  ME : in std_logic;
  CLK : in std_logic;
  TEST1 : in std_logic;
  TEST_RNM : in std_logic;
  RME : in std_logic;
  RM : in std_logic_vector (rmbits-1 downto 0);
  WA : in std_logic_vector (wabits-1 downto 0);
  WPULSE : in std_logic_vector (wpulsebits-1 downto 0);
  LS : in std_logic;
  BC0 : in std_logic;
  BC1 : in std_logic;
  BC2 : in std_logic;
  t3_me : in time
  );

end component;

SIGNAL WE_buf : STD_LOGIC;
SIGNAL ME_buf : STD_LOGIC;
SIGNAL t3_me  : time := 0 ns;

SIGNAL WElatched  :STD_LOGIC ;
SIGNAL MElatched  :STD_LOGIC ;
SIGNAL ADR_buf : STD_LOGIC_VECTOR(9 downto 0) := (others=>'0');
SIGNAL ADR_mout : STD_LOGIC_VECTOR(9 downto 0) := (others=>'0');
SIGNAL D_buf : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');
SIGNAL D_mout : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');
SIGNAL WE_mout  :STD_LOGIC ;
SIGNAL ME_mout  :STD_LOGIC ;
SIGNAL TEST1latched  :STD_LOGIC ;
SIGNAL LS_old  :STD_LOGIC ;
SIGNAL LS_buf1  :STD_LOGIC ;
SIGNAL CLK_mem  :STD_LOGIC := '0';
SIGNAL WA_old  :STD_LOGIC_VECTOR(1 downto 0);
SIGNAL WPULSE_old  :STD_LOGIC_VECTOR(2 downto 0);

SIGNAL RMVAL  : STD_LOGIC_VECTOR(2 downto 0) := "011";
SIGNAL RM_int : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL disp_LS_msg :STD_LOGIC :='1';


SIGNAL CLK_buf: STD_LOGIC;
SIGNAL TEST1_buf: STD_LOGIC;
SIGNAL TEST_RNM_buf: STD_LOGIC;
SIGNAL RME_buf: STD_LOGIC;
SIGNAL RM_buf: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL WA_buf: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL WPULSE_buf: STD_LOGIC_VECTOR(2 downto 0);
SIGNAL LS_buf: STD_LOGIC;
SIGNAL BC0_buf: STD_LOGIC;
SIGNAL BC1_buf: STD_LOGIC;
SIGNAL BC2_buf: STD_LOGIC;


  for uut : generic_vhd_SNPS_SP_HD_1024x8 use entity work.generic_vhd_SNPS_SP_HD_1024x8(behav);
  BEGIN

  LS_buf1 <= LS_buf;
 process ( CLK_buf,LS_buf1 )
  begin
    if ( (CLK_buf'last_value /= '0' and CLK_buf = '0')) then
      LS_old <= LS_buf1;
    end if;
  end process;

    CLK_mem <= '0' when (LS_old = '1' and CLK_buf /= 'X' and ME_mout /= 'X' ) else CLK_buf;
  process ( CLK_buf, ADR_buf )
  begin
    if ( (CLK_buf'last_value /= '0' and CLK_buf = '0') or NOW = 0 ns ) then
      ADR_mout <= ADR_buf;
    end if;
  end process;

  process ( CLK_buf, D_buf )
  begin
    if ( (CLK_buf'last_value /= '0' and CLK_buf = '0') or NOW = 0 ns ) then
      D_mout <= D_buf;
    end if;
  end process;

  process ( CLK_buf, ME_buf )
  begin
    if ( (CLK_buf'last_value /= '0' and CLK_buf = '0') or NOW = 0 ns ) then
      ME_mout <= ME_buf;
    end if;
  end process;

  process ( CLK_buf, WE_buf )
  begin
    if ( (CLK_buf'last_value /= '0' and CLK_buf = '0') or NOW = 0 ns ) then
      WE_mout <= WE_buf;
    end if;
  end process;

  process ( CLK_buf, WA_buf )
  begin
    if ( (CLK_buf'last_value /= '0' and CLK_buf = '0') or NOW = 0 ns ) then
      WA_old <= WA_buf;
    end if;
  end process;

  process ( CLK_buf, WPULSE_buf )
  begin
    if ( (CLK_buf'last_value /= '0' and CLK_buf = '0') or NOW = 0 ns ) then
      WPULSE_old <= WPULSE_buf;
    end if;
  end process;

  process(RM_buf(3))
  begin
    if(RM_buf(3) = 'X' ) then
      if ( (MES_CNTRL= "ON" or MES_CNTRL = "WARN") and NOW /= 0 ns) then
        assert false report "<<VIRL_MEM_WARNING: RM[3] is unknown>>" severity note;
      end if;
    end if;
  end process;



  uut : generic_vhd_SNPS_SP_HD_1024x8
  generic map (
        NW                     => 1024, 
        NADDR                  => 10,
        rmbits                 => 3,
        words                  => 1024,
        addrbits               => 10,
        bits                   => 8,
        MES_CNTRL                => MES_CNTRL
  )
  port map (
   Q =>    Q,
   ADR =>    ADR_mout,
   D =>    D_mout,
   WE =>    WE_mout,
   ME =>    ME_mout,
   CLK =>    CLK_mem,
   TEST1 =>    TEST1_buf,
   TEST_RNM =>    TEST_RNM_buf,
   RME =>    RME_buf,
   RM =>    RM_int,
   WA =>    WA_old,
   WPULSE =>    WPULSE_old,
   LS =>    LS_old,
   BC0 =>    BC0_buf,
   BC1 =>    BC1_buf,
   BC2 =>    BC2_buf,
   t3_me => t3_me
  );

    ADR_buf(0) <= 'X' when ADR(0) = 'Z' else  ADR(0);
    ADR_buf(1) <= 'X' when ADR(1) = 'Z' else  ADR(1);
    ADR_buf(2) <= 'X' when ADR(2) = 'Z' else  ADR(2);
    ADR_buf(3) <= 'X' when ADR(3) = 'Z' else  ADR(3);
    ADR_buf(4) <= 'X' when ADR(4) = 'Z' else  ADR(4);
    ADR_buf(5) <= 'X' when ADR(5) = 'Z' else  ADR(5);
    ADR_buf(6) <= 'X' when ADR(6) = 'Z' else  ADR(6);
    ADR_buf(7) <= 'X' when ADR(7) = 'Z' else  ADR(7);
    ADR_buf(8) <= 'X' when ADR(8) = 'Z' else  ADR(8);
    ADR_buf(9) <= 'X' when ADR(9) = 'Z' else  ADR(9);
    D_buf(0) <= 'X' when D(0) = 'Z' else  D(0);
    D_buf(1) <= 'X' when D(1) = 'Z' else  D(1);
    D_buf(2) <= 'X' when D(2) = 'Z' else  D(2);
    D_buf(3) <= 'X' when D(3) = 'Z' else  D(3);
    D_buf(4) <= 'X' when D(4) = 'Z' else  D(4);
    D_buf(5) <= 'X' when D(5) = 'Z' else  D(5);
    D_buf(6) <= 'X' when D(6) = 'Z' else  D(6);
    D_buf(7) <= 'X' when D(7) = 'Z' else  D(7);
    WE_buf <= 'X' when WE = 'Z' else  WE;
    ME_buf <= 'X' when ME = 'Z' else  ME;
    CLK_buf <= 'X' when CLK = 'Z' else  CLK;
    TEST1_buf <= 'X' when TEST1 = 'Z' else  TEST1;
    TEST_RNM_buf <= 'X' when TEST_RNM = 'Z' else  TEST_RNM;
    RME_buf <= 'X' when RME = 'Z' else  RME;
    RM_buf(0) <= 'X' when RM(0) = 'Z' else  RM(0);
    RM_buf(1) <= 'X' when RM(1) = 'Z' else  RM(1);
    RM_buf(2) <= 'X' when RM(2) = 'Z' else  RM(2);
    RM_buf(3) <= 'X' when RM(3) = 'Z' else  RM(3);
    WA_buf(0) <= 'X' when WA(0) = 'Z' else  WA(0);
    WA_buf(1) <= 'X' when WA(1) = 'Z' else  WA(1);
    WPULSE_buf(0) <= 'X' when WPULSE(0) = 'Z' else  WPULSE(0);
    WPULSE_buf(1) <= 'X' when WPULSE(1) = 'Z' else  WPULSE(1);
    WPULSE_buf(2) <= 'X' when WPULSE(2) = 'Z' else  WPULSE(2);
    LS_buf <= 'X' when LS = 'Z' else  LS;
    BC0_buf <= 'X' when BC0 = 'Z' else  BC0;
    BC1_buf <= 'X' when BC1 = 'Z' else  BC1;
    BC2_buf <= 'X' when BC2 = 'Z' else  BC2;

process(ME_buf)

VARIABLE t3_me_tmp : time := 0 ns;

begin

  if ( ME_buf'event ) then
    t3_me_tmp := now;
    t3_me <= t3_me_tmp;
  end if;

end process;
   RM_int <= RM(2 downto 0) when RME_buf = '1' else RMVAL when RME_buf = '0' else (others=>'X');

     
process (CLK_buf)
begin
   if ( CLK_buf'event and CLK_buf'last_value='0' and CLK_buf = '1') then
     if ( RME_buf = 'X' and ME_buf = '1' ) then
       if( (MES_CNTRL="ON" or MES_CNTRL="ERR") and NOW /= 0 ns  ) then
         assert false report "<<VIRL_MEM_ERR:RME unknown>>" severity note;
       end if;
     end if;
   end if;
end process;


process (LS_buf,CLK_buf)
begin
  if (LS_buf'event and LS_buf'last_value /= '0' and LS_buf /= '1') then
    disp_LS_msg <= '1';
  end if;

  if (LS_buf = '1' and ME_mout /= '0' and (LS_buf'event or (CLK_buf'event and CLK_buf /= '0' and CLK_buf'last_value /= '1'))) then
    if( (MES_CNTRL="ON" or MES_CNTRL="WARN") and disp_LS_msg = '1' ) then
      assert FALSE report "<<VIRL_MEM_WARNING:  No Operation as Memory is in Light Sleep mode.>>" severity note;
      disp_LS_msg <= '0';
    end if;
  end if;
end process;

end behaviour;

configuration conf_SNPS_SP_HD_1024x8_behaviour of SNPS_SP_HD_1024x8 is
for behaviour
end for;
end conf_SNPS_SP_HD_1024x8_behaviour;
