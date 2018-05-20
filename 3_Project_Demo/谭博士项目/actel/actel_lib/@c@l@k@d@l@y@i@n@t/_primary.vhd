library verilog;
use verilog.vl_types.all;
entity CLKDLYINT is
    generic(
        t_rise          : integer := 0;
        t_fall          : integer := 0
    );
    port(
        CLK             : in     vl_logic;
        DLYGL0          : in     vl_logic;
        DLYGL1          : in     vl_logic;
        DLYGL2          : in     vl_logic;
        DLYGL3          : in     vl_logic;
        DLYGL4          : in     vl_logic;
        GL              : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of t_rise : constant is 1;
    attribute mti_svvh_generic_type of t_fall : constant is 1;
end CLKDLYINT;
