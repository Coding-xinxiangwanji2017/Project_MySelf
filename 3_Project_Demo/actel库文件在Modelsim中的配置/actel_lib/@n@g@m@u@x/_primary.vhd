library verilog;
use verilog.vl_types.all;
entity NGMUX is
    port(
        GL              : out    vl_logic;
        CLK0            : in     vl_logic;
        CLK1            : in     vl_logic;
        S               : in     vl_logic
    );
end NGMUX;
