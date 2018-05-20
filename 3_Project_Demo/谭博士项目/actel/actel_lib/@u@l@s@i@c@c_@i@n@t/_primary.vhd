library verilog;
use verilog.vl_types.all;
entity ULSICC_INT is
    port(
        USTDBY          : in     vl_logic;
        LPENA           : in     vl_logic
    );
end ULSICC_INT;
