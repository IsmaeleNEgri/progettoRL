library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity isEmpty_next_calc is
    generic(STACK_PTR_DEPTH : integer := 3);
    Port(
        clear : in std_logic;
        rst : in std_logic;
        isEmptyBuffer : buffer std_logic;
        do_push : in std_logic;
        do_pop : in std_logic;
        spNext : in std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        next_state : out std_logic
    );
end isEmpty_next_calc;

architecture Behavioral of isEmpty_next_calc is
begin
    next_state <= '1' when (clear='1' or rst='1')
                         or (isEmptyBuffer='1' and do_push='0')
                         or (do_pop='1' and spNext="000")
                  else '0';
end Behavioral;
