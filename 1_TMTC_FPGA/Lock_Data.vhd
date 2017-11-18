library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY Lock_Data IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		clk   :in std_logic;  --18.432M
		reset :in std_logic;
		cs_lock_data :in std_logic;
		data_in  :in  std_logic_vector(15 downto 0);
		data_out :out std_logic_vector(15 downto 0)

	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
	
END Lock_Data;

ARCHITECTURE Lock_Data_architecture OF Lock_Data IS
--signal counter_16384  :integer range 0 to 25384;

BEGIN
process(clk)

begin
	if (reset='0') then
		data_out<="ZZZZZZZZZZZZZZZZ";
	elsif rising_edge(clk)  then		
	    if(cs_lock_data = '0') then
			data_out<= data_in;
		 end if;
	end if;
end process;

END Lock_Data_architecture;
