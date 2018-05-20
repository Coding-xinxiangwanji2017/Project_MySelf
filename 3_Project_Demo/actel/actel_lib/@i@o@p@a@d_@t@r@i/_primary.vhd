library verilog;
use verilog.vl_types.all;
entity IOPAD_TRI is
    port(
        PAD             : out    vl_logic;
        D               : in     vl_logic;
        E               : in     vl_logic
    );
end IOPAD_TRI;
