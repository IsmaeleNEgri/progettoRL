library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Push_Pop_Selector is
    generic(
        STACK_PTR_DEPTH : integer := 3
    );
    port(
        clk: in std_logic;
        rst: in std_logic;

        push : in  std_logic;
        pop  : in  std_logic;
        isFullBuffer  : in  std_logic;
        isEmptyBuffer : in  std_logic;
        sp : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);

        do_push : out std_logic;
        do_pop  : out std_logic
    );
end Push_Pop_Selector;

architecture Behavioral of Push_Pop_Selector is
    signal half_ok      : std_logic;
    signal do_push_sig  : std_logic;
    signal do_pop_sig   : std_logic;
begin

    half_ok <= '1' when sp < "100" else '0';

    -- Caso push e pop simultanei + pop o push solitari
    do_push_sig <= '1' when push='1' and isFullBuffer='0'and ((pop='1' and half_ok='1') or pop='0')
                       else '0';

    do_pop_sig <= '1' when pop='1' and isEmptyBuffer='0' and ((push='1' and half_ok='0') or push='0')
                       else '0';

    process(clk, rst)
    begin
        if rst = '1' then
            do_push <= '0';
            do_pop  <= '0';
        elsif rising_edge(clk) then
            do_push <= do_push_sig;
            do_pop  <= do_pop_sig;
        end if;
    end process;

end Behavioral;
