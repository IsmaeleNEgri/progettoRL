library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity do_push_pop_calc is
    port(
        rst : in std_logic;
        a : in std_logic;
        b : in std_logic;
        c : out std_logic
    );
end do_push_pop_calc;

architecture Behavioral of do_push_pop_calc is
begin
    c <= '0' when rst='1' else
               '1' when a='1' and b='0'
               else '0';
end Behavioral;