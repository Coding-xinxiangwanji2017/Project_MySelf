--
-- ZestETM1 Ethernet interface via breakout board physical layer
--   FIFO interface mode
--   File name: GigExPhyFIFO.vhd
--   Version: 1.00
--   Date: 14/8/2013
--
--
--   Copyright (C) 2013 Orange Tree Technologies Ltd. All rights reserved.
--   Orange Tree Technologies grants the purchaser of a ZestETM1 the right to use and 
--   modify this logic core in any form such as VHDL source code or EDIF netlist in 
--   FPGA designs that target the ZestETM1.
--   Orange Tree Technologies prohibits the use of this logic core in any form such 
--   as VHDL source code or EDIF netlist in FPGA designs that target any other
--   hardware unless the purchaser of the ZestETM1 has purchased the appropriate 
--   licence from Orange Tree Technologies. Contact Orange Tree Technologies if you 
--   want to purchase such a licence.
--
--  *****************************************************************************************
--  **
--  **  Disclaimer: LIMITED WARRANTY AND DISCLAIMER. These designs are
--  **              provided to you "as is". Orange Tree Technologies and its licensors 
--  **              make and you receive no warranties or conditions, express, implied, 
--  **              statutory or otherwise, and Orange Tree Technologies specifically 
--  **              disclaims any implied warranties of merchantability, non-infringement,
--  **              or fitness for a particular purpose. Orange Tree Technologies does not
--  **              warrant that the functions contained in these designs will meet your 
--  **              requirements, or that the operation of these designs will be 
--  **              uninterrupted or error free, or that defects in the Designs will be 
--  **              corrected. Furthermore, Orange Tree Technologies does not warrant or 
--  **              make any representations regarding use or the results of the use of the 
--  **              designs in terms of correctness, accuracy, reliability, or otherwise.                                               
--  **
--  **              LIMITATION OF LIABILITY. In no event will Orange Tree Technologies 
--  **              or its licensors be liable for any loss of data, lost profits, cost or 
--  **              procurement of substitute goods or services, or for any special, 
--  **              incidental, consequential, or indirect damages arising from the use or 
--  **              operation of the designs or accompanying documentation, however caused 
--  **              and on any theory of liability. This limitation will apply even if 
--  **              Orange Tree Technologies has been advised of the possibility of such 
--  **              damage. This limitation shall apply notwithstanding the failure of the 
--  **              essential purpose of any limited remedies herein.
--  **
--  *****************************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity GigExPhyFIFO is
    generic (
        CLOCK_RATE : integer := 125000000
    );
    port (
        CLK : in std_logic;
        
        -- Interface to GigExpedite
        GigEx_Clk : out std_logic;
        GigEx_nTx : out std_logic;
        GigEx_TxChan : out std_logic_vector(2 downto 0);
        GigEx_TxData : out std_logic_vector(7 downto 0);
        GigEx_nRxFull : out std_logic_vector(7 downto 0);
        GigEx_nRx : in std_logic;
        GigEx_RxChan : in std_logic_vector(2 downto 0);
        GigEx_RxData : in std_logic_vector(7 downto 0);
        GigEx_nTxFull : in std_logic_vector(7 downto 0);
        GigEx_nInt : in std_logic;

        -- Application interface
        UserTx : in std_logic;
        UserTxChan : in std_logic_vector(2 downto 0);
        UserTxData : in std_logic_vector(7 downto 0);
        UserRxFull : in std_logic_vector(7 downto 0);
        UserRx : out std_logic;
        UserRxChan : out std_logic_vector(2 downto 0);
        UserRxData : out std_logic_vector(7 downto 0);
        UserTxFull : out std_logic_vector(7 downto 0);
        UserInterrupt : out std_logic
    );
end GigExPhyFIFO;

