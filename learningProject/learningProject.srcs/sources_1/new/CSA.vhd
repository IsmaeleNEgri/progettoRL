----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2025 10:18:12 PM
-- Design Name: 
-- Module Name: CSA - Behavioral
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

entity CSA is
    Port ( a,b,c : in STD_LOGIC_VECTOR (3 downto 0);
           sum : out STD_LOGIC_VECTOR (3 downto 0); 
           carry : out STD_LOGIC_VECTOR (3 downto 0));
end CSA;

architecture Behavioral of CSA is
    
    --define the fullAdder component, that compose the CSA
    component fullAdder 
        Port(fa, fb, fCin : in std_logic;
             fsum, fCout : out std_logic);
    end component;
    
begin
    
    --in order to get this the scheme of the CSA is advised
    --faNumber before ":" means fullAdder (i'm just "defining and using the parts")
    --it works since the "c" of the CSA is associated with the "Cin" of the fullAdder (look at the position in the "()")
    fa0: fullAdder port map (a(0), b(0), c(0), sum(0), carry(0));
    fa1: fullAdder port map (a(1), b(1), c(1), sum(1), carry(1));
    fa2: fullAdder port map (a(2), b(2), c(2), sum(2), carry(2));
    fa3: fullAdder port map (a(3), b(3), c(3), sum(3), carry(3));
    
end Behavioral;
