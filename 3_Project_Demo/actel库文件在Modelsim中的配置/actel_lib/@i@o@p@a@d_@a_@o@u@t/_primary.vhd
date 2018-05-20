library verilog;
use verilog.vl_types.all;
entity IOPAD_A_OUT is
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic
    );
end IOPAD_A_OUT;
