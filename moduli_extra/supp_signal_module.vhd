library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity supp_signal_module is
   Port ( 
      rst : in std_logic;
      sig_to_conf_supp : in std_logic;
      status_buffer : in std_logic;
      do_sig_supp : out std_logic  
    );
end supp_signal_module;

architecture Behavioral of supp_signal_module is

begin
    
     do_sig_supp <= '0' when rst='1' else
                 '1' when sig_to_conf_supp='1' and status_buffer='0'
                 else '0';

end Behavioral;
