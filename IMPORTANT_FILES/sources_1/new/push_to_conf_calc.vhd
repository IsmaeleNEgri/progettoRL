library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity push_to_conf_calc is
    port(
        push : in std_logic;
        pop  : in std_logic;
        half_ok : in std_logic;
        push_to_conf : out std_logic
    );
end push_to_conf_calc;

architecture Behavioral of push_to_conf_calc is
begin
    push_to_conf <= '1' when push='1' and ((pop='1' and half_ok='1') or pop='0')
                    else '0';
end Behavioral;