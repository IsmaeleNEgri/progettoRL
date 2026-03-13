library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity status_and_error is
    Port (
        rst : in std_logic;
        clk     : in  std_logic;
        clear   : in  std_logic;
        push : in  std_logic;    
        pop : in  std_logic;
        full_in : in std_logic;
        empty_in : in std_logic;
        
        popError : out std_logic;   
        pushError : out std_logic;
        isEmpty : out std_logic;
        isFull : out std_logic;
        invalidate : out std_logic
     );
end status_and_error;

    architecture Behavioral of status_and_error is
    
    signal popError_reg :  std_logic := '0';
    signal pushError_reg :  std_logic := '0';
    signal invalid : std_logic := '0';
    
begin
                       
    popError_reg <= '1' when ( pop= '1' and empty_in = '1') else '0';
    
    pushError_reg <= '1' when (push = '1' and full_in = '1') else '0';
    
    invalid <= '1' when ( pop = '1' and push = '1' ) else '0';
    
    process(clk,rst)
    begin
        
        if rst = '1' then
            popError <= '0';
            pushError <= '0';
        
        elsif rising_edge(clk) then
            if clear = '1' then 
                invalidate <= '0';
                popError <= '0';
                pushError <= '0';
                
            else 
                
                if invalid = '0' then
                    popError <= popError_reg;
                    pushError <= pushError_reg;
                    invalidate <= pushError_reg or popError_reg;
                else
                    popError <= '0';
                    pushError <= '0'; 
                    invalidate <= invalid;   
                end if;                    
                
           end if; 
        end if;
    end process;                 
    
    
    isEmpty <= empty_in;
    isFull <= full_in;
end Behavioral;
