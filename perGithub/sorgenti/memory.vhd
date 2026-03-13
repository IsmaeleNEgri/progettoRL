library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory is
    generic (
        DATA_WIDTH : integer := 8;
        STACK_DEPTH : integer := 8;
        STACK_PTR_DEPTH : integer := 4
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        
        pop : in std_logic;
        push : in std_logic;
        invalidate : in std_logic;

        w_addr : in std_logic_vector(2 downto 0);
        r_addr : in std_logic_vector(2 downto 0);

        dIN  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        dOUT : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end memory;

architecture Behavioral of memory is

    type mStack is array (0 to STACK_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal mSig : mStack := (others => (others => '0'));
    signal dOUT_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal push_k : std_logic := '0';
    signal pop_k : std_logic := '0';

begin
    
    process(clk)
    begin
        
        if rst = '1' then
            mSig <= (others => (others => '0'));
    
        elsif rising_edge(clk)then

            if (push = '1' and invalidate = '0') then
                case w_addr is
                    when "000" => mSig(0) <= dIN;
                    when "001" => mSig(1) <= dIN;
                    when "010" => mSig(2) <= dIN;
                    when "011" => mSig(3) <= dIN;
                    when "100" => mSig(4) <= dIN;
                    when "101" => mSig(5) <= dIN;
                    when "110" => mSig(6) <= dIN;
                    when "111" => mSig(7) <= dIN;
                    when others => null;
                end case;
            
            elsif (pop  = '1' and invalidate = '0' )then
               case r_addr is
                    when "000" => dOUT_reg <= mSig(0);
                    when "001" => dOUT_reg <= mSig(1);
                    when "010" => dOUT_reg <= mSig(2);
                    when "011" => dOUT_reg <= mSig(3);
                    when "100" => dOUT_reg <= mSig(4);
                    when "101" => dOUT_reg <= mSig(5);
                    when "110" => dOUT_reg <= mSig(6);
                    when "111" => dOUT_reg <= mSig(7);
                    when others => dOUT_reg <= (others => '0');
                end case;
                
            end if;
         end if;
    end process;
    
    dOUT <= dOUT_reg;
end Behavioral;
