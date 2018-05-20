library verilog;
use verilog.vl_types.all;
entity CLKBUF_LVCMOS5 is
    port(
        Y               : out    vl_logic;
        PAD             : in     vl_logic
    );
end CLKBUF_LVCMOS5;
