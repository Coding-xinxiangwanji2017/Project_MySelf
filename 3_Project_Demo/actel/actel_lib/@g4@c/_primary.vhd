library verilog;
use verilog.vl_types.all;
entity G4C is
    port(
        CLK_1MHZ_ENA    : out    vl_logic;
        CLK_50MHZ_ENA_FAB: out    vl_logic;
        CLK_XTAL_ENA    : out    vl_logic;
        FF_IN_PROGRESS_FAB: out    vl_logic;
        RAM_INIT_DONE_B : out    vl_logic;
        UJ_DRCAP        : out    vl_logic;
        UJ_DRSH         : out    vl_logic;
        UJ_DRUPD        : out    vl_logic;
        UJ_IR           : out    vl_logic_vector(7 downto 0);
        UJ_RSTB         : out    vl_logic;
        UJ_TCK          : out    vl_logic;
        UJ_TDI          : out    vl_logic;
        US_ASICRESET_B  : out    vl_logic;
        US_ASICTEST     : out    vl_logic;
        US_FF_ACK       : out    vl_logic;
        US_POR_B        : out    vl_logic;
        US_RESTORE      : out    vl_logic;
        US_TAMPER       : out    vl_logic_vector(15 downto 0);
        US_WE           : out    vl_logic;
        CALIB_CLKS      : in     vl_logic_vector(5 downto 0);
        OSC_XTAL_MODE   : in     vl_logic_vector(1 downto 0);
        UJ_TDO          : in     vl_logic;
        US_IRQ_B        : in     vl_logic_vector(6 downto 0);
        US_RC1MHZ_OFF   : in     vl_logic;
        US_RC50MHZ_OFF  : in     vl_logic;
        US_RESPONSE_B   : in     vl_logic_vector(7 downto 0);
        US_SPARE_IN     : in     vl_logic_vector(16 downto 0);
        US_XTAL_OFF     : in     vl_logic;
        TDI             : in     vl_logic;
        TMS             : in     vl_logic;
        TCK             : in     vl_logic;
        TRSTB           : in     vl_logic;
        TDO             : out    vl_logic
    );
end G4C;
