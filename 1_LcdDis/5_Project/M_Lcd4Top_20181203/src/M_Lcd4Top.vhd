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
-- 文件名称  :  M_Lcd4Top.vhd
-- 设    计  :  zhang wenjun
-- 邮    件  :  
-- 校    对  :
-- 设计日期  :  2018/11/30
-- 功能简述  :  LCD4 top entity
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2018/11/30
-- 功能描述  ： 1920*1080 Image
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

entity M_Lcd4Top is 
    generic (
        Simulation                      : integer := 1;                         -- Simulation = 0 for simulatin        
        Refresh_Rate                    : integer := 150;                       -- Choice the the Refrate
        Use_ChipScope                   : integer := 1
    );
    port (
        --------------------------------
        -- Reset & Clock
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- Reset, active low
        CpSl_Clk_i                      : in  std_logic;                        -- Clock 100MHz, single
        CpSl_Clk_iP                     : in  std_logic;                        -- Clock 200MHz, diff
        CpSl_Clk_iN                     : in  std_logic;                        -- Clock 200MHz, diff
        -- LED
        CpSv_Led_o                      : out std_logic_vector( 3 downto 0);    -- LED out
        -- SMA
        CpSv_Sma_o                      : out std_logic_vector( 3 downto 0);    -- SMA out
        -- GPIO 
        CpSv_Gpio_o                     : out std_logic_vector( 4 downto 0);    -- GPIO out
        
        --------------------------------
        -- DVI
        --------------------------------
        CpSl_Dvi0Clk_i                  : in  std_logic;                        -- DVI clk
        CpSl_Dvi0Vsync_i                : in  std_logic;                        -- DVI vsync
        CpSl_Dvi0Hsync_i                : in  std_logic;                        -- DVI hsync
        CpSl_Dvi0Scdt_i                 : in  std_logic;                        -- DVI SCDT
        CpSl_Dvi0De_i                   : in  std_logic;                        -- DVI de
        CpSv_Dvi0R_i                    : in  std_logic_vector( 7 downto 0);    -- DVI Red
        CpSv_Dvi0G_i                    : in  std_logic_vector( 7 downto 0);    -- DVI Green

        CpSl_Dvi1Scdt_i                 : in  std_logic;                        -- DVI SCDT
        CpSv_Dvi1R_i                    : in  std_logic_vector( 7 downto 0);    -- DVI Red
        CpSv_Dvi1G_i                    : in  std_logic_vector( 7 downto 0);    -- DVI Green

        --------------------------------
        -- FMC IF
        --------------------------------
        FMC0_LA02_P                     : out std_logic;                        -- Port 0 FMC_LA02_P
        FMC0_LA03_P                     : out std_logic;                        -- Port 0 FMC_LA03_P
        FMC0_LA04_P                     : out std_logic;                        -- Port 0 FMC_LA04_P
        FMC0_LA05_P                     : out std_logic;                        -- Port 0 FMC_LA05_P
        FMC0_LA06_P                     : out std_logic;                        -- Port 0 FMC_LA06_P
        FMC0_LA07_P                     : out std_logic;                        -- Port 0 FMC_LA07_P
        FMC0_LA08_P                     : out std_logic;                        -- Port 0 FMC_LA08_P
        FMC0_LA09_P                     : out std_logic;                        -- Port 0 FMC_LA09_P
        FMC0_LA10_P                     : out std_logic;                        -- Port 0 FMC_LA10_P
        FMC0_LA11_P                     : out std_logic;                        -- Port 0 FMC_LA11_P
        FMC0_LA12_P                     : out std_logic;                        -- Port 0 FMC_LA12_P
        FMC0_LA13_P                     : out std_logic;                        -- Port 0 FMC_LA13_P
        FMC0_LA14_P                     : out std_logic;                        -- Port 0 FMC_LA14_P
        FMC0_LA15_P                     : out std_logic;                        -- Port 0 FMC_LA15_P
        FMC0_LA16_P                     : out std_logic;                        -- Port 0 FMC_LA16_P
        FMC0_LA19_P                     : out std_logic;                        -- Port 0 FMC_LA19_P
        FMC0_LA20_P                     : out std_logic;                        -- Port 0 FMC_LA20_P
        FMC0_LA21_P                     : out std_logic;                        -- Port 0 FMC_LA21_P
        FMC0_LA22_P                     : out std_logic;                        -- Port 0 FMC_LA22_P
        FMC0_LA23_P                     : out std_logic;                        -- Port 0 FMC_LA23_P
        FMC0_LA24_P                     : out std_logic;                        -- Port 0 FMC_LA24_P
        FMC0_LA25_P                     : out std_logic;                        -- Port 0 FMC_LA25_P
        FMC0_LA26_P                     : out std_logic;                        -- Port 0 FMC_LA26_P
        FMC0_LA27_P                     : out std_logic;                        -- Port 0 FMC_LA27_P
        FMC0_LA28_P                     : out std_logic;                        -- Port 0 FMC_LA28_P
        FMC0_LA29_P                     : out std_logic;                        -- Port 0 FMC_LA29_P
        FMC0_LA30_P                     : out std_logic;                        -- Port 0 FMC_LA30_P
        FMC0_LA31_P                     : out std_logic;                        -- Port 0 FMC_LA31_P
        FMC0_LA32_N                     : out std_logic;                        -- Port 0 FMC_LA32_N
        FMC0_LA_N                       : out std_logic_vector(27 downto 0);    -- Port 0 FMC_N

        FMC1_LA02_P                     : out std_logic;                        -- Port 1 FMC_LA02_P
        FMC1_LA03_P                     : out std_logic;                        -- Port 1 FMC_LA03_P
        FMC1_LA04_P                     : out std_logic;                        -- Port 1 FMC_LA04_P
        FMC1_LA05_P                     : out std_logic;                        -- Port 1 FMC_LA05_P
        FMC1_LA06_P                     : out std_logic;                        -- Port 1 FMC_LA06_P
        FMC1_LA07_P                     : out std_logic;                        -- Port 1 FMC_LA07_P
        FMC1_LA08_P                     : out std_logic;                        -- Port 1 FMC_LA08_P
        FMC1_LA09_P                     : out std_logic;                        -- Port 1 FMC_LA09_P
        FMC1_LA10_P                     : out std_logic;                        -- Port 1 FMC_LA10_P
        FMC1_LA11_P                     : out std_logic;                        -- Port 1 FMC_LA11_P
        FMC1_LA12_P                     : out std_logic;                        -- Port 1 FMC_LA12_P
        FMC1_LA13_P                     : out std_logic;                        -- Port 1 FMC_LA13_P
        FMC1_LA14_P                     : out std_logic;                        -- Port 1 FMC_LA14_P
        FMC1_LA15_P                     : out std_logic;                        -- Port 1 FMC_LA15_P
        FMC1_LA16_P                     : out std_logic;                        -- Port 1 FMC_LA16_P
        FMC1_LA19_P                     : out std_logic;                        -- Port 1 FMC_LA19_P
        FMC1_LA20_P                     : out std_logic;                        -- Port 1 FMC_LA20_P
        FMC1_LA21_P                     : out std_logic;                        -- Port 1 FMC_LA21_P
        FMC1_LA22_P                     : out std_logic;                        -- Port 1 FMC_LA22_P
        FMC1_LA23_P                     : out std_logic;                        -- Port 1 FMC_LA23_P
        FMC1_LA24_P                     : out std_logic;                        -- Port 1 FMC_LA24_P
        FMC1_LA25_P                     : out std_logic;                        -- Port 1 FMC_LA25_P
        FMC1_LA26_P                     : out std_logic;                        -- Port 1 FMC_LA26_P
        FMC1_LA27_P                     : out std_logic;                        -- Port 1 FMC_LA27_P
        FMC1_LA28_P                     : out std_logic;                        -- Port 1 FMC_LA28_P
        FMC1_LA29_P                     : out std_logic;                        -- Port 1 FMC_LA29_P
        FMC1_LA30_P                     : out std_logic;                        -- Port 1 FMC_LA30_P
        FMC1_LA31_P                     : out std_logic;                        -- Port 1 FMC_LA31_P
        FMC1_LA32_N                     : out std_logic;                        -- Port 1 FMC_LA32_N
        FMC1_LA_N                       : out std_logic_vector(27 downto 0);    -- Port 1 FMC_N

        --------------------------------
        -- DDR IF
        --------------------------------
        ddr3_dq                         : inout std_logic_vector(31 downto 0);
        ddr3_dqs_p                      : inout std_logic_vector( 3 downto 0);
        ddr3_dqs_n                      : inout std_logic_vector( 3 downto 0);
        ddr3_addr                       : out   std_logic_vector(14 downto 0);
        ddr3_ba                         : out   std_logic_vector( 2 downto 0);
        ddr3_ras_n                      : out   std_logic;
        ddr3_cas_n                      : out   std_logic;
        ddr3_we_n                       : out   std_logic;
        ddr3_reset_n                    : out   std_logic;
        ddr3_ck_p                       : out   std_logic_vector( 0 downto 0);
        ddr3_ck_n                       : out   std_logic_vector( 0 downto 0);
        ddr3_cke                        : out   std_logic_vector( 0 downto 0);
        ddr3_cs_n                       : out   std_logic_vector( 0 downto 0);
        ddr3_dm                         : out   std_logic_vector( 3 downto 0);
        ddr3_odt                        : out   std_logic_vector( 0 downto 0)
    );
