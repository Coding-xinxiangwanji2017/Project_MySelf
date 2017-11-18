library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
ENTITY cpu_data_buffer IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		clk :in std_logic;
		rd  :in  std_logic;
		wr  :in  std_logic;
		cpudata  :inout  std_logic_vector(7 downto 0);
		dataout  :out    std_logic_vector(7 downto 0);
		datain   :in     std_logic_vector(7 downto 0)
		
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
	
END cpu_data_buffer;
ARCHITECTURE cpu_data_buffer_architecture OF cpu_data_buffer IS

	
BEGIN
process(clk)
variable rd_vector :std_logic_vector(1 downto 0);
begin
	if(rising_edge(clk))  then
		rd_vector(1):=rd_vector(0);
		rd_vector(0):=rd;
		if(rd='0')   then   --falling edge
			cpudata(7 downto 0)<=datain(7 downto 0);	
		elsif((wr='0'))	then
			dataout(7 downto 0)<=cpudata(7 downto 0);
		else
			dataout(7 downto 0)<="ZZZZZZZZ";
			cpudata(7 downto 0)<="ZZZZZZZZ";
		end if;
	end if;
end process;
END cpu_data_buffer_architecture;
