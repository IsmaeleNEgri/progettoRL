library IEEE;
use IEEE.std_logic_1164.all;

entity rippleCarryAdder is
  generic (
      STACK_PTR_DEPTHR : integer := 3
  );
  port (
    A    : in  std_logic_vector(STACK_PTR_DEPTHR-1 downto 0);
    B    : in  std_logic_vector(STACK_PTR_DEPTHR-1 downto 0);
    Cin  : in  std_logic;
    --ras stand for ripple adder sum
    ras  : out std_logic_vector(STACK_PTR_DEPTHR-1 downto 0);
    Cout : out std_logic
  );
end entity rippleCarryAdder;

architecture rtl of rippleCarryAdder is
  --mc stand for middle carry. I call it like that, because it is easier to understand (at least to me)
  signal carry : std_logic_vector(STACK_PTR_DEPTHR downto 0);
begin
  carry(0) <= Cin;

  gen_adders: for i in 0 to STACK_PTR_DEPTHR-1 generate
    fa: entity work.fullAdder
      port map (
        a    => A(i),
        b    => B(i),
        cin  => carry(i),
        sum  => ras(i),
        cout => carry(i+1)
      );
  end generate;

  Cout <= carry(STACK_PTR_DEPTHR);

  end architecture rtl;
