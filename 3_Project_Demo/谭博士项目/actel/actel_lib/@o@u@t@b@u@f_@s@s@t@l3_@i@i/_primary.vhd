library verilog;
use verilog.vl_types.all;
entity OUTBUF_SSTL3_II is
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic
    );
end OUTBUF_SSTL3_II;
