---------------------------------------------------------------------------------------------------------------
-- Copyright  :  513 Di Mian Zhuang Bei Shi Ye Bu
-- Project    :  CPCI_UART
-- Module     :  UART TX module, read FIFO data into TXD data ,configure baud parameter,data bit,parity bit
-- File       :  UART_tx.vhd
-- Author     :  Xiaohm
-- Fuction    :  
-- Edition    :  V1.0
-- Date       :  2014-11-07
---------------------------------------------------------------------------------------------------------------
-- History    :
---------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity  UART_tx  is
    port(
        --------------global signals-----------
        sysclk_i            :    in    std_logic;
        reset_i_n        :    in    std_logic;
        s_reset_i_p      :    in    std_logic;
        -------------UART  signals-------------
        CPCI_enable_i_p  :    in    std_logic;
        uart_enable_i_p  :    in    std_logic;
        baud_s_i         :    in    std_logic_vector(15 downto 0);
        data_s_i         :    in    std_logic_vector(2 downto 0); 
        parity_s_i       :    in    std_logic_vector(1 downto 0);
        fifo_empty_i_n   :    in    std_logic;
        fifo_data_i      :    in    std_logic_vector(7 downto 0);
        fifo_rd_o_p      :    out   std_logic;
        data_txd_o       :    out   std_logic
    );
end UART_tx;

architecture FPGA of UART_tx is
	
	signal     clken          :     std_logic;
	signal     clk_div        :     std_logic_vector(15 downto 0);
	signal     rden           :     std_logic;
	signal     rden_dl        :     std_logic;
	signal     data_buf       :     std_logic_vector(7 downto 0);
	signal     data_cnt       :     std_logic_vector(2 downto 0);
	signal     parity_bit     :     std_logic;
	signal     state          :     std_logic_vector(2 downto 0);
	constant   IDLE           :     std_logic_vector(2 downto 0) := "000";
	constant   DATA_WAIT      :     std_logic_vector(2 downto 0) := "001";
	constant   START          :     std_logic_vector(2 downto 0) := "010";
	constant   PARITY         :     std_logic_vector(2 downto 0) := "011";
	
	begin
	  
		process(sysclk_i,reset_i_n,s_reset_i_p)
			begin
			  if(reset_i_n = '0' or s_reset_i_p = '1') then
			    clken      <= '0';
				 clk_div    <= "0000000000000000";
			  elsif rising_edge(sysclk_i)then
			    if(CPCI_enable_i_p = '1' and uart_enable_i_p = '1') then
				   
					 if(clk_div = baud_s_i - "0000000000000001")then
						 clken   <= '1';
						 clk_div <= "0000000000000000";
					 else
						 clken   <= '0';
						 clk_div <= clk_div + '1';
					 end if;
				 else
				    clken      <= '0';
				    clk_div    <= "0000000000000000";
				 end if;
			  end if;
		end process;
		
		----------Read FIFO signal ---------------
		process(sysclk_i,reset_i_n,s_reset_i_p)
			begin
			  if(reset_i_n = '0' or s_reset_i_p = '1') then
			     rden_dl   <= '0';
			  elsif rising_edge(sysclk_i) then
				 if(CPCI_enable_i_p = '1' and uart_enable_i_p = '1') then
			     rden_dl   <= rden;
				 else
				  rden_dl   <= '0';
				 end if;
			  end if;
		end process;
		
		fifo_rd_o_p   <= rden  and  (not rden_dl);
		
		--------Read FIFO and Send out------------
		process(sysclk_i,reset_i_n,s_reset_i_p)
			begin
			  if(reset_i_n = '0' or s_reset_i_p = '1') then
				  data_txd_o  <=  '1';
				  parity_bit  <=  '0';
				  rden        <=  '0';
				  data_cnt    <=  "000";
				  data_buf    <=  "00000000";
				  state       <=  IDLE;
			  elsif rising_edge(sysclk_i) then
			     if(CPCI_enable_i_p = '1' and uart_enable_i_p = '1') then
					  if(clken = '1') then
					     case  state is
						     when   IDLE     => 
									data_txd_o  <= '1';
									parity_bit  <=  '0';
									if(fifo_empty_i_n = '0') then
									   rden     <= '1';
										state    <=  DATA_WAIT;
									else
									   state    <=  IDLE;
									end if;
							   when  DATA_WAIT =>
								   rden        <= '0';
									data_txd_o  <= '0';
									data_buf    <= fifo_data_i;
									state       <= START;
								when   START    =>
								   data_txd_o  <= data_buf(0);
									parity_bit  <= parity_bit xor data_buf(0);
									data_buf(7) <= '1';
									data_buf(6 downto 0)  <= data_buf(7 downto 1);
									if(data_cnt = data_s_i)then
									   data_cnt <= "000";
										if(parity_s_i = "00") then  ----no parity
										   state  <= IDLE;
										else
										   state  <= PARITY;
										end if;
									else
									   data_cnt  <= data_cnt + '1';
										state     <= START;
									end if;
							    when   PARITY  =>
								    if(parity_s_i = "01") then
									    data_txd_o <= not parity_bit;
									 elsif(parity_s_i = "10") then
									    data_txd_o <= parity_bit;
									 end if;
									 state  <= IDLE;
								 when  OTHERS  =>
								    state  <= IDLE;
						  end case;
						else
						   state  <= state;
						end if;
				   else
					  state  <= IDLE;
					end if;
												
			  end if;  
		end process;
	   
	

end FPGA;