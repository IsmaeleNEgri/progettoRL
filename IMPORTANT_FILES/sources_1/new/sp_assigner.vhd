library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sp_assigner is
    generic(STACK_PTR_DEPTH : integer := 3);
    port(
        clk : in std_logic;
        rst : in std_logic;

        sp_in  : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        sp_out : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0)
    );
end sp_assigner;

architecture Behavioral of sp_assigner is
    signal sp_reg : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
begin

    process(clk, rst)
    begin
        if rst = '1' then
            sp_reg <= (others => '0');
        elsif rising_edge(clk) then
            sp_reg <= sp_in;
        end if;
    end process;

    sp_out <= sp_reg;

end Behavioral;