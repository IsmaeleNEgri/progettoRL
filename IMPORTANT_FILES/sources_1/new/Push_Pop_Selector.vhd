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
        isFullBuffer : in std_logic;
        isEmptyBuffer : in std_logic;

        sp : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        spNext : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        B_sum : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        Cout : out std_logic;
        do_push : out std_logic;
        do_pop : out std_logic;
        pop_to_confirm : out std_logic;
        push_to_confirm : out std_logic;
        half_ok : out std_logic
    );
end Push_Pop_Selector;

architecture Behavioral of Push_Pop_Selector is

    signal do_push_support : std_logic;
    signal do_pop_support : std_logic;
    signal push_to_conf_support : std_logic;
    signal pop_to_conf_support : std_logic;
    signal half_ok_support : std_logic;

    signal sp_support : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal spNext_support : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal Cout_support : std_logic;
    signal B_sum_support : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);

begin

    half_ok_support <= '1' when sp_support < "100" else '0';

    push_to_conf_support <= '1' when push='1' and ((pop='1' and half_ok_support='1') or pop='0')
                      else '0';

    pop_to_conf_support <= '1' when pop='1' and ((push='1' and half_ok_support='0') or push='0')
                     else '0';

    do_push_support <= '0' when rst='1' else
                 '1' when push_to_conf_support='1' and isFullBuffer='0'
                 else '0';

    do_pop_support <= '0' when rst='1' else
                '1' when pop_to_conf_support='1' and isEmptyBuffer='0'
                else '0';

    do_push <= do_push_support;
    do_pop <= do_pop_support;
    push_to_confirm <= push_to_conf_support;
    pop_to_confirm <= pop_to_conf_support;
    half_ok <= half_ok_support;

    sp <= sp_support;
    spNext <= spNext_support;
    B_sum <= B_sum_support;
    Cout <= Cout_support;


    sp_ctrl : entity work.sp_controller
        generic map(
            STACK_PTR_DEPTH => STACK_PTR_DEPTH
        )
        port map(
            clk => clk,
            rst => rst,

            do_push => do_push_support,
            do_pop => do_pop_support,
            clear => clear,
            isFullBuffer => isFullBuffer,

            sp => sp_support,
            spNext => spNext_support,
            B_sum => B_sum_support,
            Cout => Cout_support
        );

end Behavioral;