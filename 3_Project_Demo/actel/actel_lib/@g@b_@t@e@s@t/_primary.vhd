library verilog;
use verilog.vl_types.all;
entity GB_TEST is
    port(
        A               : in     vl_logic;
        EN              : in     vl_logic;
        YN              : out    vl_logic;
        YS              : out    vl_logic
    );
end GB_TEST;
