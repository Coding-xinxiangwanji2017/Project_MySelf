library verilog;
use verilog.vl_types.all;
entity IOPADN_IN is
    port(
        PAD_P           : in     vl_logic;
        N2POUT_P        : out    vl_logic
    );
end IOPADN_IN;
