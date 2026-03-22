library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity do_pop_calc is
    port(
        rst : in std_logic;
        pop_to_conf : in std_logic;
        isEmptyBuffer : in std_logic;
        do_pop : out std_logic
    );
end do_pop_calc;

architecture Behavioral of do_pop_calc is
begin
    do_pop <= '0' when rst='1' else
              '1' when pop_to_conf='1' and isEmptyBuffer='0'
              else '0';
end Behavioral;