library verilog;
use verilog.vl_types.all;
entity OUTBUF_GTL25 is
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic
    );
end OUTBUF_GTL25;
