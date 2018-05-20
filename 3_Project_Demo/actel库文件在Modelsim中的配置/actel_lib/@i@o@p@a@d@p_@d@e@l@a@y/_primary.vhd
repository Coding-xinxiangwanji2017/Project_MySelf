library verilog;
use verilog.vl_types.all;
entity IOPADP_DELAY is
    port(
        IOUT_P          : out    vl_logic;
        IOUT_IN         : in     vl_logic
    );
end IOPADP_DELAY;
