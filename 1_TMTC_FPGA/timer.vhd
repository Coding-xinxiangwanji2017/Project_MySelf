library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY timer IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		clk_1ms   :in std_logic;  --18.432M
		reset :in std_logic;
		wr : in std_logic;
		datain  :in std_logic_vector(15 downto 0);
		clk_timer :in std_logic;
		cs_enable :in std_logic;
		cs_unenable :in std_logic;
		pusle_1ms :out std_logic

	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
	
END timer;

ARCHITECTURE timer_architecture OF timer IS
signal clk_timer_vector :std_logic_vector(1 downto 0);
signal enable_mark  :std_logic;
signal   counter_vector  :std_logic_vector(15 downto 0);
BEGIN
process(clk_1ms)
variable counter_vector_seg :std_logic_vector(15 downto 0);
begin

	if (reset='0') then
		counter_vector<="0000000000000000";
		counter_vector_seg:="0001000000000000";
		pusle_1ms<='1';
		enable_mark<='0';
	elsif ((wr='0') and (cs_enable='0')) then
		enable_mark<='1';
	elsif ((wr='0') and (cs_unenable='0')) then
		enable_mark<='0';
	elsif rising_edge(clk_1ms)  then
		
		clk_timer_vector(0)<= clk_timer;
		clk_timer_vector(1)<= clk_timer_vector(0);
		
		    pusle_1ms<='1';
		if(clk_timer_vector="01") then
			if(enable_mark='1') then		
					pusle_1ms<='0';
			--else
			--	pusle_1ms<='1';
			end if;
		--else
		--		pusle_1ms<='1';			
		end if;
	end if;
end process;

END timer_architecture;

