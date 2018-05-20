library verilog;
use verilog.vl_types.all;
entity MSS_LPXTLOSC is
    port(
        LPXIN           : in     vl_logic;
        CLKOUT          : out    vl_logic
    );
end MSS_LPXTLOSC;
