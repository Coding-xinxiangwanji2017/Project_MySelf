library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity zl_chanle_slec is
    port(
        --------------------------------
        -- Clock\Reset
        --------------------------------
        clk             : in  std_logic;
		reset           : in  std_logic;
		cs_sel_chanle   : in  std_logic;
		data            : in  std_logic_vector(15 downto 0);
		    
		-- Clk_input
		clk_input1      : in  std_logic;
		clk_input2      : in  std_logic;
		clk_input3      : in  std_logic;
		clk_input4      : in  std_logic;
		clk_output1	    : out std_logic;
		clk_output2     : out std_logic;
		clk_output3     : out std_logic;
		clk_output4     : out std_logic;
		
		--PCM_Clk
		pcm_input1      : in  std_logic;
		pcm_input2      : in  std_logic;
		pcm_input3      : in  std_logic;
		pcm_input4      : in  std_logic;
		pcm_output1	    : out std_logic;
		pcm_output2     : out std_logic;
		pcm_output3     : out std_logic;
        pcm_output4     : out std_logic;		
	);
end zl_chanle_slec;

ARCHITECTURE zl_chanle_slec_architecture OF zl_chanle_slec IS	
    signal PrSv_Chanle_s : std_logic_vector(3 downto 0);

begin
    process (reset,clk) begin
        if(rising_edge(clk))   then
            if(reset='0') then
            	chanle_signal<="1111";
            elsif(cs_sel_chanle='0') then
            	chanle_signal(3 downto 0)<=  data(3 downto 0);
            end if;
            
            if(chanle_signal(0)='1') then  --di 4lu
            	clk_output1 <= clk_input1;
            	pcm_output1 <= pcm_input1;
            else
            	clk_output1 <='1';
            	pcm_output1 <='0';	
            end if;
            		
            if(chanle_signal(1)='1') then--di 4lu
            	clk_output2 <= clk_input2;
            	pcm_output2 <= pcm_input2;
            else
            	clk_output2 <='1';
            	pcm_output2 <='0';	
            end if;
            
            if(chanle_signal(2)='1') then--di 4lu
            	clk_output3 <= clk_input3;
            	pcm_output3 <= pcm_input3;
            else
            	clk_output3 <='1';
            	pcm_output3 <='0';	
            end if;
            
            if(chanle_signal(3)='1') then  --di 4lu
            	clk_output4 <= clk_input4;
            	pcm_output4 <= pcm_input4;
            else
            	clk_output4 <='1';
            	pcm_output4 <='0';	
            end if;

        end if;
    end process;
END zl_chanle_slec_architecture;
