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
-- 文件名称  :  M_LcdVsync.vhd
-- 设    计  :  zhangwenjun
-- 邮    件  :
-- 校    对  :
-- 设计日期  :  2016/06/29
-- 功能简述  :  Choice Vsync to Lcd output data
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhangwenjun, 2016/06/29
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity M_LcdVsync is
    port (
        --------------------------------
        -- clock & reset
        --------------------------------
        CpSl_Rst_iN                     :  in std_logic;                        -- Resxt active low
        CpSl_Clk_i                      :  in std_logic;                        -- 100MHz
        --------------------------------
        -- Vsync input
        --------------------------------
        CpSl_ExtVsync_i                 :  in std_logic;                        -- Ext vsync
        
        --------------------------------
        -- Vsync output
        --------------------------------
        CpSl_ExtVld_o                   :  out std_logic;                       -- ExtVsync
        CpSl_LcdVsync_o                 :  out std_logic                        -- Vsync
	);
end M_LcdVsync;

architecture arch_M_LcdVsync of M_LcdVsync is
	----------------------------------------------------------------------------
    -- constant declaration
    ----------------------------------------------------------------------------
    --PrSl_ExtSyncCnt_c = 80MHz*2s = 160_000_000 (98967FF)
    constant PrSl_ExtSyncCnt_c          : std_logic_vector(27 downto 0 ) := x"98967FF"; -- 2s Cnt

    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    --Row Trig
    signal PrSl_ExtRowTrig_s            : std_logic;                            -- Ext Vsync Trig
    signal PrSl_ExtRowTrigDly1_s        : std_logic;                            -- Ext Vsync Trig Dly1
    signal PrSl_ExtRowTrigDly2_s        : std_logic;                            -- Ext Vsync Trig Dly2
    signal PrSl_ExtRowTrigDly3_s        : std_logic;                            -- Ext Vsync Trig Dly3
    signal PrSl_ExtVsync_s              : std_logic;                            -- Ext Vsync Trig
    signal PrSl_ExtVld_s                : std_logic;                            -- Est Valid
    
    signal PrSl_ExtVsyncDly1_s          : std_logic;                            -- Dly1
    signal PrSl_ExtVsyncDly2_s          : std_logic;                            -- Dly2
    signal PrSl_ExtVsyncDly3_s          : std_logic;                            -- Dly3
    
    -- Ext sync Cnt
    signal PrSl_ExtSyncCnt_s            : std_logic_vector(27 downto 0);        -- ExtVsync Cnt   

begin
	--Dly CpSl_ExtVsync_i
     process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_ExtVsyncDly1_s <= '0';
            PrSl_ExtVsyncDly2_s <= '0';
            PrSl_ExtVsyncDly3_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_ExtVsyncDly1_s <= CpSl_ExtVsync_i;
            PrSl_ExtVsyncDly2_s <= PrSl_ExtVsyncDly1_s;
            PrSl_ExtVsyncDly3_s <= PrSl_ExtVsyncDly2_s;
        end if;
    end process;
    
    -- Row ExtTrig
    PrSl_ExtRowTrig_s <= (PrSl_ExtVsyncDly2_s and not PrSl_ExtVsyncDly3_s);

    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_ExtRowTrigDly1_s <= '0';
            PrSl_ExtRowTrigDly2_s <= '0';
            PrSl_ExtRowTrigDly3_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_ExtRowTrigDly1_s <= PrSl_ExtRowTrig_s;
            PrSl_ExtRowTrigDly2_s <= PrSl_ExtRowTrigDly1_s;
            PrSl_ExtRowTrigDly3_s <= PrSl_ExtRowTrigDly2_s;
        end if;
    end process;
    --output Extsync
    PrSl_ExtVsync_s <= (PrSl_ExtRowTrig_s or PrSl_ExtRowTrigDly1_s 
                        or PrSl_ExtRowTrigDly2_s or PrSl_ExtRowTrigDly3_s);

    process (CpSl_Rst_iN, CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_ExtSyncCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_ExtRowTrig_s = '1') then
                PrSl_ExtSyncCnt_s <= (others => '0');
            elsif (PrSl_ExtSyncCnt_s = PrSl_ExtSyncCnt_c) then 
                PrSl_ExtSyncCnt_s <= (others => '0');
            else
                PrSl_ExtSyncCnt_s <= PrSl_ExtSyncCnt_s + '1';
            end if;
        end if;
    end process;
    
    --ExtVsync Valid
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_ExtVld_s <= '0';
        elsif rising_edge (CpSl_Clk_i) then
            if (PrSl_ExtRowTrig_s = '1') then 
                PrSl_ExtVld_s <= '1';
            elsif (PrSl_ExtSyncCnt_s = PrSl_ExtSyncCnt_c) then 
                PrSl_ExtVld_s <= '0';
            else --hold
            end if;
        end if;
    end process;
    -- Ext Valid
    CpSl_ExtVld_o <= PrSl_ExtVld_s;     

    --Dly LcdVsync
    process (CpSl_Rst_iN, CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            CpSl_LcdVsync_o <= '0';
        elsif rising_edge (CpSl_Clk_i) then
            if (PrSl_ExtVld_s = '1') then 
                CpSl_LcdVsync_o <= PrSl_ExtVsync_s;
            else
                CpSl_LcdVsync_o <= '0';
            end if;
        end if;
    end process;

end arch_M_LcdVsync;


