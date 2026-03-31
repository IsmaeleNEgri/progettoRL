library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_assigner is
    generic(
        DATA_WIDTH : integer := 8
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        push_i : in std_logic;
        pop_i : in std_logic;
        clear_i : in std_logic;
        
        din : in std_logic_vector(DATA_WIDTH-1 downto 0);
        
        push_s : out std_logic;
        pop_s : out std_logic;
        clear_s : out std_logic;
        din_s : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end input_assigner;

architecture Behavioral of input_assigner is
begin

    process(clk,rst)
    begin
        
        if rst = '1' then 
            pop_s <= '0';
            push_s <= '0';
            din_s <= (others => '0');
            clear_s <= '0';
        elsif rising_edge(clk) then
            pop_s <= pop_i;
            push_s <= push_i;
            din_s <= din;
            clear_s <= clear_i;
        end if;
        
    end process;

end Behavioral;