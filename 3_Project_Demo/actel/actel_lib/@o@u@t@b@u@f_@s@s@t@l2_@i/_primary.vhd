library verilog;
use verilog.vl_types.all;
entity OUTBUF_SSTL2_I is
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic
    );
end OUTBUF_SSTL2_I;
