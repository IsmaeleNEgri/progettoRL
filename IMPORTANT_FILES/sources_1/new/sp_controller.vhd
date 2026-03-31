library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sp_controller is
    generic(
        STACK_PTR_DEPTH : integer := 3
    );
    port(
        clk : in std_logic;
        rst : in std_logic;

        do_pop : in std_logic;
        do_push : in std_logic;
        clear : in std_logic;
        isFullBuffer : buffer std_logic;

        sp : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        spNext : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        B_sum : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        Cout : out std_logic
    );
end sp_controller;

architecture Structural of sp_controller is

    signal sp_s : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal spNext_s : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal Cout_s : std_logic;
    signal Bsum_s : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal sp_out_s : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);

begin

    Bsum_calc_block : entity work.Bsum_calc
        generic map(STACK_PTR_DEPTH => STACK_PTR_DEPTH)
        port map(
            do_push => do_push,
            do_pop => do_pop,
            B_sum => Bsum_s
        );

    RippleCarryAdder_block : entity work.rippleCarryAdder
        generic map(STACK_PTR_DEPTHR => STACK_PTR_DEPTH)
        port map(
            A => sp_s,
            B => Bsum_s,
            Cin => '0',
            ras => spNext_s,
            Cout => Cout_s
        );

    sp_calc_block : entity work.sp_calc
        generic map(STACK_PTR_DEPTH => STACK_PTR_DEPTH)
        port map(
            clear => clear,
            rst => rst,
            do_push => do_push,
            do_pop => do_pop,
            isFullBuffer => isFullBuffer,
            sp => sp_s,
            spNext => spNext_s,
            Cout => Cout_s,
            sp_out => sp_out_s
        );

    sp_assigner_block : entity work.sp_assigner
        generic map(STACK_PTR_DEPTH => STACK_PTR_DEPTH)
        port map(
            clk => clk,
            rst => rst,
            sp_in => sp_out_s,
            sp_out => sp_s
        );

    sp <= sp_s;
    spNext <= spNext_s;
    Cout <= Cout_s;
    B_sum <= Bsum_s;

end Structural;