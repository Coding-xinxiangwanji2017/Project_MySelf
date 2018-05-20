library verilog;
use verilog.vl_types.all;
entity OUTBUF_LVDS is
    port(
        D               : in     vl_logic;
        PADP            : out    vl_logic;
        PADN            : out    vl_logic
    );
end OUTBUF_LVDS;
