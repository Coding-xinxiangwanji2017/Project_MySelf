
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY PCM_JT IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		clk  :in   std_logic;
		RESET :in   std_logic;
		PCM_CLK :in   std_logic;
		PCM     :in   std_logic;
		pcm_Data : out std_logic_vector(7 downto 0);
		FIFO_WR : out std_logic
	);

END PCM_JT;
ARCHITECTURE PCM_JT_architecture OF PCM_JT IS

signal  pcm_clk_siftVector      :std_logic_vector(1 downto 0);
signal  pcm_vector     :std_logic_vector(7 downto 0);
signal  counter_10   :integer range 0 to 15;	
signal  FIFO_WR_Siganl   :std_logic;
signal  FIFO_WR_Siganl_Vector  :std_logic_vector(2 downto 0);
BEGIN
pcm_Data(7 downto 0)<=pcm_vector(7 downto 0);
process(clk)
begin
	if rising_edge(clk)  then
		if(RESET='1') then
--			FIFO_WR<='0';
			counter_10<=0;
			pcm_clk_siftVector<="00";
			pcm_vector<="00000000";
		else			
			pcm_clk_siftVector(0)<=PCM_CLK;
			pcm_clk_siftVector(1)<=pcm_clk_siftVector(0);
			    
			if(pcm_clk_siftVector="10") then 
				counter_10<= counter_10+1;
				pcm_vector(0)<=PCM;
				pcm_vector(7 downto 1)<=pcm_vector(6 downto 0);
				if (counter_10 = 7) then
					counter_10 <= 0;
					FIFO_WR_Siganl<='1';
				else
					FIFO_WR_Siganl<='0';					
				end if;
			end if;	
		end if;
	end if;
end process;

process(clk,FIFO_WR_Siganl)
begin
	if rising_edge(clk) then
		FIFO_WR_Siganl_Vector(0)<=FIFO_WR_Siganl;
		FIFO_WR_Siganl_Vector(1)<=FIFO_WR_Siganl_Vector(0);
--		if(FIFO_WR_Siganl_Vector="01" and pcm_gate='0') then
		if(FIFO_WR_Siganl_Vector="01" ) then
			FIFO_WR<='1';
		else 
			FIFO_WR<='0';	
		end if;
	end if;
end process;
END PCM_JT_architecture;
