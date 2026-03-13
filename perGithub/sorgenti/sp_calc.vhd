library ieee;
use ieee.std_logic_1164.all;

entity sp_calc is
  port (
    clk     : in  std_logic;
    rst     : in  std_logic; 
    clear   : in  std_logic; 
    push : in  std_logic; 
    pop : in  std_logic; 
  
    --write is a fictional signal to indicate 0 - pop, 1-push to the memory
    w_addr : out std_logic_vector(2 downto 0);
    r_addr : out std_logic_vector(2 downto 0);
    
    full_out : out std_logic;
    empty_out : out std_logic
  );
end entity;

architecture Behavioral of sp_calc is
    
  signal b_sum        : std_logic_vector(3 downto 0);  
  signal sp_reg       : std_logic_vector(3 downto 0) := "0000";
  signal sp_next_raw  : std_logic_vector(3 downto 0);
  signal sp_next      : std_logic_vector(3 downto 0);
  signal carry_reg    : std_logic;

  signal w_addr_reg   : std_logic_vector(2 downto 0);
  signal r_addr_reg   : std_logic_vector(2 downto 0);

  signal invalid_reg : std_logic;
  
  signal full_reg : std_logic := '0';
  signal empty_reg : std_logic := '1';

begin

    b_sum <= "1111" when (pop='1' and push='0') else
             "0001" when (push='1' and pop='0') else
             "0000";


    incrementer_decrementer: entity work.rippleCarryAdder
      generic map (
        STACK_PTR_DEPTHR => 4
      )
      port map (
        A    => sp_reg,
        B    => b_sum,
        Cin  => '0',
        ras  => sp_next_raw,
        Cout => carry_reg
      );


    invalid_reg <= '1' when ((pop='1' and sp_reg="0000") or
                         (push='1' and sp_reg="1000"))
               else '0';

    sp_next <= sp_reg when invalid_reg ='1' else sp_next_raw;


    w_addr_reg <= sp_reg(2 downto 0);  

    r_addr_reg <= sp_next(2 downto 0) when (pop='1' and invalid_reg ='0')
                  else sp_reg(2 downto 0);
                  
    empty_reg <= '1' when sp_next = "0000" else '0';
    full_reg <= '1' when sp_next = "1000" else '0';

                  
    process(clk, rst)
    begin
        if rst='1' then
            sp_reg <= "0000";
            w_addr <= "000";
            r_addr <= "000";

        elsif rising_edge(clk) then
            if clear = '1' then 
                sp_reg <= "0000";
                w_addr <= "000";
                r_addr <= "000";
                empty_out <= '0';
                full_out <= '0';
            else
            
                empty_out <= empty_reg;
                full_out <=  full_reg;
                
                sp_reg <= sp_next;
    
                w_addr <= w_addr_reg;
                r_addr <= r_addr_reg;
            end if;
        end if;
    end process;

end Behavioral;
