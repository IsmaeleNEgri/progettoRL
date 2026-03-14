library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Push_Pop_Selector is
    generic(
        STACK_PTR_DEPTH : integer := 3
    );
    port(
        rst: in std_logic;

        push : in  std_logic;
        pop  : in  std_logic;
        isFullBuffer  : in  std_logic;
        isEmptyBuffer : in  std_logic;
        sp : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        pop_to_confirm: inout std_logic;
        push_to_confirm: inout std_logic;

        do_push : out std_logic;
        do_pop  : out std_logic;
        half_ok : inout std_logic
    );
end Push_Pop_Selector;

architecture Behavioral of Push_Pop_Selector is
    
begin

    half_ok <= '1' when sp < "100" else '0';
    
    -- Caso push e pop simultanei + pop o push solitari
    push_to_confirm <= '1' when push='1' and ((pop='1' and half_ok='1') or pop='0')
                          else '0';
    
    pop_to_confirm <= '1' when pop='1' and ((push='1' and half_ok='0') or push='0')
                          else '0';

    do_push <= '0' when rst='1' else
               '1' when push_to_confirm='1' and isFullBuffer='0'
               else '0';

    do_pop <= '0' when rst='1' else
              '1' when pop_to_confirm='1' and isEmptyBuffer='0'
              else '0';

end Behavioral;
