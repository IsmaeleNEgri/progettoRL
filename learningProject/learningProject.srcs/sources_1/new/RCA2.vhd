----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2025 09:40:14 AM
-- Design Name: 
-- Module Name: RCA2 - Behavioral
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

--the 2 in RCA2 is just cause i messed up and somehow the RCA that i  deleted is still somewhere so i cant use RCA as a name 
entity RCA2 is
    
   --the use of the bus option result in the use of the sd_logic_vector, and it is used to have multiple bit result
   -- we probably wont use std_vector but it's good to know how to use it. basically when you have a inout/output of more bit vectors
   --are used. STD_VECTOR( last _bit downto first_bit) means i have bits (0-4)
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
            b : in STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC;
           sum : out STD_LOGIC_VECTOR (3 downto 0);
           Cout : out STD_LOGIC);
end RCA2;

--N.B once you define the RCA, since it use the fullAdder source, that source will be nested inside the RCA source

architecture Structural of RCA2 is

    --the RCA is composed of fullAdders so it is necessary to define it as a compoenent, but before that the source fullAdder has
    --to be created before RCA is
    component fullAdder
        Port ( A, B, Cin : in STD_LOGIC;
               Sum, Cout : out STD_LOGIC );
    end component;
    
    --variable C to manage the carries
    signal C : STD_LOGIC_VECTOR(3 downto 0);
    
begin
    --in order to get this having the draw of the RCA is required, so check the schematic of the simulation
    FA0: fullAdder port map(A(0), B(0), Cin, Sum(0), C(0));
    FA1: fullAdder port map(A(1), B(1), C(0), Sum(1), C(1));
    FA2: fullAdder port map(A(2), B(2), C(1), Sum(2), C(2));
    FA3: fullAdder port map(A(3), B(3), C(2), Sum(3), Cout);
end Structural;

