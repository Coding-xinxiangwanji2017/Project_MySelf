library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;




ENTITY gen_adr IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		clk        :in     std_logic;
		reset      :in     std_logic;
		send_signal    :in    std_logic;
		rising_count         :in     std_logic;
		adr     :out      std_logic_vector(9 downto 0) 
	);

END gen_adr;

ARCHITECTURE gen_adr_architecture OF gen_adr IS
signal  adr_signal :std_logic_vector(9 downto 0); 
BEGIN

process(clk)

begin
	if(rising_edge(clk))  then
		adr<=adr_signal;
		if(reset='0')	then
			adr_signal<="0000000000";
		elsif(send_signal='1')   then
			adr_signal<="0000000000";
		elsif(rising_count='1') then
			adr_signal<= (adr_signal+ '1');
		end if;
	end if;
end process;

END gen_adr_architecture;

