----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/15/2025 10:17:52 PM
-- Design Name: 
-- Module Name: fullAdderTb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

-- for the testbench a simulation source file has to be created with no ports
--before starting know that the process for testing start simultaniously

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fullAdderTb is
--  Port ( );
end fullAdderTb;

architecture Behavioral of fullAdderTb is
    --i personally use name_otherParteofName for testing signals, but i'm still not sure about it
    signal t_a   : std_logic := '0';    
    signal t_b   : std_logic := '0';    
    signal t_Cin : std_logic := '0';    
    --
    signal t_sum : std_logic;    
    signal t_Cout : std_logic;
        
    constant clockSig : time := 5ns;
    
begin
    --with the UUT i define the entity i want to test (fullAdder, name must be that of the entity)
    --and then i link every signal with is test version
    UUT: entity work.fullAdder
        port map(
            a => t_a,
            b => t_b,
            Cin => t_Cin,
            --
            sum => t_sum,
            Cout => t_Cout
            );  
            
    --now i have to give the values for the test
    proc_a : process
    begin
        --assign 0 to t_a
        t_a <= '0';
        --i wait then i switch value to 1     
        wait for clockSig;
        t_a <= '1';
        --i wait again then i stop
        wait for clockSig;
    end process;
    
    --the multiplication of clockSig by 2 in b, it is not standard, it's just the port that behave like this
    --because in the simulation we forced it like this 
    proc_b : process
    begin
        t_b <= '0';
        wait for clockSig * 2;
        t_b <= '1';
        wait for clockSig * 2;
    end process;
    
    proc_Cin : process
    begin
        t_Cin <= '0';   
        wait for clockSig * 4;
        t_Cin <= '1';
        wait for clockSig * 4;
    end process;

end Behavioral;
