library ieee;
use ieee.std_logic_1164.all;
use work.all;
use work.gp_pkg.all;

entity p_top is
  port (
    --Data interface --Added by CJ
    C1_REQ    : out std_logic;
    C2_REQ    : out std_logic;
    C1_ACK    : in std_logic;
    C2_ACK    : in std_logic;
    C1_REQ_D  : out std_logic_vector(31 downto 0);
    C2_REQ_D  : out std_logic_vector(31 downto 0);
    C1_IN_D   : in std_logic_vector(127 downto 0);
    C2_IN_D   : in std_logic_vector(127 downto 0);
    C1_DDI_VLD : in std_logic;
    C2_DDI_VLD : in std_logic;
    EXE        : in std_logic;

    -- clocks and control signals
    HCLK       : in    std_logic;                  -- clk input, use this or an internally generated clock for CPU core
    EVEN_C     : in    std_logic;                  -- even pulses of HCLK. Used to generate clk_e_pos and clk_e_neg.
    MRESET     : in    std_logic;                  -- system reset               low active
    MIRQOUT    : out   std_logic;                  -- interrupt request output    
    MCKOUT0    : out   std_logic;                  -- for trace adapter
    MCKOUT1    : out   std_logic;                  -- programable clock out
    MTEST      : in    std_logic;                  --                            high active                 
    MBYPASS    : in    std_logic;
    MIRQ0      : in    std_logic;                  --                            low active
    MIRQ1      : in    std_logic;                  --                            low active
    -- SW debug                                                               
    MSDIN      : in    std_logic;                  -- serial data in (debug)     
    MSDOUT     : out   std_logic                   -- serial data out    
  );
end p_top;

architecture struct of p_top is


  ------------------------------------------------------
  -- Old version of dual core CPU with debug access only
  ------------------------------------------------------
  
  -- iomem
  component SY180_1024X8X1CM8     
    port(
      A0                         :   IN   std_logic;
      A1                         :   IN   std_logic;
      A2                         :   IN   std_logic;
      A3                         :   IN   std_logic;
      A4                         :   IN   std_logic;
      A5                         :   IN   std_logic;
      A6                         :   IN   std_logic;
      A7                         :   IN   std_logic;
      A8                         :   IN   std_logic;
      A9                         :   IN   std_logic;
      DO0                        :   OUT   std_logic;
      DO1                        :   OUT   std_logic;
      DO2                        :   OUT   std_logic;
      DO3                        :   OUT   std_logic;
      DO4                        :   OUT   std_logic;
      DO5                        :   OUT   std_logic;
      DO6                        :   OUT   std_logic;
      DO7                        :   OUT   std_logic;
      DI0                        :   IN   std_logic;
      DI1                        :   IN   std_logic;
      DI2                        :   IN   std_logic;
      DI3                        :   IN   std_logic;
      DI4                        :   IN   std_logic;
      DI5                        :   IN   std_logic;
      DI6                        :   IN   std_logic;
      DI7                        :   IN   std_logic;
      WEB                        :   IN   std_logic;
      CK                         :   IN   std_logic;
      CSB                        :   IN   std_logic
      );
  end component; 
  -- trcmem
  component SY180_256X32X1CM4
  port(
      A0                         :   IN   std_logic;
      A1                         :   IN   std_logic;
      A2                         :   IN   std_logic;
      A3                         :   IN   std_logic;
      A4                         :   IN   std_logic;
      A5                         :   IN   std_logic;
      A6                         :   IN   std_logic;
      A7                         :   IN   std_logic;
      DO0                        :   OUT   std_logic;
      DO1                        :   OUT   std_logic;
      DO2                        :   OUT   std_logic;
      DO3                        :   OUT   std_logic;
      DO4                        :   OUT   std_logic;
      DO5                        :   OUT   std_logic;
      DO6                        :   OUT   std_logic;
      DO7                        :   OUT   std_logic;
      DO8                        :   OUT   std_logic;
      DO9                        :   OUT   std_logic;
      DO10                        :   OUT   std_logic;
      DO11                        :   OUT   std_logic;
      DO12                        :   OUT   std_logic;
      DO13                        :   OUT   std_logic;
      DO14                        :   OUT   std_logic;
      DO15                        :   OUT   std_logic;
      DO16                        :   OUT   std_logic;
      DO17                        :   OUT   std_logic;
      DO18                        :   OUT   std_logic;
      DO19                        :   OUT   std_logic;
      DO20                        :   OUT   std_logic;
      DO21                        :   OUT   std_logic;
      DO22                        :   OUT   std_logic;
      DO23                        :   OUT   std_logic;
      DO24                        :   OUT   std_logic;
      DO25                        :   OUT   std_logic;
      DO26                        :   OUT   std_logic;
      DO27                        :   OUT   std_logic;
      DO28                        :   OUT   std_logic;
      DO29                        :   OUT   std_logic;
      DO30                        :   OUT   std_logic;
      DO31                        :   OUT   std_logic;
      DI0                        :   IN   std_logic;
      DI1                        :   IN   std_logic;
      DI2                        :   IN   std_logic;
      DI3                        :   IN   std_logic;
      DI4                        :   IN   std_logic;
      DI5                        :   IN   std_logic;
      DI6                        :   IN   std_logic;
      DI7                        :   IN   std_logic;
      DI8                        :   IN   std_logic;
      DI9                        :   IN   std_logic;
      DI10                        :   IN   std_logic;
      DI11                        :   IN   std_logic;
      DI12                        :   IN   std_logic;
      DI13                        :   IN   std_logic;
      DI14                        :   IN   std_logic;
      DI15                        :   IN   std_logic;
      DI16                        :   IN   std_logic;
      DI17                        :   IN   std_logic;
      DI18                        :   IN   std_logic;
      DI19                        :   IN   std_logic;
      DI20                        :   IN   std_logic;
      DI21                        :   IN   std_logic;
      DI22                        :   IN   std_logic;
      DI23                        :   IN   std_logic;
      DI24                        :   IN   std_logic;
      DI25                        :   IN   std_logic;
      DI26                        :   IN   std_logic;
      DI27                        :   IN   std_logic;
      DI28                        :   IN   std_logic;
      DI29                        :   IN   std_logic;
      DI30                        :   IN   std_logic;
      DI31                        :   IN   std_logic;
      WEB                         :   IN   std_logic;
      CK                          :   IN   std_logic;
      CSB                         :   IN   std_logic
      );
   end component;

  -- pmem
  --component SY180_2048X2X1CM8
  --port(
  --    A0                         :   IN   std_logic;
  --    A1                         :   IN   std_logic;
  --    A2                         :   IN   std_logic;
  --    A3                         :   IN   std_logic;
  --    A4                         :   IN   std_logic;
  --    A5                         :   IN   std_logic;
  --    A6                         :   IN   std_logic;
  --    A7                         :   IN   std_logic;
  --    A8                         :   IN   std_logic;
  --    A9                         :   IN   std_logic;
  --    A10                        :   IN   std_logic;
  --    DO0                        :   OUT   std_logic;
  --    DO1                        :   OUT   std_logic;
  --    DI0                        :   IN   std_logic;
  --    DI1                        :   IN   std_logic;
  --    WEB                        :   IN   std_logic;
  --    CK                         :   IN   std_logic;
  --    CSB                         :   IN   std_logic
  --    );
  --end component;


--ROM0
  --component SP180_4096X80BM1A
  --port(
  --    A0                            :   IN   std_logic;
  --    A1                            :   IN   std_logic;
  --    A2                            :   IN   std_logic;
  --    A3                            :   IN   std_logic;
  --    A4                            :   IN   std_logic;
  --    A5                            :   IN   std_logic;
  --    A6                            :   IN   std_logic;
  --    A7                            :   IN   std_logic;
  --    A8                            :   IN   std_logic;
  --    A9                            :   IN   std_logic;
  --    A10                            :   IN   std_logic;
  --    A11                            :   IN   std_logic;
  --    DO0                           :   OUT   std_logic;
  --    DO1                           :   OUT   std_logic;
  --    DO2                           :   OUT   std_logic;
  --    DO3                           :   OUT   std_logic;
  --    DO4                           :   OUT   std_logic;
  --    DO5                           :   OUT   std_logic;
  --    DO6                           :   OUT   std_logic;
  --    DO7                           :   OUT   std_logic;
  --    DO8                           :   OUT   std_logic;
  --    DO9                           :   OUT   std_logic;
  --    DO10                           :   OUT   std_logic;
  --    DO11                           :   OUT   std_logic;
  --    DO12                           :   OUT   std_logic;
  --    DO13                           :   OUT   std_logic;
  --    DO14                           :   OUT   std_logic;
  --    DO15                           :   OUT   std_logic;
  --    DO16                           :   OUT   std_logic;
  --    DO17                           :   OUT   std_logic;
  --    DO18                           :   OUT   std_logic;
  --    DO19                           :   OUT   std_logic;
  --    DO20                           :   OUT   std_logic;
  --    DO21                           :   OUT   std_logic;
  --    DO22                           :   OUT   std_logic;
  --    DO23                           :   OUT   std_logic;
  --    DO24                           :   OUT   std_logic;
  --    DO25                           :   OUT   std_logic;
  --    DO26                           :   OUT   std_logic;
  --    DO27                           :   OUT   std_logic;
  --    DO28                           :   OUT   std_logic;
  --    DO29                           :   OUT   std_logic;
  --    DO30                           :   OUT   std_logic;
  --    DO31                           :   OUT   std_logic;
  --    DO32                           :   OUT   std_logic;
  --    DO33                           :   OUT   std_logic;
  --    DO34                           :   OUT   std_logic;
  --    DO35                           :   OUT   std_logic;
  --    DO36                           :   OUT   std_logic;
  --    DO37                           :   OUT   std_logic;
  --    DO38                           :   OUT   std_logic;
  --    DO39                           :   OUT   std_logic;
  --    DO40                           :   OUT   std_logic;
  --    DO41                           :   OUT   std_logic;
  --    DO42                           :   OUT   std_logic;
  --    DO43                           :   OUT   std_logic;
  --    DO44                           :   OUT   std_logic;
  --    DO45                           :   OUT   std_logic;
  --    DO46                           :   OUT   std_logic;
  --    DO47                           :   OUT   std_logic;
  --    DO48                           :   OUT   std_logic;
  --    DO49                           :   OUT   std_logic;
  --    DO50                           :   OUT   std_logic;
  --    DO51                           :   OUT   std_logic;
  --    DO52                           :   OUT   std_logic;
  --    DO53                           :   OUT   std_logic;
  --    DO54                           :   OUT   std_logic;
  --    DO55                           :   OUT   std_logic;
  --    DO56                           :   OUT   std_logic;
  --    DO57                           :   OUT   std_logic;
  --    DO58                           :   OUT   std_logic;
  --    DO59                           :   OUT   std_logic;
  --    DO60                           :   OUT   std_logic;
  --    DO61                           :   OUT   std_logic;
  --    DO62                           :   OUT   std_logic;
  --    DO63                           :   OUT   std_logic;
  --    DO64                           :   OUT   std_logic;
  --    DO65                           :   OUT   std_logic;
  --    DO66                           :   OUT   std_logic;
  --    DO67                           :   OUT   std_logic;
  --    DO68                           :   OUT   std_logic;
  --    DO69                           :   OUT   std_logic;
  --    DO70                           :   OUT   std_logic;
  --    DO71                           :   OUT   std_logic;
  --    DO72                           :   OUT   std_logic;
  --    DO73                           :   OUT   std_logic;
  --    DO74                           :   OUT   std_logic;
  --    DO75                           :   OUT   std_logic;
  --    DO76                           :   OUT   std_logic;
  --    DO77                           :   OUT   std_logic;
  --    DO78                           :   OUT   std_logic;
  --    DO79                           :   OUT   std_logic;
  --    CK                               :   IN   std_logic;
  --    CS                               :   IN   std_logic;
  --    OE                               :   IN   std_logic
  --    );
  --end component;


