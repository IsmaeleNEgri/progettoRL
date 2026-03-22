library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity do_push_calc is
    port(
        rst : in std_logic;
        push_to_conf : in std_logic;
        isFullBuffer : in std_logic;
        do_push : out std_logic
    );
end do_push_calc;

architecture Behavioral of do_push_calc is
begin
    do_push <= '0' when rst='1' else
               '1' when push_to_conf='1' and isFullBuffer='0'
               else '0';
end Behavioral;