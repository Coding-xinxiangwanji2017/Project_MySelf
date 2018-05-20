library verilog;
use verilog.vl_types.all;
entity LIVE_FB_PROBES is
    port(
        PRBA            : out    vl_logic;
        PRBB            : out    vl_logic
    );
end LIVE_FB_PROBES;