-- ROM1
   --component SP180_4096X80BM1B
   --port(
   --    A0                            :   IN   std_logic;
   --    A1                            :   IN   std_logic;
   --    A2                            :   IN   std_logic;
   --    A3                            :   IN   std_logic;
   --    A4                            :   IN   std_logic;
   --    A5                            :   IN   std_logic;
   --    A6                            :   IN   std_logic;
   --    A7                            :   IN   std_logic;
   --    A8                            :   IN   std_logic;
   --    A9                            :   IN   std_logic;
   --    A10                            :   IN   std_logic;
   --    A11                            :   IN   std_logic;
   --    DO0                           :   OUT   std_logic;
   --    DO1                           :   OUT   std_logic;
   --    DO2                           :   OUT   std_logic;
   --    DO3                           :   OUT   std_logic;
   --    DO4                           :   OUT   std_logic;
   --    DO5                           :   OUT   std_logic;
   --    DO6                           :   OUT   std_logic;
   --    DO7                           :   OUT   std_logic;
   --    DO8                           :   OUT   std_logic;
   --    DO9                           :   OUT   std_logic;
   --    DO10                           :   OUT   std_logic;
   --    DO11                           :   OUT   std_logic;
   --    DO12                           :   OUT   std_logic;
   --    DO13                           :   OUT   std_logic;
   --    DO14                           :   OUT   std_logic;
   --    DO15                           :   OUT   std_logic;
   --    DO16                           :   OUT   std_logic;
   --    DO17                           :   OUT   std_logic;
   --    DO18                           :   OUT   std_logic;
   --    DO19                           :   OUT   std_logic;
   --    DO20                           :   OUT   std_logic;
   --    DO21                           :   OUT   std_logic;
   --    DO22                           :   OUT   std_logic;
   --    DO23                           :   OUT   std_logic;
   --    DO24                           :   OUT   std_logic;
   --    DO25                           :   OUT   std_logic;
   --    DO26                           :   OUT   std_logic;
   --    DO27                           :   OUT   std_logic;
   --    DO28                           :   OUT   std_logic;
   --    DO29                           :   OUT   std_logic;
   --    DO30                           :   OUT   std_logic;
   --    DO31                           :   OUT   std_logic;
   --    DO32                           :   OUT   std_logic;
   --    DO33                           :   OUT   std_logic;
   --    DO34                           :   OUT   std_logic;
   --    DO35                           :   OUT   std_logic;
   --    DO36                           :   OUT   std_logic;
   --    DO37                           :   OUT   std_logic;
   --    DO38                           :   OUT   std_logic;
   --    DO39                           :   OUT   std_logic;
   --    DO40                           :   OUT   std_logic;
   --    DO41                           :   OUT   std_logic;
   --    DO42                           :   OUT   std_logic;
   --    DO43                           :   OUT   std_logic;
   --    DO44                           :   OUT   std_logic;
   --    DO45                           :   OUT   std_logic;
   --    DO46                           :   OUT   std_logic;
   --    DO47                           :   OUT   std_logic;
   --    DO48                           :   OUT   std_logic;
   --    DO49                           :   OUT   std_logic;
   --    DO50                           :   OUT   std_logic;
   --    DO51                           :   OUT   std_logic;
   --    DO52                           :   OUT   std_logic;
   --    DO53                           :   OUT   std_logic;
   --    DO54                           :   OUT   std_logic;
   --    DO55                           :   OUT   std_logic;
   --    DO56                           :   OUT   std_logic;
   --    DO57                           :   OUT   std_logic;
   --    DO58                           :   OUT   std_logic;
   --    DO59                           :   OUT   std_logic;
   --    DO60                           :   OUT   std_logic;
   --    DO61                           :   OUT   std_logic;
   --    DO62                           :   OUT   std_logic;
   --    DO63                           :   OUT   std_logic;
   --    DO64                           :   OUT   std_logic;
   --    DO65                           :   OUT   std_logic;
   --    DO66                           :   OUT   std_logic;
   --    DO67                           :   OUT   std_logic;
   --    DO68                           :   OUT   std_logic;
   --    DO69                           :   OUT   std_logic;
   --    DO70                           :   OUT   std_logic;
   --    DO71                           :   OUT   std_logic;
   --    DO72                           :   OUT   std_logic;
   --    DO73                           :   OUT   std_logic;
   --    DO74                           :   OUT   std_logic;
   --    DO75                           :   OUT   std_logic;
   --    DO76                           :   OUT   std_logic;
   --    DO77                           :   OUT   std_logic;
   --    DO78                           :   OUT   std_logic;
   --    DO79                           :   OUT   std_logic;
   --    CK                               :   IN   std_logic;
   --    CS                               :   IN   std_logic;
   --    OE                               :   IN   std_logic
   --    );
   --end component;

  --RAM 0
  component SU180_256X128X1BM1A
  port(
      A0                         :   IN   std_logic;
      A1                         :   IN   std_logic;
      A2                         :   IN   std_logic;
      A3                         :   IN   std_logic;
      A4                         :   IN   std_logic;
      A5                         :   IN   std_logic;
      A6                         :   IN   std_logic;
      A7                         :   IN   std_logic;
      --A8                         :   IN   std_logic;
      --A9                         :   IN   std_logic;
      --A10                         :   IN   std_logic;
      DO0                        :   OUT   std_logic;
      DO1                        :   OUT   std_logic;
      DO2                        :   OUT   std_logic;
      DO3                        :   OUT   std_logic;
      DO4                        :   OUT   std_logic;
      DO5                        :   OUT   std_logic;
      DO6                        :   OUT   std_logic;
      DO7                        :   OUT   std_logic;
      DO8                        :   OUT   std_logic;
      DO9                        :   OUT   std_logic;
      DO10                        :   OUT   std_logic;
      DO11                        :   OUT   std_logic;
      DO12                        :   OUT   std_logic;
      DO13                        :   OUT   std_logic;
      DO14                        :   OUT   std_logic;
      DO15                        :   OUT   std_logic;
      DO16                        :   OUT   std_logic;
      DO17                        :   OUT   std_logic;
      DO18                        :   OUT   std_logic;
      DO19                        :   OUT   std_logic;
      DO20                        :   OUT   std_logic;
      DO21                        :   OUT   std_logic;
      DO22                        :   OUT   std_logic;
      DO23                        :   OUT   std_logic;
      DO24                        :   OUT   std_logic;
      DO25                        :   OUT   std_logic;
      DO26                        :   OUT   std_logic;
      DO27                        :   OUT   std_logic;
      DO28                        :   OUT   std_logic;
      DO29                        :   OUT   std_logic;
      DO30                        :   OUT   std_logic;
      DO31                        :   OUT   std_logic;
      DO32                        :   OUT   std_logic;
      DO33                        :   OUT   std_logic;
      DO34                        :   OUT   std_logic;
      DO35                        :   OUT   std_logic;
      DO36                        :   OUT   std_logic;
      DO37                        :   OUT   std_logic;
      DO38                        :   OUT   std_logic;
      DO39                        :   OUT   std_logic;
      DO40                        :   OUT   std_logic;
      DO41                        :   OUT   std_logic;
      DO42                        :   OUT   std_logic;
      DO43                        :   OUT   std_logic;
      DO44                        :   OUT   std_logic;
      DO45                        :   OUT   std_logic;
      DO46                        :   OUT   std_logic;
      DO47                        :   OUT   std_logic;
      DO48                        :   OUT   std_logic;
      DO49                        :   OUT   std_logic;
      DO50                        :   OUT   std_logic;
      DO51                        :   OUT   std_logic;
      DO52                        :   OUT   std_logic;
      DO53                        :   OUT   std_logic;
      DO54                        :   OUT   std_logic;
      DO55                        :   OUT   std_logic;
      DO56                        :   OUT   std_logic;
      DO57                        :   OUT   std_logic;
      DO58                        :   OUT   std_logic;
      DO59                        :   OUT   std_logic;
      DO60                        :   OUT   std_logic;
      DO61                        :   OUT   std_logic;
      DO62                        :   OUT   std_logic;
      DO63                        :   OUT   std_logic;
      DO64                        :   OUT   std_logic;
      DO65                        :   OUT   std_logic;
      DO66                        :   OUT   std_logic;
      DO67                        :   OUT   std_logic;
      DO68                        :   OUT   std_logic;
      DO69                        :   OUT   std_logic;
      DO70                        :   OUT   std_logic;
      DO71                        :   OUT   std_logic;
      DO72                        :   OUT   std_logic;
      DO73                        :   OUT   std_logic;
      DO74                        :   OUT   std_logic;
      DO75                        :   OUT   std_logic;
      DO76                        :   OUT   std_logic;
      DO77                        :   OUT   std_logic;
      DO78                        :   OUT   std_logic;
      DO79                        :   OUT   std_logic;
      DO80                        :   OUT   std_logic;
      DO81                        :   OUT   std_logic;
      DO82                        :   OUT   std_logic;
      DO83                        :   OUT   std_logic;
      DO84                        :   OUT   std_logic;
      DO85                        :   OUT   std_logic;
      DO86                        :   OUT   std_logic;
      DO87                        :   OUT   std_logic;
      DO88                        :   OUT   std_logic;
      DO89                        :   OUT   std_logic;
      DO90                        :   OUT   std_logic;
      DO91                        :   OUT   std_logic;
      DO92                        :   OUT   std_logic;
      DO93                        :   OUT   std_logic;
      DO94                        :   OUT   std_logic;
      DO95                        :   OUT   std_logic;
      DO96                        :   OUT   std_logic;
      DO97                        :   OUT   std_logic;
      DO98                        :   OUT   std_logic;
      DO99                        :   OUT   std_logic;
      DO100                       :   OUT   std_logic;
      DO101                       :   OUT   std_logic;
      DO102                       :   OUT   std_logic;
      DO103                       :   OUT   std_logic;
      DO104                       :   OUT   std_logic;
      DO105                       :   OUT   std_logic;
      DO106                       :   OUT   std_logic;
      DO107                       :   OUT   std_logic;
      DO108                       :   OUT   std_logic;
      DO109                       :   OUT   std_logic;
      DO110                       :   OUT   std_logic;
      DO111                       :   OUT   std_logic;
      DO112                       :   OUT   std_logic;
      DO113                       :   OUT   std_logic;
      DO114                       :   OUT   std_logic;
      DO115                       :   OUT   std_logic;
      DO116                       :   OUT   std_logic;
      DO117                       :   OUT   std_logic;
      DO118                       :   OUT   std_logic;
      DO119                       :   OUT   std_logic;
      DO120                       :   OUT   std_logic;
      DO121                       :   OUT   std_logic;
      DO122                       :   OUT   std_logic;
      DO123                       :   OUT   std_logic;
      DO124                       :   OUT   std_logic;
      DO125                       :   OUT   std_logic;
      DO126                       :   OUT   std_logic;
      DO127                       :   OUT   std_logic;
      DI0                        :   IN   std_logic;
      DI1                        :   IN   std_logic;
      DI2                        :   IN   std_logic;
      DI3                        :   IN   std_logic;
      DI4                        :   IN   std_logic;
      DI5                        :   IN   std_logic;
      DI6                        :   IN   std_logic;
      DI7                        :   IN   std_logic;
      DI8                        :   IN   std_logic;
      DI9                        :   IN   std_logic;
      DI10                        :   IN   std_logic;
      DI11                        :   IN   std_logic;
      DI12                        :   IN   std_logic;
      DI13                        :   IN   std_logic;
      DI14                        :   IN   std_logic;
      DI15                        :   IN   std_logic;
      DI16                        :   IN   std_logic;
      DI17                        :   IN   std_logic;
      DI18                        :   IN   std_logic;
      DI19                        :   IN   std_logic;
      DI20                        :   IN   std_logic;
      DI21                        :   IN   std_logic;
      DI22                        :   IN   std_logic;
      DI23                        :   IN   std_logic;
      DI24                        :   IN   std_logic;
      DI25                        :   IN   std_logic;
      DI26                        :   IN   std_logic;
      DI27                        :   IN   std_logic;
      DI28                        :   IN   std_logic;
      DI29                        :   IN   std_logic;
      DI30                        :   IN   std_logic;
      DI31                        :   IN   std_logic;
      DI32                        :   IN   std_logic;
      DI33                        :   IN   std_logic;
      DI34                        :   IN   std_logic;
      DI35                        :   IN   std_logic;
      DI36                        :   IN   std_logic;
      DI37                        :   IN   std_logic;
      DI38                        :   IN   std_logic;
      DI39                        :   IN   std_logic;
      DI40                        :   IN   std_logic;
      DI41                        :   IN   std_logic;
      DI42                        :   IN   std_logic;
      DI43                        :   IN   std_logic;
      DI44                        :   IN   std_logic;
      DI45                        :   IN   std_logic;
      DI46                        :   IN   std_logic;
      DI47                        :   IN   std_logic;
      DI48                        :   IN   std_logic;
      DI49                        :   IN   std_logic;
      DI50                        :   IN   std_logic;
      DI51                        :   IN   std_logic;
      DI52                        :   IN   std_logic;
      DI53                        :   IN   std_logic;
      DI54                        :   IN   std_logic;
      DI55                        :   IN   std_logic;
      DI56                        :   IN   std_logic;
      DI57                        :   IN   std_logic;
      DI58                        :   IN   std_logic;
      DI59                        :   IN   std_logic;
      DI60                        :   IN   std_logic;
      DI61                        :   IN   std_logic;
      DI62                        :   IN   std_logic;
      DI63                        :   IN   std_logic;
      DI64                        :   IN   std_logic;
      DI65                        :   IN   std_logic;
      DI66                        :   IN   std_logic;
      DI67                        :   IN   std_logic;
      DI68                        :   IN   std_logic;
      DI69                        :   IN   std_logic;
      DI70                        :   IN   std_logic;
      DI71                        :   IN   std_logic;
      DI72                        :   IN   std_logic;
      DI73                        :   IN   std_logic;
      DI74                        :   IN   std_logic;
      DI75                        :   IN   std_logic;
      DI76                        :   IN   std_logic;
      DI77                        :   IN   std_logic;
      DI78                        :   IN   std_logic;
      DI79                        :   IN   std_logic;
      DI80                        :   IN   std_logic;
      DI81                        :   IN   std_logic;
      DI82                        :   IN   std_logic;
      DI83                        :   IN   std_logic;
      DI84                        :   IN   std_logic;
      DI85                        :   IN   std_logic;
      DI86                        :   IN   std_logic;
      DI87                        :   IN   std_logic;
      DI88                        :   IN   std_logic;
      DI89                        :   IN   std_logic;
      DI90                        :   IN   std_logic;
      DI91                        :   IN   std_logic;
      DI92                        :   IN   std_logic;
      DI93                        :   IN   std_logic;
      DI94                        :   IN   std_logic;
      DI95                        :   IN   std_logic;
      DI96                        :   IN   std_logic;
      DI97                        :   IN   std_logic;
      DI98                        :   IN   std_logic;
      DI99                        :   IN   std_logic;
      DI100                       :   IN   std_logic;
      DI101                       :   IN   std_logic;
      DI102                       :   IN   std_logic;
      DI103                       :   IN   std_logic;
      DI104                       :   IN   std_logic;
      DI105                       :   IN   std_logic;
      DI106                       :   IN   std_logic;
      DI107                       :   IN   std_logic;
      DI108                       :   IN   std_logic;
      DI109                       :   IN   std_logic;
      DI110                       :   IN   std_logic;
      DI111                       :   IN   std_logic;
      DI112                       :   IN   std_logic;
      DI113                       :   IN   std_logic;
      DI114                       :   IN   std_logic;
      DI115                       :   IN   std_logic;
      DI116                       :   IN   std_logic;
      DI117                       :   IN   std_logic;
      DI118                       :   IN   std_logic;
      DI119                       :   IN   std_logic;
      DI120                       :   IN   std_logic;
      DI121                       :   IN   std_logic;
      DI122                       :   IN   std_logic;
      DI123                       :   IN   std_logic;
      DI124                       :   IN   std_logic;
      DI125                       :   IN   std_logic;
      DI126                       :   IN   std_logic;
      DI127                       :   IN   std_logic;
      WEB                         :   IN   std_logic;
      CK                          :   IN   std_logic;
      CS                          :   IN   std_logic;
      OE                          :   IN   std_logic
      );
  END component;

-- RAM 1
  --component SU180_2048X80X1BM1B
  --port(
  --    A0                         :   IN   std_logic;
  --    A1                         :   IN   std_logic;
  --    A2                         :   IN   std_logic;
  --    A3                         :   IN   std_logic;
  --    A4                         :   IN   std_logic;
  --    A5                         :   IN   std_logic;
  --    A6                         :   IN   std_logic;
  --    A7                         :   IN   std_logic;
  --    A8                         :   IN   std_logic;
  --    A9                         :   IN   std_logic;
  --    A10                         :   IN   std_logic;
  --    DO0                        :   OUT   std_logic;
  --    DO1                        :   OUT   std_logic;
  --    DO2                        :   OUT   std_logic;
  --    DO3                        :   OUT   std_logic;
  --    DO4                        :   OUT   std_logic;
  --    DO5                        :   OUT   std_logic;
  --    DO6                        :   OUT   std_logic;
  --    DO7                        :   OUT   std_logic;
  --    DO8                        :   OUT   std_logic;
  --    DO9                        :   OUT   std_logic;
  --    DO10                        :   OUT   std_logic;
  --    DO11                        :   OUT   std_logic;
  --    DO12                        :   OUT   std_logic;
  --    DO13                        :   OUT   std_logic;
  --    DO14                        :   OUT   std_logic;
  --    DO15                        :   OUT   std_logic;
  --    DO16                        :   OUT   std_logic;
  --    DO17                        :   OUT   std_logic;
  --    DO18                        :   OUT   std_logic;
  --    DO19                        :   OUT   std_logic;
  --    DO20                        :   OUT   std_logic;
  --    DO21                        :   OUT   std_logic;
  --    DO22                        :   OUT   std_logic;
  --    DO23                        :   OUT   std_logic;
  --    DO24                        :   OUT   std_logic;
  --    DO25                        :   OUT   std_logic;
  --    DO26                        :   OUT   std_logic;
  --    DO27                        :   OUT   std_logic;
  --    DO28                        :   OUT   std_logic;
  --    DO29                        :   OUT   std_logic;
  --    DO30                        :   OUT   std_logic;
  --    DO31                        :   OUT   std_logic;
  --    DO32                        :   OUT   std_logic;
  --    DO33                        :   OUT   std_logic;
  --    DO34                        :   OUT   std_logic;
  --    DO35                        :   OUT   std_logic;
  --    DO36                        :   OUT   std_logic;
  --    DO37                        :   OUT   std_logic;
  --    DO38                        :   OUT   std_logic;
  --    DO39                        :   OUT   std_logic;
  --    DO40                        :   OUT   std_logic;
  --    DO41                        :   OUT   std_logic;
  --    DO42                        :   OUT   std_logic;
  --    DO43                        :   OUT   std_logic;
  --    DO44                        :   OUT   std_logic;
  --    DO45                        :   OUT   std_logic;
  --    DO46                        :   OUT   std_logic;
  --    DO47                        :   OUT   std_logic;
  --    DO48                        :   OUT   std_logic;
  --    DO49                        :   OUT   std_logic;
  --    DO50                        :   OUT   std_logic;
  --    DO51                        :   OUT   std_logic;
  --    DO52                        :   OUT   std_logic;
  --    DO53                        :   OUT   std_logic;
  --    DO54                        :   OUT   std_logic;
  --    DO55                        :   OUT   std_logic;
  --    DO56                        :   OUT   std_logic;
  --    DO57                        :   OUT   std_logic;
  --    DO58                        :   OUT   std_logic;
  --    DO59                        :   OUT   std_logic;
  --    DO60                        :   OUT   std_logic;
  --    DO61                        :   OUT   std_logic;
  --    DO62                        :   OUT   std_logic;
  --    DO63                        :   OUT   std_logic;
  --    DO64                        :   OUT   std_logic;
  --    DO65                        :   OUT   std_logic;
  --    DO66                        :   OUT   std_logic;
  --    DO67                        :   OUT   std_logic;
  --    DO68                        :   OUT   std_logic;
  --    DO69                        :   OUT   std_logic;
  --    DO70                        :   OUT   std_logic;
  --    DO71                        :   OUT   std_logic;
  --    DO72                        :   OUT   std_logic;
  --    DO73                        :   OUT   std_logic;
  --    DO74                        :   OUT   std_logic;
  --    DO75                        :   OUT   std_logic;
  --    DO76                        :   OUT   std_logic;
  --    DO77                        :   OUT   std_logic;
  --    DO78                        :   OUT   std_logic;
  --    DO79                        :   OUT   std_logic;
  --    DI0                        :   IN   std_logic;
  --    DI1                        :   IN   std_logic;
  --    DI2                        :   IN   std_logic;
  --    DI3                        :   IN   std_logic;
  --    DI4                        :   IN   std_logic;
  --    DI5                        :   IN   std_logic;
  --    DI6                        :   IN   std_logic;
  --    DI7                        :   IN   std_logic;
  --    DI8                        :   IN   std_logic;
  --    DI9                        :   IN   std_logic;
  --    DI10                        :   IN   std_logic;
  --    DI11                        :   IN   std_logic;
  --    DI12                        :   IN   std_logic;
  --    DI13                        :   IN   std_logic;
  --    DI14                        :   IN   std_logic;
  --    DI15                        :   IN   std_logic;
  --    DI16                        :   IN   std_logic;
  --    DI17                        :   IN   std_logic;
  --    DI18                        :   IN   std_logic;
  --    DI19                        :   IN   std_logic;
  --    DI20                        :   IN   std_logic;
  --    DI21                        :   IN   std_logic;
  --    DI22                        :   IN   std_logic;
  --    DI23                        :   IN   std_logic;
  --    DI24                        :   IN   std_logic;
  --    DI25                        :   IN   std_logic;
  --    DI26                        :   IN   std_logic;
  --    DI27                        :   IN   std_logic;
  --    DI28                        :   IN   std_logic;
  --    DI29                        :   IN   std_logic;
  --    DI30                        :   IN   std_logic;
  --    DI31                        :   IN   std_logic;
  --    DI32                        :   IN   std_logic;
  --    DI33                        :   IN   std_logic;
  --    DI34                        :   IN   std_logic;
  --    DI35                        :   IN   std_logic;
  --    DI36                        :   IN   std_logic;
  --    DI37                        :   IN   std_logic;
  --    DI38                        :   IN   std_logic;
  --    DI39                        :   IN   std_logic;
  --    DI40                        :   IN   std_logic;
  --    DI41                        :   IN   std_logic;
  --    DI42                        :   IN   std_logic;
  --    DI43                        :   IN   std_logic;
  --    DI44                        :   IN   std_logic;
  --    DI45                        :   IN   std_logic;
  --    DI46                        :   IN   std_logic;
  --    DI47                        :   IN   std_logic;
  --    DI48                        :   IN   std_logic;
  --    DI49                        :   IN   std_logic;
  --    DI50                        :   IN   std_logic;
  --    DI51                        :   IN   std_logic;
  --    DI52                        :   IN   std_logic;
  --    DI53                        :   IN   std_logic;
  --    DI54                        :   IN   std_logic;
  --    DI55                        :   IN   std_logic;
  --    DI56                        :   IN   std_logic;
  --    DI57                        :   IN   std_logic;
  --    DI58                        :   IN   std_logic;
  --    DI59                        :   IN   std_logic;
  --    DI60                        :   IN   std_logic;
  --    DI61                        :   IN   std_logic;
  --    DI62                        :   IN   std_logic;
  --    DI63                        :   IN   std_logic;
  --    DI64                        :   IN   std_logic;
  --    DI65                        :   IN   std_logic;
  --    DI66                        :   IN   std_logic;
  --    DI67                        :   IN   std_logic;
  --    DI68                        :   IN   std_logic;
  --    DI69                        :   IN   std_logic;
  --    DI70                        :   IN   std_logic;
  --    DI71                        :   IN   std_logic;
  --    DI72                        :   IN   std_logic;
  --    DI73                        :   IN   std_logic;
  --    DI74                        :   IN   std_logic;
  --    DI75                        :   IN   std_logic;
  --    DI76                        :   IN   std_logic;
  --    DI77                        :   IN   std_logic;
  --    DI78                        :   IN   std_logic;
  --    DI79                        :   IN   std_logic;
  --    WEB                         :   IN   std_logic;
  --    CK                          :   IN   std_logic;
  --    CS                          :   IN   std_logic;
  --    OE                          :   IN   std_logic
  --    );
  --END component;
-- application and microprogram shared memory
 -- component SU180_16384X8X1BM8
 -- port(
 --     A0                         :   IN   std_logic;
 --     A1                         :   IN   std_logic;
 --     A2                         :   IN   std_logic;
 --     A3                         :   IN   std_logic;
 --     A4                         :   IN   std_logic;
 --     A5                         :   IN   std_logic;
 --     A6                         :   IN   std_logic;
 --     A7                         :   IN   std_logic;
 --     A8                         :   IN   std_logic;
 --     A9                         :   IN   std_logic;
 --     A10                         :   IN   std_logic;
 --     A11                         :   IN   std_logic;
 --     A12                         :   IN   std_logic;
 --     A13                         :   IN   std_logic;
 --     DO0                        :   OUT   std_logic;
 --     DO1                        :   OUT   std_logic;
 --     DO2                        :   OUT   std_logic;
 --     DO3                        :   OUT   std_logic;
 --     DO4                        :   OUT   std_logic;
 --     DO5                        :   OUT   std_logic;
 --     DO6                        :   OUT   std_logic;
 --     DO7                        :   OUT   std_logic;
 --     DI0                        :   IN   std_logic;
 --     DI1                        :   IN   std_logic;
 --     DI2                        :   IN   std_logic;
 --     DI3                        :   IN   std_logic;
 --     DI4                        :   IN   std_logic;
 --     DI5                        :   IN   std_logic;
 --     DI6                        :   IN   std_logic;
 --     DI7                        :   IN   std_logic;
 --     WEB                       :   IN   std_logic;
 --     CK                            :   IN   std_logic;
 --     CS                           :   IN   std_logic;
 --     OE                            :   IN   std_logic
 --     );
 --end component;





  -----------------------------------------------------------------------------
  -- Internal signals driven by (i.e. "output" from) each block 
  -----------------------------------------------------------------------------  
  signal hclk_i       : std_logic;  -- 16.7mhz clk
  signal pllout       : std_logic;                         
  signal msdin_i      : std_logic;                         
  signal pd_i         : std_logic_vector(7 downto 0);      
  signal pj_i         : std_logic_vector(7 downto 0);      
  signal pi_i         : std_logic_vector(7 downto 0);      
  signal ph_i         : std_logic_vector(7 downto 0);      
  signal pc_i         : std_logic_vector(7 downto 0);      
  signal mbypass_i    : std_logic;                         
  signal mreset_i     : std_logic;                         
  signal mtest_i      : std_logic;                         
  signal mwake_i      : std_logic;                         
  signal mirq0_i      : std_logic;                         
  signal mirq1_i      : std_logic;                         
  signal pe_i         : std_logic_vector(7 downto 0);      
  signal pf_i         : std_logic_vector(7 downto 0);      
  signal pg_i         : std_logic_vector(7 downto 0);      
  signal pa_i         : std_logic_vector(7 downto 0);      
  signal pb_i         : std_logic_vector(7 downto 0);   
