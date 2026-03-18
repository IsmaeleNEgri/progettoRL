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
        isFullBuffer : in std_logic;

        sp : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        spNext : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        B_sum : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        Cout : out std_logic
    );
end sp_controller;

architecture Behavioral of sp_controller is

    signal sp_support : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal spNext_support : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal Cout_support : std_logic;
    signal B_sum_support : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal sp_out : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);

begin

    sp_out <= (others => '0') when clear = '1' or rst='1'
        else sp_support when (do_push='1' and Cout_support='1') or 
                       (do_pop='1' and (sp_support="000" or isFullBuffer='1'))
        else spNext_support when (do_pop='1' or do_push='1')
        else sp_support;

    B_sum_support <= "001" when do_push = '1' else
               "111" when do_pop  = '1' else
               "000";

    sp <= sp_support;
    spNext <= spNext_support;
    Cout <= Cout_support;
    B_sum <= B_sum_support;

    incrementer_decrementer : entity work.rippleCarryAdder
        generic map(STACK_PTR_DEPTHR => STACK_PTR_DEPTH)
        port map(
            A => sp_support,
            B => B_sum_support,
            Cin => '0',
            ras => spNext_support,
            Cout => Cout_support
        );

    process(clk, rst)
    begin
        if rst = '1' then
            sp_support <= (others => '0');
        elsif rising_edge(clk) then
            sp_support <= sp_out;
        end if;
    end process;

end Behavioral;