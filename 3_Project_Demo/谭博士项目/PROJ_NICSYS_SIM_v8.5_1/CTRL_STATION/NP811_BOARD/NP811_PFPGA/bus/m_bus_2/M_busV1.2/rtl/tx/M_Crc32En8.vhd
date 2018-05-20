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
-- 文件名称  :  M_Crc32De8.vhd
-- 设    计  :  
-- 邮    件  :  
-- 校    对  :
-- 设计日期  :  2014/05/08
-- 功能简述  :  CRC encoder, CRC 32bit, CpSv_Data_i 8 bit
--              Polynomial: (0 1 2 4 5 7 8 10 11 12 16 22 23 26 32)
--              CRC result is 32bit, When used as 8bit, the output order shoule be
--                    _____       _____       _____       _____
--              _____|     |_____|     |_____|     |_____|     |_____
--                      [31:24]     [23:16]     [15: 8]     [ 7: 0]
-- 版本序号  :  
-- 修改历史  :  
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity M_Crc32En8 is
    port (
        CpSl_Rst_i                      : in  std_logic;                        --
        CpSl_Clk_i                      : in  std_logic;                        --

        CpSl_Init_i                     : in  std_logic;                        --
        CpSv_Data_i                     : in  std_logic_vector( 7 downto 0);    --
        CpSl_CrcEn_i                    : in  std_logic;                        --
        CpSv_CrcResult_o                : out std_logic_vector(31 downto 0)     --
    );
end M_Crc32En8;

architecture arch_M_Crc32En8 of M_Crc32En8 is
    ----------------------------------------------------------------------------
    -- constant declaration
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- component declaration
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    signal PrSv_D_s                     : std_logic_vector( 7 downto 0);        --
    signal PrSv_C_s                     : std_logic_vector(31 downto 0);        --

