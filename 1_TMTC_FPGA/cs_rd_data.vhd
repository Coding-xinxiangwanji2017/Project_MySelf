library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


--  Entity Declaration

ENTITY cs_rd_data IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		reset       :in  std_logic;
		clk         :in  std_logic;
		rd_cs1      :in  std_logic; --
		rd_cs2      :in  std_logic; --
		rd_cs3      :in  std_logic; --
		rd_cs4      :in  std_logic;
		rd_cs5      :in  std_logic; --
		rd_cs6      :in  std_logic; --
		rd_cs7      :in  std_logic;	
	   rd_cs8      :in  std_logic;
	   rd_cs9      :in  std_logic;	
		rd_data1  :in  std_logic_vector(7 downto 0); --
		rd_data2  :in  std_logic_vector(10 downto 0); --	
		rd_data3  :in  std_logic_vector(7 downto 0); --		
		rd_data4  :in  std_logic_vector(10 downto 0); --		
		rd_data5  :in  std_logic_vector(7 downto 0); --		
		rd_data6  :in  std_logic_vector(10 downto 0); --		
		rd_data8  :in  std_logic_vector(7 downto 0); --		
		rd_data9  :in  std_logic_vector(10 downto 0); --	
		int1  :in  std_logic;
		int2  :in  std_logic;
		int3  :in  std_logic;		
		int4  :in  std_logic;
		data_out        :out  std_logic_vector(15 downto 0)
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
	
END cs_rd_data;


--  Architecture Body

ARCHITECTURE cs_rd_data_architecture OF cs_rd_data IS
BEGIN
process(clk,reset)
begin
	if(rising_edge(clk))   then
		if(rd_cs1='0') then
			data_out<="00000000"&rd_data1;
		elsif(rd_cs2='0') then
			data_out(15 downto 0)<="00000"&rd_data2;
		elsif(rd_cs3='0') then
			data_out(15 downto 0)<="00000000"&rd_data3;		
		elsif(rd_cs4='0') then
			data_out(15 downto 0)<="00000"&rd_data4;		
		elsif(rd_cs5='0') then
			data_out(15 downto 0)<="00000000"&rd_data5;
		elsif(rd_cs6='0') then
			data_out(15 downto 0)<="00000"&rd_data6;		

			
		elsif(rd_cs8='0') then
			data_out(15 downto 0)<="00000000"&rd_data8;	
		elsif(rd_cs9='0') then
			data_out(15 downto 0)<="00000"&rd_data9;	
			
		elsif(rd_cs7='0') then
			data_out(15 downto 0)<="000000000000"&(not int4)&(not int3)&(not int2)&(not int1);			
		else
			data_out<="ZZZZZZZZZZZZZZZZ";
		end if;
	end if;
end process;

END cs_rd_data_architecture;
