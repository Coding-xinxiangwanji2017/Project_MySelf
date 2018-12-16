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
-- 文件名称  :  M_DviIf.vhd
-- 设    计  :  zhang wenjun 
-- 邮    件  :  
-- 校    对  :  
-- 设计日期  :  2016/01/28
-- 功能简述  :  DVI/LCD/DDR
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2016/06/28
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

entity M_DviIf is
    port (
        --------------------------------
        -- DVI Input
        --------------------------------
        CpSl_Dvi0Clk_i                  : in  std_logic;                        -- DVI0 clk
        CpSl_Dvi0Vsync_i                : in  std_logic;                        -- DVI0 V sync
        CpSl_Dvi0Hsync_i                : in  std_logic;                        -- DVI0 H sync
        CpSl_Dvi0De_i                   : in  std_logic;                        -- DVI0 De
        CpSl_Dvi0Scdt_i                 : in  std_logic;                        -- DVI0 SCDT
        CpSv_Dvi0R_i                    : in  std_logic_vector(  7 downto 0);   -- DVI0 red
        CpSl_Dvi1Scdt_i                 : in  std_logic;                        -- DVI0 SCDT
        CpSv_Dvi1R_i                    : in  std_logic_vector(  7 downto 0);   -- DVI1 red
        CpSl_Dvi1De_i                   : in  std_logic;                        -- DVI1 De
        
        --------------------------------
        -- DVI Output
        --------------------------------
        CpSl_Dvi0Clk_o                  : out std_logic;                        -- DVI0 clk
        CpSl_Dvi0Vsync_o                : out std_logic;                        -- DVI0 V sync
        CpSl_Dvi0Hsync_o                : out std_logic;                        -- DVI0 H sync
        CpSl_Dvi0De_o                   : out std_logic;                        -- DVI0 De
        CpSl_Dvi0Scdt_o                 : out std_logic;                        -- DVI0 SCDT
        CpSv_Dvi0R_o                    : out std_logic_vector(  7 downto 0);   -- DVI0 red
        CpSl_Dvi1Scdt_o                 : out std_logic;                        -- DVI1 SCDT
        CpSl_Dvi1De_o                   : out std_logic;                        -- DVI1 De
        CpSv_Dvi1R_o                    : out std_logic_vector(  7 downto 0)    -- DVI1 red
        
    );
end M_DviIf;

architecture arch_M_DdrIf of M_DviIf is
    ----------------------------------------------------------------------------
    -- constant declaration
    ----------------------------------------------------------------------------
    
    ----------------------------------------------------------------------------
    -- component declaration
    ----------------------------------------------------------------------------
    
    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    signal PrSl_Clk_s                   : std_logic;
    signal PrSv_Input_s                 : std_logic_vector(22 downto 0);
    signal PrSv_IDDR_Pos_s              : std_logic_vector(22 downto 0);
    signal PrSv_IDDR_Neg_s              : std_logic_vector(22 downto 0);
    signal PrSv_Output_s                : std_logic_vector(22 downto 0);
        
begin
    
    IBUFG_inst : IBUFG
    generic map (
        IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
        IOSTANDARD => "DEFAULT")
    port map (
        O => PrSl_Clk_s,        -- Clock buffer output
        I => CpSl_Dvi0Clk_i     -- Clock buffer input (connect directly to top-level port)
    );

    PrSv_Input_s(0)                 <= CpSl_Dvi0Vsync_i ;
    PrSv_Input_s(1)                 <= CpSl_Dvi0Hsync_i ;
    PrSv_Input_s(2)                 <= CpSl_Dvi0De_i    ;
    PrSv_Input_s(3)                 <= CpSl_Dvi0Scdt_i  ;
    PrSv_Input_s(11 downto 4)       <= CpSv_Dvi0R_i     ;
    PrSv_Input_s(12)                <= CpSl_Dvi1Scdt_i  ;
    PrSv_Input_s(20 downto 13)      <= CpSv_Dvi1R_i     ;
    PrSv_Input_s(21)                <= CpSl_Dvi1De_i    ;   
        
    IDDR_GEN: for i in 0 to 21 generate 
    begin
        IDDR_inst : IDDR
        generic map (
            DDR_CLK_EDGE => "SAME_EDGE",    -- "OPPOSITE_EDGE", "SAME_EDGE"
                                            -- or "SAME_EDGE_PIPELINED"
            INIT_Q1 => '0',                 -- Initial value of Q1: '0' or '1'
            INIT_Q2 => '0',                 -- Initial value of Q2: '0' or '1'
            SRTYPE => "SYNC")               -- Set/Reset type: "SYNC" or "ASYNC"
        port map (
            Q1  => PrSv_IDDR_Pos_s(i),      -- 1-bit output for positive edge of clock
            Q2  => PrSv_IDDR_Neg_s(i),      -- 1-bit output for negative edge of clock
            C   => PrSl_Clk_s,              -- 1-bit clock input
            CE  => '1',                     -- 1-bit clock enable input
            D   => PrSv_Input_s(i),         -- 1-bit DDR data input
            R   => '0',                     -- 1-bit reset
            S   => '0'                      -- 1-bit set
        );
    end generate IDDR_GEN;
    
    --Select the Negative edge data
    process (PrSl_Clk_s) begin
        if rising_edge(PrSl_Clk_s) then
            PrSv_Output_s <= PrSv_IDDR_Neg_s;
        end if;
    end process;
    
    CpSl_Dvi0Clk_o      <= PrSl_Clk_s                 ;
    CpSl_Dvi0Vsync_o    <= PrSv_Output_s(0)           ;
    CpSl_Dvi0Hsync_o    <= PrSv_Output_s(1)           ;
    CpSl_Dvi0De_o       <= PrSv_Output_s(2)           ;
    CpSl_Dvi0Scdt_o     <= PrSv_Output_s(3)           ;
    CpSv_Dvi0R_o        <= PrSv_Output_s(11 downto 4) ;
    CpSl_Dvi1Scdt_o     <= PrSv_Output_s(12)          ;
    CpSv_Dvi1R_o        <= PrSv_Output_s(20 downto 13);
    CpSl_Dvi1De_o       <= PrSv_Output_s(21)          ;    

end arch_M_DdrIf;