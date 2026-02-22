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
    
    signal isFullBuffer : std_logic := '0';    --buffer version of some of the ports, in fact they are flags
    signal isEmptyBuffer : std_logic := '1'; 
    signal half_ok : std_logic;
    
    signal sp_sig        : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal isFull_sig    : std_logic;
    signal isEmpty_sig   : std_logic;

begin

    sp_sig <= (others => '0') when clear = '1' else
           spNext when (do_push = '1' or do_pop ='1') else
           sp;

    isEmpty_sig <= '1' when (clear = '1' or (do_pop = '1' and spNext = "000")) else
           '0' when do_push = '1' else
           isEmptyBuffer;

    isFull_sig <= '0' when (clear = '1' or do_pop ='1') else
           '1' when (do_push = '1' and Cout = '1') else
           isFullBuffer;

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
			push => push,
			pop => pop,
			sp => sp,
			
            din => din,
			dout => dout
        );
        
    selector_unit : entity work.Push_Pop_Selector
    generic map(
        STACK_PTR_DEPTH => STACK_PTR_DEPTH
    )
    port map(
        clk=>clk,
        rst => rst,
        push => push,
        pop => pop,
        isFullBuffer => isFullBuffer,
        isEmptyBuffer => isEmptyBuffer,
        sp => sp,
        do_push => do_push,
        do_pop => do_pop,
        B_sum => B_sum
    );
    
    status_controller : entity work.status_controller
    port map(
        clk =>clk,
        rst => rst,
        push => push,
        pop => pop,
        isFullBuffer => isFullBuffer,
        isEmptyBuffer => isEmptyBuffer,
        pushError => pushError,
        popError => popError
    );
        
    process(clk, rst)
    begin
    if(rst = '1') then
    
        sp <= (others => '0');
        isFullBuffer <= '0';
        isEmptyBuffer <= '1';

    elsif rising_edge(clk) then        --looking if we are on a rising edge of the clock
                    
        sp <= sp_sig;
        isFullBuffer <= isFull_sig;
        isEmptyBuffer <= isEmpty_sig;
                
    end if;
        
    end process;
    
    isEmpty <= isEmptyBuffer;    --"passing" signals to their out counter part, by register 
    isFull <= isFullBuffer;
    
end Behavioral;
