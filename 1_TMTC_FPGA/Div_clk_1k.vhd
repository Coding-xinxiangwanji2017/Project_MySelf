library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY Div_clk_1k IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		clk   :in std_logic;  --18.432M
		reset :in std_logic;
		div_clk_1ms :out std_logic;
		div_clk_1s  :out std_logic;
		div_clk_10ms :out std_logic;
		div_clk_5ms  :out std_logic;
		div_clk_50ms  :out std_logic;
		div_clk_100ms :out std_logic;
		div_clk_200ms :out std_logic
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
	
END Div_clk_1k;

ARCHITECTURE Div_clk_1k_architecture OF Div_clk_1k IS

--signal counter_16384  :integer range 0 to 25384;


signal  pcm_clk_signal_1ms : std_logic;
signal  pcm_clk_signal_1s : std_logic;
signal  pcm_clk_signal_10ms :std_logic;
signal  pcm_clk_signal_5ms : std_logic;
signal  pcm_clk_signal_50ms : std_logic;
signal  pcm_clk_signal_100ms :std_logic;
signal  pcm_clk_signal_200ms :std_logic;
signal  pcm_clk_signal_500us :std_logic;

beign 

    div_clk_1ms     <= pcm_clk_signal_1ms;
    div_clk_10ms    <= pcm_clk_signal_10ms;
    div_clk_1s      <= pcm_clk_signal_1s;
    div_clk_5ms     <= pcm_clk_signal_5ms;
    div_clk_50ms    <= pcm_clk_signal_50ms;
    div_clk_100ms   <= pcm_clk_signal_100ms;
    div_clk_200ms   <= pcm_clk_signal_200ms;

process(clk,reset,pcm_clk_signal_1ms)
variable  counter_16384_1  :integer range 0 to 16384;
variable  counter_16384_2  :integer range 0 to 16384;
begin
	if (reset='0') then

		counter_16384_1:=0;
		pcm_clk_signal_1ms<='1';
		
	elsif rising_edge(clk)  then
		counter_16384_1 :=counter_16384_1+1;
		counter_16384_2 :=counter_16384_2+1;		
	    if(counter_16384_1=16500) then
			counter_16384_1:=0;
			pcm_clk_signal_1ms<= not pcm_clk_signal_1ms;
		 end if;
	    if(counter_16384_2=8250) then
			counter_16384_2:=0;
			pcm_clk_signal_500us<= not pcm_clk_signal_500us;
		 end if;		 

	end if;
		
end process;
process(pcm_clk_signal_1ms)
variable counter_100000    :integer range 0 to 100000;
begin	
	if (reset='0') then

		counter_100000:=0;
		pcm_clk_signal_1s<='1';
	elsif rising_edge(pcm_clk_signal_1ms)  then
		 counter_100000 :=counter_100000 + 1;
	    if(counter_100000 = 500) then
			counter_100000:=0;
			pcm_clk_signal_1s<= not pcm_clk_signal_1s;
		end if;

	end if;
end process;

process(pcm_clk_signal_1ms)
variable counter_10    :integer range 0 to 10;
begin	
	if (reset='0') then

		counter_10:=0;
		pcm_clk_signal_10ms<='1';
	elsif rising_edge(pcm_clk_signal_1ms)  then
		counter_10 :=counter_10+1;
	    if(counter_10=5) then
			counter_10:=0;
			pcm_clk_signal_10ms<= not pcm_clk_signal_10ms;
		end if;

	end if;
end process;

process(pcm_clk_signal_500us)
variable counter_100    :integer range 0 to 100;
begin	
	if (reset='0') then

		counter_100:=0;
		pcm_clk_signal_5ms<='1';
	elsif falling_edge(pcm_clk_signal_500us)  then
		counter_100 :=counter_100+1;
	    if(counter_100=5) then
			counter_100:=0;
			pcm_clk_signal_5ms<= not pcm_clk_signal_5ms;
		end if;
	end if;
end process;

process(pcm_clk_signal_1ms)
variable counter_100    :integer range 0 to 100;
begin
	if (reset='0') then

		counter_100:=0;
		pcm_clk_signal_50ms<='1';
	elsif rising_edge(pcm_clk_signal_1ms)  then
		counter_100 :=counter_100+1;
	    if(counter_100=25) then
			counter_100:=0;
			pcm_clk_signal_50ms<= not pcm_clk_signal_50ms;
		end if;

	end if;
end process;


process(pcm_clk_signal_1ms)
variable counter_1000    :integer range 0 to 1000;
begin	
	if (reset='0') then

		counter_1000:=0;
		pcm_clk_signal_100ms<='1';
	elsif rising_edge(pcm_clk_signal_1ms)  then
		counter_1000 :=counter_1000+1;
	    if(counter_1000=50) then
			counter_1000:=0;
			pcm_clk_signal_100ms<= not pcm_clk_signal_100ms;
		end if;

	end if;
end process;

process(pcm_clk_signal_1ms)
variable counter_1000    :integer range 0 to 1000;
begin	
	if (reset='0') then

		counter_1000:=0;
		pcm_clk_signal_200ms<='1';
	elsif rising_edge(pcm_clk_signal_1ms)  then
		counter_1000 :=counter_1000+1;
	    if(counter_1000=100) then
			counter_1000:=0;
			pcm_clk_signal_200ms<= not pcm_clk_signal_200ms;
		end if;

	end if;
end process;



END Div_clk_1k_architecture;
