library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity status_controller is
    Port(
        clk : in std_logic;
        rst : in std_logic;
        
        push : in std_logic;
        pop : in std_logic;
        isEmptyBuffer : in std_logic;
        isFullBuffer : in std_logic;
        
        popError : out std_logic;
        pushError : out std_logic);
                
end status_controller;

architecture Behavioral of status_controller is
    
    signal pushErr_next : std_logic;
    signal popErr_next : std_logic;
    
begin
          
      pushErr_next <= '1' when (push = '1' and isFullBuffer = '1' and pop = '0') else '0';       
      popErr_next <= '1' when (pop = '1' and isEmptyBuffer = '1' and push = '0') else '0';                
      
      process(clk,rst)
      begin 
        if(rst  = '1') then
            pushError <= '0';
            popError <= '0';
        elsif rising_edge(clk) then
            pushError <= pushErr_next;
            popError <= popErr_next;
        end if;
      end process;
      
end Behavioral;