--  signal mpordis_i    : std_logic;                                                

-- PLL
    -- PLL                                           
  signal tcko         : std_logic;                         
  signal const_0      : std_logic; 

  -- Core clock buffers
  --signal even_c : std_logic;
  signal clk_d  : std_logic;
  signal clk_d_pos  : std_logic;
  signal clk_da_pos  : std_logic;
  signal clk_c_en  : std_logic;
  --signal clk_c2_pos : std_logic;  
  signal clk_s  : std_logic;
  signal clk_s_pos  : std_logic;
  signal clk_u_pos  : std_logic;
  signal clk_i  : std_logic;
  signal clk_i_pos  : std_logic;
  signal clk_e_pos  : std_logic;
  signal clk_e_neg  : std_logic;
  signal clk_p  : std_logic;
  signal clk_rx : std_logic;  
  signal clk_tx : std_logic;
  signal clk_a_pos  : std_logic;
  signal clk_c2a_pos : std_logic;
  signal clk_ea_pos : std_logic;
  --signal clk_ea_neg : std_logic;
  
  -- RTC block
  signal rxout           : std_logic;
  signal mrxout_o        : std_logic;
  signal rtc_data        : std_logic_vector(7 downto 0); 
  signal dis_bmem_int    : std_logic;

  signal halt_en             : std_logic;   --high active, will go to halt state
  signal nap_en              : std_logic;   --high active, will go to nap state
  signal wakeup_lp           : std_logic;  -- From wakeup_lp input IO
  signal poweron_finish      : std_logic;  -- 
  signal reset_iso           : std_logic;  -- to isolate the core reset
  signal reset_iso_clear     : std_logic; --clear reset isolate
  signal reset_core_n        : std_logic;  -- to reset core, low active
  signal io_iso              : std_logic;  -- to isolate the io signals in nap mode
  signal nap_rec             : std_logic;  -- will recover from nap mode
  signal pmic_core_en        : std_logic;  
  signal pmic_io_en          : std_logic;
  signal clk_mux_out         : std_logic;

  signal lp_pwr_ok       : std_logic;

  -----------------------------------------------------------------------------
  -- core/peri driven signals
  -----------------------------------------------------------------------------
  -- Signals to other blocks
  signal exe_i          : std_logic; --CJ
  signal ddi_vld_c1      : std_logic; --CJ
  signal ddi_vld_c2      : std_logic; --CJ
  signal pll_frange   : std_logic;
  signal pll_n        : std_logic_vector(5 downto 0);
  signal pll_m        : std_logic_vector(2 downto 0);
  signal en_xosc      : std_logic;
  signal en_pll       : std_logic;
  signal sel_pll      : std_logic;
  signal xout_selected : std_logic;
  signal test_pll     : std_logic;
  -- signal pll_vcc18a   : std_logic;
  -- signal pll_gnd18a   : std_logic;
  -- signal pll_vcc18d   : std_logic;
  -- signal pll_gnd18d   : std_logic;
  -- signal pll_vcck     : std_logic;
  -- signal pll_gndk     : std_logic;
--  signal test_pll_temp     : std_logic;  --added by HYX 
  signal pll_pdn      : std_logic;       --added by HYX,20141115
  signal erxclk       : std_logic;
  signal etxclk       : std_logic;
  signal rst_n        : std_logic;    
  signal rst_cn       : std_logic;    
  signal en_d         : std_logic;    
  signal fast_d       : std_logic;    
  --signal din_e        : std_logic;
  signal din_ea        : std_logic;    
  signal din_i        : std_logic;    
  signal din_u        : std_logic;    
  signal din_s        : std_logic;    
  signal din_a        : std_logic;
  --add the following two signals by maning
  signal clk_in_off     : std_logic;
  signal clk_main_off   : std_logic;  
  signal sdram_en		: std_logic; 
  signal out_line    : std_logic;
  signal hold_flash  : std_logic;   
  signal hold_flash_d: std_logic;                  
  signal flash_en    : std_logic;                    
  signal flash_mode  : std_logic_vector (3 downto 0);
  signal ld_dqi_flash : std_logic; 
  signal router_ido     : std_logic_vector(7 downto 0);
  signal core_idi       : std_logic_vector(7 downto 0);
  signal bmem_a8      : std_logic;    
  signal bmem_d       : std_logic_vector(7 downto 0);      
  signal bmem_ce_n    : std_logic;   
  signal bmem_we_n    : std_logic; 
--  signal ram_partition : std_logic_vector(3 downto 0); 
  signal rst_rtc      : std_logic; 
  signal en_fclk      : std_logic; 
  signal fclk         : std_logic;
  signal ld_bmem      : std_logic;
  signal rtc_sel      : std_logic_vector(2 downto 0);
  signal ach_sel      : std_logic_vector(2 downto 0);
  signal adc_bits_int : std_logic; -- added by HYX, 20141205
  -- signal adc_ref2v    : std_logic; --delete by HYX, 20141205
  -- signal adc_extref   : std_logic; --delete by HYX, 20141205
  -- signal adc_diff     : std_logic; --delete by HYX, 20141205
  -- signal adc_en       : std_logic; --delete by HYX, 20141205
  signal dac_bits     : std_logic_vector(0 to 1);
  signal dac_en       : std_logic_vector(0 to 1);
  signal en_tstamp    : std_logic_vector(1 downto 0);
  signal tiu_tstamp   : std_logic;
  signal tstamp       : std_logic_vector(2 downto 0);
  signal mpll_tsto_o  : std_logic;                         
  signal adc_dac      : std_logic;  
  --signals to core2
  signal  c2_core2_en   : std_logic;  -- core2 enable
  signal  c2_rsc_n      : std_logic;
  signal  c2_clkreq_gen : std_logic;
  --signal  c2_even_c     : std_logic;
  signal  c2_crb_out    : std_logic_vector(7 downto 0);
  signal  c2_crb_sel    : std_logic_vector(3 downto 0);  
  signal  c2_en_pmem    : std_logic;
  signal  c2_en_wdog    : std_logic;
  signal  c2_pup_clk    : std_logic;
  signal  c2_pup_irq    : std_logic_vector(1 downto 0);
  signal  c2_r_size     : std_logic_vector(1 downto 0);
  signal  c2_c_size     : std_logic_vector(1 downto 0);
  signal  c2_t_ras      : std_logic_vector(2 downto 0);
  signal  c2_t_rcd      : std_logic_vector(1 downto 0);
  signal  c2_t_rp       : std_logic_vector(1 downto 0);
--  signal  c2_en_mexec   : std_logic;
  -- to memories signals
  signal c1_mprom_a       : std_logic_vector(13 downto 0); 
  signal c1_mprom_ce      : std_logic_vector(1 downto 0);  
  signal c1_mprom_oe      : std_logic_vector(1 downto 0);
  --signal c1_mpram_a       : std_logic_vector(13 downto 0);    --Modified by CJ
  --signal c1_mpram_d       : std_logic_vector(79 downto 0);   --Modified by CJ
  signal c1_mpram_a       : std_logic_vector(7 downto 0);   --Modified by CJ
  signal c1_mpram_d       : std_logic_vector(127 downto 0);     --Modified by CJ 
  signal c1_mpram_ce      : std_logic_vector(1 downto 0);    
  signal c1_mpram_oe      : std_logic_vector(1 downto 0);    
  signal c1_mpram_we_n    : std_logic;                       
  signal c1_gmem_a        : std_logic_vector(9 downto 0);    
  signal c1_gmem_d        : std_logic_vector(7 downto 0);    
  signal c1_gmem_ce_n     : std_logic;                      
  signal c1_gmem_we_n     : std_logic;                       
  signal iomem_a       : std_logic_vector(9 downto 0);    
  signal iomem_d       : std_logic_vector(15 downto 0);   
  signal iomem_ce_n    : std_logic_vector(1 downto 0);  
  signal iomem_we_n    : std_logic;                      
  signal trcmem_a      : std_logic_vector(7 downto 0);    
  signal trcmem_d      : std_logic_vector(31 downto 0);   
  signal trcmem_ce_n   : std_logic;                       
  signal trcmem_we_n   : std_logic;                                            
  signal c1_pmem_a        : std_logic_vector(10 downto 0);   
  signal c1_pmem_d        : std_logic_vector(1 downto 0);   
  signal c1_pmem_ce_n     : std_logic;                      
  signal c1_pmem_we_n     : std_logic;  
  signal en_pmem2	   : std_logic;
  signal short_cycle   : std_logic;
  -- to PADS
--  signal router_ir_en  : std_logic;   --delete by HYX, 20141027
--  signal north_en	   : std_logic;     --delete by HYX, 20141027
--  signal south_en	   : std_logic;     --delete by HYX, 20141027
--  signal west_en	   : std_logic;      --delete by HYX, 20141027
--  signal east_en	   : std_logic;      --delete by HYX, 20141027
--  signal router_clk_en : std_logic;   --delete by HYX, 20141027  
  signal mirqout_o     : std_logic;                       
  signal mckout1_o     : std_logic;   
  signal mckout1_o_en  : std_logic;                    
  signal msdout_o      : std_logic;                       
  signal mrstout_o     : std_logic;                       
  signal mexec_o       : std_logic;                       
  signal mxout_o       : std_logic;                       
  signal ddq_en        : std_logic;                       
  signal da_o          : std_logic_vector(13 downto 0);   
  signal dba_o         : std_logic_vector(1 downto 0);    
  signal dcke_o        : std_logic_vector(3 downto 0);    
  signal pa_en         : std_logic_vector(7 downto 0);    
  signal pa_o          : std_logic_vector(7 downto 0);    
  signal pb_en         : std_logic_vector(7 downto 0);    
  signal pb_o          : std_logic_vector(7 downto 0);    
  signal pc_en         : std_logic_vector(7 downto 0);    
  signal pc_o          : std_logic_vector(7 downto 0);    
  signal pd_en         : std_logic_vector(7 downto 0);    
  signal pd_o          : std_logic_vector(7 downto 0);    
  signal pe_en         : std_logic_vector(7 downto 0);    
  signal pe_o          : std_logic_vector(7 downto 0);    
  signal pf_en         : std_logic_vector(7 downto 0);    
  signal pf_o          : std_logic_vector(7 downto 0);    
  signal pg_en         : std_logic_vector(7 downto 0);    
  signal pg_o          : std_logic_vector(7 downto 0);    
  signal ph_en         : std_logic_vector(7 downto 0);    
  signal ph_o          : std_logic_vector(7 downto 0);    
  signal pi_en         : std_logic_vector(7 downto 0);    
  signal pi_o          : std_logic_vector(7 downto 0);    
  signal pj_en         : std_logic_vector(7 downto 0);    
  signal pj_o          : std_logic_vector(7 downto 0);
  
  signal d_hi          : std_logic;                       
  signal d_sr          : std_logic;                       
  signal d_lo          : std_logic;                       
  signal p1_hi         : std_logic;                       
  signal p1_sr         : std_logic;     
  signal p2_hi         : std_logic;                       
  signal p2_sr         : std_logic; 
  signal p3_hi         : std_logic;                       
  signal p3_sr         : std_logic;                     
  -- signal pc_hi         : std_logic;                       
  -- signal pc_lo_n       : std_logic;                       
  -- signal ph_hi         : std_logic;                       
  -- signal ph_lo_n       : std_logic;                       
  -- signal pi_hi         : std_logic;                       
  -- signal pi_lo_n       : std_logic;                                          
  -- signal pel_hi        : std_logic;                       
  -- signal peh_hi        : std_logic;                       
  -- signal pdll_hi       : std_logic;                       
  -- signal pdlh_hi       : std_logic;                       
  -- signal pdh_hi        : std_logic;                                             
  -- signal pf_hi         : std_logic;                       
  -- signal pg_hi         : std_logic;                       
  
  -----------------------------------------------------------------------------
  -- signals between core and peri
  -----------------------------------------------------------------------------
  -- core driven
  signal dbus        : std_logic_vector(7 downto 0);  
  signal rst_en      : std_logic;
  --signal rst_en2     : std_logic;
  signal pd_s          : std_logic_vector(2 downto 0);
  signal aaddr       : std_logic_vector(4 downto 0);
  signal idack       : std_logic_vector(7 downto 0);
  signal ios_iden    : std_logic;                   
  signal ios_ido     : std_logic_vector(7 downto 0);                  
  signal ilioa       : std_logic;                   
  signal ildout      : std_logic;                   
  signal inext       : std_logic;
  signal iden        : std_logic;                         
  signal dqm_size    : std_logic_vector(1 downto 0);
  signal en_uart1    : std_logic;
  signal en_uart2    : std_logic;
  signal en_uart3    : std_logic;
  signal en_eth      : std_logic_vector(1 downto 0);
  signal en_iobus    : std_logic_vector(1 downto 0);
  signal ddqm        : std_logic_vector(7 downto 0);
  signal en_tiu      : std_logic;
  signal run_tiu     : std_logic;
  -- Peri driven
  signal dfp         : std_logic_vector(7 downto 0);
  signal idreq       : std_logic_vector(7 downto 0);
  signal idi         : std_logic_vector(7 downto 0);
  signal irq0        : std_logic;                         
  signal irq1        : std_logic; 
  --- signal declrations for memory selector jameel--  
  -- signal dout_rom0_sig : std_logic_vector(79 downto 0);
  -- signal dout_ram0_sig : std_logic_vector(79 downto 0);
  -- signal dout_rom1_sig : std_logic_vector(79 downto 0);
  -- signal dout_ram1_sig : std_logic_vector(79 downto 0);
  ------signal declaration end here------------------
  --signal proc_clk    : std_logic;
  -----------------------------------------------------------------------------
  -- Memory driven signals
  -----------------------------------------------------------------------------
  -- MPROM0, MPROM1, MPRAM0, MPRAM1
  signal c1_mp_q      : std_logic_vector(127 downto 0);
  signal c2_mp_q      : std_logic_vector(127 downto 0);  
  -- GMEM
  signal c1_gmem_q    : std_logic_vector(7 downto 0);
  signal c2_gmem_q    : std_logic_vector(7 downto 0);
  -- IOMEM0, IOMEM1
  signal iomem_q   : std_logic_vector(15 downto 0);
  
  -- TRCMEM
  signal trcmem_q  : std_logic_vector(31 downto 0);
  
  -- PMEM (Patch memory)  
  signal c1_pmem_q    : std_logic_vector(1  downto 0);
  signal c2_pmem_q    : std_logic_vector(1  downto 0);
  -- BMEM (battery backed memory)
  signal bmem_q    : std_logic_vector(7 downto 0); 
  
  signal rom0_addr_sig : std_logic_vector(11 downto 0); 
  -- router related signals
