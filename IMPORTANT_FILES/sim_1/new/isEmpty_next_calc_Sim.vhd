library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity isEmpty_next_calc_Sim is
end isEmpty_next_calc_Sim;

architecture sim of isEmpty_next_calc_Sim is

    constant N : integer := 3;

    signal clear, rst : std_logic := '0';
    signal isEmptyBuffer : std_logic := '0';
    signal do_push, do_pop : std_logic := '0';
    signal spNext : std_logic_vector(N-1 downto 0) := "000";

    signal next_state : std_logic;

begin

    DUT : entity work.isEmpty_next_calc
        generic map(N)
        port map(
            clear => clear,
            rst => rst,
            isEmptyBuffer => isEmptyBuffer,
            do_push => do_push,
            do_pop => do_pop,
            spNext => spNext,
            next_state => next_state
        );

    stim : process
    begin
        --initializing.
        --next_state =1, isEmptyBuffer will start as 1.
        --NB: do_push and do_pop can't be both 1 at the same time.

        
        rst <= '1';
        wait for 10 ns;
        rst <= '0';

        isEmptyBuffer <= '1';        --isEmptyBuffer=1, do_push=0 => next_state=1, isEmptyBuffer will be 1.
        wait for 10 ns;

        isEmptyBuffer <= '0';        -- do_pop=1 e spNext="000" =>  next_state=1, isEmptyBuffer will be 1.
        do_pop <= '1';
        wait for 10 ns;

        do_pop <= '0';        -- do_push=1, do_pop=0, spNext != "000" => next_state=0, isEmptyBuffer will be 0.
        do_push <= '1';
        spNext <= "001";
        wait for 10 ns;

        wait;
    end process;

end sim;