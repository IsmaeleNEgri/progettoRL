library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--to use the package where i placed the function for the stackPointer and the memory
library work;
use work.depthMinCalc.all;

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
    dIN : in std_logic_vector(dWidth -1 downto 0);
    dOUT : out std_logic_vector(dWidth - 1 downto 0);
    --error is TO BE VERIFIED
    error : out std_logic
    );
end memory;

architecture Behavioral of memory is

    --the addr is defined by the same function used by the stack pointer 
    signal addr : integer := minBitNecessary(depth-1);
    
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
    
   --temporary measure for 4 out signal (TO BE VERIFIED)
    signal pushError :  std_logic;
    signal popError :  std_logic;
    signal isFull :  std_logic;
    signal isEmpty :  std_logic; 
    
begin
 
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
