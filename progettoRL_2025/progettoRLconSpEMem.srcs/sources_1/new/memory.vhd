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
    --the addr is defined by the same function used by the stack pointer 
    addr : in std_logic_vector(minBitNecessary(depth -1) downto 0) ;
    dIN : in std_logic_vector(dWidth -1 downto 0);
    dOUT : out std_logic_vector(dWidth - 1 downto 0)
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
    
begin


end Behavioral;
