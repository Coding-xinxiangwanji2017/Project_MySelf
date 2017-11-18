library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--  Entity Declaration

entity data_gen is
    port(
        clk                             : in  std_logic;
		pcm_clk                         : in  std_logic;
		pcm_pusle                       : in  std_logic;
		reset                           : in  std_logic;	
		pcm_out                         : out std_logic_vector(7 downto 0)
	);
end data_gen;
--  Architecture Bo
architecture data_gen_architecture of data_gen is
    signal pcm_clk_signal_vector        : std_logic_vector(1 downto 0);
    signal pcm_pusle_vector             : std_logic_vector(1 downto 0);
    signal data_sor                     : std_logic_vector(7 downto 0);
    signal Frame_num                    : std_logic_vector(7 downto 0);
    
begin 

process(clk,pcm_clk)
begin
    if rising_edge(clk) then
		pcm_clk_signal_vector(1)<=pcm_clk_signal_vector(0);
		pcm_clk_signal_vector(0)<= pcm_clk;
		pcm_pusle_vector(0)<=pcm_pusle;
		pcm_pusle_vector(1)<=pcm_pusle_vector(0);
    end if;
end process;

process(clk,pcm_clk_signal_vector,reset)
variable count :integer range 8 downto 0;
begin

if rising_edge(clk) then
	if(reset='1')	then
		data_sor<="00000000";
		Frame_num<="00000000";
	elsif (pcm_pusle='0') then
		data_sor<="00000000";
		pcm_out<=Frame_num;
		Frame_num<=Frame_num+1;
	elsif ((pcm_clk_signal_vector="01"))   then  --rising_edge
		count:=count+1;
		if(count=8) then
			count:=0;
			pcm_out<=data_sor;
			data_sor<=data_sor+'1';
		end if;
	end if;
end if;
end process;
END data_gen_architecture;