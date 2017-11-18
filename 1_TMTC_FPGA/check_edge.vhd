library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY check_edge IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		xcpu :in  std_logic;
		clk :in  std_logic;
		cpufalling_edge :out std_logic
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
END check_edge;
ARCHITECTURE check_edge_architecture OF check_edge IS	
signal  xwr_vector : std_logic_vector(3 downto 0);
BEGIN
process(clk)
begin
   if(rising_edge(clk))   then
		xwr_vector(2 downto 1)<= xwr_vector(1 downto 0);
		xwr_vector(0)<= xcpu;
		if (xwr_vector(2 downto 1)="10") then -- falling_edge
			cpufalling_edge<='1';
		else
		    cpufalling_edge<='0';
		end if;
		
   end if;
end process;
END check_edge_architecture;