architecture arch of GigExPhyFIFO is

    -- Declare signals
    signal RegUser_TxChan : std_logic_vector(2 downto 0);
    signal RegUser_TxData : std_logic_vector(7 downto 0);
    signal RegUser_nRxFull : std_logic_vector(7 downto 0);
    signal RegUser_nTx : std_logic;
    
    signal GigEx_nTxVal : std_logic;
    signal GigEx_TxChanVal : std_logic_vector(2 downto 0);
    signal GigEx_TxDataVal : std_logic_vector(7 downto 0);
    signal GigEx_nRxFullVal : std_logic_vector(7 downto 0);

    signal nCLK : std_logic;
    signal RegGigEx_nRxP : std_logic;
    signal RegGigEx_nRxN : std_logic;
    signal RegGigEx_RxChanP : std_logic_vector(2 downto 0);
    signal RegGigEx_RxChanN : std_logic_vector(2 downto 0);
    signal RegGigEx_RxDataP : std_logic_vector(7 downto 0);
    signal RegGigEx_RxDataN : std_logic_vector(7 downto 0);
    signal RegGigEx_nTxFullP : std_logic_vector(7 downto 0);
    signal RegGigEx_nTxFullN : std_logic_vector(7 downto 0);
    signal User_nRxP : std_logic;
    signal User_nRxN : std_logic;
    signal User_RxChanP : std_logic_vector(2 downto 0);
    signal User_RxChanN : std_logic_vector(2 downto 0);
    signal User_RxDataP : std_logic_vector(7 downto 0);
    signal User_RxDataN : std_logic_vector(7 downto 0);
    signal User_nTxFullP : std_logic_vector(7 downto 0);
    signal User_nTxFullN : std_logic_vector(7 downto 0);
    signal User_nInterrupt : std_logic;

    attribute IOB : string;
    attribute IOB of TxCopyInst : label is "FORCE";
    attribute IOB of InterruptInst : label is "FORCE";

