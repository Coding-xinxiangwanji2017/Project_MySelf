library verilog;
use verilog.vl_types.all;
entity CLKDLY_SDF is
    port(
        CLK             : in     vl_logic;
        DLYGL0          : in     vl_logic;
        DLYGL1          : in     vl_logic;
        DLYGL2          : in     vl_logic;
        DLYGL3          : in     vl_logic;
        DLYGL4          : in     vl_logic;
        GL              : out    vl_logic
    );
end CLKDLY_SDF;
