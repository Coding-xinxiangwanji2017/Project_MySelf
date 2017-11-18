library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY gen_int2 IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		cs_clr_int :in  std_logic;
		clk :in  std_logic;
		reset : in std_logic;
		out_time :in  std_logic;			
		int :out std_logic
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
END gen_int2;
ARCHITECTURE gen_int2_architecture OF gen_int2 IS	
signal  out_time_vector : std_logic_vector(1 downto 0);
BEGIN
process(clk)
begin
   if(rising_edge(clk))   then
        if(reset='0') then 
			out_time_vector<="00";
			int <='1';
        else 
			out_time_vector(1)<= out_time_vector(0);
			out_time_vector(0)<= out_time;
            if (out_time_vector(1 downto 0)="10") then -- falling_edge
				int<='0';
            elsif(cs_clr_int= '0') then
				 int<='1';
            end if;
        end if;
   end if;
end process;

END gen_int2_architecture;


