library verilog;
use verilog.vl_types.all;
entity OUTBUF_F_8 is
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic
    );
end OUTBUF_F_8;
