library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pop_to_conf_calc is
    port(
        push : in std_logic;
        pop  : in std_logic;
        half_ok : in std_logic;
        pop_to_conf : out std_logic
    );
end pop_to_conf_calc;

architecture Behavioral of pop_to_conf_calc is
begin
    pop_to_conf <= '1' when pop='1' and ((push='1' and half_ok='0') or push='0')
                   else '0';
end Behavioral;