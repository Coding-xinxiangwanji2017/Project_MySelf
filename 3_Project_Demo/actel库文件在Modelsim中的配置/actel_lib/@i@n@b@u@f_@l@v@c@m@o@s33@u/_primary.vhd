library verilog;
use verilog.vl_types.all;
entity INBUF_LVCMOS33U is
    port(
        Y               : out    vl_logic;
        PAD             : in     vl_logic
    );
end INBUF_LVCMOS33U;
