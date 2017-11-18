library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY bl_check IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		clk_in   :in std_logic;  --18.432M
		reset :in std_logic;
		rd : in std_logic;
		cs_bl_check :in std_logic;
		bl1: in std_logic;
		bl2: in std_logic;
		bl3: in std_logic;
		bl4: in std_logic;
		bl5: in std_logic;
		bl6: in std_logic;
		bl7: in std_logic;
		bl8: in std_logic;
		bl9: in std_logic;
		bl10: in std_logic;
		bl11: in std_logic;
		bl12: in std_logic;
		bl13: in std_logic;
		bl14: in std_logic;
		bl15: in std_logic;
		bl16: in std_logic;		
		dataout  :out std_logic_vector(15 downto 0)
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
	
END bl_check;

ARCHITECTURE bl_check_architecture OF bl_check IS
signal clk_timer_vector :std_logic_vector(1 downto 0);

signal   counter_vector  :std_logic_vector(15 downto 0);
BEGIN
process(clk_in)
variable counter_vector_seg :std_logic_vector(15 downto 0);
begin
if(rising_edge(clk_in)) then
	if((rd='0')and (cs_bl_check='0')) then
		dataout(15 downto 0)<= bl16 &bl15 &bl14 &bl13 &bl12 &bl11 &bl10 &bl9 &bl8 &bl7 &bl6 &bl5 &bl4 &bl3 &bl2 &bl1;
	else 
		dataout<= "ZZZZZZZZZZZZZZZZ";
	end if;
end if;
end process;
END bl_check_architecture;


