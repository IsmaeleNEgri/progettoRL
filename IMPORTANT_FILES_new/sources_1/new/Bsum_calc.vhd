library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Bsum_calc is
    generic(STACK_PTR_DEPTH : integer := 3);
    port(
        do_push : in std_logic;
        do_pop  : in std_logic;
        B_sum   : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0)
    );
end Bsum_calc;

architecture Behavioral of Bsum_calc is
begin
    B_sum <= "001" when do_push = '1' else
             "111" when do_pop  = '1' else
             (others => '0');
end Behavioral;