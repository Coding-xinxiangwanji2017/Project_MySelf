library verilog;
use verilog.vl_types.all;
entity MX2C is
    port(
        Y               : out    vl_logic;
        A               : in     vl_logic;
        S               : in     vl_logic;
        B               : in     vl_logic
    );
end MX2C;
