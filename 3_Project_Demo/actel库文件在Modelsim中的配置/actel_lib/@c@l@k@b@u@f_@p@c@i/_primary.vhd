library verilog;
use verilog.vl_types.all;
entity CLKBUF_PCI is
    port(
        Y               : out    vl_logic;
        PAD             : in     vl_logic
    );
end CLKBUF_PCI;
