library verilog;
use verilog.vl_types.all;
entity SIMBUF is
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic
    );
end SIMBUF;
