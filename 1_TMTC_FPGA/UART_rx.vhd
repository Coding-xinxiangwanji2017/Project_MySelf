---------------------------------------------------------------------------------------------------------------
-- Copyright  :  513 Di Mian Zhuang Bei Shi Ye Bu
-- Project    :  CPCI_UART
-- Module     :  UART RX module, write RXD data into FIFO,generate interrupt signal
-- File       :  UART_rx.vhd
-- Author     :  Xiaohm
-- Fuction    :
-- Edition    :  V1.0
-- Date       :  2014-11-08
---------------------------------------------------------------------------------------------------------------
-- History    :
---------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity  UART_rx  is
    port(
        --------------global signals-----------
        sysclk_i         :    in    std_logic;
        reset_i_n        :    in    std_logic;
        s_reset_i_p      :    in    std_logic;
        -------------UART  signals-------------
        CPCI_enable_i_p  :    in    std_logic;
        baud_s_i         :    in    std_logic_vector(15 downto 0);
        data_s_i         :    in    std_logic_vector(2 downto 0);
        parity_s_i       :    in    std_logic_vector(1 downto 0);
        data_rxd_i       :    in    std_logic;
        fifo_data_o      :    out   std_logic_vector(7 downto 0);
        fifo_wr_o_p      :    out   std_logic;
        time_out         :    out   std_logic
	);
end UART_rx;

architecture FPGA of UART_rx is

	signal     clk_cnt        :     std_logic_vector(15 downto 0);
	signal     data_buf       :     std_logic_vector(7 downto 0);
	signal     data_cnt       :     std_logic_vector(2 downto 0);
	signal     wren           :     std_logic;
	signal     fault          :     std_logic;
	signal     state          :     std_logic_vector(2 downto 0);
	constant   IDLE           :     std_logic_vector(2 downto 0) := "000";
	constant   START          :     std_logic_vector(2 downto 0) := "001";
	constant   PARITY         :     std_logic_vector(2 downto 0) := "010";
	constant   STOP           :     std_logic_vector(2 downto 0) := "011";
	signal     r_start        :     std_logic;
	signal     r_clear        :     std_logic;
	signal     r_cnt_en       :     std_logic;
	signal     r_time_count   :     std_logic_vector(19 downto 0);
	signal     r_timeout      :     std_logic;
	signal     result_xor     :     std_logic;

