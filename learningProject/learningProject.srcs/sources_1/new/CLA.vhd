library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--4 bit CLA
entity CLA is
    Port (
        a     : in  STD_LOGIC_VECTOR(3 downto 0);
        b     : in  STD_LOGIC_VECTOR(3 downto 0);
        Cin   : in  STD_LOGIC;
        sum   : out STD_LOGIC_VECTOR(3 downto 0);
        Cout  : out STD_LOGIC
    );
end CLA;

architecture Behavioral of CLA is

    --G is generate and P is propagate
    signal G, P : STD_LOGIC_VECTOR(3 downto 0);
    signal C : STD_LOGIC_VECTOR(4 downto 0); 
    
begin
    --generate and propagate calculation
    G <= a AND b;
    P <= a XOR b;

    --carries calculation
    --here it is the problem with the cla, the carries formula for only 4 bit is already too long for me
    C(0) <= Cin;
    C(1) <= G(0) OR (P(0) AND C(0));
    C(2) <= G(1) OR (P(1) AND G(0)) OR (P(1) AND P(0) AND C(0));
    C(3) <= G(2) OR (P(2) AND G(1)) OR (P(2) AND P(1) AND G(0)) OR (P(2) AND P(1) AND P(0) AND C(0));
    C(4) <= G(3) OR (P(3) AND C(3));

    --sums calculation
    sum(0) <= P(0) XOR C(0);
    sum(1) <= P(1) XOR C(1);
    sum(2) <= P(2) XOR C(2);
    sum(3) <= P(3) XOR C(3);
    
    --carefull to not forget this one below
    Cout <= C(4);
    
end Behavioral;