end M_Lcd4Top;

architecture arch_M_Lcd4Top of M_Lcd4Top is
    ----------------------------------------------------------------------------
    -- constant declaration
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- component declaration
    ----------------------------------------------------------------------------
    component M_Icon port (
        control0                        : inout std_logic_vector(35 downto 0);
        control1                        : inout std_logic_vector(35 downto 0);
        control2                        : inout std_logic_vector(35 downto 0);
        control3                        : inout std_logic_vector(35 downto 0)  
    );
    end component;
    -- PLL 
    component M_ClkPll port (
        reset                           : in  std_logic;
        clk_in1                         : in  std_logic;
        clk_out1                        : out std_logic;
        clk_out2                        : out std_logic;
        locked                          : out std_logic
    );
    end component;

    component M_FreClkPll port (
        reset                           : in  std_logic;
        clk_in1                         : in  std_logic;
        clk_out1                        : out std_logic;
        locked                          : out std_logic
    );
    end component;

    component M_DviIf port (
        --------------------------------
        -- DVI Input
        --------------------------------
        CpSl_Dvi0Clk_i                  : in  std_logic;                        -- DVI0 clk
        CpSl_Dvi0Vsync_i                : in  std_logic;                        -- DVI0 V sync
        CpSl_Dvi0Hsync_i                : in  std_logic;                        -- DVI0 H sync
        CpSl_Dvi0De_i                   : in  std_logic;                        -- DVI0 De
        CpSl_Dvi0Scdt_i                 : in  std_logic;                        -- DVI0 SCDT
        CpSv_Dvi0R_i                    : in  std_logic_vector(  7 downto 0);   -- DVI0 red
        CpSv_Dvi0G_i                    : in  std_logic_vector(  7 downto 0);   -- DVI0 Green
        CpSl_Dvi1Scdt_i                 : in  std_logic;                        -- DVI1 SCDT
        CpSv_Dvi1R_i                    : in  std_logic_vector(  7 downto 0);   -- DVI1 red
        CpSv_Dvi1G_i                    : in  std_logic_vector(  7 downto 0);   -- DVI1 Green

        --------------------------------
        -- DVI Output
        --------------------------------
        CpSl_Dvi0Clk_o                  : out std_logic;                        -- DVI0 clk
        CpSl_Dvi0Vsync_o                : out std_logic;                        -- DVI0 V sync
        CpSl_Dvi0Hsync_o                : out std_logic;                        -- DVI0 H sync
        CpSl_Dvi0De_o                   : out std_logic;                        -- DVI0 De
        CpSl_Dvi0Scdt_o                 : out std_logic;                        -- DVI0 SCDT
        CpSv_Dvi0R_o                    : out std_logic_vector(  7 downto 0);   -- DVI0 Red
        CpSv_Dvi0G_o                    : out std_logic_vector(  7 downto 0);   -- DVI0 Green
        CpSl_Dvi1Scdt_o                 : out std_logic;                        -- DVI1 SCDT
        CpSv_Dvi1R_o                    : out std_logic_vector(  7 downto 0);   -- DVI1 Red
        CpSv_Dvi1G_o                    : out std_logic_vector(  7 downto 0)    -- DVI1 Green
    );
    end component;

    component M_DdrIf 
        generic (
            Simulation                  : integer := 1;
            Use_ChipScope               : integer := 1
        );
        port (
        --------------------------------
        -- SMA V Sync
        --------------------------------
        CpSl_DVISync_SMA_o              : out  std_logic;                       -- Sync out of DVI V Sync
        CpSl_LCDSync_SMA_o              : out  std_logic;                       -- Sync out of LCD V Sync

        --------------------------------
        -- DVI
        --------------------------------
        CpSl_Dvi0Clk_i                  : in  std_logic;                        -- DVI0 clk
        CpSl_Dvi0Vsync_i                : in  std_logic;                        -- DVI0 V sync
        CpSl_Dvi0Hsync_i                : in  std_logic;                        -- DVI0 H sync
        CpSl_Dvi0De_i                   : in  std_logic;                        -- DVI0 De
        CpSl_Dvi0Scdt_i                 : in  std_logic;                        -- DVI0 SCDT
        CpSv_Dvi0R_i                    : in  std_logic_vector(  7 downto 0);   -- DVI0 red
        CpSv_Dvi0G_i                    : in  std_logic_vector(  7 downto 0);   -- DVI0 Green
        CpSl_Dvi1Scdt_i                 : in  std_logic;                        -- DVI1 SCDT
        CpSv_Dvi1R_i                    : in  std_logic_vector(  7 downto 0);   -- DVI1 Red
        CpSv_Dvi1G_i                    : in  std_logic_vector(  7 downto 0);   -- DVI1 Green

        --------------------------------
        -- LCD
        --------------------------------
        CpSl_LcdClk_i                   : in  std_logic;                        -- LCD clk
        CpSl_LCD_Double_i               : in  std_logic;                        -- Double reference
        CpSv_Refresh_Rate_Sel_i         : in  std_logic_vector( 2  downto 0);   -- refresh Selection
        CpSl_LcdVsync_o                 : out std_logic;                        -- LCD V sync
        CpSl_LcdHsync_o                 : out std_logic;                        -- LCD H sync
        CpSv_LcdR0_o                    : out std_logic_vector( 11 downto 0);   -- LCD Red0
        CpSv_LcdR1_o                    : out std_logic_vector( 11 downto 0);   -- LCD Red1
        CpSv_LcdR2_o                    : out std_logic_vector( 11 downto 0);   -- LCD Red2
        CpSv_LcdR3_o                    : out std_logic_vector( 11 downto 0);   -- LCD Red3
        CpSv_LcdG0_o                    : out std_logic_vector( 11 downto 0);   -- LCD Green0
        CpSv_LcdG1_o                    : out std_logic_vector( 11 downto 0);   -- LCD Green1
        CpSv_LcdG2_o                    : out std_logic_vector( 11 downto 0);   -- LCD Green2
        CpSv_LcdG3_o                    : out std_logic_vector( 11 downto 0);   -- LCD Green3

        --------------------------------
        -- DDR
        --------------------------------
        CpSl_DdrRdy_i                   : in  std_logic;                        -- DDR ready
        CpSl_DdrClk_i                   : in  std_logic;                        -- DDR clock
        CpSl_AppRdy_i                   : in  std_logic;                        -- DDR APP IF
        CpSl_AppEn_o                    : out std_logic;                        -- DDR APP IF
        CpSv_AppCmd_o                   : out std_logic_vector(  2 downto 0);   -- DDR APP IF
        CpSv_AppAddr_o                  : out std_logic_vector( 28 downto 0);   -- DDR APP IF
        CpSl_AppWdfRdy_i                : in  std_logic;                        -- DDR APP IF
        CpSl_AppWdfWren_o               : out std_logic;                        -- DDR APP IF
        CpSl_AppWdfEnd_o                : out std_logic;                        -- DDR APP IF
        CpSv_AppWdfData_o               : out std_logic_vector(255 downto 0);   -- DDR APP IF
        CpSl_AppRdDataVld_i             : in  std_logic;                        -- DDR APP IF
        CpSv_AppRdData_i                : in  std_logic_vector(255 downto 0);   -- DDR APP IF
        
        --------------------------------
        -- ChipScope
        --------------------------------
        CpSv_ChipCtrl0_io               : inout std_logic_vector(35 downto 0);  -- ChipScope_Ctrl0
        CpSv_ChipCtrl1_io               : inout std_logic_vector(35 downto 0);  -- ChipScope_Ctrl1 
        CpSv_ChipCtrl2_io               : inout std_logic_vector(35 downto 0)   -- ChipScope_Ctrl2
    );
    end component;
        
    component M_DdrCtrl port (
        sys_rst                         : in    std_logic;
        sys_clk_p                       : in    std_logic;
        sys_clk_n                       : in    std_logic;
        ui_clk_sync_rst                 : out   std_logic;
        ui_clk                          : out   std_logic;
        init_calib_complete             : out   std_logic;

        app_addr                        : in    std_logic_vector( 28 downto 0);
        app_cmd                         : in    std_logic_vector(  2 downto 0);
        app_en                          : in    std_logic;
        app_wdf_data                    : in    std_logic_vector(255 downto 0);
        app_wdf_end                     : in    std_logic;
        app_wdf_mask                    : in    std_logic_vector( 31 downto 0);
        app_wdf_wren                    : in    std_logic;
        app_rd_data                     : out   std_logic_vector(255 downto 0);
        app_rd_data_end                 : out   std_logic;
        app_rd_data_valid               : out   std_logic;
        app_rdy                         : out   std_logic;
        app_wdf_rdy                     : out   std_logic;
        app_sr_req                      : in    std_logic;
        app_sr_active                   : out   std_logic;
        app_ref_req                     : in    std_logic;
        app_ref_ack                     : out   std_logic;
        app_zq_req                      : in    std_logic;
        app_zq_ack                      : out   std_logic;

        ddr3_dq                         : inout std_logic_vector(31 downto 0);
        ddr3_dqs_p                      : inout std_logic_vector( 3 downto 0);
        ddr3_dqs_n                      : inout std_logic_vector( 3 downto 0);
        ddr3_addr                       : out   std_logic_vector(14 downto 0);
        ddr3_ba                         : out   std_logic_vector( 2 downto 0);
        ddr3_ras_n                      : out   std_logic;
        ddr3_cas_n                      : out   std_logic;
        ddr3_we_n                       : out   std_logic;
        ddr3_reset_n                    : out   std_logic;
        ddr3_ck_p                       : out   std_logic_vector( 0 downto 0);
        ddr3_ck_n                       : out   std_logic_vector( 0 downto 0);
        ddr3_cke                        : out   std_logic_vector( 0 downto 0);
        ddr3_cs_n                       : out   std_logic_vector( 0 downto 0);
        ddr3_dm                         : out   std_logic_vector( 3 downto 0);
        ddr3_odt                        : out   std_logic_vector( 0 downto 0)
    );
    end component;

    component M_FreCtrl
        generic (
            Simulation                  : integer := 1;
            Refresh_Rate                : integer := 200
        );
        port (
        --------------------------------
        --Reset and Clock
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                       --Rst, active low
        CpSl_Clk_i                      : in  std_logic;                       --Clk, 90Mhz signal 

        --------------------------------
        --Dvi
        --------------------------------
        CpSl_Dvi0Scdt_i                 : in  std_logic;                        --Dvi0 Scdt
        CpSl_Dvi1Scdt_i                 : in  std_logic;                        --Dvi1 Scdt
        CpSl_Dvi0Vsync_i                : in  std_logic;                        --Dvi0 Vsync

        --------------------------------
        -- Select Clk signal 
        --------------------------------
        CpSl_ClkSel_o                   : out std_logic;                        -- Select Clk 
        CpSl_DviEn_o                    : out std_logic;                        -- Dvi input enable
        --------------------------------
        --Frequence Choice
        --------------------------------
        CpSl_LCD_Double_o               : out  std_logic;
        CpSv_FreChoice_o                : out  std_logic_vector( 2 downto 0);   -- Choice frequence
        CpSv_FreLed_o                   : out  std_logic_vector( 3 downto 0);   -- led
            
        --------------------------------
        --ChipScope 
        --------------------------------
        CpSv_ChipCtrl3_io               : inout std_logic_vector(35 downto 0)   -- ChipScope Ctrl
    );
    end component;

    component M_Pattern port (
        --------------------------------
        -- Reset and clock
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- Reset, active low
        CpSl_Clk_i                      : in  std_logic;                        -- Clock,90MHz

        --------------------------------
        -- Output signals
        --------------------------------
        CpSl_Hsync_o                    : out std_logic;
        CpSl_Vsync_o                    : out std_logic;
        CpSv_Red0_o                     : out std_logic_vector(11 downto 0);
        CpSv_Red1_o                     : out std_logic_vector(11 downto 0);
        CpSv_Red2_o                     : out std_logic_vector(11 downto 0);
        CpSv_Red3_o                     : out std_logic_vector(11 downto 0)
    );
    end component;

    component remapper port (
        clock                           : in  std_logic;
        hsync                           : in  std_logic;
        vsync                           : in  std_logic;
        r1                              : in  std_logic_vector( 11 downto 0);
        r2                              : in  std_logic_vector( 11 downto 0);
        r3                              : in  std_logic_vector( 11 downto 0);
        r4                              : in  std_logic_vector( 11 downto 0);
        g1                              : in  std_logic_vector( 11 downto 0);
        g2                              : in  std_logic_vector( 11 downto 0);
        g3                              : in  std_logic_vector( 11 downto 0);
        g4                              : in  std_logic_vector( 11 downto 0);
        b1                              : in  std_logic_vector( 11 downto 0);
        b2                              : in  std_logic_vector( 11 downto 0);
        b3                              : in  std_logic_vector( 11 downto 0);
        b4                              : in  std_logic_vector( 11 downto 0);
        pardata                         : out std_logic_vector( 55 downto 0);
        pardata_h                       : out std_logic_vector(104 downto 0);
        pardata_l                       : out std_logic_vector( 90 downto 0)
    );
    end component;

    component M_HSelectIO port (
        io_reset                        : in  std_logic;
        clk_in                          : in  std_logic;
        clk_div_in                      : in  std_logic;
        data_out_from_device            : in  std_logic_vector(104 downto 0);
        data_out_to_pins_p              : out std_logic_vector( 14 downto 0);
        data_out_to_pins_n              : out std_logic_vector( 14 downto 0)
    );
    end component;

    component M_LSelectIO port (
        io_reset                        : in  std_logic;
        clk_in                          : in  std_logic;
        clk_div_in                      : in  std_logic;
        data_out_from_device            : in  std_logic_vector(90 downto 0);
        data_out_to_pins_p              : out std_logic_vector(12 downto 0);
        data_out_to_pins_n              : out std_logic_vector(12 downto 0)
    );
    end component;

    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    -- Chipscope
    signal PrSv_ChipCtrl0_s             : std_logic_vector( 35 downto 0);       -- Chipscope control0
    signal PrSv_ChipCtrl1_s             : std_logic_vector( 35 downto 0);       -- Chipscope control1
    signal PrSv_ChipCtrl2_s             : std_logic_vector( 35 downto 0);       -- Chipscope control2  
    signal PrSv_ChipCtrl3_s             : std_logic_vector( 35 downto 0);       -- Chipscope control3   
  
    --Pll Clk
    signal PrSl_PllLock_s               : std_logic;                            -- PLL lock
    signal PrSl_Bufg_s                  : std_logic;                            -- IBUFG
    signal PrSl_FrePllLocked_s          : std_logic;                            -- FreCtrl PLL locked
    signal PrSl_PllLocked_s             : std_logic;                            -- Pll Locked
    
    --DVI IDDR
    signal PrSl_If_ExtVsync_s           : std_logic;                            -- ExtVsync                                                                           
    signal PrSl_If_Dvi0Clk_s            : std_logic;                            -- Dvi0Clk  
    signal PrSl_If_Dvi0Vsync_s          : std_logic;                            -- Dvi0Vsync
    signal PrSl_If_Dvi0Hsync_s          : std_logic;                            -- Dvi0Hsync
    signal PrSl_If_Dvi0De_s             : std_logic;                            -- Dvi0De  
    signal PrSl_If_Dvi0Scdt_s           : std_logic;                            -- Dvi0Scdt 
    signal PrSv_If_Dvi0R_s              : std_logic_vector(  7 downto 0);       -- Dvi0R_s  
    signal PrSv_If_Dvi0G_s              : std_logic_vector(  7 downto 0);       -- Dvi0G_s 
    signal PrSl_If_Dvi1Scdt_s           : std_logic;                            -- Dvi1Scdt 
    signal PrSv_If_Dvi1R_s              : std_logic_vector(  7 downto 0);       -- Dvi1R    
    signal PrSv_If_Dvi1G_s              : std_logic_vector(  7 downto 0);       -- Dvi1G_s  
                                                                                 
    -- SMA outputfor test                                                        
    signal PrSl_DVISyncTest_s           : std_logic;                            -- DVISync_SMA
    signal PrSl_LCDSyncTest_s           : std_logic;                            -- LCDSync_SMA
    
    -- FMC 
    signal PrSl_ClkFmc_s                : std_logic;                            -- FMC clk
    signal PrSl_ClkLcd_s                : std_logic;                            -- LCD clk
    signal PrSl_ClkFre_s                : std_logic;                            -- refresh clk
    signal PrSl_Dvi0DeDly1_s            : std_logic;                            -- Delay De 1 clk
    signal PrSl_Dvi0DeDly2_s            : std_logic;                            -- Delay De 2 clk
    signal PrSl_Dvi0DeDly3_s            : std_logic;                            -- Delay De 3 clk
    signal PrSl_SyncPolar_s             : std_logic;                            -- Sync polarity indicator
    signal PrSl_Dvi0Vsync_s             : std_logic;                            -- Inner Vsync
    signal PrSl_Dvi0Hsync_s             : std_logic;                            -- Inner Hsync
    signal PrSl_RealHsync_s             : std_logic;                            -- Real h sync
    signal PrSl_RealVsync_s             : std_logic;                            -- Real v sync
    signal PrSv_RealR0_s                : std_logic_vector( 11 downto 0);       -- Real red ch0
    signal PrSv_RealR1_s                : std_logic_vector( 11 downto 0);       -- Real red ch1
    signal PrSv_RealR2_s                : std_logic_vector( 11 downto 0);       -- Real red ch2
    signal PrSv_RealR3_s                : std_logic_vector( 11 downto 0);       -- Real red ch3
    signal PrSv_RealG0_s                : std_logic_vector( 11 downto 0);       -- Real Green ch0
    signal PrSv_RealG1_s                : std_logic_vector( 11 downto 0);       -- Real Green ch1
    signal PrSv_RealG2_s                : std_logic_vector( 11 downto 0);       -- Real Green ch2
    signal PrSv_RealG3_s                : std_logic_vector( 11 downto 0);       -- Real Green ch3

    signal PrSv_FreChoice_s             : std_logic_vector( 2 downto 0);        -- Refresh Rate Sel
    signal PrSv_FreLed_s                : std_logic_vector( 3 downto 0);        -- light led
    signal PrSl_DdrRst_s                : std_logic;                            --
    signal PrSl_DdrClk_s                : std_logic;                            --
    signal PrSl_DdrRdy_s                : std_logic;                            --
    signal PrSv_AppAddr_s               : std_logic_vector( 28 downto 0);       --
    signal PrSv_AppCmd_s                : std_logic_vector(  2 downto 0);       --
    signal PrSl_AppEn_s                 : std_logic;                            --
    signal PrSv_AppWdfData_s            : std_logic_vector(255 downto 0);       --
    signal PrSl_AppWdfEnd_s             : std_logic;                            --
    signal PrSl_AppWdfWren_s            : std_logic;                            --
    signal PrSv_AppRdData_s             : std_logic_vector(255 downto 0);       --
    signal PrSl_AppRdDataVld_s          : std_logic;                            --
    signal PrSl_AppRdy_s                : std_logic;                            --
    signal PrSl_AppWdfRdy_s             : std_logic;                            --
    --
    signal PrSl_SimSwitch_s             : std_logic;                            -- Sim data switch
    signal PrSl_SimHsync_s              : std_logic;                            -- Sim h sync
    signal PrSl_SimVsync_s              : std_logic;                            -- Sim v sync
    signal PrSv_SimR0_s                 : std_logic_vector( 11 downto 0);       -- Sim red ch0
    signal PrSv_SimR1_s                 : std_logic_vector( 11 downto 0);       -- Sim red ch1
    signal PrSv_SimR2_s                 : std_logic_vector( 11 downto 0);       -- Sim red ch2
    signal PrSv_SimR3_s                 : std_logic_vector( 11 downto 0);       -- Sim red ch3
    signal PrSl_Port0Hsync_s            : std_logic;                            -- H sync
    signal PrSl_Port0Vsync_s            : std_logic;                            -- V sync
    signal PrSv_Port0R0_s               : std_logic_vector( 11 downto 0);       -- Red ch0
    signal PrSv_Port0R1_s               : std_logic_vector( 11 downto 0);       -- Red ch1
    signal PrSv_Port0R2_s               : std_logic_vector( 11 downto 0);       -- Red ch2
    signal PrSv_Port0R3_s               : std_logic_vector( 11 downto 0);       -- Red ch3
    signal PrSv_Port0G0_s               : std_logic_vector( 11 downto 0);       -- Green ch0
    signal PrSv_Port0G1_s               : std_logic_vector( 11 downto 0);       -- Green ch1
    signal PrSv_Port0G2_s               : std_logic_vector( 11 downto 0);       -- Green ch2
    signal PrSv_Port0G3_s               : std_logic_vector( 11 downto 0);       -- Green ch3
    signal PrSv_Port0B0_s               : std_logic_vector( 11 downto 0);       -- Blue ch0
    signal PrSv_Port0B1_s               : std_logic_vector( 11 downto 0);       -- Blue ch1
    signal PrSv_Port0B2_s               : std_logic_vector( 11 downto 0);       -- Blue ch2
    signal PrSv_Port0B3_s               : std_logic_vector( 11 downto 0);       -- Blue ch3
    signal PrSl_Port1Hsync_s            : std_logic;                            -- H sync
    signal PrSl_Port1Vsync_s            : std_logic;                            -- V sync
    signal PrSv_Port1R0_s               : std_logic_vector( 11 downto 0);       -- Red ch0
    signal PrSv_Port1R1_s               : std_logic_vector( 11 downto 0);       -- Red ch1
    signal PrSv_Port1R2_s               : std_logic_vector( 11 downto 0);       -- Red ch2
    signal PrSv_Port1R3_s               : std_logic_vector( 11 downto 0);       -- Red ch3
    signal PrSv_Port1G0_s               : std_logic_vector( 11 downto 0);       -- Green ch0
    signal PrSv_Port1G1_s               : std_logic_vector( 11 downto 0);       -- Green ch1
    signal PrSv_Port1G2_s               : std_logic_vector( 11 downto 0);       -- Green ch2
    signal PrSv_Port1G3_s               : std_logic_vector( 11 downto 0);       -- Green ch3
    signal PrSv_Port1B0_s               : std_logic_vector( 11 downto 0);       -- Blue ch0
    signal PrSv_Port1B1_s               : std_logic_vector( 11 downto 0);       -- Blue ch1
    signal PrSv_Port1B2_s               : std_logic_vector( 11 downto 0);       -- Blue ch2
    signal PrSv_Port1B3_s               : std_logic_vector( 11 downto 0);       -- Blue ch3
    signal PrSv_Matrix0H_s              : std_logic_vector(104 downto 0);       -- Matrix high
    signal PrSv_Matrix0HS_sP            : std_logic_vector( 14 downto 0);       -- Matrix high serial
    signal PrSv_Matrix0HS_sN            : std_logic_vector( 14 downto 0);       -- Matrix high serial
    signal PrSv_Matrix1H_s              : std_logic_vector(104 downto 0);       -- Matrix high
    signal PrSv_Matrix1HS_sP            : std_logic_vector( 14 downto 0);       -- Matrix high serial
    signal PrSv_Matrix1HS_sN            : std_logic_vector( 14 downto 0);       -- Matrix high serial
    signal PrSv_Matrix0L_s              : std_logic_vector( 90 downto 0);       -- Matrix low
    signal PrSv_Matrix0LS_sP            : std_logic_vector( 12 downto 0);       -- Matrix low serial P
    signal PrSv_Matrix0LS_sN            : std_logic_vector( 12 downto 0);       -- Matrix low serial N
    signal PrSv_Matrix1L_s              : std_logic_vector( 90 downto 0);       -- Matrix low
    signal PrSv_Matrix1LS_sP            : std_logic_vector( 12 downto 0);       -- Matrix low serial P
    signal PrSv_Matrix1LS_sN            : std_logic_vector( 12 downto 0);       -- Matrix low serial N

    signal PrSl_SelectIO_s              : std_logic;                            -- SelectIO Rst 
    signal PrSl_Lcd_Double_s            : std_logic;                            -- Double referce
    signal PrSl_LcdVsync_s              : std_logic;                            -- Lcd Vsync
    
    -- reset
    signal PrSl_RstPll_s                : std_logic;                            -- teset Pll
    
	 
