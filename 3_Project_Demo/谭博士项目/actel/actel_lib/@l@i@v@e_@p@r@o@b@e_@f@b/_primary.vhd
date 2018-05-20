library verilog;
use verilog.vl_types.all;
entity LIVE_PROBE_FB is
    port(
        PROBE_A         : out    vl_logic;
        PROBE_B         : out    vl_logic
    );
end LIVE_PROBE_FB;
