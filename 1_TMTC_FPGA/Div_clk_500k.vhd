library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY Div_clk_500k IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		clk   :in std_logic;  --33M
		reset :in std_logic;
		div_clk_500k :out std_logic
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
	
END Div_clk_500k;

ARCHITECTURE Div_clk_500k_architecture OF Div_clk_500k IS

signal counter_16384  :integer range 0 to 25384;
signal  pcm_clk_signal_500k : std_logic;

BEGIN
div_clk_500k<= pcm_clk_signal_500k;

process(clk,reset)
--variable  counter_16384  :integer range 0 to 16384;
begin
	if (reset='0') then
		counter_16384<=0;
		pcm_clk_signal_500k<='1';
	elsif rising_edge(clk)  then
		counter_16384 <=counter_16384+1;
	    if(counter_16384=33) then
			counter_16384<=0;
			pcm_clk_signal_500k<= not pcm_clk_signal_500k;
        end if;

	end if;
		
end process;

END Div_clk_500k_architecture;
