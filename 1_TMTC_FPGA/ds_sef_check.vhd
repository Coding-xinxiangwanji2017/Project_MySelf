library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ds_sef_check is
    port(
		clk                             : in  std_logic;                        -- Clk 33M;single 
		reset                           : in  std_logic;
		ds_clk_in                       : in  std_logic;
		ds_gate_in                      : in  std_logic;
		data_in                         : in  std_logic_vector(7 downto 0);
		ad                              : out std_logic_vector(4 downto 0);
		ds_data_out                     : out std_logic
	);
end ds_sef_check;

architecture ds_sef_check_architecture of ds_sef_check is

    signal  ds_gate_vector              : std_logic_vector(1 downto 0);
    signal  ds_clk_vector               : std_logic_vector(1 downto 0);
    signal  ds_data_signal              : std_logic;
    signal  Adr_updata1                 : std_logic;
    signal  Adr_updata2                 : std_logic;
    signal  Adr_updata3                 : std_logic;

begin

process (clk)
    variable counter_pcm : integer range 0 to 15;
    variable counter_ad  : integer range 0 to 31;
    variable ds_data_in_signal : std_logic_vector(7 downto 0);
    variable ad_signal : std_logic_vector(4 downto 0);
    begin
    	ad <= ad_signal;
    	ds_data_out<= ds_data_in_signal(7);

        if(rising_edge(clk)) then

    		ds_gate_vector(1)<=ds_gate_vector(0);
    		ds_gate_vector(0)<=ds_gate_in;

    		ds_clk_vector(1)<=ds_clk_vector(0);
    		ds_clk_vector(0)<=ds_clk_in;
    		    
            if(ds_gate_vector="10") then    -- falling edge
    			counter_pcm:=1;
    			counter_ad:=0;
    			ds_data_in_signal:= data_in;
    			ad_signal:="00000";
    			Adr_updata1<='0';
            end if;
                
            if(Adr_updata1='0') then
    			Adr_updata1<='1';
    			Adr_updata2<='0';
            end if;
                
            if(Adr_updata2='0') then
    			Adr_updata2<='1';
    			ds_data_in_signal:= data_in;
            end if;
                
            if(ds_clk_vector="01") then    -- rising_edge 
                if(counter_pcm=8) then
    				counter_pcm:= 1;
    --				ad_signal:=ad_signal+'1';
    				ds_data_in_signal:= data_in;
                elsif(counter_pcm=1) then
    				counter_pcm:= counter_pcm+1;
    				ad_signal:=ad_signal+'1';
    				ds_data_in_signal(7 downto 1):=ds_data_in_signal(6 downto 0);
                else
    				counter_pcm:= counter_pcm+1;
    				ds_data_in_signal(7 downto 1):=ds_data_in_signal(6 downto 0);
                end if;

            end if;

        end if;
    end process;

END ds_sef_check_architecture;