--  signal router_en : STD_LOGIC;                                       --delete by HYX, 20141027
--  signal clk_i_r : STD_LOGIC;                                          --delete by HYX, 20141027
--  signal clk_p_r : STD_LOGIC;                                           --delete by HYX, 20141027
--	signal	north_ack_s_in          : STD_LOGIC_VECTOR (1 downto 0);         --delete by HYX, 20141027
--	signal	north_data_s_in         : STD_LOGIC_VECTOR (3 downto 0);          --delete by HYX, 20141027 
--	signal	north_ack_s_out         :  STD_LOGIC_VECTOR (1 downto 0);          --delete by HYX, 20141027
--	signal	north_data_s_out        :  STD_LOGIC_VECTOR (3 downto 0);            --delete by HYX, 20141027
--	signal	south_ack_s_in          : STD_LOGIC_VECTOR (1 downto 0);             --delete by HYX, 20141027
--	signal	south_data_s_in         : STD_LOGIC_VECTOR (3 downto 0);           --delete by HYX, 20141027
--	signal	south_ack_s_out         :  STD_LOGIC_VECTOR (1 downto 0);        --delete by HYX, 20141027
--	signal	south_data_s_out        :  STD_LOGIC_VECTOR (3 downto 0);        --delete by HYX, 20141027
--	signal	west_ack_s_in           : STD_LOGIC_VECTOR (1 downto 0);         --delete by HYX, 20141027
--	signal	west_data_s_in          : STD_LOGIC_VECTOR (3 downto 0);           --delete by HYX, 20141027
--	signal	west_ack_s_out          :  STD_LOGIC_VECTOR (1 downto 0);        --delete by HYX, 20141027
--	signal	west_data_s_out         :  STD_LOGIC_VECTOR (3 downto 0);        --delete by HYX, 20141027
--	signal	east_ack_s_in           : STD_LOGIC_VECTOR (1 downto 0);         --delete by HYX, 20141027
--	signal	east_data_s_in          : STD_LOGIC_VECTOR (3 downto 0);           --delete by HYX, 20141027
--	signal	east_ack_s_out          :  STD_LOGIC_VECTOR (1 downto 0);          --delete by HYX, 20141027
--	signal	east_data_s_out         :  STD_LOGIC_VECTOR (3 downto 0);          --delete by HYX, 20141027
--	signal  rd_irq_n				 : std_logic;                                         --delete by HYX, 20141027
-------------------------------------------------------------------------------
---------------dual core related----------------------------------------------------------
-------------------------------------------------------------------------------
	signal c1_d_addr   : std_logic_vector(31 downto 0);
	signal c1_d_cs     : std_logic;  -- CS to SDRAM
    signal c1_d_ras    : std_logic;  -- RAS to SDRAM
    signal c1_d_cas    : std_logic;  -- CAS to SDRAM
    signal c1_d_we     : std_logic;  -- WE to SDRAM
    signal c1_d_dqi    : std_logic_vector(31 downto 0); -- Data in from processor --CJ
    signal c1_d_dqi_sd : std_logic_vector(7 downto 0); -- Data in from sdram
    signal c1_d_dqo    : std_logic_vector(127 downto 0); -- Data out to processor --CJ
	signal c2_d_addr   : std_logic_vector(31 downto 0);
	signal c2_d_cs     : std_logic;  -- CS to SDRAM
    signal c2_d_ras    : std_logic;  -- RAS to SDRAM
    signal c2_d_cas    : std_logic;  -- CAS to SDRAM
    signal c2_d_we     : std_logic;  -- WE to SDRAM
    signal c2_d_dqi    : std_logic_vector(31 downto 0); -- Data in from processor
    signal c2_d_dqo    : std_logic_vector(127 downto 0); -- Data out to processor
    
  signal c2_mprom_a       : std_logic_vector(13 downto 0); --CJ
  signal c2_mprom_ce      : std_logic_vector(1 downto 0);  
  signal c2_mprom_oe      : std_logic_vector(1 downto 0);
  signal c2_mpram_a       : std_logic_vector(7 downto 0); --CJ
  signal c2_mpram_d       : std_logic_vector(127 downto 0); --CJ  
  signal c2_mpram_ce      : std_logic_vector(1 downto 0);    
  signal c2_mpram_oe      : std_logic_vector(1 downto 0);    
  signal c2_mpram_we_n    : std_logic;                       
  signal c2_gmem_a        : std_logic_vector(9 downto 0);    
  signal c2_gmem_d        : std_logic_vector(7 downto 0);    
  signal c2_gmem_ce_n     : std_logic;                       
  signal c2_gmem_we_n     : std_logic;                                                                 
  signal c2_pmem_a        : std_logic_vector(10 downto 0);   
  signal c2_pmem_d        : std_logic_vector(1 downto 0);   
  signal c2_pmem_ce_n     : std_logic;                       
  signal c2_pmem_we_n     : std_logic; 
  
  signal mp_ROM0_DO     : std_logic_vector (79 downto 0); 
  signal mp_ROM0_A      : std_logic_vector (13 downto 0); 
  signal mp_ROM0_CS     : std_logic;                      
  signal mp_ROM0_OE     : std_logic;                      
  signal mp_ROM1_DO     :  std_logic_vector (79 downto 0);
  signal mp_ROM1_A      :  std_logic_vector (13 downto 0);
  signal mp_ROM1_CS     :  std_logic;                     
  signal mp_ROM1_OE     :  std_logic;                     
  signal mp_PM_DO       : std_logic_vector (1 downto 0);  
  signal mp_PM_DI       : std_logic_vector (1 downto 0);  
  signal mp_PM_A        : std_logic_vector (10 downto 0); 
  signal mp_PM_WEB      : std_logic;                      
  signal mp_PM_CSB      : std_logic;      

  signal mp_RAM0_DO     :  std_logic_vector (127 downto 0);
  signal mp_RAM0_DI     :  std_logic_vector (127 downto 0);
  signal mp_RAM0_A      :  std_logic_vector (7 downto 0);
  signal mp_RAM0_WEB    :  std_logic;   
  signal mp_RAM0_OE     :  std_logic;
  signal mp_RAM0_CS     :  std_logic;                  
                    
  signal mp_RAM1_DO     :  std_logic_vector (79 downto 0);
  signal mp_RAM1_DI     :  std_logic_vector (79 downto 0);
  signal mp_RAM1_A      :  std_logic_vector (13 downto 0);
  signal mp_RAM1_WEB    :  std_logic;
  signal mp_RAM1_CS     : std_logic;   

  signal f_addr_in     : std_logic_vector(16 downto 0);
  signal f_rd_in       : std_logic;  -- low active
  signal f_wr_in       : std_logic;  -- low active        
  signal f_data_in     : std_logic_vector(7 downto 0); -- Data in from processor
  signal f_data_out    : std_logic_vector(7 downto 0); -- Data out to processor   
  signal f_CE          : std_logic;                      
  signal f_ADDR        : std_logic_vector(12 downto 0);  
  signal f_WRONLY      : std_logic;                      
  signal f_PERASE      : std_logic;                      
  signal f_SERASE      : std_logic;                      
  signal f_MERASE      : std_logic;                      
  signal f_PROG        : std_logic;                      
  signal f_INF         : std_logic;                      
  signal f_POR         : std_logic;                      
  signal f_SAVEN       : std_logic;                      
  signal f_TM          : std_logic_vector(3 downto 0);   
  signal f_DATA_WR     : std_logic_vector(31 downto 0);  
  signal f0_ALE        : std_logic;    
  signal f0_DATA_IN    :std_logic_vector(31 downto 0);       
  signal f0_RBB        :std_logic;  
  signal f1_ALE        : std_logic;    
  signal f1_DATA_IN    :std_logic_vector(31 downto 0);       
  signal f1_RBB        :std_logic; 
  signal f2_ALE        : std_logic;    
  signal f2_DATA_IN    :std_logic_vector(31 downto 0);       
  signal f2_RBB        :std_logic; 
  signal f3_ALE        : std_logic;    
  signal f3_DATA_IN    :std_logic_vector(31 downto 0);       
  signal f3_RBB        :std_logic; 
  --RAM0 
  signal RAM0_DO         : std_logic_vector (7 downto 0); -- modify flag, 2015lp
  signal RAM0_DI         : std_logic_vector (7 downto 0);
  signal RAM0_A          : std_logic_vector (13 downto 0);
  signal RAM0_WEB        : std_logic;
  signal RAM0_CS         : std_logic;
        --RAM1 
  signal RAM1_DO         : std_logic_vector (7 downto 0);
  signal RAM1_DI         : std_logic_vector (7 downto 0);
  signal RAM1_A          : std_logic_vector (13 downto 0);
  signal RAM1_WEB        : std_logic;
  signal RAM1_CS         : std_logic;
         --RAM2 
  signal RAM2_DO         : std_logic_vector (7 downto 0);
  signal RAM2_DI         : std_logic_vector (7 downto 0);
  signal RAM2_A          : std_logic_vector (13 downto 0);
  signal RAM2_WEB        : std_logic;
  signal RAM2_CS         : std_logic;
         --RAM3 
  signal RAM3_DO         : std_logic_vector (7 downto 0);
  signal RAM3_DI         : std_logic_vector (7 downto 0);
  signal RAM3_A          : std_logic_vector (13 downto 0);
  signal RAM3_WEB        : std_logic;
  signal RAM3_CS         : std_logic;
         --RAM4 
  signal RAM4_DO         : std_logic_vector (7 downto 0);
  signal RAM4_DI         : std_logic_vector (7 downto 0);
  signal RAM4_A          : std_logic_vector (13 downto 0);
  signal RAM4_WEB        : std_logic;
  signal RAM4_CS         : std_logic;
--         --RAM5 
--  signal RAM5_DO         : std_logic_vector (127 downto 0);
--  signal RAM5_DI         : std_logic_vector (127 downto 0);
--  signal RAM5_A          : std_logic_vector (9 downto 0);
--  signal RAM5_WEB        : std_logic_vector(15 downto 0);
--  signal RAM5_CS         : std_logic;
--         --RAM6 
--  signal RAM6_DO         : std_logic_vector (127 downto 0);
--  signal RAM6_DI         : std_logic_vector (127 downto 0);
--  signal RAM6_A          : std_logic_vector (9 downto 0);
--  signal RAM6_WEB        : std_logic_vector(15 downto 0);
--  signal RAM6_CS         : std_logic;
--         --RAM7 
--  signal RAM7_DO         : std_logic_vector (127 downto 0);
--  signal RAM7_DI         : std_logic_vector (127 downto 0);
--  signal RAM7_A          : std_logic_vector (9 downto 0);
--  signal RAM7_WEB        : std_logic_vector(15 downto 0);
--  signal RAM7_CS         : std_logic;   

begin

  -- RJ start

  ------------------------------------------------------
  -- PCIe
  ------------------------------------------------------
  --pcie_req_if_clk_o <= ref_clk;
  --pcie_req_if_rst_o <= '0';
  --pcie_wr_req_ctrl_wrs <= '0';
  --pcie_wr_req_ctrl_length     <= (others => '0');
  --pcie_wr_req_ctrl_start_addr <= (others => '0');
  --pcie_wr_req_data_wrs        <= '0';
  --pcie_wr_req_data            <= (others => '0');
  --pcie_rd_req_wrs             <= '0';
  --pcie_rd_req_start_addr      <= (others => '0');
  --pcie_rd_req_length          <= (others => '0');
--
  --------------------------------------------------------
  ---- DDR4
  --------------------------------------------------------
  --ddr4_cell_clk_o           <= ddr4_clk_i;
  --ddr4_cell_rst_o           <= '0';
  --ddr4_cell_input_start     <= '0';
  --ddr4_cell_input_data      <= (others => '0');
  --ddr4_input_addr           <= (others => '0');
  --ddr4_cell_output_ready    <= '0';
  --ddr4_output_addr_vld      <= '0';
  --ddr4_output_addr          <= (others => '0');
--
  --------------------------------------------------------
  ---- Reg1
  --------------------------------------------------------
  --reg1_user_clk  <= reg1_ref_clk;
  --reg1_user_rst  <= '0';
  --reg1_rda       <= (others => '0');
  --reg1_rdav      <= '0';
  --reg1_ac        <= reg1_wea;
--
  --------------------------------------------------------
  ---- Reg2
  --------------------------------------------------------
  --reg2_user_clk  <= reg2_ref_clk;
  --reg2_user_rst  <= '0';
  --reg2_rda       <= (others => '0');
  --reg2_rdav      <= '0';
  --reg2_ac        <= reg2_wea;

  
  hclk_i <= HCLK;
  --hclk_i <= ref_clk;
  mreset_i <= MRESET;
  MIRQOUT <= mirqout_o; 
  MCKOUT0 <= clk_s;
  MCKOUT1 <= mckout1_o; 
  mtest_i <= MTEST;
  mbypass_i <= MBYPASS;
  mirq0_i <= MIRQ0;
  mirq1_i <= MIRQ1;
  -- SW debug                                                               
  msdin_i <= MSDIN;
  MSDOUT <= msdout_o;

  rxout <= clk_s;

  wakeup_lp <= '1';
  lp_pwr_ok <= '1';
  pmic_core_en <= '1';
  pmic_io_en <= '1';
  io_iso <= '1';

  pllout <= HCLK;
  ddi_vld_c1 <= C1_DDI_VLD;
  ddi_vld_c2 <= C2_DDI_VLD;
  C1_REQ_D <=c1_d_dqi;
  C2_REQ_D <= c2_d_dqi;
  c1_d_dqo <= C1_IN_D;
  c2_d_dqo <= C2_IN_D;
  --process
  --begin
  --  lp_pwr_ok <= '0';
  --  wait for 32 ns;
  --  lp_pwr_ok <= '1';
  --  wait;
  --end process;
  --pllout <= ref_clk;
-- RJ end
  

 -----------------------------------------------------------------------------
 -----------------------------------------------------------------------------
 -----------------------------------------------------------------------------            
               
 rom0_addr_sig <= mp_ROM0_A(12) & mp_ROM0_A(10 downto 0);
  -----------------------------------------------------------------------------
  -- Instantiation of memories
  -----------------------------------------------------------------------------

  -- mprom0, mprom1
 --  mprom00
--  mprom00: SP180_4096X80BM1A
--  PORT MAP (
--      A0          => rom0_addr_sig(0),
--      A1          => rom0_addr_sig(1),               
--      A2          => rom0_addr_sig(2),              
--      A3          => rom0_addr_sig(3),             
--      A4          => rom0_addr_sig(4),             
--      A5          => rom0_addr_sig(5),               
--      A6          => rom0_addr_sig(6),               
--      A7          => rom0_addr_sig(7),               
--      A8          => rom0_addr_sig(8),               
--      A9          => rom0_addr_sig(9),               
--      A10         => rom0_addr_sig(10),
--      A11         => rom0_addr_sig(11),                
--      DO0         => mp_ROM0_DO(0),              
--      DO1         => mp_ROM0_DO(1),              
--      DO2         => mp_ROM0_DO(2),              
--      DO3         => mp_ROM0_DO(3),               
--      DO4         => mp_ROM0_DO(4),               
--      DO5         => mp_ROM0_DO(5),               
--      DO6         => mp_ROM0_DO(6),               
--      DO7         => mp_ROM0_DO(7),              
--      DO8         => mp_ROM0_DO(8),               
--      DO9         => mp_ROM0_DO(9),               
--      DO10        => mp_ROM0_DO(10),              
--      DO11        => mp_ROM0_DO(11),              
--      DO12        => mp_ROM0_DO(12),              
--      DO13        => mp_ROM0_DO(13),               
--      DO14        => mp_ROM0_DO(14),                
--      DO15        => mp_ROM0_DO(15),              
--      DO16        => mp_ROM0_DO(16),              
--      DO17        => mp_ROM0_DO(17),                
--      DO18        => mp_ROM0_DO(18),               
--      DO19        => mp_ROM0_DO(19),               
--      DO20        => mp_ROM0_DO(20),           
--      DO21        => mp_ROM0_DO(21),               
--      DO22        => mp_ROM0_DO(22),               
--      DO23        => mp_ROM0_DO(23),               
--      DO24        => mp_ROM0_DO(24),                
--      DO25        => mp_ROM0_DO(25),               
--      DO26        => mp_ROM0_DO(26),               
--      DO27        => mp_ROM0_DO(27),               
--      DO28        => mp_ROM0_DO(28),               
--      DO29        => mp_ROM0_DO(29),               
--      DO30        => mp_ROM0_DO(30),               
--      DO31        => mp_ROM0_DO(31),              
--      DO32        => mp_ROM0_DO(32),             
--      DO33        => mp_ROM0_DO(33),             
--      DO34        => mp_ROM0_DO(34),            
--      DO35        => mp_ROM0_DO(35),             
--      DO36        => mp_ROM0_DO(36),              
--      DO37        => mp_ROM0_DO(37),               
--      DO38        => mp_ROM0_DO(38),               
--      DO39        => mp_ROM0_DO(39),               
--      DO40        => mp_ROM0_DO(40),             
--      DO41        => mp_ROM0_DO(41),              
--      DO42        => mp_ROM0_DO(42),             
--      DO43        => mp_ROM0_DO(43),               
--      DO44        => mp_ROM0_DO(44),               
--      DO45        => mp_ROM0_DO(45),              
--      DO46        => mp_ROM0_DO(46),               
--      DO47        => mp_ROM0_DO(47),              
--      DO48        => mp_ROM0_DO(48),                
--      DO49        => mp_ROM0_DO(49),             
--      DO50        => mp_ROM0_DO(50),              
--      DO51        => mp_ROM0_DO(51),               
--      DO52        => mp_ROM0_DO(52),             
--      DO53        => mp_ROM0_DO(53),           
--      DO54        => mp_ROM0_DO(54),             
--      DO55        => mp_ROM0_DO(55),             
--      DO56        => mp_ROM0_DO(56),              
--      DO57        => mp_ROM0_DO(57),             
--      DO58        => mp_ROM0_DO(58),          
--      DO59        => mp_ROM0_DO(59),              
--      DO60        => mp_ROM0_DO(60),             
--      DO61        => mp_ROM0_DO(61),           
--      DO62        => mp_ROM0_DO(62),             
--      DO63        => mp_ROM0_DO(63),               
--      DO64        => mp_ROM0_DO(64),              
--      DO65        => mp_ROM0_DO(65),             
--      DO66        => mp_ROM0_DO(66),               
--      DO67        => mp_ROM0_DO(67),              
--      DO68        => mp_ROM0_DO(68),             
--      DO69        => mp_ROM0_DO(69),            
--      DO70        => mp_ROM0_DO(70),           
--      DO71        => mp_ROM0_DO(71),             
--      DO72        => mp_ROM0_DO(72),        
--      DO73        => mp_ROM0_DO(73),              
--      DO74        => mp_ROM0_DO(74),              
--      DO75        => mp_ROM0_DO(75),             
--      DO76        => mp_ROM0_DO(76),               
--      DO77        => mp_ROM0_DO(77),          
--      DO78        => mp_ROM0_DO(78),           
--      DO79        => mp_ROM0_DO(79),                         
--      CK          => clk_p,           
--      CS          => mp_ROM0_CS,               
--      OE          => mp_ROM0_OE                
--      );--
--

