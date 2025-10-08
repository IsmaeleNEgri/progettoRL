-- ripple_adder3.vhd
library IEEE;
use IEEE.std_logic_1164.all;

entity rippleCarryAdder is
  port (
    A    : in  std_logic_vector(2 downto 0);
    B    : in  std_logic_vector(2 downto 0);
    Cin  : in  std_logic;
    --ras stand for ripple adder sum
    ras  : out std_logic_vector(2 downto 0);
    Cout : out std_logic
  );
end entity rippleCarryAdder;

architecture rtl of rippleCarryAdder is
  --mc stand for middle carry. I call it like that, because it is easier to understand (at least to me)
  signal mc0, mc1 : std_logic;
begin
  fa0: entity work.fullAdder port map(a => A(0), b => B(0), cin => Cin, sum => ras(0), cout => mc0);
  fa1: entity work.fullAdder port map(a => A(1), b => B(1), cin => mc0,  sum => ras(1), cout => mc1);
  fa2: entity work.fullAdder port map(a => A(2), b => B(2), cin => mc1,  sum => ras(2), cout => Cout);
end architecture rtl;
