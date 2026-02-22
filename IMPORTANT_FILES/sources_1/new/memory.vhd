library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory is
    generic (
        DATA_WIDTH : integer := 8;
        STACK_DEPTH : integer := 8;
        STACK_PTR_DEPTH : integer := 3
    );
    
    --all the in and out signals
    port(
        clk : in std_logic;
        rst : in std_logic;
        clear : in std_logic;
        pop : in  std_logic;     
        push : in std_logic;
        sp : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        
        dIN : in std_logic_vector(DATA_WIDTH-1 downto 0);
        dOUT : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );

end memory;

architecture Behavioral of memory is

    --this is the crucial part of the project : the "register-array"
    --Still here we only define the memory, the access and logic behind it will be in the main module (i think)
    --the following line states : mStack is a type representing an array of lenght = 8 and each element in it is long 8 bit
    type mStack is array (0 to STACK_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal mSig : mStack := (others => (others => '0'));

begin
    
    process(clk, rst)
    begin
        if rising_edge(clk) then
                                
            if(push = '1') then            --PUSH operation  
               --after a push it's not empty anymore
               
               case sp is
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
               
                
            elsif(pop='1') then            --POP operation
                  
                case sp is
                   when "000" => dOUT <= mSig(0);
                   when "001" => dOUT <= mSig(1);
                   when "010" => dOUT <= mSig(2);
                   when "011" => dOUT <= mSig(3);
                   when "100" => dOUT <= mSig(4);
                   when "101" => dOUT <= mSig(5);
                   when "110" => dOUT <= mSig(6);
                   when "111" => dOUT <= mSig(7);
                   when others => null;
                end case;
            end if;
                    
        end if;
    end process;
    
end Behavioral;