library verilog;
use verilog.vl_types.all;
entity RAM64x18 is
    generic(
        MEMORYFILE      : string  := "";
        WARNING_MSGS_ON : integer := 1;
        NO_COLLISION    : integer := 0
    );
    port(
        A_DOUT          : out    vl_logic_vector(17 downto 0);
        B_DOUT          : out    vl_logic_vector(17 downto 0);
        BUSY            : out    vl_logic;
        A_ADDR_CLK      : in     vl_logic;
        A_ADDR_EN       : in     vl_logic;
        A_ADDR_LAT      : in     vl_logic;
        A_ADDR_ARST_N   : in     vl_logic;
        A_ADDR_SRST_N   : in     vl_logic;
        A_DOUT_CLK      : in     vl_logic;
        A_DOUT_EN       : in     vl_logic;
        A_DOUT_LAT      : in     vl_logic;
        A_DOUT_ARST_N   : in     vl_logic;
        A_DOUT_SRST_N   : in     vl_logic;
        A_ADDR          : in     vl_logic_vector(9 downto 0);
        A_WIDTH         : in     vl_logic_vector(2 downto 0);
        A_BLK           : in     vl_logic_vector(1 downto 0);
        A_EN            : in     vl_logic;
        B_ADDR_CLK      : in     vl_logic;
        B_ADDR_EN       : in     vl_logic;
        B_ADDR_LAT      : in     vl_logic;
        B_ADDR_ARST_N   : in     vl_logic;
        B_ADDR_SRST_N   : in     vl_logic;
        B_DOUT_CLK      : in     vl_logic;
        B_DOUT_EN       : in     vl_logic;
        B_DOUT_LAT      : in     vl_logic;
        B_DOUT_ARST_N   : in     vl_logic;
        B_DOUT_SRST_N   : in     vl_logic;
        B_ADDR          : in     vl_logic_vector(9 downto 0);
        B_WIDTH         : in     vl_logic_vector(2 downto 0);
        B_BLK           : in     vl_logic_vector(1 downto 0);
        B_EN            : in     vl_logic;
        C_CLK           : in     vl_logic;
        C_ADDR          : in     vl_logic_vector(9 downto 0);
        C_DIN           : in     vl_logic_vector(17 downto 0);
        C_WEN           : in     vl_logic;
        C_BLK           : in     vl_logic_vector(1 downto 0);
        C_WIDTH         : in     vl_logic_vector(2 downto 0);
        C_EN            : in     vl_logic;
        SII_LOCK        : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MEMORYFILE : constant is 1;
    attribute mti_svvh_generic_type of WARNING_MSGS_ON : constant is 1;
    attribute mti_svvh_generic_type of NO_COLLISION : constant is 1;
end RAM64x18;
