library verilog;
use verilog.vl_types.all;
entity OUTBUF_HSTL_I is
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic
    );
end OUTBUF_HSTL_I;
