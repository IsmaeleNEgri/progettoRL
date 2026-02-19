library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux2 is
    Port(
        D: in STD_LOGIC_VECTOR(1 downto 0);
        S: in STD_LOGIC;
        Y: out STD_LOGIC
    );
end Mux2;

architecture Behavioral of Mux2 is

begin
    process(D,S)
    begin
        case S is
            when '0' =>
                Y <= D(0);
            when '1' =>
                Y <= D(1);
        end case;
    end process;

end Behavioral;
