library verilog;
use verilog.vl_types.all;
entity OUTBUF_S_16 is
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic
    );
end OUTBUF_S_16;
