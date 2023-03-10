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
--  Software           : Rev: U-2022.12                                
--  Library Format     : Rev: 1.05.00                                  
--  Compiler Name      : gf22nsd41p10s1dvl01msa03                      
--  Platform           : Linux3.10.0-957.5.1.el7.x86_64                
--                     : #1 SMP Wed Dec 19 10:46:58 EST 2018x86_64     
--  Date of Generation : Fri Dec 09 14:03:48 CET 2022                  
--                                                                     
-----------------------------------------------------------------------
--   --------------------------------------------------------------     
--                       Template Revision : 3.1.0                      
--   --------------------------------------------------------------     

--                      * Synchronous, 1-Port ROM *                   
--     WARNING: Ports with underscores not allowed in VITAL models    
--                THIS IS A SYNCHRONOUS 1-PORT MEMORY MODEL           
--                                                                    
--   Memory Name:SNPS_ROM_4Kx80_mprom00                               
--   Memory Size:4096 words x 80 bits                                 
--                                                                    
--                               PORT NAME                            
--                               ---------                            
--               Output Ports                                         
--                                   Q[79:0]                          
--               Input Ports:                                         
--                                   ADR[11:0]                        
--                                   ME                               
--                                   CLK                              
--                                   LS                               
--                                   TEST1                            
--                                   RM[3:0]                          
--                                   RME                              
-- -------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.TEXTIO.ALL;


entity generic_vhd_SNPS_ROM_4Kx80_mprom00 is
  generic (
        PreloadFilename   : string               := "SNPS_ROM_4Kx80_mprom00.hex";
        TimingChecksOn    : Boolean              := True;
        XGenerationOn     : Boolean              := True;
        words             : integer              := 4096;
        addrbits          : integer              := 12;
        rmbits            : integer              := 4;
        bits              : integer              := 80;
        MES_CNTRL           : string              := "ON"
   );
   port (
  Q : out std_logic_vector (bits-1 downto 0);
  ADR : in std_logic_vector (addrbits-1 downto 0);
  ME : in std_logic;
  CLK : in std_logic;
  LS : in std_logic;
  TEST1 : in std_logic;
  RM : in std_logic_vector (rmbits-1 downto 0);
  RME : in std_logic;
  t3_me : in time
   );
end generic_vhd_SNPS_ROM_4Kx80_mprom00;

architecture behav of generic_vhd_SNPS_ROM_4Kx80_mprom00 is

SIGNAL DataX  : std_logic_vector(bits-1 downto 0) := ( others => 'X' );
SIGNAL DataZ  : std_logic_vector(bits-1 downto 0) := ( others => 'Z' );
SIGNAL Q_tmp : std_logic_vector (bits-1 downto 0);
SIGNAL Q_local_prev : std_logic_vector (bits-1 downto 0);
SIGNAL  mes_all_valid : Boolean := false;