begin
    ----------------------------------------------------------------------------
    -- Data in
    ----------------------------------------------------------------------------
    PrSv_D_s (0)<= CpSv_Data_i (7);
    PrSv_D_s (1)<= CpSv_Data_i (6);
    PrSv_D_s (2)<= CpSv_Data_i (5);
    PrSv_D_s (3)<= CpSv_Data_i (4);
    PrSv_D_s (4)<= CpSv_Data_i (3);
    PrSv_D_s (5)<= CpSv_Data_i (2);
    PrSv_D_s (6)<= CpSv_Data_i (1);
    PrSv_D_s (7)<= CpSv_Data_i (0);

    -- CRC
    process (CpSl_Rst_i, CpSl_Clk_i) begin
        if (CpSl_Rst_i = '1') then
            PrSv_C_s <= x"FFFFFFFF";
        elsif rising_edge(CpSl_Clk_i) then
            if (CpSl_Init_i='1') then
                PrSv_C_s <= x"FFFFFFFF";
            elsif (CpSl_CrcEn_i = '1') then
                -- 0~7
                PrSv_C_s( 0) <= PrSv_D_s( 6) xor PrSv_D_s( 0) xor
                         PrSv_C_s(24) xor PrSv_C_s(30);
                PrSv_C_s( 1) <= PrSv_D_s( 7) xor PrSv_D_s( 6) xor PrSv_D_s( 1) xor PrSv_D_s( 0) xor
                         PrSv_C_s(24) xor PrSv_C_s(25) xor PrSv_C_s(30) xor PrSv_C_s(31);
                PrSv_C_s( 2) <= PrSv_D_s( 7) xor PrSv_D_s( 6) xor PrSv_D_s( 2) xor PrSv_D_s( 1) xor PrSv_D_s( 0) xor
                         PrSv_C_s(24) xor PrSv_C_s(25) xor PrSv_C_s(26) xor PrSv_C_s(30) xor PrSv_C_s(31);
                PrSv_C_s( 3) <= PrSv_D_s( 7) xor PrSv_D_s( 3) xor PrSv_D_s( 2) xor PrSv_D_s( 1) xor
                         PrSv_C_s(25) xor PrSv_C_s(26) xor PrSv_C_s(27) xor PrSv_C_s(31);
                PrSv_C_s( 4) <= PrSv_D_s( 6) xor PrSv_D_s( 4) xor PrSv_D_s( 3) xor PrSv_D_s( 2) xor PrSv_D_s( 0) xor
                         PrSv_C_s(24) xor PrSv_C_s(26) xor PrSv_C_s(27) xor PrSv_C_s(28) xor PrSv_C_s(30);
                PrSv_C_s( 5) <= PrSv_D_s( 7) xor PrSv_D_s( 6) xor PrSv_D_s( 5) xor PrSv_D_s( 4) xor PrSv_D_s( 3) xor PrSv_D_s( 1) xor PrSv_D_s( 0) xor
                         PrSv_C_s(24) xor PrSv_C_s(25) xor PrSv_C_s(27) xor PrSv_C_s(28) xor PrSv_C_s(29) xor PrSv_C_s(30) xor PrSv_C_s(31);
                PrSv_C_s( 6) <= PrSv_D_s( 7) xor PrSv_D_s( 6) xor PrSv_D_s( 5) xor PrSv_D_s( 4) xor PrSv_D_s( 2) xor PrSv_D_s( 1) xor
                         PrSv_C_s(25) xor PrSv_C_s(26) xor PrSv_C_s(28) xor PrSv_C_s(29) xor PrSv_C_s(30) xor PrSv_C_s(31);
                PrSv_C_s( 7) <= PrSv_D_s( 7) xor PrSv_D_s( 5) xor PrSv_D_s( 3) xor PrSv_D_s( 2) xor PrSv_D_s( 0) xor
                         PrSv_C_s(24) xor PrSv_C_s(26) xor PrSv_C_s(27) xor PrSv_C_s(29) xor PrSv_C_s(31);

                -- 8~15
                PrSv_C_s( 8) <= PrSv_D_s( 4) xor PrSv_D_s( 3) xor PrSv_D_s( 1) xor PrSv_D_s( 0) xor
                         PrSv_C_s( 0) xor PrSv_C_s(24) xor PrSv_C_s(25) xor PrSv_C_s(27) xor PrSv_C_s(28);
                PrSv_C_s( 9) <= PrSv_D_s( 5) xor PrSv_D_s( 4) xor PrSv_D_s( 2) xor PrSv_D_s( 1) xor
                         PrSv_C_s( 1) xor PrSv_C_s(25) xor PrSv_C_s(26) xor PrSv_C_s(28) xor PrSv_C_s(29);
                PrSv_C_s(10) <= PrSv_D_s( 5) xor PrSv_D_s( 3) xor PrSv_D_s( 2) xor PrSv_D_s( 0) xor
                         PrSv_C_s( 2) xor PrSv_C_s(24) xor PrSv_C_s(26) xor PrSv_C_s(27) xor PrSv_C_s(29);
                PrSv_C_s(11) <= PrSv_D_s( 4) xor PrSv_D_s( 3) xor PrSv_D_s( 1) xor PrSv_D_s( 0) xor
                         PrSv_C_s( 3) xor PrSv_C_s(24) xor PrSv_C_s(25) xor PrSv_C_s(27) xor PrSv_C_s(28);
                PrSv_C_s(12) <= PrSv_D_s( 6) xor PrSv_D_s( 5) xor PrSv_D_s( 4) xor PrSv_D_s( 2) xor PrSv_D_s( 1) xor PrSv_D_s( 0) xor
                         PrSv_C_s( 4) xor PrSv_C_s(24) xor PrSv_C_s(25) xor PrSv_C_s(26) xor PrSv_C_s(28) xor PrSv_C_s(29) xor PrSv_C_s(30);
                PrSv_C_s(13) <= PrSv_D_s( 7) xor PrSv_D_s( 6) xor PrSv_D_s( 5) xor PrSv_D_s( 3) xor PrSv_D_s( 2) xor PrSv_D_s( 1) xor
                         PrSv_C_s( 5) xor PrSv_C_s(25) xor PrSv_C_s(26) xor PrSv_C_s(27) xor PrSv_C_s(29) xor PrSv_C_s(30) xor PrSv_C_s(31);
                PrSv_C_s(14) <= PrSv_D_s( 7) xor PrSv_D_s( 6) xor PrSv_D_s( 4) xor PrSv_D_s( 3) xor PrSv_D_s( 2) xor
                         PrSv_C_s( 6) xor PrSv_C_s(26) xor PrSv_C_s(27) xor PrSv_C_s(28) xor PrSv_C_s(30) xor PrSv_C_s(31);
                PrSv_C_s(15) <= PrSv_D_s( 7) xor PrSv_D_s( 5) xor PrSv_D_s( 4) xor PrSv_D_s( 3) xor
                         PrSv_C_s( 7) xor PrSv_C_s(27) xor PrSv_C_s(28) xor PrSv_C_s(29) xor PrSv_C_s(31);

                -- 16~23
                PrSv_C_s(16) <= PrSv_D_s( 5) xor PrSv_D_s( 4) xor PrSv_D_s( 0) xor
                         PrSv_C_s( 8) xor PrSv_C_s(24) xor PrSv_C_s(28) xor PrSv_C_s(29);
                PrSv_C_s(17) <= PrSv_D_s( 6) xor PrSv_D_s( 5) xor PrSv_D_s( 1) xor
                         PrSv_C_s( 9) xor PrSv_C_s(25) xor PrSv_C_s(29) xor PrSv_C_s(30);
                PrSv_C_s(18) <= PrSv_D_s( 7) xor PrSv_D_s( 6) xor PrSv_D_s( 2) xor
                         PrSv_C_s(10) xor PrSv_C_s(26) xor PrSv_C_s(30) xor PrSv_C_s(31);
                PrSv_C_s(19) <= PrSv_D_s( 7) xor PrSv_D_s( 3) xor
                         PrSv_C_s(11) xor PrSv_C_s(27) xor PrSv_C_s(31);
                PrSv_C_s(20) <= PrSv_D_s( 4) xor
                         PrSv_C_s(12) xor PrSv_C_s(28);
                PrSv_C_s(21) <= PrSv_D_s( 5) xor
                         PrSv_C_s(13) xor PrSv_C_s(29);
                PrSv_C_s(22) <= PrSv_D_s( 0) xor
                         PrSv_C_s(14) xor PrSv_C_s(24);
                PrSv_C_s(23) <= PrSv_D_s( 6) xor PrSv_D_s( 1) xor PrSv_D_s( 0) xor
                         PrSv_C_s(15) xor PrSv_C_s(24) xor PrSv_C_s(25) xor PrSv_C_s(30);

                -- 24~32
                PrSv_C_s(24) <= PrSv_D_s( 7) xor PrSv_D_s( 2) xor PrSv_D_s( 1) xor
                         PrSv_C_s(16) xor PrSv_C_s(25) xor PrSv_C_s(26) xor PrSv_C_s(31);
                PrSv_C_s(25) <= PrSv_D_s( 3) xor PrSv_D_s( 2) xor
                         PrSv_C_s(17) xor PrSv_C_s(26) xor PrSv_C_s(27);
                PrSv_C_s(26) <= PrSv_D_s( 6) xor PrSv_D_s( 4) xor PrSv_D_s( 3) xor PrSv_D_s( 0) xor
                         PrSv_C_s(18) xor PrSv_C_s(24) xor PrSv_C_s(27) xor PrSv_C_s(28) xor PrSv_C_s(30);
                PrSv_C_s(27) <= PrSv_D_s( 7) xor PrSv_D_s( 5) xor PrSv_D_s( 4) xor PrSv_D_s( 1) xor
                         PrSv_C_s(19) xor PrSv_C_s(25) xor PrSv_C_s(28) xor PrSv_C_s(29) xor PrSv_C_s(31);
                PrSv_C_s(28) <= PrSv_D_s( 6) xor PrSv_D_s( 5) xor PrSv_D_s( 2) xor
                         PrSv_C_s(20) xor PrSv_C_s(26) xor PrSv_C_s(29) xor PrSv_C_s(30);
                PrSv_C_s(29) <= PrSv_D_s( 7) xor PrSv_D_s( 6) xor PrSv_D_s( 3) xor
                         PrSv_C_s(21) xor PrSv_C_s(27) xor PrSv_C_s(30) xor PrSv_C_s(31);
                PrSv_C_s(30) <= PrSv_D_s( 7) xor PrSv_D_s( 4) xor
                         PrSv_C_s(22) xor PrSv_C_s(28) xor PrSv_C_s(31);
                PrSv_C_s(31) <= PrSv_D_s( 5) xor
                         PrSv_C_s(23) xor PrSv_C_s(29);
            end if;
        end if;
    end process;

    -- Not
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '1') then
            CpSv_CrcResult_o <= ( others=>'0');
        elsif rising_edge(CpSl_Clk_i) then
            CpSv_CrcResult_o(31) <= not PrSv_C_s(24);
            CpSv_CrcResult_o(30) <= not PrSv_C_s(25);
            CpSv_CrcResult_o(29) <= not PrSv_C_s(26);
            CpSv_CrcResult_o(28) <= not PrSv_C_s(27);
            CpSv_CrcResult_o(27) <= not PrSv_C_s(28);
            CpSv_CrcResult_o(26) <= not PrSv_C_s(29);
            CpSv_CrcResult_o(25) <= not PrSv_C_s(30);
            CpSv_CrcResult_o(24) <= not PrSv_C_s(31);

            CpSv_CrcResult_o(23) <= not PrSv_C_s(16);
            CpSv_CrcResult_o(22) <= not PrSv_C_s(17);
            CpSv_CrcResult_o(21) <= not PrSv_C_s(18);
            CpSv_CrcResult_o(20) <= not PrSv_C_s(19);
            CpSv_CrcResult_o(19) <= not PrSv_C_s(20);
            CpSv_CrcResult_o(18) <= not PrSv_C_s(21);
            CpSv_CrcResult_o(17) <= not PrSv_C_s(22);
            CpSv_CrcResult_o(16) <= not PrSv_C_s(23);

            CpSv_CrcResult_o(15) <= not PrSv_C_s( 8);
            CpSv_CrcResult_o(14) <= not PrSv_C_s( 9);
            CpSv_CrcResult_o(13) <= not PrSv_C_s(10);
            CpSv_CrcResult_o(12) <= not PrSv_C_s(11);
            CpSv_CrcResult_o(11) <= not PrSv_C_s(12);
            CpSv_CrcResult_o(10) <= not PrSv_C_s(13);
            CpSv_CrcResult_o( 9) <= not PrSv_C_s(14);
            CpSv_CrcResult_o( 8) <= not PrSv_C_s(15);

            CpSv_CrcResult_o( 7) <= not PrSv_C_s( 0);
            CpSv_CrcResult_o( 6) <= not PrSv_C_s( 1);
            CpSv_CrcResult_o( 5) <= not PrSv_C_s( 2);
            CpSv_CrcResult_o( 4) <= not PrSv_C_s( 3);
            CpSv_CrcResult_o( 3) <= not PrSv_C_s( 4);
            CpSv_CrcResult_o( 2) <= not PrSv_C_s( 5);
            CpSv_CrcResult_o( 1) <= not PrSv_C_s( 6);
            CpSv_CrcResult_o( 0) <= not PrSv_C_s( 7);
        end if;
    end process;

end arch_M_Crc32En8;