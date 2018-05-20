library verilog;
use verilog.vl_types.all;
entity ULSICC_AUTH is
    port(
        AUTHEN          : in     vl_logic;
        LSICC           : in     vl_logic
    );
end ULSICC_AUTH;
