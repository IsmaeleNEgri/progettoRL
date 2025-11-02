library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memorySim is
    generic (
    DATA_WIDTH : integer := 8;     
    STACK_DEPTH : integer := 8;
    STACK_PTR_DEPTH : integer := 3
    );    
end memorySim;

architecture Behavioral of memorySim is
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
    signal stackPointer: std_logic_vector(STACK_PTR_DEPTH-1 downto 0);
        
    --------------------------------------------------------------------------------------
    --this is called shadow memory. it's a copy of the memory for testbench purpose only
    type tb_mem_shadow is array(0 to STACK_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal tb_shadowMem : tb_mem_shadow := (others => (others => '0')); 
    --since it does not affect the memory functionality i used a 
    signal tb_sp  : integer range 0 to STACK_DEPTH := 0;       
    
    ---------------------------------------------------------------------------------------
    
    constant clk_period : time := 80 ns;
    
    type arr is array (0 to STACK_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    constant test_values : arr := (
        "00001010",  -- 10
        "00001011",  -- 11
        "00001100",  -- 12
        "00001101",  -- 13
        "00001110",  -- 14
        "00001111",  -- 15
        "00010000",  -- 16
        "00010001"   -- 17  
    );
    
    begin
        clk_process : process
        begin
            clk <= '0';
            wait for clk_period /2 ;
            clk <= '1';
            wait for clk_period /2 ;
        end process;
        
        ---------------------------------------------------------------------------------------

        shadow_update_process : process(clk)            --indipendent process used to update the shadow memory
        begin
          if rising_edge(clk) then
            if rst = '1' or clear = '1' then
              tb_shadowMem <= (others => (others => '0'));
              tb_sp <= 0;
            else
              if push = '1' and pop = '0' then
                if tb_sp < STACK_DEPTH then
                  tb_shadowMem(tb_sp) <= dIN;
                  tb_sp <= tb_sp + 1;
                end if;
              elsif pop = '1' and push = '0' then
                if tb_sp > 0 then
                  tb_shadowMem(tb_sp - 1) <= (others => '0');
                  tb_sp <= tb_sp - 1;
                end if;
              elsif push = '1' and pop = '1' then
                if tb_sp = 0 then
                  tb_shadowMem(tb_sp) <= dIN;
                  tb_sp <= tb_sp + 1;
                else
                  tb_shadowMem(tb_sp-1) <= dIN;
                end if;
              end if;
            end if;
          end if;
        end process;
        -------------------------------------------------------------------------------------
        
        uut: entity work.memory
            port map (
                clkR => clk,
                rstR => rst,
                popR => pop,
                pushR => push,
                clearR => clear,
                dINR => dIN,
                dOUTR => dOUT,
                pushErrorR => pushError,
                popErrorR => popError,
                isEmptyR => isEmpty,
                isFullR => isFull,
                stackPtrR => stackPointer
            );
        
        stim_proc: process
        begin
            rst <= '1';
            wait for clk_period;
            rst <= '0';
            wait for clk_period;
        
            pop <= '1';        --Testing if pop works at the start of the simulation, with 0 elements in the stack, should show PopError = '1'
            wait for clk_period;
            pop <= '0';
            wait for clk_period;
        
        
        
            dIN <= "01001001";                --push 1 value and then we see if "popping" twice shows the first time the first input, and the second time another PopError
            push <= '1';
            wait for clk_period;
            dIN <= (others => 'U');
            push <= '0';
            wait for clk_period;

            -----------------------------
            assert isEmpty = '0';
                report "value correctly evalueted empty (memSim line 129)"
                severity note; 
            ----------------------------
            
            pop <= '1';
            wait for clk_period;

            ----------------------------
            assert isEmpty = '1';
                report "value correctly evaluated not empty (memSim line 138)"
                severity note;
            -----------------------------
                
            pop <= '1';
            wait for clk_period;

            -----------------------------
            assert popError = '1';
                report "pop error correctly evaluated (memSim line 147)" 
                severity note;
            -----------------------------
                
            pop <='0';
            wait for clk_period;
        
            
            
            dIN <= "01001001";                --push 1 value and then we see if "clearing" shows the first time that "isEmpty" is '1', and then we set pop to '1' to see the popError
            push <= '1';
            wait for clk_period;
            dIN <= (others => 'U');
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
                
            dIn <= "11010001";    -- push 1 item to check if rst works independently from the rising_edge
            push <= '1';
            wait for clk_period;
            push <= '0';
            wait for clk_period;
            rst <= '1';
            wait for clk_period;
            rst <= '0';
            wait for clk_period;
            
        
            for i in 0 to STACK_DEPTH-1 loop        --Fill stack completely (isFull should appear as '1') and then we add another element to trigger pushError
                dIN <= test_values(i);
                push <= '1';
                wait for clk_period;
                push <= '0';
                wait for clk_period;

                if i = 7 then
                ---------------------------------------------------------------
                    assert isFull = '1';
                      report "isFull correctly evaluated (memSim line 192)"
                      severity note;
                ----------------------------------------------------------------
                end if;    
            end loop;
                    
            dIN <= "11111111";
            push <= '1';
            wait for clk_period;

            ------------------------------------------------------------
            assert pushError = '1';
                report "pushError correctly evaluated (memSim line 204)"
                severity note;
            ------------------------------------------------------------
                
            push <= '0';
            dIN <= (others => 'U');
            wait for clk_period;
            
            for i in 0 to STACK_DEPTH loop            --pop all elements +1 and we'll get a popError
                pop <= '1';
                wait for clk_period;
                pop <= '0'; 
                wait for clk_period;
            end loop;

            -------------------------------------------------------
            assert popError = '1';
                 report "popError correctly evaluated (memSim line 221)"
                 severity note;

            report "Fine stim_proc raggiunta"
                severity note;
            ------------------------------------------------------

            wait;
        end process;
end Behavioral;
