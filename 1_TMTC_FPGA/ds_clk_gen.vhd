library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ds_clk_gen is
    port(
        clk                             : in  std_logic;  --33M
		reset                           : in  std_logic;
		clk_1M                          : in  std_logic;
		cs                              : in  std_logic;
		ds_clk                          : out std_logic;
		ds_gate                         : out std_logic
	);
end ds_clk_gen;

ARCHITECTURE ds_clk_gen_architecture OF ds_clk_gen IS

signal  counter_16384  :integer range 0 to 25384;
signal  clk_1M_vector : std_logic_vector(1 downto 0);
signal  ds_clk_signal : std_logic;
signal  state         : std_logic_vector(2 downto 0);

BEGIN
process(clk)
begin
	if(rising_edge(clk)) then
		clk_1M_vector(1)<=clk_1M_vector(0);
		clk_1M_vector(0)<=clk_1M;
	end if;
end process;

process(clk,reset)
    variable clk_1M_counter :integer range 0 to 360;
begin

	if(rising_edge(clk)) then
		if(reset='0') then
			clk_1M_counter:=0;
			state<="000";
		end if;
		    
		if(clk_1M_vector="01") then
			if(clk_1M_counter= 360) then	
				clk_1M_counter:= 0;
			else
				clk_1M_counter:= clk_1M_counter+1;
			end if;				
		end if;
		    
		case state is
			when "000"=>
				if cs = '0' then
					state <= "001";
					clk_1M_counter:=0;
				else
					state <= "000";
				end if;
			when "001"=>
				if clk_1M_counter = 40 then
					state <= "010";
				else
					state <= "001";
				end if;
			when "010"=>
				if clk_1M_counter = 308 then
					state <= "011";
				else
					state <= "010";
				end if;
			when "011" =>
				if clk_1M_counter = 360 then
					state <= "000";
				else
					state <= "011";
				end if;			
			when others =>
				state <= "000";
		end case;
	end if;
end process;

process (state,clk)
    variable ds_clk_counter   :integer range 0 to 18;
    begin
		ds_clk<=ds_clk_signal;

	if(rising_edge(clk)) then		
			case state is
				when "000" =>
					ds_clk_signal<='1';
					ds_gate<='1';
					ds_clk_counter:=0;
				when "001" =>
					ds_clk_signal<='1';
					ds_gate<='0';
				when "010" =>
					ds_gate<='0';	
					if(clk_1M_vector="01") then
						if(ds_clk_counter=18) then
							ds_clk_counter:=1;
						else
							ds_clk_counter:= ds_clk_counter+1;
						end if;
						if(ds_clk_counter<17) then
							ds_clk_signal<= not ds_clk_signal;
						else
							ds_clk_signal<='1';
						end if;
					end if;
					
				when "011" =>
					ds_clk_signal<='1';
					ds_gate<='0';	
				when others =>
					ds_clk_signal<='1';
					ds_gate<='1';					
			end case;
	end if;
end process;

END ds_clk_gen_architecture;
