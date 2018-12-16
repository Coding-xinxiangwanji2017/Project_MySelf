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
-- 版    权  :  Jesus
-- 文件名称  :  M_Dvi.vhd
-- 设    计  :  zhang wenjun
-- 邮    件  :  
-- 校    对  :  
-- 设计日期  :  2018/11/30
-- 功能简述  :  Dvi_Input Data
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2018/11/30
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

Library UNISIM;
use UNISIM.vcomponents.all;


entity M_Dvi is
    Port (
        -- Clk & Reset 
        CpSl_Clk_i                      : in  std_logic;                         -- 100MHz,signal 
        CpSl_Rst_iN                     : in  std_logic;                         -- FPGA Reaet,active low
        
        -- sii1161
        HPD_Si1161                      : out std_logic;

        -- Dvi0
        HDMI_in_SCDT                    : in  std_logic;
        HDMI_in_DVI0_R                  : in  std_logic_vector(7 downto 0);
        HDMI_in_DVI0_G                  : in  std_logic_vector(7 downto 0);
        HDMI_in_DVI0_B                  : in  std_logic_vector(7 downto 0);  
        HDMI_in_DVI0_CLK                : in  std_logic;
        HDMI_in_DVI0_DE                 : in  std_logic;
        HDMI_in_DVI0_VSYNC              : in  std_logic;
        HDMI_in_DVI0_HSYNC              : in  std_logic;
        HDMI_stag0_out                  : out std_logic;
        HDMI_in_PDO_n                   : out std_logic;
        LED0                            : out std_logic;
        
        -- Dvi1
        HDMI_inB_SCDT                   : in  std_logic;
        HDMI_in_DVI1_R                  : in  std_logic_vector(7 downto 0);
        HDMI_in_DVI1_G                  : in  std_logic_vector(7 downto 0);
        HDMI_in_DVI1_B                  : in  std_logic_vector(7 downto 0);  
        HDMI_in_DVI1_CLK                : in  std_logic;
        HDMI_in_DVI1_DE                 : in  std_logic;
        HDMI_in_DVI1_VSYNC              : in  std_logic;
        HDMI_in_DVI1_HSYNC              : in  std_logic;
        HDMI_stag1_out                  : out std_logic;
        HDMI_inB_PDO_n                  : out std_logic;
        LED1                            : out std_logic
    );
end M_Dvi;

