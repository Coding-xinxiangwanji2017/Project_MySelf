--------------------------------------------------------------------------------
--           *****************          *****************
--                           **        **
--               ***          **      **           **
--              *   *          **    **           * *
--             *     *          **  **              *
--             *     *           ****               *
--             *     *          **  **              *
--              *   *          **    **             *
--               ***          **      **          *****
--                           **        **
--           *****************          *****************
--------------------------------------------------------------------------------
-- 版    权  :  BiXing Tech
-- 文件名称  :  M_Test.vhd
-- 设    计  :  zhang wen jun
-- 邮    件  :  
-- 校    对  :
-- 设计日期  :  2016/3/2
-- 功能简述  :  200Hz/100Hz/60Hz/50Hz
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wen jun, 2016/3/2
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity M_Test is
    generic (
        Simulation                      : integer := 1
    );    
    port (
        --------------------------------
        -- Rst & Clk
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- Rst, active low
        CpSl_Clk_i                      : in  std_logic;                        -- Clk, 100Mhz signal
        
        --------------------------------
        -- Refersh Rate Choice
        --------------------------------
        CpSv_FreChoice_i                : in std_logic_vector(2 downto 0);      -- FreChoice
        
        --------------------------------
        -- Test Pulse
        --------------------------------
        CpSl_Test_o                     : out std_logic                         -- Test Pulse
    );
end M_Test;

architecture arch_M_Test of M_Test is 
    ----------------------------------------------------------------------------
    --constant declaration
    ----------------------------------------------------------------------------
    -- FreChoice                                       
    constant PrSv_Ref150Hz_c            : std_logic_vector( 2 downto 0) := "100"; -- 150Hz 
   
    constant PrSv_Ref200Hz_c            : std_logic_vector( 2 downto 0) := "110"; -- 200Hz
    constant PrSv_Ref100Hz_c            : std_logic_vector( 2 downto 0) := "011"; -- 100Hz
    constant PrSv_Ref60Hz_c             : std_logic_vector( 2 downto 0) := "101"; -- 60Hz
    constant PrSv_Ref50Hz_c             : std_logic_vector( 2 downto 0) := "111"; -- 50Hz
    
    -- Cnt
    constant PrSv_100usCnt_c            : std_logic_vector(23 downto 0):= x"002327"; -- 100us Cnt
    constant PrSv_1msCnt_c              : std_logic_vector(23 downto 0):= x"015F8F"; -- 1ms  Cnt
    constant PrSv_2msCnt_c              : std_logic_vector(23 downto 0):= x"02BF1F"; -- 2ms  Cnt

    constant PrSv_6msCnt_c              : std_logic_vector(23 downto 0):= x"0927BF"; -- 6.67ms Cnt
      
    constant PrSv_5msCnt_c              : std_logic_vector(23 downto 0):= x"061A87"; -- 5ms  Cnt
    constant PrSv_10msCnt_c             : std_logic_vector(23 downto 0):= x"0C3500"; -- 10ms Cnt
    constant PrSv_16msCnt_c             : std_logic_vector(23 downto 0):= x"145855"; -- 16ms Cnt
    constant PrSv_20msCnt_c             : std_logic_vector(23 downto 0):= x"186A00"; -- 20ms Cnt  
                                                                                               
    ----------------------------------------------------------------------------
    --signal declaration
    ----------------------------------------------------------------------------
    signal PrSl_1msTrig_s               : std_logic;                            -- 1ms Trig
    signal PrSl_2msTrig_s               : std_logic;                            -- 2ms Trig
    signal PrSv_Cnt_s                   : std_logic_vector(23 downto 0);        -- Cnt
    signal PrSv_TestCnt_s               : std_logic_vector(23 downto 0);        -- Generate Cnt
    signal PrSv_FreChoiceDly1_s         : std_logic_vector( 2 downto 0);        -- Delay CpSv_FreChoice_i 1 Clk
    signal PrSv_FreChoiceDly2_s         : std_logic_vector( 2 downto 0);        -- Delay CpSv_FreChoice_i 2 Clk


