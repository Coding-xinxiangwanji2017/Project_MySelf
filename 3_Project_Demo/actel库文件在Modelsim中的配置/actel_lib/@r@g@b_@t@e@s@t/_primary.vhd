library verilog;
use verilog.vl_types.all;
entity RGB_TEST is
    port(
        A               : in     vl_logic;
        EN              : in     vl_logic;
        YL              : out    vl_logic;
        YR              : out    vl_logic
    );
end RGB_TEST;
