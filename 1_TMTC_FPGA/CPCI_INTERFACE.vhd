library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;




ENTITY CPCI_INTERFACE IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		clk        :in     std_logic;
		reset      :in     std_logic;
		ads      :in     std_logic;
		blast      :in     std_logic;
		lwr      :in     std_logic;
		CPCI_AD      :in     std_logic_vector(17 downto 0);
		CPCI_Data   :inout  std_logic_vector(31 downto 0);
		ready    :out    std_logic;
		wr       :out    std_logic;
		rd       :out    std_logic;
		AD       :out    std_logic_vector(17 downto 0);
		data       :inout    std_logic_vector(31 downto 0)

	);

	
END CPCI_INTERFACE;

ARCHITECTURE CPCI_INTERFACE_architecture OF CPCI_INTERFACE IS

signal  blast_Vector:  std_logic_vector(3 downto 0);	
BEGIN
process(clk)
begin
	if(rising_edge(clk))  then
		if(reset='0') then
			ready<='1';
			wr<='1';
			rd<='1';
			blast_Vector<="ZZZZ";
		else
			---------------------------------------ready
				blast_Vector(3 downto 1)<=blast_Vector(2 downto 0);  --ready
				blast_Vector(0)<=blast;
				if(blast_Vector(3 downto 0)="1000")  then
					ready<='0';
				else 
					ready<='1';
				end if;
				--------------------wr and rd
				if(blast='0')  then
					if(lwr='0') then
						rd<='0';
					else
						wr<='0';
					end if;
				else
					rd<='1';
					wr<='1';
				end if;
				-------------------------- AD
				if(ads='0') then
					ad(17 downto 0)<= cpci_ad(17 downto 0);
				elsif(blast_Vector="0001") then
					ad(17 downto 0)<= "ZZZZZZZZZZZZZZZZZZ";
				end if;
				---------------------------DATA
				if(blast='0' and lwr='1') then
					data(31 downto 0)<= cpci_data(31 downto 0);
				elsif(blast='0' and lwr='0') then
					cpci_data(31 downto 0)<=data(31 downto 0);
				else
					data(31 downto 0)<="ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
					cpci_data(31 downto 0)<="ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
				end if;
		end if;
	end if;
end process;

END CPCI_INTERFACE_architecture;