architecture arch_M_Dvi of M_Dvi is
    ------------------------------------ 
    -- constant describe                
    ------------------------------------ 
    constant PrSv_1sCnt_c               : std_logic_vector(27 downto 0) := x"5F5E0FF"; -- 99_999_999
    constant PrSv_FlageCnt_c            : std_logic_vector(27 downto 0) := x"5F5E0FD"; -- 99_999_997
    constant PrSv_50msCnt_c             : std_logic_vector(27 downto 0) := x"04C4B3F"; -- 4_999_999

    ------------------------------------
    -- ChipScope describe
    ------------------------------------
    component M_Dvi_ila port (
        CLK                             : in    std_logic;
        probe0                          : in    std_logic_vector(127 DOWNTO 0)
    );
    end component;
    
    ------------------------------------
    -- component describe
    ------------------------------------
    -- ClkPll
    component M_ClkPll port (
        -- Clock in
        CLK_IN1                         : in  std_logic;
        -- Clock out
        CLK_OUT1                        : out std_logic;
        -- Reset & PrSl_Locked_s
        RESET                           : in  std_logic;
        LOCKED                          : out std_logic
    );
    end component;

    ------------------------------------
    -- signal describe
    ------------------------------------
    -- ChipScope
    signal PrSv_ChipCtrl0_s             : std_logic_vector( 35 downto 0);
    signal PrSv_ChipTrig0_s             : std_logic_vector(127 downto 0);
        
    -- ClkPll
    signal  PrSl_Locked_s               : std_logic;
    signal  PrSl_100MClk_s              : std_logic;
    
    -- Cnt
    signal PrSv_1sCnt_s                 : std_logic_vector(27 downto 0);
    signal PrSl_RisFlage_s              : std_logic;
    signal PrSl_FallFlage_s             : std_logic;
    signal PrSl_HpdSi1161_s             : std_logic;
    
    -- Dvi0
    signal PrSl_Dvi0Clk_s               : std_logic;
    signal PrSl_Dvi0_Clk_s              : std_logic;
    signal PrSl_Dvi0RDly1_s             : std_logic_vector(7 downto 0);
    signal PrSl_Dvi0GDly1_s 	        : std_logic_vector(7 downto 0);	
    signal PrSl_Dvi0BDly1_s 	        : std_logic_vector(7 downto 0);	
    signal PrSl_Dvi0DeDly1_s 	        : std_logic;
    signal PrSl_Dvi0HsyncDly1_s         : std_logic;
    signal PrSl_Dvi0VsyncDly1_s         : std_logic;
    signal PrSl_Dvi0VsyncDly2_s         : std_logic;
    signal PrSl_Dvi0VsyncTrig_s         : std_logic;
    signal PrSv_Dvi0DeCnt_s             : std_logic_vector(10 downto 0);
    signal PrSv_Dvi0VsyncCnt_s          : std_logic_vector( 7 downto 0);
    signal PrSv_Dvi0HCnt_s              : std_logic_vector(10 downto 0);
    signal PrSv_Dvi0VCnt_s              : std_logic_vector( 7 downto 0);
                                        
    -- Dvi1
    signal PrSl_Dvi1Clk_s               : std_logic;
    signal PrSl_Dvi1_Clk_s              : std_logic;
    signal PrSl_Dvi1RDly1_s             : std_logic_vector(7 downto 0);
    signal PrSl_Dvi1GDly1_s 	        : std_logic_vector(7 downto 0);	
    signal PrSl_Dvi1BDly1_s 	        : std_logic_vector(7 downto 0);	
    signal PrSl_Dvi1DeDly1_s 	        : std_logic;
    signal PrSl_Dvi1HsyncDly1_s         : std_logic;
    signal PrSl_Dvi1VsyncDly1_s         : std_logic;
    signal PrSl_Dvi1VsyncDly2_s         : std_logic;
    signal PrSl_Dvi1VsyncTrig_s         : std_logic;
    signal PrSv_Dvi1DeCnt_s             : std_logic_vector(10 downto 0);
    signal PrSv_Dvi1VsyncCnt_s          : std_logic_vector( 7 downto 0);
    signal PrSv_Dvi1HCnt_s              : std_logic_vector(10 downto 0);
    signal PrSv_Dvi1VCnt_s              : std_logic_vector( 7 downto 0);    
        
    
