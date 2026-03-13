library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    generic (
        DATA_WIDTH : integer := 8;
        STACK_DEPTH : integer := 8;
        STACK_PTR_DEPTH : integer := 4
    );
    port (
    clk       : in  std_logic;
    RST       : in  std_logic; -- async active-high
    CLEAR     : in  std_logic; -- sync
    DIN       : in  std_logic_vector(7 downto 0);
    PUSH      : in  std_logic;
    POP       : in  std_logic;
    DOUT      : out std_logic_vector(7 downto 0);
    ISFULL    : out std_logic;
    ISEMPTY   : out std_logic;
    PUSHERROR : out std_logic;
    POPERROR  : out std_logic
  );
end top_level;


architecture Behavioral of top_level is
       
    --memory address signals
    signal w_addr : std_logic_vector(2 downto 0);
    signal r_addr : std_logic_vector(2 downto 0);
    --operation address
    signal sp_reg : std_logic_vector(3 downto 0) := "0000";
    signal invalidate_reg : std_logic := '0';
    
begin
    
    ctrl_wrapper : entity work.wrapper
    port map(
        clk => clk,
        rst => RST,
        clear => CLEAR,
        push => PUSH,
        pop => POP,
        sp_out => sp_reg,
        w_addr => w_addr,
        r_addr => r_addr,
        popError => POPERROR,   
        pushError => PUSHERROR,
        isEmpty => ISEMPTY,
        isFull => ISFULL,
        invalidate => invalidate_reg
    );
    
    memory : entity work.memory
    generic map(
        DATA_WIDTH => DATA_WIDTH,
        STACK_DEPTH => STACK_DEPTH,
        STACK_PTR_DEPTH => STACK_PTR_DEPTH
    )
    port map(
        clk => clk,
        rst => RST,
        pop => POP,
        push => PUSH,
        w_addr => w_addr,
        r_addr => r_addr,
        invalidate => invalidate_reg,
        dIN => DIN,
        dOUT => DOUT
    );

end Behavioral;
