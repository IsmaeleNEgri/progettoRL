library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity signal_conf_module is
   Port ( 
      signal_one : in std_logic;
      signal_two : in std_logic;
      half_ok_support : in std_logic;
      sig_to_conf_support : out std_logic  
    );
end signal_conf_module;

architecture Behavioral of signal_conf_module is

begin
    
    sig_to_conf_support <= '1' when signal_one = '1' and ((signal_two='1' and half_ok_support='0') or signal_two='0')
                     else '0';

end Behavioral;
