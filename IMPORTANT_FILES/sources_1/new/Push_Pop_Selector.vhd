library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Push_Pop_Selector is
    generic(
        STACK_PTR_DEPTH : integer := 3
    );
    port(
        clk : in  std_logic;
        rst : in  std_logic;

        clear : in std_logic;
        push : in std_logic;
        pop : in std_logic;
        isFullBuffer : buffer std_logic;
        isEmptyBuffer : buffer std_logic;

        sp : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        spNext : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        Cout : out std_logic;

        do_push : out std_logic;
        do_pop : out std_logic;
        pop_to_confirm : out std_logic;
        push_to_confirm : out std_logic
    );
end Push_Pop_Selector;

architecture Structural of Push_Pop_Selector is

    signal half_ok_s : std_logic;
    signal half_ok_inv_s : std_logic;
    signal push_to_conf_s : std_logic;
    signal pop_to_conf_s : std_logic;
    signal do_push_s : std_logic;
    signal do_pop_s : std_logic;

    signal sp_s : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal spNext_s : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal B_sum_s : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal Cout_s : std_logic;

begin

    half_ok_inv_s <= not half_ok_s;

    half_ok_block : entity work.half_ok_calc
        port map(
            sp2 => sp_s(2),
            half_ok => half_ok_s
        );

    push_conf_block : entity work.push_pop_to_conf_calc
        port map(
            a => push,
            b => pop,
            half_ok => half_ok_s,
            c => push_to_conf_s
        );

    pop_conf_block : entity work.push_pop_to_conf_calc
        port map(
            a => pop,
            b => push,
            half_ok => half_ok_inv_s,
            c => pop_to_conf_s
        );

    do_push_block : entity work.do_push_pop_calc
        port map(
            rst => rst,
            a => push_to_conf_s,
            b => isFullBuffer,
            c => do_push_s
        );

    do_pop_block : entity work.do_push_pop_calc
        port map(
            rst => rst,
            a => pop_to_conf_s,
            b => isEmptyBuffer,
            c => do_pop_s
        );

    sp_controller : entity work.sp_controller
        generic map(STACK_PTR_DEPTH => STACK_PTR_DEPTH)
        port map(
            clk => clk,
            rst => rst,
            do_push => do_push_s,
            do_pop => do_pop_s,
            clear => clear,
            isFullBuffer => isFullBuffer,
            sp => sp_s,
            spNext => spNext_s,
            B_sum => B_sum_s,
            Cout => Cout_s
        );

    push_to_confirm <= push_to_conf_s;
    pop_to_confirm <= pop_to_conf_s;
    do_push <= do_push_s;
    do_pop <= do_pop_s;

    sp <= sp_s;
    spNext <= spNext_s;
    Cout <= Cout_s;

end Structural;