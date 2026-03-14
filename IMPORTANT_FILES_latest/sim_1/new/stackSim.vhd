
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stackSim is
    generic (
    DATA_WIDTH : integer := 8;     
    STACK_DEPTH : integer := 8;
    STACK_PTR_DEPTH : integer := 3
    );    
end stackSim;

architecture Behavioral of stackSim is

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal pop : std_logic := '0';
    signal push : std_logic := '0';
    signal clear : std_logic := '0';
    signal dIN : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => 'U');
    signal dOUT : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal pushError : std_logic;
    signal popError : std_logic;
    signal isEmpty : std_logic;
    signal isFull : std_logic;  
    signal sp_debug : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal do_pop_debug : std_logic;
    signal do_push_debug : std_logic;
    signal mSig_debug : std_logic_vector(DATA_WIDTH*STACK_DEPTH-1 downto 0);
    signal B_sum_debug : std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
    signal Cout_debug : std_logic;
    signal isFullBuffer: std_logic;
    signal isEmptyBuffer: std_logic;
    
    constant clk_period : time := 50 ns;
    
    --test values
    type arr is array (0 to STACK_DEPTH) of std_logic_vector(DATA_WIDTH-1 downto 0);
    constant test_values : arr := (
        "00001010",  -- 10
        "00001011",  -- 11
        "00001100",  -- 12
        "00001101",  -- 13
        "00001110",  -- 14
        "00001111",  -- 15
        "00010000",  -- 16
        "00010001",  -- 17  
        "11111111"  --255 is used as a bait to trigger pushError
    );
    
    begin
        clk_process : process
        begin
            clk <= '0';
            wait for clk_period /2 ;
            clk <= '1';
            wait for clk_period /2 ;
        end process;
        
        -------------------------------------------------------------------------------------
        
        --real testing process, for the memory module
        uut: entity work.stack
            port map (
                clk => clk, 
                rst => rst,
                pop => pop,
                push => push,
                clear => clear,
                dIN => dIN,
                dOUT => dOUT,
                pushError => pushError,
                popError => popError,
                isEmpty => isEmpty,
                sp_debug => sp_debug,
                do_pop_debug => do_pop_debug,
                do_push_debug => do_push_debug,
                mSig_debug => mSig_debug,
                Cout_debug => Cout_debug,
                B_sum_debug => B_sum_debug,
                isFullBuffer => isFullBuffer,
                isEmptyBuffer => isEmptyBuffer,
                isFull => isFull
            );
        
        stim_proc: process  
        begin
            rst <= '1';
            wait for clk_period;
            rst <= '0';
            wait for clk_period;
            
            ---------------------------------------------------
            --simutaneous pop and push with "low load" stack
            pop <= '1';
            push <= '1';
            dIN <= "11111111";
            wait for clk_period;
            pop <= '0';
            push <= '0';
            wait for clk_period;
            
            --pop to return to the "original state"
            pop <= '1';
            wait for clk_period;
            pop <= '0';
            wait for clk_period;
            --------------------------------------------------
                    
            pop <= '1';        --Testing if pop works at the start of the simulation, with 0 elements in the stack, should show PopError = '1'
            wait for clk_period;
            pop <= '0';
            wait for clk_period;
            
            pop <= '1';
            wait for clk_period;
            pop <= '0';
            wait for clk_period;
        
            dIN <= "01001001";         --push 1 value and then we see if "popping" twice shows the first time the first input, and the second time another PopError
            push <= '1';
            wait for clk_period;
            push <= '0';
            wait for clk_period;

            pop <= '1';
            wait for clk_period;
            
            pop <= '0';
            wait for clk_period;
            pop <= '1';
            wait for clk_period;

            pop <='0';
            wait for clk_period;
        
            -------------------------------------------------------------
            dIN <= "01001001";                --push 1 value and then we see if "clearing" shows the first time that "isEmpty" is '1', and then we set pop to '1' to see the popError
            push <= '1';
            wait for clk_period;
            push <= '0';
            wait for clk_period;
            clear <= '1';
            wait for clk_period;
            clear <= '0';
            wait for clk_period;
            pop <= '1';
            wait for clk_period;
            pop <= '0';
            wait for clk_period;
            ----------------------------------------------------------------
            
            ----------------------------------------------------------------
            dIn <= "11010001";    -- push 2 items consecutive to check if rst works independently from the rising_edge
            push <= '1';
            wait for clk_period;
            push <= '0';
            dIn <= "00101010";
            push <= '1';
            wait for clk_period;
            push <= '0';
            wait for clk_period;
            clear <= '1';        -- since the rst is only at activation of the network, then this part is not needed for rst testing anymore, so switch to clear
            wait for clk_period;
            clear <= '0';
            wait for clk_period;
            ------------------------------------------------------------------
            
            for i in 0 to STACK_DEPTH-1 loop        --Fill stack completely (isFull should appear as '1')
                dIN <= test_values(i);
                push <= '1';
                wait for clk_period;
                push <= '0';
                wait for clk_period;    
            end loop;
            
            -------------------------------------------------
            --simutaneous pop and push with "high load" stack
            pop <= '1';
            push <= '1';
            wait for clk_period;
            pop <= '0';
            push <= '0';
            wait for clk_period;
            
            --pop to return to the "original state"
            push <= '1';
            dIN <= "11111111";
            wait for clk_period;
            push <= '0';
            wait for clk_period;
            
            --clear the entire stack
            clear <= '1';
            wait for clk_period;
            clear <= '0';
            wait for clk_period;
            --------------------------------------------------
        
            for i in 0 to STACK_DEPTH loop        --Fill stack completely again and then we add another element to trigger pushError
                dIN <= test_values(i);
                push <= '1';
                wait for clk_period;
                push <= '0';
                wait for clk_period;
            end loop;
            
            
            for i in 0 to STACK_DEPTH loop            --pop all elements +1 and we'll get a popError
                pop <= '1';
                wait for clk_period;
                pop <= '0'; 
                wait for clk_period;
            end loop;


            wait;
        end process;
end Behavioral;
