library verilog;
use verilog.vl_types.all;
entity CLKDIV_SDF is
    port(
        CLK             : in     vl_logic;
        RESET           : in     vl_logic;
        ODIVHALF        : in     vl_logic;
        ODIV0           : in     vl_logic;
        ODIV1           : in     vl_logic;
        ODIV2           : in     vl_logic;
        ODIV3           : in     vl_logic;
        ODIV4           : in     vl_logic;
        GL              : out    vl_logic
    );
end CLKDIV_SDF;