begin

    -- Output clock with DDR FF to give predictable timing
    nCLK <= not CLK;
    ClockOutInst : ODDR
        generic map (
            DDR_CLK_EDGE => "OPPOSITE_EDGE",
            INIT => '0',
            SRTYPE => "SYNC"
        )
        port map (
            Q => GigEx_Clk,
            C => CLK,
            CE => '1',
            D1 => '0',
            D2 => '1',
            R => '0',
            S => '0'
        );

    -- Data outputs
    process (CLK) begin
        if (CLK'event and CLK='1') then
            RegUser_nTx <= not UserTx;
            RegUser_TxChan <= UserTxChan;
            RegUser_TxData <= UserTxData;
            RegUser_nRxFull <= not UserRxFull;
        end if;
    end process;

    -- This makes the data/control change on the falling edge of the clock
    -- at the GigExpedite to ensure setup/hold times
    TxCopyInst : FDCE
        generic map (
            INIT => '1'
        )
        port map (
            Q => GigEx_nTxVal,
            C => CLK,
            CE => '1',
            D => RegUser_nTx,
            CLR => '0'
        );
    ChanOutCopy:
        for g in 0 to 2 generate
            attribute IOB of ChanOutCopyInst : label is "FORCE";
        begin
            ChanOutCopyInst : FDCE
                generic map (
                    INIT => '0'
                )
                port map (
                    Q => GigEx_TxChanVal(g),
                    C => CLK,
                    CE => '1',
                    D => RegUser_TxChan(g),
                    CLR => '0'
                );
        end generate;
    DataOutCopy:
        for g in 0 to 7 generate
            attribute IOB of DataOutCopyInst : label is "FORCE";
        begin
            DataOutCopyInst : FDCE
                generic map (
                    INIT => '0'
                )
                port map (
                    Q => GigEx_TxDataVal(g),
                    C => CLK,
                    CE => '1',
                    D => RegUser_TxData(g),
                    CLR => '0'
                );
        end generate;
    RxFullCopy:
        for g in 0 to 7 generate
            attribute IOB of RxFullCopyInst : label is "FORCE";
        begin
            RxFullCopyInst : FDCE
                generic map (
                    INIT => '0'
                )
                port map (
                    Q => GigEx_nRxFullVal(g),
                    C => CLK,
                    CE => '1',
                    D => RegUser_nRxFull(g),
                    CLR => '0'
                );
        end generate;

    GigEx_nTx <= GigEx_nTxVal;
    GigEx_TxChan <= GigEx_TxChanVal;
    GigEx_TxData <= GigEx_TxDataVal;
    GigEx_nRxFull <= GigEx_nRxFullVal;
    
    -- Read path
    -- Use DDR FF to get rising and falling edge registers
    nRxInInst : IDDR
        generic map (
            DDR_CLK_EDGE => "OPPOSITE_EDGE",
            INIT_Q1 => '1',
            INIT_Q2 => '1',
            SRTYPE => "SYNC"
        )
        port map (
            Q1 => RegGigEx_nRxP,
            Q2 => RegGigEx_nRxN,
            C => CLK,
            CE => '1',
            D => GigEx_nRx,
            R => '0',
            S => '0'
        );
        
    ChanInCopy:
        for g in 0 to 2 generate
        begin
            ChanInCopyInst : IDDR
                generic map (
                    DDR_CLK_EDGE => "OPPOSITE_EDGE",
                    INIT_Q1 => '0',
                    INIT_Q2 => '0',
                    SRTYPE => "SYNC"
                )
                port map (
                    Q1 => RegGigEx_RxChanP(g),
                    Q2 => RegGigEx_RxChanN(g),
                    C => CLK,
                    CE => '1',
                    D => GigEx_RxChan(g),
                    R => '0',
                    S => '0'
                );
        end generate;
    DataInCopy:
        for g in 0 to 7 generate
        begin
            DataInCopyInst : IDDR
                generic map (
                    DDR_CLK_EDGE => "OPPOSITE_EDGE",
                    INIT_Q1 => '0',
                    INIT_Q2 => '0',
                    SRTYPE => "SYNC"
                )
                port map (
                    Q1 => RegGigEx_RxDataP(g),
                    Q2 => RegGigEx_RxDataN(g),
                    C => CLK,
                    CE => '1',
                    D => GigEx_RxData(g),
                    R => '0',
                    S => '0'
                );
        end generate;
    nTxFullCopy:
        for g in 0 to 7 generate
        begin
            nTxFullCopyInst : IDDR
                generic map (
                    DDR_CLK_EDGE => "OPPOSITE_EDGE",
                    INIT_Q1 => '0',
                    INIT_Q2 => '0',
                    SRTYPE => "SYNC"
                )
                port map (
                    Q1 => RegGigEx_nTxFullP(g),
                    Q2 => RegGigEx_nTxFullN(g),
                    C => CLK,
                    CE => '1',
                    D => GigEx_nTxFull(g),
                    R => '0',
                    S => '0'
                );
        end generate;

    -- Re-register to user clock
    nRxPCopyInst : FD
        generic map ( INIT=>'1' )
        port map (
            Q => User_nRxP,
            C => CLK,
            D => RegGigEx_nRxP
        );
    nRxNCopyInst : FD
        generic map ( INIT=>'1' )
        port map (
            Q => User_nRxN,
            C => CLK,
            D => RegGigEx_nRxN
        );
    ChanInPCopy:
        for g in 0 to 2 generate
        begin
            ChanInPCopyInst : FD
                port map (
                    Q => User_RxChanP(g),
                    C => CLK,
                    D => RegGigEx_RxChanP(g)
                );
        end generate;
    ChanInNCopy:
        for g in 0 to 2 generate
        begin
            ChanInNCopyInst : FD
                port map (
                    Q => User_RxChanN(g),
                    C => CLK,
                    D => RegGigEx_RxChanN(g)
                );
        end generate;
    DataInPCopy:
        for g in 0 to 7 generate
        begin
            DataInPCopyInst : FD
                port map (
                    Q => User_RxDataP(g),
                    C => CLK,
                    D => RegGigEx_RxDataP(g)
                );
        end generate;
    DataInNCopy:
        for g in 0 to 7 generate
        begin
            DataInNCopyInst : FD
                port map (
                    Q => User_RxDataN(g),
                    C => CLK,
                    D => RegGigEx_RxDataN(g)
                );
        end generate;
    nTxFullPCopy:
        for g in 0 to 7 generate
        begin
            nTxFullPCopyInst : FD
                port map (
                    Q => User_nTxFullP(g),
                    C => CLK,
                    D => RegGigEx_nTxFullP(g)
                );
        end generate;
    nTxFullNCopy:
        for g in 0 to 7 generate
        begin
            nTxFullNCopyInst : FD
                port map (
                    Q => User_nTxFullN(g),
                    C => CLK,
                    D => RegGigEx_nTxFullN(g)
                );
        end generate;

    -- Select read data path on clock rate
    -- Since the delays to/from the GigExpedite are fixed, the read sample
    -- clock edge will change with the clock rate changing
    process (User_RxDataN, User_RxDataP, User_nRxN, User_nRxP, User_RxChanN, User_RxChanP,
             User_nTxFullN, User_nTxFullP) begin
        if (CLOCK_RATE<60000000) then
            UserRxData <= User_RxDataN;
            UserRxChan <= User_RxChanN;
            UserRx <= not User_nRxN;
            UserTxFull <= not User_nTxFullN;
        elsif (CLOCK_RATE<105000000) then
            UserRxData <= User_RxDataP;
            UserRxChan <= User_RxChanP;
            UserRx <= not User_nRxP;
            UserTxFull <= not User_nTxFullP;
        else
            UserRxData <= User_RxDataP;
            UserRxChan <= User_RxChanP;
            UserRx <= not User_nRxP;
            UserTxFull <= not User_nTxFullP;
        end if;
    end process;
		
    -- Register interrupt line from GigExpedite
    InterruptInst : FD
        port map (
            Q => User_nInterrupt,
            C => CLK,
            D => GigEx_nInt
        );
    UserInterrupt <= not User_nInterrupt;
    
end arch;
