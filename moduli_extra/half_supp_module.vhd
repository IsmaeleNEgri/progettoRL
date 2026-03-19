library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_supp_module is
   Port (        
        sp_support : in std_logic_vector(2 downto 0);
        half_ok_support : out std_logic
    );
end half_supp_module;

architecture Behavioral of half_supp_module is

begin
    
    half_ok_support <= '1' when sp_support < "100" else '0';

end Behavioral;
