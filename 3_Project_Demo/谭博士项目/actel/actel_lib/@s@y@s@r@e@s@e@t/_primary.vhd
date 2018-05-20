library verilog;
use verilog.vl_types.all;
entity SYSRESET is
    port(
        DEVRST_N        : in     vl_logic;
        POWER_ON_RESET_N: out    vl_logic
    );
end SYSRESET;
