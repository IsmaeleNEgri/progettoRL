library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sp_controller is
    generic(
        STACK_PTR_DEPTH : integer := 3
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        clear : in std_logic;

        sp_in  : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        spNext : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        do_push : in std_logic;
        do_pop  : in std_logic;
        Cout    : in std_logic;

        sp_out : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        isFull : out std_logic;
        isEmpty : out std_logic
    );
end sp_controller;

architecture Behavioral of sp_controller is
    signal sp_reg : std_logic_vector(STACK_PTR_DEPTH-1 downto 0) := (others => '0');
    signal full_reg, empty_reg : std_logic := '0';
begin

    process(clk, rst)
    begin
        if rst = '1' then
            sp_reg <= (others => '0');
            full_reg <= '0';
            empty_reg <= '1';

        elsif rising_edge(clk) then
            if clear = '1' then
                sp_reg <= (others => '0');
                full_reg <= '0';
                empty_reg <= '1';

            else
                sp_reg <= spNext;

                if do_pop = '1' and spNext = "000" then
                    empty_reg <= '1';
                elsif do_push = '1' then
                    empty_reg <= '0';
                end if;

                if do_pop = '1' then
                    full_reg <= '0';
                elsif (sp_in = "111" or (do_push = '1' and Cout = '1')) then
                    full_reg <= '1';
                end if;
            end if;
        end if;
    end process;

    sp_out <= sp_reg;
    isFull <= full_reg;
    isEmpty <= empty_reg;

end Behavioral;