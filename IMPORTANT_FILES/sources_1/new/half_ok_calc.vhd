library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_ok_calc is
    generic(STACK_PTR_DEPTH : integer := 3);
    port(
        sp : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        half_ok : out std_logic
    );
end half_ok_calc;

architecture Behavioral of half_ok_calc is
begin
    half_ok <= '1' when sp < "100" else '0';
end Behavioral;