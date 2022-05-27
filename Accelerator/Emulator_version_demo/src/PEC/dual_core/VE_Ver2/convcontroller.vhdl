

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.instructiontypes.all;
use work.vetypes.all;

entity convcontroller is 
  generic();
  port(
    clk          : in std_logic;
    start        : in std_logic;
    data_addr    : out std_logic_vector(7 downto 0);
    weight_addr  : out std_logic_vector(7 downto 0);
    bias_addr    : out std_logic_vector(7 downto 0);
    data_rd_en   : out std_logic;
    data_wr_en   : out std_logic;
    weight_rd_en : out std_logic;
    weight_wr_en : out std_logic;
    memreg_c     : out memreg_ctrl;
    writebuff_c  : out memreg_ctrl;
    done         : out std_logic
  );
end entity;

architecture convctrl of convcontroller is
begin
end architecture; 