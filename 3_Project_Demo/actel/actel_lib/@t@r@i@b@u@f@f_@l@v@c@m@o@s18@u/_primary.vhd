library verilog;
use verilog.vl_types.all;
entity TRIBUFF_LVCMOS18U is
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic;
        E               : in     vl_logic
    );
end TRIBUFF_LVCMOS18U;
