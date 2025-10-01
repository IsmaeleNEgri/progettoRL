----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/25/2025 11:38:17 PM
-- Design Name: 
-- Module Name: registerTb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity registerTb is
--  Port ( );
end registerTb;

architecture Behavioral of registerTb is
    
    constant length: integer := 8;
    
    --placing test signals
    signal  t_clk : std_logic := '0';
    signal t_rst   : std_logic := '0';
    signal t_din   : std_logic_vector(length-1 downto 0);
    signal t_dout  : std_logic_vector(length-1 downto 0);
    
    --taking the register (i took one since their behavior is the same, and "redefining" it 
    component outputRegister
        generic (l : integer := 8);
        port(clk  : in  std_logic;
             rst  : in  std_logic;
             din  : in  std_logic_vector(l-1 downto 0);
             dout : out std_logic_vector(l-1 downto 0));
    end component;
    
   
begin
    --i have to port the signals so i can link the port to the test signals
    uut : outputRegister
        generic map(l => length)
        port map(clk=>t_clk,
                  rst=>t_rst,
                  din=>t_din,
                  dout=>t_dout);
                  
     --once the porting is done, its time to start the "stimulation"
     --first test in on the clock signal
     clk_process : process
     begin 
        while true loop
            t_clk <= '0';
            wait for 10 ns;
            t_clk <= '1';
            wait for 10 ns;
       end loop; 
     end process;
     
     --second test is just to try it out on the rising_edge
     stim_proc : process
  begin
    -- Reset iniziale
    t_rst <= '1';
    wait for 20 ns;
    t_rst <= '0';

    -- give a input (test 2.1)
    t_din <= "10101010";
    wait for 20 ns;

    --change of input (test 2.2)
    t_din <= "11110000";
    wait for 20 ns;

    --reset test (test 2.3)
    t_rst <= '1';
    wait for 10 ns;
    t_rst <= '0';
    t_din <= "00001111";
    wait for 20 ns;

    wait;
  end process;

end Behavioral;
