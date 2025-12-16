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
    
    --------------------------------------------------------------------------------------
    --this is called shadow memory. it's a copy of the memory for testbench purpose only
    type tb_mem_shadow is array(0 to STACK_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal tb_shadowMem : tb_mem_shadow := (others => (others => '0')); 
    
    --since it does not affect the memory functionality i used a 
    signal tb_sp  : integer range 0 to STACK_DEPTH := 0; 
    
    --popError and pushError that mimic the R version of the ones in memory.signas.
    signal popError_tb : std_logic;
    signal pushError_tb : std_logic;     
    
    --extra signals necessary due to the input registers in Memory
    --S stand for slow, as i have to slow down the shadow Memory to match the Memory speed
    signal pushS : std_logic := '0';
    signal popS  : std_logic := '0';
    signal clearS: std_logic := '0';
    signal dINS : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    
    --extra signals due to the output register delay
    --dOUTEx is to confront the pop data from shadowMem with dOUT of mem
    signal dOUTEx : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    --delayed dOUTEx
    signal dOUTEx_delayed : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    ---------------------------------------------------------------------------------------
    
    constant clk_period : time := 48 ns;
    
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
            clk <= '1';
            wait for clk_period /2 ;
            clk <= '0';
            wait for clk_period /2 ;
        end process;
        
        ---------------------------------------------------------------------------------------
        
        slowing_process : process(clk)
        begin
            if rising_edge(clk) then
            --command "slowing"
            pushS  <= push;
            popS   <= pop;
            clearS <= clear;
            dINS   <= dIN;
            end if;
        end process;
          
        
        --indipendent process for the shadow memory
        shadowMem_process : process(clk, rst)
        begin
          if rst = '1' then
            tb_shadowMem <= (others => (others => '0'));
            tb_sp <= 0;
            dOUTEx <= (others => '0');
            dOUTEx_delayed <= (others => '0');
            pushError_tb <= '0';
            popError_tb <= '0';
        
          elsif rising_edge(clk) then
            
            dOUTEx <= dOUTEx_delayed;

            pushError_tb <= '0';
            popError_tb  <= '0';
        
            -- clear
            if clearS = '1' then
              tb_shadowMem <= (others => (others => '0'));
              tb_sp <= 0;
        
            else
              --------------------------------------------------
              
              if pushS = '1' and popS = '1' then
                if tb_sp < 4 then
                  tb_shadowMem(tb_sp) <= dINS;
                  tb_sp <= tb_sp + 1;
                else
                  dOUTEx_delayed <= tb_shadowMem(tb_sp - 1);
                  tb_shadowMem(tb_sp - 1) <= (others => '0');
                  tb_sp <= tb_sp - 1;
                end if;
              end if;
              --------------------------------------------------
        
              
              if pushS = '1' and popS = '0' then
                if tb_sp < STACK_DEPTH then
                  tb_shadowMem(tb_sp) <= dINS;
                  tb_sp <= tb_sp + 1;
                else
                  pushError_tb <= '1';
                end if;
        
              
              elsif popS = '1' and pushS = '0' then
                if tb_sp > 0 then
                  dOUTEx_delayed <= tb_shadowMem(tb_sp - 1);
                  tb_shadowMem(tb_sp - 1) <= (others => '0');
                  tb_sp <= tb_sp - 1;
                else
                  popError_tb <= '1';
                end if;
              end if;
            end if;
          end if;
        end process;
        -------------------------------------------------------------------------------------
        
        -------------------------------------------------------------------------------------
        --indipendent process for the asserts
        assert_process : process(clk)
        begin
          if rising_edge(clk) then
            -- verifica dopo il push
            if tb_sp > 0 then
              assert isEmpty = '0'
                report "Stack not empty"
                severity note;
            end if;
            
            if not (tb_sp = STACK_DEPTH -1) then
              assert isFull = '0'
                report "Stack not full"
                severity note;
            end if;
            
            if tb_sp > 0 then
              assert isEmpty = '0'
                report "Stack non vuoto dopo push"
                severity note;
            end if;
            
            if tb_sp = 0 then
              assert isEmpty = '1'
                report "Stack empty"
                severity note;
            end if;
            
            
            -- verifica errori
            if tb_sp = STACK_DEPTH -1 and push = '1' then
              assert pushError = '1'
                report "pushError correctly active"
                severity note;
            end if;
        
            if tb_sp = 0 and pop = '1' then
              assert popError = '1'
                report "popError correctly active"
                severity note;
            end if;
          end if;
        end process;
        -------------------------------------------------------------------------------------
        
        --real testing process, for the memory module
        uut: entity work.memory
            port map (
                clkR => clk,
                rstR => rst,
                pop => pop,
                push => push,
                clear => clear,
                dIN => dIN,
                dOUT => dOUT,
                pushError => pushError,
                popError => popError,
                isEmpty => isEmpty,
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
            dIn <= "11010001";    -- push 2 items to check if rst works independently from the rising_edge
            push <= '1';
            wait for clk_period;
            push <= '0';
            wait for clk_period;
            dIn <= "00101010";
            push <= '1';
            wait for clk_period;
            push <= '0';
            wait for clk_period + 3ns;
            rst <= '1';
            wait for clk_period;
            rst <= '0';
            wait for clk_period - 3ns;
                      
            ------------------------------------------------------------------
            
            for i in 0 to STACK_DEPTH-1 loop        --Fill stack completely (isFull should appear as '1') and then we set clear on '1';
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
