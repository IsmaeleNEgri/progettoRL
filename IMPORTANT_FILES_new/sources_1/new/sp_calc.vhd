library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sp_calc is
    generic(STACK_PTR_DEPTH : integer := 3);
    port(
        clear: in std_logic;
        rst : in std_logic;
        do_push : in std_logic;
        do_pop : in std_logic;
        isFullBuffer : buffer std_logic;

        sp : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        spNext : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        Cout : in  std_logic;

        sp_out : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0)
    );
end sp_calc;

architecture Behavioral of sp_calc is
begin
    sp_out <= (others => '0') when clear='1' or rst='1' else
              sp when (do_push='1' and Cout='1') or
                      (do_pop='1' and (sp="000" or isFullBuffer='1')) else
              spNext when (do_pop='1' or do_push='1') else
              sp;
end Behavioral;