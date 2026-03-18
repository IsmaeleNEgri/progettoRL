library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity error_calc is
   Port (  
    push_or_pop : in std_logic;
    isEmpty_or_isFull : in std_logic;
    corrispective_out : out std_logic
   );
end error_calc;

architecture Behavioral of error_calc is

begin
    
    corrispective_out <= '1' when (push_or_pop = '1' and isEmpty_or_isFull = '1') else '0';

end Behavioral;
