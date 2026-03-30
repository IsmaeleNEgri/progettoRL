library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity status_assigner is
   Port (  
     rst : in std_logic;
     clk : in std_logic;
     isEmptyBuffer : buffer std_logic;
     isFullBuffer : buffer std_logic;
     pushErr_next : in std_logic;
     popErr_next : in std_logic;
     isFull_next: in std_logic;
     isEmpty_next: in std_logic;
     
     pushError : out std_logic;
     popError : out std_logic;
     isEmpty : out std_logic;
     isFull : out std_logic
   );
end status_assigner;

architecture Behavioral of status_assigner is
begin

    process(clk, rst)
    begin
        if rst = '1' then
        
            isFullBuffer <= '0';
            isEmptyBuffer <= '1';
            isEmpty <= '1';
            isFull <= '0';
            
            pushError <= '0';
            popError <= '0';

        elsif rising_edge(clk) then
            isFullBuffer <= isFull_next;
            isEmptyBuffer <= isEmpty_next;
            isFull <= isFull_next;
            isEmpty <= isEmpty_next;

            pushError <= pushErr_next;
            popError <= popErr_next;
        end if;
    end process;

end Behavioral;
