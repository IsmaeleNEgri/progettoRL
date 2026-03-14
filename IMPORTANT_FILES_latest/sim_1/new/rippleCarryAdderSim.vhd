library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rippleCarryAdderSim is    
end rippleCarryAdderSim;

architecture Behavioral of rippleCarryAdderSim is
    constant STACK_PTR_DEPTHR : integer := 3;
    
    component rippleCarryAdder
        port (
            A : in  std_logic_vector(STACK_PTR_DEPTHR-1 downto 0);
            B : in  std_logic_vector(STACK_PTR_DEPTHR-1 downto 0);
            Cin : in  std_logic;
            ras : out std_logic_vector(STACK_PTR_DEPTHR-1 downto 0);
            Cout : out std_logic
        );
    end component;

    signal A, B : std_logic_vector(STACK_PTR_DEPTHR-1 downto 0) := (others => '0');
    signal Cin : std_logic := '0';
    signal ras : std_logic_vector(STACK_PTR_DEPTHR-1 downto 0);
    signal Cout : std_logic;

begin
    uut: rippleCarryAdder
        port map (
            A => A,
            B => B,
            Cin => Cin,
            ras => ras,
            Cout => Cout
        );
        
    stim_proc: process
        variable a_int, b_int : integer;
        variable sum_expected : integer;
    begin
        for k in 0 to 1 loop    --k is Cin
            for i in 0 to 7 loop        --i is A
                for j in 0 to 7 loop        --j is B
                    case i is
                    when 0 => A <= "000";
                    when 1 => A <= "001";
                    when 2 => A <= "010";
                    when 3 => A <= "011";
                    when 4 => A <= "100";
                    when 5 => A <= "101";
                    when 6 => A <= "110";
                    when 7 => A <= "111";
                    when others => A <= (others => 'U');
                end case;

                case j is
                    when 0 => B <= "000";
                    when 1 => B <= "001";
                    when 2 => B <= "010";
                    when 3 => B <= "011";
                    when 4 => B <= "100";
                    when 5 => B <= "101";
                    when 6 => B <= "110";
                    when 7 => B <= "111";
                    when others => B <= (others => 'U');
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