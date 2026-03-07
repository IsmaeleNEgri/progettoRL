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
        isFull : out std_logic;
        sp_debug : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        do_push_debug : out std_logic;
        do_pop_debug : out std_logic;
        mSig_debug     : out std_logic_vector(DATA_WIDTH*STACK_DEPTH-1 downto 0);
        Cout_debug: out std_logic;
        B_sum_debug : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0)
        
    );
end stack;

architecture Behavioral of stack is

    signal sp,spNext : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal do_push, do_pop, Cout : std_logic;
    signal B_sum : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal isFullBuffer: std_logic :='0';
    signal isEmptyBuffer: std_logic := '1';

begin

    selector_unit : entity work.Push_Pop_Selector
        generic map(STACK_PTR_DEPTH => STACK_PTR_DEPTH)
        port map(
            clk => clk,
            rst => rst,
            
            push => push,
            pop => pop,
            isFullBuffer => isFullBuffer,
            isEmptyBuffer => isEmptyBuffer,
            sp => sp,
            
            do_push => do_push,
            do_pop => do_pop
        );

    incrementer_decrementer : entity work.rippleCarryAdder
        generic map(STACK_PTR_DEPTHR => STACK_PTR_DEPTH)
        port map(
            A => sp,
            B => B_sum,
            Cin => '0',
            ras => spNext,
            Cout => Cout
        );

    memory_unit: entity work.memory
        generic map(
            STACK_DEPTH => STACK_DEPTH,
            DATA_WIDTH => DATA_WIDTH,
            STACK_PTR_DEPTH => STACK_PTR_DEPTH
        )
        port map(
            clk => clk,
            rst => rst,
            
            clear => clear,
            do_push => do_push,
            do_pop => do_pop,
            sp => sp,
            mSig_debug => mSig_debug,

            
            din => din,
            dout => dout
        );

    status_controller : entity work.status_controller
        port map(
            clk => clk,
            rst => rst,
            
            sp => sp,
            spNext => spNext,
            do_push => do_push,
            do_pop => do_pop,
            clear => clear,
            push => push,
            pop => pop,
            isFullBuffer => isFullBuffer,
            isEmptyBuffer => isEmptyBuffer,
            Cout => Cout,
            
            pushError => pushError,
            popError => popError,
            isEmpty => isEmpty,
            isFull => isFull
        );

    sp_ctrl : entity work.sp_controller
        generic map(
        STACK_PTR_DEPTH => STACK_PTR_DEPTH
        )
        port map(
            clk => clk,
            rst => rst,
            
            do_push => do_push,
            do_pop => do_pop,
            clear => clear,
            spNext => spNext,
            sp => sp,
            
            B_sum => B_sum
        );
        
        B_sum_debug <= B_sum;
        do_pop_debug <= do_pop;
        do_push_debug <= do_push;
        sp_debug <= sp;
        Cout_debug <= Cout;

end Behavioral;