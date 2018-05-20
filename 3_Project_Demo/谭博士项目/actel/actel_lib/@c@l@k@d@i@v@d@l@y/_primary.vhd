library verilog;
use verilog.vl_types.all;
entity CLKDIVDLY is
    generic(
        INTRINSIC_DELAY : integer := 2393;
        PROG_INIT_DELAY : integer := 535;
        PROG_STEP_INCREMENT: integer := 200
    );
    port(
        CLK             : in     vl_logic;
        RESET           : in     vl_logic;
        ODIVHALF        : in     vl_logic;
        ODIV0           : in     vl_logic;
        ODIV1           : in     vl_logic;
        ODIV2           : in     vl_logic;
        ODIV3           : in     vl_logic;
        ODIV4           : in     vl_logic;
        DLYGL0          : in     vl_logic;
        DLYGL1          : in     vl_logic;
        DLYGL2          : in     vl_logic;
        DLYGL3          : in     vl_logic;
        DLYGL4          : in     vl_logic;
        GL              : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INTRINSIC_DELAY : constant is 1;
    attribute mti_svvh_generic_type of PROG_INIT_DELAY : constant is 1;
    attribute mti_svvh_generic_type of PROG_STEP_INCREMENT : constant is 1;
end CLKDIVDLY;