--    
-- --  mprom11
--   mprom11: SP180_4096X80BM1B
--   PORT MAP (
--       A0          => mp_ROM1_A(0),
--       A1          => mp_ROM1_A(1),               
--       A2          => mp_ROM1_A(2),              
--       A3          => mp_ROM1_A(3),             
--       A4          => mp_ROM1_A(4),             
--       A5          => mp_ROM1_A(5),               
--       A6          => mp_ROM1_A(6),               
--       A7          => mp_ROM1_A(7),               
--       A8          => mp_ROM1_A(8),               
--       A9          => mp_ROM1_A(9),               
--       A10         => mp_ROM1_A(10),
--       A11         => mp_ROM1_A(11),                
--       DO0         => mp_ROM1_DO(0),               
--       DO1         => mp_ROM1_DO(1),               
--       DO2         => mp_ROM1_DO(2),              
--       DO3         => mp_ROM1_DO(3),               
--       DO4         => mp_ROM1_DO(4),               
--       DO5         => mp_ROM1_DO(5),               
--       DO6         => mp_ROM1_DO(6),               
--       DO7         => mp_ROM1_DO(7),              
--       DO8         => mp_ROM1_DO(8),               
--       DO9         => mp_ROM1_DO(9),               
--       DO10        => mp_ROM1_DO(10),              
--       DO11        => mp_ROM1_DO(11),              
--       DO12        => mp_ROM1_DO(12),              
--       DO13        => mp_ROM1_DO(13),               
--       DO14        => mp_ROM1_DO(14),                
--       DO15        => mp_ROM1_DO(15),              
--       DO16        => mp_ROM1_DO(16),              
--       DO17        => mp_ROM1_DO(17),                
--       DO18        => mp_ROM1_DO(18),               
--       DO19        => mp_ROM1_DO(19),               
--       DO20        => mp_ROM1_DO(20),           
--       DO21        => mp_ROM1_DO(21),               
--       DO22        => mp_ROM1_DO(22),               
--       DO23        => mp_ROM1_DO(23),               
--       DO24        => mp_ROM1_DO(24),                
--       DO25        => mp_ROM1_DO(25),               
--       DO26        => mp_ROM1_DO(26),               
--       DO27        => mp_ROM1_DO(27),               
--       DO28        => mp_ROM1_DO(28),               
--       DO29        => mp_ROM1_DO(29),               
--       DO30        => mp_ROM1_DO(30),               
--       DO31        => mp_ROM1_DO(31),              
--       DO32        => mp_ROM1_DO(32),             
--       DO33        => mp_ROM1_DO(33),             
--       DO34        => mp_ROM1_DO(34),            
--       DO35        => mp_ROM1_DO(35),             
--       DO36        => mp_ROM1_DO(36),              
--       DO37        => mp_ROM1_DO(37),               
--       DO38        => mp_ROM1_DO(38),               
--       DO39        => mp_ROM1_DO(39),               
--       DO40        => mp_ROM1_DO(40),             
--       DO41        => mp_ROM1_DO(41),              
--       DO42        => mp_ROM1_DO(42),             
--       DO43        => mp_ROM1_DO(43),               
--       DO44        => mp_ROM1_DO(44),               
--       DO45        => mp_ROM1_DO(45),              
--       DO46        => mp_ROM1_DO(46),               
--       DO47        => mp_ROM1_DO(47),              
--       DO48        => mp_ROM1_DO(48),                
--       DO49        => mp_ROM1_DO(49),             
--       DO50        => mp_ROM1_DO(50),              
--       DO51        => mp_ROM1_DO(51),               
--       DO52        => mp_ROM1_DO(52),             
--       DO53        => mp_ROM1_DO(53),           
--       DO54        => mp_ROM1_DO(54),             
--       DO55        => mp_ROM1_DO(55),             
--       DO56        => mp_ROM1_DO(56),              
--       DO57        => mp_ROM1_DO(57),             
--       DO58        => mp_ROM1_DO(58),          
--       DO59        => mp_ROM1_DO(59),              
--       DO60        => mp_ROM1_DO(60),             
--       DO61        => mp_ROM1_DO(61),           
--       DO62        => mp_ROM1_DO(62),             
--       DO63        => mp_ROM1_DO(63),               
--       DO64        => mp_ROM1_DO(64),              
--       DO65        => mp_ROM1_DO(65),             
--       DO66        => mp_ROM1_DO(66),               
--       DO67        => mp_ROM1_DO(67),              
--       DO68        => mp_ROM1_DO(68),             
--       DO69        => mp_ROM1_DO(69),            
--       DO70        => mp_ROM1_DO(70),           
--       DO71        => mp_ROM1_DO(71),             
--       DO72        => mp_ROM1_DO(72),        
--       DO73        => mp_ROM1_DO(73),              
--       DO74        => mp_ROM1_DO(74),              
--       DO75        => mp_ROM1_DO(75),             
--       DO76        => mp_ROM1_DO(76),               
--       DO77        => mp_ROM1_DO(77),          
--       DO78        => mp_ROM1_DO(78),           
--       DO79        => mp_ROM1_DO(79),                         
--       CK          => clk_p, 
--       CS          => mp_ROM1_CS,               
--       OE          => mp_ROM1_OE                
--       );

  mpram00: SU180_256X128X1BM1A
  PORT MAP (
      A0          => mp_RAM0_A(0),
      A1          => mp_RAM0_A(1),               
      A2          => mp_RAM0_A(2),              
      A3          => mp_RAM0_A(3),             
      A4          => mp_RAM0_A(4),             
      A5          => mp_RAM0_A(5),               
      A6          => mp_RAM0_A(6),               
      A7          => mp_RAM0_A(7),               
      --A8          => mp_RAM0_A(8),               
      --A9          => mp_RAM0_A(9),               
      --A10         => mp_RAM0_A(10),                
      DO0         => mp_RAM0_DO(0),               
      DO1         => mp_RAM0_DO(1),               
      DO2         => mp_RAM0_DO(2),              
      DO3         => mp_RAM0_DO(3),               
      DO4         => mp_RAM0_DO(4),               
      DO5         => mp_RAM0_DO(5),               
      DO6         => mp_RAM0_DO(6),               
      DO7         => mp_RAM0_DO(7),              
      DO8         => mp_RAM0_DO(8),               
      DO9         => mp_RAM0_DO(9),               
      DO10        => mp_RAM0_DO(10),              
      DO11        => mp_RAM0_DO(11),              
      DO12        => mp_RAM0_DO(12),              
      DO13        => mp_RAM0_DO(13),               
      DO14        => mp_RAM0_DO(14),                
      DO15        => mp_RAM0_DO(15),              
      DO16        => mp_RAM0_DO(16),              
      DO17        => mp_RAM0_DO(17),                
      DO18        => mp_RAM0_DO(18),               
      DO19        => mp_RAM0_DO(19),               
      DO20        => mp_RAM0_DO(20),           
      DO21        => mp_RAM0_DO(21),               
      DO22        => mp_RAM0_DO(22),               
      DO23        => mp_RAM0_DO(23),               
      DO24        => mp_RAM0_DO(24),                
      DO25        => mp_RAM0_DO(25),               
      DO26        => mp_RAM0_DO(26),               
      DO27        => mp_RAM0_DO(27),               
      DO28        => mp_RAM0_DO(28),               
      DO29        => mp_RAM0_DO(29),               
      DO30        => mp_RAM0_DO(30),               
      DO31        => mp_RAM0_DO(31),              
      DO32        => mp_RAM0_DO(32),             
      DO33        => mp_RAM0_DO(33),             
      DO34        => mp_RAM0_DO(34),            
      DO35        => mp_RAM0_DO(35),             
      DO36        => mp_RAM0_DO(36),              
      DO37        => mp_RAM0_DO(37),               
      DO38        => mp_RAM0_DO(38),               
      DO39        => mp_RAM0_DO(39),               
      DO40        => mp_RAM0_DO(40),             
      DO41        => mp_RAM0_DO(41),              
      DO42        => mp_RAM0_DO(42),             
      DO43        => mp_RAM0_DO(43),               
      DO44        => mp_RAM0_DO(44),               
      DO45        => mp_RAM0_DO(45),              
      DO46        => mp_RAM0_DO(46),               
      DO47        => mp_RAM0_DO(47),              
      DO48        => mp_RAM0_DO(48),                
      DO49        => mp_RAM0_DO(49),             
      DO50        => mp_RAM0_DO(50),              
      DO51        => mp_RAM0_DO(51),               
      DO52        => mp_RAM0_DO(52),             
      DO53        => mp_RAM0_DO(53),           
      DO54        => mp_RAM0_DO(54),             
      DO55        => mp_RAM0_DO(55),             
      DO56        => mp_RAM0_DO(56),              
      DO57        => mp_RAM0_DO(57),             
      DO58        => mp_RAM0_DO(58),          
      DO59        => mp_RAM0_DO(59),              
      DO60        => mp_RAM0_DO(60),             
      DO61        => mp_RAM0_DO(61),           
      DO62        => mp_RAM0_DO(62),             
      DO63        => mp_RAM0_DO(63),               
      DO64        => mp_RAM0_DO(64),              
      DO65        => mp_RAM0_DO(65),             
      DO66        => mp_RAM0_DO(66),               
      DO67        => mp_RAM0_DO(67),              
      DO68        => mp_RAM0_DO(68),             
      DO69        => mp_RAM0_DO(69),            
      DO70        => mp_RAM0_DO(70),           
      DO71        => mp_RAM0_DO(71),             
      DO72        => mp_RAM0_DO(72),        
      DO73        => mp_RAM0_DO(73),              
      DO74        => mp_RAM0_DO(74),              
      DO75        => mp_RAM0_DO(75),             
      DO76        => mp_RAM0_DO(76),               
      DO77        => mp_RAM0_DO(77),          
      DO78        => mp_RAM0_DO(78),           
      DO79        => mp_RAM0_DO(79), 
      DO80        => mp_RAM0_DO(80),  --CJ
      DO81        => mp_RAM0_DO(81),  --CJ
      DO82        => mp_RAM0_DO(82),  --CJ
      DO83        => mp_RAM0_DO(83),  --CJ
      DO84        => mp_RAM0_DO(84),  --CJ
      DO85        => mp_RAM0_DO(85),  --CJ
      DO86        => mp_RAM0_DO(86),  --CJ
      DO87        => mp_RAM0_DO(87),  --CJ
      DO88        => mp_RAM0_DO(88),  --CJ
      DO89        => mp_RAM0_DO(89),  --CJ
      DO90        => mp_RAM0_DO(90),  --CJ
      DO91        => mp_RAM0_DO(91),  --CJ
      DO92        => mp_RAM0_DO(92),  --CJ
      DO93        => mp_RAM0_DO(93),  --CJ
      DO94        => mp_RAM0_DO(94),  --CJ
      DO95        => mp_RAM0_DO(95),  --CJ
      DO96        => mp_RAM0_DO(96),  --CJ
      DO97        => mp_RAM0_DO(97),  --CJ
      DO98        => mp_RAM0_DO(98),  --CJ
      DO99        => mp_RAM0_DO(99),  --CJ
      DO100       => mp_RAM0_DO(100), --CJ
      DO101       => mp_RAM0_DO(101), --CJ
      DO102       => mp_RAM0_DO(102), --CJ
      DO103       => mp_RAM0_DO(103), --CJ
      DO104       => mp_RAM0_DO(104), --CJ
      DO105       => mp_RAM0_DO(105), --CJ
      DO106       => mp_RAM0_DO(106), --CJ
      DO107       => mp_RAM0_DO(107), --CJ
      DO108       => mp_RAM0_DO(108), --CJ
      DO109       => mp_RAM0_DO(109), --CJ
      DO110       => mp_RAM0_DO(110), --CJ
      DO111       => mp_RAM0_DO(111), --CJ
      DO112       => mp_RAM0_DO(112), --CJ
      DO113       => mp_RAM0_DO(113), --CJ
      DO114       => mp_RAM0_DO(114), --CJ
      DO115       => mp_RAM0_DO(115), --CJ
      DO116       => mp_RAM0_DO(116), --CJ
      DO117       => mp_RAM0_DO(117), --CJ
      DO118       => mp_RAM0_DO(118), --CJ
      DO119       => mp_RAM0_DO(119), --CJ
      DO120       => mp_RAM0_DO(120), --CJ
      DO121       => mp_RAM0_DO(121), --CJ
      DO122       => mp_RAM0_DO(122), --CJ
      DO123       => mp_RAM0_DO(123), --CJ
      DO124       => mp_RAM0_DO(124), --CJ
      DO125       => mp_RAM0_DO(125), --CJ
      DO126       => mp_RAM0_DO(126), --CJ
      DO127       => mp_RAM0_DO(127), --CJ          
      DI0         => mp_RAM0_DI(0),           
      DI1         => mp_RAM0_DI(1),            
      DI2         => mp_RAM0_DI(2),            
      DI3         => mp_RAM0_DI(3),            
      DI4         => mp_RAM0_DI(4),           
      DI5         => mp_RAM0_DI(5),            
      DI6         => mp_RAM0_DI(6),           
      DI7         => mp_RAM0_DI(7),         
      DI8         => mp_RAM0_DI(8),           
      DI9         => mp_RAM0_DI(9),           
      DI10        => mp_RAM0_DI(10),              
      DI11        => mp_RAM0_DI(11),              
      DI12        => mp_RAM0_DI(12),              
      DI13        => mp_RAM0_DI(13),             
      DI14        => mp_RAM0_DI(14),           
      DI15        => mp_RAM0_DI(15),            
      DI16        => mp_RAM0_DI(16),          
      DI17        => mp_RAM0_DI(17),               
      DI18        => mp_RAM0_DI(18),               
      DI19        => mp_RAM0_DI(19),              
      DI20        => mp_RAM0_DI(20),               
      DI21        => mp_RAM0_DI(21),               
      DI22        => mp_RAM0_DI(22),              
      DI23        => mp_RAM0_DI(23),                
      DI24        => mp_RAM0_DI(24),             
      DI25        => mp_RAM0_DI(25),              
      DI26        => mp_RAM0_DI(26),                
      DI27        => mp_RAM0_DI(27),               
      DI28        => mp_RAM0_DI(28),              
      DI29        => mp_RAM0_DI(29),           
      DI30        => mp_RAM0_DI(30),               
      DI31        => mp_RAM0_DI(31),            
      DI32        => mp_RAM0_DI(32),              
      DI33        => mp_RAM0_DI(33),              
      DI34        => mp_RAM0_DI(34),        
      DI35        => mp_RAM0_DI(35),            
      DI36        => mp_RAM0_DI(36),             
      DI37        => mp_RAM0_DI(37),               
      DI38        => mp_RAM0_DI(38),             
      DI39        => mp_RAM0_DI(39),           
      DI40        => mp_RAM0_DI(40),           
      DI41        => mp_RAM0_DI(41),             
      DI42        => mp_RAM0_DI(42),           
      DI43        => mp_RAM0_DI(43),            
      DI44        => mp_RAM0_DI(44),           
      DI45        => mp_RAM0_DI(45),              
      DI46        => mp_RAM0_DI(46),          
      DI47        => mp_RAM0_DI(47),            
      DI48        => mp_RAM0_DI(48),            
      DI49        => mp_RAM0_DI(49),              
      DI50        => mp_RAM0_DI(50),              
      DI51        => mp_RAM0_DI(51),             
      DI52        => mp_RAM0_DI(52),              
      DI53        => mp_RAM0_DI(53),            
      DI54        => mp_RAM0_DI(54),          
      DI55        => mp_RAM0_DI(55),               
      DI56        => mp_RAM0_DI(56),             
      DI57        => mp_RAM0_DI(57),             
      DI58        => mp_RAM0_DI(58),               
      DI59        => mp_RAM0_DI(59),           
      DI60        => mp_RAM0_DI(60),             
      DI61        => mp_RAM0_DI(61),             
      DI62        => mp_RAM0_DI(62),              
      DI63        => mp_RAM0_DI(63),            
      DI64        => mp_RAM0_DI(64),           
      DI65        => mp_RAM0_DI(65),              
      DI66        => mp_RAM0_DI(66),               
      DI67        => mp_RAM0_DI(67),           
      DI68        => mp_RAM0_DI(68),            
      DI69        => mp_RAM0_DI(69),              
      DI70        => mp_RAM0_DI(70),            
      DI71        => mp_RAM0_DI(71),            
      DI72        => mp_RAM0_DI(72),              
      DI73        => mp_RAM0_DI(73),             
      DI74        => mp_RAM0_DI(74),             
      DI75        => mp_RAM0_DI(75),              
      DI76        => mp_RAM0_DI(76),              
      DI77        => mp_RAM0_DI(77),               
      DI78        => mp_RAM0_DI(78),             
      DI79        => mp_RAM0_DI(79), 
      DI80        => mp_RAM0_DI(80),  --CJ
      DI81        => mp_RAM0_DI(81),  --CJ
      DI82        => mp_RAM0_DI(82),  --CJ
      DI83        => mp_RAM0_DI(83),  --CJ
      DI84        => mp_RAM0_DI(84),  --CJ
      DI85        => mp_RAM0_DI(85),  --CJ
      DI86        => mp_RAM0_DI(86),  --CJ
      DI87        => mp_RAM0_DI(87),  --CJ
      DI88        => mp_RAM0_DI(88),  --CJ
      DI89        => mp_RAM0_DI(89),  --CJ
      DI90        => mp_RAM0_DI(90),  --CJ
      DI91        => mp_RAM0_DI(91),  --CJ
      DI92        => mp_RAM0_DI(92),  --CJ
      DI93        => mp_RAM0_DI(93),  --CJ
      DI94        => mp_RAM0_DI(94),  --CJ
      DI95        => mp_RAM0_DI(95),  --CJ
      DI96        => mp_RAM0_DI(96),  --CJ
      DI97        => mp_RAM0_DI(97),  --CJ
      DI98        => mp_RAM0_DI(98),  --CJ
      DI99        => mp_RAM0_DI(99),  --CJ
      DI100       => mp_RAM0_DI(100), --CJ
      DI101       => mp_RAM0_DI(101), --CJ
      DI102       => mp_RAM0_DI(102), --CJ
      DI103       => mp_RAM0_DI(103), --CJ
      DI104       => mp_RAM0_DI(104), --CJ
      DI105       => mp_RAM0_DI(105), --CJ
      DI106       => mp_RAM0_DI(106), --CJ
      DI107       => mp_RAM0_DI(107), --CJ
      DI108       => mp_RAM0_DI(108), --CJ
      DI109       => mp_RAM0_DI(109), --CJ
      DI110       => mp_RAM0_DI(110), --CJ
      DI111       => mp_RAM0_DI(111), --CJ
      DI112       => mp_RAM0_DI(112), --CJ
      DI113       => mp_RAM0_DI(113), --CJ
      DI114       => mp_RAM0_DI(114), --CJ
      DI115       => mp_RAM0_DI(115), --CJ
      DI116       => mp_RAM0_DI(116), --CJ
      DI117       => mp_RAM0_DI(117), --CJ
      DI118       => mp_RAM0_DI(118), --CJ
      DI119       => mp_RAM0_DI(119), --CJ
      DI120       => mp_RAM0_DI(120), --CJ
      DI121       => mp_RAM0_DI(121), --CJ
      DI122       => mp_RAM0_DI(122), --CJ
      DI123       => mp_RAM0_DI(123), --CJ
      DI124       => mp_RAM0_DI(124), --CJ
      DI125       => mp_RAM0_DI(125), --CJ
      DI126       => mp_RAM0_DI(126), --CJ
      DI127       => mp_RAM0_DI(127), --CJ           
      WEB         => mp_RAM0_WEB,              
      CK          => clk_p,           
      CS          => mp_RAM0_CS,               
      OE          => '1'                
      );

  --mpram11: SU180_2048X80X1BM1B
  --PORT MAP (
  --    A0          => mp_RAM1_A(0),
  --    A1          => mp_RAM1_A(1),               
  --    A2          => mp_RAM1_A(2),              
  --    A3          => mp_RAM1_A(3),             
  --    A4          => mp_RAM1_A(4),             
  --    A5          => mp_RAM1_A(5),               
  --    A6          => mp_RAM1_A(6),               
  --    A7          => mp_RAM1_A(7),               
  --    A8          => mp_RAM1_A(8),               
  --    A9          => mp_RAM1_A(9),               
  --    A10         => mp_RAM1_A(10),                
  --    DO0         => mp_RAM1_DO(0),               
  --    DO1         => mp_RAM1_DO(1),               
  --    DO2         => mp_RAM1_DO(2),              
  --    DO3         => mp_RAM1_DO(3),               
  --    DO4         => mp_RAM1_DO(4),               
  --    DO5         => mp_RAM1_DO(5),               
  --    DO6         => mp_RAM1_DO(6),               
  --    DO7         => mp_RAM1_DO(7),              
  --    DO8         => mp_RAM1_DO(8),               
  --    DO9         => mp_RAM1_DO(9),               
  --    DO10        => mp_RAM1_DO(10),              
  --    DO11        => mp_RAM1_DO(11),              
  --    DO12        => mp_RAM1_DO(12),              
  --    DO13        => mp_RAM1_DO(13),               
  --    DO14        => mp_RAM1_DO(14),                
  --    DO15        => mp_RAM1_DO(15),              
  --    DO16        => mp_RAM1_DO(16),              
  --    DO17        => mp_RAM1_DO(17),                
  --    DO18        => mp_RAM1_DO(18),               
  --    DO19        => mp_RAM1_DO(19),               
  --    DO20        => mp_RAM1_DO(20),           
  --    DO21        => mp_RAM1_DO(21),               
  --    DO22        => mp_RAM1_DO(22),               
  --    DO23        => mp_RAM1_DO(23),               
  --    DO24        => mp_RAM1_DO(24),                
  --    DO25        => mp_RAM1_DO(25),               
  --    DO26        => mp_RAM1_DO(26),               
  --    DO27        => mp_RAM1_DO(27),               
  --    DO28        => mp_RAM1_DO(28),               
  --    DO29        => mp_RAM1_DO(29),               
  --    DO30        => mp_RAM1_DO(30),               
  --    DO31        => mp_RAM1_DO(31),              
  --    DO32        => mp_RAM1_DO(32),             
  --    DO33        => mp_RAM1_DO(33),             
  --    DO34        => mp_RAM1_DO(34),            
  --    DO35        => mp_RAM1_DO(35),             
  --    DO36        => mp_RAM1_DO(36),              
  --    DO37        => mp_RAM1_DO(37),               
  --    DO38        => mp_RAM1_DO(38),               
  --    DO39        => mp_RAM1_DO(39),               
  --    DO40        => mp_RAM1_DO(40),             
  --    DO41        => mp_RAM1_DO(41),              
  --    DO42        => mp_RAM1_DO(42),             
  --    DO43        => mp_RAM1_DO(43),               
  --    DO44        => mp_RAM1_DO(44),               
  --    DO45        => mp_RAM1_DO(45),              
  --    DO46        => mp_RAM1_DO(46),               
  --    DO47        => mp_RAM1_DO(47),              
  --    DO48        => mp_RAM1_DO(48),                
  --    DO49        => mp_RAM1_DO(49),             
  --    DO50        => mp_RAM1_DO(50),              
  --    DO51        => mp_RAM1_DO(51),               
  --    DO52        => mp_RAM1_DO(52),             
  --    DO53        => mp_RAM1_DO(53),           
  --    DO54        => mp_RAM1_DO(54),             
  --    DO55        => mp_RAM1_DO(55),             
  --    DO56        => mp_RAM1_DO(56),              
  --    DO57        => mp_RAM1_DO(57),             
  --    DO58        => mp_RAM1_DO(58),          
  --    DO59        => mp_RAM1_DO(59),              
  --    DO60        => mp_RAM1_DO(60),             
  --    DO61        => mp_RAM1_DO(61),           
  --    DO62        => mp_RAM1_DO(62),             
  --    DO63        => mp_RAM1_DO(63),               
  --    DO64        => mp_RAM1_DO(64),              
  --    DO65        => mp_RAM1_DO(65),             
  --    DO66        => mp_RAM1_DO(66),               
  --    DO67        => mp_RAM1_DO(67),              
  --    DO68        => mp_RAM1_DO(68),             
  --    DO69        => mp_RAM1_DO(69),            
  --    DO70        => mp_RAM1_DO(70),           
  --    DO71        => mp_RAM1_DO(71),             
  --    DO72        => mp_RAM1_DO(72),        
  --    DO73        => mp_RAM1_DO(73),              
  --    DO74        => mp_RAM1_DO(74),              
  --    DO75        => mp_RAM1_DO(75),             
  --    DO76        => mp_RAM1_DO(76),               
  --    DO77        => mp_RAM1_DO(77),          
  --    DO78        => mp_RAM1_DO(78),           
  --    DO79        => mp_RAM1_DO(79),            
  --    DI0         => mp_RAM1_DI(0),           
  --    DI1         => mp_RAM1_DI(1),             
  --    DI2         => mp_RAM1_DI(2),            
  --    DI3         => mp_RAM1_DI(3),            
  --    DI4         => mp_RAM1_DI(4),           
  --    DI5         => mp_RAM1_DI(5),            
  --    DI6         => mp_RAM1_DI(6),           
  --    DI7         => mp_RAM1_DI(7),         
  --    DI8         => mp_RAM1_DI(8),           
  --    DI9         => mp_RAM1_DI(9),           
  --    DI10        => mp_RAM1_DI(10),              
  --    DI11        => mp_RAM1_DI(11),              
  --    DI12        => mp_RAM1_DI(12),              
  --    DI13        => mp_RAM1_DI(13),             
  --    DI14        => mp_RAM1_DI(14),           
  --    DI15        => mp_RAM1_DI(15),            
  --    DI16        => mp_RAM1_DI(16),          
  --    DI17        => mp_RAM1_DI(17),               
  --    DI18        => mp_RAM1_DI(18),               
  --    DI19        => mp_RAM1_DI(19),              
  --    DI20        => mp_RAM1_DI(20),               
  --    DI21        => mp_RAM1_DI(21),               
  --    DI22        => mp_RAM1_DI(22),              
  --    DI23        => mp_RAM1_DI(23),                
  --    DI24        => mp_RAM1_DI(24),             
  --    DI25        => mp_RAM1_DI(25),              
  --    DI26        => mp_RAM1_DI(26),                
  --    DI27        => mp_RAM1_DI(27),               
  --    DI28        => mp_RAM1_DI(28),              
  --    DI29        => mp_RAM1_DI(29),           
  --    DI30        => mp_RAM1_DI(30),               
  --    DI31        => mp_RAM1_DI(31),            
  --    DI32        => mp_RAM1_DI(32),              
  --    DI33        => mp_RAM1_DI(33),              
  --    DI34        => mp_RAM1_DI(34),        
  --    DI35        => mp_RAM1_DI(35),            
  --    DI36        => mp_RAM1_DI(36),             
  --    DI37        => mp_RAM1_DI(37),               
  --    DI38        => mp_RAM1_DI(38),             
  --    DI39        => mp_RAM1_DI(39),           
  --    DI40        => mp_RAM1_DI(40),           
  --    DI41        => mp_RAM1_DI(41),             
  --    DI42        => mp_RAM1_DI(42),           
  --    DI43        => mp_RAM1_DI(43),            
  --    DI44        => mp_RAM1_DI(44),           
  --    DI45        => mp_RAM1_DI(45),              
  --    DI46        => mp_RAM1_DI(46),          
  --    DI47        => mp_RAM1_DI(47),            
  --    DI48        => mp_RAM1_DI(48),            
  --    DI49        => mp_RAM1_DI(49),              
  --    DI50        => mp_RAM1_DI(50),              
  --    DI51        => mp_RAM1_DI(51),             
  --    DI52        => mp_RAM1_DI(52),              
  --    DI53        => mp_RAM1_DI(53),            
  --    DI54        => mp_RAM1_DI(54),          
  --    DI55        => mp_RAM1_DI(55),               
  --    DI56        => mp_RAM1_DI(56),             
  --    DI57        => mp_RAM1_DI(57),             
  --    DI58        => mp_RAM1_DI(58),               
  --    DI59        => mp_RAM1_DI(59),           
  --    DI60        => mp_RAM1_DI(60),             
  --    DI61        => mp_RAM1_DI(61),             
  --    DI62        => mp_RAM1_DI(62),              
  --    DI63        => mp_RAM1_DI(63),            
  --    DI64        => mp_RAM1_DI(64),           
  --    DI65        => mp_RAM1_DI(65),              
  --    DI66        => mp_RAM1_DI(66),               
  --    DI67        => mp_RAM1_DI(67),           
  --    DI68        => mp_RAM1_DI(68),            
  --    DI69        => mp_RAM1_DI(69),              
  --    DI70        => mp_RAM1_DI(70),            
  --    DI71        => mp_RAM1_DI(71),            
  --    DI72        => mp_RAM1_DI(72),              
  --    DI73        => mp_RAM1_DI(73),             
  --    DI74        => mp_RAM1_DI(74),             
  --    DI75        => mp_RAM1_DI(75),              
  --    DI76        => mp_RAM1_DI(76),              
  --    DI77        => mp_RAM1_DI(77),               
  --    DI78        => mp_RAM1_DI(78),             
  --    DI79        => mp_RAM1_DI(79),           
  --    WEB         => mp_RAM1_WEB,              
  --    CK          => clk_p,            
  --    CS          => mp_RAM1_CS,               
  --    OE          => '1'                
  --    );



