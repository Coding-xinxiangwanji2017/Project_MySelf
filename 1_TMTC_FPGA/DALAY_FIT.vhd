library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


--  Entity Declaration

ENTITY DALAY_FIT IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		reset       :in  std_logic;
		clk         :in  std_logic;
		pcm_gate_in :in  std_logic; --heard no delay ,end delay 100000
		pcm_in      :in  std_logic; --delay 20002
		pcm_clk_in  :in  std_logic; --delay 20002				
		pcm_clk_delay  :out  std_logic;
		pcm_gate_delay :out  std_logic;
		pcm_out        :out  std_logic
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
	
END DALAY_FIT;


--  Architecture Body

ARCHITECTURE DALAY_FIT_architecture OF DALAY_FIT IS

signal pcm_clk_signal  :std_logic;
signal pcm_gate_signal :std_logic;
signal pcm_in_signal   :std_logic;
signal pcm_gate_signal2 :std_logic;
signal pcm_gate_signal_vector :std_logic_vector(1 downto 0);
signal pcm_clk_signal_vector :std_logic_vector(1 downto 0);
signal pcm_in_signal_vector  :std_logic_vector(1 downto 0);	
signal pcm_gate_signal2_vector  :std_logic_vector(1 downto 0);	

BEGIN

process(clk,reset)
begin
	if(rising_edge(clk))   then
		pcm_gate_signal_vector(1)<=pcm_gate_signal_vector(0);
		pcm_gate_signal_vector(0)<=pcm_gate_in;
		pcm_clk_signal_vector(1)<=pcm_clk_signal_vector(0);
		pcm_clk_signal_vector(0)<=pcm_clk_in;
		pcm_in_signal_vector(1)<=pcm_in_signal_vector(0);
		pcm_in_signal_vector(0)<=pcm_in;
		pcm_gate_signal2_vector(1)<=pcm_gate_signal2_vector(0);
		pcm_gate_signal2_vector(0)<=pcm_gate_signal;
	end if;
end process;
process(pcm_clk_signal_vector,clk)
variable pcm_clk_count1   :integer  range 0 to 32767;
variable pcm_clk_count2   :integer  range 0 to 32767;
variable pcm_gate_count1  :integer  range 0 to 32767;
variable pcm_gate_count2  :integer  range 0 to 32767;
variable pcm_in_count1  :integer  range 0 to 32767;
variable pcm_in_count2  :integer  range 0 to 32767;
variable pcm_gate2_count1  :integer  range 0 to 32767;
variable pcm_gate2_count2  :integer  range 0 to 32767;
begin

		if(rising_edge(clk))  then
			if(reset='0')  then
				pcm_clk_count1:=0;
				pcm_clk_count2:=0;
				pcm_gate_count1:=0;
				pcm_gate_count2:=0;		
				pcm_in_count1:=0;
				pcm_in_count2:=0;	
				pcm_gate_signal<='1';		
				pcm_in_signal<='1';
				pcm_clk_signal<='1';				
			end if;
			
			--clk
			if(pcm_clk_signal_vector="01") then  --rising_edge
				pcm_clk_count1:=30;
			elsif(pcm_clk_signal_vector="10") then
				pcm_clk_count2:=30;
			end if;
			if(pcm_clk_count1>0) then
				pcm_clk_count1:=pcm_clk_count1-1;
			end if;
			if(pcm_clk_count2>0) then
				pcm_clk_count2:=pcm_clk_count2-1;			
			end if;			
			if (pcm_clk_count1=1) then
				pcm_clk_signal<='1';
			end if;
			if (pcm_clk_count2=1) then
				pcm_clk_signal<='0';
			end if;			
			
			--gate
			if(pcm_gate_signal_vector="01") then  --rising_edge
				pcm_gate_count1:=30;
			elsif(pcm_gate_signal_vector="10") then
				pcm_gate_count2:=30;
			end if;
			if(pcm_gate_count1>0) then
				pcm_gate_count1:=pcm_gate_count1-1;
			end if;
			if(pcm_gate_count2>0) then
				pcm_gate_count2:=pcm_gate_count2-1;			
			end if;			
			if (pcm_gate_count1=1) then
				pcm_gate_signal<='1';
			end if;
			if (pcm_gate_count2=1) then
				pcm_gate_signal<='0';
			end if;		
			--gate2
			if(pcm_gate_signal2_vector="01") then  --rising_edge
				pcm_gate2_count1:=50;
			elsif(pcm_gate_signal2_vector="10") then
				pcm_gate2_count2:=50;
			end if;
			if(pcm_gate2_count1>0) then
				pcm_gate2_count1:=pcm_gate2_count1-1;
			end if;
			if(pcm_gate2_count2>0) then
				pcm_gate2_count2:=pcm_gate2_count2-1;			
			end if;			
			if (pcm_gate2_count1=1) then
				pcm_gate_signal2<='1';
			end if;
			if (pcm_gate2_count2=1) then
				pcm_gate_signal2<='0';
			end if;		

			
			--pcm
			if(pcm_in_signal_vector="01") then  --rising_edge
				pcm_in_count1:=30;
			elsif(pcm_in_signal_vector="10") then
				pcm_in_count2:=30;
			end if;
			if(pcm_in_count1>0) then
				pcm_in_count1:=pcm_in_count1-1;
			end if;
			if(pcm_in_count2>0) then
				pcm_in_count2:=pcm_in_count2-1;			
			end if;			
			if (pcm_in_count1=1) then
				pcm_in_signal<='1';
			end if;
			if (pcm_in_count2=1) then
				pcm_in_signal<='0';
			end if;					
			
			
			pcm_clk_delay<= pcm_clk_signal;
			pcm_gate_delay<= (pcm_gate_in and pcm_gate_signal and pcm_gate_signal2);
--			pcm_gate_delay<= pcm_gate_signal;
			pcm_out<= pcm_in_signal;
	end if;
end process;
END DALAY_FIT_architecture;
