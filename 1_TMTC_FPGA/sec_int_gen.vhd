library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY sec_int_gen IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		clk_in        :in std_logic;  --18.432M
		int_falling_edge :in std_logic;
		cs_clrsec_int :in std_logic;
		reset         :in std_logic;
		sec_int       :out std_logic

	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
	
END sec_int_gen;

ARCHITECTURE sec_int_gen_architecture OF sec_int_gen IS
BEGIN
process(clk_in)

begin
if(rising_edge(clk_in)) then
	if(reset='0') then
		sec_int <= '1';
	elsif(int_falling_edge='1') then	
		sec_int <= '0';
	elsif(cs_clrsec_int ='0')  then 
		sec_int <= '1';
	end if;
end if;
end process;

END sec_int_gen_architecture;
