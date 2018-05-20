library verilog;
use verilog.vl_types.all;
entity BIBUF_LVDS is
    port(
        Y               : out    vl_logic;
        PADP            : inout  vl_logic;
        PADN            : inout  vl_logic;
        D               : in     vl_logic;
        E               : in     vl_logic
    );
end BIBUF_LVDS;
