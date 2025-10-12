----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/24/2025 11:32:03 PM
-- Design Name: 
-- Module Name: inputRegister - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity inputRegister is
    generic(
        length : integer := 8);

    Port ( clk : in std_logic;
    rst : in std_logic;
    pop : in  std_logic;
    push : in std_logic;
    clear : in std_logic;
    
    dIn : in std_logic_vector(length -1  downto 0);
    dOut : out std_logic_vector(length -1 downto 0);
    
    pushError : out std_logic;
    popError : out std_logic;
    isEmpty : out std_logic;
    isFull : out std_logic  
    );
    
end inputRegister;

architecture Behavioral of inputRegister is
    --temporary vector "for all the values"
    signal rData : std_logic_vector(length-1 downto 0);
    
begin
    --first i discovered that "" is different from '' here
    --second i discovered the words: others, rising_edge and sp falling_edge
    --others set all the values of a signale to a value specified
    --rising_edge controls if there was a rising_edge (what a surprise)
    process(clk,rst,dIn)
       begin 
        --check reset
          if rst = '1'then
            rData <= (others => '0');  
        --check if rising_edge
          elsif rising_edge(clk) then 
            rData <= dIn;
          end if;
    end process;
    
    --set the rData datas on the out door of the register 
    dOut <= rData;       

end Behavioral;
