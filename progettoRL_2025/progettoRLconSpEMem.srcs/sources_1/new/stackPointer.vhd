-- File: StackPointer.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.depthMinCalc.all;  

entity StackPointer is
  generic (
  --startedwith a basic 16 for the stack depth
    STACK_DEPTH : natural := 16                 
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

  --using the function construct i define a function to calculate the minimal number of bit required
  function ceil_log2(x : natural) return natural is
    variable tmp : natural := x - 1;
    variable ret : natural := 0;
  begin
    while tmp /= 0 loop
      ret := ret + 1;
      tmp := tmp / 2;
    end loop;
    return ret;
  end function;

  signal sp_reg  : unsigned(ceil_log2(STACK_DEPTH)-1 downto 0) := (others => '0');
  signal sp_next : unsigned(ceil_log2(STACK_DEPTH)-1 downto 0);
  signal empty_i : std_logic;
  signal full_i  : std_logic;

begin

  -- Logica combinatoria del prossimo valore
  process(sp_reg, push, pop, full_i, empty_i)
  begin
    sp_next <= sp_reg;
    if (push = '1' and pop = '0' and full_i = '0') then
      sp_next <= sp_reg + 1;
    elsif (pop = '1' and push = '0' and empty_i = '0') then
      sp_next <= sp_reg - 1;
    end if;
  end process;

  -- Logica sincrona (registro)
  process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sp_reg <= (others => '0');
      else
        sp_reg <= sp_next;
      end if;
    end if;
  end process;

  -- Flags empty/full (sincroni, derivati dal puntatore)
  empty_i <= '1' when sp_reg = 0 else '0';
  full_i  <= '1' when sp_reg = to_unsigned(STACK_DEPTH-1, sp_reg'length) else '0';

  -- Output registrati
  sp_out <= std_logic_vector(sp_reg);
  empty  <= empty_i;
  full   <= full_i;
end Behavioral;
