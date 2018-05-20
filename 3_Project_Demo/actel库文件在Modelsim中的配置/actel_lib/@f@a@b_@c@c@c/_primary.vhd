library verilog;
use verilog.vl_types.all;
entity FAB_CCC is
    generic(
        VCOFREQUENCY    : real    := 0.000000;
        f_CLKA_LOCK     : integer := 3;
        CLKA_TO_REF_DELAY: integer := 0;
        EMULATED_SYSTEM_DELAY: integer := 2028;
        IN_DIV_DELAY    : integer := 0;
        OUT_UDIV_DELAY  : integer := 0;
        OUT_VDIV_DELAY  : integer := 0;
        OUT_WDIV_DELAY  : integer := 0;
        MUX_DELAY       : integer := 0;
        IN_DELAY_BYP1   : integer := 0;
        BYP_GLAMUX_DELAY: integer := 0;
        BYP_GLBMUX_DELAY: integer := 0;
        BYP_GLCMUX_DELAY: integer := 0;
        GLA_DRVR_DELAY  : integer := 0;
        GLB_DRVR_DELAY  : integer := 0;
        GLC_DRVR_DELAY  : integer := 0;
        Y_DRVR_DELAY    : integer := 0;
        FB_MUX_DELAY    : integer := 0;
        BYP0_CLK_GL     : integer := 0;
        X_MUX_DELAY     : integer := 0;
        FIN_LOCK_DELAY  : integer := 0;
        LOCK_OUT_DELAY  : integer := 0;
        t_rise          : integer := 0;
        t_fall          : integer := 0;
        PROG_STEP_INCREMENT: integer := 200;
        PROG_INIT_DELAY : integer := 535;
        INIT_DELAY      : integer := 65;
        NGMUX_GLA       : integer := 0;
        NGMUX_GLC       : integer := 0;
        NGMUX_GLMUXINT  : integer := 0
    );
    port(
        CLKA            : in     vl_logic;
        EXTFB           : in     vl_logic;
        PLLEN           : in     vl_logic;
        GLA             : out    vl_logic;
        LOCK            : out    vl_logic;
        CLKB            : in     vl_logic;
        GLB             : out    vl_logic;
        YB              : out    vl_logic;
        CLKC            : in     vl_logic;
        GLC             : out    vl_logic;
        YC              : out    vl_logic;
        OADIV           : in     vl_logic_vector(4 downto 0);
        OADIVHALF       : in     vl_logic;
        OADIVRST        : in     vl_logic;
        OAMUX           : in     vl_logic_vector(2 downto 0);
        BYPASSA         : in     vl_logic;
        DLYGLA          : in     vl_logic_vector(4 downto 0);
        DLYGLAFAB       : in     vl_logic_vector(4 downto 0);
        OBDIV           : in     vl_logic_vector(4 downto 0);
        OBDIVHALF       : in     vl_logic;
        OBDIVRST        : in     vl_logic;
        OBMUX           : in     vl_logic_vector(2 downto 0);
        BYPASSB         : in     vl_logic;
        DLYGLB          : in     vl_logic_vector(4 downto 0);
        OCDIV           : in     vl_logic_vector(4 downto 0);
        OCDIVHALF       : in     vl_logic;
        OCDIVRST        : in     vl_logic;
        OCMUX           : in     vl_logic_vector(2 downto 0);
        BYPASSC         : in     vl_logic;
        DLYGLC          : in     vl_logic_vector(4 downto 0);
        FINDIV          : in     vl_logic_vector(6 downto 0);
        FBDIV           : in     vl_logic_vector(6 downto 0);
        FBDLY           : in     vl_logic_vector(4 downto 0);
        FBSEL           : in     vl_logic_vector(1 downto 0);
        XDLYSEL         : in     vl_logic;
        VCOSEL          : in     vl_logic_vector(2 downto 0);
        GLMUXSEL        : in     vl_logic_vector(1 downto 0);
        GLMUXCFG        : in     vl_logic_vector(1 downto 0);
        GLMUXINT        : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of VCOFREQUENCY : constant is 1;
    attribute mti_svvh_generic_type of f_CLKA_LOCK : constant is 1;
    attribute mti_svvh_generic_type of CLKA_TO_REF_DELAY : constant is 1;
    attribute mti_svvh_generic_type of EMULATED_SYSTEM_DELAY : constant is 1;
    attribute mti_svvh_generic_type of IN_DIV_DELAY : constant is 1;
    attribute mti_svvh_generic_type of OUT_UDIV_DELAY : constant is 1;
    attribute mti_svvh_generic_type of OUT_VDIV_DELAY : constant is 1;
    attribute mti_svvh_generic_type of OUT_WDIV_DELAY : constant is 1;
    attribute mti_svvh_generic_type of MUX_DELAY : constant is 1;
    attribute mti_svvh_generic_type of IN_DELAY_BYP1 : constant is 1;
    attribute mti_svvh_generic_type of BYP_GLAMUX_DELAY : constant is 1;
    attribute mti_svvh_generic_type of BYP_GLBMUX_DELAY : constant is 1;
    attribute mti_svvh_generic_type of BYP_GLCMUX_DELAY : constant is 1;
    attribute mti_svvh_generic_type of GLA_DRVR_DELAY : constant is 1;
    attribute mti_svvh_generic_type of GLB_DRVR_DELAY : constant is 1;
    attribute mti_svvh_generic_type of GLC_DRVR_DELAY : constant is 1;
    attribute mti_svvh_generic_type of Y_DRVR_DELAY : constant is 1;
    attribute mti_svvh_generic_type of FB_MUX_DELAY : constant is 1;
    attribute mti_svvh_generic_type of BYP0_CLK_GL : constant is 1;
    attribute mti_svvh_generic_type of X_MUX_DELAY : constant is 1;
    attribute mti_svvh_generic_type of FIN_LOCK_DELAY : constant is 1;
    attribute mti_svvh_generic_type of LOCK_OUT_DELAY : constant is 1;
    attribute mti_svvh_generic_type of t_rise : constant is 1;
    attribute mti_svvh_generic_type of t_fall : constant is 1;
    attribute mti_svvh_generic_type of PROG_STEP_INCREMENT : constant is 1;
    attribute mti_svvh_generic_type of PROG_INIT_DELAY : constant is 1;
    attribute mti_svvh_generic_type of INIT_DELAY : constant is 1;
    attribute mti_svvh_generic_type of NGMUX_GLA : constant is 1;
    attribute mti_svvh_generic_type of NGMUX_GLC : constant is 1;
    attribute mti_svvh_generic_type of NGMUX_GLMUXINT : constant is 1;
end FAB_CCC;
