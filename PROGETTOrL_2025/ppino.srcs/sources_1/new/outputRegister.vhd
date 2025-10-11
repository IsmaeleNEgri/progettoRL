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

--it is very similar to the input registe

entity outputRegister is
    generic(
        length : integer := 8);

    Port ( clk : in std_logic;
    rst : in std_logic;
    sp : in std_logic_vector(2 downto 0);
    
    dIn : in std_logic_vector(length -1  downto 0);
    stackOut : out std_logic_vector(8 * length -1 downto 0);
    --TO BE VERIFIED
    singleDOut : out std_logic_vector(length -1 downto 0);
    
    isEmpty : out std_logic;
    isFull : out std_logic 
    );
    
end outputRegister;

architecture Behavioral of outputRegister is
    --temporary vector "for all the values"
    signal rData : std_logic_vector(length-1 downto 0);
    
begin

  process(clk, rst, dIn)
  begin
    --check reset
    if rst = '1' then
      rData <= (others => '0');
    --check if rising_edge
    elsif rising_edge(clk) then
      rData <= dIn;
    end if;
  end process;
    
  --set all the data in rData to the out door of the register 
  stackOut <= rData;

end Behavioral;