--  -- iomem0, iomem1
  --  iomem0
  iomem0: SY180_1024X8X1CM8
  PORT MAP (
      A0          => iomem_a(0),
      A1          => iomem_a(1),              
      A2          => iomem_a(2),             
      A3          => iomem_a(3),            
      A4          => iomem_a(4),            
      A5          => iomem_a(5),              
      A6          => iomem_a(6),              
      A7          => iomem_a(7),              
      A8          => iomem_a(8),              
      A9          => iomem_a(9),                             
      DO0         => iomem_q(0),              
      DO1         => iomem_q(1),              
      DO2         => iomem_q(2),             
      DO3         => iomem_q(3),              
      DO4         => iomem_q(4),              
      DO5         => iomem_q(5),              
      DO6         => iomem_q(6),              
      DO7         => iomem_q(7),                    
      DI0         => iomem_d(0),           
      DI1         => iomem_d(1),            
      DI2         => iomem_d(2),           
      DI3         => iomem_d(3),           
      DI4         => iomem_d(4),          
      DI5         => iomem_d(5),           
      DI6         => iomem_d(6),          
      DI7         => iomem_d(7),               
      WEB         => iomem_we_n,             
      CK          => clk_p,          
      CSB         => iomem_ce_n(0)                               
      ); 

  --   iomem1: 
  iomem1: SY180_1024X8X1CM8
  PORT MAP (
      A0          => iomem_a(0),
      A1          => iomem_a(1),              
      A2          => iomem_a(2),             
      A3          => iomem_a(3),            
      A4          => iomem_a(4),            
      A5          => iomem_a(5),              
      A6          => iomem_a(6),              
      A7          => iomem_a(7),              
      A8          => iomem_a(8),              
      A9          => iomem_a(9),                             
      DO0         => iomem_q(8),              
      DO1         => iomem_q(9),              
      DO2         => iomem_q(10),             
      DO3         => iomem_q(11),              
      DO4         => iomem_q(12),              
      DO5         => iomem_q(13),              
      DO6         => iomem_q(14),              
      DO7         => iomem_q(15),                    
      DI0         => iomem_d(8),         
      DI1         => iomem_d(9),            
      DI2         => iomem_d(10),           
      DI3         => iomem_d(11),           
      DI4         => iomem_d(12),           
      DI5         => iomem_d(13),           
      DI6         => iomem_d(14),        
      DI7         => iomem_d(15),               
      WEB         => iomem_we_n,            
      CK          => clk_p,           
      CSB         => iomem_ce_n(1)                               
      );

--  -- pmem
 --    mppmem
  --mppmem: SY180_2048X2X1CM8
  --PORT MAP (
  --    A0          => mp_PM_A(0),
  --    A1          => mp_PM_A(1),              
  --    A2          => mp_PM_A(2),             
  --    A3          => mp_PM_A(3),            
  --    A4          => mp_PM_A(4),            
  --    A5          => mp_PM_A(5),              
  --    A6          => mp_PM_A(6),              
  --    A7          => mp_PM_A(7),              
  --    A8          => mp_PM_A(8),              
  --    A9          => mp_PM_A(9),
  --    A10         => mp_PM_A(10),                             
  --    DO0         => mp_PM_DO(0),              
  --    DO1         => mp_PM_DO(1),                                  
  --    DI0         => mp_PM_DI(0),           
  --    DI1         => mp_PM_DI(1),                           
  --    WEB         => mp_PM_WEB,             
  --    CK          => clk_p,           
  --    CSB          => mp_PM_CSB                               
  --    );
	   
--  -- trcmem
  trcmem: SY180_256X32X1CM4
  PORT MAP (
      A0          => trcmem_a(0),
      A1          => trcmem_a(1),              
      A2          => trcmem_a(2),             
      A3          => trcmem_a(3),            
      A4          => trcmem_a(4),            
      A5          => trcmem_a(5),              
      A6          => trcmem_a(6),              
      A7          => trcmem_a(7),                                            
      DO0         => trcmem_q(0),              
      DO1         => trcmem_q(1),             
      DO2         => trcmem_q(2),             
      DO3         => trcmem_q(3),              
      DO4         => trcmem_q(4),              
      DO5         => trcmem_q(5),              
      DO6         => trcmem_q(6),              
      DO7         => trcmem_q(7),             
      DO8         => trcmem_q(8),              
      DO9         => trcmem_q(9),              
      DO10        => trcmem_q(10),            
      DO11        => trcmem_q(11),             
      DO12        => trcmem_q(12),             
      DO13        => trcmem_q(13),              
      DO14        => trcmem_q(14),               
      DO15        => trcmem_q(15),             
      DO16        => trcmem_q(16),             
      DO17        => trcmem_q(17),               
      DO18        => trcmem_q(18),             
      DO19        => trcmem_q(19),              
      DO20        => trcmem_q(20),          
      DO21        => trcmem_q(21),              
      DO22        => trcmem_q(22),              
      DO23        => trcmem_q(23),              
      DO24        => trcmem_q(24),               
      DO25        => trcmem_q(25),               
      DO26        => trcmem_q(26),               
      DO27        => trcmem_q(27),               
      DO28        => trcmem_q(28),               
      DO29        => trcmem_q(29),               
      DO30        => trcmem_q(30),               
      DO31        => trcmem_q(31),                       
      DI0         => trcmem_d(0),            
      DI1         => trcmem_d(1),             
      DI2         => trcmem_d(2),            
      DI3         => trcmem_d(3),            
      DI4         => trcmem_d(4),           
      DI5         => trcmem_d(5),            
      DI6         => trcmem_d(6),           
      DI7         => trcmem_d(7),         
      DI8         => trcmem_d(8),           
      DI9         => trcmem_d(9),           
      DI10        => trcmem_d(10),              
      DI11        => trcmem_d(11),              
      DI12        => trcmem_d(12),              
      DI13        => trcmem_d(13),             
      DI14        => trcmem_d(14),           
      DI15        => trcmem_d(15),            
      DI16        => trcmem_d(16),          
      DI17        => trcmem_d(17),               
      DI18        => trcmem_d(18),               
      DI19        => trcmem_d(19),              
      DI20        => trcmem_d(20),               
      DI21        => trcmem_d(21),               
      DI22        => trcmem_d(22),              
      DI23        => trcmem_d(23),                
      DI24        => trcmem_d(24),             
      DI25        => trcmem_d(25),              
      DI26        => trcmem_d(26),                
      DI27        => trcmem_d(27),               
      DI28        => trcmem_d(28),              
      DI29        => trcmem_d(29),           
      DI30        => trcmem_d(30),               
      DI31        => trcmem_d(31),                      
      WEB         => trcmem_we_n,              
      CK          => clk_p,            
      CSB         => trcmem_ce_n                              
      );



  --ram1: SU180_16384X8X1BM8        -- need modification flag, 2015lp
  --port MAP (
  --    A0          =>  RAM1_A(0),
  --    A1          =>  RAM1_A(1),
  --    A2          =>  RAM1_A(2),
  --    A3          =>  RAM1_A(3),
  --    A4          =>  RAM1_A(4),
  --    A5          =>  RAM1_A(5),
  --    A6          =>  RAM1_A(6),
  --    A7          =>  RAM1_A(7),
  --    A8          =>  RAM1_A(8),
  --    A9          =>  RAM1_A(9),
  --    A10         =>  RAM1_A(10),
  --    A11         =>  RAM1_A(11),
  --    A12         =>  RAM1_A(12),
  --    A13         =>  RAM1_A(13),
  --    DO0         =>  RAM1_DO(0),
  --    DO1         =>  RAM1_DO(1),
  --    DO2         =>  RAM1_DO(2),
  --    DO3         =>  RAM1_DO(3),
  --    DO4         =>  RAM1_DO(4),
  --    DO5         =>  RAM1_DO(5),
  --    DO6         =>  RAM1_DO(6),
  --    DO7         =>  RAM1_DO(7),
  --    DI0         =>  RAM1_DI(0),
  --    DI1         =>  RAM1_DI(1),
  --    DI2         =>  RAM1_DI(2),
  --    DI3         =>  RAM1_DI(3),
  --    DI4         =>  RAM1_DI(4),
  --    DI5         =>  RAM1_DI(5),
  --    DI6         =>  RAM1_DI(6),
  --    DI7         =>  RAM1_DI(7), 
  --    WEB         =>  RAM1_WEB, 
  --    CK          =>  clk_p, 
  --    CS          =>  RAM1_CS, 
  --    OE          =>  '1'   
  --    );
--
  --ram2: SU180_16384X8X1BM8        -- need modification flag, 2015lp
  --port MAP (
  --    A0          =>  RAM2_A(0),
  --    A1          =>  RAM2_A(1),
  --    A2          =>  RAM2_A(2),
  --    A3          =>  RAM2_A(3),
  --    A4          =>  RAM2_A(4),
  --    A5          =>  RAM2_A(5),
  --    A6          =>  RAM2_A(6),
  --    A7          =>  RAM2_A(7),
  --    A8          =>  RAM2_A(8),
  --    A9          =>  RAM2_A(9),
  --    A10         =>  RAM2_A(10),
  --    A11         =>  RAM2_A(11),
  --    A12         =>  RAM2_A(12),
  --    A13         =>  RAM2_A(13),
  --    DO0         =>  RAM2_DO(0),
  --    DO1         =>  RAM2_DO(1),
  --    DO2         =>  RAM2_DO(2),
  --    DO3         =>  RAM2_DO(3),
  --    DO4         =>  RAM2_DO(4),
  --    DO5         =>  RAM2_DO(5),
  --    DO6         =>  RAM2_DO(6),
  --    DO7         =>  RAM2_DO(7),
  --    DI0         =>  RAM2_DI(0),
  --    DI1         =>  RAM2_DI(1),
  --    DI2         =>  RAM2_DI(2),
  --    DI3         =>  RAM2_DI(3),
  --    DI4         =>  RAM2_DI(4),
  --    DI5         =>  RAM2_DI(5),
  --    DI6         =>  RAM2_DI(6),
  --    DI7         =>  RAM2_DI(7), 
  --    WEB         =>  RAM2_WEB, 
  --    CK          =>  clk_p, 
  --    CS          =>  RAM2_CS, 
  --    OE          =>  '1'   
  --    );
