library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY bl_out IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		clk_in   :in std_logic;  --18.432M
		reset :in std_logic;
		rd : in std_logic;
		a7 : in std_logic;
		addr: in std_logic_vector (3 downto 0);
	   blout  :out std_logic_vector(15 downto 0)
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
	
END bl_out;

ARCHITECTURE bl_out_architecture OF bl_out IS
signal clk_timer_vector :std_logic_vector(1 downto 0);

signal   counter_vector  :std_logic_vector(15 downto 0);
BEGIN
process(clk_in)
variable counter_vector_seg :std_logic_vector(15 downto 0);
begin
if(rising_edge(clk_in)) then
	if((rd='0')and (addr="0001")and (a7='0')) then
		blout(15 downto 0)<= X"aaaa";
	elsif
      ((rd='0')and (addr="0010")and (a7='0')) then	
		blout<= X"5555";
	end if;
end if;
end process;
END bl_out_architecture;


