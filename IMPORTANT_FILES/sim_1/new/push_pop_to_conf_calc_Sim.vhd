library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity push_pop_to_conf_calc_Sim is

end push_pop_to_conf_calc_Sim;

architecture sim of push_pop_to_conf_calc_Sim is

    signal a, b, half_ok : std_logic := '0';
    signal c : std_logic;

begin

    uut : entity work.push_pop_to_conf_calc
        port map(
            a => a,
            b => b,
            half_ok => half_ok,
            c => c
        );

    stim : process
    begin
        --we are testing push_to_conf.
        --in case we wanted to test pop_to_conf, the half_ok signal would be the inverted, and the outcome too (pop_to_conf)
        
        a <= '0'; b <= '0'; half_ok <= '0';     --initializing
        wait for 10 ns;

        a <= '1'; b <= '0'; half_ok <= '0';        -- push=1, pop=0 => push_to_conf=1
        wait for 10 ns;

        a <= '1'; b <= '1'; half_ok <= '1';        -- push=1, pop=1, half_ok=1 => push_to_conf=1
        wait for 10 ns;

        half_ok <= '0';        -- push=1, pop=1, half_ok=0 => push_to_conf=0
        wait for 10 ns;

        a<='0'; b<= '1';       --push=0, pop=1, half_ok =0 => push_to_conf =0
        
        wait;
    end process;

end sim;