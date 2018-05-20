library verilog;
use verilog.vl_types.all;
entity OUTBUF_A is
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic
    );
end OUTBUF_A;
