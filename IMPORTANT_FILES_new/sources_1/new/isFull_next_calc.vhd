library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity isFull_next_calc is
    Port(
        clear : in std_logic;
        rst : in std_logic;
        isFullBuffer : buffer std_logic;
        do_push : in std_logic;
        do_pop : in std_logic;
        Cout : in std_logic;
        next_state : out std_logic
    );
end isFull_next_calc;

architecture Behavioral of isFull_next_calc is
begin
    next_state <= '0' when (clear='1' or rst='1') else
                  '1' when (isFullBuffer='1' and do_pop='0')
                        or (do_push='1' and Cout='1')
                  else '0';
end Behavioral;