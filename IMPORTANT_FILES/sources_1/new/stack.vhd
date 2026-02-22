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
    
    signal sp : std_logic_vector(STACK_PTR_DEPTH-1 downto 0) := (others => '0');    --stack pointer 
    signal do_push : std_logic;
    signal do_pop : std_logic;
    signal B_sum : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    

    signal spNext : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);    --result of incrementer_decrementer
    signal Cout : std_logic;    --register of carry out 
    
    --buffer version of some of the ports, in fact they are flags
    signal isFullBuffer : std_logic := '0';
    signal isEmptyBuffer : std_logic := '1'; 
    signal half_ok : std_logic;



begin

    incrementer_decrementer : entity work.rippleCarryAdder     --instance of the ripple carry to increment or decrement of 1 the sp
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
    
    memory_unit: entity work.memory
        generic map(
            STACK_DEPTH => STACK_DEPTH,
            DATA_WIDTH => DATA_WIDTH,
            STACK_PTR_DEPTH => STACK_PTR_DEPTH
        )
        port map(
            clk =>clk,
            rst => rst,
			clear => clear,
			pop => pop,
			push => push,
			sp => sp,
			
            din => din,
			dout => dout
        );
        
    selector_unit : entity work.Push_Pop_Selector
    generic map(
        STACK_PTR_DEPTH => STACK_PTR_DEPTH
    )
    port map(
        push => push,
        pop => pop,
        isFullBuffer => isFullBuffer,
        isEmptyBuffer => isEmptyBuffer,
        sp => sp,
        do_push => do_push,
        do_pop => do_pop,
        B_sum => B_sum
    );

        
    process(clk, rst)
    begin
    if(rst = '1') then
            sp <= (others => '0');
            isFullBuffer <= '0';
            isEmptyBuffer <= '1';
            popError <= '0';
            pushError <= '0';

        elsif rising_edge(clk) then        --looking if we are on a rising edge of the clock
            
            popError <= '0';
            pushError <= '0';
                        
            if(clear = '1') then                --same as the rst, but different meaning
            
                sp <= (others => '0');
                isFullBuffer <= '0';
                isEmptyBuffer <= '1';
                
-----------------------------------------------------------------------------------------------------
            elsif (push = '1' and isFullBuffer = '1') then            --in case of PUSH with full stack 
                pushError <= '1';
                                     
            elsif(do_push='1') then            --PUSH operation  

               isEmptyBuffer <= '0';               --after a push it's not empty anymore
               sp <= spNext;               --stack pointer incrementation
               
               if(Cout='1') then               --control if max stack
                    isFullBuffer <= '1';
               end if;
             
-----------------------------------------------------------------------------------------------------
            elsif(pop='1' and isEmptyBuffer='1') then            --case if pop and the stack is empty
                popError<='1';
                
            elsif(do_pop='1') then            --POP operation
            
                isFullBuffer <= '0';        --after popping, the stack isn't full anymore
                sp <=spNext;        --stack pointer decrementation
         
                if(spNext="000") then                --signaling an empty stack 
                
                    isEmptyBuffer <= '1';
                                     
                end if;
            end if;
                    
        end if;
        
        --"passing" signals to their out counter part, by register 
        isEmpty <= isEmptyBuffer;
        isFull <= isFullBuffer;
        
    end process;
    
    

end Behavioral;