begin
    -- Delay PrSv_Refresh_Rate_s 
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_FreChoiceDly1_s <= (others => '0');
            PrSv_FreChoiceDly2_s <= (others => '0');
                
        elsif rising_edge (CpSl_Clk_i) then 
            PrSv_FreChoiceDly1_s <= CpSv_FreChoice_i;
            PrSv_FreChoiceDly2_s <= PrSv_FreChoiceDly1_s;
                
        end if;
    end process;
    
    -- Choice Frequence
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_TestCnt_s <= (others => '0');
        elsif rising_edge (CpSl_Clk_i) then 
            case PrSv_FreChoiceDly2_s is 
                when PrSv_Ref200Hz_c =>  -- 200Hz 
                    PrSv_TestCnt_s <= PrSv_5msCnt_c;
                
                when PrSv_Ref100Hz_c =>  -- 100Hz 
                    PrSv_TestCnt_s <= PrSv_10msCnt_c;
                    
                when PrSv_Ref60Hz_c =>  -- 60Hz 
                    PrSv_TestCnt_s <= PrSv_16msCnt_c;
                
                when PrSv_Ref50Hz_c =>  -- 50Hz
                    PrSv_TestCnt_s <= PrSv_20msCnt_c;
                    
                when PrSv_Ref150Hz_c =>  -- 150Hz 
                    PrSv_TestCnt_s <= PrSv_6msCnt_c;
                
                when others => 
                    PrSv_TestCnt_s <= (others => '0');
                        
            end case;
        end if;
    end process;
    
    --Cnt
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_Cnt_s <= (others => '0');
        elsif rising_edge (CpSl_Clk_i) then 
            if (PrSv_Cnt_s = PrSv_TestCnt_s) then
                PrSv_Cnt_s <= (others => '0');
            else
                PrSv_Cnt_s <= PrSv_Cnt_s + '1';
            end if;
        end if;
    end process;
    
    Sim_Trig : if (Simulation = 0) generate  
    -- 1ms Trig
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_1msTrig_s <= '0';
        elsif rising_edge (CpSl_Clk_i) then 
            if (PrSv_Cnt_s = PrSv_100usCnt_c) then
                PrSl_1msTrig_s <= '1';
            else
                PrSl_1msTrig_s <= '0';
            end if;
        end if;
    end process;
    
    -- 2ms Trig
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_2msTrig_s <= '0';
        elsif rising_edge (CpSl_Clk_i) then 
            if (PrSv_Cnt_s = PrSv_1msCnt_c) then
                PrSl_2msTrig_s <= '1';
            else
                PrSl_2msTrig_s <= '0';
            end if;
        end if;
    end process;
    end generate Sim_Trig;
    
    Real_Trig : if (Simulation = 1) generate  
    -- 1ms Trig
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_1msTrig_s <= '0';
        elsif rising_edge (CpSl_Clk_i) then 
            if (PrSv_Cnt_s = PrSv_1msCnt_c) then
                PrSl_1msTrig_s <= '1';
            else
                PrSl_1msTrig_s <= '0';
            end if;
        end if;
    end process;
    
    -- 2ms Trig
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_2msTrig_s <= '0';
        elsif rising_edge (CpSl_Clk_i) then 
            if (PrSv_Cnt_s = PrSv_2msCnt_c) then
                PrSl_2msTrig_s <= '1';
            else
                PrSl_2msTrig_s <= '0';
            end if;
        end if;
    end process;
    end generate Real_Trig;
    
    -- Text Pulse
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            CpSl_Test_o <= '0';
        elsif rising_edge (CpSl_Clk_i) then 
            if (PrSl_1msTrig_s = '1') then
                CpSl_Test_o <= '1';
            elsif (PrSl_2msTrig_s = '1') then 
                CpSl_Test_o <= '0';
            else --hold
            end if;
        end if;
    end process;
    
end arch_M_Test;