library verilog;
use verilog.vl_types.all;
entity PLL_DLY_SDF is
    generic(
        VCOFREQUENCY    : real    := 0.000000
    );
    port(
        GLAIN           : in     vl_logic;
        GLBIN           : in     vl_logic;
        GLCIN           : in     vl_logic;
        YBIN            : in     vl_logic;
        YCIN            : in     vl_logic;
        VCOIN           : in     vl_logic;
        LOCKIN          : in     vl_logic;
        EXTFBIN         : in     vl_logic;
        GLA             : out    vl_logic;
        GLB             : out    vl_logic;
        GLC             : out    vl_logic;
        YB              : out    vl_logic;
        YC              : out    vl_logic;
        PLLOUT          : out    vl_logic;
        LOCK            : out    vl_logic;
        EXTFBOUT        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of VCOFREQUENCY : constant is 1;
end PLL_DLY_SDF;
