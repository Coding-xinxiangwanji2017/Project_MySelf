library verilog;
use verilog.vl_types.all;
entity PLL_TIMING_V2 is
    generic(
        CLKA_TO_REF_DELAY: integer := 900;
        EMULATED_SYSTEM_DELAY: integer := 5700;
        IN_DIV_DELAY    : integer := 850;
        OUT_DIV_DELAY   : integer := 1510;
        MUX_DELAY       : integer := 1700;
        IN_DELAY_BYP1   : integer := 1523;
        BYP_MUX_DELAY   : integer := 250;
        GL_DRVR_DELAY   : integer := 550;
        Y_DRVR_DELAY    : integer := 0;
        FB_MUX_DELAY    : integer := 1420;
        BYP0_CLK_GL     : integer := 1360;
        X_MUX_DELAY     : integer := 160;
        FIN_LOCK_DELAY  : integer := 2050;
        LOCK_OUT_DELAY  : integer := 820;
        PROG_STEP_INCREMENT: integer := 580;
        PROG_INIT_DELAY : integer := 2300
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLKA_TO_REF_DELAY : constant is 1;
    attribute mti_svvh_generic_type of EMULATED_SYSTEM_DELAY : constant is 1;
    attribute mti_svvh_generic_type of IN_DIV_DELAY : constant is 1;
    attribute mti_svvh_generic_type of OUT_DIV_DELAY : constant is 1;
    attribute mti_svvh_generic_type of MUX_DELAY : constant is 1;
    attribute mti_svvh_generic_type of IN_DELAY_BYP1 : constant is 1;
    attribute mti_svvh_generic_type of BYP_MUX_DELAY : constant is 1;
    attribute mti_svvh_generic_type of GL_DRVR_DELAY : constant is 1;
    attribute mti_svvh_generic_type of Y_DRVR_DELAY : constant is 1;
    attribute mti_svvh_generic_type of FB_MUX_DELAY : constant is 1;
    attribute mti_svvh_generic_type of BYP0_CLK_GL : constant is 1;
    attribute mti_svvh_generic_type of X_MUX_DELAY : constant is 1;
    attribute mti_svvh_generic_type of FIN_LOCK_DELAY : constant is 1;
    attribute mti_svvh_generic_type of LOCK_OUT_DELAY : constant is 1;
    attribute mti_svvh_generic_type of PROG_STEP_INCREMENT : constant is 1;
    attribute mti_svvh_generic_type of PROG_INIT_DELAY : constant is 1;
end PLL_TIMING_V2;