--
  --ram3: SU180_16384X8X1BM8        -- need modification flag, 2015lp
  --port MAP (
  --    A0          =>  RAM3_A(0),
  --    A1          =>  RAM3_A(1),
  --    A2          =>  RAM3_A(2),
  --    A3          =>  RAM3_A(3),
  --    A4          =>  RAM3_A(4),
  --    A5          =>  RAM3_A(5),
  --    A6          =>  RAM3_A(6),
  --    A7          =>  RAM3_A(7),
  --    A8          =>  RAM3_A(8),
  --    A9          =>  RAM3_A(9),
  --    A10         =>  RAM3_A(10),
  --    A11         =>  RAM3_A(11),
  --    A12         =>  RAM3_A(12),
  --    A13         =>  RAM3_A(13),
  --    DO0         =>  RAM3_DO(0),
  --    DO1         =>  RAM3_DO(1),
  --    DO2         =>  RAM3_DO(2),
  --    DO3         =>  RAM3_DO(3),
  --    DO4         =>  RAM3_DO(4),
  --    DO5         =>  RAM3_DO(5),
  --    DO6         =>  RAM3_DO(6),
  --    DO7         =>  RAM3_DO(7),
  --    DI0         =>  RAM3_DI(0),
  --    DI1         =>  RAM3_DI(1),
  --    DI2         =>  RAM3_DI(2),
  --    DI3         =>  RAM3_DI(3),
  --    DI4         =>  RAM3_DI(4),
  --    DI5         =>  RAM3_DI(5),
  --    DI6         =>  RAM3_DI(6),
  --    DI7         =>  RAM3_DI(7), 
  --    WEB         =>  RAM3_WEB, 
  --    CK          =>  clk_p, 
  --    CS          =>  RAM3_CS, 
  --    OE          =>  '1'   
  --    );

  --ram4: SU180_16384X8X1BM8        -- need modification flag, 2015lp
  --port MAP (
  --    A0          =>  RAM4_A(0),
  --    A1          =>  RAM4_A(1),
  --    A2          =>  RAM4_A(2),
  --    A3          =>  RAM4_A(3),
  --    A4          =>  RAM4_A(4),
  --    A5          =>  RAM4_A(5),
  --    A6          =>  RAM4_A(6),
  --    A7          =>  RAM4_A(7),
  --    A8          =>  RAM4_A(8),
  --    A9          =>  RAM4_A(9),
  --    A10         =>  RAM4_A(10),
  --    A11         =>  RAM4_A(11),
  --    A12         =>  RAM4_A(12),
  --    A13         =>  RAM4_A(13),
  --    DO0         =>  RAM4_DO(0),
  --    DO1         =>  RAM4_DO(1),
  --    DO2         =>  RAM4_DO(2),
  --    DO3         =>  RAM4_DO(3),
  --    DO4         =>  RAM4_DO(4),
  --    DO5         =>  RAM4_DO(5),
  --    DO6         =>  RAM4_DO(6),
  --    DO7         =>  RAM4_DO(7),
  --    DI0         =>  RAM4_DI(0),
  --    DI1         =>  RAM4_DI(1),
  --    DI2         =>  RAM4_DI(2),
  --    DI3         =>  RAM4_DI(3),
  --    DI4         =>  RAM4_DI(4),
  --    DI5         =>  RAM4_DI(5),
  --    DI6         =>  RAM4_DI(6),
  --    DI7         =>  RAM4_DI(7), 
  --    WEB         =>  RAM4_WEB, 
  --    CK          =>  clk_p, 
  --    CS          =>  RAM4_CS, 
  --    OE          =>  '1'   
  --    );


  -----------------------------------------------------------------------------
  -- Clock generation block
  -----------------------------------------------------------------------------
  clk_gen0: entity work.clk_gen
    port map (
      --rst_n      => rst_n,
      rst_cn     => rst_cn,
      --pllout     => pllout,
--      pllout     => tcko,   -- added by HYX, 20141115, for pll test
      --xout       => hclk_i, -- 16.7mhz clk
--      clk_mux_out => clk_mux_out,
      clk_mux_out => pllout,
      erxclk     => erxclk,
      etxclk     => etxclk,
--      en_eth     => en_eth,
      --sel_pll    => en_pll,--sel_pll,  to select ref oscillator change sel_pll to en_pll to select suitable clock by maning
      en_d       => en_d,  
      fast_d     => fast_d,
      --din_e      => din_e,
      --din_ea     => din_ea,
      din_i      => din_i, 
      din_u      => din_u, 
      din_s      => din_s,
      din_a      => din_a,
	    clk_in_off => clk_in_off,
      clk_main_off => clk_main_off ,
      hold_flash_d => hold_flash_d,
--	  en_r		=> router_clk_en,       --delete by HYX, 20141027
      clk_p      => clk_p, 
      clk_c_en   => clk_c_en,
      even_c     => even_c,
      --clk_c2_pos => clk_c2_pos,
      --clk_e_pos  => clk_e_pos,
      --clk_e_neg  => clk_e_neg,
	  --clk_c2a_pos => clk_c2a_pos,
	  --clk_ea_pos     => clk_ea_pos,
	  --clk_ea_neg     => clk_ea_neg,
      clk_i      => clk_i, 
      clk_i_pos  => clk_i_pos, 
--	  clk_i_r	=> clk_i_r,     --delete by HYX, 20141027
--	  clk_p_r	=> clk_p_r,     --delete by HYX, 20141027
      clk_d      => clk_d, 
      clk_d_pos  => clk_d_pos, 
      clk_da_pos  => clk_da_pos, 
      clk_u_pos  => clk_u_pos,
      clk_s      => clk_s, 
      clk_s_pos  => clk_s_pos,
      clk_rx     => clk_rx,
      clk_tx     => clk_tx,
      clk_a_pos  => clk_a_pos
	  );
--  clk_a <= clk_a_pos;
--  -----------------------------------------------------------------------------
--  -- Real time clock  !!! SEPARATELY POWERED !!!
--  -----------------------------------------------------------------------------
    rtc0: entity work.rtc 
     port map(
      xout      => hclk_i,
      pllout    => pllout,
      sel_pll   => sel_pll,
      xout_selected => xout_selected,
      lp_pwr_ok => lp_pwr_ok,
      rxout     => rxout,  -- 32KHz oscillator input         
      mrxout_o  => mrxout_o,  -- 32KHz oscillator output or external wake
      rst_rtc   => rst_rtc,  -- Reset RTC counter byte            
      en_fclk   => en_fclk,  -- Enable fast clocking of RTC counter byte
      fclk      => fclk,  -- Fast clock to RTC counter byte   
      ld_bmem   => ld_bmem,  -- Latch enable to the dis_bmem latch   
      rtc_sel   => rtc_sel,   -- RTC byte select
      rtc_data  => rtc_data,   -- RTC data             
      dis_bmem  => dis_bmem_int, 
      
      reset_iso_clear=> reset_iso_clear,
	  halt_en        => halt_en            ,    
      nap_en         => nap_en             ,    
      wakeup_lp      => wakeup_lp          ,    
      poweron_finish => poweron_finish     ,    
      reset_iso      => reset_iso          ,    
      reset_core_n   => reset_core_n       ,    
      io_iso         => io_iso             ,    
      nap_rec        => nap_rec            ,    
      pmic_core_en   => pmic_core_en       ,    
      pmic_io_en     => pmic_io_en         ,    
      clk_mux_out    => clk_mux_out        ,    
      
          --gmem1
      c1_gmem_a     =>  c1_gmem_a,   
      c1_gmem_q     =>  c1_gmem_q,   
      c1_gmem_d     =>  c1_gmem_d,   
      c1_gmem_we_n  =>  c1_gmem_we_n,   
      c1_gmem_ce_n  =>  c1_gmem_ce_n,   
  
      --gmem2
      c2_gmem_a     =>  c2_gmem_a,  
      c2_gmem_q     =>  c2_gmem_q,  
      c2_gmem_d     =>  c2_gmem_d,  
      c2_gmem_we_n  =>  c2_gmem_we_n,  
      c2_gmem_ce_n  =>  c2_gmem_ce_n,  

      --bmem
      dbus          =>  dbus,  
      bmem_a8       =>  bmem_a8,  
      bmem_q        =>  bmem_q,  
      bmem_d        =>  bmem_d,  
      bmem_we_n     =>  bmem_we_n,  
      bmem_ce_n     =>  bmem_ce_n,
	  --RAM0 
	  RAM0_DO       =>  RAM0_DO ,
	  RAM0_DI       =>  RAM0_DI ,
	  RAM0_A        =>  RAM0_A  ,
	  RAM0_WEB      =>  RAM0_WEB,
	  RAM0_CS       =>  RAM0_CS 
      ); 

    -- Disable power to BMEM 
