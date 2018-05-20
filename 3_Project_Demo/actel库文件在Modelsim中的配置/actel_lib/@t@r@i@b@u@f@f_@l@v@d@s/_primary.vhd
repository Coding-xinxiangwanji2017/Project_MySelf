library verilog;
use verilog.vl_types.all;
entity TRIBUFF_LVDS is
    port(
        PADP            : out    vl_logic;
        PADN            : out    vl_logic;
        D               : in     vl_logic;
        E               : in     vl_logic
    );
end TRIBUFF_LVDS;
