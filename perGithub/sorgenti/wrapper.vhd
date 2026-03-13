library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity wrapper is
    port(
        rst : in std_logic;
        clk     : in  std_logic;
        clear   : in  std_logic; -- sync
        push : in  std_logic; 
        pop : in  std_logic;
        
        popError : out std_logic;   
        pushError : out std_logic;
        isEmpty : out std_logic;
        isFull : out std_logic; 
        invalidate : out std_logic;
    
        sp_out  : out std_logic_vector(3 downto 0);
        w_addr : out std_logic_vector(2 downto 0);
        r_addr : out std_logic_vector(2 downto 0)
    );
end wrapper;

architecture Behavioral of wrapper is
     
     signal sp_reg : std_logic_vector(3 downto 0);
     signal empty_reg : std_logic;
     signal full_reg : std_logic;
     
     
begin

    sp_calc : entity work.sp_calc
    port map(
        clk => clk,
        rst => rst,
        clear => clear,
        push => push,
        pop => pop,
        w_addr => w_addr,
        r_addr => r_addr,
        full_out => full_reg,
        empty_out => empty_reg
    );
    
    sae : entity work.status_and_error
    port map(
        clk => clk,
        rst => rst,
        clear => clear,
        push => push,
        pop => pop,
        empty_in => empty_reg,
        full_in => full_reg,
        popError => popError,
        pushError => pushError,
        isEmpty => isEmpty,
        isFull => isFull,
        invalidate => invalidate       
    );


end Behavioral;
