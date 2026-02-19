library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity stack is
    generic (
        DATA_WIDTH : integer := 8;
        STACK_DEPTH : integer := 8;
        STACK_PTR_DEPTH : integer := 3
    );
    
    --all the in and out signals
    port(
        clk : in std_logic;
        rst : in std_logic;
        pop : in  std_logic;     
        push : in std_logic;
        clear : in std_logic;
        
        dIN : in std_logic_vector(DATA_WIDTH-1 downto 0);
        dOUT : out std_logic_vector(DATA_WIDTH-1 downto 0);
        
        pushError : out std_logic;
        popError : out std_logic;
        isEmpty : out std_logic;
        isFull : out std_logic
    );
end stack;


architecture Behavioral of stack is

    component memory is 
        generic(
            DATA_WIDTH: integer;
            STACK_DEPTH: integer;
            STACK_PTR_DEPTH: integer
        );
        port(
            rst: in std_logic;
            clk : in std_logic;
			din : in std_logic_vector(DATA_WIDTH - 1 downto 0);
			dout: out std_logic_vector(DATA_WIDTH - 1 downto 0)
        );
    end component;



    --this is the crucial part of the project : the "register-array"
    --Still here we only define the memory, the access and logic behind it will be in the main module (i think)
    --the following line states : mStack is a type representing an array of lenght = 8 and each element in it is long 8 bit
    type mStack is array (0 to STACK_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal mSig : mStack := (others => (others => '0'));
    
    
    signal sp : std_logic_vector(STACK_PTR_DEPTH-1 downto 0) := (others => '0');    --stack pointer 
    signal do_push : std_logic;
    signal do_pop : std_logic;
    signal B_sum : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    

    signal spNext : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);    --result of incrementer_decrementer
    signal Cout : std_logic;    --register of carry out 
    
    --buffer version of some of the ports, in fact they are flags
    signal isFullBuffer : std_logic := '0';
    signal isEmptyBuffer : std_logic := '1'; 

begin
    --selection of push or pop
    B_sum <= "001" when do_push ='1' 
        else "111" when do_pop ='1'
        else (others => '0');
        
    do_push <= '1' when (push = '1' and isFullBuffer = '0') and 
        (pop = '0' or (sp = "000" or sp = "001" or sp = "010" or sp = "011"))
        else '0';
    do_pop <= '1' when (pop  = '1' and isEmptyBuffer = '0' and do_push = '0') 
        else '0';


    incrementer_decrementer : entity work.rippleCarryAdder     --instance of the ripple carry to increment of 1 the sp
        generic map (
            STACK_PTR_DEPTHR => STACK_PTR_DEPTH
        )
        port map(
            A => sp,
            B => B_sum,
            Cin => '0',
            ras => spNext,
            Cout => Cout
        );
    
    process(clk, rst)
    begin
    if(rst = '1') then
                mSig <= (others => (others => '0'));
                sp <= (others => '0');
                isFullBuffer <= '0';
                isEmptyBuffer <= '1';
                popError <= '0';
                pushError <= '0';

        --looking if we are on a rising edge of the clock
        elsif rising_edge(clk) then
            
            popError <= '0';
            pushError <= '0';
                        
            --clear operation 
            if(clear = '1') then                --same as the rst, but different meaning
                mSig <= (others => (others => '0'));
                sp <= (others => '0');
                isFullBuffer <= '0';
                isEmptyBuffer <= '1';
                
            --only push
            elsif (push = '1' and isFullBuffer = '1') then            --in case of PUSH with full stack 
                pushError <= '1';
                                     
            elsif(do_push='1') then            --PUSH operation  
               --after a push it's not empty anymore
               isEmptyBuffer <= '0';
               
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
               
               --stack pointer incrementation
               sp <= spNext;
               
               if(Cout='1') then               --control if max stack
                    isFullBuffer <= '1';
               end if;
             
            --only pop
            elsif(pop='1' and isEmptyBuffer='1') then            --case if pop and the stack is empty
                popError<='1';
                
            elsif(do_pop='1') then            --POP operation
                isFullBuffer <= '0';
                  
                case spNext is
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
                
                --stack pointer decrementation
                sp <=spNext;
         
                --signaling an empty stack 
                if(spNext="000") then
                    isEmptyBuffer <= '1';
                                      
                end if;
            end if;   
                    
        end if;
    end process;
    
    --"passing" signals to their out counter part, by register 
    process(clk, rst)
    begin
        if rising_edge(clk) then
        
            isEmpty <= isEmptyBuffer;
            isFull <= isFullBuffer;

        end if;
    end process;
    
    memory_unit: memory
        generic map(
            STACK_DEPTH => STACK_DEPTH,
            DATA_WIDTH => DATA_WIDTH,
            STACK_PTR_DEPTH => STACK_PTR_DEPTH
        )
        port map(
            clk =>clk,
            rst => rst,
            din => din,
			dout => dout
        );

end Behavioral;
