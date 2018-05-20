library verilog;
use verilog.vl_types.all;
entity MSS_XTLOSC is
    port(
        XTL             : in     vl_logic;
        CLKOUT          : out    vl_logic
    );
end MSS_XTLOSC;
