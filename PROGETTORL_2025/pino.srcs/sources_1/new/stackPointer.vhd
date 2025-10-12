-- File: StackPointer.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.depthMinCalc.all;  

entity StackPointer is
  generic (
  --startedwith a basic  for the stack depth
    STACK_DEPTH : natural := 8                 
  );
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    push  : in  std_logic;
    pop   : in  std_logic;
    sp_out: out std_logic_vector(minBitNecessary(STACK_DEPTH)-1 downto 0);
    empty : out std_logic;
    full  : out std_logic
  );
end entity;

architecture Behavioral of StackPointer is


begin


end Behavioral;
