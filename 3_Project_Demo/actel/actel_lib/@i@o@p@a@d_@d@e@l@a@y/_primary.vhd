library verilog;
use verilog.vl_types.all;
entity IOPAD_DELAY is
    port(
        IOUT_IN         : in     vl_logic;
        IOUT_P          : out    vl_logic
    );
end IOPAD_DELAY;
