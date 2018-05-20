library verilog;
use verilog.vl_types.all;
entity RCOSC_1MHZ_FAB is
    port(
        CLKOUT          : out    vl_logic;
        A               : in     vl_logic
    );
end RCOSC_1MHZ_FAB;
