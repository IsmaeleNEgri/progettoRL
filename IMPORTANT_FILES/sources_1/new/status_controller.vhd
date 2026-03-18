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
        isEmptyBuffer : buffer std_logic;
        isFullBuffer : buffer std_logic;
        spNext  : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        sp : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        do_push : in  std_logic;
        do_pop  : in  std_logic;
        Cout : in std_logic;
        push_to_confirm : in std_logic;
        pop_to_confirm: in std_logic;
        
        isFull : out std_logic;
        isEmpty : out std_logic;
        popError : out std_logic;
        pushError : out std_logic
    );
                
end status_controller;

architecture Structural of status_controller is

    signal isFull_next  : std_logic;
    signal isEmpty_next : std_logic;
    signal pushErr_next : std_logic;
    signal popErr_next  : std_logic;

begin

    pushError_next : entity work.error_calc
      port map(
        push_or_pop => push_to_confirm,
        isEmpty_or_isFull => isFullBuffer,
        corrispective_out => pushErr_next
      );

    popError_next : entity work.error_calc
      port map(
        push_or_pop => pop_to_confirm,
        isEmpty_or_isFull => isEmptyBuffer,
        corrispective_out => popErr_next
      );

    empty_calc : entity work.isEmpty_next_calc
        generic map(STACK_PTR_DEPTH => STACK_PTR_DEPTH)
        port map(
            clear => clear,
            rst => rst,
            isEmptyBuffer => isEmptyBuffer,
            do_push => do_push,
            do_pop => do_pop,
            spNext => spNext,
            next_state => isEmpty_next
        );

    full_calc : entity work.isFull_next_calc
        port map(
            clear => clear,
            rst => rst,
            isFullBuffer => isFullBuffer,
            do_push => do_push,
            do_pop => do_pop,
            Cout => Cout,
            next_state => isFull_next
        );

    assign_output : entity work.assigner
      port map(
        isEmptyBuffer => isEmptyBuffer,
        isFullBuffer  => isFullBuffer,
        rst => rst,
        clk => clk,
        pushErr_next => pushErr_next,
        popErr_next  => popErr_next,
        isFull_next  => isFull_next,
        isEmpty_next => isEmpty_next,
        pushError => pushError,
        popError  => popError,
        isEmpty   => isEmpty,
        isFull    => isFull
      );

end Structural;
