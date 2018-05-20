library verilog;
use verilog.vl_types.all;
entity TRIBUFF_S_8 is
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic;
        E               : in     vl_logic
    );
end TRIBUFF_S_8;
