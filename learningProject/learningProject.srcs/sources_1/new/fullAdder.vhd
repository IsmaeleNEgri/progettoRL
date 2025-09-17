----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/15/2025 10:04:48 PM
-- Design Name: 
-- Module Name: fullAdder - Behavioral
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

entity fullAdder is
        Port (a,b,Cin : in STD_LOGIC;
            sum : out STD_LOGIC;
            Cout : out STD_LOGIC);
end fullAdder;
     
architecture Behavioral of fullAdder is
    --signal is used for temporary variable, before the begin
    signal w1 : std_logic;
    signal w2 : std_logic;
    signal w3 : std_logic;

begin

    --I could have used 1 equation, but for longer project intermediate variable are preferable,
    --as using 1 long equation can make it hard to debug
    w1 <= a xor b;
    w2 <= w1 and Cin;
    w3 <= a and b;
    
    sum <= w1 xor Cin;
    Cout <= w2 or w3;

end Behavioral;
