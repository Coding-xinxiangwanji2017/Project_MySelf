library verilog;
use verilog.vl_types.all;
entity RAM1K18 is
    generic(
        TC2CWWH         : integer := 0;
        TC2CRWH         : integer := 0;
        TC2CWRH         : integer := 0;
        TPD             : real    := 0.001000;
        MEMORYFILE      : string  := "";
        WARNING_MSGS_ON : integer := 1;
        NO_COLLISION    : integer := 0
    );
    port(
        A_DOUT          : out    vl_logic_vector(17 downto 0);
        B_DOUT          : out    vl_logic_vector(17 downto 0);
        BUSY            : out    vl_logic;
        A_CLK           : in     vl_logic;
        A_ARST_N        : in     vl_logic;
        A_BLK           : in     vl_logic_vector(2 downto 0);
        A_DIN           : in     vl_logic_vector(17 downto 0);
        A_ADDR          : in     vl_logic_vector(13 downto 0);
        A_WEN           : in     vl_logic_vector(1 downto 0);
        A_DOUT_CLK      : in     vl_logic;
        A_DOUT_EN       : in     vl_logic;
        A_DOUT_ARST_N   : in     vl_logic;
        A_DOUT_SRST_N   : in     vl_logic;
        A_DOUT_LAT      : in     vl_logic;
        A_WIDTH         : in     vl_logic_vector(2 downto 0);
        A_WMODE         : in     vl_logic;
        A_EN            : in     vl_logic;
        B_CLK           : in     vl_logic;
        B_ARST_N        : in     vl_logic;
        B_BLK           : in     vl_logic_vector(2 downto 0);
        B_DIN           : in     vl_logic_vector(17 downto 0);
        B_ADDR          : in     vl_logic_vector(13 downto 0);
        B_WEN           : in     vl_logic_vector(1 downto 0);
        B_DOUT_CLK      : in     vl_logic;
        B_DOUT_EN       : in     vl_logic;
        B_DOUT_ARST_N   : in     vl_logic;
        B_DOUT_SRST_N   : in     vl_logic;
        B_DOUT_LAT      : in     vl_logic;
        B_WIDTH         : in     vl_logic_vector(2 downto 0);
        B_WMODE         : in     vl_logic;
        B_EN            : in     vl_logic;
        SII_LOCK        : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of TC2CWWH : constant is 1;
    attribute mti_svvh_generic_type of TC2CRWH : constant is 1;
    attribute mti_svvh_generic_type of TC2CWRH : constant is 1;
    attribute mti_svvh_generic_type of TPD : constant is 1;
    attribute mti_svvh_generic_type of MEMORYFILE : constant is 1;
    attribute mti_svvh_generic_type of WARNING_MSGS_ON : constant is 1;
    attribute mti_svvh_generic_type of NO_COLLISION : constant is 1;
end RAM1K18;
