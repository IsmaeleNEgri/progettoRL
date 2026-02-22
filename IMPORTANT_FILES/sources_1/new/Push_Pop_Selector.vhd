library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Push_Pop_Selector is
    generic(
        STACK_PTR_DEPTH : integer := 3
    );
    port(
        -- input control signals
        push          : in  std_logic;
        pop           : in  std_logic;
        isFullBuffer  : in  std_logic;
        isEmptyBuffer : in  std_logic;

        -- stack pointer
        sp            : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);

        -- outputs
        do_push       : out std_logic;
        do_pop        : out std_logic;
        B_sum         : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0)
    );
end Push_Pop_Selector;

architecture Behavioral of Push_Pop_Selector is
    signal half_ok: std_logic;
    signal do_push_sig : std_logic;
    signal do_pop_sig : std_logic;
    
begin
    
    half_ok <= '1' when (sp = "000" or sp = "001" or sp = "010" or sp = "011")
        else '0';
    do_push_sig <= '1' when (push = '1' and isFullBuffer = '0') and 
        (pop = '0' or half_ok='1')
        else '0';
    do_pop_sig <= '1' when (pop  = '1' and isEmptyBuffer = '0' and do_push_sig = '0') 
        else '0';
    B_sum <= "001" when do_push_sig = '1'
        else "111" when do_pop_sig = '1'
        else (others => '0');

    do_push <= do_push_sig;
    do_pop  <= do_pop_sig;


end Behavioral;