begin
    ------------------------------------
    -- ChipScope describe
    ------------------------------------
    --Dvi0
    U_M_Dvi_ila_0 : M_Dvi_ila port map (
        CLK                             => PrSl_Dvi0_Clk_s,
        probe0                          => PrSv_ChipTrig0_s
    );
    
    PrSv_ChipTrig0_s(  7 downto   0)    <= PrSl_Dvi0RDly1_s;
    PrSv_ChipTrig0_s( 15 downto   8)    <= PrSl_Dvi0GDly1_s;
    PrSv_ChipTrig0_s( 23 downto  16)    <= PrSl_Dvi0BDly1_s;
    PrSv_ChipTrig0_s(            24)    <= PrSl_Dvi0DeDly1_s;
    PrSv_ChipTrig0_s(            25)    <= PrSl_Dvi0HsyncDly1_s;
    PrSv_ChipTrig0_s(            26)    <= PrSl_Dvi0VsyncDly1_s;
    PrSv_ChipTrig0_s( 37 downto  27)    <= PrSv_Dvi0DeCnt_s;
    PrSv_ChipTrig0_s( 48 downto  38)    <= PrSv_Dvi0HCnt_s;
    PrSv_ChipTrig0_s( 56 downto  49)    <= PrSv_Dvi0VCnt_s;
                                 
    PrSv_ChipTrig0_s( 64 downto  57)    <= PrSl_Dvi1RDly1_s;
    PrSv_ChipTrig0_s( 72 downto  65)    <= PrSl_Dvi1GDly1_s;
    PrSv_ChipTrig0_s( 80 downto  73)    <= PrSl_Dvi1BDly1_s;
    PrSv_ChipTrig0_s(            81)    <= PrSl_Dvi1DeDly1_s;
    PrSv_ChipTrig0_s(            82)    <= PrSl_Dvi1HsyncDly1_s;
    PrSv_ChipTrig0_s(            83)    <= PrSl_Dvi1VsyncDly1_s;
    PrSv_ChipTrig0_s( 94 downto  84)    <= PrSv_Dvi1DeCnt_s;
    PrSv_ChipTrig0_s(105 downto  95)    <= PrSv_Dvi1HCnt_s;
    PrSv_ChipTrig0_s(113 downto 106)    <= PrSv_Dvi1VCnt_s;
        
    PrSv_ChipTrig0_s(           114)    <= PrSl_RisFlage_s;
    PrSv_ChipTrig0_s(           115)    <= PrSl_FallFlage_s;
    PrSv_ChipTrig0_s(127 downto 116)    <= (others => '0');
    
    
    ------------------------------------
    -- component describe
    ------------------------------------
    U_M_ClkPll_0 : M_ClkPll port map (
        -- Clock in
        CLK_IN1                         => CpSl_Clk_i,
        RESET                           => not CpSl_Rst_iN,
        -- Clock out
        CLK_OUT1                        => PrSl_100MClk_s,
        -- PrSl_Locked_s
        LOCKED                          => PrSl_Locked_s
    );
    
    ------------------------------------
    -- ibufg describe
    ------------------------------------
    U_M_Ibufg_0 : IBUFG
    generic map (
        IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
        IOSTANDARD => "DEFAULT")
    port map (
        O => PrSl_Dvi0Clk_s,        -- Clock buffer output
        I => HDMI_in_DVI0_CLK     -- Clock buffer input (connect directly to top-level port)
    );
    
    U_M_Ibufg_1 : IBUFG
    generic map (
        IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
        IOSTANDARD => "DEFAULT")
    port map (
        O => PrSl_Dvi1Clk_s,        -- Clock buffer output
        I => HDMI_in_DVI1_CLK     -- Clock buffer input (connect directly to top-level port)
    );
    
    PrSl_Dvi0_Clk_s <= not PrSl_Dvi0Clk_s;
    PrSl_Dvi1_Clk_s <= not PrSl_Dvi1Clk_s;
    ------------------------------------
    -- 1s Cnt
    ------------------------------------
    process (PrSl_Locked_s,PrSl_100MClk_s) begin 
        if (PrSl_Locked_s = '0') then
            PrSv_1sCnt_s <= (others => '0');
        elsif rising_edge (PrSl_100MClk_s) then 
            if (PrSv_1sCnt_s = PrSv_1sCnt_c) then 
                PrSv_1sCnt_s <= (others => '0');
            else
                PrSv_1sCnt_s <= PrSv_1sCnt_s + '1';
            end if;
        end if;
    end process;
    
    -- Rising Flage
    process (PrSl_Locked_s,PrSl_100MClk_s) begin 
        if (PrSl_Locked_s = '0') then
            PrSl_RisFlage_s <= '0';
        elsif rising_edge (PrSl_100MClk_s) then 
            if (PrSv_1sCnt_s = 0) then 
                PrSl_RisFlage_s <= '0';
            elsif (PrSv_1sCnt_s = 2) then 
                PrSl_RisFlage_s <= '1';
            else --hold
            end if;
        end if;
    end process;
    
    -- Falling Flage
    process (PrSl_Locked_s,PrSl_100MClk_s) begin 
        if (PrSl_Locked_s = '0') then
            PrSl_FallFlage_s <= '0';
        elsif rising_edge (PrSl_100MClk_s) then 
            if (PrSv_1sCnt_s = PrSv_FlageCnt_c) then 
                PrSl_FallFlage_s <= '1';
            elsif (PrSv_1sCnt_s = PrSv_1sCnt_c) then 
                PrSl_FallFlage_s <= '0';
            else --hold
            end if;
        end if;
    end process;
    
    -- HDP_sii1161
    process (PrSl_Locked_s,PrSl_100MClk_s) begin
        if (PrSl_Locked_s = '0') then 
            PrSl_HpdSi1161_s <= '0';
        elsif rising_edge (PrSl_100MClk_s) then 
            if (PrSv_1sCnt_s = PrSv_50msCnt_c) then 
                PrSl_HpdSi1161_s <= '1';
            elsif (PrSv_1sCnt_s = PrSv_1sCnt_c) then 
                PrSl_HpdSi1161_s <= '0';
            else --hold
            end if;
        end if;
    end process;
    
    HPD_Si1161 <= not PrSl_HpdSi1161_s;
    
    ------------------------------------
    -- Dvi0 describe
    ------------------------------------
    process (PrSl_Locked_s,PrSl_Dvi0_Clk_s) begin 
        if (PrSl_Locked_s = '0') then 
            PrSl_Dvi0RDly1_s     <= (others => '0');
            PrSl_Dvi0GDly1_s 	 <= (others => '0');
            PrSl_Dvi0BDly1_s 	 <= (others => '0');
            PrSl_Dvi0DeDly1_s 	 <= '0';
            PrSl_Dvi0HsyncDly1_s <= '0';
            PrSl_Dvi0VsyncDly1_s <= '0';

        elsif rising_edge (PrSl_Dvi0_Clk_s) then
            PrSl_Dvi0RDly1_s     <= HDMI_in_DVI0_R;    
            PrSl_Dvi0GDly1_s 	 <= HDMI_in_DVI0_G;    
            PrSl_Dvi0BDly1_s 	 <= HDMI_in_DVI0_B;    
            PrSl_Dvi0DeDly1_s 	 <= HDMI_in_DVI0_DE; 
            PrSl_Dvi0HsyncDly1_s <= HDMI_in_DVI0_HSYNC;   
            PrSl_Dvi0VsyncDly1_s <= HDMI_in_DVI0_VSYNC;
            
        end if;                     
    end process;
    
    -- Dvi0_DeCnt
    process (PrSl_Locked_s,PrSl_Dvi0_Clk_s) begin 
        if (PrSl_Locked_s = '0') then 
            PrSv_Dvi0DeCnt_s <= (others => '0');
        elsif rising_edge (PrSl_Dvi0_Clk_s) then 
            if (HDMI_in_SCDT = '1') then 
                if (PrSl_Dvi0DeDly1_s = '0') then 
                    PrSv_Dvi0DeCnt_s <= (others => '0');
                else
                    PrSv_Dvi0DeCnt_s <= PrSv_Dvi0DeCnt_s + '1';
                end if;
            else
                PrSv_Dvi0DeCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- Dvi0_HCnt
    process (PrSl_Locked_s,PrSl_Dvi0_Clk_s) begin 
        if (PrSl_Locked_s = '0') then 
            PrSv_Dvi0HCnt_s <= (others => '0');
        elsif rising_edge (PrSl_Dvi0_Clk_s) then 
            if (HDMI_in_SCDT = '1') then 
                if (HDMI_in_DVI0_VSYNC = '1') then 
                    if (PrSl_Dvi0HsyncDly1_s = '0' and HDMI_in_DVI0_HSYNC = '1') then 
                        PrSv_Dvi0HCnt_s <= PrSv_Dvi0HCnt_s + '1';
                    else -- hold
                    end if;
                else
                    PrSv_Dvi0HCnt_s <= (others => '0');
                end if;
            else
                PrSv_Dvi0HCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- Dvi0VsyncTrig
    PrSl_Dvi0VsyncTrig_s <= '1' when (PrSl_Dvi0VsyncDly1_s <= '0' and HDMI_in_DVI0_VSYNC <= '1') else '0';
    
    -- Dvi0_Vsync_Cnt
    process (PrSl_Locked_s,PrSl_Dvi0_Clk_s) begin
        if (PrSl_Locked_s = '0') then 
            PrSv_Dvi0VsyncCnt_s <= (others => '0');
        elsif rising_edge (PrSl_Dvi0_Clk_s) then 
            if (HDMI_in_SCDT = '1') then
                if (PrSl_RisFlage_s = '1') then
                    if (PrSl_Dvi0VsyncTrig_s = '1') then 
                        PrSv_Dvi0VsyncCnt_s <= PrSv_Dvi0VsyncCnt_s + '1';
                    else -- hold
                    end if;
                else
                    PrSv_Dvi0VsyncCnt_s <= (others => '0');
                end if;
            else
                PrSv_Dvi0VsyncCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    process (PrSl_Locked_s,PrSl_Dvi0_Clk_s) begin
        if (PrSl_Locked_s = '0') then 
            PrSv_Dvi0VCnt_s <= (others => '0');
        elsif rising_edge (PrSl_Dvi0_Clk_s) then 
            if (HDMI_in_SCDT = '1') then
                if (PrSl_FallFlage_s = '1') then
                    PrSv_Dvi0VCnt_s <= PrSv_Dvi0VsyncCnt_s;
                else -- hold
                end if;
            else
                PrSv_Dvi0VCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    ------------------------------------
    -- Dvi1 describe
    ------------------------------------
    process (PrSl_Locked_s,PrSl_Dvi1_Clk_s) begin 
        if (PrSl_Locked_s = '0') then 
            PrSl_Dvi1RDly1_s     <= (others => '0');
            PrSl_Dvi1GDly1_s 	 <= (others => '0');
            PrSl_Dvi1BDly1_s 	 <= (others => '0');
            PrSl_Dvi1DeDly1_s 	 <= '0';
            PrSl_Dvi1HsyncDly1_s <= '0';
            PrSl_Dvi1VsyncDly1_s <= '0';
            
        elsif rising_edge (PrSl_Dvi1_Clk_s) then
            PrSl_Dvi1RDly1_s     <= HDMI_in_DVI1_R;    
            PrSl_Dvi1GDly1_s 	 <= HDMI_in_DVI1_G;    
            PrSl_Dvi1BDly1_s 	 <= HDMI_in_DVI1_B;    
            PrSl_Dvi1DeDly1_s 	 <= HDMI_in_DVI1_DE;
            PrSl_Dvi1HsyncDly1_s <= HDMI_in_DVI1_HSYNC;   
            PrSl_Dvi1VsyncDly1_s <= HDMI_in_DVI1_VSYNC;
            
        end if;
    end process;
    
    -- Dvi1_DeCnt
    process (PrSl_Locked_s,PrSl_Dvi1_Clk_s) begin 
        if (PrSl_Locked_s = '0') then 
            PrSv_Dvi1DeCnt_s <= (others => '0');
        elsif rising_edge (PrSl_Dvi1_Clk_s) then 
            if (HDMI_inB_SCDT = '1') then 
                if (PrSl_Dvi1DeDly1_s = '0') then 
                    PrSv_Dvi1DeCnt_s <= (others => '0');
                else
                    PrSv_Dvi1DeCnt_s <= PrSv_Dvi1DeCnt_s + '1';
                end if;
            else
                PrSv_Dvi1DeCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- Dv1_HCnt
    process (PrSl_Locked_s,PrSl_Dvi1_Clk_s) begin 
        if (PrSl_Locked_s = '0') then 
            PrSv_Dvi1HCnt_s <= (others => '0');
        elsif rising_edge (PrSl_Dvi1_Clk_s) then 
            if (HDMI_inB_SCDT = '1') then 
                if (HDMI_in_DVI1_VSYNC = '1') then 
                    if (PrSl_Dvi1HsyncDly1_s = '0' and HDMI_in_DVI1_HSYNC = '1') then 
                        PrSv_Dvi1HCnt_s <= PrSv_Dvi1HCnt_s + '1';
                    else -- hold
                    end if;
                else
                    PrSv_Dvi1HCnt_s <= (others => '0');
                end if;
            else
                PrSv_Dvi1HCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- Dvi1VsyncTrig
    PrSl_Dvi1VsyncTrig_s <= '1' when (PrSl_Dvi1VsyncDly1_s <= '0' and HDMI_in_DVI1_VSYNC <= '1') else '0';
    
    -- Dvi1_Vsync_Cnt
    process (PrSl_Locked_s,PrSl_Dvi1_Clk_s) begin
        if (PrSl_Locked_s = '0') then 
            PrSv_Dvi1VsyncCnt_s <= (others => '0');
        elsif rising_edge (PrSl_Dvi1_Clk_s) then 
            if (HDMI_inB_SCDT = '1') then
                if (PrSl_RisFlage_s = '1') then
                    if (PrSl_Dvi1VsyncTrig_s = '1') then 
                        PrSv_Dvi1VsyncCnt_s <= PrSv_Dvi1VsyncCnt_s + '1';
                    else -- hold
                    end if;
                else
                    PrSv_Dvi1VsyncCnt_s <= (others => '0');
                end if;
            else
                PrSv_Dvi1VsyncCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    process (PrSl_Locked_s,PrSl_Dvi1_Clk_s) begin
        if (PrSl_Locked_s = '0') then 
            PrSv_Dvi1VCnt_s <= (others => '0');
        elsif rising_edge (PrSl_Dvi1_Clk_s) then 
            if (HDMI_inB_SCDT = '1') then
                if (PrSl_FallFlage_s = '1') then
                    PrSv_Dvi1VCnt_s <= PrSv_Dvi1VsyncCnt_s;
                else -- hold
                end if;
            else
                PrSv_Dvi1VCnt_s <= (others => '0');
            end if;
        end if;
    end process;
	 
--************************************************************	 

    --HDMI_in_PIX<='0';
    LED0            <= not HDMI_in_SCDT;
    LED1            <= not HDMI_inB_SCDT;
    HDMI_in_PDO_n   <='1';
    HDMI_inB_PDO_n  <='1';
    HDMI_stag0_out  <='1';
    HDMI_stag1_out  <='1';

end arch_M_Dvi;