library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;




ENTITY wr_data_cs IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		clk        :in     std_logic;
		reset      :in     std_logic;
		cpu_data   :in  std_logic_vector(15 downto 0);
		wr_data    :out    std_logic_vector(15 downto 0);
		cs         :in     std_logic;
		wr         :in     std_logic 
	);

	
END wr_data_cs;

ARCHITECTURE wr_data_cs_architecture OF wr_data_cs IS

	
BEGIN
process(clk)
begin
	if(rising_edge(clk))  then
		if(reset='0')	then
			wr_data<="ZZZZZZZZZZZZZZZZ";
		end if;
		if(wr='0' and cs='0')  then
			wr_data(15 downto 0)<=cpu_data(15 downto 0);
		end if;
	end if;
end process;

END wr_data_cs_architecture;
