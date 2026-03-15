library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stack is
    generic (
        DATA_WIDTH : integer := 8;
        STACK_DEPTH : integer := 8;
        STACK_PTR_DEPTH : integer := 3
    );
    port( 
        clk : in std_logic;
        rst : in std_logic;
        pop : in  std_logic;
        push : in std_logic;
        clear : in std_logic;

        dIN : in std_logic_vector(DATA_WIDTH-1 downto 0);
        dOUT : out std_logic_vector(DATA_WIDTH-1 downto 0);

        pushError : out std_logic;
        popError : out std_logic;
        isEmpty : out std_logic;
        isFull : out std_logic
        
    );
end stack;

architecture Behavioral of stack is

    signal sp,spNext : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal do_push, do_pop, Cout : std_logic;
    signal B_sum : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal half_ok, push_to_confirm, pop_to_confirm: std_logic;
    signal isFullBuffer, isEmptyBuffer: std_logic;
    

begin

    selector_unit : entity work.Push_Pop_Selector
        generic map(STACK_PTR_DEPTH => STACK_PTR_DEPTH)
        port map(
            clk => clk,
            rst => rst,
            
            clear => clear,
            push => push,
            pop => pop,
            do_push => do_push,
            do_pop => do_pop,
            sp => sp, 
            spNext => spNext,
            B_sum => B_sum,
            Cout => Cout,
            
            isFullBuffer => isFullBuffer,
            isEmptyBuffer => isEmptyBuffer,
            half_ok=> half_ok,
            push_to_confirm => push_to_confirm,
            pop_to_confirm => pop_to_confirm
            
        );

    

    memory_unit: entity work.memory
        generic map(
            STACK_DEPTH => STACK_DEPTH,
            DATA_WIDTH => DATA_WIDTH,
            STACK_PTR_DEPTH => STACK_PTR_DEPTH
        )
        port map(
            clk => clk,
            
            do_push => do_push,
            do_pop => do_pop,
            sp => sp,
            isFullBuffer => isFullBuffer,
            
            din => din,
            dout => dout
        );

    status_controller : entity work.status_controller
        port map(
            clk => clk,
            rst => rst,
            
            spNext => spNext,
            sp => sp,
            do_push => do_push,
            do_pop => do_pop,
            clear => clear,
            isFullBuffer => isFullBuffer,
            isEmptyBuffer => isEmptyBuffer,
            Cout => Cout,
            push_to_confirm => push_to_confirm,
            pop_to_confirm => pop_to_confirm,

            
            pushError => pushError,
            popError => popError,
            isEmpty => isEmpty,
            isFull => isFull
        );

    

end Behavioral;