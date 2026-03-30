library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity push_pop_to_conf_calc is
    port(
        a : in std_logic;
        b : in std_logic;
        half_ok : in std_logic;
        c : out std_logic
    );
end push_pop_to_conf_calc;

architecture Behavioral of push_pop_to_conf_calc is
begin
    c <= '1' when a='1' and ((b='1' and half_ok='1') or b='0')
                    else '0';
end Behavioral;