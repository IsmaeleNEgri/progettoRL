library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_ok_calc is
    port(
        sp2 : in  std_logic;
        half_ok : out std_logic
    );
end half_ok_calc;

architecture Behavioral of half_ok_calc is
begin
    half_ok <= not sp2;
end Behavioral;