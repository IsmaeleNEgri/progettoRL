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

    signal sp, spNext : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal do_push, do_pop : std_logic;
    signal B_sum : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal Cout : std_logic;
    signal isFullBuffer, isEmptyBuffer : std_logic;

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
            do_pop => do_pop,
            B_sum => B_sum
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
            push => do_push,
            pop => do_pop,
            sp => sp,
            din => din,
            dout => dout
        );

    status_controller : entity work.status_controller
        port map(
            clk => clk,
            rst => rst,
            push => push,
            pop => pop,
            isFullBuffer => isFullBuffer,
            isEmptyBuffer => isEmptyBuffer,
            pushError => pushError,
            popError => popError
        );

    sp_ctrl : entity work.sp_controller
        generic map(STACK_PTR_DEPTH => STACK_PTR_DEPTH)
        port map(
            clk => clk,
            rst => rst,
            clear => clear,
            sp_in => sp,
            spNext => spNext,
            do_push => do_push,
            do_pop => do_pop,
            Cout => Cout,
            sp_out => sp,
            isFull => isFullBuffer,
            isEmpty => isEmptyBuffer
        );

    isEmpty <= isEmptyBuffer;
    isFull <= isFullBuffer;

end Behavioral;