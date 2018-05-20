library verilog;
use verilog.vl_types.all;
entity CCC_SYNCB_GEN is
    port(
        VCO0            : in     vl_logic;
        FBIN            : in     vl_logic;
        LOCK            : in     vl_logic;
        RESET_N         : in     vl_logic;
        SWRESYNC        : in     vl_logic;
        FB_DIV          : in     vl_logic_vector(13 downto 0);
        CORE_LOCK       : out    vl_logic;
        RSTSYNC_N       : out    vl_logic_vector(3 downto 0);
        GPD0_G3STYLE_N  : in     vl_logic;
        GPD0_SRESETGENEN: in     vl_logic;
        GPD0_RESETGENEN : in     vl_logic;
        GPD1_G3STYLE_N  : in     vl_logic;
        GPD1_SRESETGENEN: in     vl_logic;
        GPD1_RESETGENEN : in     vl_logic;
        GPD2_G3STYLE_N  : in     vl_logic;
        GPD2_SRESETGENEN: in     vl_logic;
        GPD2_RESETGENEN : in     vl_logic;
        GPD3_G3STYLE_N  : in     vl_logic;
        GPD3_SRESETGENEN: in     vl_logic;
        GPD3_RESETGENEN : in     vl_logic
    );
end CCC_SYNCB_GEN;
