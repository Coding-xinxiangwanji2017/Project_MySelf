library verilog;
use verilog.vl_types.all;
entity CCC_PLL is
    generic(
        TPD             : real    := 0.000000e+000;
        FB_MULTIPLIER   : integer := 1;
        VCOFREQUENCY    : real    := 0.000000
    );
    port(
        CLKIN           : in     vl_logic;
        FBIN            : in     vl_logic;
        BYPASS          : in     vl_logic;
        RESET           : in     vl_logic;
        POWERDOWN       : in     vl_logic;
        SSMD            : in     vl_logic_vector(1 downto 0);
        SSMF            : in     vl_logic_vector(4 downto 0);
        SSE             : in     vl_logic;
        CLKDIV          : in     vl_logic_vector(5 downto 0);
        FBDIV           : in     vl_logic_vector(9 downto 0);
        VCODIV          : in     vl_logic_vector(2 downto 0);
        FBSEL           : in     vl_logic;
        MODE_32K        : in     vl_logic;
        PLL_RANGE       : in     vl_logic_vector(3 downto 0);
        MODE_1V2        : in     vl_logic;
        MODE_3V3        : in     vl_logic;
        LOCKWIN         : in     vl_logic_vector(2 downto 0);
        LOCKCNT         : in     vl_logic_vector(3 downto 0);
        LOCK            : out    vl_logic;
        VCO0            : out    vl_logic;
        VCO45           : out    vl_logic;
        VCO90           : out    vl_logic;
        VCO135          : out    vl_logic;
        VCO180          : out    vl_logic;
        VCO225          : out    vl_logic;
        VCO270          : out    vl_logic;
        VCO315          : out    vl_logic;
        divq_reset      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of TPD : constant is 2;
    attribute mti_svvh_generic_type of FB_MULTIPLIER : constant is 2;
    attribute mti_svvh_generic_type of VCOFREQUENCY : constant is 1;
end CCC_PLL;
