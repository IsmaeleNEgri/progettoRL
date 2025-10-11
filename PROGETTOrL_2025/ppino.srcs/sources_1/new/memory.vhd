library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--to use the package where i placed the function for the stackPointer and the memory
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
    signal spTempReg : std_logic_vector(2 downto 0) := (others => '0');
    
    --TO BE VERIFIED THE USE OF THE BUFFER FOR THE COUT
    signal coutTempReg : std_logic := '0';
    
    --buffer version of some of the ports
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
            
            dinR : in std_logic_vector(dWidth -1  downto 0);
            --dinO is the output of the input register
            dinOR : out std_logic_vector(dWidth -1 downto 0);
    
            pushErrorR : out std_logic;
            popErrorR : out std_logic;
            isEmptyR : out std_logic;
            isFullR : out std_logic 
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
    
begin
    
    incrementer : entity work.rippleCarryAdder 
        port map(
            A => sp,
            B => "001",
            Cin => '0',
            ras => spTempReg,
            Cout => coutTempReg
        );
    
     decrementer : entity work.rippleCarryAdder
        port map(
            A => sp,
            B => "111",
            Cin => '0',
            ras => spTempReg,
            Cout => coutTempReg
        );
        
     
     
      --when the memory "start" it is empty and not full (TO BE VERIFIED)
    isEmpty <= '1';
    isFull  <= '0';
    
    process(clk, rst, pop, push, dIN) 
    begin 
        if rising_edge(clk) then 
        
            --reset operation
            if(rst = '1') then
                tempOutReg <= (others => '0');
                mSig <= (others => (others => '0'));
                isEmpty <= '1';
            end if;
            
            --push operation
            if(push = '1' and isFull = '0') then
               mSig(addr) <= dIN;
               addr <= addr +1;
                
               if(addr = depth - 1) then
                    isFull <= '1';
               end if;
               
               --after a push in not empty anymore
               isEmpty <= '0';
            
            --in case of push with full stack 
            else if (push = '1' and isFull = '1') then
                pushError <= '1';  
            end if; 
            
            end if;
            
            --pop operation
            if(pop = '1' and isEmpty = '0') then 
                tempOutReg <= mSig(addr);
                mSig(addr) <= (others => '0');
                addr <= addr -1;
                
                if (addr = 0) then
                    isEmpty <= '1';
                end if;
                
                --after a pop is not full anymore
                isFull <= '0';
                
            --in case of pop with empty stack    
            else if (pop = '1' and isEmpty = '1') then
                popError <= '1';
            end if;
            
            end if;          
            
            --in case the errors have a job except to skip an instruction
             if (pushError = '1' or popError = '1') then
                error <= '1';
             end if;
             
        end if;
    end process;
    
    dOUT <= tempOutReg;              
  
end Behavioral;
