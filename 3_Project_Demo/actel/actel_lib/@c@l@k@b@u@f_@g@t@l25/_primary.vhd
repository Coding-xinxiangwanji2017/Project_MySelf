library verilog;
use verilog.vl_types.all;
entity CLKBUF_GTL25 is
    port(
        Y               : out    vl_logic;
        PAD             : in     vl_logic
    );
end CLKBUF_GTL25;
