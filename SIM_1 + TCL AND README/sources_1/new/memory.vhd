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
    pop : in  std_logic;
    push : in std_logic;
    clear : in std_logic;
    
    dIN : in std_logic_vector(DATA_WIDTH-1 downto 0);
    dOUTR : out std_logic_vector(DATA_WIDTH-1 downto 0);
    
    pushErrorR : out std_logic := '0';
    popErrorR : out std_logic:= '0';
    isEmptyR : out std_logic:= '1';
    isFullR : out std_logic:= '0';
    stackPtrR: out std_logic_vector(STACK_PTR_DEPTH-1 downto 0) := "000"
    );
end memory;

architecture Behavioral of memory is
  
    --this is the crucial part of the project : the "register-array"
    --YES, you read that right, to make a stack memory, you define a array of registers who are "accessed by" stackPointer
    --Still here we j only define the memory, the access and logic behind it will be in the main module (i think)
    --the following line states : mStack is an array of lenght = 8 and each element in it is long 8 bit
    type mStack is array (0 to STACK_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    
    --but mstack is a custom type so we need a variable now
    --the (other => others =>) is the initialitation of every bit of every word of the array 
    signal mSig : mStack := (others => (others => '0'));    
   
   --stack pointer declaration
    signal sp : std_logic_vector(STACK_PTR_DEPTH-1 downto 0) := (others => '0');    --stack pointer
    
    --temporary register for increment or decremnt of the stack pointer
    signal spInc : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal spDec : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    
    --temporary register for the sp - carry out 
    signal coutTempRegAdd : std_logic;
    
    --buffer version of some of the ports, in fact they arre flags
    signal isFullBuffer : std_logic := '0';
    signal isEmptyBuffer : std_logic := '1';
    
    signal dINR : std_logic_vector(7 downto 0) := (others => '0');
    signal popR : std_logic := '0';
    signal pushR : std_logic := '0';
    signal clearR : std_logic := '0';
        
begin

    incrementer : entity work.rippleCarryAdder     --instance of the ripple carry to increment of 1 the sp
        generic map (
            STACK_PTR_DEPTHR => STACK_PTR_DEPTH
        )
        port map(
            A => sp,
            B => "001",
            Cin => '0',
            ras => spInc,
            Cout => coutTempRegAdd
        );
     decrementer : entity work.rippleCarryAdder      --instance of the ripple carry to decrement of 1 the sp
        generic map (
            STACK_PTR_DEPTHR => STACK_PTR_DEPTH
        )

        port map(
            A => sp,
            B => "111",
            Cin => '0',
            ras => spDec
        );

    process(clkR)
    begin
       if rising_edge(clkR)
	  dINR <= dIN;
          clearR <= clear;
          popR <= pop;
          pushR <= push;
       end if;
    end if;
   
    process(clkR)
    begin 
        
        if(rstR = '1') then
                mSig <= (others => (others => '0'));
                sp <= (others => '0');
                isFullBuffer <= '0';
                isEmptyBuffer <= '1';
                isEmptyR <= '1';
                isFullR <= '0';
                stackPtrR <= "000";
        end if;
        
        --initializing the errors signals
        popErrorR <= '0';
        pushErrorR <= '0';
        
        --looking if we are on a rising edege of the clock
        if rising_edge(clkR) then
            
            --clear operation 
            if(clearR = '1') then                --same as the rst, but different meaning
                mSig <= (others => (others => '0'));
                sp <= (others => '0');
                isFullBuffer <= '0';
                isEmptyBuffer <= '1';
                isEmptyR <= '1';
                isFullR <= '0';
                stackPtrR <= "000";
            end if; 
            
            --in case of PUSH with full stack 
            if (pushR = '1' and isFullBuffer = '1') then
                pushErrorR <= '1';
                popErrorR <= '0';
                isFullR <='1';
                isEmptyR <= '0';
                isEmptyBuffer <= '0';
            end if; 
            
            --push operation
            if(pushR = '1' and isFullBuffer = '0') then
               
               isEmptyR <= '0';               --after a push it's not empty anymore
               isEmptyBuffer <= '0';
               
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
               
               --stack pointer incrementation
               sp <= spInc;
               stackPtrR <= spInc;
               
               if(coutTempRegAdd='1') then               --control if max stack
                    isFullBuffer <= '1';
                    isFullR <= '1';
               end if;
             
            end if;
            
            --case if pop and the stack is empty
            if(popR='1' and isEmptyBuffer='1') then
                popErrorR<='1';
                pushErrorR <='0';
                isEmptyR <='1';
                isFullBuffer <= '0';
                isFullR <= '0';
            end if;
            
            --pop operation
            if(popR='1' and isEmptyBuffer='0') then
                isFullR <= '0';
                isFullBuffer <= '0';
                
                case spDec is
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
                
                --stack pointer decrementation
                sp <=spDec;
                stackPtrR <=spDec;
                
                --signaling an empty stack 
                if(spDec="000") then
                    isEmptyBuffer <= '1';
                    isEmptyR <= '1';
                end if;
                
            end if;
            
        end if; 
        
    end process;
end Behavioral;