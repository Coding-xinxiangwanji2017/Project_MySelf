library verilog;
use verilog.vl_types.all;
entity SYSCTRL_RESET_STATUS is
    port(
        RESET_STATUS    : out    vl_logic
    );
end SYSCTRL_RESET_STATUS;
