library verilog;
use verilog.vl_types.all;
entity CLKBUF_SSTL3_I is
    port(
        Y               : out    vl_logic;
        PAD             : in     vl_logic
    );
end CLKBUF_SSTL3_I;
