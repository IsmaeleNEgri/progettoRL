library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity isFull_next_calc_Sim is

end isFull_next_calc_Sim;

architecture sim of isFull_next_calc_Sim is

    signal clear, rst : std_logic := '0';
    signal isFullBuffer : std_logic := '0';
    signal do_push, do_pop : std_logic := '0';
    signal Cout : std_logic := '0';

    signal next_state : std_logic;

begin

    DUT : entity work.isFull_next_calc
        port map(
            clear => clear,
            rst => rst,
            isFullBuffer => isFullBuffer,
            do_push => do_push,
            do_pop => do_pop,
            Cout => Cout,
            next_state => next_state
        );

    stim : process
    begin
        --initializing.
        --NB: do_push and do_pop can't be both 1 at the same time.
        
        rst <= '1';
        wait for 10 ns;
        rst <= '0';

        isFullBuffer <= '1';        --isFullBuffer=1, e do_pop=0 => next_state=1, isFullNext will be 1.
        wait for 10 ns;
        
        clear <= '1';           --clearing => next_state=0, isFullNext will be 0.
        wait for 10 ns;
        
        clear <='0';        -- do_push e Cout=1, isFullBuffer =0 => next_state=1, isFullNext will be 1.
        do_push <= '1';
        isFullBuffer <= '0';
        Cout <= '1';
        wait for 10 ns;

        do_push <= '0';        -- do_pop=1 => next_state=0, isFullNext will be 0.
        do_pop <= '1';
        Cout <= '0';
        wait for 10 ns;

        wait;
    end process;

end sim;