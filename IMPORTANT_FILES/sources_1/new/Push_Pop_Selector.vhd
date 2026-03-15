library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Push_Pop_Selector is
    generic(
        STACK_PTR_DEPTH : integer := 3
    );
    port(
        clk: in std_logic;
        rst: in std_logic;

        clear: in std_logic;
        push : in  std_logic;
        pop  : in  std_logic;
        do_push : inout std_logic;
        do_pop  : inout std_logic;
        sp : inout std_logic_vector(STACK_PTR_DEPTH-1 downto 0);

        B_sum: inout std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        spNext: inout std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        Cout : inout std_logic;
        isFullBuffer  : in  std_logic;
        isEmptyBuffer : in  std_logic;
        pop_to_confirm: inout std_logic;
        push_to_confirm: inout std_logic;
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

    sp_ctrl : entity work.sp_controller
        generic map(
        STACK_PTR_DEPTH => STACK_PTR_DEPTH
        )
        port map(
            clk => clk,
            rst => rst,
            
            do_push => do_push,
            Cout => Cout,
            do_pop => do_pop,
            clear => clear,
            spNext => spNext,
            sp => sp,
            isFullBuffer => isFullBuffer,
            
            B_sum => B_sum
        );
    
end Behavioral;
