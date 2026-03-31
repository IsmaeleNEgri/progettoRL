library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sp_calc_Sim is

end sp_calc_Sim;

architecture sim of sp_calc_Sim is

    constant N : integer := 3;

    signal clear, rst : std_logic := '0';
    signal do_push, do_pop : std_logic := '0';
    signal isFullBuffer : std_logic := '0';

    signal sp : std_logic_vector(N-1 downto 0) := "010";
    signal spNext : std_logic_vector(N-1 downto 0) := "011";
    signal Cout : std_logic := '0';

    signal sp_out : std_logic_vector(N-1 downto 0);

begin

    DUT : entity work.sp_calc
        generic map(N)
        port map(
            clear => clear,
            rst => rst,
            do_push => do_push,
            do_pop => do_pop,
            isFullBuffer => isFullBuffer,
            sp => sp,
            spNext => spNext,
            Cout => Cout,
            sp_out => sp_out
        );

    stim : process
    begin
        --initializing.
        --sp_out will start as "000".
        --NB: do_push and do_pop can't be both 1 at the same time.
        
        rst <= '1';
        wait for 10 ns;
        rst <= '0';

        do_push <= '1'; Cout <= '1';        -- push e Cout=1 => sp_out = sp
        wait for 10 ns;

        do_push <= '0'; do_pop <= '1'; Cout <= '0';        -- do_pop=1, Cout=0 => sp_out = spNext
        wait for 10 ns;

        clear <= '1';        -- clear=1 => sp_out ="000".
        wait for 10 ns;
        clear <= '0';

        wait;
    end process;

end sim;