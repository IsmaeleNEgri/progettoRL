library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sp_controller is
    generic(
        STACK_PTR_DEPTH : integer := 3
    );
    port(
        clear   : in  std_logic;
        sp_in   : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        spNext  : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        do_push : in  std_logic;
        do_pop  : in  std_logic;
        Cout    : in  std_logic;

        sp_out  : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        isFull  : out std_logic;
        isEmpty : out std_logic
    );
end sp_controller;

architecture Behavioral of sp_controller is
begin
    sp_out <= (others => '0') when clear = '1' else
              spNext;
    
    isEmpty <= '1' when (clear = '1' or  (do_pop = '1' and spNext = "000")) else
               '0' when do_push = '1' else
               '0';
                   
    isFull <= '0' when (clear = '1' or do_pop='1') else
              '1' when (sp_in = "111" or (do_push = '1' and Cout = '1')) else
              '0';

end Behavioral;
                    
