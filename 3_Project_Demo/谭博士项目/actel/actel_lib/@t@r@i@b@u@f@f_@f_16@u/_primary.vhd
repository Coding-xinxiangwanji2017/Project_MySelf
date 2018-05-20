library verilog;
use verilog.vl_types.all;
entity TRIBUFF_F_16U is
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic;
        E               : in     vl_logic
    );
end TRIBUFF_F_16U;
