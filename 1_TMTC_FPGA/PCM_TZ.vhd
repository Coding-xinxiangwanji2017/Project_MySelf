library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--  Entity Declaration

ENTITY PCM_TZ IS

	PORT
	(
		clk        :in std_logic;
		pcm_gate   :out std_logic;
		pcm        :out std_logic;
		pcm_clk    :out std_logic;
		send_signal  :in std_logic;
		FIFO2_rd   :out std_logic;
		inData     :in  std_logic_vector(15 downto 0);
		reset      :in std_logic;
		data_length_L  : in std_logic_vector(15 downto 0)		
	);

	
END PCM_TZ;
--  Architecture Bo
ARCHITECTURE PCM_TZ_architecture OF PCM_TZ IS
signal pcm_clk_signal    :std_logic;
signal pcm_clk_signal_vector  :std_logic_vector (1 downto 0);
signal send_signal_vector     :std_logic_vector(1 downto 0);


signal pcm_gate_signal    :std_logic;
signal pcm_clk_delay      :std_logic;
BEGIN
pcm_clk<= (not pcm_clk_signal);
pcm_gate<= pcm_gate_signal;

process(clk,reset)
variable count   :integer  range 0 to 32767;	
variable count_data :integer range 0 to 200;
begin
	if(rising_edge(clk))  then
		if reset='0' then
		   count:=1;
		   pcm_clk_signal<='1';
		else
			count:= count+1;
			if(33=count)		then
				pcm_clk_signal<= '0';
			elsif(66=count)	then
			    count:=0;
			    pcm_clk_signal<= '1';
			end if;
		end if;
	end if;
end process;

process(clk,pcm_clk_signal,send_signal)
begin
	if rising_edge(clk)   then
		pcm_clk_signal_vector(1)<=pcm_clk_signal_vector(0);
		pcm_clk_signal_vector(0)<= pcm_clk_signal;
		    
		send_signal_vector(1)<=send_signal_vector(0);
		send_signal_vector(0)<=send_signal;
	end if;
end process;

process(send_signal,clk,pcm_clk_signal_vector,send_signal_vector,reset)
variable count_sendData :integer range 0 to 1023;
variable count_pcm   :integer range 0 to 23;
variable send_data_buffer   :std_logic_vector(15 downto 0);
variable fifo2_rd_temp      :std_logic;
begin
if rising_edge(clk) then
	if(reset='0')	then
		pcm_gate_signal<='1';
		count_sendData:=0;
	end if;
	if send_signal_vector ="01" then  --rising_edge
		   fifo2_rd_temp:='1';
	elsif  (send_signal_vector ="10")  then
	   send_data_buffer(15 downto 0):=inData(15 downto 0);
	   count_sendData:=CONV_INTEGER(data_length_L);
	   count_pcm:= 0;
		fifo2_rd_temp:='1';   --20140710
	else
			if((pcm_clk_signal_vector="01"))   then
				pcm_clk_delay<= pcm_clk_signal;
			   if (count_sendData=0)  then
				   pcm_gate_signal<='1';
			   end if;
			end if;
			if ((pcm_clk_signal_vector="01") and (count_sendData>0))   then  --rising_edge
			
			   pcm_gate_signal<='0';  --
--			   pcm<= send_data_buffer(0);   --xxl 20140731
			   pcm<= send_data_buffer(15); 
--			   send_data_buffer(14 downto 0):=send_data_buffer(15 downto 1);  --xxl 20140731
			   send_data_buffer(15 downto 1):=send_data_buffer(14 downto 0);
			   count_pcm:=count_pcm+1;
--				count_sendData:=count_sendData-1;  --xxl 20140704
			   if (count_pcm=16) then
					count_sendData:=count_sendData-1;  --xxl 20140704
					count_pcm:=0;
					fifo2_rd_temp:='1';
					send_data_buffer(15 downto 0):=inData(15 downto 0);
				else 
					fifo2_rd_temp:='0';
			   end if;
				
			 else 
				fifo2_rd_temp:='0';  
			 end if;
	end if;
	
end if;
	FIFO2_rd<=fifo2_rd_temp;
end process;
END PCM_TZ_architecture;
