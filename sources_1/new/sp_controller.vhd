library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sp_controller is
    generic(
        STACK_PTR_DEPTH : integer := 3
    );
    port(
        clk     : in std_logic;
        rst     : in std_logic;
        
        do_pop : in std_logic;
        do_push : in std_logic;
        clear   : in  std_logic;
        spNext  : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        sp      : buffer std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        
        B_sum   : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0)
    );
end sp_controller;

architecture Behavioral of sp_controller is

    signal sp_out : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    
begin
    
    sp_out <= (others => '0') when clear = '1' else 
              (spNext) when (do_pop='1' or do_push ='1') else
              sp;
              
              
    B_sum <= "001" when do_push = '1' else
             "111" when do_pop  = '1' else
             "000";
    
    process(clk,rst)
    begin
        if(rst  = '1') then
           sp <= "000";
           
        elsif rising_edge(clk) then
            sp <= sp_out;
        end if;
    end process;

end Behavioral;
                  