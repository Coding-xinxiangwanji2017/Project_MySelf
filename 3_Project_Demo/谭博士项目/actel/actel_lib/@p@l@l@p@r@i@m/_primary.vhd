library verilog;
use verilog.vl_types.all;
entity PLLPRIM is
    generic(
        VCOFREQUENCY    : real    := 0.000000;
        f_CLKA_LOCK     : integer := 3;
        CLKA_TO_REF_DELAY: integer := 147;
        EMULATED_SYSTEM_DELAY: integer := 2028;
        IN_DIV_DELAY    : integer := 266;
        OUT_UDIV_DELAY  : integer := 662;
        OUT_VDIV_DELAY  : integer := 887;
        OUT_WDIV_DELAY  : integer := 887;
        MUX_DELAY       : integer := 500;
        IN_DELAY_BYP1   : integer := 647;
        BYP_GLAMUX_DELAY: integer := 20;
        BYP_GLBMUX_DELAY: integer := 30;
        BYP_GLCMUX_DELAY: integer := 30;
        GLA_DRVR_DELAY  : integer := 35;
        GLB_DRVR_DELAY  : integer := 47;
        GLC_DRVR_DELAY  : integer := 47;
        Y_DRVR_DELAY    : integer := 0;
        FB_MUX_DELAY    : integer := 125;
        BYP0_CLK_GL     : integer := 202;
        X_MUX_DELAY     : integer := 528;
        FIN_LOCK_DELAY  : integer := 300;
        LOCK_OUT_DELAY  : integer := 120;
        t_rise          : integer := 0;
        t_fall          : integer := 0;
        PROG_STEP_INCREMENT: integer := 200;
        PROG_INIT_DELAY : integer := 535;
        INIT_DELAY      : integer := 65;
        NGMUX_GLA       : integer := 0;
        NGMUX_GLC       : integer := 30;
        NGMUX_GLMUXINT  : integer := 27
    );
    port(
        DYNSYNC         : in     vl_logic;
        CLKA            : in     vl_logic;
        EXTFB           : in     vl_logic;
        POWERDOWN       : in     vl_logic;
        CLKB            : in     vl_logic;
        CLKC            : in     vl_logic;
        OADIVRST        : in     vl_logic;
        OADIVHALF       : in     vl_logic;
        OADIV0          : in     vl_logic;
        OADIV1          : in     vl_logic;
        OADIV2          : in     vl_logic;
        OADIV3          : in     vl_logic;
        OADIV4          : in     vl_logic;
        OAMUX0          : in     vl_logic;
        OAMUX1          : in     vl_logic;
        OAMUX2          : in     vl_logic;
        BYPASSA         : in     vl_logic;
        DLYGLA0         : in     vl_logic;
        DLYGLA1         : in     vl_logic;
        DLYGLA2         : in     vl_logic;
        DLYGLA3         : in     vl_logic;
        DLYGLA4         : in     vl_logic;
        DLYGLADSS0      : in     vl_logic;
        DLYGLADSS1      : in     vl_logic;
        DLYGLADSS2      : in     vl_logic;
        DLYGLADSS3      : in     vl_logic;
        DLYGLADSS4      : in     vl_logic;
        DLYGLACORE0     : in     vl_logic;
        DLYGLACORE1     : in     vl_logic;
        DLYGLACORE2     : in     vl_logic;
        DLYGLACORE3     : in     vl_logic;
        DLYGLACORE4     : in     vl_logic;
        OBDIVRST        : in     vl_logic;
        OBDIVHALF       : in     vl_logic;
        OBDIV0          : in     vl_logic;
        OBDIV1          : in     vl_logic;
        OBDIV2          : in     vl_logic;
        OBDIV3          : in     vl_logic;
        OBDIV4          : in     vl_logic;
        OBMUX0          : in     vl_logic;
        OBMUX1          : in     vl_logic;
        OBMUX2          : in     vl_logic;
        BYPASSB         : in     vl_logic;
        DLYGLB0         : in     vl_logic;
        DLYGLB1         : in     vl_logic;
        DLYGLB2         : in     vl_logic;
        DLYGLB3         : in     vl_logic;
        DLYGLB4         : in     vl_logic;
        OCDIVRST        : in     vl_logic;
        OCDIVHALF       : in     vl_logic;
        OCDIV0          : in     vl_logic;
        OCDIV1          : in     vl_logic;
        OCDIV2          : in     vl_logic;
        OCDIV3          : in     vl_logic;
        OCDIV4          : in     vl_logic;
        OCMUX0          : in     vl_logic;
        OCMUX1          : in     vl_logic;
        OCMUX2          : in     vl_logic;
        BYPASSC         : in     vl_logic;
        DLYGLC0         : in     vl_logic;
        DLYGLC1         : in     vl_logic;
        DLYGLC2         : in     vl_logic;
        DLYGLC3         : in     vl_logic;
        DLYGLC4         : in     vl_logic;
        FINDIV0         : in     vl_logic;
        FINDIV1         : in     vl_logic;
        FINDIV2         : in     vl_logic;
        FINDIV3         : in     vl_logic;
        FINDIV4         : in     vl_logic;
        FINDIV5         : in     vl_logic;
        FINDIV6         : in     vl_logic;
        FBDIV0          : in     vl_logic;
        FBDIV1          : in     vl_logic;
        FBDIV2          : in     vl_logic;
        FBDIV3          : in     vl_logic;
        FBDIV4          : in     vl_logic;
        FBDIV5          : in     vl_logic;
        FBDIV6          : in     vl_logic;
        FBDLY0          : in     vl_logic;
        FBDLY1          : in     vl_logic;
        FBDLY2          : in     vl_logic;
        FBDLY3          : in     vl_logic;
        FBDLY4          : in     vl_logic;
        FBSEL0          : in     vl_logic;
        FBSEL1          : in     vl_logic;
        XDLYSEL         : in     vl_logic;
        GLA             : out    vl_logic;
        GLADSS          : out    vl_logic;
        LOCK            : out    vl_logic;
        GLB             : out    vl_logic;
        YB              : out    vl_logic;
        GLC             : out    vl_logic;
        MACCLK          : out    vl_logic;
        YC              : out    vl_logic;
        GLMUXSEL        : in     vl_logic;
        GLMUXCFG        : in     vl_logic;
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
end PLLPRIM;
