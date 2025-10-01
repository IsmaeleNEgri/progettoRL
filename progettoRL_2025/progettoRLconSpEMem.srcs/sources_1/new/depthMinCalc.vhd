library IEEE;
use IEEE.STD_LOGIC_1164.all;

package depthMinCalc is
  --function to calculate the minimal number of bit to use for the stack depth
  --inside package i define the function, the type it takes, and the one it gives
  function minBitNecessary(x : natural) return natural;
end package depthMinCalc;

package body depthMinCalc is
--i go from 0 to x-1 cause i'm using the binary language
  function minBitNecessary(x : natural) return natural is
    variable tmp : natural := x - 1;
    variable ret : natural := 0;
  begin
    while tmp > 0 loop
    --ret is "initialized" 1 cause even if i have 0 as number i need 1 bit to represent it
      ret := ret + 1;
      --the /2 is like what we learned in our first year of university
      tmp := tmp / 2;
    end loop;
    return ret;
  end function minBitNecessary;
  
end package body depthMinCalc;