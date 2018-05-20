library verilog;
use verilog.vl_types.all;
entity IOIN_IB is
    port(
        YIN             : in     vl_logic;
        E               : in     vl_logic;
        Y               : out    vl_logic
    );
end IOIN_IB;
