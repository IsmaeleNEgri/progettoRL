library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;

entity memory is
    
    generic(
        --stack depth
        depth : integer := 8;
        --data max width
        dWidth : integer := 8
        );

    port(
    clk : in std_logic;
    rst : in std_logic;
    pop : in  std_logic;
    push : in std_logic;
    clear : in std_logic;
    
    dIN : in std_logic_vector(dWidth -1 downto 0);
    dOUT : out std_logic_vector(dWidth - 1 downto 0);
    
    pushError : out std_logic;
    popError : out std_logic;
    isEmpty : out std_logic;
    isFull : out std_logic  
    );
end memory;

architecture Behavioral of memory is
  
    --this is the crucial part of the project : the "register-array"
    --YES, you read that right, to make a stack memory, you define a array of registers who are "accessed by" stackPointer
    --Still here we jìonly define the memory, the access and logic behind it will be in the main module (i think)
    --the following line states : mStack is an array of (depth -1) lenght and each element in it is long (dwith-1)(bit)
    type mStack is array (0 to depth -1) of std_logic_vector(dWidth -1 downto 0);
    
    --but mstack is a custom type so we need a variable now
    --the (other => others =>) is the initialitation of every bit of every word of the array 
    signal mSig : mStack := (others => (others => '0'));
    
    --in order to make the operations syncronized with the clock, it is necessary to use a temporary register
    --It is not needed with dIN since it happens only on the rising edge of the clock
    signal tempOutReg : std_logic_vector(dWidth-1 downto 0) := (others => '0' );
    
    --stack pointer 
    signal sp : std_logic_vector(2 downto 0) := (others => '0');
    --temporary register for increment or decremnt of the stack pointer
    signal spInc : std_logic_vector(2 downto 0) := (others => '0');
    signal spDec : std_logic_vector(2 downto 0) := (others => '0');
    
    --TO BE VERIFIED THE USE OF THE BUFFER FOR THE COUT
    signal coutTempReg : std_logic := '0';
    
    --buffer version of some of the ports, in fact they arre flags
    signal pushErrBuffer : std_logic := '0';
    signal popErrBuffer : std_logic := '0';
    signal isFullBuffer : std_logic := '0';
    signal isEmptyBuffer : std_logic := '1';
    
    
    --the extra 'R' stand for register cause i dont want to get confuse with other similar signals
    component inputReg 
        port(
            clkR : in std_logic;
            rstR : in std_logic;
            popR : in  std_logic;
            pushR : in std_logic;
            clearR : in std_logic;
            
            dinR : in std_logic_vector(dWidth -1  downto 0)
        );
        end component;
        
     component outputReg
         port(
            clkR : in std_logic;
            rstR : in std_logic;
            spR : in std_logic_vector(2 downto 0);
            
            --donI is the input of the output register
            donIR : in std_logic_vector(dWidth -1  downto 0);
            stackOut : out std_logic_vector(depth * dWidth -1 downto 0);
                
            --TO BE VERIFIED
            singleDOutR : out std_logic_vector(dWidth -1 downto 0);
    
            isEmptyR : out std_logic;
            isFullR : out std_logic 
        );
        end component;
        
        signal index : integer;
    
begin
    
    --instance of the ripple carry to increment of 1 the sp
    incrementer : entity work.rippleCarryAdder 
        port map(
            A => sp,
            B => "001",
            Cin => '0',
            ras => spInc,
            Cout => coutTempReg
        );
        
      --instance of the ripple carry to decrement of 1 the sp
     decrementer : entity work.rippleCarryAdder
        port map(
            A => sp,
            B => "111",
            Cin => '0',
            ras => spDec,
            Cout => coutTempReg
        );
        
    iReg : inputReg
    port map(
      clkR    => clk,
      rstR    => rst,
      dinR   => dIN,
      pushR   => push,
      popR   => pop,
      clearR => clear
    );

     
    --when the memory "start" it is empty and not full (TO BE VERIFIED)
    isEmpty <= '1';
    isFull  <= '0';
    
    process(clk)     
    
    begin 
    
        if rising_edge(clk) then 
        --the following lines are for when appear the rst "signal"
            if(rst = '1') then
                mSig <= (others => (others => '0'));
                tempOutReg <= (others => '0');
                sp <= (others => '0');
                pushErrBuffer <= '0';
                popErrBuffer <= '0';
                isFullBuffer <= '0';
                isEmptyBuffer <= '1';
            end if;
            
            --the following lines till the next if are for the clear
            if(clear = '1') then
                --same as the rst, but different meaning
                mSig <= (others => (others => '0'));
                tempOutReg <= (others => '0');
                sp <= (others => '0');
                pushErrBuffer <= '0';
                popErrBuffer <= '0';
                isFullBuffer <= '0';
                isEmptyBuffer <= '1';
            end if; 
            
            --in case of push with full stack 
            if (push = '1' and isFullBuffer = '1') then
                pushErrBuffer <= '1';  
            end if; 
            
             --push operation
            if(push = '1' and isFullBuffer = '0') then
               index <= to_integer(unsigned(sp));
               mSig(index) <= dIN;
               --for some reason the increment work this way
               sp <= spInc;
                
               --the transformation to integer index of the sp needs to be done again as it is needed for the isFull "signal"
               index <= to_integer(unsigned(sp)); 
               
               --control if max stack
               if(index = depth - 1) then
                    isFullBuffer <= '1';
               end if;
               
               --after a push in not empty anymore
               isEmpty <= '0';
             
            end if;
            
        end if;
    end process;
    
    dOUT <= tempOutReg;              
  
end Behavioral;
