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
        POP : in  std_logic;
        PUSH : in std_logic;
        CLEAR : in std_logic;

        DIN : in std_logic_vector(DATA_WIDTH-1 downto 0);
        dOUT : out std_logic_vector(DATA_WIDTH-1 downto 0);

        pushError : out std_logic;
        popError : out std_logic;
        isEmpty : out std_logic;
        isFull : out std_logic
        
    );
end stack;

architecture Behavioral of stack is
    
    signal pop_s : std_logic;
    signal push_s : std_logic;
    signal clear_s : std_logic;
    signal dIN_s : std_logic_vector(DATA_WIDTH-1 downto 0);
    
    
    signal sp,spNext : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal do_push, do_pop, Cout : std_logic;
    signal push_to_confirm, pop_to_confirm: std_logic;
    signal isFullBuffer, isEmptyBuffer: std_logic;
    

begin
    
    sync_in : entity work.syncer
    port map(
        clk => clk,
        rst => rst,
        pop_i => POP,
        push_i => PUSH,
        clear_i => CLEAR,
        din => DIN,
        
        push_s => push_s,
        pop_s => pop_s,
        din_s => dIN_s,
        clear_s => clear_s
    );
    
    Push_Pop_Selector : entity work.Push_Pop_Selector
        generic map(STACK_PTR_DEPTH => STACK_PTR_DEPTH)
        port map(
            clk => clk,
            rst => rst,
            
            clear => clear_s,
            push => push_s,
            pop => pop_S,
            isFullBuffer => isFullBuffer,
            isEmptyBuffer => isEmptyBuffer,
            
            sp => sp, 
            spNext => spNext,
            Cout => Cout,
            do_push => do_push,
            do_pop => do_pop,
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
            
            din => dIN_s,
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
            clear => clear_s,
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
