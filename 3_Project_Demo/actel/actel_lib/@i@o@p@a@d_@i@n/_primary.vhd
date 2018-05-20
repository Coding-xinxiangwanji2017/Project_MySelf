library verilog;
use verilog.vl_types.all;
entity IOPAD_IN is
    port(
        Y               : out    vl_logic;
        PAD             : in     vl_logic
    );
end IOPAD_IN;
