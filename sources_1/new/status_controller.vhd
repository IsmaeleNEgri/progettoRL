library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity status_controller is
    generic(
        STACK_PTR_DEPTH : integer := 3 
    );
    Port(
        clk : in std_logic;
        rst : in std_logic;
        
        clear : in std_logic;
        push : in std_logic;
        pop : in std_logic;
        isEmptyBuffer : buffer std_logic;
        isFullBuffer : buffer std_logic;
        spNext  : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        do_push : in  std_logic;
        do_pop  : in  std_logic;
        Cout : in std_logic;
        
        isFull : out std_logic;
        isEmpty : out std_logic;
        popError : out std_logic;
        pushError : out std_logic);
                
end status_controller;

architecture Behavioral of status_controller is
    
    signal pushErr_next : std_logic;
    signal popErr_next : std_logic;
begin
          
      pushErr_next <= '1' when (push = '1' and isFullBuffer = '1' and pop = '0') 
                          else '0';       
      popErr_next <= '1' when (pop = '1' and isEmptyBuffer = '1' and push = '0')
                          else '0';  
      isEmptyBuffer <= '1' when (clear = '1' or rst='1' or (do_pop = '1' and spNext = "000")) else
                     '0' when do_push = '1';

      isFullBuffer<= '0' when (clear = '1' or do_pop='1') else
                     '1' when ((isEmptyBuffer ='0' and spNext = "000") or ( do_push = '1' and Cout = '1'));
      
      
             
      process(clk,rst)
      begin 
        if(rst  = '1') then
            pushError <= '0';
            popError <= '0';
            isFull <= '0';
            isEmpty <= '1';
            
        elsif rising_edge(clk) then
            isEmpty <= isEmptyBuffer;
            isFull <= isFullBuffer;
            pushError <= pushErr_next;
            popError <= popErr_next;
        end if;
      end process;
      
end Behavioral;
