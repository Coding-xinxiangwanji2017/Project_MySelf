library verilog;
use verilog.vl_types.all;
entity INBUF_PCI is
    port(
        Y               : out    vl_logic;
        PAD             : in     vl_logic
    );
end INBUF_PCI;
