library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity next_state_calc is
   Port (
      rst : in std_logic;
      clear : in std_logic;
      Empty_or_Full_buffer : in std_logic;
      do_signal : in std_logic;
      do_signal_two : in std_logic;
      spNext : in std_logic_vector(2 downto 0);
      cout : in std_logic;
      if_empty : in std_logic;
      
      next_state : out std_logic            
    );
end next_state_calc;

architecture Behavioral of next_state_calc is
    
    signal next_state_one : std_logic := '0';
    signal next_state_two : std_logic := '0';
    
begin
       
      next_state_one <= '1' when (clear = '1' or rst = '1') 
                            or (Empty_or_Full_buffer = '1' and do_signal = '0') 
                            or (do_signal_two = '1' and spNext = "000")  else '0';
    
      next_state_two <= '1' when (clear = '1' or rst = '1') 
                            or (Empty_or_Full_buffer = '1' and do_signal = '0') 
                            or (do_signal_two = '1' and cout = '1')  else '0';
      
      next_state <= next_state_one when if_empty = '1' else next_state_two;
      
end Behavioral;
