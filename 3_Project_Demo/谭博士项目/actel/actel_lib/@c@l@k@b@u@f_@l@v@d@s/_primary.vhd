library verilog;
use verilog.vl_types.all;
entity CLKBUF_LVDS is
    port(
        PADP            : in     vl_logic;
        PADN            : in     vl_logic;
        Y               : out    vl_logic
    );
end CLKBUF_LVDS;