begin
    ----------------------------------------------------------------------------
    -- Chipscope
    ----------------------------------------------------------------------------
    ChipScope : if (Use_ChipScope = 1) generate
    U_M_Icon_0 : M_Icon port map (
        control0                        => PrSv_ChipCtrl0_s                     ,
        control1                        => PrSv_ChipCtrl1_s                     ,
        control2                        => PrSv_ChipCtrl2_s                     ,
        control3                        => PrSv_ChipCtrl3_s                     
    ); 
    end generate ChipScope;
    
    
    -- PrSl_If_Dvi1Scdt_s
    PrSl_If_Dvi1Scdt_s <= '1';
    
    ----------------------------------------------------------------------------
    -- BUFG
    ----------------------------------------------------------------------------
    IBUFG_inst : IBUFG
    generic map (
        IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
        IOSTANDARD => "DEFAULT"
    )
    port map (
        O => PrSl_Bufg_s, -- Clock buffer output
        I => CpSl_Clk_i -- Clock buffer input (connect directly to top-level port)
    );
    
    ----------------------------------------------------------------------------
    -- Clock
    -- CLk_In1  ：100MHz 
    -- clk_out1 : 630MHz
    -- clk_out2 : 90MHz
    ----------------------------------------------------------------------------
    PrSl_RstPll_s <= not CpSl_Rst_iN;
    U_M_ClkPll_0 : M_ClkPll port map (
        reset                           => PrSl_RstPll_s                        , -- in  std_logic;
        clk_in1                         => PrSl_Bufg_s                          , -- in  std_logic;
        clk_out1                        => PrSl_ClkFmc_s                        , -- out std_logic;
        clk_out2                        => PrSl_ClkLcd_s                        , -- out std_logic;
        locked                          => PrSl_PllLock_s                         -- out std_logic
    );
    ----------------------------------------------------------------------------
    -- Clock
    -- CLk_In1  ：100MHz 
    -- clk_out1 : 100MHz
    ----------------------------------------------------------------------------
    U_M_FreClkPll_0 : M_FreClkPll port map (
        reset                           => PrSl_RstPll_s                        , -- in  std_logic;
        clk_in1                         => PrSl_Bufg_s                          , -- in  std_logic;
        clk_out1                        => PrSl_ClkFre_s                        , -- out std_logic;
        locked                          => PrSl_FrePllLocked_s                    -- out std_logic;
    );
    PrSl_PllLocked_s <= '1' when (PrSl_PllLock_s = '1' and PrSl_FrePllLocked_s = '1')
                            else '0';
    ----------------------------------------------------------------------------
    --control the refresh rate
    ----------------------------------------------------------------------------
    U_M_FreCtrl_0 : M_FreCtrl 
    generic map (
        Simulation                      => Simulation                           , -- simulation = 0
        Refresh_Rate                    => Refresh_Rate
    )
    port map (
        --------------------------------
        --reset and clock
        --------------------------------
        CpSl_Rst_iN                     => PrSl_PllLocked_s                       , -- in std_logic;
        CpSl_Clk_i                      => PrSl_ClkFre_s                        , -- in std_logic;

        ------------------------------------------------------------------------
        --Dvi signal
        ------------------------------------------------------------------------
        CpSl_Dvi0Scdt_i                 => PrSl_If_Dvi0Scdt_s                   , -- in std_logic;
        CpSl_Dvi1Scdt_i                 => PrSl_If_Dvi1Scdt_s                   , -- in std_logic;
        CpSl_Dvi0Vsync_i                => PrSl_If_Dvi0Vsync_s                  , -- in std_logic;

        --------------------------------
        -- Select Clk
        --------------------------------
        CpSl_ClkSel_o                   => open                                 , -- out std_logic;
        CpSl_DviEn_o                    => open                                 , -- Dvi input enable
        
        --------------------------------
        --Frequence Choice
        --------------------------------
        CpSl_LCD_Double_o               => open                                 , -- out std_logic;
        CpSv_FreChoice_o                => PrSv_FreChoice_s                     , -- out std_logic_vector( 2 downto 0);
        CpSv_FreLed_o                   => PrSv_FreLed_s                        , -- out std_logic_vector( 3 downto 0);
        
        --------------------------------
        --ChipScope 
        --------------------------------
        CpSv_ChipCtrl3_io               => PrSv_ChipCtrl3_s                       -- in std_logic_vector(35 downto 0)
    );

    ----------------------------------------------------------------------------
    -- Dvi Input
    ----------------------------------------------------------------------------
    U_M_DviIf_0 : M_DviIf port map (
        --------------------------------
        -- DVI Input
        --------------------------------
        CpSl_Dvi0Clk_i                  => CpSl_Dvi0Clk_i                       , -- Dvi0Clk
        CpSl_Dvi0Vsync_i                => CpSl_Dvi0Vsync_i                     , -- Dvi0Vsync 
        CpSl_Dvi0Hsync_i                => CpSl_Dvi0Hsync_i                     , -- Dvi0Hsync 
        CpSl_Dvi0De_i                   => CpSl_Dvi0De_i                        , -- Dvi0De 
        CpSl_Dvi0Scdt_i                 => CpSl_Dvi0Scdt_i                      , -- Dvi0Scdt
        CpSv_Dvi0R_i                    => CpSv_Dvi0R_i                         , -- Dvi0R  
        CpSv_Dvi0G_i                    => CpSv_Dvi0G_i                         , -- DVI0G
        CpSl_Dvi1Scdt_i                 => CpSl_Dvi1Scdt_i                      , -- Dvi1Scdt
        CpSv_Dvi1R_i                    => CpSv_Dvi1R_i                         , -- Dvi1R  
        CpSv_Dvi1G_i                    => CpSv_Dvi1G_i                         , -- DVI1G
                                                                                 
        --------------------------------                                         
        -- DVI Output                                                            
        --------------------------------  
        CpSl_Dvi0Clk_o                  => PrSl_If_Dvi0Clk_s                    , -- Dvi0Clk    
        CpSl_Dvi0Vsync_o                => PrSl_If_Dvi0Vsync_s                  , -- Dvi0Vsync  
        CpSl_Dvi0Hsync_o                => PrSl_If_Dvi0Hsync_s                  , -- Dvi0Hsync  
        CpSl_Dvi0De_o                   => PrSl_If_Dvi0De_s                     , -- Dvi0De     
        CpSl_Dvi0Scdt_o                 => PrSl_If_Dvi0Scdt_s                   , -- Dvi0Scdt   
        CpSv_Dvi0R_o                    => PrSv_If_Dvi0R_s                      , -- Dvi0R      
        CpSv_Dvi0G_o                    => PrSv_If_Dvi0G_s                      , -- Dvi0R 
        CpSl_Dvi1Scdt_o                 => open                   , -- Dvi1Scdt   
        CpSv_Dvi1R_o                    => PrSv_If_Dvi1R_s                      , -- Dvi1R   
        CpSv_Dvi1G_o                    => PrSv_If_Dvi1G_s                        -- Dvi1G      
    );

    ----------------------------------------------------------------------------
    -- DDR, include:
    -- DDR interface
    -- DDR controller
    ----------------------------------------------------------------------------
    ------------------------------------
    -- DDR if with controller
    -- M_ila Core
    ------------------------------------
    U_M_DdrIf_0 : M_DdrIf 
    generic map(
        Simulation                      => Simulation,
        Use_ChipScope                   => Use_ChipScope
    )
    port map (
        --------------------------------
        -- SMA VSync Test
        --------------------------------
        CpSl_DVISync_SMA_o              => PrSl_DVISyncTest_s                   , -- out std_logic;
        CpSl_LCDSync_SMA_o              => PrSl_LCDSyncTest_s                   , -- out std_logic;

        --------------------------------
        -- DVI
        --------------------------------
        CpSl_Dvi0Clk_i                  => PrSl_If_Dvi0Clk_s                    , -- in  std_logic;
        CpSl_Dvi0Vsync_i                => PrSl_If_Dvi0Vsync_s                  , -- in  std_logic;                        
        CpSl_Dvi0Hsync_i                => PrSl_If_Dvi0Hsync_s                  , -- in  std_logic;                        
        CpSl_Dvi0De_i                   => PrSl_If_Dvi0De_s                     , -- in  std_logic;                        
        CpSl_Dvi0Scdt_i                 => PrSl_If_Dvi0Scdt_s                   , -- in  std_logic;                        
        CpSv_Dvi0R_i                    => PrSv_If_Dvi0R_s                      , -- in  std_logic_vector(  7 downto 0);   
        CpSv_Dvi0G_i                    => PrSv_If_Dvi0G_s                      , -- in  std_logic_vector(  7 downto 0); 
        CpSl_Dvi1Scdt_i                 => PrSl_If_Dvi1Scdt_s                   , -- in  std_logic;                        
        CpSv_Dvi1R_i                    => PrSv_If_Dvi1R_s                      , -- in  std_logic_vector(  7 downto 0);   
        CpSv_Dvi1G_i                    => PrSv_If_Dvi1G_s                      , -- in  std_logic_vector(  7 downto 0); 
        
        --------------------------------
        -- LCD
        --------------------------------
        CpSl_LcdClk_i                   => PrSl_ClkLcd_s                        , -- in  std_logic; 
        CpSl_LCD_Double_i               => '0'                                  , -- in  std_logic;                      
        CpSv_Refresh_Rate_Sel_i         => PrSv_FreChoice_s                     , -- in  std_logic_vector(  2 downto 0);  
        CpSl_LcdVsync_o                 => PrSl_RealVsync_s                     , -- out std_logic;                       
        CpSl_LcdHsync_o                 => PrSl_RealHsync_s                     , -- out std_logic;                       
        CpSv_LcdR0_o                    => PrSv_RealR0_s                        , -- out std_logic_vector( 11 downto 0);  
        CpSv_LcdR1_o                    => PrSv_RealR1_s                        , -- out std_logic_vector( 11 downto 0);  
        CpSv_LcdR2_o                    => PrSv_RealR2_s                        , -- out std_logic_vector( 11 downto 0);  
        CpSv_LcdR3_o                    => PrSv_RealR3_s                        , -- out std_logic_vector( 11 downto 0);  
        CpSv_LcdG0_o                    => PrSv_RealG0_s                        , -- out std_logic_vector( 11 downto 0);  
        CpSv_LcdG1_o                    => PrSv_RealG1_s                        , -- out std_logic_vector( 11 downto 0);  
        CpSv_LcdG2_o                    => PrSv_RealG2_s                        , -- out std_logic_vector( 11 downto 0);  
        CpSv_LcdG3_o                    => PrSv_RealG3_s                        , -- out std_logic_vector( 11 downto 0);
        
        --------------------------------
        -- DDR
        --------------------------------
        CpSl_DdrRdy_i                   => PrSl_DdrRdy_s                        , -- in  std_logic;                        
        CpSl_DdrClk_i                   => PrSl_DdrClk_s                        , -- in  std_logic;                        
        CpSl_AppRdy_i                   => PrSl_AppRdy_s                        , -- in  std_logic;                        
        CpSl_AppEn_o                    => PrSl_AppEn_s                         , -- out std_logic;                        
        CpSv_AppCmd_o                   => PrSv_AppCmd_s                        , -- out std_logic_vector(  2 downto 0);   
        CpSv_AppAddr_o                  => PrSv_AppAddr_s                       , -- out std_logic_vector( 28 downto 0);   
        CpSl_AppWdfRdy_i                => PrSl_AppWdfRdy_s                     , -- in  std_logic;                        
        CpSl_AppWdfWren_o               => PrSl_AppWdfWren_s                    , -- out std_logic;                        
        CpSl_AppWdfEnd_o                => PrSl_AppWdfEnd_s                     , -- out std_logic;                        
        CpSv_AppWdfData_o               => PrSv_AppWdfData_s                    , -- out std_logic_vector(255 downto 0);   
        CpSl_AppRdDataVld_i             => PrSl_AppRdDataVld_s                  , -- in  std_logic;                        
        CpSv_AppRdData_i                => PrSv_AppRdData_s                     , -- in  std_logic_vector(255 downto 0)    
        
        --------------------------------
        -- ChipScope
        --------------------------------
        CpSv_ChipCtrl0_io               => PrSv_ChipCtrl0_s                     , -- in std_logic_vector(35 downto 0); 
        CpSv_ChipCtrl1_io               => PrSv_ChipCtrl1_s                     , -- in std_logic_vector(35 downto 0); 
        CpSv_ChipCtrl2_io               => PrSv_ChipCtrl2_s                       -- in std_logic_vector(35 downto 0); 
    );

    ------------------------------------
    -- DDR controller
    ------------------------------------
    U_M_DdrCtrl_0 : M_DdrCtrl port map (
        sys_rst                         => CpSl_Rst_iN                          , -- in    std_logic;
        sys_clk_p                       => CpSl_Clk_iP                          , -- in    std_logic;
        sys_clk_n                       => CpSl_Clk_iN                          , -- in    std_logic;
        ui_clk_sync_rst                 => PrSl_DdrRst_s                        , -- out   std_logic;
        ui_clk                          => PrSl_DdrClk_s                        , -- out   std_logic;
        init_calib_complete             => PrSl_DdrRdy_s                        , -- out   std_logic;

        app_addr                        => PrSv_AppAddr_s                       , -- in    std_logic_vector( 28 downto 0);
        app_cmd                         => PrSv_AppCmd_s                        , -- in    std_logic_vector(  2 downto 0);
        app_en                          => PrSl_AppEn_s                         , -- in    std_logic;
        app_wdf_data                    => PrSv_AppWdfData_s                    , -- in    std_logic_vector(255 downto 0);
        app_wdf_end                     => PrSl_AppWdfEnd_s                     , -- in    std_logic;
        app_wdf_mask                    => (others => '0')                      , -- in    std_logic_vector( 31 downto 0);
        app_wdf_wren                    => PrSl_AppWdfWren_s                    , -- in    std_logic;
        app_rd_data                     => PrSv_AppRdData_s                     , -- out   std_logic_vector(255 downto 0);
        app_rd_data_end                 => open                                 , -- out   std_logic;
        app_rd_data_valid               => PrSl_AppRdDataVld_s                  , -- out   std_logic;
        app_rdy                         => PrSl_AppRdy_s                        , -- out   std_logic;
        app_wdf_rdy                     => PrSl_AppWdfRdy_s                     , -- out   std_logic;
        app_sr_req                      => '0'                                  , -- in    std_logic;
        app_sr_active                   => open                                 , -- out   std_logic;
        app_ref_req                     => '0'                                  , -- in    std_logic;
        app_ref_ack                     => open                                 , -- out   std_logic;
        app_zq_req                      => '0'                                  , -- in    std_logic;
        app_zq_ack                      => open                                 , -- out   std_logic;

        ddr3_dq                         => ddr3_dq                              , -- inout std_logic_vector(31 downto 0);
        ddr3_dqs_p                      => ddr3_dqs_p                           , -- inout std_logic_vector( 3 downto 0);
        ddr3_dqs_n                      => ddr3_dqs_n                           , -- inout std_logic_vector( 3 downto 0);
        ddr3_addr                       => ddr3_addr                            , -- out   std_logic_vector(14 downto 0);
        ddr3_ba                         => ddr3_ba                              , -- out   std_logic_vector( 2 downto 0);
        ddr3_ras_n                      => ddr3_ras_n                           , -- out   std_logic;
        ddr3_cas_n                      => ddr3_cas_n                           , -- out   std_logic;
        ddr3_we_n                       => ddr3_we_n                            , -- out   std_logic;
        ddr3_reset_n                    => ddr3_reset_n                         , -- out   std_logic;
        ddr3_ck_p                       => ddr3_ck_p                            , -- out   std_logic_vector( 0 downto 0);
        ddr3_ck_n                       => ddr3_ck_n                            , -- out   std_logic_vector( 0 downto 0);
        ddr3_cke                        => ddr3_cke                             , -- out   std_logic_vector( 0 downto 0);
        ddr3_cs_n                       => ddr3_cs_n                            , -- out   std_logic_vector( 0 downto 0);
        ddr3_dm                         => ddr3_dm                              , -- out   std_logic_vector( 3 downto 0);
        ddr3_odt                        => ddr3_odt                               -- out   std_logic_vector( 0 downto 0)
    );

    ----------------------------------------------------------------------------
    -- Image pattern generator & image data map
    ----------------------------------------------------------------------------
    ------------------------------------
    -- Test pattern
    ------------------------------------
    U_M_Pattern_0 : M_Pattern port map (
        --------------------------------
        -- Reset and clock
        --------------------------------
        CpSl_Rst_iN                     => PrSl_PllLocked_s                       , -- in  std_logic; 
        CpSl_Clk_i                      => PrSl_ClkLcd_s                        , -- in  std_logic; 

        --------------------------------
        -- Output signals
        --------------------------------
        CpSl_Hsync_o                    => PrSl_SimHsync_s                      , -- out std_logic;
        CpSl_Vsync_o                    => PrSl_SimVsync_s                      , -- out std_logic;
        CpSv_Red0_o                     => PrSv_SimR0_s                         , -- out std_logic_vector(11 downto 0);
        CpSv_Red1_o                     => PrSv_SimR1_s                         , -- out std_logic_vector(11 downto 0);
        CpSv_Red2_o                     => PrSv_SimR2_s                         , -- out std_logic_vector(11 downto 0);
        CpSv_Red3_o                     => PrSv_SimR3_s                           -- out std_logic_vector(11 downto 0)
    );

    ------------------------------------
    -- Image data map
    ------------------------------------
    PrSl_SimSwitch_s  <= '0'; -- 0: Real data, 1: Sim data

    PrSl_Port0Hsync_s <= PrSl_SimHsync_s when (PrSl_SimSwitch_s = '1') else PrSl_RealHsync_s;
    PrSl_Port0Vsync_s <= PrSl_SimVsync_s when (PrSl_SimSwitch_s = '1') else PrSl_RealVsync_s;
    PrSv_Port0R0_s    <= PrSv_SimR0_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealR0_s   ;
    PrSv_Port0R1_s    <= PrSv_SimR1_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealR1_s   ;
    PrSv_Port0R2_s    <= PrSv_SimR2_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealR2_s   ;
    PrSv_Port0R3_s    <= PrSv_SimR3_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealR3_s   ;
    PrSv_Port0G0_s    <= PrSv_SimR0_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG0_s   ;
    PrSv_Port0G1_s    <= PrSv_SimR1_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG1_s   ;
    PrSv_Port0G2_s    <= PrSv_SimR2_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG2_s   ;
    PrSv_Port0G3_s    <= PrSv_SimR3_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG3_s   ;
    PrSv_Port0B0_s    <= PrSv_SimR0_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG0_s   ;
    PrSv_Port0B1_s    <= PrSv_SimR1_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG1_s   ;
    PrSv_Port0B2_s    <= PrSv_SimR2_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG2_s   ;
    PrSv_Port0B3_s    <= PrSv_SimR3_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG3_s   ;

    PrSl_Port1Hsync_s <= PrSl_SimHsync_s when (PrSl_SimSwitch_s = '1') else PrSl_RealHsync_s;
    PrSl_Port1Vsync_s <= PrSl_SimVsync_s when (PrSl_SimSwitch_s = '1') else PrSl_RealVsync_s;
    PrSv_Port1R0_s    <= PrSv_SimR0_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealR0_s   ;
    PrSv_Port1R1_s    <= PrSv_SimR1_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealR1_s   ;
    PrSv_Port1R2_s    <= PrSv_SimR2_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealR2_s   ;
    PrSv_Port1R3_s    <= PrSv_SimR3_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealR3_s   ;
    PrSv_Port1G0_s    <= PrSv_SimR0_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG0_s   ;
    PrSv_Port1G1_s    <= PrSv_SimR1_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG1_s   ;
    PrSv_Port1G2_s    <= PrSv_SimR2_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG2_s   ;
    PrSv_Port1G3_s    <= PrSv_SimR3_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG3_s   ;
    PrSv_Port1B0_s    <= PrSv_SimR0_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG0_s   ;
    PrSv_Port1B1_s    <= PrSv_SimR1_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG1_s   ;
    PrSv_Port1B2_s    <= PrSv_SimR2_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG2_s   ;
    PrSv_Port1B3_s    <= PrSv_SimR3_s    when (PrSl_SimSwitch_s = '1') else PrSv_RealG3_s   ;

    ----------------------------------------------------------------------------
    -- For LCD display, include:
    -- entity: Remapper
    -- entity: SelectIO
    -- FMC port map: 2p
    ----------------------------------------------------------------------------
    ------------------------------------
    -- Remapper
    ------------------------------------
    U_remapper_0 : remapper port map (
        clock                           => PrSl_ClkLcd_s                        , -- in  std_logic;
        hsync                           => PrSl_Port0Hsync_s                    , -- in  std_logic;
        vsync                           => PrSl_Port0Vsync_s                    , -- in  std_logic;
        r1                              => PrSv_Port0R0_s                       , -- in  std_logic_vector( 11 downto 0);
        r2                              => PrSv_Port0R1_s                       , -- in  std_logic_vector( 11 downto 0);
        r3                              => PrSv_Port0R2_s                       , -- in  std_logic_vector( 11 downto 0);
        r4                              => PrSv_Port0R3_s                       , -- in  std_logic_vector( 11 downto 0);
        g1                              => PrSv_Port0G0_s                       , -- in  std_logic_vector( 11 downto 0);
        g2                              => PrSv_Port0G1_s                       , -- in  std_logic_vector( 11 downto 0);
        g3                              => PrSv_Port0G2_s                       , -- in  std_logic_vector( 11 downto 0);
        g4                              => PrSv_Port0G3_s                       , -- in  std_logic_vector( 11 downto 0);
        b1                              => PrSv_Port0B0_s                       , -- in  std_logic_vector( 11 downto 0);
        b2                              => PrSv_Port0B1_s                       , -- in  std_logic_vector( 11 downto 0);
        b3                              => PrSv_Port0B2_s                       , -- in  std_logic_vector( 11 downto 0);
        b4                              => PrSv_Port0B3_s                       , -- in  std_logic_vector( 11 downto 0);
        pardata                         => open                                 , -- out std_logic_vector( 55 downto 0);
        pardata_h                       => PrSv_Matrix0H_s                      , -- out std_logic_vector(104 downto 0);
        pardata_l                       => PrSv_Matrix0L_s                        -- out std_logic_vector( 90 downto 0)
    );

    U_remapper_1 : remapper port map (
        clock                           => PrSl_ClkLcd_s                        , -- in  std_logic;
        hsync                           => PrSl_Port1Hsync_s                    , -- in  std_logic;
        vsync                           => PrSl_Port1Vsync_s                    , -- in  std_logic;
        r1                              => PrSv_Port1R0_s                       , -- in  std_logic_vector( 11 downto 0);
        r2                              => PrSv_Port1R1_s                       , -- in  std_logic_vector( 11 downto 0);
        r3                              => PrSv_Port1R2_s                       , -- in  std_logic_vector( 11 downto 0);
        r4                              => PrSv_Port1R3_s                       , -- in  std_logic_vector( 11 downto 0);
        g1                              => PrSv_Port1G0_s                       , -- in  std_logic_vector( 11 downto 0);
        g2                              => PrSv_Port1G1_s                       , -- in  std_logic_vector( 11 downto 0);
        g3                              => PrSv_Port1G2_s                       , -- in  std_logic_vector( 11 downto 0);
        g4                              => PrSv_Port1G3_s                       , -- in  std_logic_vector( 11 downto 0);
        b1                              => PrSv_Port1B0_s                       , -- in  std_logic_vector( 11 downto 0);
        b2                              => PrSv_Port1B1_s                       , -- in  std_logic_vector( 11 downto 0);
        b3                              => PrSv_Port1B2_s                       , -- in  std_logic_vector( 11 downto 0);
        b4                              => PrSv_Port1B3_s                       , -- in  std_logic_vector( 11 downto 0);
        pardata                         => open                                 , -- out std_logic_vector( 55 downto 0);
        pardata_h                       => PrSv_Matrix1H_s                      , -- out std_logic_vector(104 downto 0);
        pardata_l                       => PrSv_Matrix1L_s                        -- out std_logic_vector( 90 downto 0)
    );

    ------------------------------------
    -- SelectIO
    ------------------------------------
    PrSl_SelectIO_s <= '1' when (PrSl_PllLocked_s = '0' or CpSl_Rst_iN = '0') else '0';

    U_M_HSelectIO_0 : M_HSelectIO port map (
        io_reset                        => PrSl_SelectIO_s                      , -- in  std_logic;
        clk_in                          => PrSl_ClkFmc_s                        , -- in  std_logic;
        clk_div_in                      => PrSl_ClkLcd_s                        , -- in  std_logic;
        data_out_from_device            => PrSv_Matrix0H_s                      , -- in  std_logic_vector(104 downto 0);
        data_out_to_pins_p              => PrSv_Matrix0HS_sP                    , -- out std_logic_vector( 14 downto 0);
        data_out_to_pins_n              => PrSv_Matrix0HS_sN                      -- out std_logic_vector( 14 downto 0)
    );

    U_M_LSelectIO_0 : M_LSelectIO port map (
        io_reset                        => PrSl_SelectIO_s                      , -- in  std_logic;
        clk_in                          => PrSl_ClkFmc_s                        , -- in  std_logic;
        clk_div_in                      => PrSl_ClkLcd_s                        , -- in  std_logic;
        data_out_from_device            => PrSv_Matrix0L_s                      , -- in  std_logic_vector(90 downto 0);
        data_out_to_pins_p              => PrSv_Matrix0LS_sP                    , -- out std_logic_vector(12 downto 0);
        data_out_to_pins_n              => PrSv_Matrix0LS_sN                      -- out std_logic_vector(12 downto 0)
    );

    U_M_HSelectIO_1 : M_HSelectIO port map (
        io_reset                        => PrSl_SelectIO_s                      , -- in  std_logic;
        clk_in                          => PrSl_ClkFmc_s                        , -- in  std_logic;
        clk_div_in                      => PrSl_ClkLcd_s                        , -- in  std_logic;
        data_out_from_device            => PrSv_Matrix1H_s                      , -- in  std_logic_vector(104 downto 0);
        data_out_to_pins_p              => PrSv_Matrix1HS_sP                    , -- out std_logic_vector( 14 downto 0);
        data_out_to_pins_n              => PrSv_Matrix1HS_sN                      -- out std_logic_vector( 14 downto 0)
    );

    U_M_LSelectIO_1 : M_LSelectIO port map (
        io_reset                        => PrSl_SelectIO_s                      , -- in  std_logic;
        clk_in                          => PrSl_ClkFmc_s                        , -- in  std_logic;
        clk_div_in                      => PrSl_ClkLcd_s                        , -- in  std_logic;
        data_out_from_device            => PrSv_Matrix1L_s                      , -- in  std_logic_vector(90 downto 0);
        data_out_to_pins_p              => PrSv_Matrix1LS_sP                    , -- out std_logic_vector(12 downto 0);
        data_out_to_pins_n              => PrSv_Matrix1LS_sN                      -- out std_logic_vector(12 downto 0)
    );
    
    ------------------------------------
    -- FMC port map: Port0
    ------------------------------------
    FMC0_LA02_P <= PrSv_Matrix0HS_sP( 0);
    FMC0_LA03_P <= PrSv_Matrix0HS_sP( 1);
    FMC0_LA04_P <= PrSv_Matrix0HS_sP( 2);
    FMC0_LA05_P <= PrSv_Matrix0HS_sP( 3);
    FMC0_LA06_P <= PrSv_Matrix0HS_sP( 4);
    FMC0_LA07_P <= PrSv_Matrix0HS_sP( 5);
    FMC0_LA08_P <= PrSv_Matrix0HS_sP( 6);
    FMC0_LA09_P <= PrSv_Matrix0HS_sP( 7);
    FMC0_LA10_P <= PrSv_Matrix0HS_sP( 8);
    FMC0_LA11_P <= PrSv_Matrix0HS_sP( 9);
    FMC0_LA12_P <= PrSv_Matrix0HS_sP(10);
    FMC0_LA13_P <= PrSv_Matrix0HS_sP(11);
    FMC0_LA14_P <= PrSv_Matrix0HS_sP(12);
    FMC0_LA15_P <= PrSv_Matrix0HS_sP(13);
    FMC0_LA16_P <= PrSv_Matrix0HS_sP(14);

    FMC0_LA19_P <= PrSv_Matrix0LS_sP( 0);
    FMC0_LA20_P <= PrSv_Matrix0LS_sP( 1);
    FMC0_LA21_P <= PrSv_Matrix0LS_sP( 2);
    FMC0_LA22_P <= PrSv_Matrix0LS_sP( 3);
    FMC0_LA23_P <= PrSv_Matrix0LS_sP( 4);
    FMC0_LA24_P <= PrSv_Matrix0LS_sP( 5);
    FMC0_LA25_P <= PrSv_Matrix0LS_sP( 6);
    FMC0_LA26_P <= PrSv_Matrix0LS_sP( 7);
    FMC0_LA27_P <= PrSv_Matrix0LS_sP( 8);
    FMC0_LA28_P <= PrSv_Matrix0LS_sP( 9);
    FMC0_LA29_P <= PrSv_Matrix0LS_sP(10);
    FMC0_LA30_P <= PrSv_Matrix0LS_sP(11);
    FMC0_LA31_P <= PrSv_Matrix0LS_sP(12);

    FMC0_LA32_N <= PrSl_PllLocked_s;
    FMC0_LA_N   <= PrSv_Matrix0LS_sN
                 & PrSv_Matrix0HS_sN;

    ------------------------------------
    -- FMC port map: Port1
    ------------------------------------
    FMC1_LA02_P <= PrSv_Matrix1HS_sP( 0);
    FMC1_LA03_P <= PrSv_Matrix1HS_sP( 1);
    FMC1_LA04_P <= PrSv_Matrix1HS_sP( 2);
    FMC1_LA05_P <= PrSv_Matrix1HS_sP( 3);
    FMC1_LA06_P <= PrSv_Matrix1HS_sP( 4);
    FMC1_LA07_P <= PrSv_Matrix1HS_sP( 5);
    FMC1_LA08_P <= PrSv_Matrix1HS_sP( 6);
    FMC1_LA09_P <= PrSv_Matrix1HS_sP( 7);
    FMC1_LA10_P <= PrSv_Matrix1HS_sP( 8);
    FMC1_LA11_P <= PrSv_Matrix1HS_sP( 9);
    FMC1_LA12_P <= PrSv_Matrix1HS_sP(10);
    FMC1_LA13_P <= PrSv_Matrix1HS_sP(11);
    FMC1_LA14_P <= PrSv_Matrix1HS_sP(12);
    FMC1_LA15_P <= PrSv_Matrix1HS_sP(13);
    FMC1_LA16_P <= PrSv_Matrix1HS_sP(14);

    FMC1_LA19_P <= PrSv_Matrix1LS_sP( 0);
    FMC1_LA20_P <= PrSv_Matrix1LS_sP( 1);
    FMC1_LA21_P <= PrSv_Matrix1LS_sP( 2);
    FMC1_LA22_P <= PrSv_Matrix1LS_sP( 3);
    FMC1_LA23_P <= PrSv_Matrix1LS_sP( 4);
    FMC1_LA24_P <= PrSv_Matrix1LS_sP( 5);
    FMC1_LA25_P <= PrSv_Matrix1LS_sP( 6);
    FMC1_LA26_P <= PrSv_Matrix1LS_sP( 7);
    FMC1_LA27_P <= PrSv_Matrix1LS_sP( 8);
    FMC1_LA28_P <= PrSv_Matrix1LS_sP( 9);
    FMC1_LA29_P <= PrSv_Matrix1LS_sP(10);
    FMC1_LA30_P <= PrSv_Matrix1LS_sP(11);
    FMC1_LA31_P <= PrSv_Matrix1LS_sP(12);

    FMC1_LA32_N <= PrSl_PllLocked_s;
    FMC1_LA_N   <= PrSv_Matrix1LS_sN
                 & PrSv_Matrix1HS_sN;

    ----------------------------------------------------------------------------
    -- External interface
    -- LED: 4bit
    -- SMA: 4bit
    -- GPIO: 5bit 
    ----------------------------------------------------------------------------
    ------------------------------------
    -- LED
    ------------------------------------
    CpSv_Led_o(3 downto 0) <= PrSv_FreLed_s;

    ------------------------------------
    -- SMA
    ------------------------------------
    CpSv_Sma_o(0) <= PrSl_DVISyncTest_s;
    CpSv_Sma_o(1) <= PrSl_LCDSyncTest_s;
    CpSv_Sma_o(2) <= '0';
    CpSv_Sma_o(3) <= '0';
        
    ------------------------------------
    -- GPIO 
    ------------------------------------
    CpSv_Gpio_o(0) <= PrSl_DVISyncTest_s;
    CpSv_Gpio_o(1) <= PrSl_LCDSyncTest_s;
    CpSv_Gpio_o(4 downto 2) <= (others => '0');

end arch_M_Lcd4Top;