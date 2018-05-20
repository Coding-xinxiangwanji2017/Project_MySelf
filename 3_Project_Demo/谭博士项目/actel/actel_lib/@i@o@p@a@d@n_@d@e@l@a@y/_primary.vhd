library verilog;
use verilog.vl_types.all;
entity IOPADN_DELAY is
    port(
        N2POUT_P        : out    vl_logic;
        IOUT_IN         : in     vl_logic
    );
end IOPADN_DELAY;
