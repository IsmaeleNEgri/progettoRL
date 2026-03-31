library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity error_calc is
   Port (  
    a : in std_logic;
    b : buffer std_logic;
    c : out std_logic
   );
end error_calc;

architecture Behavioral of error_calc is

begin
    
    c <= '1' when (a = '1' and b = '1') else '0';

end Behavioral;
