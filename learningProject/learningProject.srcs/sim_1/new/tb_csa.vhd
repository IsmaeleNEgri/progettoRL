----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2025 10:30:37 PM
-- Design Name: 
-- Module Name: tb_csa - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_csa is
--  Port ( );
end tb_csa;

architecture Behavioral of tb_csa is
    
    --required signals ,(signals of the CSA)
    signal a, b, c : STD_LOGIC_VECTOR(3 downto 0);
    signal sum, carry : STD_LOGIC_VECTOR(3 downto 0);
    
    --define of the CSA component (this is a testbench (tb) i have to define the CSA as a component)
    component CSA
        Port ( a, b, c : in STD_LOGIC_VECTOR(3 downto 0);
               sum : out STD_LOGIC_VECTOR(3 downto 0);
               carry : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

begin
    
    --mapping of the signals "into the CSA" (i connected them so when i stimulate the signals the CSA react and do his things)
    uut: CSA port map (A => A, B => B, C => C, Sum => Sum, Carry => Carry);
    
    --if you're asking youreself about the the values and name below, just dont, they're AI generated cause i'm not so good at 
    --inventing casual test so i asked to give some values and it did
    --Anyway it does 3 test with 3 different set
    
    --Also i understand the fullAdderTb problem, and it's just that i have to use only a process, otherwise since they start togheter
    --they also produce a mess on the simulation result mixing all of the results
    stim_proc: process
    begin
        -- Test 1
        A <= "0001"; B <= "0010"; C <= "0100";
        wait for 10 ns;

        -- Test 2
        A <= "1111"; B <= "0001"; C <= "0001";
        wait for 10 ns;

        -- Test 3
        A <= "1010"; B <= "0101"; C <= "0011";
        wait for 10 ns;

        wait;
    end process;

end Behavioral;