--    dis_bmem <= dis_bmem_int;  
  -----------------------------------------------------------------------------
  -- core
  -----------------------------------------------------------------------------
  core1: entity work.core
    port map(
    -- Clocks to/from clock block
    clk_p         => clk_p,   --: in  std_logic;  -- PLL clock
    clk_c_en      => clk_c_en,   --: in  std_logic;  -- CP clock
    even_c        => even_c,
    --clk_c2_pos   => clk_c2_pos,  --: in  std_logic;  -- clk_c / 2 
    clk_e_pos     => clk_e_pos,   --: out  std_logic;  -- Execution clock
    clk_e_neg     => clk_e_neg,   --: out  std_logic;  -- Execution clock
    clk_i_pos     => clk_i_pos,   --: in  std_logic;  -- I/O clock
    clk_d_pos     => clk_d_pos,   --: in  std_logic;  -- DRAM clock
    clk_s_pos     => clk_s_pos,   --: in  std_logic;  -- SP clock
    -- Control outputs to the clock block
    rst_n         => rst_n,   --: out std_logic;  -- Asynchronous reset to clk_gen
    rst_cn        => rst_cn,  --: out std_logic;  -- Reset, will hold all clocks except c,rx,tx
    en_d          => en_d,    --: out std_logic;  -- Enable clk_d
    fast_d        => fast_d,  --: out std_logic;  -- clk_d speed select 
    --din_e       => din_e,   --: out std_logic;  -- D input to FF generating clk_e
    din_i         => din_i,   --: out std_logic;  -- D input to FF generating clk_i
    din_u         => din_u,   --: out std_logic;  -- D input to FF generating clk_u
    din_s         => din_s,   --: out std_logic;  -- D input to FF generating clk_s
    clk_in_off    => clk_in_off   ,
    clk_main_off  => clk_main_off ,
	  sdram_en      => sdram_en,
    --flash Control   -coreflag
    out_line      => out_line,
    hold_flash    => hold_flash,
    hold_flash_d  => hold_flash_d,
    flash_en      => flash_en,
    flash_mode    => flash_mode,
    ld_dqi_flash  => ld_dqi_flash,
    -- Control signals to/from the oscillator and PLL
    pll_frange    => pll_frange, --: out std_logic;  -- Frequency range select
    pll_n         => pll_n,    --: out std_logic_vector(5 downto 0);   -- Multiplier
    pll_m         => pll_m,    --: out std_logic_vector(2 downto 0);   -- Divider
    en_xosc       => en_xosc,  --: out std_logic;  -- Enable XOSC 
    en_pll        => en_pll,   --: out std_logic;  -- Enable PLL 
	  sel_pll       => sel_pll,  --: out std_logic;  -- Select PLL as clock source
	  test_pll      => test_pll, --: out std_logic;  -- PLL in test mode
    xout          => hclk_i,     --: in  std_logic;  -- XOSC ref. clock output -- 16.7 mhz clk
    -- Power on signal
    pwr_ok        => '1',--pwr_ok,  --: in  std_logic;  -- Power is on --change by maning to '1'
	---------------------------------------------------------------------
    -- Memory signals
    ---------------------------------------------------------------------
    -- MPROM signals
    mprom_a       => c1_mprom_a,    --: out std_logic_vector(13 downto 0);-- Address  
    mprom_ce      => c1_mprom_ce,   --: out std_logic_vector(1 downto 0); -- Chip enable(active high) 
    mprom_oe      => c1_mprom_oe,   --: out std_logic_vector(1 downto 0); --Output enable(active high)
    -- MPRAM signals
    mpram_a       => c1_mpram_a,    --: out std_logic_vector(13 downto 0);-- Address  
    mpram_d       => c1_mpram_d,    --: out std_logic_vector(79 downto 0);-- Data to memory
    mpram_ce      => c1_mpram_ce,    --: out std_logic_vector(1 downto 0); -- Chip enable(active high)
    mpram_oe      => c1_mpram_oe,   --: out std_logic_vector(1 downto 0); -- Output enable(active high)
    mpram_we_n    => c1_mpram_we_n, --: out std_logic;                    -- Write enable(active low)
    -- MPROM/MPRAM data out bus
    mp_q          => c1_mp_q,       --: in  std_logic_vector(79 downto 0);-- Data from MPROM/MPRAM
    -- GMEM signals
    gmem_a        => c1_gmem_a,  --: out std_logic_vector(9 downto 0);  
    gmem_d        => c1_gmem_d,  --: out std_logic_vector(7 downto 0);  
    gmem_q        => c1_gmem_q,  --: in  std_logic_vector(7 downto 0);
    gmem_ce_n     => c1_gmem_ce_n,--: out std_logic;                      
    gmem_we_n     => c1_gmem_we_n,--: out std_logic;                      
    -- IOMEM signals
    iomem_a       => iomem_a,    --: out std_logic_vector(9 downto 0);
    iomem_d       => iomem_d,    --: out std_logic_vector(15 downto 0);
    iomem_q       => iomem_q,    --: in  std_logic_vector(15 downto 0);
    iomem_ce_n    => iomem_ce_n, --: out std_logic_vector(1 downto 0); 
    iomem_we_n    => iomem_we_n, --: out std_logic;
    -- TRCMEM signals (Trace memory)
    trcmem_a      => trcmem_a,   --: out std_logic_vector(7 downto 0);
    trcmem_d      => trcmem_d,   --: out std_logic_vector(31 downto 0);
    trcmem_q      => trcmem_q,     --: in  std_logic_vector(31 downto 0);
    trcmem_ce_n   => trcmem_ce_n, --: out std_logic; 
    trcmem_we_n   => trcmem_we_n, --: out std_logic;
    -- PMEM signals (Patch memory)
    pmem_a        => c1_pmem_a,   --: out std_logic_vector(10 downto 0);
    pmem_d        => c1_pmem_d,   --: out std_logic_vector(1  downto 0);
    pmem_q        => c1_pmem_q,   --: in  std_logic_vector(1  downto 0);
    pmem_ce_n     => c1_pmem_ce_n,--: out std_logic;  
    pmem_we_n     => c1_pmem_we_n,
    
    c2_core2_en   => c2_core2_en   ,
    c2_rsc_n      => c2_rsc_n,
    c2_clkreq_gen => c2_clkreq_gen,
    --c2_even_c     => c2_even_c,
    c2_crb_sel    => c2_crb_sel    ,
    c2_crb_out    => c2_crb_out    ,
    c2_en_pmem    => c2_en_pmem    ,
    c2_en_wdog    => c2_en_wdog    ,
    c2_pup_clk    => c2_pup_clk    ,
    c2_pup_irq    => c2_pup_irq    ,
    c2_r_size     => c2_r_size     ,
    c2_c_size     => c2_c_size     ,
    c2_t_ras      => c2_t_ras      ,
    c2_t_rcd      => c2_t_rcd      ,
    c2_t_rp       => c2_t_rp       ,
--    c2_en_mexec   => c2_en_mexec   ,
    short_cycle   => short_cycle,
    -- BMEM block signals
    bmem_a8       => bmem_a8,  --: out  std_logic;
    bmem_q        => bmem_q,   --: in   std_logic_vector(7 downto 0);
    bmem_d        => bmem_d,   --: out  std_logic_vector(7 downto 0);
    bmem_ce_n     => bmem_ce_n,--: out  std_logic;
	  bmem_we_n     => bmem_we_n,
--	  ram_partition => ram_partition,
--	router_ir_en  => router_ir_en ,     --delete by HYX, 20141027
--	north_en	    => north_en	 ,         --delete by HYX, 20141027
--	south_en	    => south_en	 ,         --delete by HYX, 20141027
--	west_en	 	    => west_en	 	 ,       --delete by HYX, 20141027
--	east_en	 	    => east_en	 	 ,       --delete by HYX, 20141027
--	router_clk_en => router_clk_en,  --delete by HYX, 20141027
    -- RTC block signals
    exe => exe_i,         --CJ
    ddi_vld => ddi_vld_c1, --CJ
    reset_core_n   => reset_core_n   ,
    reset_iso      => reset_iso      ,
	reset_iso_clear=> reset_iso_clear,
    poweron_finish => poweron_finish ,
    nap_rec        => nap_rec        ,
    halt_en        => halt_en        ,
    nap_en         => nap_en         ,
    rst_rtc       => rst_rtc,  --: out std_logic;  -- Reset RTC counter byte
    en_fclk       => en_fclk,  --: out std_logic;  -- Enable fast clocking of RTC counter byte
    fclk          => fclk,     --: out std_logic;  -- Fast clock to RTC counter byte
    ld_bmem       => ld_bmem,  --: out std_logic;  -- Latch enable to the en_bmem latch
    rtc_sel       => rtc_sel,  --: out std_logic_vector(2 downto 0);   -- RTC byte select
    rtc_data      => rtc_data, --: in  std_logic_vector(7 downto 0);   -- RTC data
    --  Signals to/from Peripheral block
    dfp           => dfp,     --: in  std_logic_vector(7 downto 0); 
    dbus          => dbus,    --: out std_logic_vector(7 downto 0);
    rst_en        => rst_en,  --: out std_logic;
    --rst_en2     => rst_en2, --: out std_logic;
    pd            => pd_s,      --: out std_logic_vector(2 downto 0);  -- pl_pd
    aaddr         => aaddr,   --: out std_logic_vector(4 downto 0);  -- pl_aaddr
    idreq         => idreq,   --: in  std_logic_vector(7 downto 0);
    idi           => idi,     --: in  std_logic_vector(7 downto 0);     
    idack         => idack,   --: out std_logic_vector(7 downto 0);                   
    ios_iden      => ios_iden,--: out std_logic;                   
    ios_ido       => ios_ido, --: out std_logic_vector(7 downto 0);                  
    ilioa         => ilioa,   --: out std_logic;                   
    ildout        => ildout,  --: out std_logic;                   
    inext         => inext,   --: out std_logic;
    iden          => iden,    --: in  std_logic;
    dqm_size      => dqm_size,--: out std_logic_vector(1 downto 0);
    adc_dac       => adc_dac, --: out std_logic;
    en_uart1      => en_uart1,--: out std_logic;
    en_uart2      => en_uart2,--: out std_logic;
    en_uart3      => en_uart3,--: out std_logic;
    en_eth        => en_eth,  --: out std_logic_vector(1 downto 0);
    en_tiu        => en_tiu,  --: out std_logic;
    run_tiu       => run_tiu, --: out std_logic;
    en_tstamp     => en_tstamp,--: out std_logic_vector(1 downto 0);
    en_iobus      => en_iobus,--: out std_logic_vector(1 downto 0);
    ddqm          => ddqm,    --: out std_logic_vector(7  downto 0);   
    irq0          => irq0,    --: in  std_logic;  -- Interrupt request 0   
    irq1          => irq1,    --: in  std_logic;  -- Interrupt request 1   
    adc_ref2v  	  => open, --: out	std_logic;	-- Select 2V internal ADC reference (1V)
---------------------------------------------------------------------
    -- PADS
---------------------------------------------------------------------
    -- Misc. signals
    --mpordis_i     => '1',--MPORDIS, --: in  std_logic;  -- 'power on' from pad
    mreset_i      => mreset_i, --: in  std_logic;  -- Asynchronous reset input 
    mirqout_o     => mirqout_o, --: out std_logic;  -- Interrupt  request output 
    mckout1_o     => mckout1_o, --: out std_logic;  -- Programmable clock out
    mckout1_o_en  => mckout1_o_en, 
    msdin_i       => msdin_i, --: in  std_logic;  -- Serial data in (debug) 
    msdout_o      => msdout_o, --: out std_logic;  -- Serial data out
    mrstout_o     => mrstout_o, --: out std_logic;  -- Reset out
    mxout_o       => mxout_o, --: out std_logic;  -- Oscillator test output
    mexec_o       => mexec_o, --: out std_logic;  -- clk_e test output
    mtest_i       => mtest_i,--: in  std_logic;  -- Test mode---
    mbypass_i     => mbypass_i,--: in  std_logic;  -- bypass PLL
    mwake_i       => '0',--: in  std_logic;  -- wake up
    -- DRAM signals
	  en_pmem2      => en_pmem2,
    d_addr        => c1_d_addr,--to internal sram block
    dcs_o         => c1_d_cs,  --: out std_logic;  -- Chip select
    dras_o        => c1_d_ras, --: out std_logic;  -- Row address strobe
    dcas_o        => c1_d_cas, --: out std_logic;  -- Column address strobe
    dwe_o         => c1_d_we,  --: out std_logic;  -- Write enable
    ddq_i         => c1_d_dqo,  --: in  std_logic_vector(7 downto 0); -- Data input bus  --in std_logic_vector(127 downto 0);
    ddq_o         => c1_d_dqi,  --: out std_logic_vector(7 downto 0); -- Data output bus --out std_logic_vector(31 downto 0);
    ddq_en        => ddq_en, --: out std_logic;  -- Data output bus enable
    da_o          => da_o,   --: out std_logic_vector(13 downto 0);  -- Address
    dba_o         => dba_o,  --: out std_logic_vector(1 downto 0); -- Bank address
    dcke_o        => dcke_o, --: out std_logic_vector(3 downto 0); -- Clock enable
    -- Port A
    pa_i          => pa_i(4 downto 0), --: in  std_logic_vector(4 downto 0);
	--pl_out			  => pl_out,
		-- I/O cell configuration control outputs
    d_hi          => d_hi           ,   --: out std_logic; -- High drive on DRAM interface
    d_sr          => d_sr           ,   --: out std_logic; -- Slew rate limit on DRAM interface
    d_lo          => d_lo           ,   --: out std_logic; -- Low drive on DRAM interface
    p1_hi         => p1_hi          ,   --: out std_logic; -- High drive on port group 1 pins
    p1_sr         => p1_sr          ,   --: out std_logic; -- Slew rate limit on port group 1 pins
    p2_hi         => p2_hi          ,   --: out std_logic; -- High drive on port group 2 pins
    p2_sr         => p2_sr          ,   --: out std_logic; -- Slew rate limit on port group 2 pins
    p3_hi         => p3_hi          ,   --: out std_logic; -- High drive on port group 3 pins
    p3_sr         => p3_sr             --: out std_logic; -- Slew rate limit on port group 3 pins
    -- pc_hi      => pc_hi          ,   --: out std_logic;  -- High drive on port C pins
    -- pc_lo_n    => pc_lo_n        ,   --: out std_logic;  -- Not low drive port C pins
    -- ph_hi      => ph_hi          ,   --: out std_logic;  -- High drive on port H pins
    -- ph_lo_n    => ph_lo_n        ,   --: out std_logic;  -- Not low drive port H pins
    -- pi_hi      => pi_hi          ,   --: out std_logic;  -- High drive on port I pins
    -- pi_lo_n    => pi_lo_n        ,   --: out std_logic;  -- Not low drive port I pins
    -- pel_hi     => pel_hi         ,   --: out std_logic;  -- High drive on low half of port E pins
    -- peh_hi     => peh_hi         ,   --: out std_logic;  -- High drive on high half of port E pins
    -- pdll_hi    => pdll_hi        ,   --: out std_logic;  -- High drive low dibit, low half of port D
    -- pdlh_hi    => pdlh_hi        ,   --: out std_logic;  -- High drive high dibit, low half of port D
    -- pdh_hi     => pdh_hi         ,   --: out std_logic;  -- High drive on high half of port D pins
    -- pf_hi      => pf_hi          ,   --: out std_logic;  -- High drive on port F pins
    -- pg_hi      => pg_hi             --: out std_logic  -- High drive on port G pins
    ); 
  core2 : entity work.acore 
  port map(
---------------------------------------------------------------------
    -- Signals to/from other blocks
---------------------------------------------------------------------
    -- Clocks to/from clock block
    clk_p         => clk_p  ,      
    clk_c_en      => clk_c_en  ,
    even_c        => even_c,     
    --clk_c2_pos  => clk_c2a_pos,
    clk_e_pos     => clk_ea_pos,
    --clk_e_neg   => clk_ea_neg,
	  clk_d_pos		  => clk_da_pos,    -- Control outputs to the clock block
    --rst_n       : out std_logic;  -- Asynchronous reset to clk_gen
    --rst_cn      : out std_logic;  -- Reset, will hold all clocks except c,rx,tx
    --din_e       => din_ea,  -- D input to FF generating clk_e
    -- signals from the master core
    rst_cn        => c2_core2_en,       --reset core2 if disabled
    rsc_n         => c2_rsc_n,
    clkreq_gen    => '0',
    core2_en      => c2_core2_en     ,
    crb_out       => c2_crb_out      ,
    en_pmem       => c2_en_pmem      ,
    en_wdog       => c2_en_wdog      ,
    pup_clk       => c2_pup_clk      ,
    pup_irq    	  => c2_pup_irq    	,
    r_size     	  => c2_r_size     	,
    c_size     	  => c2_c_size     	,
    t_ras      	  => c2_t_ras      	,
    t_rcd      	  => c2_t_rcd      	,
    t_rp       	  => c2_t_rp       	,
--    en_mexec   	  => c2_en_mexec   	,
    dqm_size      => dqm_size     ,
    fast_d        => fast_d       ,
    short_cycle   => short_cycle,
    
    crb_sel       => c2_crb_sel,
    --  Signals to/from Peripheral block
    dfp           => dfp          , 
    --dbus        : out std_logic_vector(7 downto 0);
    --rst_en      : out std_logic;
    --pd          : out std_logic_vector(2 downto 0);  -- pl_pd
    --aaddr       : out std_logic_vector(4 downto 0);  -- pl_aaddr
    ddqm          => open,   
    irq0          => '1',  -- Interrupt request 0   
    irq1          => '1',  -- Interrupt request 1   
---------------------------------------------------------------------
    -- Memory signals
---------------------------------------------------------------------
    -- MPROM signals
    mprom_a       => c2_mprom_a    ,
    mprom_ce      => c2_mprom_ce   ,
    mprom_oe      => c2_mprom_oe   ,
    -- MPRAM signals
    mpram_a       => c2_mpram_a    ,-- Address  
    mpram_d       => c2_mpram_d    ,-- Data to memory
    mpram_ce      => c2_mpram_ce   ,-- Chip enable(active high)
    mpram_oe      => c2_mpram_oe   ,-- Output enable(active high)
    mpram_we_n    => c2_mpram_we_n ,-- Write enable(active low)
    -- MPROM/MPRAM data out bus
    mp_q          => c2_mp_q      ,-- Data from MPROM/MPRAM
    -- GMEM signals
    gmem_a        => c2_gmem_a      ,  
    gmem_d        => c2_gmem_d      ,  
    gmem_q        => c2_gmem_q      ,
    gmem_ce_n     => c2_gmem_ce_n   ,   
    gmem_we_n     => c2_gmem_we_n   ,   
    -- PMEM signals (Patch memory)
    pmem_a        => c2_pmem_a      ,
    pmem_d        => c2_pmem_d      ,
    pmem_q        => c2_pmem_q      ,
    pmem_ce_n     => c2_pmem_ce_n   ,  
    pmem_we_n     => c2_pmem_we_n   ,
    exe          => exe ,     --CJ
     ddi_vld      =>ddi_vld_c2, --CJ 
---------------------------------------------------------------------
    -- PADS
---------------------------------------------------------------------
    -- DRAM signals     
    d_addr        => c2_d_addr,
    dcs_o         => c2_d_cs,
    dras_o        => c2_d_ras,
    dcas_o        => c2_d_cas,
    dwe_o         => c2_d_we,
    ddq_i         => c2_d_dqo,   --in std_logic_vector(127 downto 0)-- Data input bus
    ddq_o         => c2_d_dqi,   -- out std_logic_vector(31 downto 0); -- Data output bus
    ddq_en        => open,
    da_o          => open,
    dba_o         => open,
    dcke_o        => open -- Clock enable

    );  


    
    mpmem_inf_inst : entity work.mpmem_inf
  PORT map(
       
      -- MPROM signals
    -- clk_p    => clk_p,
    -- rst_cn   => rst_cn,
    -- clk_e_pos  => clk_e_pos,
    -- clk_ea_pos   => clk_ea_pos,
        c1_mprom_a     => c1_mprom_a     ,-- Address  
        c1_mprom_ce    => c1_mprom_ce    ,-- Chip enable(active high) 
        c1_mprom_oe    => c1_mprom_oe    ,--Output enable(active high)
        -- MPRAM signals
        c1_mpram_a     => c1_mpram_a     ,-- Address  
        c1_mpram_d     => c1_mpram_d     ,-- Data to memory
        c1_mpram_ce    => c1_mpram_ce    ,-- Chip enable(active high)
        c1_mpram_oe    => c1_mpram_oe    ,-- Output enable(active high)
        c1_mpram_we_n  => c1_mpram_we_n  ,-- Write enable(active low)
        -- PMEM signals (Patch memory)
        c1_pmem_a      => c1_pmem_a      ,
        c1_pmem_d      => c1_pmem_d      ,
        c1_pmem_q      => c1_pmem_q      ,
        c1_pmem_ce_n   => c1_pmem_ce_n   ,
        c1_pmem_we_n   => c1_pmem_we_n   ,
                     
        c1_mp_q        => c1_mp_q        ,
        -- MPROM signals
        c2_mprom_a     => c2_mprom_a     ,-- Address  
        c2_mprom_ce    => c2_mprom_ce    ,-- Chip enable(active high) 
        c2_mprom_oe    => c2_mprom_oe    ,--Output enable(active high)
        -- MPRAM signals
        c2_mpram_a     => c2_mpram_a     ,-- Address  
        c2_mpram_d     => c2_mpram_d     ,-- Data to memory
        c2_mpram_ce    => c2_mpram_ce    ,-- Chip enable(active high)
        c2_mpram_oe    => c2_mpram_oe    ,-- Output enable(active high)
        c2_mpram_we_n  => c2_mpram_we_n  ,-- Write enable(active low)
        -- PMEM signals (Patch memory)
        c2_pmem_a      => c2_pmem_a      ,
        c2_pmem_d      => c2_pmem_d      ,
        c2_pmem_q      => c2_pmem_q      ,
        c2_pmem_ce_n   => c2_pmem_ce_n   ,
        c2_pmem_we_n   => c2_pmem_we_n   ,
                       
        c2_mp_q        => c2_mp_q        ,
        --memory interface
        --ROM0
        ROM0_DO     => mp_ROM0_DO     ,-- in  std_logic_vector (79 downto 0); 
        ROM0_A      => mp_ROM0_A      ,-- out std_logic_vector (13 downto 0);
        ROM0_CS     => mp_ROM0_CS     ,-- out std_logic;
        ROM0_OE     => mp_ROM0_OE     ,-- out std_logic; 
        --ROM1
        ROM1_DO     => mp_ROM1_DO     ,--: in  std_logic_vector (79 downto 0); 
        ROM1_A      => mp_ROM1_A      ,--: out std_logic_vector (13 downto 0);
        ROM1_CS     => mp_ROM1_CS     ,--: out std_logic;
        ROM1_OE     => mp_ROM1_OE     ,--: out std_logic;
        --patch memory
        PM_DO       => mp_PM_DO      ,--: in  std_logic_vector (1 downto 0);
        PM_DI       => mp_PM_DI      ,--: out std_logic_vector (1 downto 0);
        PM_A        => mp_PM_A       ,--: out std_logic_vector (10 downto 0);
        PM_WEB      => mp_PM_WEB     ,--: out std_logic;
        PM_CSB      => mp_PM_CSB     ,--: out std_logic;
        --RAM0
        RAM0_DO     => mp_RAM0_DO     ,--: in  std_logic_vector (79 downto 0);
        RAM0_DI     => mp_RAM0_DI     ,--: out std_logic_vector (79 downto 0);
        RAM0_A      => mp_RAM0_A      ,--: out std_logic_vector (13 downto 0);
        RAM0_WEB    => mp_RAM0_WEB    ,--: out std_logic;
        RAM0_OE     => mp_RAM0_OE     ,
        RAM0_CS     => mp_RAM0_CS     , --: out std_logic;
        ----RAM1                          -- not included in the low-power version, deleted 2015-6-22, by HYX
        RAM1_DO     => mp_RAM1_DO     ,--: in  std_logic_vector (79 downto 0);
        RAM1_DI     => mp_RAM1_DI     ,--: out std_logic_vector (79 downto 0);
        RAM1_A      => mp_RAM1_A      ,--: out std_logic_vector (13 downto 0);
        RAM1_WEB    => mp_RAM1_WEB    ,--: out std_logic;
        RAM1_CS     => mp_RAM1_CS    --: out std_logic
    );


  --sdram_inf_inst : entity work.sdram_inf
	--PORT map(  
	--      clk_p       => clk_p       ,
	--      clk_d_pos   => clk_d_pos   ,
	--      clk_da_pos   => clk_da_pos   ,
	--      rst_n       => rst_n       ,
	--	    short_cycle => short_cycle ,
	--	    fast_d    => fast_d,
	--	-----core1 sdram interface
	--      c1_d_addr   => c1_d_addr   ,
	--	    c1_d_cs     => c1_d_cs     ,
  --      c1_d_ras    => c1_d_ras    ,
  --      c1_d_cas    => c1_d_cas    ,
  --      c1_d_we     => c1_d_we     ,
  --      c1_d_dqi    => c1_d_dqi    ,
  --      c1_d_dqi_sd => c1_d_dqi_sd ,
  --      c1_d_dqo    => c1_d_dqo    ,
  --      -----core2 sdram interface
	--      c2_d_addr   => c2_d_addr   ,
	--	    c2_d_cs     => c2_d_cs     ,
  --      c2_d_ras    => c2_d_ras    ,
  --      c2_d_cas    => c2_d_cas    ,
  --      c2_d_we     => c2_d_we     ,
  --      c2_d_dqi    => c2_d_dqi    ,
  --      c2_d_dqo    => c2_d_dqo    ,
  --      --memory interface
  --      --ROM0
  --      f_addr_in   => f_addr_in   ,
  --      f_rd_in     => f_rd_in     ,
  --      f_wr_in     => f_wr_in     ,
  --      f_data_in   => f_data_in   ,
  --      f_data_out  => f_data_out  ,
  --      --SRAM interface
  --      --RAM0 
  --      RAM0_DO       => RAM0_DO         ,
  --      RAM0_DI       => RAM0_DI         ,
  --      RAM0_A        => RAM0_A          ,
  --      RAM0_WEB      => RAM0_WEB        ,
  --      RAM0_CS       => RAM0_CS        ,
  --      --RAM1        => --RAM1          ,
  --      RAM1_DO       => RAM1_DO         ,
  --      RAM1_DI       => RAM1_DI         ,
  --      RAM1_A        => RAM1_A          ,
  --      RAM1_WEB      => RAM1_WEB        ,
  --      RAM1_CS       => RAM1_CS        ,
  --      --RAM2        => --RAM2          ,
  --      RAM2_DO       => RAM2_DO         ,
  --      RAM2_DI       => RAM2_DI         ,
  --      RAM2_A        => RAM2_A          ,
  --      RAM2_WEB      => RAM2_WEB        ,
  --      RAM2_CS       => RAM2_CS        ,
  --      --RAM3        => --RAM3          ,
  --      RAM3_DO       => RAM3_DO         ,
  --      RAM3_DI       => RAM3_DI         ,
  --      RAM3_A        => RAM3_A          ,
  --      RAM3_WEB      => RAM3_WEB        ,
  --      RAM3_CS       => RAM3_CS        ,
  --      --RAM4        => --RAM4          --,
  --      RAM4_DO       => RAM4_DO         ,
  --      RAM4_DI       => RAM4_DI         ,
  --      RAM4_A        => RAM4_A          ,
  --      RAM4_WEB      => RAM4_WEB        ,
  --      RAM4_CS       => RAM4_CS         
	--	);

  --flash interface
  flash_inf_inst : entity work.flash_inf 
	PORT MAP( 
	    clk_p       => clk_p       ,
		even_c		=> even_c		,
	    rst_cn      => rst_n      ,
	    
	    flash_en    => flash_en    ,
	    flash_mode  => flash_mode  ,
	    out_line    => out_line    ,
	    hold_flash  => hold_flash  ,
	    hold_flash_d => hold_flash_d,
	    
	    addr_in     => f_addr_in   ,
        rd_in       => f_rd_in     ,
        wr_in       => f_wr_in     ,
        data_in     => f_data_in   ,
        data_out    => f_data_out  ,
		ld_dqi_flash => ld_dqi_flash,
        
        CE          => f_CE          ,
        ADDR        => f_ADDR        ,
        WRONLY      => f_WRONLY      ,
        PERASE      => f_PERASE      ,
        SERASE      => f_SERASE      ,
        MERASE      => f_MERASE      ,
        PROG        => f_PROG        ,
        INF         => f_INF         ,
        POR         => f_POR         ,
        SAVEN       => f_SAVEN       ,
        TM          => f_TM          ,
        DATA_WR     => f_DATA_WR     ,    
        f0_ALE      => f0_ALE      ,
        --f0_PVPP   => --f0_PVPP   ,
        f0_DATA_IN  => f0_DATA_IN  ,       
        f0_RBB      => f0_RBB      ,
        f1_ALE      => f1_ALE      ,
        --f1_PVPP   => --f1_PVPP   ,
        f1_DATA_IN  => f1_DATA_IN  ,       
        f1_RBB      => f1_RBB      ,
        f2_ALE      => f2_ALE      ,
        --f2_PVPP   => --f2_PVPP   ,
        f2_DATA_IN  => f2_DATA_IN  ,       
        f2_RBB      => f2_RBB      ,
        f3_ALE      => f3_ALE      ,
        --f3_PVPP   => --f3_PVPP   ,
        f3_DATA_IN  => f3_DATA_IN  ,       
        f3_RBB      => f3_RBB      --,
--        f4_ALE      => f4_ALE      ,
--        --f4_PVPP   => --f4_PVPP   ,
--        f4_DATA_IN  => f4_DATA_IN  ,       
--        f4_RBB      => f4_RBB      ,
--        f5_ALE      => f5_ALE      ,
--        --f5_PVPP   => --f5_PVPP   ,
--        f5_DATA_IN  => f5_DATA_IN  ,       
--        f5_RBB      => f5_RBB      ,
--        f6_ALE      => f6_ALE      ,
--        --f6_PVPP   => --f6_PVPP   ,
--        f6_DATA_IN  => f6_DATA_IN  ,       
--        f6_RBB      => f6_RBB      ,
--        f7_ALE      => f7_ALE      ,
--        --f7_PVPP   => --f7_PVPP   ,
--        f7_DATA_IN  => f7_DATA_IN  ,       
--        f7_RBB      => f7_RBB      

		);		


  -----------------------------------------------------------------------------
  -- Peripherals
  -----------------------------------------------------------------------------

	erxclk <= '0';
	etxclk <= '0';
	din_a <= '0';
	dfp <= "00000000";
	iden <= '0';
	idreq <= "11111111";
	idi <= "00000000";
	irq0 <= '1';
	irq1 <= '1';
	pa_en <= "00000000";
	pb_en <= "00000000";
	pc_en <= "00000000";
	pd_en <= "00000000";
	pe_en <= "00000000";
	pf_en <= "00000000";
	pg_en <= "00000000";
	ph_en <= "00000000";
	pi_en <= "00000000";
	pj_en <= "00000000";

  

end struct;
