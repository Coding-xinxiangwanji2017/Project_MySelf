library verilog;
use verilog.vl_types.all;
entity IO_TEST is
    port(
        D               : in     vl_logic;
        E               : in     vl_logic;
        Y               : out    vl_logic
    );
end IO_TEST;
