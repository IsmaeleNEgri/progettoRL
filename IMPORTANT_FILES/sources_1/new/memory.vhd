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
        clkR : in std_logic;
        rstR : in std_logic;
        clear : in std_logic;
        pop : in  std_logic;     
        push : in std_logic;
        
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
    
    --stack pointer declaration 
    signal sp : std_logic_vector(STACK_PTR_DEPTH-1 downto 0) := (others => '0');    --stack pointer
    
    
    -- input register signals 
    signal pushR   : std_logic;
    signal popR    : std_logic;
    signal clearR  : std_logic;
    signal dINR    : std_logic_vector(DATA_WIDTH-1 downto 0);
    
    --output register signal
    signal dOUTR : std_logic_vector(DATA_WIDTH-1 downto 0); 

begin
    
    process(clkR, rstR)
    begin
        if(rstR = '1') then
                mSig <= (others => (others => '0'));
                sp <= (others => '0');

        --looking if we are on a rising edge of the clock
        elsif rising_edge(clkR) then
        
            pushR <= push;
            popR <= pop;
            clearR <= clear;
            dINR <= dIN;
                        
            --clear operation 
            if(clearR = '1') then                --same as the rst, but different meaning
                mSig <= (others => (others => '0'));
                sp <= (others => '0');
              
                                     
            elsif(push = '1') then            --PUSH operation  
               --after a push it's not empty anymore
               
               case sp is
                   when "000" => mSig(0) <= dINR;
                   when "001" => mSig(1) <= dINR;
                   when "010" => mSig(2) <= dINR;
                   when "011" => mSig(3) <= dINR;
                   when "100" => mSig(4) <= dINR;
                   when "101" => mSig(5) <= dINR;
                   when "110" => mSig(6) <= dINR;
                   when "111" => mSig(7) <= dINR;
                   when others => null;
               end case;
               
                
            elsif(pop='1') then            --POP operation
                  
                case sp is
                   when "000" => dOUTR <= mSig(0);
                   when "001" => dOUTR <= mSig(1);
                   when "010" => dOUTR <= mSig(2);
                   when "011" => dOUTR <= mSig(3);
                   when "100" => dOUTR <= mSig(4);
                   when "101" => dOUTR <= mSig(5);
                   when "110" => dOUTR <= mSig(6);
                   when "111" => dOUTR <= mSig(7);
                   when others => null;
                end case;
            end if;
                    
        end if;
    end process;
    
end Behavioral;