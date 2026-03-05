library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sp_controller is
    generic(
        STACK_PTR_DEPTH : integer := 3
    );
    port(
        clk     : in std_logic;
        rst     : in std_logic;
        
        clear   : in  std_logic;
        spNext  : in  std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        Cout    : in  std_logic;
        sp  : out std_logic_vector(STACK_PTR_DEPTH-1 downto 0)
    );
end sp_controller;

architecture Behavioral of sp_controller is

    signal sp_out : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    
begin
    
    sp_out <= (others => '0') when clear = '1' else
              spNext;
              
    process(clk,rst)
    begin
        if(rst  = '1') then
           sp <= "000";
                
        elsif rising_edge(clk) then
            sp <= sp_out;
        end if;
    end process;

end Behavioral;
                  