SIGNAL  ADR_ipd : std_logic_vector (addrbits-1 downto 0);
SIGNAL ME_ipd : std_ulogic;
SIGNAL TEST1_ipd : std_ulogic;
    
 function to_unsigned_integer (oper : STD_LOGIC_VECTOR) return INTEGER is
   variable value : INTEGER := 0;
   variable temp_no : INTEGER := 1;
   variable temp_oper : STD_LOGIC_VECTOR(oper'range) := oper;
   variable INDEX : INTEGER := 1;
   begin
     assert oper'length <= 31
     report "VIRL_MEM_WARNING: argument is too large in TO_INTEGER, only lower 31 bits will be taken"
     severity NOTE;
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
         assert FALSE report
         "VIRL_MEM_WARNING: Illegal value detected in the conversion of TO_unsigned_INTEGER"
         severity NOTE;
          --value := integer'LEFT;
         value := 0;
       end if;
        return (value);
  end to_unsigned_integer;


BEGIN

  ME_ipd <= ME ;
  ADR_ipd <= ADR ;
  TEST1_ipd <= TEST1 ;



PROCESS ( ADR_ipd,ME_ipd,CLK,LS,TEST1_ipd )

VARIABLE  ADRlatched : std_logic_vector (addrbits-1 downto 0);
VARIABLE  ADR_old : std_logic_vector (addrbits-1 downto 0);
VARIABLE MElatched : std_ulogic;
VARIABLE ME_old : std_ulogic;
VARIABLE LSlatched : std_ulogic;
VARIABLE TEST1latched : std_ulogic;
VARIABLE TEST1_old : std_ulogic;
VARIABLE  RMlatched : std_logic_vector (rmbits-1 downto 0);
VARIABLE RMElatched : std_ulogic;
VARIABLE ADR_lat  : integer range (2**addrbits)-1 downto 0;
subtype A_WORD is std_logic_vector( 79 downto 0 );
type    ROM_ARRAY is array (0 to words - 1 ) of A_WORD;
FILE rom_data_file : TEXT IS IN PreloadFilename;
VARIABLE rom_init : BOOLEAN := FALSE;
VARIABLE rom_row : LINE;
VARIABLE cnt : INTEGER := 0;
VARIABLE mem_core_array : ROM_ARRAY;
VARIABLE Q_int : std_logic_vector(79 downto 0);
VARIABLE Q_test : std_logic_vector(79 downto 0);
VARIABLE diff_me_tch  : std_ulogic   := '0';
VARIABLE diff_me_tcc  : std_ulogic   := '0';
VARIABLE t0_pfirst : time := 0 ns;
VARIABLE t1_pfirst : time := 0 ns;
VARIABLE t2_pnow   : time := 0 ns;
VARIABLE t2_nnow   : time := 0 ns;


-- Address Calculate FUNCTION
function TO_INT( address : std_logic_vector ) return integer is
  variable add : integer := 0;
begin
  for index in 0 to addrbits-1 loop
    if( address(index) = '1' ) then
      add := add + (2**index);
    end if;
  end loop;
    return add;
end TO_INT;

-- function for sll operation ( Modelsim Requirement)

 function local_sll ( oper : STD_LOGIC_VECTOR; count : INTEGER) return STD_LOGIC_VECTOR is
   variable temp_oper : STD_LOGIC_VECTOR(oper'range) := oper;
   variable value : STD_LOGIC_VECTOR(oper'range);
     begin
       value(oper'Right+count-1 downto oper'Right) := ( others => '0');
       value(oper'Left downto oper'Right+count) := oper(oper'Left-count downto oper'Right);
     return (value);
     end local_sll;


BEGIN

-- ROM Initialization
if (rom_init = false) then
  while not endfile(rom_data_file) and (cnt < 4096) loop
    readline(rom_data_file, rom_row);
    hread( rom_row, mem_core_array(cnt));
    cnt := cnt + 1;
  end loop;
  rom_init := true;
end if;


        
if ((CLK'event and CLK = '0' and CLK'last_value = '1') or ADR_ipd'event ) then
  if ( CLK = '0' ) then
    ADR_old := ADR_ipd;
  end if;
end if;

if ((CLK'event and CLK = '0' and CLK'last_value = '1') or ME_ipd'event ) then
  if ( CLK = '0' ) then
    ME_old := ME_ipd;
  end if;
end if;

if ((CLK'event and CLK = '0' and CLK'last_value = '1') or TEST1_ipd'event ) then
  if ( CLK = '0' ) then
    TEST1_old := TEST1_ipd;
  end if;
end if;


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

-- CLK 0->X
if ( CLK'event and CLK'last_value = '0' and CLK = 'X' and (diff_me_tch = '1' or ME /= '0')) then
  if( (MES_CNTRL="ON"  or MES_CNTRL = "ERR")  and mes_all_valid  ) then
    assert false report "<<VIRL_MEM_ERR: CLK(0->X) unknown>>" severity note;
  end if;
  Q_tmp <= DataX;

-- CLK X->1
elsif ( CLK'event and CLK'last_value = 'X' and CLK = '1' and (diff_me_tch = '1' or ME /= '0') ) then
      Q_tmp <= DataX;

-- CLK 1->X
elsif ( CLK'event and CLK'last_value='1' and CLK = 'X' and ME /= '0' ) then
  if( (MES_CNTRL="ON"  or MES_CNTRL = "ERR")  and mes_all_valid  ) then
    assert false report "<<VIRL_MEM_ERR: CLK(1->X) unknown>>" severity note;
  end if;
  Q_tmp <= DataX;
-- CLK 1->0
elsif ( CLK'event and CLK'last_value = '1' and CLK = '0') then
  if ( TEST1latched = '1'  and MElatched = '1' and ADR_lat < words  ) then
    Q_int := mem_core_array(to_unsigned_integer(ADRlatched));
    Q_tmp <= Q_int(79 downto 0); 
  end if;
-- CLK 0->1
elsif ( CLK'event and CLK'last_value = '0' and CLK = '1') then
  MElatched := TO_X01(ME_old);
  ADRlatched := TO_X01(ADR_old);
  TEST1latched := TO_X01(TEST1_old);
--ME=X
 ADR_lat := TO_INT(ADR_old);
if( IS_X(MElatched)) then
       if ((MES_CNTRL="ON"  or MES_CNTRL = "ERR")  and mes_all_valid  ) then
           assert false report "<<VIRL_MEM_ERR: ME is unknown >> " severity note;
       end if;
    Q_tmp <= DataX;
--ME=1
  elsif( MElatched= '1' ) then
     if (RME = '1') then
       if (RM > "0011" and ( not IS_X(RM) ) ) then
         if ( (MES_CNTRL="ON"  or MES_CNTRL = "WARN") and NOW /= 0 ns and mes_all_valid ) then
           assert false report "<<VIRL_MEM_WARNING: RM is not a recommended value >>" severity note;
         end if;
       end if;
     end if;
   if( (IS_X(RM)) ) then
     if ( (MES_CNTRL ="ON"  or MES_CNTRL = "ERR") and mes_all_valid  ) then
       if ( RME /= 'X' ) then
         assert false report "<<VIRL_MEM_ERR: RM is unknown>>" severity note;
       else
         assert false report " <<VIRL_MEM_ERR: RME is unknown >> " severity note;
       end if;
     end if;
      Q_tmp <= DataX;
    elsif ( IS_X(TEST1) ) then
      if ( (MES_CNTRL ="ON"  or MES_CNTRL = "ERR")  and mes_all_valid  ) then
        assert false report " <<VIRL_MEM_ERR: TEST1 is unknown >> " severity note;
      end if;
      Q_tmp <= DataX;
    elsif ( IS_X(LS) ) then
      if ( (MES_CNTRL ="ON"  or MES_CNTRL = "ERR")  and mes_all_valid  ) then
        assert false report " <<VIRL_MEM_ERR: LS is unknown >> " severity note;
      end if;
      Q_tmp <= DataX;
    elsif( (IS_X(ADRlatched)) ) then
      Q_tmp <= DataX;
      if ( (MES_CNTRL ="ON"  or MES_CNTRL = "ERR")  and mes_all_valid  ) then 
          assert false report " <<VIRL_MEM_ERR: ADR is unknown >> " severity note; 
      end if; 
    elsif( ADR_lat < 0 or ADR_lat >= words ) then
      Q_tmp <= DataX;
      if (( MES_CNTRL ="ON"  or MES_CNTRL = "WARN")  and mes_all_valid ) then  
          assert false report "<<VIRL_MEM_WARNING: ADR greater than fixed WORD space>>" severity note;
      end if;  
    else
      Q_int := mem_core_array(ADR_lat);
     if ( TEST1 = '1' and ((to_unsigned_integer(Q_local_prev) /= to_unsigned_integer(Q_int)) or (IS_X(Q_local_prev))) ) then
       Q_tmp <= DataX;
     else
      Q_tmp <= Q_int(79 downto 0);
     end if;
       if ( not mes_all_valid ) then
         mes_all_valid <= true;
       end if;
    end if;
  end if;
end if;       
                  


 
if ( TEST1_ipd'event and TEST1_ipd = '1' ) then
  if ( (MES_CNTRL ="ON"  or MES_CNTRL = "WARN")  and mes_all_valid ) then
    assert FALSE report "<<VIRL_MEM_WARNING: In TEST1 mode, Tch requirement is that Tch must be less than 4*Tcq. Tcl requirement is that Tcl >=Tcc>>." severity note;
  end if;
end if;



END PROCESS;

process( Q_tmp )
begin 
  -- Normal Mode 
  Q <= Q_tmp;
  Q_local_prev <= Q_tmp;
end process; 

end behav;

---------------- ACTUAL MEMORY DESCRIPTION   ---------------------------

library IEEE;
library work;
use work.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.TEXTIO.ALL;


entity SNPS_ROM_4Kx80_mprom00 is

  generic (
        PreloadFilename   : string                 := "SNPS_ROM_4Kx80_mprom00.hex";
        XGenerationOn     : Boolean                := True;
        words             : integer                := 4096;
        addrbits          : integer                := 12;
        bits              : integer                := 80;
        MES_CNTRL           : string                := "ON"
   );

 port (
        Q : out std_logic_vector(79 downto 0);
        ADR : in std_logic_vector(11 downto 0);
        ME : in std_logic;
        CLK : in std_logic;
        LS : in std_logic;
        TEST1 : in std_logic;
        RM : in std_logic_vector(3 downto 0);
        RME : in std_logic );

end SNPS_ROM_4Kx80_mprom00;

architecture behaviour of SNPS_ROM_4Kx80_mprom00 is

SIGNAL ADR_buf : STD_LOGIC_VECTOR(11 downto 0);
SIGNAL ME_buf : STD_LOGIC;
SIGNAL t3_me  : time := 0 ns;

component generic_vhd_SNPS_ROM_4Kx80_mprom00
  generic (  
        PreloadFilename   : string                 := "SNPS_ROM_4Kx80_mprom00.hex"; 
        words             : integer                := 4096;
        addrbits          : integer                := 12;
        rmbits            : integer                := 4;
        bits              : integer                := 80;
        MES_CNTRL           : string                := "ON"
  );

   port (
  Q : out std_logic_vector (bits-1 downto 0);
  ADR : in std_logic_vector (addrbits-1 downto 0);
  ME : in std_logic;
  CLK : in std_logic;
  LS : in std_logic;
  TEST1 : in std_logic;
  RM : in std_logic_vector (rmbits-1 downto 0);
  RME : in std_logic;
  t3_me : in time
   );

end component;


SIGNAL LS_old  :STD_LOGIC ;
SIGNAL LS_buf1  :STD_LOGIC ;
SIGNAL CLK_mem  :STD_LOGIC := '0';

SIGNAL RMVAL  : STD_LOGIC_VECTOR(2 downto 0) := "011";
SIGNAL RM_int : STD_LOGIC_VECTOR(3 downto 0);

SIGNAL ADR_mout : STD_LOGIC_VECTOR(11 downto 0) := (others=>'0');
SIGNAL ME_mout : STD_LOGIC ;

SIGNAL CLK_buf: STD_LOGIC;
SIGNAL LS_buf: STD_LOGIC;
SIGNAL TEST1_buf: STD_LOGIC;
SIGNAL RM_buf: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL RME_buf: STD_LOGIC;
SIGNAL disp_LS_msg :STD_LOGIC :='1';


  for uut : generic_vhd_SNPS_ROM_4Kx80_mprom00 use entity work.generic_vhd_SNPS_ROM_4Kx80_mprom00(behav);
  BEGIN

    LS_old <= LS_buf when CLK_buf = '0' else LS_old ;
    CLK_mem <= '0' when (LS_old = '1' and ME_mout /= 'X') else CLK_buf;
  process ( CLK_buf, ADR_buf )
  begin
    if ( (CLK_buf'last_value /= '0' and CLK_buf = '0') or NOW = 0 ns ) then
      ADR_mout <= ADR_buf;
    end if;
  end process;

  process ( CLK_buf, ME_buf )
  begin
    if ( (CLK_buf'last_value /= '0' and CLK_buf = '0') or NOW = 0 ns ) then
      ME_mout <= ME_buf;
    end if;
  end process;


  uut : generic_vhd_SNPS_ROM_4Kx80_mprom00
  generic map (
        PreloadFilename        => PreloadFilename,
        words                  => 4096,
        addrbits               => 12,
        bits                   => 80,
        MES_CNTRL              => MES_CNTRL
  )
  port map (
   Q =>    Q,
   ADR =>    ADR_mout,
   ME =>    ME_mout,
   CLK =>    CLK_mem,
   LS =>    LS_old,
   TEST1 =>    TEST1_buf,
   RM =>    RM_int,
   RME =>    RME_buf,
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
    ADR_buf(10) <= 'X' when ADR(10) = 'Z' else  ADR(10);
    ADR_buf(11) <= 'X' when ADR(11) = 'Z' else  ADR(11);
    ME_buf <= 'X' when ME = 'Z' else  ME;
    CLK_buf <= 'X' when CLK = 'Z' else  CLK;
    LS_buf <= 'X' when LS = 'Z' else  LS;
    TEST1_buf <= 'X' when TEST1 = 'Z' else  TEST1;
    RM_buf(0) <= 'X' when RM(0) = 'Z' else  RM(0);
    RM_buf(1) <= 'X' when RM(1) = 'Z' else  RM(1);
    RM_buf(2) <= 'X' when RM(2) = 'Z' else  RM(2);
    RM_buf(3) <= 'X' when RM(3) = 'Z' else  RM(3);
    RME_buf <= 'X' when RME = 'Z' else  RME;

process(ME_buf)
VARIABLE t3_me_tmp : time := 0 ns;
begin
  if ( ME_buf'event ) then
    t3_me_tmp := now;
    t3_me <= t3_me_tmp;
  end if;
end process;

   RM_int(2 downto 0) <= RM(2 downto 0) when RME_buf = '1' else RMVAL when RME_buf = '0' else (others=>'X');
    RM_int(3) <= RM(3);


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

configuration conf_SNPS_ROM_4Kx80_mprom00_behaviour of SNPS_ROM_4Kx80_mprom00 is
for behaviour
end for;
end conf_SNPS_ROM_4Kx80_mprom00_behaviour;