begin

	  fifo_wr_o_p    <= wren;
	  time_out       <= r_timeout;
	  ----------------Serial  To  Parallel---------------
    process(sysclk_i,reset_i_n,s_reset_i_p) begin
	    if(reset_i_n = '0' or s_reset_i_p = '1') then
	    	 wren         <=  '0';
	    	 clk_cnt      <=  X"0000";
	    	 data_cnt     <=  "000";
	    	 data_buf     <=  X"00";
	    	 fifo_data_o  <=  X"00";
	    	 fault        <=  '1';
	    	 state        <=  IDLE;
	    elsif rising_edge(sysclk_i)then
            if(CPCI_enable_i_p = '1') then
                case state is
                when IDLE =>
                   wren   <=  '0';
                   if(data_rxd_i = '0') then
                       if((('0'&baud_s_i(15 downto 1))-1)= clk_cnt) then
                           clk_cnt  <= X"0000";
                           data_cnt <= "000";
                           data_buf <= X"00";
                           state    <= START;
                       elsif((('0'&baud_s_i(15 downto 1))-1) < clk_cnt) then --xxl 20150824
                           clk_cnt      <=  X"0000";
                       else
                           clk_cnt      <=  clk_cnt + '1';
                           state        <=  IDLE;
                       end if;
                   else
                       clk_cnt <= X"0000";
                       state   <= IDLE;
                   end if;
        
               when  START   =>
                   if(clk_cnt = baud_s_i - X"0001")then
                       clk_cnt     <= X"0000";
                       data_buf(7) <= data_rxd_i;
                       data_buf(6 downto 0)<= data_buf(7 downto 1);
                       if(data_cnt = data_s_i)then
                           data_cnt     <=  "000";
                           if(parity_s_i = "00") then
                               fault     <=  '0';
                               state     <=  STOP;
                           else
               			    state <= PARITY;
                           end if;
                       else
                           data_cnt  <=  data_cnt + '1';
                           state     <=  START;
                       end if;
                   else
                       clk_cnt   <=  clk_cnt  +  '1';
                       state     <=  START;
                   end if;
        
               when  PARITY  =>
                   result_xor <= data_buf(7) xor data_buf(6) xor data_buf(5) xor data_buf(4) xor data_buf(3) xor data_buf(2) xor data_buf(1) xor data_buf(0);
                   if(clk_cnt = baud_s_i - X"0001")then
                       clk_cnt <= X"0000";
                       state   <= STOP;
                       if(parity_s_i = "01")then      ------odd check
                           if(data_rxd_i = not result_xor) then
                               fault     <=  '0';
                           else
                               fault     <=  '1';
                           end if;
                       elsif(parity_s_i = "10") then
                           if(data_rxd_i = result_xor) then
                               fault <= '0';
                           else
                               fault <= '1';
                           end if;
                       end if;
                   else
                       clk_cnt <= clk_cnt + '1';
                       state   <= PARITY;
                   end if;
                       
               when STOP =>
                   if(clk_cnt = baud_s_i - X"0001")then
                       clk_cnt         <=  X"0000";
                       state           <=  IDLE;
                       if(data_rxd_i = '1') then
                           fifo_data_o <= data_buf;
                           wren        <= '1';
                       end if;
                   else
                       clk_cnt <= clk_cnt + '1';
                       state   <= STOP;
                   
                   end if;
                       
                when  OTHERS  => 
                    state <= IDLE;

               end case;
                   
           end if;
	    end if;
    end process;

	  process(sysclk_i,reset_i_n,s_reset_i_p)
		 begin
		   if(reset_i_n = '0' or s_reset_i_p = '1') then
				  r_clear    <=   '0';
			elsif rising_edge(sysclk_i)then
			  if(CPCI_enable_i_p = '1')then
			   if(state = START)then
				  r_clear    <=   '1';
				else
				  r_clear    <=   '0';
				end if;
			  else
			     r_clear    <=   '0';
			  end if;
		   end if;
	  end process;

	  process(sysclk_i,reset_i_n,s_reset_i_p)
		  begin
		    if(reset_i_n = '0' or s_reset_i_p = '1') then
				  r_start      <= '0';
			 elsif rising_edge(sysclk_i)then
			  if(CPCI_enable_i_p = '1')then
			   if(wren = '1') then
				  r_start      <= '1';
				else
				  r_start      <= '0';
				end if;
			  else
			     r_start      <= '0';
			  end if;
			 end if;
	  end process;

	   process(sysclk_i,reset_i_n,s_reset_i_p)
		  begin
		    if(reset_i_n = '0' or s_reset_i_p = '1') then
				  r_cnt_en      <= '0';
			 elsif rising_edge(sysclk_i)then
			  if(CPCI_enable_i_p = '1')then
			   if(r_clear = '1') then
				  r_cnt_en      <= '0';
				elsif(r_start = '1')then
				  r_cnt_en      <= '1';
				end if;
			  else
			     r_cnt_en      <= '0';
			  end if;
			 end if;
	  end process;

	  process(sysclk_i,reset_i_n,s_reset_i_p)
		  begin
		    if(reset_i_n = '0' or s_reset_i_p = '1') then
			   r_time_count   <=  X"00000";
			 elsif rising_edge(sysclk_i)then
			  if(CPCI_enable_i_p = '1')then
			   if(r_cnt_en = '1') then
				  if(r_time_count = X"75300")then    --------48000
					  r_time_count <= X"75300";
				  else
				     r_time_count <= r_time_count + '1';
				  end if;
				else
				     r_time_count   <=  X"00000";
				end if;
			  else
			        r_time_count   <=  X"00000";
			  end if;
        end if;
	  end process;

	  process(sysclk_i,reset_i_n,s_reset_i_p)
		 begin
		   if(reset_i_n = '0' or s_reset_i_p = '1') then
				    r_timeout    <=  '0';
	      elsif rising_edge(sysclk_i)then
            if(CPCI_enable_i_p = '1')then
--					if(r_time_count = X"752ff")then    --xxl
					if(r_time_count = X"12bf")then    --xxl
						r_timeout  <=  '1';
					else
					   r_timeout  <=  '0';
					end if;
				else
				      r_timeout  <=  '0';
				end if;
			end if;
		end process;




end FPGA;