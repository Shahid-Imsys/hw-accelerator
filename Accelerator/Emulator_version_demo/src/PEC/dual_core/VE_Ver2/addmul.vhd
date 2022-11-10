--adder and multiplier
--this block does add/sub and multiplication.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vetypes.all;

entity addmul is
  port(
    clk                    : in  std_logic;
    enable_add             : in  std_logic;
    enable_mul             : in  std_logic;
    inl0, inl1, inr0, inr1 : in  std_logic_vector(7 downto 0);
    ctrl                   : in  addmul_ctrl;
    am_res                 : out signed(17 downto 0)
    );
end entity addmul;

architecture first of addmul is
  signal addl0, addl1, addr0, addr1         : signed(8 downto 0);  -- Adder inputs (signed/zero extended)
  signal addl0in, addl1in, addr0in, addr1in : signed(9 downto 0);  -- Adder inputs (possibly inverted, carry in)
  signal addlout, addrout                   : signed(9 downto 0);  -- Adder result with crap bit
  signal addl, addr                         : signed(8 downto 0);  -- Registered adder result
  signal mulres                             : signed(17 downto 0);  -- Registered multiplier result
  signal mulen                              : enable_t;  -- Delayed control signals
begin

-- Signed/unsigned

  addl0 <= resize(signed(inl0), 9) when ctrl.signl0 = s else signed(resize(unsigned(inl0), 9));
  addl1 <= resize(signed(inl1), 9) when ctrl.signl1 = s else signed(resize(unsigned(inl1), 9));
  addr0 <= resize(signed(inr0), 9) when ctrl.signr0 = s else signed(resize(unsigned(inr0), 9));
  addr1 <= resize(signed(inr1), 9) when ctrl.signr1 = s else signed(resize(unsigned(inr1), 9));

-- Add/sub

  addl0in <= addl0 & '1';
  addl1in <= not(addl1) & '1' when ctrl.addsubl = sub else addl1 & '0';
  addr0in <= addr0 & '1';
  addr1in <= not(addr1) & '1' when ctrl.addsubr = sub else addr1 & '0';

-- Additions
  addlout <= addl0in + addl1in;
  addrout <= addr0in + addr1in;


-- Adder registers
  process(clk)
  begin
    if rising_edge(clk) then
      if enable_add = '1' then
        if ctrl.en_addmul = enable then
          addl <= addlout(9 downto 1);
          addr <= addrout(9 downto 1);
        end if;

        --  Delay control signals
        mulen <= ctrl.en_addmul;
      end if;
    end if;
  end process;

-- Multiplier registers
  process(clk)
  begin
    if rising_edge(clk) then
      if enable_mul = '1' then
        if mulen = enable then
          mulres <= addl * addr;
        end if;

        ----  Delay control signals
        --mulen <= ctrl.en_addmul;
      end if;
    end if;
  end process;

  am_res <= mulres;
end architecture;
