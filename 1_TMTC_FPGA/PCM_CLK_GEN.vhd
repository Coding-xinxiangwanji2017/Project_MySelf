library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PCM_CLK_GEN is
    port(
		clk                             :in  std_logic;                         -- Clk 18.432MHz single
		reset                           :in  std_logic;                         -- reset,active high
		pcm_clk                         :out std_logic;                         -- PCM_Clk
		frame_end                       :out std_logic                          -- Frame
	);
end PCM_CLK_GEN;

architecture PCM_CLK_GEN_architecture of PCM_CLK_GEN is
    ------------------------------------ 
    -- describe integer                 
    ------------------------------------ 
    signal counter_16384  : integer range 0 to 16383;
    signal counter_2047   : integer range 0 to 8192;
    
    ------------------------------------ 
    -- describe PCM_Clk                 
    ------------------------------------ 
    signal pcm_clk_signal : std_logic;

begin
    ------------------------------------
    --PCM_Clk
    ------------------------------------
    
    pcm_clk_signal <= pcm_clk;
    
    process (reset,clk) begin
        if (reset = '1') then
            counter_16384 <= (others => '0');
        elsif rising_edge(clk) then 
            if (counter_16384 = 1593) then
                counter_16384 <= (others => '0');
            else
                counter_16384 <= counter_16384 + '1';
            end if;
        end if;
    end process;

    process(clk,reset,pcm_clk_signal) begin
        if (reset='1') then
    		counter_2047<=1;
    		frame_end<='1';
    		pcm_clk_signal<='1';
        elsif rising_edge(clk)  then    		
    	    if(counter_16384=1953) then
    			pcm_clk_signal<= not pcm_clk_signal;
    			counter_2047<= counter_2047+1;
            end if;
                
            if ((counter_2047>4080) and (counter_2047<4097)) then
    			frame_end<='0';
            elsif (counter_2047=4097) then
    			frame_end<= '1';
    			counter_2047<=1;
            else
    			frame_end<='1';
            end if;
        end if;

    end process;

end PCM_CLK_GEN_architecture;
