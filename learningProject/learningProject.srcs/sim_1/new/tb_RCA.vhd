----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2025 10:12:31 AM
-- Design Name: 
-- Module Name: tb_RCA - Behavioral
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

entity tb_rca is
end tb_rca;

architecture Behavioral of tb_rca is
    signal A, B : STD_LOGIC_VECTOR(3 downto 0);
    signal Cin : STD_LOGIC;
    signal Sum : STD_LOGIC_VECTOR(3 downto 0);
    signal Cout : STD_LOGIC;

    component RCA2
        Port ( A, B : in STD_LOGIC_VECTOR(3 downto 0);
               Cin : in STD_LOGIC;
               Sum : out STD_LOGIC_VECTOR(3 downto 0);
               Cout : out STD_LOGIC );
    end component;

begin
    DUT: RCA2 port map(A, B, Cin, Sum, Cout);

    process
    begin
        A <= "0101"; B <= "0011"; Cin <= '0';
        wait for 10 ns;
        A <= "1111"; B <= "0001"; Cin <= '1';
        wait for 10 ns;
        wait;
    end process;
end Behavioral;
