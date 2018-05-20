library verilog;
use verilog.vl_types.all;
entity XTLOSC_FAB is
    port(
        CLKOUT          : out    vl_logic;
        A               : in     vl_logic
    );
end XTLOSC_FAB;
