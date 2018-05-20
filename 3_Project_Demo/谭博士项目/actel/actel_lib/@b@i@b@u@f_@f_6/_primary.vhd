library verilog;
use verilog.vl_types.all;
entity BIBUF_F_6 is
    port(
        Y               : out    vl_logic;
        D               : in     vl_logic;
        E               : in     vl_logic;
        PAD             : inout  vl_logic
    );
end BIBUF_F_6;
