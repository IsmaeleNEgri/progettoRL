library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity do_push_pop_calc_Sim is

end do_push_pop_calc_Sim;

architecture sim of do_push_pop_calc_Sim is

    signal rst : std_logic := '0';
    signal a : std_logic := '0';
    signal b : std_logic := '0';
    signal c : std_logic;

begin

    DUT : entity work.do_push_pop_calc
        port map(
            rst => rst,
            a => a,
            b => b,
            c => c
        );

    stim : process
    begin
        --testing do_push. 
        --testing do_pop would produce the same exact output.
    
        rst <= '1';     --initializing
        wait for 10 ns;
        rst <= '0';

        a <= '1'; b <= '0';        -- push_to_conf=1, isFullBuffer=0 => do_push=1
        wait for 10 ns;

        b <= '1';        -- push_to_conf=1, isFullBuffer=1 => do_push=0
        wait for 10 ns;

        a <= '0';        -- push_to_conf=0 => do_push=0
        wait for 10 ns;

        wait;
    end process;

end sim;