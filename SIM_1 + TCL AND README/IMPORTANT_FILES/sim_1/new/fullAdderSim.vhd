library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fullAdderSim is
end fullAdderSim;

architecture Behavioral of fullAdderSim is

    component fullAdder
        Port (
            a : in  STD_LOGIC;
            b : in  STD_LOGIC;
            cin : in  STD_LOGIC;
            sum : out STD_LOGIC;
            cout : out STD_LOGIC
        );
    end component;

    signal a, b, cin : STD_LOGIC := '0';
    signal sum, cout : STD_LOGIC;

begin
    uut: fullAdder
        port map (
            a => a,
            b => b,
            cin => cin,
            sum => sum,
            cout => cout
        );

    stim_proc: process
    begin
        for k in 0 to 1 loop    --k is Cin
            for i in 0 to 1 loop        --i is a
                for j in 0 to 1 loop        --j is b
                
                case i is
                    when 0 => a <= '0';
                    when 1 => a <= '1';
                    when others => a <= 'U';
                end case;

                case j is
                    when 0 => b <= '0';
                    when 1 => b <= '1';
                    when others => b <= 'U';
                end case;

                if k = 0 then
                    Cin <= '0';
                else
                    Cin <= '1';
                end if;
                wait for 10 ns;
                end loop;
            end loop;
        end loop;
        wait;
    end process;
end Behavioral;